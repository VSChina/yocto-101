FROM dockcross/linux-arm64

COPY bme280 /work/BMEBuild/bme280

# download wiringPi
WORKDIR /work/BMEBuild/
RUN git clone git://git.drogon.net/wiringPi

# Replace "/proc/cpuinfo" with "/home/root/wiringPi/cpuinfo" in wiringPi.c 
# for a known bug(wiringPi does not support rpi3-64).
RUN sed -i "s#\/proc\/cpuinfo#\/home\/root\/wiringPi\/cpuinfo#g" /work/BMEBuild/wiringPi/wiringPi/wiringPi.c
RUN grep "\/cpuinfo" /work/BMEBuild/wiringPi/wiringPi/wiringPi.c -n

# Compile wiringPi with self-write CMakeLists.txt
COPY wiringpi-sdk/CMakeLists.txt /work/BMEBuild/wiringPi/wiringPi
WORKDIR /work/BMEBuild/wiringPi/wiringPi
RUN cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} . && \
    make

# Compile the bme280 app
WORKDIR /work/BMEBuild/bme280
RUN mkdir cmake && \
    cd cmake && \
    cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .. && \
    make && \
    ls -l .

RUN find / -name "bme_project*"