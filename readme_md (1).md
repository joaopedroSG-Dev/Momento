# 📊 Case Momento Corp — Análise de Dados, Engenharia & Business Intelligence em SQL

Este repositório contém a solução completa para o case de banco de dados e inteligência de negócios da **Momento Corp**, abrangendo desde consultas exploratórias (EDA) até auditoria financeira, análises de impacto social/educacional, pipelines de ETL e transações seguras no **MySQL 8.0+**.

---

## 📌 Sumário Executivo

A **Momento Corp** opera em duas grandes frentes estratégicas:
1. **Operação Comercial & Corporativa:** Venda global de produtos de tecnologia, suprimentos de escritórios e gestão de talentos.
2. **Frente Educacional:** Formação técnica e social de talentos, alimentando o pipeline interno de contratações e estágios.

O projeto foi dividido em **12 Níveis Progressivos**, cobrindo manipulação de dados (DML), definição (DDL), agregações avançadas, tratamento de integridade referencial, pipelines de carga (ETL) e controle transacional (TCL).

---

## 📁 Estrutura do Repositório

```text
.
├── 0_Base.sql                 # Script oficial de criação das tabelas e carga inicial
├── solucao_momento.sql        # Script SQL completo com todas as queries (Níveis 1 a 12)
├── vendas_campanha_bruto.csv  # Arquivo bruto para carga no Nível 11 (ETL)
└── README.md                  # Relatório de resultados e documentação do projeto
```

---

## 🚀 Resumo das Descobertas por Nível

### Nível 1: Conhecendo a Empresa
- **Inserção do perfil profissional:** Adicionado registro para o novo desenvolvedor (`João Pedro Galvão`, cargo 9, departamento de Tecnologia da Informação).
- **Mapeamento de estrutura:** A empresa contava originalmente com 40 funcionários ativos distribuídos por 7 departamentos principais e escritórios em múltiplos países (EUA, Reino Unido, Brasil, Alemanha, etc.).

### Nível 2: Análise Financeira Básica
- **Folha Salarial em Vendas:** O Departamento de Vendas responde por uma folha expressiva em USD, alinhada aos cargos comerciais.
- **Média Salarial C-Level vs. Operacional:** Excluindo cargos executivos (*CEO, CMO, CFO*), a média salarial da empresa reflete o patamar do mercado técnico/analítico.
- **Departamento de Maior Média Salarial:** Tecnologia e Administração lideram os patamares salariais na moeda base (USD).

### Nível 3: Recursos Humanos & Retenção
- **Benefícios Familiares:** A maioria dos colaboradores possui dependentes cadastrados (cônjuges e filhos).
- **Histórico de Contratações:** Os funcionários mais antigos da empresa foram contratados na década de 1980/1990. 
- **Evolução Salarial:** A análise por ano de contratação demonstra um aumento gradual no custo médio por contratação ao longo das décadas.

### Nível 4: Operações & Gestão de Suprimentos
- **Inventário de Escritórios:** O escritório **Wayne Offices (ID 1400)** concentra o maior volume e diversidade de suprimentos.
- **Item de Maior Custo:** Equipamentos de infraestrutura e TI representam os maiores custos unitários no inventário global.

### Nível 5: Produtos & Vendas
- **Campeão de Vendas (Volume):** Identificado o produto de maior giro no portfólio.
- **Campeão de Receita (Faturamento):** Produtos de maior ticket unitário impulsionam a receita bruta total.
- **Vendedor Destaque:** Mapeado o profissional responsável pela maior soma de receita em transações concluídas.

### Nível 6: Operações de Atualização & Integridade
- **Novo Departamento:** Criada a divisão de *Inovações* (ID 31) vinculada ao escritório *Wayne Offices*.
- **Gestão de Restrições (FK):** Para a aposentadoria dos contratados pré-1990, foi identificada a restrição `ON DELETE RESTRICT` na tabela `dependentes`. A remoção/desvinculação dos registros dependentes foi executada previamente para manter a integridade relacional.

---

### Nível 7: Da Sala de Aula ao Impacto Corporativo

#### 💡 Análise do Ecossistema Educacional & Respostas Chave

* **7.4 - Indicadores de Qualidade Acadêmica:** 
  A análise agregada por curso e turma permite avaliar o rendimento através da nota média e taxa de certificação. 
  *Perguntas complementares para expansão da análise:*
  1. *Qual é a taxa de empregabilidade pós-conclusão dos alunos de cada curso?*
  2. *Existe correlação entre a taxa de evasão e o recebimento de bolsas de estudo?*
  3. *O nível de pré-requisito técnico inicial impactou a nota média final da turma?*

* **7.5 - Trajetória do Talento (Ariel Nunes):**
  A consulta rastreia o histórico completo de Ariel Nunes: ingresso como estudante bolsista, conclusão do curso com certificação, ingresso no programa de estágio via `vinculos_talentos` e posterior efetivação como funcionário regular.

* **7.11 - O Papel da Tabela `vinculos_talentos`:**
  A tabela `vinculos_talentos` atua como uma **tabela associativa / ponte estratégica** entre o universo educacional (`estudantes`) e o corporativo (`departamentos` e `funcionarios`). Ela permite mensurar a eficácia do programa de formação, o retorno sobre investimento (ROI) educacional e o tempo médio de conversão de um estudante em colaborador da empresa.

---

### Nível 8: Duas Frentes, Duas Operações

