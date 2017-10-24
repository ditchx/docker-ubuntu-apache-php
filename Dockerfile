FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
	apache2 \
	software-properties-common \
	supervisor \
 	wget \
    curl \
    git \
    zip \
    unzip \
    libxml2-dev \
    build-essential \
    libssl-dev \
    nano \
    openssh-client \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    language-pack-en-base \
    ansible \
    apt-transport-https \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y --no-install-recommends \
		libapache2-mod-php7.1 \
		php7.1 \
	    php7.1-cgi \
		php7.1-cli \
		php7.1-curl \
	    php7.1-common \
		php7.1-dev \
	    php7.1-fpm \
		php7.1-gd \
	    php7.1-gmp \
		php7.1-imap \
	    php7.1-intl \
	    php7.1-json \
	    php7.1-ldap \
		php7.1-mbstring \
		php7.1-mcrypt \
		php7.1-mysql \
	    php7.1-odbc \
	    php7.1-opcache \
		php7.1-pgsql \
		php7.1-pspell \
	    php7.1-readline \
	    php7.1-sqlite3 \
	    php7.1-tidy \
		php7.1-xml \
		php7.1-xmlrpc \
	    php7.1-xsl \
	    php7.1-zip \
		php-apcu \
		php-memcached \
		php-pear \
		php-redis \
	    php-xdebug \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*	

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash && \
    export NVM_DIR="/root/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 6.11 lts && \
    npm i -g npm

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer creates=/usr/local/bin/composer
RUN php /usr/local/bin/composer global require "fxp/composer-asset-plugin:~1.1.1"
RUN php /usr/local/bin/composer global require "hirak/prestissimo:^0.3"

RUN a2enmod rewrite

RUN useradd -ms /bin/bash dev && usermod -aG sudo dev

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY run.sh /run.sh
RUN chmod 755 /run.sh
EXPOSE 80 
CMD ["/run.sh"]