# Semana 1 — Fundamentos de SQL

Projeto de estudo com banco fictício inspirado em sistemas de qualidade automotiva.

## Contexto

Este repositório documenta meu avanço prático em SQL focado em Engenharia e Análise de Dados. Para tornar o aprendizado aplicável, modelei um banco de dados relacional simulando o cenário de manufatura e qualidade de uma montadora. 

> **⚠️ Aviso Importante:** Nenhum dado real, nomes de sistemas internos ou estruturas de tabelas são utilizados neste projeto. O banco de dados é estritamente fictício e apenas inspirado no domínio de negócios.

As tabelas principais são: 
* `veiculos`: dados de chassi, linha de produção, modelos e datas de fabricação.
* `ocorrencias_qfs`: falhas apontadas e níveis de severidade.
* `inspecoes_ncbs`: status de auditoria e avaliações de qualidade.

## As 10 queries

### Query 1 — Anti-join: veículos sem nenhuma ocorrência registrada
**O problema que resolve:** Identificar os veículos que passaram pela linha sem gerar nenhuma ocorrência.
**Por que este JOIN:** O `LEFT JOIN` com `WHERE IS NULL` descarta tudo o que teve correspondência e deixa apenas os veículos sem defeito.
```sql
SELECT
    v.id_veiculo,
    v.modelo,
    v.linha_producao,
    v.data_producao
FROM veiculos v
LEFT JOIN ocorrencias_qfs o
    ON v.id_veiculo = o.id_veiculo      
WHERE o.id_veiculo IS NULL;             
```
---
### Query 2 — Filtro IN: Veículos dos modelos A e C
**O problema que resolve:** Levantar dados restritos a um escopo específico de modelos.
**Por que este JOIN:** Não há JOIN, consulta direta na tabela principal.
```sql
SELECT
    id_veiculo,
    modelo,
    linha_producao,
    data_producao
FROM veiculos
WHERE modelo IN ('Modelo A', 'Modelo C'); 
```
---
### Query 3 — Filtro de Período e Múltiplas Condições
**O problema que resolve:** Monitorar falhas críticas recentes.
**Por que este JOIN:** Não há JOIN, consulta direta na tabela de fatos.
```sql
SELECT
    id_ocorrencia,
    id_veiculo,
    severidade,
    descricao,
    data
FROM ocorrencias_qfs
WHERE severidade = 'Alta'               
  AND data >= '2026-07-15'              
ORDER BY data DESC, id_ocorrencia DESC; 
```
---
### Query 4 — INNER JOIN: Veículos com pelo menos uma ocorrência
**O problema que resolve:** Mostrar dados do carro e do defeito lado a lado, eliminando carros sem problemas.
**Por que este JOIN:** O `INNER JOIN` só traz a interseção.
```sql
SELECT 
    v.modelo,
    v.linha_producao,
    o.severidade,
    o.descricao
FROM veiculos v 
INNER JOIN ocorrencias_qfs o            
    ON v.id_veiculo = o.id_veiculo;     
```
---
### Query 5 — LEFT JOIN: Todos os veículos (A base completa)
**O problema que resolve:** Visão geral da frota (mostra o carro mesmo sem defeito, deixando o campo vazio).
**Por que este JOIN:** A tabela da esquerda (`veiculos`) é a prioridade.
```sql
SELECT 
    v.modelo,
    v.linha_producao,
    o.severidade,
    o.descricao
FROM veiculos v 
LEFT JOIN ocorrencias_qfs o             
    ON v.id_veiculo = o.id_veiculo;
```
---
### Query 6 — O Join Triplo e o Fan-out
**O problema que resolve:** Contar as ocorrências reais quando a terceira tabela (inspeções) gera multiplicação de linhas dentro da mesma chave (fan-out).
**Por que este JOIN:** Múltiplos `LEFT JOIN` ligam as duas tabelas de fatos à dimensão de veículos. Como isso duplica os registros (ex: o carro 1035 multiplicou para 6 linhas), a saída segura é usar `COUNT(DISTINCT)`.
```sql
SELECT COUNT(DISTINCT o.id_ocorrencia)  
FROM veiculos v
LEFT JOIN ocorrencias_qfs o 
    ON v.id_veiculo = o.id_veiculo
LEFT JOIN inspecoes_ncbs i 
    ON v.id_veiculo = i.id_veiculo      
WHERE v.id_veiculo = 1035;              
```
---
### Query 7 — A Armadilha do LEFT JOIN
**O problema que resolve:** Proteger o LEFT JOIN de virar um INNER JOIN ao filtrar dados da tabela da direita.
**Por que este JOIN:** A condição sobe para o `ON` para preservar os carros sem ocorrência (NULL).
```sql
SELECT 
    v.modelo,
    v.linha_producao,
    o.severidade,
    o.descricao
FROM veiculos v 
LEFT JOIN ocorrencias_qfs o
    ON v.id_veiculo = o.id_veiculo
	AND o.severidade = 'Alta';          
```
---
### Query 8 — Agregação: Ocorrências por modelo
**O problema que resolve:** Mostrar ranking de modelos problemáticos e validar o uso do `COUNT(coluna)`.
**Por que este JOIN:** Ignorar os NULLs do `LEFT JOIN` e permitir contar "0 ocorrências" corretamente.
```sql
SELECT 
    v.modelo,
    COUNT(o.id_ocorrencia) AS quantidade_ocorrencias 
FROM veiculos v 
LEFT JOIN ocorrencias_qfs o
    ON v.id_veiculo = o.id_veiculo 
GROUP BY v.modelo                       
ORDER BY quantidade_ocorrencias DESC;   
```
---
### Query 9 — Agrupamento Duplo: Ocorrências por severidade e linha
**O problema que resolve:** Entender onde (linha) e qual a gravidade (severidade) dos problemas.
**Por que este JOIN:** `LEFT JOIN` mantendo a visibilidade de todas as linhas de produção. O foco aqui é garantir que o `COUNT` aponte para `o.id_ocorrencia` para ignorar os NULLs dos veículos sem falhas.
```sql
SELECT 
	v.linha_producao,
	o.severidade,
	COUNT(o.id_ocorrencia) AS quantidade_ocorrencias
FROM veiculos v
LEFT JOIN ocorrencias_qfs o
	ON v.id_veiculo = o.id_veiculo 
GROUP BY 
	v.linha_producao,                   
	o.severidade                        
ORDER BY 
	v.linha_producao,                   
	quantidade_ocorrencias DESC;        
```
---
### Query 10 — O poder do HAVING: Veículos reincidentes
**O problema que resolve:** Isolar apenas os chassis que apresentaram múltiplos defeitos.
**Por que este JOIN:** O `HAVING` filtra o resultado da agregação. Aqui, agrupamos pelo ID do veículo (garantido no SELECT e no GROUP BY) e contamos o ID da ocorrência.
```sql
SELECT 
	v.id_veiculo,
	v.modelo,
	COUNT(o.id_ocorrencia) AS quantidade_ocorrencias
FROM veiculos v 
INNER JOIN ocorrencias_qfs o 
	ON v.id_veiculo = o.id_veiculo
GROUP BY 
	v.id_veiculo,                       
	v.modelo                            
HAVING COUNT(o.id_ocorrencia) > 1;         
```
---
## Erros cometidos e o que aprendi