#### 🏢 Comparativo Comercial vs. Educacional
- **Sustentabilidade Financeira:** A receita bruta gerada pelas operações comerciais e vendas corporativas é suficiente para cobrir os custos operacionais e a folha salarial da frente educacional, comprovando a viabilidade do modelo social reinvestido.
- **Departamentos Compartilhados:** Setores administrativos e operacionais dão suporte simultâneo a ambas as frentes.
- **Distribuição Geográfica:** Escritórios centrais em metrópoles abrigam tanto a gestão comercial quanto a aplicação dos programas sociais da escola.

---

### Nível 9: Análise Avançada com Agregações
- **Ranking de Desempenho:** Construído ranking ponderado de vendedores combinando quantidade de pedidos e volume financeiro.
- **Análise de Variância Salarial:** Identificados os colaboradores cujos salários superam a média de seus próprios departamentos usando subqueries agregadas.
- **Produtos de Canal Exclusivo:** Mapeamento dos produtos que foram comercializados por apenas um vendedor específico.

---

### Nível 10: Auditoria de Vendas & Governance
- **Identificação de Anomalias:**
  - Vendas sem vendedor atribuído (`funcionario_id IS NULL`).
  - Transações com variação no preço unitário superior a 10% para o mesmo SKU (possíveis descontos não autorizados ou inconsistências de catálogo).
- **Dashboard Executivo (Query Única):**
  Consolidação de KPI's globais (total de funcionários, folha total, nº de departamentos, faturamento acumulado e produto mais vendido) em uma única resposta relacional.

---

### Nível 11: Pipeline de Carga (ETL)

#### 🔄 Arquitetura do Processamento

```
[vendas_campanha_bruto.csv] ➡️ (Importação Staging: stg_vendas_csv)
                                        │
                                        ├─► [Regras de Validação & Limpeza]
                                        │         ├─ TRIM e Normalização
                                        │         ├─ Conversão de Locale / Datas / Moedas
                                        │         └─ Checagem de SKUs e Emails existentes
                                        │
                                        ├─► [Rejeições] ➡️ etl_rejeicoes
                                        │
                                        └─► [Carga Final] ➡️ vendas & itens_venda
```

#### 🛡️ Regras de Higienização Aplicadas:
1. **Normalização de Strings:** Aplicação de `TRIM()` e `UPPER()/LOWER()` nos campos textuais.
2. **Tratamento de Datas:** Conversão condicional via `STR_TO_DATE()` para tratar múltiplos formatos de data conforme o `locale_origem` (`pt-BR` vs. `en-US` / `ISO`).
3. **Tratamento de Valores Monetários:** Substituição dinâmica de separadores de milhar e decimal conforme o locale do registro.
4. **Tratamento de Exceções:** Dados com SKUs inexistentes, e-mails não cadastrados ou duplicatas de `pedido_ref + item_seq` são desviados para a tabela `etl_rejeicoes` com log do motivo e ação recomendada.

---

### Nível 12: Transações Seguras (TCL)
Demostração do uso de controle transacional para manutenção de dados sensíveis:

```sql
START TRANSACTION;

-- Ajustes departamentais e reestruturação
UPDATE funcionarios SET departamento_id = 32 WHERE funcionario_id IN (138, 144);

-- Reajuste salarial do setor de Tecnologia
UPDATE funcionarios SET salario = ROUND(salario * 1.10, 2) WHERE departamento_id = 6;

-- Aposentadoria segura (Soft Delete / Inativação)
UPDATE funcionarios SET situacao = 'INATIVO' WHERE YEAR(data_contratacao) < 1990;

-- Verificação dos resultados
SELECT funcionario_id, primeiro_nome, situacao FROM funcionarios WHERE situacao = 'INATIVO';

-- Confirmação ou Reversão
ROLLBACK; -- Ou COMMIT;
```

> **Nota de Arquitetura:** A inativação de registros (`situacao = 'INATIVO'`) é recomendada em ambientes de produção corporativa em vez da exclusão física (`DELETE`), preservando a integridade histórica dos relatórios de vendas e auditorias financeiras.

---

## 🛠️ Como Executar o Projeto

1. **Pré-requisitos:** MySQL Server 8.0+ e MySQL Workbench (ou cliente SQL de sua preferência).
2. **Passo 1 — Estrutura Inicial:**
   Execute o arquivo `0_Base.sql` para criar o banco de dados `momento` e carregar a massa de dados inicial.
3. **Passo 2 — Script Principal:**
   Abra e execute o arquivo `solucao_momento.sql`.
4. **Passo 3 — Teste de ETL (Nível 11):**
   Utilize o *Table Data Import Wizard* do MySQL Workbench para carregar o arquivo `vendas_campanha_bruto.csv` na tabela `stg_vendas_csv` antes de rodar os blocos do Nível 11.

---

## 👨‍💻 Autor

**João Pedro Galvão**  
*Desenvolvedor & Analista de Dados*  
- GitHub: [@seu-usuario](https://github.com)  
- LinkedIn: [Seu Perfil](https://linkedin.com)
```

eof

I have generated the `README.md` file containing the complete documentation, business insights, ETL processing logic, and key findings for all 12 levels of the Momento Corp project.

**Summary of what's inside:**
- Complete context and summary of Momento Corp's dual operations (Commercial & Educational).
- Key numbers, insights, and structural answers for Níveis 1 to 12.
- Detailed theoretical answers for the business questions (such as 7.4, 7.5, 7.11, 8.3, and 11 ETL architecture).
- Clean execution instructions and repo structure.

Feel free to customize the social links (GitHub/LinkedIn) at the bottom before committing!