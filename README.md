## Informações necessarias
Para executar este projeto é necessário instalar o [`ruby`](#ruby) 

## Passo a passo, para instalar
Primeiro precisar buildar o projeto  e rodar o setup. Se não quiser rodar o setup que já vem o [`seed`](#criar-seed), pode-se criar com o [`create`](#criar-banco-de-dados) depois [`migrate`](#rodar-migration)
```

$ rails db:setup
```

## Para rodar o projeto
Antes de rodar o projeto precisa criar o banco de dados com o setup
```
$ $ rails server
```

## Criar banco de dados
```
$ rails db:create
```

## Rodar Migration
```
$ rails db:migrate
```

## Criar seed
```
$ rails db:seed
```

## Rodar testes
```
$  rspec
```

## Rails console
```
$ rails c
```

## Criar seed
```
$ rails db:seed
```
## Criar setup
```
$  rails db:setup
```