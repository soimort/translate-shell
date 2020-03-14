FROM alpine:latest
MAINTAINER soimort

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories 

RUN apk add bash gawk curl mplayer fribidi less hunspell wget \
    #  bsdmainutils 
    && wget git.io/trans \
    && chmod +x ./trans \ 
    && mv ./trans /usr/local/bin/
ENTRYPOINT ["trans"]
CMD ["--help"]
