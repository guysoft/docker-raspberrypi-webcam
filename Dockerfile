FROM arm32v6/alpine:edge
EXPOSE 8081
EXPOSE 8080
ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}

ENV TZ="Asia/Jerusalem"

RUN apk update && \
    apk upgrade && \
    apk add -U -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
       bash \
       sudo \
       tzdata \
       motion \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && rm /var/cache/apk/*

#========================================
# Add normal user with passwordless sudo
#========================================
# add new user
ARG USER=seluser
ENV HOME /home/$USER
RUN adduser -D $USER \
        && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
        && chmod 0440 /etc/sudoers.d/$USER

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER $USER
WORKDIR $HOME
