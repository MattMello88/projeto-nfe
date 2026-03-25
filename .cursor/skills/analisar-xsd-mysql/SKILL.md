---
name: analisar-xsd-mysql
description: >
  Analisa qualquer arquivo XSD (schema XML) e verifica no banco de dados MySQL
  se as tabelas correspondentes existem, gerando scripts SQL de CREATE TABLE ou
  ALTER TABLE com base na estrutura encontrada no schema. Use esta skill quando
  o usuário fornecer um arquivo XSD, XML schema, schema de nota fiscal, ou pedir
  para "criar tabelas a partir do XSD", "analisar schema XML", "gerar banco de
  dados a partir de XSD", "mapear XSD para SQL", "importar estrutura XML para
  banco", ou mencionar NF-e, CT-e, MDF-e, SPED, ou qualquer outro schema XML
  fiscal/empresarial.
---

# Analisar XSD → MySQL

## Workflow

```
- [ ] 1. Ler o arquivo XSD fornecido pelo usuário
- [ ] 2. Interpretar a estrutura: identificar entidades (complexType/sequence)
- [ ] 3. Mapear cada entidade para um nome de tabela e suas colunas
- [ ] 4. Usar MCP MySQL para listar tabelas existentes
- [ ] 5. Para cada tabela: verificar se existe e quais colunas tem
- [ ] 6. Gerar CREATE TABLE (ausentes) e/ou ALTER TABLE (colunas faltando)
- [ ] 7. Apresentar resultado estruturado com scripts prontos
```

> O MCP MySQL é **somente leitura** — gere scripts para o usuário executar.

---

## Passo 1 — Ler o XSD

Quando o usuário fornecer o caminho do XSD, leia o arquivo com a ferramenta Read.
Se o XSD incluir outros schemas (`xs:include` / `xs:import`), leia os arquivos
referenciados que contenham os tipos usados pelas entidades principais.

Ignore schemas auxiliares de assinatura digital (ex: `xmldsig-core-schema*.xsd`).

---

## Passo 2 — Interpretar a estrutura do XSD

### Regras de interpretação

**Identificar entidades → tabelas:**
- Cada `xs:element` com `xs:complexType` aninhado com múltiplos filhos = **candidato a tabela**
- Elementos com `maxOccurs > 1` (ou `unbounded`) = **tabela separada** com FK para o pai
- Elementos simples dentro de um `xs:complexType` = **colunas** dessa tabela
- Atributos (`xs:attribute`) = **colunas** da mesma tabela
- `xs:choice` entre elementos = colunas separadas (todas nullable, exceto a obrigatória)

**Hierarquia → relação entre tabelas:**
```
Elemento pai (complexType com filhos)     → tabela_pai
  └─ Elemento filho (complexType)         → tabela_filho  (FK: id_tabela_pai)
       └─ Elemento neto (maxOccurs > 1)   → tabela_neto   (FK: id_tabela_filho)
```

**Elementos com `minOccurs="0"` = coluna nullable (`NULL`).**
**Elementos sem `minOccurs` ou `minOccurs="1"` = coluna NOT NULL.**

### Como nomear tabelas e colunas

> Siga as convenções definidas na rule [banco-dados.mdc](../../rules/banco-dados.mdc) para nomenclatura, tipos e padrões obrigatórios.

---

## Passo 3 — Mapear tipos XSD para MySQL

| Tipo XSD / Padrão                        | Tipo MySQL              | Observação                        |
|------------------------------------------|-------------------------|-----------------------------------|
| `xs:string` maxLength ≤ 20               | `VARCHAR(n)`            | usar maxLength exato              |
| `xs:string` maxLength 21–255             | `VARCHAR(n)`            | usar maxLength exato              |
| `xs:string` maxLength > 255 ou sem limite| `TEXT`                  |                                   |
| `xs:string` pattern `[0-9]{n}` fixo      | `CHAR(n)`               | tamanho fixo                      |
| `xs:integer` / `xs:int`                  | `INT`                   |                                   |
| `xs:long` / `xs:unsignedLong`            | `BIGINT`                |                                   |
| `xs:boolean`                             | `TINYINT(1)`            | 0/1                               |
| `xs:decimal` / tipo `TDec_1302`          | `DECIMAL(15,2)`         | financeiro padrão                 |
| tipo `TDec_1104v` (qtd 4 dec)            | `DECIMAL(15,4)`         | quantidades                       |
| tipo `TDec_1110v` (val unit 10 dec)      | `DECIMAL(21,10)`        | valor unitário                    |
| tipo `TDec_1203` (peso 3 dec)            | `DECIMAL(15,3)`         | pesos/medidas                     |
| tipo `TDec_0302a04` (alíq 4 dec)         | `DECIMAL(7,4)`          | alíquotas                         |
| `xs:date` / tipo `TData`                 | `DATE`                  |                                   |
| `xs:dateTime` / tipo `TDateTimeUTC`      | `DATETIME`              |                                   |
| `xs:enumeration` com valores numéricos   | `TINYINT`               | add COMMENT com valores           |
| `xs:enumeration` com valores string      | `VARCHAR(n)`            |                                   |
| `TCnpj` (pattern 14 dígitos)             | `VARCHAR(14)`           |                                   |
| `TCpf` (pattern 11 dígitos)              | `VARCHAR(11)`           |                                   |
| `TCodMunIBGE` (7 dígitos)                | `VARCHAR(7)`            |                                   |
| `TCodUfIBGE`                             | `TINYINT`               |                                   |
| `TUf` / `TUfEmi`                         | `CHAR(2)`               |                                   |
| `TIe` / inscrições estaduais             | `VARCHAR(14)`           |                                   |

