FROM node:18-alpine AS builder

ARG CYBERCHEF_VERSION=10.19.4
ENV CYBERCHEF_VERSION=${CYBERCHEF_VERSION}

RUN apk add --no-cache git python3 make g++ ca-certificates \
  && update-ca-certificates

WORKDIR /app

RUN git clone -b "v${CYBERCHEF_VERSION}" --depth=1 https://github.com/gchq/CyberChef.git .

ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm ci
RUN npx grunt prod

FROM nginx:1.27-alpine

COPY --from=builder /app/build/prod/ /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
