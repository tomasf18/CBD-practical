# Base de Dados de Filmes

## Dataset

No path: `src/main/resources/movie.csv` encontram-se todos os dados que foram utilizados para este exercício.
Usei o programa `src/main/java/pt/tmg/cbd/lab2/ex6/MovieDatabaseUploader.java` para escrever todos os 7668 dados na database.

## Estrutura do Dataset

Cada documento na coleção `movies` representa um filme com a seguinte estrutura:

```json
{
    "name": "Inception",
    "rating": 8.8,
    "genre": ["Sci-Fi", "Thriller"],
    "year": 2010,
    "released": "2010-07-16",
    "score": 9.0,
    "votes": 200000,
    "director": "Christopher Nolan",
    "writer": "Christopher Nolan",
    "star": "Leonardo DiCaprio",
    "country": "USA",
    "budget": "$160,000,000",
    "gross": "$829,895,144",
    "company": "Warner Bros.",
    "runtime": "148 min"
}
```

## Consultas `find`

### 0. Confirmar dados na coleção.
```javascript
db.movies.find().count()
7668
```

### 1. Listar todos os filmes de Drama lançados após o ano 2000.
```javascript
db.movies.find({genre: "Drama", year: {$gt: 2000}}, {name: 1, year: 1, genre: 1, _id: 0})
```
.count() -> 747

### 2. Consultar filmes onde Leonardo DiCaprio atuou como personagem principal.
```javascript
db.movies.find({star: "Leonardo DiCaprio"}, {name: 1, year: 1, star: 1, _id: 0})
```
.count() -> 20

### 3. Encontrar filmes com avaliação igual ou superior a 9.
```javascript
db.movies.find({score: {$gte: 9}},{name: 1, score: 1, _id: 0})
[
  { name: 'The Shawshank Redemption', score: 9.3 },
  { name: 'The Dark Knight', score: 9 }
]
```

### 4. Listar filmes lançados após 2000 com pontuação média de avaliação maior ou igual a 8.5 e com mais de 500.000 votos
```javascript
db.movies.find({year: { $gt: 2000 }, score: { $gte: 8.5 }, votes: { $gt: 500000 }}, {name: 1, year: 1, score: 1, votes: 1, _id: 0})
[
  { name: 'The Lord of the Rings: The Fellowship of the Ring', year: 2001, score: 8.8, votes: 1700000 },
  { name: 'Spirited Away', year: 2001, score: 8.6, votes: 679000 },
  { name: 'The Pianist', year: 2002, score: 8.5, votes: 756000 },
  { name: 'The Lord of the Rings: The Two Towers', year: 2002, score: 8.7, votes: 1500000 },
  { name: 'City of God', year: 2002, score: 8.6, votes: 714000 },
  { name: 'The Lord of the Rings: The Return of the King', year: 2003, score: 8.9, votes: 1700000 },
  { name: 'The Departed', year: 2006, score: 8.5, votes: 1200000 },
  { name: 'The Prestige', year: 2006, score: 8.5, votes: 1200000 },
  { name: 'The Dark Knight', year: 2008, score: 9, votes: 2400000 },
  { name: 'Inception', year: 2010, score: 8.8, votes: 2100000 },
  { name: 'The Intouchables', year: 2011, score: 8.5, votes: 785000 },
  { name: 'Interstellar', year: 2014, score: 8.6, votes: 1600000 },
  { name: 'Whiplash', year: 2014, score: 8.5, votes: 749000 },
  { name: 'Parasite', year: 2019, score: 8.6, votes: 631000 }
]
```

### Encontrar filmes do Reino Unido com duração superior a 120 minutos e com Jack Nicholson como star.
```javascript
db.movies.find({ country: "United Kingdom", runtime: { $regex: /^\d+/, $gte: "120" }, star: "Jack Nicholson" }, { name: 1, country: 1, runtime: 1, star: 1, _id: 0 })
[
  {
    name: 'The Shining',
    star: 'Jack Nicholson',
    country: 'United Kingdom',
    runtime: '146 min'
  }
]

```

### 6. Encontrar filmes com diretor Christopher Nolan.
```javascript
db.movies.find({director: "Christopher Nolan"}, {name: 1, director: 1, _id: 0})
[
  { name: 'Following', director: 'Christopher Nolan' },
  { name: 'Memento', director: 'Christopher Nolan' },
  { name: 'Insomnia', director: 'Christopher Nolan' },
  { name: 'Batman Begins', director: 'Christopher Nolan' },
  { name: 'The Prestige', director: 'Christopher Nolan' },
  { name: 'The Dark Knight', director: 'Christopher Nolan' },
  { name: 'Inception', director: 'Christopher Nolan' },
  { name: 'The Dark Knight Rises', director: 'Christopher Nolan' },
  { name: 'Interstellar', director: 'Christopher Nolan' },
  { name: 'Dunkirk', director: 'Christopher Nolan' },
  { name: 'Tenet', director: 'Christopher Nolan' }
]

```

## Consultas `aggregate`

