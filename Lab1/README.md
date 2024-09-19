# Redis

## Pull redis image

```bash
docker pull redis:7
```

## Run redis in background

```bash
docker run -d --name redis-server -p 6379:6379 redis:7
```

## Stop and start server

```bash
docker stop redis-server
```

```bash
docker start redis-server
```

## Connect to redis 

```bash
docker exec -it redis-server redis-cli  
```
Inicia um cliente que pode fazer comandos no terminal, esses comandos ficam guardados no ficheiro /.rediscli_history. Para sair basta dar Crtl + C.
Os comandos executados pelo cliente servem para guardar/alterar/aceder a dados numa base de dados remota (redis).
Fazendo SETs, insere-se dados na database.
Fazendo GETs, vai-se buscar dados à database.

## Enter the redis container 

```bash
docker exec -it redis-server /bin/bash
```
Parece que é quase um novo pc dentro do container (dá para fazer comandos tipo ls e assim). Para sair basta dar exit

## Copy the /.rediscli_history to a file

```bash
docker cp redis-server:/root/.rediscli_history CBD-11-112981.txt
```
To find the file we can use the following command:

```bash
ll /root
```
## Run commands in a file

```bash
docker exec -i redis-server redis-cli < CBD-12-batch.txt
```