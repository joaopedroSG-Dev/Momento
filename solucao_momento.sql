-- ============================================================================
-- PROJETO MOMENTO — SOLUÇÃO COMPLETA SQL E ETL (NÍVEIS 1 A 12)
-- Autor: João Pedro Silva Galvão
-- SGBD: MySQL 8.0+
-- ============================================================================

USE momento;

-- ============================================================================
-- ETAPA 0 — EXPLORAÇÃO INICIAL (EDA)
-- ============================================================================
SHOW TABLES;
SELECT COUNT(*) AS total_funcionarios FROM funcionarios;
SELECT COUNT(*) AS total_vendas FROM vendas;
SELECT COUNT(*) AS total_produtos FROM produtos;


-- ============================================================================
-- NÍVEL 1: CONHECENDO A EMPRESA
-- ============================================================================

-- 1.1 Incluir você (João Pedro) no sistema
-- Departamento 6 = Tecnologia da Informação | Cargo 9 = Desenvolvedor Web (faixa: 4000 a 10000)
INSERT INTO funcionarios (
  funcionario_id, primeiro_nome, sobrenome, email, telefone, 
  data_contratacao, cargo_id, salario, moeda_salario, gerente_id, departamento_id, situacao
) VALUES (
  222, 'João Pedro', 'Galvão', 'joao.galvao@momento.org', '+55-11-99999-0000',
  CURDATE(), 9, 5500.00, 'USD', 103, 6, 'ATIVO'
);

-- 1.2 Total de funcionários na empresa
SELECT COUNT(*) AS total_funcionarios 
FROM funcionarios;

-- 1.3 Quantos funcionários trabalham especificamente no Departamento de Tecnologia?
SELECT COUNT(*) AS total_tecnologia
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Tecnologia da Informação';

-- 1.4 Liste todos os departamentos que existem na empresa. Quantos são?
SELECT departamento_id, departamento_nome, educacional, escritorio_id
FROM departamentos
ORDER BY departamento_nome;

SELECT COUNT(*) AS total_departamentos FROM departamentos;

-- 1.5 Quantos escritórios a Momento possui? Em quais países?
SELECT COUNT(*) AS total_escritorios FROM escritorios;

SELECT DISTINCT p.pais_id, p.pais_nome, COUNT(e.escritorio_id) AS qtd_escritorios
FROM escritorios e
JOIN paises p ON e.pais_id = p.pais_id
GROUP BY p.pais_id, p.pais_nome
ORDER BY qtd_escritorios DESC;


-- ============================================================================
-- NÍVEL 2: ANÁLISE FINANCEIRA BÁSICA
-- ============================================================================

-- 2.1 Quantos funcionários trabalham no Departamento de Vendas?
SELECT COUNT(*) AS total_vendas
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Vendas';

-- 2.2 Qual é o custo total com salários do Departamento de Vendas?
SELECT SUM(f.salario) AS custo_total_vendas
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Vendas';

-- 2.3 Média salarial da empresa, excluindo os cargos de CEO, CMO e CFO
SELECT ROUND(AVG(f.salario), 2) AS media_salarial_sem_c_level
FROM funcionarios f
JOIN cargos c ON f.cargo_id = c.cargo_id
WHERE c.cargo_nome NOT IN ('CEO', 'CMO', 'CFO');

-- 2.4 Média salarial do Departamento de Tecnologia
SELECT ROUND(AVG(f.salario), 2) AS media_salarial_tecnologia
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
WHERE d.departamento_nome = 'Tecnologia da Informação';

-- 2.5 Qual departamento possui a maior média salarial?
SELECT d.departamento_nome, f.moeda_salario, ROUND(AVG(f.salario), 2) AS media_salarial
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_id, d.departamento_nome, f.moeda_salario
ORDER BY media_salarial DESC
LIMIT 1;

-- 2.6 Qual departamento possui o menor número de funcionários?
SELECT d.departamento_nome, COUNT(f.funcionario_id) AS qtd_funcionarios
FROM departamentos d
LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY qtd_funcionarios ASC
LIMIT 1;


-- ============================================================================
-- NÍVEL 3: RECURSOS HUMANOS
-- ============================================================================

-- 3.1 Quantos funcionários da empresa Momento possuem cônjuges?
SELECT COUNT(DISTINCT funcionario_id) AS funcionarios_com_conjuge
FROM dependentes
WHERE relacionamento = 'Cônjuge';

