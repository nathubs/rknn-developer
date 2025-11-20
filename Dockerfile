# 使用多架构基础镜像
FROM ubuntu:20.04

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
