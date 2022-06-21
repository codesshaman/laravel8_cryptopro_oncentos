FROM centos:centos7

# Передаём id пользователя в систему:

ENV USER_ID=1000

# Переключаюсь на суперпользователя:

USER root

# Устанавливаю рабочий каталог и копирую все нужные файлы:

WORKDIR /tmp
COPY ./sources .

# Создаю пользователя с тем же UID, что и в системе:

RUN groupadd user && useradd --create-home user -g user && \
    sed -i "s/user:x:1000:1000/user:x:${USER_ID}:${USER_ID}/g" /etc/passwd && \
    cp systemctlpatch/systemctl.py /usr/bin/systemctl

# Устанавливаю весь необходимый софт:

RUN yum install -y boost-devel \
    lsb gcc-c++ wget automake \
    autoconf unzip sqlite-devel mc nano

# Устанавливаю php-devel 7.4.30:

RUN cd /tmp/php7_sources && rpm -i libedit-3.0-12.20121213cvs.el7.x86_64.rpm && \
    rpm -i php74-common-7.4.30-1.el7.ius.x86_64.rpm && rpm -i php74-cli-7.4.30-1.el7.ius.x86_64.rpm && \
    rpm -i libtool-2.4.2-22.el7_3.x86_64.rpm && rpm -i libsepol-devel-2.5-10.el7.x86_64.rpm && \
    rpm -i pcre-devel-8.32-17.el7.x86_64.rpm && rpm -i libselinux-devel-2.5-15.el7.x86_64.rpm && \
    rpm -i libkadm5-1.15.1-50.el7.x86_64.rpm && rpm -i libcom_err-devel-1.42.9-19.el7.x86_64.rpm && \
    rpm -i keyutils-libs-devel-1.5.8-3.el7.x86_64.rpm && rpm -i libverto-devel-0.2.5-4.el7.x86_64.rpm && \
    rpm -i krb5-devel-1.15.1-50.el7.x86_64.rpm && rpm -i crypto-policies-20170816-1.git2618a6c.el7.noarch.rpm && \
    rpm -i openssl11-libs-1.1.1k-3.el7.x86_64.rpm && rpm -i openssl11-devel-1.1.0i-1.el7.x86_64.rpm

#    rpm -i krb5-devel-1.15.1-50.el7.x86_64.rpm && \
     

# Устанавливаю libxml2-devel:

RUN cd /tmp/libxml2.0 && rpm -i xz-devel-5.2.2-1.el7.x86_64.rpm && \
    rpm -i zlib-devel-1.2.7-18.el7.x86_64.rpm && rpm -i libxml2-devel-2.9.1-6.el7.5.x86_64.rpm

# Устанавливаю КриптоПРО:

#RUN chmod a+x /usr/bin/systemctl && cd /tmp/linux-amd64_rpm && chmod +x install.sh && \
    #./install.sh && rpm -i  lsb-cprocsp-devel-5.0.12500-6.noarch.rpm
    #cd /tmp/cades_linux && rpm -i cprocsp-pki-phpcades-64-2.0.14589-1.amd64.rpm && \
    #cprocsp-pki-cades-64-2.0.14589-1.amd64.rpm && cd /tmp/libxml2.0 && cp /tmp/php7_sources/php-7.4.30.tar.gz /opt && \
    #cd /opt && tar -xvzf php-7.4.30.tar.gz && mv php-7.4.30 php && rm -y /opt/php-7.4.30.tar.gz && \
    #cd /opt/php/ && ./configure --prefix=/opt/php --enable-fpm && rm /opt/cprocsp/src/phpcades/Makefile.unix && \
    #cp /tmp/Makefile.unix /opt/cprocsp/src/phpcades/ && \
    ###### update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 10 && \
    #cp /tmp/php7_support.patch/php7_support.patch /opt/cprocsp/src/phpcades && \
    #cd /opt/cprocsp/src/phpcades && patch -p0 < ./php7_support.patch && \
    #eval `/opt/cprocsp/src/doxygen/CSP/../setenv.sh --64` && make -f Makefile.unix && \
    #cp /opt/cprocsp/src/phpcades/libphpcades.so $(php -i | grep 'extension_dir => ' | awk '{print $3}')/phpcades.so && \
    #ln -s /opt/cprocsp/src/phpcades/libphpcades.so $(php -i | grep 'extension_dir => ' | awk '{print $3}')/libcppcades.so && \
    #echo 'extension=phpcades.so' >> /etc/php/7.4/cli/php.ini && cd /tmp/php7_sources && \
    #echo 'error_log=/var/log/phpfpm_errors.log' >> /etc/php/7.4/cli/php.ini && \
    #rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && service php7.4-fpm start

# Переключаюсь на созданного пользователя и открываю рабочий порт:

USER user

EXPOSE 8888

# CMD ["php-fpm"]
