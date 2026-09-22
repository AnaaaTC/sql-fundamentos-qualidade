# Semana 2 — Subqueries, Correlated Subqueries e CTEs

Projeto de estudo com banco fictício inspirado em sistemas de qualidade automotiva.

## Contexto

Esta semana avança para o uso de subconsultas, distinção entre consultas correlacionadas e não correlacionadas, além de modularização de código com Common Table Expressions (CTEs) encadeadas.

## As Queries da Semana 2

### Query 1 — Subquery Não Correlacionada: Veículos acima da média geral da frota
**O problema que resolve:** Isolar os chassis que possuem um volume de falhas superior à média de ocorrências por veículo de toda a fábrica.
**Por que foi escrita daquele jeito:** Utiliza uma subquery independente aninhada no `HAVING`. Como ela é não correlacionada, o SGBD calcula a média matemática uma única vez e utiliza o resultado estático para filtrar a consulta principal, garantindo alta performance.
```sql
SELECT 
    v.id_veiculo,
    v.modelo,
    COUNT(o.id_ocorrencia) AS total_ocorrencias
FROM veiculos v
JOIN ocorrencias_qfs o 
    ON v.id_veiculo = o.id_veiculo
GROUP BY 
    v.id_veiculo, 
    v.modelo
HAVING COUNT(o.id_ocorrencia) > (
    SELECT AVG(contagem_por_carro) 
    FROM (
        SELECT COUNT(id_ocorrencia) AS contagem_por_carro 
        FROM ocorrencias_qfs 
        GROUP BY id_veiculo
    )
);
```
---
### Query 2 — Subquery Correlacionada: Data da ocorrência mais recente por veículo
**O problema que resolve:** Enriquecer o cadastro base de cada veículo anexando a data exata do problema mais recente registrado.
**Por que foi escrita daquele jeito:** Emprega uma subquery correlacionada diretamente no `SELECT`, fazendo referência ao ID da linha externa (`o.id_veiculo = v.id_veiculo`). Embora processe linha a linha, é a forma mais limpa de trazer atributos agregados temporais sem colapsar a volumetria da frota.
```sql
SELECT 
    v.id_veiculo,
    v.modelo,
    v.linha_producao,
    (
        SELECT MAX(o.data)
        FROM ocorrencias_qfs o
        WHERE o.id_veiculo = v.id_veiculo
    ) AS ultima_data_ocorrencia
FROM veiculos v;
```
---
### Query 3 — CTE (Common Table Expression): Refatoração modular da média geral
**O problema que resolve:** Isolar a complexidade de agrupamento e contagem em uma etapa intermediária nomeada para limpar o código principal.
**Por que foi escrita daquele jeito:** Substitui subqueries aninhadas complexas por uma estrutura linear utilizando `WITH`. Ela funciona como uma tabela temporária lógica, tornando a leitura do script totalmente sequencial e muito mais fácil de manter a longo prazo.
```sql
WITH ocorrencias_por_veiculo AS (
    SELECT 
        v.id_veiculo,
        v.modelo,
        COUNT(o.id_ocorrencia) AS total_ocorrencias
    FROM veiculos v
    JOIN ocorrencias_qfs o 
        ON v.id_veiculo = o.id_veiculo
    GROUP BY 
        v.id_veiculo, 
        v.modelo
)
SELECT 
    id_veiculo,
    modelo,
    total_ocorrencias
FROM ocorrencias_por_veiculo
WHERE total_ocorrencias > (
    SELECT AVG(total_ocorrencias) 
    FROM ocorrencias_por_veiculo
);
```
# Semana 2 — Subqueries, Correlated Subqueries e CTEs

Projeto de estudo com banco fictício inspirado em sistemas de qualidade automotiva.

## Contexto

Esta semana avança para o uso de subconsultas, distinção entre consultas correlacionadas e não correlacionadas, além de modularização de código com Common Table Expressions (CTEs) encadeadas.

## As Queries da Semana 2

