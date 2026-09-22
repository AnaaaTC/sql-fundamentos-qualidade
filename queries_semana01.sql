### Query 1 — Anti-join: veículos sem nenhuma ocorrência registrada
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