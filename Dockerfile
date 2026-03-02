FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update and install required packages
RUN apt update && apt upgrade -y && \
    apt install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    gnupg \
    nginx \
    mariadb-server \
    redis-server \
    php8.1 \
    php8.1-cli \
    php8.1-fpm \
    php8.1-mysql \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-bcmath \
    php8.1-xml \
    php8.1-curl \
    php8.1-zip \
    php8.1-intl \
    composer \
    && apt clean

WORKDIR /var/www/pterodactyl

EXPOSE 80 443

CMD ["/bin/bash"]
