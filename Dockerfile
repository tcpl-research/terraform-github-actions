FROM alpine:3 

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates git openssh"]

RUN ["bin/sh", "-c", "mkdir -p /src"]

COPY ["src", "/src/"]

ENTRYPOINT ["/src/entrypoint.sh"]
