# TCC MBA Fatec (Aplicação de Algoritmos de Machine Learning na previsão de cotação do Bitcoin)

Neste repositório contém o artigo e todos os códigos
utilizados para confecção do TCC do MBA Fatec em 2020.

A estrutura das pastas é a seguinte:

* data - Arquivos .RData utilizados para o estudo. Só é 
criada localmente através da função `GetData()`. Deve-se
executar o arquivo `main.R` para gerar os dados.
* R - Todos os script em R utilizados no trabalho;
* template-artigo - Todos os arquivos utilizados para 
escrita do artigo em `Latex`

O Arquivo `config.yml` deve ser salvo localmente na pasta
principal, com as credenciais para acesso ao banco de dados,
conforme exemplo:

```
default:
  azure:
    connection: nome_do_banco
    host: endereco_do_host
    user: usuario
    password: senha
```

Deve-se ter instalado o Latex para compilação do artigo,
conforme [Projeto](https://www.latex-project.org/).