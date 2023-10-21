`[runtime, engine, orchestrator]`
runtime:  [runc, containerd]
engine: [cli, rest api, server daemon]
orchestrator: manage containers [start, stop, update, ..]
```
docker pull <image>:xx.xx
docker run
docker ps
docker ls
docker container exec -it <container_id> <program> 
^ run a program of a container
```
### [Layers](https://docs.docker.com/build/guide/layers/)
Each instruction in docker file creates a layer in the image.
> only the changed layers are built again
![[Pasted image 20231022001723.png]]
## Example
```docker
# Use the official MongoDB image as the base image
FROM mongo:latest

# Set environment variables
ENV MONGO_INITDB_ROOT_USERNAME admin
ENV MONGO_INITDB_ROOT_PASSWORD password

# Expose MongoDB default port
EXPOSE 27017

# Create a directory for custom initialization scripts
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy a custom initialization script (if needed)
# COPY ./init-script.js /docker-entrypoint-initdb.d/

# Start MongoDB when the container runs
CMD ["mongod", "--auth"]
```
-t create a virtual terminal session
-d detached mode (background mode)
-i keep `STDIN` open even when running in detached mode

create image: `docker build -t my-mongodb`
build container: `docker run -d -p 27017:27017 --name db-container my-mongodb
### `init-script.js`
```js
// Create and use a new database
db = db.getSiblingDB('myanilist');

// Create a new collection
db.createCollection('characters');

// Insert a document into the collection
db.mycollection.insert({
    name: 'Lain Iwakura',
    age: 14,
    desc: 'She is first depicted as a shy junior high school student with few friends or interests.'
});
```
>[!warning]+ Nothing is persistent
>In a Docker container, including a MongoDB container, the data is stored inside the container's file system. By default, data stored in a container is not persisted outside the container, which means that if the container is stopped or removed, the data within it is lost.
>
> **Solution**: Volume mapping `-v host\dir:container\dir` 

## Docker + k8s
Publish the image to Docker Hub, Google Container Registry or etc, once that is done, k8s can pull em build > put in a pod > under a deployment > [You the user @ControlPlane dictating every action]

Secrets are managed using **ConfigMaps**
