FROM debian:jessie
MAINTAINER Michael Ledin "mledin89@gmail.com"

RUN apt-get update &&\
        DEBIAN_FRONTEND=noninteractive apt-get -y install gnupg-curl &&\
        apt-key adv --fetch-keys "https://geti2p.net/_static/i2p-debian-repo.key.asc" &&\
        echo 'deb http://deb.i2p2.de/ jessie main\n\
            deb-src http://deb.i2p2.de/ jessie main' >> /etc/apt/sources.list.d/i2p.list &&\
        apt-get update &&\
        DEBIAN_FRONTEND=noninteractive apt-get -y install i2p i2p-keyring &&\
        rm -rf /var/lib/apt/lists/* &&\
        apt-get remove -y gnupg-curl &&\
        apt-get autoremove -y &&\
        apt-get clean &&\
        sed -i s/RUN_DAEMON=\"false\"/RUN_DAEMON=\"true\"/ /etc/default/i2p &&\
        /etc/init.d/i2p start &&\
        echo "i2cp.tcp.bindAllInterfaces=true" >> /var/lib/i2p/i2p-config/router.config &&\
        sed -i s/::1,127.0.0.1/0.0.0.0/ /var/lib/i2p/i2p-config/clients.config

VOLUME ["/var/lib/i2p/i2p-config"]

EXPOSE 7657 4444 4445

CMD /etc/init.d/i2p start && tail -f /var/log/i2p/wrapper.log
