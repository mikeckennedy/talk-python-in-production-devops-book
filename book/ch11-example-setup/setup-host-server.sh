# This script is meant as a guide to setup a new machine to run our docker cluster.

############################################################
# Setup the server itself
apt-get update
apt-get upgrade -y
apt-get install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

apt install btop -y
apt install ca-certificates -y
apt install curl wget -y
apt install git -y

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=720000'

git config --global user.email "YOUR_EMAIL"
git config --global user.name "YOUR_NAME"





############################################################
# Setup docker on the server.

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# To install the latest version of Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Change Docker data file to mounted volume if wanted:
# see https://stackoverflow.com/questions/36014554/how-to-change-the-default-location-for-docker-create-volume-command
# Before you set up anything, be sure to change the docker working data to the mounted volume.

# Test Docker
docker run hello-world




############################################################
# Create the persistent docker elements (network, disks, etc)
docker network create -d bridge cluster-network --subnet=174.44.0.0/16

# TODO: docker volume create NAME



############################################################
# Set up the infrastructure and docker files

# Copy the infrastructure files (this repo)

# TODO: MAKE SURE TO USE YOUR OWN FORK HERE.
# You won't be able to test updates if you use the base one since
# you can't change it on demand.
git clone https://github.com/mikeckennedy/talk-python-in-production-devops-book /cluster-src/
cd /cluster-src/

