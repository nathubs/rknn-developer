# rknn-developer
RK系列的开发编译环境镜像

## 镜像使用方法
### 1. 拉取镜像
```
docker pull edenwong/rknn-developer:latest
```

### 2. 启动容器
```
docker run -it --name rknn-dev -v ./xiaozhi-go:/xiaozhi-go nathubs/rknn-developer:latest /bin/bash
```

### 3. 进入容器
```
docker exec -it rknn-dev /bin/bash
```

## 镜像特点
- 基于Ubuntu 20.04
- 内置RKNN Toolkit，支持RK356X RK3588
- 内置golang 1.24.2
- 内置cmake 3.18.4
- 内置gcc 9.3.0

### golang
```
export GOOS=linux
export GOARCH=arm64
export CGO_ENABLED=1
export CC=aarch64-linux-gnu-gcc  #
```




## feature
- 支持RK356X RK3588
- 支持golang 1.24.2
- 支持cmake 3.18.4
- 支持gcc 9.3.0


## 重新编译 sherpa-onnx 库为 ARM64 版本
```
# 安装交叉编译工具链（如果尚未安装）
sudo apt install gcc-aarch64-linux-gnu

# 克隆 sherpa-onnx
git clone https://github.com/k2-fsa/sherpa-onnx.git
cd sherpa-onnx

# 创建构建目录
mkdir build-arm64 && cd build-arm64

# 使用交叉编译工具链配置
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
  -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc \
  -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++

# 编译
make -j$(nproc)

# 将生成的库文件复制到部署目录
cp lib/libsherpa-onnx-c-api.so /path/to/deployment/
```

```
export CGO_ENABLED=1
export GOOS=linux
export GOARCH=arm64
export CC=/home/eden/src/RKNN/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc
export PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig # 告诉 pkg-config去哪里查找软件包的配置文件（.pc 文件）


# 常见问题及解决方法
1. 缺少opus依赖库,报错如下：
go build -o xiaozhi-client-rk3566 cmd/client/main.go
# command-line-arguments
/usr/local/go/pkg/tool/linux_amd64/link: running aarch64-linux-gnu-gcc failed: exit status 1
/usr/bin/aarch64-linux-gnu-gcc -Wl,--build-id=0x9883b802a9d4d3d5722252a0d96067ff1ed205fc -o $WORK/b001/exe/a.out -rdynamic -Wl,--compress-debug-sections=zlib /tmp/go-link-716979807/go.o /tmp/go-link-716979807/000000.o /tmp/go-link-716979807/000001.o /tmp/go-link-716979807/000002.o /tmp/go-link-716979807/000003.o /tmp/go-link-716979807/000004.o /tmp/go-link-716979807/000005.o /tmp/go-link-716979807/000006.o /tmp/go-link-716979807/000007.o /tmp/go-link-716979807/000008.o /tmp/go-link-716979807/000009.o /tmp/go-link-716979807/000010.o /tmp/go-link-716979807/000011.o /tmp/go-link-716979807/000012.o /tmp/go-link-716979807/000013.o /tmp/go-link-716979807/000014.o /tmp/go-link-716979807/000015.o /tmp/go-link-716979807/000016.o /tmp/go-link-716979807/000017.o /tmp/go-link-716979807/000018.o /tmp/go-link-716979807/000019.o /tmp/go-link-716979807/000020.o /tmp/go-link-716979807/000021.o /tmp/go-link-716979807/000022.o /tmp/go-link-716979807/000023.o /tmp/go-link-716979807/000024.o /tmp/go-link-716979807/000025.o /tmp/go-link-716979807/000026.o /tmp/go-link-716979807/000027.o /tmp/go-link-716979807/000028.o -O2 -g -L/usr/lib/aarch64-linux-gnu -lpulse-simple -lpulse -O2 -g -lresolv -O2 -g -L/root/go/pkg/mod/github.com/justa-cai/go-libopus@v0.0.0-20250601043848-aec438f1655f/opus -lopus -O2 -g -L/usr/lib/aarch64-linux-gnu -lasound -O2 -g -lpthread -O2 -g -L /root/go/pkg/mod/github.com/k2-fsa/sherpa-onnx-go-linux@v1.12.13/lib/aarch64-unknown-linux-gnu -lsherpa-onnx-c-api -lonnxruntime -Wl,-rpath,/root/go/pkg/mod/github.com/k2-fsa/sherpa-onnx-go-linux@v1.12.13/lib/aarch64-unknown-linux-gnu -no-pie
/usr/lib/gcc-cross/aarch64-linux-gnu/9/../../../../aarch64-linux-gnu/bin/ld: cannot find -lopus
collect2: error: ld returned 1 exit status

解决方法：
sudo apt-get install libopus-dev:arm64
