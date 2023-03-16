FROM golang:alpine AS builder

WORKDIR /app

COPY fullcycle.go /app/

RUN apk update && apk add --no-cache git upx

RUN go env -w GO111MODULE=off && go get -d -v

RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o fullcycle && upx -9 -k fullcycle

FROM scratch

COPY --from=builder /app/fullcycle /app/fullcycle

ENTRYPOINT [ "/app/fullcycle" ]