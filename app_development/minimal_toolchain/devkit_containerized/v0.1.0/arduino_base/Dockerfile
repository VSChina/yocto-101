FROM ubuntu:18.04

ARG arduino_cli_url=https://github.com/arduino/arduino-cli/releases/download/0.3.6-alpha.preview/arduino-cli-0.3.6-alpha.preview-linux64.tar.bz2
ARG go_url=https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz

RUN mkdir /work
WORKDIR /work

COPY MyFirstSketch.ino /work/

# Install arduino-cli and go compiler
RUN apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates wget git unzip && \
	wget ${arduino_cli_url} && \
	tar -jxvf arduino-cli-* && \
	rm -r arduino-cli-*.tar.bz2 && \
	mv arduino-cli-* arduino-cli && \
	mv arduino-cli /usr/bin && \
	wget ${go_url} && \
	tar -C /usr/local -xzf go*.tar.gz && \	
	rm go*.tar.gz && \
    # apt-get remove -y ca-certificates wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt autoremove -y

ENV PATH=$PATH:/usr/local/go/bin

# Download arduino-cli sdk
RUN go get -u github.com/arduino/arduino-cli

# Use root as the user
USER root
ENV USER root

# Add aditional Url to download AZ3166 package
COPY arduino-cli.yaml /work/

COPY start.sh /usr/bin/start.sh

