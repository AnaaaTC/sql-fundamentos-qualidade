# Controle de Qualidade Automotiva: Análise Relacional com SQL

Este projeto documenta meu estudo prático em SQL. Modelei um banco de dados relacional simulando o cenário de manufatura e qualidade de uma montadora para treinar cruzamento de tabelas (JOINs) e agregações numéricas (GROUP BY / HAVING).

> **⚠️ Aviso:** Todos os dados, nomes de sistemas e estruturas de tabelas neste repositório são estritamente fictícios e criados apenas para estudo. Não representam dados reais de empregadores atuais ou passados.

## Modelo de dados

Modelei três tabelas: a dimensão `veiculos` no centro, e duas tabelas de fatos (`ocorrencias_qfs` e `inspecoes_ncbs`) ligadas a ela pela chave `id_veiculo`. Essa estrutura de uma dimensão conformada compartilhada por dois fatos é o que causa o efeito *fan-out* se unida sem cuidados.

*   **`veiculos`:** Cadastro da frota (modelo, linha, data). PK: `id_veiculo`.
*   **`ocorrencias_qfs`:** Falhas e severidade. PK: `id_ocorrencia`. FK: `id_veiculo`.
*   **`inspecoes_ncbs`:** Status de qualidade. PK: `id_inspecao`. FK: `id_veiculo`.

## Perguntas que este projeto responde

*   Quais veículos saíram da linha de produção sem nenhuma ocorrência registrada?
*   Quais são os modelos com o maior número de falhas apontadas?
*   Como as ocorrências estão distribuídas por linha de produção e por severidade?
*   Quais chassis são reincidentes (têm mais de uma falha)?

## Decisões técnicas

*   **INNER JOIN vs. LEFT JOIN:** O `INNER JOIN` foi usado para trazer apenas os veículos com falha. O `LEFT JOIN` foi mantido quando a intenção era listar a base inteira, inclusive os carros sem defeito.
*   **Anti-join:** Para achar os carros sem defeito, usei `LEFT JOIN` filtrando `WHERE o.id_veiculo IS NULL` na tabela da direita.
*   **Tratamento do Fan-out no Join Triplo:** Como a dimensão compartilhada gera a multiplicação de registros ao cruzar as três tabelas simultaneamente, a decisão técnica para evitar inflar o número de defeitos foi utilizar `COUNT(DISTINCT o.id_ocorrencia)`.
*   **Contagem exata e NULLs:** Com `LEFT JOIN`, usei `COUNT(o.id_ocorrencia)` em vez de `COUNT(*)`. A diferença técnica é que `COUNT(*)` conta se a *linha existe* (e o veículo sem defeito gera uma linha no LEFT JOIN, sendo contada como 1). `COUNT(coluna)` conta os *valores presentes*, ignorando os NULLs.
*   **WHERE vs. HAVING:** `WHERE` para filtrar as linhas antes de agrupar; `HAVING` para filtrar os grupos gerados pela agregação (ex: `HAVING COUNT(o.id_ocorrencia) > 1`).

## Como executar

O projeto foi desenvolvido em **SQLite**. Para reproduzir localmente:

1.  Clone o repositório.
2.  Abra o DBeaver e crie uma nova conexão do tipo SQLite.
3.  Aponte para um novo arquivo de banco de dados (ex: `estudos_sql.db`).
4.  Execute o script `schema.sql` para criar as tabelas e injetar os dados fictícios.
5.  Abra e rode as consultas do arquivo `queries_semana01.sql`.

## Estrutura dos arquivos

*   `schema.sql`: Script DDL e DML para criação do banco e inserção da carga inicial de dados.
*   `queries_semana01.sql`: As 10 consultas SQL desenvolvidas no estudo.
*   `log_semana1.md`: Diário de bordo detalhando as queries, as razões para cada tipo de JOIN escolhido e os aprendizados técnicos (erros e comportamentos específicos do SQLite).