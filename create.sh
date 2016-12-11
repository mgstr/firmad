# create container with downloaded data

# make sure there is not temp container running
2&>/dev/null docker rm -f firmad-temp

# crete a temp container with postgres
docker run --name firmad-temp -d -e "PGDATA=/home" --volume $PWD/data:/import --volume $PWD/_init:/docker-entrypoint-initdb.d postgres:9.6

# show container logs
docker logs -f firmad-temp