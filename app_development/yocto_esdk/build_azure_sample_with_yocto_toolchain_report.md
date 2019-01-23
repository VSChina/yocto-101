
# Build Azure Sample with Docker Container leveraging Yocto Toolchain

Tutorial: [Simple Azure IoT Application](https://github.com/VSChina/yocto-101/blob/master/esdk.md#simple-azure-iot-application)

1. Test on Desktop Computer(with cache)

    * Platform:  
        cndilin-719;  
        x64 PC, intel Xeon(R) CPU E5-1620 v3 @ 3.50GHz;  
        16GB

    * Time elapsed  
        11:14 - 11:30: total(16 min)

2. Test on Laptop (clean machine, No docker cache)

    * Platform:  
        Surface Book 2, cn-dilin-102;  
        intel(R) Core(TM) i7-8650U CPU @ 1.90GHz 2.11GHz;  
        16.0GB  

    * Time elapsed  
        11:17 - 11:21  yocto-ubuntu:base(4 min)  
        11:21 - 11:26 download toolchain(5 min)  
        11:26 - 11:37 download, compile and build libraries; build app(11 min)