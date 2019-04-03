FROM ubuntu:latest

RUN mkdir /work
WORKDIR /work

COPY MyFirstSketch.ino /work/

# Install arduino-cli and go compiler
RUN apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates wget git && \
	wget https://downloads.arduino.cc/arduino-cli/arduino-cli-latest-linux64.tar.bz2 && \
	tar -jxvf arduino-cli-latest-linux64.tar.bz2 && \
	rm -r arduino-cli-latest-linux64.tar.bz2 && \
	mv arduino-cli-0.3.6-alpha.preview-linux64 arduino-cli && \
	mv arduino-cli /usr/bin && \
	wget https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz && \
	tar -C /usr/local -xzf go1.12.1.linux-amd64.tar.gz && \	
	rm go1.12.1.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

# Add builder as user so we don't run everything as root
# RUN groupadd -g 70 builder && useradd -N -m -u 70 -g 70 builder
# USER builder
# ENV USER builder

# Download arduino-cli sdk
RUN go get -u github.com/arduino/arduino-cli

# Use root as the user
USER root
ENV USER root

# Add aditional Url to download AZ3166 package
COPY arduino-cli.yaml /work/
# RUN cp /work/arduino-cli.yaml /root/go/src/github.com/arduino/arduino-cli/configs/testdata/navigate/local/first/second/arduino-cli.yaml

RUN arduino-cli core update-index --debug

# arduino-cli core install encounter error here. Use `exit 0` to ignore the error. 
# The core-install action installs az3166 tools but fail to insall hardware.(path: /root/.arduino15/) 
RUN arduino-cli core install AZ3166:stm32f4@1.6.1 --debug; exit 0

# Download the hardware from url as a workaround
# [TODO] Just a workaround; Remove later
RUN wget https://azureboard.azureedge.net/prod/arduinopackage/AZ3166-1.6.1.zip && \
	apt-get install unzip
RUN unzip 'AZ3166-1.6.1.zip' -d /work; exit 0
RUN mkdir -p /root/.arduino15/packages/AZ3166/hardware/stm32f4/1.6.1/ && \
	cp -r AZ3166/* /root/.arduino15/packages/AZ3166/hardware/stm32f4/1.6.1/ && \
	cd /root/.arduino15/packages/AZ3166/hardware/stm32f4/1.6.1/ && \
	arduino-cli core list --debug && \
	arduino-cli board listall --debug

# Initialize sample code
RUN arduino-cli sketch new MyFirstSketch --debug && \
	cp /work/MyFirstSketch.ino /root/Arduino/MyFirstSketch/MyFirstSketch.ino && \
	arduino-cli compile --fqbn AZ3166:stm32f4:MXCHIP_AZ3166 /root/Arduino/MyFirstSketch --debug && \
	ls /root/Arduino/MyFirstSketch