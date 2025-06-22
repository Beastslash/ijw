FROM ubuntu:24.04

RUN apt update && apt install -y
RUN apt install gh
RUN apt install -y ca-certificates
RUN apt install -y unzip
RUN apt install -y libdbus-1-dev pkg-config
RUN apt update
ENV PATH="$PATH:/root/.pesde/bin"

# Install Node
ENV NODE_VERSION=16.13.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version