lizmap docker
=============

Dockerfile to build an image of lizmap-web-client with the latest qgis server.

Derived from the work of [Julien ANCELIN](https://github.com/jancelin/docker-lizmap)

### Building the image

create a directory with:
```
cd /home &&
mkdir -p lizmap/{qgis_project,run/log,cache} &&
sudo chown :www-data /home/lizmap -R &&
sudo chmod 775 /home/lizmap -R
```

build image:
```
docker build -t lizmap_nginx git://github.com/3liz/lizmap-docker
```

run container:
```
docker run --restart="always" --name "lizmap_nginx" -p 8082:80 -p 8200:8200 -d -t \
-v /home/lizmap/qgis_project:/home \
-v /home/lizmap/run/log:/var/log/lizmap \
-v /home/lizmap/cache:/tmp \
lizmap_nginx
```

go to:
```
http://localhost:8082/admin.php/admin/config/editSection
```
create Path to local directory :  /home

go to:
```
http://localhost:8082/admin.php/admin/config/editServices
```
edit URL WMS: http://127.0.0.1:8200/cgi-bin/qgis_mapserv.fcgi

or

Use the docker-compose configuration that define mounted volumes

```
docker-compose up
```

to build and run the image from the local directory.

See the [docker compose page](https://docs.docker.com/compose/) for how to use it. 

or

```
make build 
```

to create the docker image

### Volumes

the lizmaps-docker declare two persistent volumes: the /home directory and the lizmap var directory. When configuring lizmap you should use /home as 
project directory in order to make them persisent.

If you want to use external projects then you have to copy your projects somewhere and mount the container /home where your projects lies on host.
Or create your a new project with the lizmap interface and push your data to the /home volume.

See https://docs.docker.com/engine/userguide/containers/dockervolumes about docker volumes

 