-- 3.2 Quantos funcionários possuem filhos registrados?
SELECT COUNT(DISTINCT funcionario_id) AS funcionarios_com_filhos
FROM dependentes
WHERE relacionamento LIKE 'Filh%';

-- 3.3 Qual funcionário foi contratado há mais tempo na empresa?
SELECT funcionario_id, primeiro_nome, sobrenome, data_contratacao
FROM funcionarios
ORDER BY data_contratacao ASC
LIMIT 1;

-- 3.4 Qual funcionário foi contratado há menos tempo na empresa?
SELECT funcionario_id, primeiro_nome, sobrenome, data_contratacao
FROM funcionarios
ORDER BY data_contratacao DESC
LIMIT 1;

-- 3.5 Liste os 5 funcionários com mais tempo de casa, ordenados pela data de contratação
SELECT funcionario_id, primeiro_nome, sobrenome, data_contratacao
FROM funcionarios
ORDER BY data_contratacao ASC
LIMIT 5;

-- 3.6 Quantos funcionários foram contratados na década de 1990 (entre 1990-1999)?
SELECT COUNT(*) AS contratados_anos_90
FROM funcionarios
WHERE YEAR(data_contratacao) BETWEEN 1990 AND 1999;

-- 3.7 Evolução da média salarial por ano de contratação
SELECT YEAR(data_contratacao) AS ano_contratacao, 
       COUNT(*) AS qtd_contratados,
       ROUND(AVG(salario), 2) AS media_salarial
FROM funcionarios
GROUP BY YEAR(data_contratacao)
ORDER BY ano_contratacao ASC;


-- ============================================================================
-- NÍVEL 4: OPERAÇÕES E ESCRITÓRIOS
-- ============================================================================

-- 4.1 Custo total de suprimentos em cada escritório (do mais caro ao mais barato)
SELECT e.escritorio_nome, 
       SUM(s.quantidade_estoque * s.custo_unitario) AS custo_total_suprimentos
FROM escritorios e
JOIN suprimentos s ON e.escritorio_id = s.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome
ORDER BY custo_total_suprimentos DESC;

-- 4.2 Qual escritório possui a maior quantidade de diferentes tipos de suprimentos?
SELECT e.escritorio_nome, 
       COUNT(DISTINCT s.suprimento_nome) AS tipos_diferentes
FROM escritorios e
JOIN suprimentos s ON e.escritorio_id = s.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome
ORDER BY tipos_diferentes DESC;

-- 4.3 Qual é o suprimento mais caro (considerando preço unitário) em toda a empresa?
SELECT suprimento_id, suprimento_nome, custo_unitario, moeda, escritorio_id
FROM suprimentos
ORDER BY custo_unitario DESC
LIMIT 1;

-- 4.4 Valor total do inventário de suprimentos da empresa
SELECT SUM(quantidade_estoque * custo_unitario) AS valor_total_inventario
FROM suprimentos;


-- ============================================================================
-- NÍVEL 5: PRODUTOS E VENDAS
-- ============================================================================

-- 5.1 Quais produtos foram vendidos pela Momento? Liste todos os produtos únicos.
SELECT DISTINCT p.produto_id, p.sku, p.produto_nome
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
ORDER BY p.produto_nome;

-- 5.2 Qual é o produto mais vendido (maior quantidade total)?
SELECT p.produto_nome, SUM(iv.quantidade) AS total_unidades_vendidas
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.produto_nome
ORDER BY total_unidades_vendidas DESC
LIMIT 1;

-- 5.3 Qual é o produto menos vendido (entre os que tiveram venda)?
SELECT p.produto_nome, SUM(iv.quantidade) AS total_unidades_vendidas
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.produto_nome
ORDER BY total_unidades_vendidas ASC
LIMIT 1;

-- 5.4 Produto que gerou mais receita (quantidade × valor unitário)
SELECT p.produto_nome, SUM(iv.quantidade * iv.preco_unitario) AS receita_total
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.produto_nome
ORDER BY receita_total DESC
LIMIT 1;

-- 5.5 Produto mais caro (maior preço unitário) no catálogo
SELECT produto_id, sku, produto_nome, preco_catalogo, moeda
FROM produtos
ORDER BY preco_catalogo DESC
LIMIT 1;

