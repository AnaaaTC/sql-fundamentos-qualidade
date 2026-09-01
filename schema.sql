PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS ocorrencias_qfs;
DROP TABLE IF EXISTS inspecoes_ncbs;
DROP TABLE IF EXISTS veiculos;

CREATE TABLE veiculos (
    id_veiculo INTEGER PRIMARY KEY,
    modelo TEXT NOT NULL,
    linha_producao TEXT NOT NULL,
    data_producao DATE NOT NULL
);

CREATE TABLE ocorrencias_qfs (
    id_ocorrencia INTEGER PRIMARY KEY,
    id_veiculo INTEGER NOT NULL,
    severidade TEXT NOT NULL,
    descricao TEXT,
    data DATE,
    
    FOREIGN KEY (id_veiculo)
        REFERENCES veiculos(id_veiculo)
);

CREATE TABLE inspecoes_ncbs (
    id_inspecao INTEGER PRIMARY KEY,
    id_veiculo INTEGER NOT NULL,
    resultado TEXT NOT NULL,
    inspetor TEXT,
    data DATE,
    
    FOREIGN KEY (id_veiculo)
        REFERENCES veiculos(id_veiculo)
);

INSERT INTO veiculos
(id_veiculo, modelo, linha_producao, data_producao)
VALUES
(1001, 'Modelo A', 'Linha 1', '2026-07-01'),
(1002, 'Modelo B', 'Linha 1', '2026-07-01'),
(1003, 'Modelo C', 'Linha 1', '2026-07-02'),
(1004, 'Modelo D', 'Linha 1', '2026-07-02'),
(1005, 'Modelo A', 'Linha 2', '2026-07-03'),
(1006, 'Modelo B', 'Linha 2', '2026-07-03'),
(1007, 'Modelo C', 'Linha 2', '2026-07-04'),
(1008, 'Modelo D', 'Linha 2', '2026-07-04'),
(1009, 'Modelo A', 'Linha 3', '2026-07-05'),
(1010, 'Modelo B', 'Linha 3', '2026-07-05'),

(1011, 'Modelo C', 'Linha 3', '2026-07-06'),
(1012, 'Modelo D', 'Linha 3', '2026-07-06'),
(1013, 'Modelo A', 'Linha 1', '2026-07-07'),
(1014, 'Modelo B', 'Linha 1', '2026-07-07'),
(1015, 'Modelo C', 'Linha 1', '2026-07-08'),
(1016, 'Modelo D', 'Linha 1', '2026-07-08'),
(1017, 'Modelo A', 'Linha 2', '2026-07-09'),
(1018, 'Modelo B', 'Linha 2', '2026-07-09'),
(1019, 'Modelo C', 'Linha 2', '2026-07-10'),
(1020, 'Modelo D', 'Linha 2', '2026-07-10'),

(1021, 'Modelo A', 'Linha 3', '2026-07-11'),
(1022, 'Modelo B', 'Linha 3', '2026-07-11'),
(1023, 'Modelo C', 'Linha 3', '2026-07-12'),
(1024, 'Modelo D', 'Linha 3', '2026-07-12'),
(1025, 'Modelo A', 'Linha 1', '2026-07-13'),
(1026, 'Modelo B', 'Linha 1', '2026-07-13'),
(1027, 'Modelo C', 'Linha 1', '2026-07-14'),
(1028, 'Modelo D', 'Linha 1', '2026-07-14'),
(1029, 'Modelo A', 'Linha 2', '2026-07-15'),
(1030, 'Modelo B', 'Linha 2', '2026-07-15'),

(1031, 'Modelo C', 'Linha 2', '2026-07-16'),
(1032, 'Modelo D', 'Linha 2', '2026-07-16'),
(1033, 'Modelo A', 'Linha 3', '2026-07-17'),
(1034, 'Modelo B', 'Linha 3', '2026-07-17'),
(1035, 'Modelo C', 'Linha 3', '2026-07-18'),
(1036, 'Modelo D', 'Linha 3', '2026-07-18'),
(1037, 'Modelo A', 'Linha 1', '2026-07-19'),
(1038, 'Modelo B', 'Linha 1', '2026-07-19'),
(1039, 'Modelo C', 'Linha 2', '2026-07-20'),
(1040, 'Modelo D', 'Linha 3', '2026-07-20');

