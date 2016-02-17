FROM alpine:3.3
WORKDIR /app
ADD ./build/tcp-proxy /app

CMD ["/app/tcp-proxy"]