-- 5.6 Faturamento total da empresa em vendas (considerando vendas não canceladas ou todas)
SELECT SUM(iv.quantidade * iv.preco_unitario) AS faturamento_total_geral,
       SUM(CASE WHEN v.status_venda = 'CONCLUIDA' THEN iv.quantidade * iv.preco_unitario ELSE 0 END) AS faturamento_concluido
FROM vendas v
JOIN itens_venda iv ON v.venda_id = iv.venda_id;

-- 5.7 Quantas vendas foram realizadas no mês de junho de 2023?
SELECT COUNT(*) AS vendas_junho_2023
FROM vendas
WHERE data_venda BETWEEN '2023-06-01' AND '2023-06-30';

-- 5.8 Qual vendedor realizou mais vendas (em quantidade de transações)?
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor,
       COUNT(v.venda_id) AS total_transacoes
FROM funcionarios f
JOIN vendas v ON f.funcionario_id = v.funcionario_id
GROUP BY f.funcionario_id, vendedor
ORDER BY total_transacoes DESC
LIMIT 1;

-- 5.9 Qual vendedor gerou mais receita para a empresa?
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor,
       SUM(iv.quantidade * iv.preco_unitario) AS receita_gerada
FROM funcionarios f
JOIN vendas v ON f.funcionario_id = v.funcionario_id
JOIN itens_venda iv ON v.venda_id = iv.venda_id
GROUP BY f.funcionario_id, vendedor
ORDER BY receita_gerada DESC
LIMIT 1;


-- ============================================================================
-- NÍVEL 6: OPERAÇÕES DE ATUALIZAÇÃO
-- ============================================================================

-- 6.1 Criar departamento "Inovações" no escritório "Wayne Offices" (escritorio_id = 1400)
INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id)
SELECT 31, 'Inovações', 0, escritorio_id
FROM escritorios
WHERE escritorio_nome = 'Wayne Offices';

-- 6.2 Transferir 2 funcionários de Tecnologia da Informação (id = 6) para Inovações (id = 31)
UPDATE funcionarios
SET departamento_id = 31
WHERE departamento_id = 6
ORDER BY funcionario_id DESC
LIMIT 2;

-- 6.3 Aumento de 10% para todos os funcionários do departamento de Tecnologia
UPDATE funcionarios
SET salario = ROUND(salario * 1.10, 2)
WHERE departamento_id = 6;

-- 6.4 Promover "Bruce Ernst" a "Senior Web Developer" (cargo_id = 26) e salário $5.000
UPDATE funcionarios
SET cargo_id = (SELECT cargo_id FROM cargos WHERE cargo_nome = 'Senior Web Developer'),
    salario = 5000.00
WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';

-- 6.5 Adicionar 15 unidades de "Headsets" a $150 no escritório "Wayne Offices"
INSERT INTO suprimentos (
  suprimento_id, referencia_compra, suprimento_nome, quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id
)
SELECT 106, 'PO-1400-08', 'Headsets', 15, 150.00, 'USD', CURDATE(), escritorio_id
FROM escritorios
WHERE escritorio_nome = 'Wayne Offices';

-- 6.6 Aposentadoria dos contratados antes de 1990
-- Passo 1: SELECT obrigatório para conferência
SELECT funcionario_id, primeiro_nome, sobrenome, data_contratacao 
FROM funcionarios 
WHERE YEAR(data_contratacao) < 1990;

-- Passo 2: Remover dependentes vinculados (ON DELETE RESTRICT)
DELETE FROM dependentes 
WHERE funcionario_id IN (SELECT funcionario_id FROM funcionarios WHERE YEAR(data_contratacao) < 1990);

-- Passo 3: Remover os funcionários contratados antes de 1990
DELETE FROM funcionarios 
WHERE YEAR(data_contratacao) < 1990;


-- ============================================================================
-- NÍVEL 7: DA SALA DE AULA AO IMPACTO CORPORATIVO
-- (Requer tabelas do módulo educacional: cursos, turmas, matriculas, estudantes, vinculos_talentos)
-- ============================================================================

-- 7.1 Cursos ativos, carga horária, nível e quantidade de turmas
SELECT c.curso_id, c.curso_nome, c.carga_horaria, c.nivel, COUNT(t.turma_id) AS total_turmas
FROM cursos c
LEFT JOIN turmas t ON c.curso_id = t.curso_id
WHERE c.ativo = 1
GROUP BY c.curso_id, c.curso_nome, c.carga_horaria, c.nivel;

