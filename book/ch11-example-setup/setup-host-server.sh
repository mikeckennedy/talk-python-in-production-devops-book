# This script is meant as a guide to setup a new machine to run our docker cluster.
# RUN THIS ONLY ONCE.


############################################################
# This script is not meant to be run directly.
# Take it piece by piece and execute the blocks
echo ""
echo "Error: This script is not meant to be run directly."
echo "Take it piece by piece and execute the blocks."
echo "For example, there are sections where you need to fill out info"
echo "like your name and email before running that block of code."
echo "Plus running each block will give you a chance to understand it better."
echo ""
exit 0


############################################################
# Setup the server itself including ohmyzsh
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

# TODO: Enter your name and email for git in the placeholders.
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

# Change Docker data file to mounted volume if wanted, this will allow you to mount a
# separate volume much bigger than your hard drive and keep the docker working volumes and images
# there. This is especially useful if you have very large DB files in a persistent Docker volume.
# See https://stackoverflow.com/questions/36014554/how-to-change-the-default-location-for-docker-create-volume-command
# Before you run anything related to Docker, be sure to change the docker working data to
# the mounted volume if you intend to do that.

# Test Docker by running hello-world:
docker run hello-world




############################################################
# Create the persistent docker elements (network, disks, etc)
docker network create -d bridge cluster-network --subnet=174.44.0.0/16
# Example: "docker volume create NAME" if you need a persistent volume,
# our example doesn't use one.



############################################################
# Set up the infrastructure (this project) and docker files

# Download the infrastructure files (this repo)
# TODO: MAKE SURE TO USE YOUR OWN FORK OF THE REPO BELOW.
# You won't be able to test updates if you use the base one since you can't change it on demand.
git clone https://github.com/mikeckennedy/talk-python-in-production-devops-book /cluster-src/
cd /cluster-src/

# Copy the app src
# TODO: MAKE SURE TO USE YOUR OWN FORK OF THE REPO https://github.com/talkpython/htmx-python-course BELOW.
# You won't be able to test updates if you use the base one since you can't change it on demand.
cd /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src
git clone https://github.com/talkpython/htmx-python-course


# ###############
# Make scripts runnable
chmod +x /cluster-src/book/ch11-example-setup/scripts/*.sh


############################################################
# Make the static folders for data exchange between the
# containers, git updates, and data exports
mkdir -p /cluster-data/
cd /cluster-data/

# The following folders are assuming the production settings
# from the ./ch11-example-setup/containers/web-servers/dot-env-template.sh file
# You MUST create a .env file in that folder and copy the values from
# dot-env-template.sh with the proper adjustments before anything will build / work.

# Make the data folders for exchange:
mkdir -p /cluster-data/nginx/static
mkdir -p /cluster-data/nginx/logs
mkdir -p /cluster-data/nginx/sites-enabled
mkdir -p /cluster-data/nginx/usr-share-nginx
mkdir -p /cluster-data/nginx/letsencrypt-etc
mkdir -p /cluster-data/nginx/letsencrypt-www
mkdir -p /cluster-data/nginx/certbot/www

mkdir -p /cluster-data/logs/video-collector

# Copy the NGINX config files into NGINX's config folder we mapped into Docker:
cp /cluster-src/book/ch11-example-setup/containers/web-servers/nginx-base-configs/video-collector.nginx /cluster-data/nginx/sites-enabled
# Copy the static files from our example app into the static folder we're mapping to NGINX (in the compose.yaml later)
cp -r /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector/static /cluster-data/nginx/static/video-collector

# Add to /etc/hosts on the host machine (so we can test requests against the domain)
127.0.0.1 video-collector-test.com

############################################################
# Run docker compose cluster as systemd service
cd /cluster-src/book/ch11-example-setup/containers/core-app
curl -fsSL https://techoverflow.net/scripts/create-docker-compose-service.sh | sudo bash /dev/stdin

cd /cluster-src/book/ch11-example-setup/containers/web-servers
curl -fsSL https://techoverflow.net/scripts/create-docker-compose-service.sh | sudo bash /dev/stdin
