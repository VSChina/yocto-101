# devicedevex.azurecr.io/public/arduino-az3166:1.6.2
FROM devicedevex.azurecr.io/internal/arduino-base:0.1.1

ARG AZ3166_version=1.6.2

# Use root as the user
USER root
ENV USER root

# Add aditional Url to download AZ3166 package
COPY arduino-cli.yaml /
COPY install_az3166.sh /work

# Install AZ3166
RUN /work/install_az3166.sh ${AZ3166_version}