INSERT INTO ocorrencias_qfs
(id_ocorrencia, id_veiculo, severidade, descricao, data)
VALUES
(1, 1001, 'Alta', 'Falha no acabamento da porta', '2026-07-01'),
(2, 1001, 'Media', 'Ruído durante fechamento', '2026-07-02'),
(3, 1002, 'Baixa', 'Pequena variação visual', '2026-07-02'),
(4, 1003, 'Alta', 'Falha no sistema de iluminação', '2026-07-03'),
(5, 1004, 'Media', 'Desalinhamento do painel', '2026-07-03'),

(6, 1005, 'Baixa', 'Risco superficial no acabamento', '2026-07-04'),
(7, 1006, 'Alta', 'Falha no encaixe do componente', '2026-07-04'),
(8, 1007, 'Media', 'Ruído interno', '2026-07-05'),
(9, 1008, 'Baixa', NULL, '2026-07-05'),
(10, 1009, 'Alta', 'Falha de montagem', '2026-07-06'),

(11, 1010, 'Media', 'Vibração durante operação', '2026-07-06'),
(12, 1011, 'Baixa', 'Pequena imperfeição visual', '2026-07-07'),
(13, 1012, 'Alta', 'Falha no acabamento externo', '2026-07-07'),
(14, 1013, 'Media', 'Desalinhamento da porta', '2026-07-08'),
(15, 1014, 'Baixa', 'Ruído no painel', NULL),

(16, 1015, 'Alta', 'Falha de encaixe', '2026-07-09'),
(17, 1016, 'Media', 'Variação no acabamento', '2026-07-09'),
(18, 1017, 'Baixa', 'Pequena marca superficial', '2026-07-10'),
(19, 1018, 'Alta', 'Falha de montagem', '2026-07-10'),
(20, 1019, 'Media', 'Ruído durante fechamento', '2026-07-11'),

(21, 1020, 'Baixa', 'Desalinhamento visual', '2026-07-11'),
(22, 1021, 'Alta', 'Falha no componente interno', '2026-07-12'),
(23, 1022, 'Media', 'Vibração excessiva', '2026-07-12'),
(24, 1023, 'Baixa', 'Pequena variação de acabamento', '2026-07-13'),
(25, 1024, 'Alta', 'Falha no processo de montagem', '2026-07-13'),

(26, 1025, 'Media', 'Ruído interno', '2026-07-14'),
(27, 1026, 'Baixa', 'Imperfeição superficial', '2026-07-14'),
(28, 1027, 'Alta', 'Falha no encaixe', '2026-07-15'),
(29, 1028, 'Media', 'Desalinhamento do painel', '2026-07-15'),
(30, 1029, 'Baixa', 'Pequena marca no acabamento', '2026-07-16'),

(31, 1030, 'Alta', 'Falha de montagem', '2026-07-16'),
(32, 1031, 'Media', 'Ruído durante operação', '2026-07-17'),
(33, 1032, 'Baixa', 'Variação visual', '2026-07-17'),

