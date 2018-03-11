FROM       ubuntu:16.04
MAINTAINER Royi Reshef "https://github.com/royi1000"

RUN apt-get update
RUN apt-get install -y openssh-server git curl samba apache2 apache2-utils
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash 
RUN apt-get update
RUN apt-get install -y nodejs
RUN mkdir /var/run/sshd && mkdir /mount && chown nobody:nogroup /mount

ENV PASSWORD root
RUN echo "root:$PASSWORD" |chpasswd
#RUN echo -e "$PASSWORD\n$PASSWORD\n" | smbpasswd -s

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN a2enmod dav dav_fs
RUN a2dissite 000-default
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

RUN mkdir -p /var/lock/apache2; chown www-data /var/lock/apache2
RUN mkdir -p /webdav; chown www-data /webdav

RUN git clone https://github.com/billchurch/WebSSH2.git
ADD ./server.crt /etc/ssl/certs
ADD ./server.key /etc/ssl/private

ADD webdav.conf /etc/apache2/sites-available/webdav.conf
RUN a2ensite webdav && a2enmod ssl && a2ensite default-ssl

RUN cd /WebSSH2 && npm install --production
RUN cd / && npm install -g droppy && mkdir -p /droppy/config
ADD ./*.sh /
ADD ./config.json /WebSSH2/
ADD ./droppy_config.json /droppy/config/config.json
ADD ./smb.conf /etc/samba/smb.conf

EXPOSE 8080
EXPOSE 22
EXPOSE 2222
EXPOSE 8989
EXPOSE 443
EXPOSE 139
EXPOSE 445

CMD    ["/bin/sh", "-c", "/start.sh"]
