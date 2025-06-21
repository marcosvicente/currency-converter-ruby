# O que foi feito

1 - Todo a operação de Crud
 - Para fazer um grupo seria necessario chamar o `CrudManagment`, com o classe que seria aperação, por exemplo, se uma atulizacão chamar `CrudManagment::UpdateService`
 - e fugir do basico do crud criar uma classe com nome final `Managment` e criar apartir dela uma nova classe. Por exemplo, quando criamos o `TransactionSevice::CreateService`, herdamos do `CrudManagment::UpdateService`

 
2 - Todo enum tem ser com a gem `enumerate_it`
 - Para criar um novo enum tem que usar a `gem` `enumerate_it`. Ver Doc: [enumerate_it](https://github.com/lucascaton/enumerate_it)

3 - Para ver o coverage 
  - Basta rodar o comando `rspec` e ir dentro do projeto no caminho `coverage/index` e abrir no navegador

4 - Dados do postman
  - esta dentro `CurrencyApi.postman_collection.json` 
    