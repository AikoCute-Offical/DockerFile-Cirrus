# Import Ubuntu 18.04 Image
FROM ubuntu:18.04

# ENV
ENV DEBIAN_FRONTEND noninteractive
ENV USER AikoCute-Offical
ENV HOSTNAME AikoCute-Offical
ENV USE_CCACHE 1
ENV LC_ALL C
ENV CCACHE_COMPRESS 1
ENV CCACHE_SIZE 50G
ENV CCACHE_DIR /tmp/ccache
ENV CCACHE_EXEC /usr/bin/ccache 
ENV USE_CCACHE true

# Install dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install bison repo libssl-dev build-essential curl flex git gnupg gperf liblz4-tool libncurses5-dev libsdl1.2-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev build-essential kernel-package libncurses5-dev bzip2 git python sudo gcc g++ openssh-server tar gzip ca-certificates -y

RUN apt-get purge openjdk-8-jdk openjdk-8-jre openjdk-11-jdk openjdk-11-jre -y

RUN apt-get install openjdk-8-jdk openjdk-8-jre -y

RUN set -x \
    && apt-get -yqq update \
    && apt-get install --no-install-recommends -yqq \
        adb autoconf automake axel bc bison build-essential ccache clang cmake curl expat flex g++ g++-multilib gawk gcc gcc-multilib git git-core git-lfs gnupg gperf htop imagemagick kmod lib32ncurses5-dev lib32readline-dev lib32z1-dev libc6-dev libcap-dev libexpat1-dev libgmp-dev liblz4-* liblz4-tool liblzma* libmpc-dev libmpfr-dev libncurses5-dev libsdl1.2-dev libssl-dev libtinfo5 libtool libwxgtk3.0-dev libxml-simple-perl libxml2 libxml2-utils lzip lzma* lzop maven ncftp ncurses-dev patch patchelf pkg-config pngcrush pngquant python python-all-dev re2c rsync schedtool squashfs-tools subversion sudo texinfo unzip w3m xsltproc zip zlib1g-dev zram-config && \
    apt-get clean

RUN apt-get update && apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8

# Install repo
RUN set -x \
    && curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo \
    && chmod a+x /usr/local/bin/repo

RUN rm -rf /var/lib/apt/lists/*

# Link Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# Add User
# Why? Well for avoid something wrong
# I've seen some notes for not using root when build
RUN useradd -ms /bin/bash aiko
RUN echo "aiko ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER aiko
WORKDIR /home/aiko

# Git
RUN git config --global user.email "aikocute@icloud.com"
RUN git config --global user.name "AikoCute-Offical"
RUN git config --global color.ui false

# Work in the build directory, repo is expected to be init'd here
WORKDIR /src

# This is where the magic happens~
ENTRYPOINT ["/bin/bash"]