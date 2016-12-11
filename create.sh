# create container with downloaded data

# make sure there is not temp container running
# can produce error message if there is no 'firmad-temp' container 
docker rm -f firmad-temp

# crete a temp container with postgres
docker run --name firmad-temp -d -e "PGDATA=/home" --volume $PWD/data:/import --volume $PWD/_init:/docker-entrypoint-initdb.d postgres:9.6

# now we need to wait till scripts in the /docker-entrypoint-initdb.d will be processed
# for now just wait 30 seconds
sleep 30

# show log to make sure initialization is complete
docker logs firmad-temp

# create a new image from firmad-temp container
docker commit firmad-temp firmad:$FIRMAD_EXPORT_DATE

# stop temp container
docker rm -f firmad-temp

# tag image before pushing to the docker hub
docker tag firmad:$FIRMAD_EXPORT_DATE mgstr/firmad:$FIRMAD_EXPORT_DATE
docker tag firmad:$FIRMAD_EXPORT_DATE mgstr/firmad:latest                   # assume that this should be the latest image

# push to the docker hub
docker push mgstr/firmad:$FIRMAD_EXPORT_DATE
docker push mgstr/firmad:latest