-- 7.2 Turmas, curso, professores, capacidade e número de matrículas
SELECT t.turma_id, c.curso_nome, 
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS professor,
       t.capacidade, COUNT(m.matricula_id) AS total_matriculas
FROM turmas t
JOIN cursos c ON t.curso_id = c.curso_id
LEFT JOIN funcionarios f ON t.professor_id = f.funcionario_id
LEFT JOIN matriculas m ON t.turma_id = m.turma_id
GROUP BY t.turma_id, c.curso_nome, professor, t.capacidade;

-- 7.3 Estudantes com bolsa, percentual e cursos
SELECT c.curso_nome, m.percentual_bolsa, COUNT(m.matricula_id) AS qtd_bolsistas
FROM matriculas m
JOIN turmas t ON m.turma_id = t.turma_id
JOIN cursos c ON t.curso_id = c.curso_id
WHERE m.percentual_bolsa > 0
GROUP BY c.curso_nome, m.percentual_bolsa;

-- 7.4 Matrículas, concluintes, certificados e nota média por curso e turma
SELECT c.curso_nome, t.turma_id,
       COUNT(m.matricula_id) AS matriculas,
       SUM(CASE WHEN m.status = 'CONCLUIDO' THEN 1 ELSE 0 END) AS concluintes,
       SUM(CASE WHEN m.certificado_emitido = 1 THEN 1 ELSE 0 END) AS certificados,
       ROUND(AVG(m.nota_final), 2) AS nota_media
FROM cursos c
JOIN turmas t ON c.curso_id = t.curso_id
LEFT JOIN matriculas m ON t.turma_id = m.turma_id
GROUP BY c.curso_nome, t.turma_id;

-- 7.5 Trajetória de Ariel Nunes
SELECT e.nome_estudante, c.curso_nome, t.turma_id, m.status AS status_matricula,
       m.percentual_bolsa, vt.tipo_vinculo, vt.status AS status_vinculo, f.data_contratacao
FROM estudantes e
JOIN matriculas m ON e.estudante_id = m.estudante_id
JOIN turmas t ON m.turma_id = t.turma_id
JOIN cursos c ON t.curso_id = c.curso_id
LEFT JOIN vinculos_talentos vt ON e.estudante_id = vt.estudante_id
LEFT JOIN funcionarios f ON vt.funcionario_id = f.funcionario_id
WHERE e.nome_estudante LIKE '%Ariel Nunes%';

-- 7.6 Vínculos de talentos e contagem de estágios vs. contratações
SELECT e.nome_estudante, vt.tipo_vinculo, d.departamento_nome, vt.status,
       CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_associado
FROM vinculos_talentos vt
JOIN estudantes e ON vt.estudante_id = e.estudante_id
JOIN departamentos d ON vt.departamento_id = d.departamento_id
LEFT JOIN funcionarios f ON vt.funcionario_id = f.funcionario_id;

SELECT tipo_vinculo, COUNT(DISTINCT estudante_id) AS qtd_pessoas
FROM vinculos_talentos
GROUP BY tipo_vinculo;

-- 7.7 Departamentos que recebem talentos da escola
SELECT DISTINCT d.departamento_id, d.departamento_nome
FROM vinculos_talentos vt
JOIN departamentos d ON vt.departamento_id = d.departamento_id;

-- 7.8 Consulta única consolidada do impacto educacional
SELECT 
  (SELECT COUNT(*) FROM estudantes) AS total_alunos,
  (SELECT COUNT(*) FROM matriculas WHERE status = 'ATIVA') AS matriculas_ativas,
  (SELECT COUNT(*) FROM matriculas WHERE status = 'CONCLUIDO') AS concluintes,
  (SELECT COUNT(*) FROM matriculas WHERE percentual_bolsa > 0) AS bolsas_concedidas,
  (SELECT COUNT(*) FROM vinculos_talentos WHERE tipo_vinculo = 'ESTAGIO') AS estagios,
  (SELECT COUNT(*) FROM vinculos_talentos WHERE funcionario_id IS NOT NULL) AS contratacoes,
  (SELECT COUNT(DISTINCT departamento_id) FROM vinculos_talentos) AS departamentos_receptores;


-- ============================================================================
-- NÍVEL 8: DUAS FRENTES, DUAS OPERAÇÕES
-- ============================================================================

