FROM openjdk:11
RUN mkdir -p /docker/brc
ADD https://github.com/Pugmatt/BedrockConnect/releases/latest/download/BedrockConnect-1.0-SNAPSHOT.jar /docker/brc
WORKDIR /docker/brc
EXPOSE 19132/udp
COPY entrypoint.sh /docker/brc

ENTRYPOINT [ "/bin/bash", "entrypoint.sh"]
