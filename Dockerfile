FROM ruby:2.2.5-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk --update -t add libressl grep sed bash keepalived && \
    rm -f /var/cache/apk/* /tmp/*

RUN gem install ovh-rest

COPY keepalived.conf /etc/keepalived/keepalived.conf
COPY assign_ip.rb /etc/keepalived/assign_ip.rb
COPY assign_ip_wrapper.sh /etc/keepalived/assign_ip_wrapper.sh
COPY start_keepalived.sh /usr/bin/start_keepalived.sh

RUN chmod +x /etc/keepalived/assign_ip_wrapper.sh
RUN chmod +x /usr/bin/start_keepalived.sh

ENTRYPOINT ["/usr/bin/start_keepalived.sh"]
