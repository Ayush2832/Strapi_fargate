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

## 2. Terraform files
- In the terraform directory we have define the terraform files for different infrastructure.

- For VPC network setup we have the file [vpc.tf](./terraform/vpc.tf)

- For Load balancer we have the file [alb.tf](./terraform/alb.tf)

- Then for ecs creation we have the file [ecs.tf](./terraform/ecs.tf)

## 3. Github action files
- Once all these things are configure we will then make `deploy.yml` file which will just checkout the code and then it make the docker image of it and then push the image to the docker hub.
- Then at last it will run terraform init and terraform apply.

- Here it will checkout the code and try ot login with the docker
```yml
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Log in to DockerHub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
```

- And then it will push the image to the docker registry

```yml
    - name: Build and Push Docker Images
      uses: docker/build-push-action@v6
      with:
        context: ./strapi_task7
        file: ./strapi_task7/Dockerfile
        push: true
        tags: ${{env.IMAGE_NAME}}:${{env.IMAGE_TAG}}
```

- And then we run the same terraform terraform init and apply command

```yml
    - name: terraform setup
      uses: hashicorp/setup-terraform@v3

    - name: Terraform init
      run: terraform init
      working-directory: ./terraform

    - name: Terraform Apply
      run: terraform apply -auto-approve -var="image_tag=${{ env.IMAGE_TAG }}"
      working-directory: ./terraform
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

- For artifact I am following this blog 
> [link](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/storing-and-sharing-data-from-a-workflow)

```yml
      - name: Archive code coverage results
        uses: actions/upload-artifact@v4
        with:
          name: terraform statefile
          path: ./terraform/terraform.tfstate
```

### 4. Result
- Once we run the command
> git push origin master
- And it will trigger the pipeline.

<img src="./images/1.png" alt="result" width="500">