1. **A Armadilha do LEFT JOIN que vira INNER:** Descobri na prática que, se eu faço um `LEFT JOIN` e coloco um filtro apontando para a tabela da direita no `WHERE` (ex: `WHERE severidade = 'Alta'`), o banco descarta as linhas `NULL` e transforma meu LEFT em um INNER JOIN silenciosamente. A solução é subir esse tipo de filtro para a cláusula `ON`.
2. **O Fan-out no Join Triplo:** Ao cruzar as tabelas de veículos, ocorrências e inspeções, percebi a explosão de dados. O carro 1035 (que tinha 3 ocorrências e 2 inspeções) multiplicou para 6 linhas. Aprendi que fazer um `COUNT` simples nessa estrutura destrói a precisão dos dados, e a saída segura é usar `COUNT(DISTINCT)` ou pré-agregar usando uma CTE.
3. **A permissividade perigosa do GROUP BY no SQLite:** Em bancos como Postgres e MySQL em modo estrito, tentar exibir no `SELECT` uma coluna que não está no `GROUP BY` trava a query com um erro. O SQLite não dá erro: ele devolve um valor arbitrário do grupo de forma silenciosa. Aprendi que esse comportamento permissivo é pior que o erro explícito porque corrompe o dado sem avisar. A regra de ouro não muda: toda coluna do `SELECT` que não é agregação matemática precisa estar no `GROUP BY`.
4. **COUNT(*) vs COUNT(coluna):** A diferença é entre "contar linhas" e "contar valores presentes". `COUNT(*)` conta se a linha existe (e o veículo sem defeito gera uma linha no `LEFT JOIN`, sendo contada como 1). `COUNT(coluna)` ignora `NULL` naquela coluna e traz a métrica real ("0 ocorrências").
5. **O momento certo para o HAVING:** Tentei usar o `HAVING` para avaliar um ID, mas entendi que o `WHERE` filtra os dados antes de agrupar (na porta de entrada), enquanto o `HAVING` avalia o resultado da conta depois de o grupo ser formado (ex: `HAVING COUNT(...) > 1`).