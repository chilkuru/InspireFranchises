# ─────────────────────────────────────────────────────────────────────────────
# TestLink 1.9.20  on  PHP 8.1 + Apache
# ─────────────────────────────────────────────────────────────────────────────
FROM php:7.4-apache

# ── System deps + PHP extensions required by TestLink ─────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
        unzip \
        curl \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libzip-dev \
        libxml2-dev \
        libldap2-dev \
        libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        gd \
        pdo \
        pdo_mysql \
        mysqli \
        mbstring \
        zip \
        xml \
        ldap \
        gettext \
    && rm -rf /var/lib/apt/lists/*

# ── Download TestLink 1.9.20 source ───────────────────────────────────────────
ARG TL_VERSION=1.9.20
ARG TL_URL=https://github.com/TestLinkOpenSourceTRMS/testlink-code/archive/refs/tags/${TL_VERSION}.zip

WORKDIR /tmp

RUN curl -fsSL "${TL_URL}" -o testlink.zip \
    && unzip -q testlink.zip \
    && rm -rf /var/www/html \
    && mv testlink-code-${TL_VERSION} /var/www/html \
    && rm testlink.zip

# ── Upload / log directories expected by TestLink ─────────────────────────────
RUN mkdir -p /var/testlink/logs \
             /var/testlink/upload_area \
    && chown -R www-data:www-data /var/www/html /var/testlink

# ── Apache document root ───────────────────────────────────────────────────────
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html|g' \
        /etc/apache2/sites-enabled/000-default.conf \
    && a2enmod rewrite

# ── PHP settings suitable for TestLink ────────────────────────────────────────
RUN { \
    echo "upload_max_filesize = 20M"; \
    echo "post_max_size = 20M"; \
    echo "memory_limit = 256M"; \
    echo "max_execution_time = 120"; \
    echo "session.save_path = /tmp"; \
} > /usr/local/etc/php/conf.d/testlink.ini

EXPOSE 80
