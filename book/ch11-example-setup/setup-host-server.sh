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
apt install tree -y

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
# TODO: MAKE SURE TO USE YOUR OWN FORK OF THE REPO HERE.
# You won't be able to test updates if you use the base one since
# you can't change it on demand.
git clone https://github.com/mikeckennedy/talk-python-in-production-devops-book /cluster-src/
cd /cluster-src/




############################################################
# Make the static folders for data exchange between the
# containers and git updates and data exports
mkdir -p /cluster-data/
cd /cluster-data/

# The following folders are assuming the production settings
# from the ./ch11-example-setup/containers/web-servers/dot-env-template.sh file
# Remember you MUST create a .env file in that folder and copy the values from
# dot-env-template.sh with the proper edits before anything will build / work.

# Make the data folders for exchange:
mkdir -p /cluster-data/nginx/static
mkdir -p /cluster-data/nginx/logs
mkdir -p /cluster-data/nginx/sites-enabled
mkdir -p /cluster-data/nginx/usr-share-nginx
mkdir -p /cluster-data/nginx/letsencrypt-etc
mkdir -p /cluster-data/nginx/letsencrypt-www
mkdir -p /cluster-data/nginx/certbot/www

mkdir -p /cluster-data/logs/video-collector


cp /cluster-src/book/ch11-example-setup/containers/web-servers/nginx-base-configs/video-collector.nginx /cluster-data/nginx/sites-enabled
cp -r /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector/static /cluster-data/nginx/static/video-collector