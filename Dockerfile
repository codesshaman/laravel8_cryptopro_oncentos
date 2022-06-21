FROM centos:centos7

# Передаём id пользователя в систему:

ENV USER_ID=1000

# Переключаюсь на суперпользователя:

USER root

# Устанавливаю весь необходимый софт:

RUN yum install -y boost-devel \
    php-devel lsb gcc-c++ wget \
    unzip sqlite-devel mc nano

# RUN apt update && \
#     apt install -y wget \
#     libboost-dev sqlite3 \
#     curl mc autoconf tar \
#     libxml2-dev nano gcc \
#     libsqlite3-dev sqlite3 \
#     make g++ patch g++-6 php-dev

# Настраиваю systemd

# RUN find /etc/systemd/system \
#          /lib/systemd/system \
#          -path '*.wants/*' \
#          -not -name '*journald*' \
#          -not -name '*systemd-tmpfiles*' \
#          -not -name '*systemd-user-sessions*' \
#          -exec rm \{} \;

# Устанавливаю рабочий каталог и копирую все нужные файлы:

WORKDIR /tmp

COPY ./sources .

# Создаю пользователя с тем же UID, что и в системе:

RUN groupadd user && useradd --create-home user -g user && \
    sed -i "s/user:x:1000:1000/user:x:${USER_ID}:${USER_ID}/g" /etc/passwd

# Устанавливаю КриптоПРО:

RUN cd /tmp/linux-amd64_rpm && chmod +x install.sh && ./install.sh && \
    dpkg -i lsb-cprocsp-devel-5.0.12500-6.noarch.rpm && cd /tmp/cades_linux && \
    dpkg -i cprocsp-pki-phpcades-64-2.0.14589-1.amd64.rpm && \
    dpkg -i cprocsp-pki-phpcades-64-2.0.14589-1.amd64.rpm && \
    cp /tmp/php7_sources/php-7.4.30.tar.gz /opt && cd /opt && \
    tar -xvzf php-7.4.30.tar.gz && mv php-7.2.24 php && \
    rm /opt/php-7.4.30.tar.gz && cd /opt/php/ && ./configure --prefix=/opt/php --enable-fpm && \
    rm /opt/cprocsp/src/phpcades/Makefile.unix && \
    cp /tmp/Makefile.unix /opt/cprocsp/src/phpcades/ && \
    # update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 10 && \
    cp /tmp/php7_support.patch/php7_support.patch /opt/cprocsp/src/phpcades && \
    cd /opt/cprocsp/src/phpcades && patch -p0 < ./php7_support.patch && \
    eval `/opt/cprocsp/src/doxygen/CSP/../setenv.sh --64` && make -f Makefile.unix && \
    cp /opt/cprocsp/src/phpcades/libphpcades.so $(php -i | grep 'extension_dir => ' | awk '{print $3}')/phpcades.so && \
    ln -s /opt/cprocsp/src/phpcades/libphpcades.so $(php -i | grep 'extension_dir => ' | awk '{print $3}')/libcppcades.so && \
    echo 'extension=phpcades.so' >> /etc/php/7.4/cli/php.ini && cd /tmp/php7_sources && \
    echo 'error_log=/var/log/phpfpm_errors.log' >> /etc/php/7.4/cli/php.ini && \
    # dpkg -i libpq5_14.4-1.pgdg18.04+1_amd64.rpm && dpkg -i php7.2-pgsql_7.2.24-0ubuntu0.18.04.12_amd64.rpm && \
    # cd /tmp/php7_fpm && dpkg -i libapparmor1_2.12-4ubuntu5_amd64.rpm && dpkg -i php7.2-common_7.2.3-1ubuntu1_amd64.rpm && \
    # dpkg -i php7.2-fpm_7.2.3-1ubuntu1_amd64.rpm && dpkg -i php-fpm_7.2+60ubuntu1_all.rpm && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && service php7.4-fpm start

# Переключаюсь на созданного пользователя и открываю рабочий порт:

USER user

EXPOSE 8888

# CMD ["php-fpm"]