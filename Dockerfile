# https://docs.docker.com/examples/nodejs_web_app/
# `--env-file=secrets/ENV/env.sh` required to run
FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y nodejs nodejs-legacy npm git
RUN npm install -g npm
# http://christian.fei.ninja/Cache-speed-up-docker-node-modules/
COPY package.json /src/package.json
RUN cd /src; npm install --production
COPY . /src
ENV PORT=80
EXPOSE 80
WORKDIR /src
CMD npm start
