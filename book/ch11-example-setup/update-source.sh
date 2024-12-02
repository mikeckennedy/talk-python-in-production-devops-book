echo "Updating infrastructure code"
cd /cluster-src/book/
git pull

echo "Updating HTMX sample app code"
cd /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src/htmx-python-course
git pull

echo "Updating static files"
cp -r /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector/static /cluster-data/nginx/static/video-collector
