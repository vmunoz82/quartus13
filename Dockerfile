ARG INSTALL_DIR="/opt/altera/13.0sp1"
ARG QUARTUS_INSTALLER="QuartusSetupWeb-13.0.1.232.run"

FROM ubuntu:20.04 as installer
LABEL stage=builder
ARG QUARTUS_INSTALLER

ENV DEBIAN_FRONTEND=noninteractive

ADD ${QUARTUS_INSTALLER} /tmp

RUN apt update && \
    apt -y install --no-install-recommends \
        libc6-i386 && \
    rm -rf /var/lib/apt/lists/* && \
    /tmp/${QUARTUS_INSTALLER} --unattendedmodeui minimal --mode unattended --installdir /tmp/installer && \
    rm -rf /tmp/${QUARTUS_INSTALLER}

FROM ubuntu:20.04
ARG INSTALL_DIR

LABEL maintainer="Victor Muñoz <victor@2c-b.cl>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update && \
    apt -y install software-properties-common && \
    add-apt-repository -y ppa:linuxuprising/libpng12 && \
    apt -y update && \
    apt -y install --no-install-recommends \
        libpng12-0 \
        libfreetype6 libsm6 libxrender1 libfontconfig1 \
        libxext6 libxft2 libxss1 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=installer /tmp/installer ${INSTALL_DIR}

