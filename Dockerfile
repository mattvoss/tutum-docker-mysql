FROM ubuntu:precise
MAINTAINER Matthew Voss <voss.matthew@gmail.com>

#RUN echo "deb http://ubuntu.adiscon.com/v8-devel precise/" >> /etc/apt/sources.list.d/adiscon.list && \
#    echo "deb-src http://ubuntu.adiscon.com/v8-devel precise/" >> /etc/apt/sources.list.d/adiscon.list

RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -s /bin/true /sbin/initctl

# Install packages
RUN apt-get update
RUN apt-get -y upgrade
RUN ! DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server pwgen telnet
RUN echo "*.* @172.17.42.1:514" >> /etc/rsyslog.d/90-networking.conf

# Add image configuration and scripts
ADD start.sh /start.sh
ADD run.sh /run.sh
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD supervisord-rsyslogd.conf /etc/supervisor/conf.d/supervisord-rsyslogd.conf
ADD supervised_mysql /usr/sbin/supervised_mysql
RUN chmod +x /usr/sbin/supervised_mysql
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD import_sql.sh /import_sql.sh

RUN chmod 755 /*.sh

EXPOSE 3306
CMD ["/usr/bin/supervisord -n"]
