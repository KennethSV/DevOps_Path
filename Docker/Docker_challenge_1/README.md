# Docker Challenge
---
## Clone repository

Repository used: https://github.com/falconcr/react-demo

## Create the necessary docker files for the creation of the container:

### Dockerfile

FROM node:17-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]

### docker-compose.yaml

version: "3.8"
services:
  react-demo:
    build: ./react-demo
    container_name: react-demo-containerized
    ports: 
      - '3000:3000'
    stdin_open: true
    tty: true

## Make sure to pull the necessary container to run the applition on:

> docker pull node:17-alpine

## Finishing Project

Once everything has been setup as described above, you can finally build up your own react dockerized application. 

> docker compose up -d

## POC

![localhost:3000](https://github.com/KennethSV/DevOps_Path/blob/main/Docker/Docker_challenge_1/Container_Running.jpg)
![Docker Container Running](https://github.com/KennethSV/DevOps_Path/blob/main/Docker/Docker_challenge_1/Page_Loaded.jpg)
