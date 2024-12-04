# ################ Set up environment for shared vars #####################
set -eu pipefail # Enable strict error handling
# Script's working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELATIVE_PATH="${SCRIPT_DIR}/../../.."
# Repo cloned here
REPO_PATH=$(realpath "$RELATIVE_PATH")
# ############### END Set up environment ##################################

echo "Updating infrastructure code"
cd ${REPO_PATH}/book/
git pull

echo "Updating HTMX sample app code"
cd ${REPO_PATH}/book/ch11-example-setup/containers/core-app/video-collector-docker/src/htmx-python-course
git pull

echo "Updating static files"
cp -r ${REPO_PATH}/book/ch11-example-setup/containers/core-app/video-collector-docker/src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector/static /cluster-data/nginx/static/video-collector
