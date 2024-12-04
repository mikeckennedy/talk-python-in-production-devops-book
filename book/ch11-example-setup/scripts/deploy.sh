# ################ Set up environment for shared vars #####################
set -eu pipefail # Enable strict error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # Script's working directory
# echo "SCRIPT_DIR ${SCRIPT_DIR}"
RELATIVE_PATH="${SCRIPT_DIR}/../../.."
# echo "RELATIVE_PATH ${RELATIVE_PATH}"
REPO_PATH=$(realpath "$RELATIVE_PATH") # Repo cloned here
# echo "REPO_PATH ${REPO_PATH}"
# ############### END Set up environment ##################################


${REPO_PATH}/book/ch11-example-setup/scripts/update-images.sh
${REPO_PATH}/book/ch11-example-setup/scripts/update-source.sh
${REPO_PATH}/book/ch11-example-setup/scripts/build_containers.sh
