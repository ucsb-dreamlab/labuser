# labuser

This repo is used to build the single user [Docker image](https://hub.docker.com/repository/docker/ucsbdreamlab/labuser/general) for DREAM Lab's [JupyterHub service](https://github.com/ucsb-dreamlab/dream-machine). It's based on [docker.io/jupyterhub/singleuser](https://registry.hub.docker.com/r/jupyterhub/singleuser).

## Usage

The image is primarily intended for the JupyterHub service, but you can also run it locally: 

```sh
docker run --rm -p 8888:8888 ucsbdreamlab/labuser
```

## build and deploy

To deploy the image to the DREAM Lab JupyterHub, you'll need to be logged in to the DREAM Lab DockerHub account.

Steps are roughly:

```sh
# tag your commit with a version and push it to github
git tag v0.0.x
git push origin v0.0.x

# build the image
docker build -t labuser -f Containerfile

# push version tag
docker push labuser ucsbdreamlab/labuser:v0.0.x
# push latest tag
docker push labuser ucsbdreamlab/labuser:latest
```

Any existing single-user servers on the JupyterHub will need to be shutdown so the new image can be downloaded.