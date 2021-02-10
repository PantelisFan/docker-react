## Front-end Production workflow example
#### For the specific example, we will be using two Dockerfiles, one for dev and one for production

In order to have two Dockerfiles, we have to slightly rename one of them, in this repo,
we there is a file `Dockerfile.dev` which we will be using for development.

Since the command: `docker build .` will not work in this case, we have to explicitly specify
the file name with by passing `-f` flag to the build command, followed by the file name.

* Build the image: `docker build -f <Filename> .`
* Start the container with the react app: `docker run -p -it 3000:3000`
The -it instructs Docker to allocate a pseudo-TTY connected to the container’s STDIN and -p exposes the port.


---
---
## Docker volumes
#### A way to avoid unnecessary and time-consuming rebuilds

When we have a dev container running, rebuilding the image to test every change is not the optimal scenario.
Docker's `run` command, offers a built-in functionality to point or "reference" files outside of the container.

```text
docker build -f Dockerfile.dev .
docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <img_id>
```
where <img_id> is the built image from the above command.
**Note: since we have node_modules inside the container, we are mapping them
with passing the argument `-v /app/node_modules`**

Now, we can hot-reload using the changes, while the container runs. 

### How to avoid all this big commands nonsense
#### docker-compose!

To simplify the `docker run` command, we can simply create a docker-compose file, 
specifying all the configuration. in the current repository, there is a `yaml` file
with all the required fields and settings to replace the long-ass command.
In this case, a simple `docker-compose up`, comes to the rescue.
---
---


## Production container
#### Multi-step docker builds

Since, on production, we are dropping the dev server required to run our app
and all the dependencies, but we still need a service which will serve
and communicate from our production web container to the end-website.

For this, we will utilize **_nginx_**: https://hub.docker.com/_/nginx

Our new container build flow will look like this:

| Build Phase |   |Run Phase |
| :---------- | --- |---------: |
| USE node:alpine | <> | USE nginx |
| COPY package.json| <> |copy the built files |
| Install deps | <> |start nginx |
| Run build command |  |  |

---
---

### Travis workflow

1. Instruct travis to run a copy of the docker image
2. Build the image using Dockerfile.env (this is the development Dockerfile)
3. Run tests
4. Deploy the code to AWS