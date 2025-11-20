# 使用多架构基础镜像
FROM ubuntu:20.04

# 预先设置时区，避免在安装tzdata时出现交互式提示
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置非交互式前端
ENV DEBIAN_FRONTEND=noninteractive

# 安装RK3566交叉编译工具链
RUN apt-get update && apt-get install -y \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    build-essential \
    git \
    cmake

# 设置交叉编译环境
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-
