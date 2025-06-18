# Task7: Deploy a Strapi application on AWS using ECS Fargate, managed entirely via Terraform and Automate via GitHub Actions [ci/cd]

## 1. Basic setup
- First we have to setup our strapi app using
> npx create-strapi@latest
- Then we can create image of that app using the dockerfile
```dockerfile
FROM node
WORKDIR /opt/
COPY . .
RUN npm install -g node-gyp && npm config set fetch-retry-maxtimeout 600000 -g && npm install
ENV PATH=./node_modules/.bin:$PATH
RUN ["npm", "run", "build"]
EXPOSE 1337
CMD ["npm", "run", "develop"]
```
- Then we can run the commands to check if it is working fine or not.
> docker build -t imagename .

> docker run -d --name contname -p 1337:1337 --env-file .env imagemid