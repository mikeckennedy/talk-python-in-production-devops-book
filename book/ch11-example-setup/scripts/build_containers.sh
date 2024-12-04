# ################ Set up environment for shared vars #####################
set -eu pipefail # Enable strict error handling
# Script's working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo "SCRIPT_DIR ${SCRIPT_DIR}"
RELATIVE_PATH="${SCRIPT_DIR}/../../.."
# echo "RELATIVE_PATH ${RELATIVE_PATH}"
# Repo cloned here
REPO_PATH=$(realpath "$RELATIVE_PATH")
# echo "REPO_PATH ${REPO_PATH}"
# ############### END Set up environment ##################################


cd ${REPO_PATH}/book/ch11-example-setup/containers/base-images
docker compose build
docker compose up -d


cd ${REPO_PATH}/book/ch11-example-setup/containers/core-app
docker compose build
docker compose up -d


cd ${REPO_PATH}/book/ch11-example-setup/containers/web-servers
docker compose build
docker compose up -d