-- 8.1 Custo de manter a frente educacional vs. operação comercial
SELECT 
  CASE WHEN d.educacional = 1 THEN 'Educacional' ELSE 'Comercial / Corporativo' END AS frente,
  d.departamento_nome,
  f.moeda_salario,
  SUM(f.salario) AS folha_salarial_mensal,
  COALESCE(sup.custo_suprimentos, 0) AS custo_suprimentos_escritorio
FROM departamentos d
LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
LEFT JOIN (
  SELECT escritorio_id, SUM(quantidade_estoque * custo_unitario) AS custo_suprimentos
  FROM suprimentos
  GROUP BY escritorio_id
) sup ON d.escritorio_id = sup.escritorio_id
GROUP BY frente, d.departamento_id, d.departamento_nome, f.moeda_salario, sup.custo_suprimentos
ORDER BY frente, folha_salarial_mensal DESC;

-- 8.2 Escritórios que concentram equipes comerciais vs. equipes da escola
SELECT e.escritorio_nome, p.pais_nome,
       SUM(CASE WHEN d.educacional = 0 THEN 1 ELSE 0 END) AS deptos_comerciais,
       SUM(CASE WHEN d.educacional = 1 THEN 1 ELSE 0 END) AS deptos_educacionais
FROM escritorios e
JOIN paises p ON e.pais_id = p.pais_id
LEFT JOIN departamentos d ON e.escritorio_id = d.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome, p.pais_nome
ORDER BY deptos_educacionais DESC, deptos_comerciais DESC;

-- 8.3 A receita das vendas consegue sustentar investimentos educacionais?
SELECT 
  (SELECT SUM(iv.quantidade * iv.preco_unitario) 
   FROM vendas v JOIN itens_venda iv ON v.venda_id = iv.venda_id 
   WHERE v.status_venda = 'CONCLUIDA') AS receita_vendas_usd,
  (SELECT SUM(salario) FROM funcionarios f 
   JOIN departamentos d ON f.departamento_id = d.departamento_id 
   WHERE d.educacional = 1 AND f.moeda_salario = 'USD') AS folha_edu_usd;

-- 8.4 Cargos e departamentos compartilhados pelas duas frentes
SELECT d.departamento_nome
FROM departamentos d
GROUP BY d.departamento_nome
HAVING COUNT(DISTINCT d.educacional) > 1;

SELECT c.cargo_nome
FROM cargos c
JOIN funcionarios f ON c.cargo_id = f.cargo_id
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY c.cargo_id, c.cargo_nome
HAVING COUNT(DISTINCT d.educacional) > 1;

-- 8.5 Expansão internacional: vendas, equipes e projeto educacional por país/região
SELECT r.regiao_nome, p.pais_nome,
       COUNT(DISTINCT e.escritorio_id) AS escritorios,
       COUNT(DISTINCT f.funcionario_id) AS funcionarios,
       SUM(CASE WHEN d.educacional = 1 THEN 1 ELSE 0 END) AS funcionarios_escola
FROM regioes r
JOIN paises p ON r.regiao_id = p.regiao_id
JOIN escritorios e ON p.pais_id = e.pais_id
LEFT JOIN departamentos d ON e.escritorio_id = d.escritorio_id
LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
GROUP BY r.regiao_nome, p.pais_nome
ORDER BY funcionarios DESC;


-- ============================================================================
-- NÍVEL 9: ANÁLISE AVANÇADA COM AGREGAÇÕES
-- ============================================================================

-- 9.1 Relatório por departamento: nome, nº funcionários, salário total e média salarial
SELECT d.departamento_id, d.departamento_nome,
       COUNT(f.funcionario_id) AS num_funcionarios,
       COALESCE(SUM(f.salario), 0) AS salario_total,
       COALESCE(ROUND(AVG(f.salario), 2), 0) AS media_salarial
FROM departamentos d
LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY salario_total DESC;

-- 9.2 Os 3 cargos mais comuns na empresa e quantos funcionários ocupam cada cargo
SELECT c.cargo_nome, COUNT(f.funcionario_id) AS qtd_funcionarios
FROM cargos c
JOIN funcionarios f ON c.cargo_id = f.cargo_id
GROUP BY c.cargo_id, c.cargo_nome
ORDER BY qtd_funcionarios DESC
LIMIT 3;

-- 9.3 Funcionários que ganham acima da média salarial de seus respectivos departamentos
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario,
       d.departamento_nome, f.salario,
       ROUND(media_dep.media_salarial, 2) AS media_departamento
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
JOIN (
  SELECT departamento_id, AVG(salario) AS media_salarial
  FROM funcionarios
  GROUP BY departamento_id
) media_dep ON f.departamento_id = media_dep.departamento_id
WHERE f.salario > media_dep.media_salarial
ORDER BY d.departamento_nome, f.salario DESC;