### Query 1 — Subquery Não Correlacionada: Veículos acima da média geral da frota
**O problema que resolve:** Isolar os chassis que possuem um volume de falhas superior à média de ocorrências por veículo de toda a fábrica.
**Por que foi escrita daquele jeito:** Utiliza uma subquery independente aninhada no `HAVING`. Como ela é não correlacionada, o SGBD calcula a média matemática uma única vez e utiliza o resultado estático para filtrar a consulta principal, garantindo alta performance.
```sql
SELECT 
    v.id_veiculo,
    v.modelo,
    COUNT(o.id_ocorrencia) AS total_ocorrencias
FROM veiculos v
JOIN ocorrencias_qfs o 
    ON v.id_veiculo = o.id_veiculo
GROUP BY 
    v.id_veiculo, 
    v.modelo
HAVING COUNT(o.id_ocorrencia) > (
    SELECT AVG(contagem_por_carro) 
    FROM (
        SELECT COUNT(id_ocorrencia) AS contagem_por_carro 
        FROM ocorrencias_qfs 
        GROUP BY id_veiculo
    )
);
```
---
### Query 2 — Subquery Correlacionada: Data da ocorrência mais recente por veículo
**O problema que resolve:** Enriquecer o cadastro base de cada veículo anexando a data exata do problema mais recente registrado.
**Por que foi escrita daquele jeito:** Emprega uma subquery correlacionada diretamente no `SELECT`, fazendo referência ao ID da linha externa (`o.id_veiculo = v.id_veiculo`). Embora processe linha a linha, é a forma mais limpa de trazer atributos agregados temporais sem colapsar a volumetria da frota.
```sql
SELECT 
    v.id_veiculo,
    v.modelo,
    v.linha_producao,
    (
        SELECT MAX(o.data)
        FROM ocorrencias_qfs o
        WHERE o.id_veiculo = v.id_veiculo
    ) AS ultima_data_ocorrencia
FROM veiculos v;
```
---
### Query 3 — CTE (Common Table Expression): Refatoração modular da média geral
**O problema que resolve:** Isolar a complexidade de agrupamento e contagem em uma etapa intermediária nomeada para limpar o código principal.
**Por que foi escrita daquele jeito:** Substitui subqueries aninhadas complexas por uma estrutura linear utilizando `WITH`. Ela funciona como uma tabela temporária lógica, tornando a leitura do script totalmente sequencial e muito mais fácil de manter a longo prazo.
```sql
WITH ocorrencias_por_veiculo AS (
    SELECT 
        v.id_veiculo,
        v.modelo,
        COUNT(o.id_ocorrencia) AS total_ocorrencias
    FROM veiculos v
    JOIN ocorrencias_qfs o 
        ON v.id_veiculo = o.id_veiculo
    GROUP BY 
        v.id_veiculo, 
        v.modelo
)
SELECT 
    id_veiculo,
    modelo,
    total_ocorrencias
FROM ocorrencias_por_veiculo
WHERE total_ocorrencias > (
    SELECT AVG(total_ocorrencias) 
    FROM ocorrencias_por_veiculo
);
```
---
### Query 4 — CTEs Encadeadas: Comparação com a média do próprio modelo
**O problema que resolve:** Identificar veículos que ultrapassam a média de falhas específica da sua categoria/modelo, e não da fábrica inteira.
**Por que foi escrita daquele jeito:** Utiliza múltiplas CTEs encadeadas (`total_por_veiculo` alimentando `media_por_modelo`), demonstrando o uso real de pipelines intermediários onde uma CTE consulta a outra diretamente.
```sql
WITH total_por_veiculo AS (
    SELECT 
        v.id_veiculo,
        v.modelo,
        COUNT(o.id_ocorrencia) AS total_ocorrencias
    FROM veiculos v
    JOIN ocorrencias_qfs o 
        ON v.id_veiculo = o.id_veiculo
    GROUP BY 
        v.id_veiculo, 
        v.modelo
),
media_por_modelo AS (
    SELECT 
        modelo,
        AVG(total_ocorrencias) AS media_modelo
    FROM total_por_veiculo
    GROUP BY modelo
)
SELECT 
    t.id_veiculo,
    t.modelo,
    t.total_ocorrencias,
    m.media_modelo
FROM total_por_veiculo t
JOIN media_por_modelo m 
    ON t.modelo = m.modelo
WHERE t.total_ocorrencias > m.media_modelo
ORDER BY t.modelo, t.total_ocorrencias DESC;
```
---
### Query 5 — LEFT JOIN & CASE WHEN: Classificação de Faixas de Risco da Frota
**O problema que resolve:** Classificar toda a frota em faixas de risco operacional com base na contagem de ocorrências por veículo, garantindo a exibição de 100% dos chassis.
**Por que foi escrita daquele jeito:** Utiliza um LEFT JOIN para preservar os veículos perfeitos sem falhas, um CASE WHEN no SELECT para traduzir volumetria em regras de negócio claras, e o alias ordenado no ORDER BY para evitar repetições desnecessárias de código mantendo a prioridade analítica.
```sql
SELECT 
    v.id_veiculo,
    v.modelo,
    v.linha_producao,
    COUNT(o.id_ocorrencia) AS total_ocorrencias,
    CASE 
        WHEN COUNT(o.id_ocorrencia) = 0 THEN '1. Sem Risco (Frota Saudável)'
        WHEN COUNT(o.id_ocorrencia) BETWEEN 1 AND 2 THEN '2. Risco Moderado'
        ELSE '3. Risco Crítico (Reincidente)'
    END AS faixa_risco
FROM veiculos v
LEFT JOIN ocorrencias_qfs o 
    ON v.id_veiculo = o.id_veiculo
GROUP BY 
    v.id_veiculo,
    v.modelo,
    v.linha_producao
ORDER BY 
    faixa_risco,
    total_ocorrencias DESC;
```