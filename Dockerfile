FROM alpine:edge
MAINTAINER n3k1 <docker@n3k1.de>
LABEL maintainer="n3k1 <docker@n3k1.de>"

EXPOSE 64738/tcp 6502/tcp 64738/udp
ENV VERSION="1.3.3"

WORKDIR /home

ADD https://github.com/mumble-voip/mumble/releases/download/${VERSION}/murmur-static_x86-${VERSION}.tar.bz2 /home
RUN addgroup --gid 64738 murmur && \
	adduser --uid 64738 --ingroup murmur --disabled-password --gecos "" murmur && \
	tar xfvj /home/murmur-static_x86-${VERSION}.tar.bz2 -x && \
	rm /home/murmur-static_x86-${VERSION}.tar.bz2 && \
	mv /home/murmur-static_x86-${VERSION}/* /home/murmur && \
	chown -R murmur /home/murmur

WORKDIR /home/murmur
VOLUME /home/murmur

CMD /home/murmur/murmur.x86 -fg -v -ini /home/murmur/murmur.ini