-- 9.4 Taxa de crescimento da empresa por ano (contratações por ano)
SELECT YEAR(data_contratacao) AS ano,
       COUNT(*) AS novas_contratacoes,
       SUM(COUNT(*)) OVER (ORDER BY YEAR(data_contratacao)) AS acumulado_funcionarios
FROM funcionarios
GROUP BY YEAR(data_contratacao)
ORDER BY ano;

-- 9.5 Ranking dos vendedores: nome, número de vendas realizadas e receita total gerada
SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor,
       COUNT(DISTINCT v.venda_id) AS numero_vendas,
       SUM(iv.quantidade * iv.preco_unitario) AS receita_total
FROM funcionarios f
JOIN vendas v ON f.funcionario_id = v.funcionario_id
JOIN itens_venda iv ON v.venda_id = iv.venda_id
GROUP BY f.funcionario_id, vendedor
ORDER BY receita_total DESC;

-- 9.6 Produtos que foram vendidos por apenas um vendedor
SELECT p.produto_id, p.sku, p.produto_nome,
       MIN(CONCAT(f.primeiro_nome, ' ', f.sobrenome)) AS unico_vendedor
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
JOIN vendas v ON iv.venda_id = v.venda_id
JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
GROUP BY p.produto_id, p.sku, p.produto_nome
HAVING COUNT(DISTINCT v.funcionario_id) = 1;


-- ============================================================================
-- NÍVEL 10: AUDITORIA DE VENDAS
-- ============================================================================

-- 10.1 Vendas que não possuem vendedor associado
SELECT * 
FROM vendas 
WHERE funcionario_id IS NULL;

-- 10.2 Vendedores registrados nas vendas que não existem na coleção de funcionários
SELECT v.*
FROM vendas v
LEFT JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
WHERE f.funcionario_id IS NULL;

-- 10.3 Produtos nas vendas com preços unitários variando > 10% entre transações
SELECT p.produto_id, p.sku, p.produto_nome,
       MIN(iv.preco_unitario) AS menor_preco_vendido,
       MAX(iv.preco_unitario) AS maior_preco_vendido,
       ROUND(((MAX(iv.preco_unitario) - MIN(iv.preco_unitario)) / MIN(iv.preco_unitario)) * 100, 2) AS variacao_percentual
FROM produtos p
JOIN itens_venda iv ON p.produto_id = iv.produto_id
GROUP BY p.produto_id, p.sku, p.produto_nome
HAVING ((MAX(iv.preco_unitario) - MIN(iv.preco_unitario)) / MIN(iv.preco_unitario)) > 0.10
ORDER BY variacao_percentual DESC;

-- 10.4 Dashboard Executivo completo em UMA ÚNICA query de agregação
SELECT
  (SELECT COUNT(*) FROM funcionarios) AS total_funcionarios,
  (SELECT SUM(salario) FROM funcionarios) AS custo_total_salarios,
  (SELECT COUNT(*) FROM departamentos) AS numero_departamentos,
  (SELECT COUNT(*) FROM escritorios) AS numero_escritorios,
  (SELECT SUM(quantidade * preco_unitario) FROM itens_venda) AS receita_total_vendas,
  (SELECT p.produto_nome 
   FROM produtos p JOIN itens_venda iv ON p.produto_id = iv.produto_id 
   GROUP BY p.produto_id, p.produto_nome 
   ORDER BY SUM(iv.quantidade) DESC LIMIT 1) AS produto_mais_vendido;


-- ============================================================================
-- NÍVEL 11: ETL DO CSV (stg_vendas_csv -> vendas, itens_venda, etl_rejeicoes)
-- ============================================================================

-- 2a. Registrar duplicatas exatas ou conflitos de mesmo pedido_ref + item_seq
INSERT INTO etl_rejeicoes (rejeicao_id, source_row_id, campo, valor_original, motivo, acao)
SELECT 
  ROW_NUMBER() OVER (ORDER BY s1.source_row_id) + COALESCE((SELECT MAX(rejeicao_id) FROM etl_rejeicoes), 0),
  s1.source_row_id,
  'pedido_ref / item_seq',
  CONCAT(COALESCE(s1.pedido_ref,'NULL'), '-', COALESCE(s1.item_seq,'NULL')),
  'Linha duplicada ou conflitante para o mesmo pedido e item',
  'DUPLICATA'
