FROM ubuntu:20.04

ENV TIME_ZONE=Etc/GMT
ENV DEBIAN_FRONTEND noninteractive

RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && printf $TIME_ZONE > /etc/timezone && \
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections && \
    apt-get update && apt-get install -y iproute2 supervisor apt-utils curl && \
    curl -s https://packagecloud.io/install/repositories/Ananda/release/script.deb.sh | bash && \
    apt-get update && apt-get install -y sdwan-client-service && \
    mkdir -p /var/log/supervisor

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

