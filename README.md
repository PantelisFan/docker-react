# Dockerized React App

In this repo, there is a  dockerized a generic react app, demonstrating a 
production workflow, utilizing CRA(create react app), Docker, docker-compose,
Travis CI, AWS Beanstalk and S3 Buckets.

![Flow Chart](https://github.com/PantelisFan/docker-react/blob/master/FlowChart.png "Flow")


## Front-end Production workflow example
#### For the specific example, we will be using two Dockerfiles, one for dev and one for production

For development purposes, there is a second Dockerfile: `Dockerfile.dev` 

Since the command: `docker build .` will not work to build the dev file, explicitly specify
the file name with by passing `-f` flag to the build command, followed by the file name.

* Build the image: `docker build -f <Filename> .`
* Start the container with the react app: `docker run -p -it x:x`
The -it instructs Docker to allocate a pseudo-TTY connected to the container’s STDIN and -p exposes the port.


---
---
## Docker volumes
#### A way to avoid unnecessary and time-consuming rebuilds

When we have a dev container running, rebuilding the image to test every change is not the optimal scenario.
Docker's `run` command, offers a built-in functionality to "point to" or "reference" files outside of the container.

```text
docker build -f Dockerfile.dev .
docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <img_id>
```
where <img_id> is the built image from the above command.
**Note: since we have node_modules inside the container, we are mapping them
with passing the argument `-v /app/node_modules`** 

### How to avoid all this big commands nonsense
#### docker-compose!

To simplify the `docker run` command, there is a docker-compose file, 
specifying all the configuration. There is a `yaml` file
with all the required fields and settings to replace the long-ass command.
A simple `docker-compose up`, comes to the rescue.


---
---


## Production container
#### Multi-step docker builds

Since, on production, the dev server gets dropped,  a service is still needed
which will serve and communicate our production web container to the website.

For this **_nginx_** will be used: https://hub.docker.com/_/nginx

The new production container build flow will have to phases:

| Build Phase |   |Run Phase |
| :---------- | --- |---------: |
| USE node:alpine | <> | USE nginx |
| COPY package.json| <> |copy the built files |
| Install deps | <> |start nginx |
| Run build command |  |  |

---
---

### Travis workflow

1. Instruct Travis to run a copy of the docker image
2. Build the image using Dockerfile.env (this is the development Dockerfile)
3. Run tests
4. Deploy the code to AWS
