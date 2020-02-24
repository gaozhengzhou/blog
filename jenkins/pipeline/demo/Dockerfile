FROM anapsix/alpine-java:8_jdk
RUN set -eux; \
        apk add -U tzdata; \
        cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime;
ADD demo.jar /
ENV JAVA_OPTS=""
CMD [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /demo.jar --spring.profiles.active=production" ]
