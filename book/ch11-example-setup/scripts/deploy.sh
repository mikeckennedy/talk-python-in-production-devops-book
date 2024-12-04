# ################ Set up environment for shared vars #####################
set -euo pipefail # Enable strict error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # Script's working directory
RELATIVE_PATH="${SCRIPT_DIR}/../../.."
REPO_PATH=$(realpath "$RELATIVE_PATH") # Repo cloned here
# ############### END Set up environment ##################################


${REPO_PATH}/src/book/ch11-example-setup/scripts/update_images.sh
${REPO_PATH}/book/ch11-example-setup/scripts/update_source.sh
${REPO_PATH}/book/ch11-example-setup/scripts/build_containers.sh
