-- =====================================================================
-- SEMANA 2 — Subqueries, Correlated Subqueries e CTEs
-- =====================================================================

-- Query 1 — Subquery Não Correlacionada: Veículos acima da média geral da frota
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


-- Query 2 — Subquery Correlacionada: Data da ocorrência mais recente por veículo
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


-- Query 3 — CTE (Common Table Expression): Refatoração modular da média geral
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


-- Query 4 — CTEs Encadeadas: Veículos com mais ocorrências que a média do próprio modelo
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


-- Query 5 — LEFT JOIN & CASE WHEN: Classificação de Faixas de Risco da Frota
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