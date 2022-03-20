FROM golang:1.15 AS build

RUN useradd -u 10001 gopher

RUN mkdir /goDev
WORKDIR /goDev
COPY go.mod  ./

RUN go mod download
COPY . .

RUN go build -o ./bin/goDev ./cmd/Yaratam

FROM scratch

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/passwd /etc/passwd

USER gopher

COPY --from=build /goDev/migrations /migrations
COPY --from=build /goDev/bin/goDev /goDev

CMD ["./goDev"]