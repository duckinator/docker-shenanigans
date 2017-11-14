FROM alpine:3.6

RUN apk add --no-cache binutils bash shadow sudo ttf-dejavu hexchat

RUN useradd --create-home --shell /bin/bash alpine && \
      gpasswd -a alpine wheel && \
      echo "alpine:password" | chpasswd
USER alpine

CMD ["/bin/bash", "--login"]

