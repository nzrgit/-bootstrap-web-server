FROM public.ecr.aws/docker/library/golang:1.21.4-alpine3.17 AS builder

WORKDIR /
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -installsuffix cgo -o main ./main.go

RUN apk update && apk add --no-cache openssl

RUN openssl genrsa -out server.key 2048
RUN openssl ecparam -genkey -name secp384r1 -out server.key
RUN openssl req -new -x509 -sha256 -key server.key -out server.crt -days 3650 -subj "/C=US/ST=NY/L=NYC/O-Global Security/OU=IT Department/CN=good.com"

FROM scratch

COPY --from=builder /main /main
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /server.crt /server.crt
COPY --from=builder /server.key /server.key

EXPOSE 8443
CMD ["/main"]
