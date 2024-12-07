# Template file for nginx set up.
# Copy to local .env file with updated values

# Here are some options:

# Locally for development:
NGINX_STATIC=./cluster-data/nginx/static
NGINX_LOGS=./cluster-data/nginx/logs
NGINX_SITES_ENABLED=./nginx-base-configs
NGINX_LETS_ENCRYPT_ETC=./cluster-data/nginx/letsencrypt-etc
NGINX_LETSENCRYPT_WWW=./cluster-data/nginx/letsencrypt-www
CERTBOT_WWW=./cluster-data/nginx/certbot/www

# Some candidate production settings
NGINX_STATIC=/cluster-data/nginx/static
NGINX_LOGS=/cluster-data/nginx/logs
NGINX_SITES_ENABLED=./nginx-base-configs
NGINX_LETS_ENCRYPT_ETC=/cluster-data/nginx/letsencrypt-etc
NGINX_LETSENCRYPT_WWW=/cluster-data/nginx/letsencrypt-www
CERTBOT_WWW=/cluster-data/nginx/certbot/www
