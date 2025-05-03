FROM ubuntu:24.04

# ------------------------------
# Labels
# ------------------------------
LABEL maintainer="Rudy Marchandise"
LABEL github="https://github.com/Ealenn/codespaces-typescript"

# ------------------------------
# Configuration
# ------------------------------
ARG USER
ENV USER=${USER:-ubuntu}
ENV HOME=/home/${USER}

ARG TZ
ENV TZ=${TZ:-Europe/Paris}

ARG LOCAL
ENV LOCAL=${LOCAL:-en_GB.UTF-8}

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------
# User Setup
# ------------------------------
RUN useradd -m -s /bin/zsh ${USER} && passwd -d ${USER} || true

# ------------------------------
# APT
# ------------------------------
RUN apt update && apt upgrade -y
RUN apt install gpg ubuntu-keyring apt-transport-https ca-certificates curl wget -y

# ------------------------------
# System
# ------------------------------
# TimeZone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

RUN apt install sudo screen tzdata locales lsb-release software-properties-common -y

# Essential
RUN apt install build-essential git vim jq fd-find -y

# Locale
RUN locale-gen $LOCAL && update-locale LANG=$LOCAL

# ZSH | OhMyZSH | Starship
RUN apt install zsh -y
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN curl -sS https://starship.rs/install.sh | sh -s - --yes
RUN rm /bin/sh && ln -s /bin/zsh /bin/sh

# ------------------------------
# Rust / Cargo
# ------------------------------
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# ------------------------------
# Go
# ------------------------------
ENV GOROOT=/usr/local/go
RUN ARCH=$(uname -m) && \
  case "$ARCH" in \
      x86_64) GO_ARCH="amd64" ;; \
      aarch64) GO_ARCH="arm64" ;; \
      armv7l) GO_ARCH="armv6l" ;; \
      ppc64le) GO_ARCH="ppc64le" ;; \
      s390x) GO_ARCH="s390x" ;; \
      *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
  esac && \
  GO_VERSION=$(curl -s "https://go.dev/dl/?mode=json" | jq -r '.[0].version') && \
  GO_URL="https://go.dev/dl/${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
  echo "Downloading Go ${GO_VERSION} for ${GO_ARCH} from ${GO_URL}" && \
  wget -q "${GO_URL}" -O go.tar.gz && \
  tar -C /usr/local -xzf go.tar.gz && \
  rm go.tar.gz

# ------------------------------
# Python
# ------------------------------
RUN apt install python3-dev python3-pip python3-setuptools -y
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# ------------------------------
# Docker
# ------------------------------
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update --allow-insecure-repositories
RUN apt install -y --allow-unauthenticated docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN usermod -aG docker ${USER}

# ------------------------------
# NodeJS - NVM
# ------------------------------
ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p $NVM_DIR
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
RUN source $NVM_DIR/nvm.sh \
    && nvm install --lts \
    && nvm alias default lts/* \
    && nvm use default

# ------------------------------
# NPM Global Packages
# ------------------------------
RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && npm install --global zx \
  && npm cache clean --force

# ------------------------------
# LSD
# ------------------------------
RUN apt install lsd -y

# ------------------------------
# TheFuck
# ------------------------------
RUN $HOME/.local/bin/uv tool install --python 3.11 thefuck --force

# ------------------------------
# NeoVIM
# ------------------------------
RUN apt install neovim -y
RUN git clone --dept 1 https://github.com/ecosse3/nvim.git $HOME/.config/nvim
RUN nvim --headless -c 'Lazy sync' -c 'qa'

# ------------------------------
# Clean
# ------------------------------
RUN apt autoremove \
  && apt autoclean \
  && apt clean

# ------------------------------
# User Setup
# ------------------------------
RUN sed -i "s#${USER}:x:.*:/bin/sh#${USER}:x:$(id -u ${USER}):$(id -g ${USER}):,,,:/home/${USER}:/bin/zsh#" /etc/passwd && \
  echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  echo "%sudo	ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  usermod --shell /bin/zsh ${USER} && \
  chsh -s /bin/zsh ${USER}

# ------------------------------
# User Home
# ------------------------------
COPY home/ /home/${USER}
RUN chown -R ${USER}:${USER} /home/${USER}

# ------------------------------
# Export
# ------------------------------
USER ${USER}
WORKDIR /home/${USER}
CMD ["zsh", "--login"]
