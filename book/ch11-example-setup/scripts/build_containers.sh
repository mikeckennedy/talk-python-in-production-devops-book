echo "Building containers"

# ################ Set up environment for shared vars #####################
set -eu pipefail # Enable strict error handling
# Script's working directory
# echo "BASE SOURCE: ${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo "SCRIPT_DIR ${SCRIPT_DIR}"
RELATIVE_PATH="${SCRIPT_DIR}/../../.."
# echo "RELATIVE_PATH ${RELATIVE_PATH}"
# Repo cloned here
REPO_PATH=$(realpath "$RELATIVE_PATH")
# echo "REPO_PATH ${REPO_PATH}"
# ############### END Set up environment ##################################

echo "Building base images"
cd ${REPO_PATH}/book/ch11-example-setup/containers/base-images
docker compose build linux-example-base
docker compose build python-example-base
echo "base images done"

echo "Build core app"
cd ${REPO_PATH}/book/ch11-example-setup/containers/core-app
docker compose build
echo "core app done"

echo "Building nginx server"
cd ${REPO_PATH}/book/ch11-example-setup/containers/web-servers
docker compose build
echo "nginx server done"


echo "Restart containers (if needed)"
cd ${REPO_PATH}/book/ch11-example-setup/containers/core-app
docker compose up -d --remove-orphans
cd ${REPO_PATH}/book/ch11-example-setup/containers/web-servers
docker compose up -d nginx --remove-orphans
echo "restarts done."