-- Ocorrências adicionais para criar múltiplos registros por veículo
(34, 1002, 'Media', 'Ruído identificado novamente', '2026-07-18'),
(35, 1003, 'Baixa', 'Pequena variação no acabamento', '2026-07-18'),
(36, 1005, 'Alta', 'Novo problema de montagem', '2026-07-19'),
(37, 1007, 'Baixa', 'Marca superficial adicional', '2026-07-19'),
(38, 1010, 'Alta', 'Falha recorrente de montagem', '2026-07-20'),
(39, 1012, 'Media', NULL, '2026-07-20'),
(40, 1015, 'Baixa', 'Variação visual adicional', '2026-07-21'),
(41, 1018, 'Alta', 'Falha recorrente', '2026-07-21'),
(42, 1020, 'Media', 'Ruído identificado novamente', '2026-07-22'),
(43, 1022, 'Baixa', 'Pequena imperfeição', '2026-07-22'),
(44, 1024, 'Alta', 'Falha de encaixe recorrente', '2026-07-23'),
(45, 1026, 'Media', 'Desalinhamento adicional', '2026-07-23'),
(46, 1028, 'Baixa', 'Marca superficial', '2026-07-24'),
(47, 1030, 'Alta', 'Falha adicional de montagem', '2026-07-24'),
(48, 1031, 'Media', 'Ruído adicional', '2026-07-25'),
(49, 1004, 'Baixa', 'Pequena imperfeição', '2026-07-25'),
(50, 1006, 'Media', 'Variação adicional', '2026-07-26')

--Adição de novos dados / tarefa semana 1: 
(51, 1035, 'Crítica', 'Motor parou comigo na rua', '2026-09-01'),
(52, 1035, 'Crítica', 'Bateria descarregou comigo na BR', '2026-09-01'),
(53, 1035, 'Crítica', 'Mesmo trancando o carro as portas continuam abertas', '2026-09-01');


INSERT INTO inspecoes_ncbs
(id_inspecao, id_veiculo, resultado, inspetor, data)
VALUES
(1, 1001, 'Aprovado', 'Carlos', '2026-07-01'),
(2, 1002, 'Aprovado', 'Marina', '2026-07-02'),
(3, 1003, 'Reprovado', NULL, '2026-07-03'),
(4, 1004, 'Aprovado', 'João', '2026-07-04'),
(5, 1005, 'Aprovado', 'Carlos', NULL),

(6, 1006, 'Reprovado', 'Marina', '2026-07-05'),
(7, 1007, 'Aprovado', 'João', '2026-07-06'),
(8, 1008, 'Aprovado', NULL, '2026-07-06'),
(9, 1009, 'Reprovado', 'Carlos', '2026-07-07'),
(10, 1010, 'Aprovado', 'Marina', '2026-07-07'),

(11, 1011, 'Aprovado', 'João', '2026-07-08'),
(12, 1012, 'Reprovado', NULL, '2026-07-08'),
(13, 1013, 'Aprovado', 'Carlos', '2026-07-09'),
(14, 1014, 'Aprovado', 'Marina', NULL),
(15, 1015, 'Reprovado', 'João', '2026-07-10'),

(16, 1016, 'Aprovado', 'Carlos', '2026-07-10'),
(17, 1017, 'Aprovado', NULL, '2026-07-11'),
(18, 1018, 'Reprovado', 'Marina', '2026-07-11'),
(19, 1019, 'Aprovado', 'João', '2026-07-12'),
(20, 1020, 'Aprovado', 'Carlos', '2026-07-12'),

(21, 1021, 'Reprovado', 'Marina', '2026-07-13'),
(22, 1022, 'Aprovado', 'João', '2026-07-13'),
(23, 1023, 'Aprovado', NULL, '2026-07-14'),
(24, 1024, 'Reprovado', 'Carlos', '2026-07-14'),
(25, 1025, 'Aprovado', 'Marina', '2026-07-15'),

(26, 1026, 'Aprovado', 'João', '2026-07-15'),
(27, 1027, 'Reprovado', 'Carlos', NULL),
(28, 1028, 'Aprovado', 'Marina', '2026-07-16'),
(29, 1029, 'Aprovado', 'João', '2026-07-17'),
(30, 1030, 'Reprovado', NULL, '2026-07-17')

--Adição de novos dados / tarefa semana 1: 
(31, 1035, 'Reprovado', NULL, '2026-09-01'),
(32, 1035, 'Aprovado', 'Ana', '2026-09-01'),
(33, 1033, 'Aprovado', 'Marcelo', '2026-09-01');



