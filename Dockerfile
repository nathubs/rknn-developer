# 使用多架构基础镜像
FROM ubuntu:20.04

# 预先设置时区，避免在安装tzdata时出现交互式提示
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置非交互式前端
ENV DEBIAN_FRONTEND=noninteractive

# 备份原始sources.list
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 替换为正确的源配置
RUN echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse" >> /etc/apt/sources.list

# 安装RK3566交叉编译工具链和基础工具
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    wget \
    tar \
    software-properties-common

# 安装aarch64交叉编译工具
RUN apt-get update && apt-get install -y \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu

# 添加arm64架构并安装arm64库
RUN dpkg --add-architecture arm64 && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports focal main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y libasound2-dev:arm64 libpulse-dev:arm64 libopus-dev:arm64

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
ENV PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig  

# 设置交叉编译环境
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-

# 验证Go安装
RUN go version