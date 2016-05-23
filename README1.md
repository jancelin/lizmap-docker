
### building from git

* Create directory with:
```
cd /home &&
mkdir -p lizmap/{qgis_project,run/log,cache} &&
sudo chown :www-data /home/lizmap -R &&
sudo chmod 775 /home/lizmap -R
```

* Build image:
```
docker build -t lizmap_nginx git://github.com/3liz/lizmap-docker
```

* Run container:
```
docker run --restart="always" --name "lizmap_nginx" -p 8082:80 -p 8200:8200 -d -t \
-v /home/lizmap/qgis_project:/home \
-v /home/lizmap/run/log:/var/log/lizmap \
-v /home/lizmap/cache:/tmp \
lizmap_nginx
```

* Go to:
```
http://localhost:8082/admin.php/admin/config/editSection
```
* Create Path to local directory :  /home

* Go to:
```
http://localhost:8082/admin.php/admin/config/editServices
```
* Edit URL WMS: http://127.0.0.1:8200/cgi-bin/qgis_mapserv.fcgi

* Copy yours .qgs & .qgs.cfg to /home/lizmap/qgis_project

* Go to http://localhost:8082 and enjoy.
