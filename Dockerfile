FROM alpine:3.3
WORKDIR /app
RUN apk add --update ca-certificates
ADD ./build/tcp-proxy /app

CMD ["/app/tcp-proxy"]
