#!/usr/bin/env bash

echo "Installing hyperledger prerequisites..."
echo

echo "Installing docker Community Edition..."
echo
sudo apt install -y apt-transport-https ca-certificates curl python \
     software-properties-common build-essential libssl-dev make python-pip

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo rm -f /etc/apt/sources.list.d/docker-ce.list 2> /dev/null
sudo rm -f /etc/apt/sources.list.d/docker-ce.list.save 2> /dev/null
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker ${USER}

echo "Installing docker compose..."
echo
VER=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
sudo curl -L https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# node
echo "Installing NVM + Node.js + NPM..."
echo
VER=$(curl --silent "https://api.github.com/repos/creationix/nvm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -o- https://raw.githubusercontent.com/creationix/nvm/$VER/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install --lts
npm install -g npm

# golang
echo
echo "Installing golang..."
echo
sudo rm -rf /usr/local/go 2> /dev/null
GOVERSION=$(curl -fsSL --silent "https://golang.org/dl" | grep -E -o 'dl.google.com/go/go.+windows' | head -1 | grep -E -o '[0-9]+\.[0-9]+.[^.windows]')
wget https://dl.google.com/go/go$GOVERSION.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go$GOVERSION.linux-amd64.tar.gz
rm go$GOVERSION.linux-amd64.tar.gz

# .bashrc content
echo >> ~/.bashrc
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export PATH="$PATH:$GOROOT/bin"' >> ~/.bashrc
echo 'export GOPATH="$HOME/golib"' >> ~/.bashrc
echo 'export PATH="$PATH:$GOPATH/bin"' >> ~/.bashrc
echo 'export GOPATH="$GOPATH:$HOME/Code/go"' >> ~/.bashrc
echo 'export PATH="$HOME/fabric-samples/bin:$PATH"' >> ~/.bashrc

source ~/.bashrc

mkdir ~/Code/go/src/github.com/$USER -p
mkdir ~/Code/go/bin
mkdir ~/Code/go/pkg
mkdir ~/golib

go get -u github.com/nsf/gocode
go get -u github.com/derekparker/delve/cmd/dlv
go get -u github.com/uudashr/gopkgs
go get -u github.com/sqs/goreturns
go get -u golang.org/x/tools

# docker CE needs a restart to work
echo
echo Rebooting in 10 seconds, press CTRL+C to cancel...
sleep 10
sudo reboot

# fabric examples
# curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash
