FROM ubuntu:bionic
MAINTAINER soimort
RUN apt update -y \ 
    && apt install -y gawk curl mplayer libfribidi-dev less hunspell bsdmainutils wget \
    && wget git.io/trans \
    && chmod +x ./trans \ 
    && mv ./trans /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/trans"]
CMD ["--help"]