FROM stg_vendas_csv s1
JOIN stg_vendas_csv s2 
  ON TRIM(s1.pedido_ref) = TRIM(s2.pedido_ref) 
  AND TRIM(s1.item_seq) = TRIM(s2.item_seq)
  AND s1.source_row_id > s2.source_row_id;

-- 2b. Registrar SKUs desconhecidos
INSERT INTO etl_rejeicoes (rejeicao_id, source_row_id, campo, valor_original, motivo, acao)
SELECT 
  ROW_NUMBER() OVER (ORDER BY s.source_row_id) + COALESCE((SELECT MAX(rejeicao_id) FROM etl_rejeicoes), 0),
  s.source_row_id,
  'sku_raw',
  s.sku_raw,
  'SKU não encontrado na tabela produtos',
  'REJEITAR'
FROM stg_vendas_csv s
LEFT JOIN produtos p ON UPPER(TRIM(s.sku_raw)) = p.sku
WHERE p.produto_id IS NULL
  AND s.source_row_id NOT IN (SELECT source_row_id FROM etl_rejeicoes);

-- 2c. Registrar vendedores sem correspondência
INSERT INTO etl_rejeicoes (rejeicao_id, source_row_id, campo, valor_original, motivo, acao)
SELECT 
  ROW_NUMBER() OVER (ORDER BY s.source_row_id) + COALESCE((SELECT MAX(rejeicao_id) FROM etl_rejeicoes), 0),
  s.source_row_id,
  'email_vendedor_raw',
  s.email_vendedor_raw,
  'E-mail do vendedor não encontrado em funcionarios',
  'REJEITAR'
FROM stg_vendas_csv s
LEFT JOIN funcionarios f ON LOWER(TRIM(s.email_vendedor_raw)) = LOWER(f.email)
WHERE f.funcionario_id IS NULL
  AND s.source_row_id NOT IN (SELECT source_row_id FROM etl_rejeicoes);

-- 2d. Registrar locale ausente, moeda inválida, quantidade <= 0 ou preço/data inválidos
INSERT INTO etl_rejeicoes (rejeicao_id, source_row_id, campo, valor_original, motivo, acao)
SELECT 
  ROW_NUMBER() OVER (ORDER BY s.source_row_id) + COALESCE((SELECT MAX(rejeicao_id) FROM etl_rejeicoes), 0),
  s.source_row_id,
  'validacao_geral',
  CONCAT('locale:', COALESCE(s.locale_origem,'NULL'), ' | qtd:', COALESCE(s.quantidade_raw,'NULL'), ' | preco:', COALESCE(s.preco_unitario_raw,'NULL')),
  'Locale não identificado, moeda ausente, quantidade não positiva ou preço malformado',
  'REVISAR'
FROM stg_vendas_csv s
WHERE s.source_row_id NOT IN (SELECT source_row_id FROM etl_rejeicoes)
  AND (
    TRIM(COALESCE(s.locale_origem, '')) = ''
    OR TRIM(COALESCE(s.moeda_raw, '')) NOT REGEXP '^[A-Za-z]{3}$'
    OR CAST(TRIM(s.quantidade_raw) AS SIGNED) <= 0
    OR REPLACE(REPLACE(TRIM(s.preco_unitario_raw), '.', ''), ',', '.') NOT REGEXP '^[0-9]+(\.[0-9]+)?$'
  );

-- Passo 3 (Load): Carregar pedidos válidos em `vendas` e linhas válidas em `itens_venda`
INSERT IGNORE INTO vendas (venda_id, referencia_origem, data_venda, funcionario_id, canal, status_venda)
SELECT 
  ROW_NUMBER() OVER (ORDER BY MIN(s.source_row_id)) + (SELECT COALESCE(MAX(venda_id), 7000) FROM vendas),
  TRIM(s.pedido_ref),
  CASE 
    WHEN TRIM(s.locale_origem) IN ('pt-BR', 'pt_BR', 'en-GB', 'fr-FR') THEN STR_TO_DATE(TRIM(s.data_venda_raw), '%d/%m/%Y')
    ELSE STR_TO_DATE(TRIM(s.data_venda_raw), '%Y-%m-%d')
  END,
  f.funcionario_id,
  CASE UPPER(TRIM(s.canal_raw))
    WHEN 'LOJA' THEN 'LOJA'
    WHEN 'WEB' THEN 'WEB'
    WHEN 'APP' THEN 'APP'
    WHEN 'MARKETPLACE' THEN 'MARKETPLACE'
    ELSE 'B2B'
  END,
  CASE UPPER(TRIM(s.status_raw))
    WHEN 'CONCLUIDA' THEN 'CONCLUIDA'
    WHEN 'CANCELADA' THEN 'CANCELADA'
    ELSE 'PENDENTE'
  END
