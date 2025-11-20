# 使用多架构基础镜像
FROM ubuntu:20.04

# 预先设置时区，避免在安装tzdata时出现交互式提示
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置非交互式前端
ENV DEBIAN_FRONTEND=noninteractive

# Fix repository issues for arm64 packages by adding needed sources
RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://ports.ubuntu.com/ubuntu-ports|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com/ubuntu|http://ports.ubuntu.com/ubuntu-ports|g' /etc/apt/sources.list && \
    dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get install -y gcc-aarch64-linux-gnu libasound2-dev:arm64 libpulse-dev:arm64

# 安装RK3566交叉编译工具链和Go 1.24.2
RUN apt-get install -y \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    build-essential \
    git \
    cmake \
    wget \
    tar    
# 下载并安装Go 1.24.2 for linux/amd64
RUN cd /tmp && \
    wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz    

# 设置Go环境变量
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV CC=aarch64-linux-gnu-gcc
ENV GOOS=linux
ENV GOARCH=arm64
ENV CGO_ENABLED=1   

# 设置交叉编译环境
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-

# 验证Go安装
RUN go version
