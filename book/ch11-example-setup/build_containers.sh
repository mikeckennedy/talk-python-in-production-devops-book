cd /cluster-src/book/ch11-example-setup/containers/base-images
docker compose build
docker compose up -d


cd /cluster-src/book/ch11-example-setup/containers/core-app
docker compose build
docker compose up -d


cd /cluster-src/book/ch11-example-setup/containers/web-servers
docker compose build
docker compose up -d
