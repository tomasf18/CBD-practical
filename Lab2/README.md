# CBD Lab 2

Sample workspace for completing the CBD Lab 2.

This workspace provides a docker-compose file to run the MongoDB server, and it's companions, in a dockerized enviromnment.

The [resources folder](resources) is automatically mounted to `/resources` in the MongoDB container.
It contains some assets required to complete the Lab.

Open `mongosh` on the container:
`docker-compose exec -it mongodb mongosh --db cbd`

Import restaurants: 
`docker-compose exec -it mongodb mongoimport --db cbd --collection restaurants --drop --file /resources/restaurants.json`


## Additional Notes

* Make sure you have previously installed Docker Desktop, or at least Docker Engine.
// TODO: Add Links


----

# Start of the guide:

```bash
docker compose up (-d)
```


Open `mongosh` (mango shell) on the container:
```bash
docker-compose exec -it mongodb mongosh --db cbd
```
Corre o docker compose e abre um terminal a executar o serviço do docker compose file "mongodb"

Import restaurants: 
```bash
docker-compose exec -it mongodb mongoimport --db cbd --collection restaurants --drop --file /resources/restaurants.json`
```
Cooree a ferramentea de importação do mongo e vai correr o json para a database
Vai ser tudo montado na pasta `./resources:/resources` -> mapeamento da pasta resources do host para o container