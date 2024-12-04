# ################ Set up environment for shared vars #####################
set -euo pipefail # Enable strict error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # Script's working directory
RELATIVE_PATH="${SCRIPT_DIR}/../../.."
REPO_PATH=$(realpath "$RELATIVE_PATH") # Repo cloned here
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