### 1. Contar filmes por género.
```javascript
db.movies.aggregate([{$unwind: "$genre"}, {$group: {_id: "$genre", totalMovies: {$sum: 1}}}, {$sort: {totalMovies: -1}}])
[
  { _id: 'Comedy', totalMovies: 2245 },
  { _id: 'Action', totalMovies: 1705 },
  { _id: 'Drama', totalMovies: 1518 },
  { _id: 'Crime', totalMovies: 551 },
  { _id: 'Biography', totalMovies: 443 },
  { _id: 'Adventure', totalMovies: 427 },
  { _id: 'Animation', totalMovies: 338 },
  { _id: 'Horror', totalMovies: 322 },
  { _id: 'Fantasy', totalMovies: 44 },
  { _id: 'Mystery', totalMovies: 20 },
  { _id: 'Thriller', totalMovies: 16 },
  { _id: 'Family', totalMovies: 11 },
  { _id: 'Romance', totalMovies: 10 },
  { _id: 'Sci-Fi', totalMovies: 10 },
  { _id: 'Western', totalMovies: 3 },
  { _id: 'Musical', totalMovies: 2 },
  { _id: 'Sport', totalMovies: 1 },
  { _id: 'Music', totalMovies: 1 },
  { _id: 'History', totalMovies: 1 }
]
```

### 2. Calcular a média das classificações para cada filme.
```javascript
db.movies.aggregate([{$group: {_id: "$name", averageScore: {$avg: "$score"}}}, {$sort: {averageScore: -1}}])
[
  { _id: 'The Shawshank Redemption', averageScore: 9.3 },
  { _id: 'The Dark Knight', averageScore: 9 },
  { _id: "Schindler's List", averageScore: 8.9 },
...
```

### 3. Contar o número de filmes por diretor.
```javascript
db.movies.aggregate([{$group: {_id: "$director", totalMovies: {$sum: 1}}}, {$sort: {totalMovies: -1}}])
[
  { _id: 'Woody Allen', totalMovies: 38 },
  { _id: 'Clint Eastwood', totalMovies: 31 },
  { _id: 'Directors', totalMovies: 28 },
  { _id: 'Steven Spielberg', totalMovies: 27 },
  { _id: 'Ron Howard', totalMovies: 24 },
  { _id: 'Steven Soderbergh', totalMovies: 23 },
  { _id: 'Ridley Scott', totalMovies: 23 },
  { _id: 'Joel Schumacher', totalMovies: 22 },
  { _id: 'Barry Levinson', totalMovies: 20 },
...
```

### 4. Listar a contagem de filmes e a média de orçamento por diretor, apenas para filmes com classificação "R".
```javascript
db.movies.aggregate([{$match: {rating: "R"}}, {$group: {_id: "$director", totalMovies: {$sum: 1}, averageBudget: {$avg: {$convert: {input: "$budget", to: "double", onError: null, onNull: null}}}}}, {$sort: {totalMovies: -1}}]) // onError e onNull são necessários para casos de campos com "Unknown"
[
  {
    _id: 'Clint Eastwood',
    totalMovies: 19,
    averageBudget: 35426315.78947368
  },
  {
    _id: 'Oliver Stone',
    totalMovies: 15,
    averageBudget: 38714285.71428572
  },
  {
    _id: 'Brian De Palma',
    totalMovies: 15,
    averageBudget: 26133333.333333332
  },
...
```

### 5. Calcular a média de pontuação para filmes dos United States após 2010 e com mais de 100.000 votos
```javascript
db.movies.aggregate([{$match: {year: {$gt: 2010}, country: "United States", votes: {$gt: 100000}}}, {$group: {_id: "$country", averageScore: {$avg: "$score"}, totalMovies: {$sum: 1}}}, {$sort: {averageScore: -1}}])
[
  {
    _id: 'United States',
    averageScore: 6.8439453125,
    totalMovies: 512
  }
]
```

### 6. Calcular a média de pontuação dos filmes para cada ator principal, com filmes dirigidos apenas por Christopher Nolan.
```javascript
db.movies.aggregate([{$match: {director: "Christopher Nolan"}}, {$unwind: "$star"}, {$group: {_id: "$star", averageScore:{$avg: "$score"}, totalMovies: {$sum: 1}}}, {$sort: { averageScore: -1 }}])
[
  { _id: 'Leonardo DiCaprio', averageScore: 8.8, totalMovies: 1 },
  { _id: 'Matthew McConaughey', averageScore: 8.6, totalMovies: 1 },
  { _id: 'Christian Bale', averageScore: 8.525, totalMovies: 4 },
  { _id: 'Guy Pearce', averageScore: 8.4, totalMovies: 1 },
  { _id: 'Fionn Whitehead', averageScore: 7.8, totalMovies: 1 },
  { _id: 'Jeremy Theobald', averageScore: 7.5, totalMovies: 1 },
  { _id: 'John David Washington', averageScore: 7.4, totalMovies: 1 },
  { _id: 'Al Pacino', averageScore: 7.2, totalMovies: 1 }
]
```