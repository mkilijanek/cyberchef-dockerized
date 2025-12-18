FROM node:18-alpine 

RUN apk --no-cache add ca-certificates git \
  && apk update && apk --no-cache upgrade \
  && apk --no-cache add curl wget unzip \
  && rm -rf /var/cache/apk/*

WORKDIR /app

ARG CYBERCHEF_VERSION
ENV CYBERCHEF_VERSION=10.19.4
RUN echo "https://github.com/gchq/CyberChef/releases/download/v${CYBERCHEF_VERSION}/CyberChef_v${CYBERCHEF_VERSION}.zip"
RUN git clone -b "v$CYBERCHEF_VERSION" --depth=1 https://github.com/gchq/CyberChef.git .

ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm install
#RUN npm audit fix --prod
RUN npx grunt prod


#RUN cp CyberChef_v*.zip cyberchef.zip && ls -lh
#RUN unzip cyberchef.zip && ls -lh \
#  && rm cyberchef.zip
#RUN Cyberchef*.html index.html

RUN npm install http-server -g
RUN mkdir -p /var/www/cyberchef
RUN cp -r /app/build/prod/* /var/www/cyberchef
#RUN http-server /var/www/cyberchef
EXPOSE 8080

CMD ["http-server", "/var/www/cyberchef", "-p", "8080"]
