# Redis  (REmote DIctionary Service) 

É um dos mais populares repositórios do tipo chave-valor em memória.  
Pode ser utilizado como base de dados, como cache de dados, ou como sistema de 
mensagens (message broker).


## Pull redis server image

```bash
docker pull redis:7
```


## Run redis server in background

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


## Connect to redis as a client (so I can operate on the database)

```bash
docker exec -it redis-server redis-cli  
```
Inicia um cliente que pode fazer comandos no terminal, esses comandos ficam guardados no ficheiro /.rediscli_history. Para sair basta dar Crtl + C.
Os comandos executados pelo cliente servem para guardar/alterar/aceder a dados numa base de dados remota (redis).
Fazendo SETs, insere-se dados na database.
Fazendo GETs, vai-se buscar dados à database.
E outros inúmeros comandos que podem ser encontrados online ou nos slides da aula (CBD_05_KeyValue).


## Enter the redis container

```bash
docker exec -it redis-server /bin/bash
```
Parece que é quase um novo pc dentro do container (dá para fazer comandos tipo ls e assim). Para sair basta dar exit.


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


# Ex 3 notes

It was asked me to install Jedis driver so I could interate with the redis database.  
I decided to create a Maven project to facilitate project organization and, with that, project management.  
So, all I needed to do was adding the necessary Jedis dependencies to the POM file and use the import on the provided sample code.  


# Ex 4 notes

In both exercises, I trasfered all the data from the .txt and .csv files to the redis database.  
Then, the only thing I had to do was to search on the database keys those which had as a substring the input provided by the user.  
The only thing a little more complex was the lambda expression I had to create on the ex b), so that I could compare all the results 
using the number of registries.