FROM debian:buster-slim
MAINTAINER n3k1 <docker@n3k1.de>
LABEL maintainer="n3k1 <docker@n3k1.de>"

EXPOSE 64738/tcp 6502/tcp 64738/udp
ENV VERSION="1.3.3"
ENV LDAP="False"

WORKDIR /home

ADD https://github.com/mumble-voip/mumble/releases/download/${VERSION}/murmur-static_x86-${VERSION}.tar.bz2 /home
RUN apt update; apt install -y zeroc-ice-slice zeroc-ice-compilers python3 python3-zeroc-ice python3-ldap python3-daemon
RUN addgroup --gid 64738 murmur && \
	adduser --uid 64738 --ingroup murmur --disabled-password --gecos "" murmur && \
	tar xfvj /home/murmur-static_x86-${VERSION}.tar.bz2 -x && \
	rm /home/murmur-static_x86-${VERSION}.tar.bz2 && \
	mv /home/murmur-static_x86-${VERSION}/* /home/murmur
COPY /entrypoint /entrypoint
COPY /ldapmur.py /home/murmur/ldapmur.py
COPY /ldapmur.ini /home/murmur/ldapmur.ini
RUN chown -R murmur /home/murmur /entrypoint; chmod 0775 /home/murmur/ldapmur.py /home/murmur/ldapmur.ini /entrypoint

WORKDIR /home/murmur
VOLUME /home/murmur

USER murmur

CMD /entrypoint