FROM stg_vendas_csv s
JOIN funcionarios f ON LOWER(TRIM(s.email_vendedor_raw)) = LOWER(f.email)
WHERE s.source_row_id NOT IN (SELECT source_row_id FROM etl_rejeicoes)
GROUP BY TRIM(s.pedido_ref), s.locale_origem, s.data_venda_raw, f.funcionario_id, s.canal_raw, s.status_raw;

INSERT INTO itens_venda (item_venda_id, venda_id, numero_item, produto_id, quantidade, preco_unitario, moeda, source_row_id)
SELECT 
  ROW_NUMBER() OVER (ORDER BY s.source_row_id) + (SELECT COALESCE(MAX(item_venda_id), 0) FROM itens_venda),
  v.venda_id,
  CAST(TRIM(s.item_seq) AS UNSIGNED),
  p.produto_id,
  CAST(TRIM(s.quantidade_raw) AS UNSIGNED),
  CASE 
    WHEN TRIM(s.locale_origem) IN ('pt-BR', 'pt_BR', 'fr-FR', 'de-DE') 
      THEN CAST(REPLACE(REPLACE(TRIM(s.preco_unitario_raw), '.', ''), ',', '.') AS DECIMAL(10,2))
    ELSE CAST(REPLACE(TRIM(s.preco_unitario_raw), ',', '') AS DECIMAL(10,2))
  END,
  UPPER(TRIM(s.moeda_raw)),
  s.source_row_id
FROM stg_vendas_csv s
JOIN vendas v ON TRIM(s.pedido_ref) = v.referencia_origem
JOIN produtos p ON UPPER(TRIM(s.sku_raw)) = p.sku
WHERE s.source_row_id NOT IN (SELECT source_row_id FROM etl_rejeicoes);


-- ============================================================================
-- NÍVEL 12: ALTERAÇÕES SEGURAS COM TRANSAÇÕES
-- ============================================================================

START TRANSACTION;

-- 1. Criar um departamento novo em um escritório existente (Wayne Offices = 1400)
INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id)
VALUES (32, 'Engenharia de Plataforma', 0, 1400);

-- 2. Cadastrar/garantir o cargo "Senior Web Developer" e promover Bruce Ernst
INSERT IGNORE INTO cargos (cargo_id, cargo_nome, min_salario, max_salario)
VALUES (26, 'Senior Web Developer', 7000.00, 16000.00);

UPDATE funcionarios
SET cargo_id = 26, salario = 8500.00
WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';

-- 3. Transferir 2 pessoas de Tecnologia (id = 6) para o novo departamento (id = 32)
UPDATE funcionarios
SET departamento_id = 32
WHERE funcionario_id IN (138, 144);

-- 4. Reajustar salários em +10% de quem permanecer em Tecnologia (id = 6)
UPDATE funcionarios
SET salario = ROUND(salario * 1.10, 2)
WHERE departamento_id = 6;

-- 5. Adicionar compra de headsets com quantidade, custo unitário, moeda, data e referência
INSERT INTO suprimentos (
  suprimento_id, referencia_compra, suprimento_nome, quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id
) VALUES (
  107, 'PO-1400-99', 'Headsets Noise Cancelling', 20, 150.00, 'USD', CURDATE(), 1400
);

-- 6. Simular aposentadoria alterando o status para 'INATIVO', sem apagar o funcionário nem histórico
UPDATE funcionarios
SET situacao = 'INATIVO'
WHERE YEAR(data_contratacao) < 1990;

-- Conferência antes de confirmar
SELECT funcionario_id, primeiro_nome, sobrenome, cargo_id, departamento_id, salario, situacao
FROM funcionarios
WHERE departamento_id IN (6, 32) OR situacao = 'INATIVO';

-- Troque ROLLBACK por COMMIT após validar o SELECT acima
ROLLBACK;
-- COMMIT;