**Quando o tipo for um `xs:simpleType` definido globalmente**, leia a definição
e aplique as regras acima conforme o `xs:restriction base` e `xs:pattern/maxLength`.

---

## Passo 4 — Verificar banco MySQL (MCP)

server: projeto-nfe

| Ferramenta       | Uso                                          | Parâmetros obrigatórios |
|------------------|----------------------------------------------|--------------------------|
| `list_tables`    | Listar todas as tabelas do banco             | nenhum                   |
| `describe_table` | Ver colunas e tipos de uma tabela            | `table` (string)         |
| `execute_query`  | Executar SELECT/SHOW/DESCRIBE/EXPLAIN        | `query` (string)         |

> `execute_query` é **somente leitura** — não executa DDL (CREATE/ALTER/DROP).

### 4.1 — Para cada tabela mapeada: verificar se existe e seu schema

- Se retornar **erro** → tabela não existe → gerar **CREATE TABLE**
- Se retornar schema → comparar colunas → gerar **ALTER TABLE** para as faltando

### 4.2 — Detectar colunas faltando

Compare a lista de colunas esperadas (mapeadas do XSD) com as retornadas pelo
`describe_table`. Ignore diferenças de case. Colunas presentes no banco mas
ausentes no XSD → **não remover** (preservar dados existentes).

---

## Passo 5 — Gerar Scripts SQL

### Template CREATE TABLE

```sql
CREATE TABLE IF NOT EXISTS <prefixo_entidade> (
  id           INT          AUTO_INCREMENT PRIMARY KEY,
  id_<pai>     INT          NOT NULL          COMMENT 'FK → tabela_pai',
  -- colunas mapeadas do XSD
  nome_coluna  VARCHAR(60)  NOT NULL          COMMENT 'tagXSD: xNome',
  outra_col    DECIMAL(15,2) NULL             COMMENT 'tagXSD: vProd',
  created_at   DATETIME     DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_fk_<pai> (id_<pai>)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='<descrição da xs:documentation>';
```

### Template ALTER TABLE

```sql
ALTER TABLE <tabela>
  ADD COLUMN <coluna> <tipo> <null/not null> COMMENT 'tagXSD: <nome_original>' AFTER <coluna_anterior>;
```

### Regras obrigatórias

- Usar `CREATE TABLE IF NOT EXISTS` e `ALTER TABLE ... ADD COLUMN`
- Incluir `COMMENT` com o nome original da tag XSD sempre que o nome da coluna divergir
- Adicionar `INDEX` em todas as colunas FK
- Separar scripts por grupo: primeiro todos os CREATE, depois todos os ALTER
- Seguir convenções da rule `banco-dados.mdc`

---

## Passo 6 — Apresentar Resultado

```markdown
## Resultado da Análise do Schema

**Arquivo XSD:** nome_do_arquivo.xsd
**Entidades identificadas:** N tabelas

### Status por tabela

| Tabela              | Status      | Ação necessária              |
|---------------------|-------------|------------------------------|
| `prefixo_entidade`  | ❌ Ausente  | CREATE TABLE                 |
| `prefixo_outra`     | ✅ Existe   | ALTER TABLE (N colunas)      |
| `prefixo_terceira`  | ✅ Completa | Nenhuma                      |

---

### Scripts SQL

#### Criar tabelas
```sql
-- scripts CREATE TABLE aqui
```

#### Alterar tabelas existentes
```sql
-- scripts ALTER TABLE aqui
```

> Execute os scripts no seu cliente MySQL para sincronizar o banco.
```

---
