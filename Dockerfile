FROM ubuntu:quantal
MAINTAINER Fernando Mayo <fernando@tutum.co>

RUN echo "deb http://ubuntu.adiscon.com/v8-devel quantal/" >> /etc/apt/sources.list.d/adiscon.list && \
    echo "deb-src http://ubuntu.adiscon.com/v8-devel quantal/" >> /etc/apt/sources.list.d/adiscon.list

RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -s /bin/true /sbin/initctl

# Install packages
RUN apt-get update
RUN apt-get -y upgrade
RUN ! DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server pwgen rsyslog telnet
RUN echo "*.* @172.17.42.1:514" >> /etc/rsyslog.d/90-networking.conf

# Add image configuration and scripts
ADD https://raw.github.com/tutumcloud/tutum-docker-mysql/master/start.sh /start.sh
ADD https://raw.github.com/tutumcloud/tutum-docker-mysql/master/run.sh /run.sh
ADD https://raw.github.com/tutumcloud/tutum-docker-mysql/master/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD https://raw.github.com/tutumcloud/tutum-docker-mysql/master/my.cnf /etc/mysql/conf.d/my.cnf
ADD https://raw.github.com/tutumcloud/tutum-docker-mysql/master/create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD https://raw.github.com/tutumcloud/tutum-docker-mysql/master/import_sql.sh /import_sql.sh
RUN chmod 755 /*.sh

EXPOSE 3306
CMD ["/run.sh"]
