FROM golang:1.20-alpine
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN apk add --no-cache yarn
RUN yarn && yarn build
RUN go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest
WORKDIR /app/cmd/sneaker-server
RUN go generate
RUN go build -v -o /usr/local/bin/sneaker-server
EXPOSE 7788
WORKDIR /app
RUN cp example.config.json /app/config/config.json
CMD [ "sneaker-server", "--config",  "/app/config/config.json", "--bind",  "0.0.0.0:7788" ]