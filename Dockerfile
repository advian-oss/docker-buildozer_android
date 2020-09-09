###############
# Common base #
###############
FROM kivy/buildozer as ndkinstall

ENV USER="user"
USER ${USER}

# Make sure we have all the build deps
RUN sudo apt-get update \
    && sudo apt-get install -y \
       build-essential \
       ccache \
       git \
       zlib1g-dev \
       python3 \
       python3-dev \
       libncurses5 \
       libstdc++6 \
       zlib1g \
       openjdk-8-jdk \
       unzip \
       ant \
       ccache \
       autoconf \
       libtool \
       libssl-dev \
       expect \
       android-sdk-platform-tools-common \
    && sudo apt-get autoremove -y \
    && sudo rm -rf /var/lib/apt/lists/* \
    && true

# Build the minimal app
COPY --chown=user:user minimalapp /minimalapp
WORKDIR /minimalapp
# First buildozer run via expect script for auto-accepting license
# buildozer may fail with NDK_MODULE_PATH error, if so we re-unpack NDK and repackage
RUN ./autobuild.sh || ( echo "Re-Unpacking NDK" && ./ndkunpack.sh && echo "Re-Building minimalapp" && buildozer -v android debug )

# Save the buildozer common files
VOLUME ["/home/${USER}/.buildozer"]

###########
# Hacking #
###########
FROM ndkinstall as devel_shell
RUN sudo apt-get update && sudo apt-get install -y zsh curl rsync \
    && sudo apt-get autoremove -y \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && echo "source /home/${USER}/.profile" >>/home/${USER}/.zshrc \
    && sudo mkdir -p /app \
    && sudo chown ${USER}:${USER} /app \
    && true
WORKDIR /app
ENTRYPOINT ["/bin/zsh", "-l"]
