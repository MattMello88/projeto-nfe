---
name: novo-script-banco-regras
description: >
  Revisa e produz scripts MySQL alinhados às regras do projeto (nomenclatura,
  tipos, FKs, índices, versionamento) e aponta implicações nas regras Delphi
  quando o script altera listagens, datas ou referências. Usar quando chegar
  novo arquivo em sql/, migration, CREATE/ALTER TABLE, pedido de validação de
  schema, ou alteração de banco antes de aplicar em MySQL.
---

# Novo script de banco — regras do projeto

## Quando aplicar

- Novo ou alterado script em `sql/` (ex.: `003_...sql`).
- Usuário cola `CREATE TABLE` / `ALTER TABLE` / `DROP` ou pede “revisa o script”.
- Script gerado a partir de XSD (combinar com a skill [analisar-xsd-mysql](../analisar-xsd-mysql/SKILL.md) se for o caso).

## Regra principal (obrigatória)

1. **Ler** a rule do repositório: [banco-dados.mdc](../../rules/banco-dados.mdc) (nomenclatura `snake_case` em inglês, tabelas no singular, `id`, `id_*` para FK, tipos, auditoria, índices, FK com nome de constraint, charset `utf8mb4`, scripts numerados).

2. **Validar o script** contra essa rule: apontar desvios e entregar **versão corrigida** ou lista de ajustes objetivos (não apenas “está ok”).

3. **Versionamento:** listar os arquivos existentes em `sql/` (Glob `sql/*.sql`) para determinar o próximo número da sequência. Nome final: `NNN_descricao.sql` na pasta `sql/`.

## Checklist rápido (MySQL)

- Tabela: singular, inglês, `PRIMARY KEY (id)` `INT UNSIGNED AUTO_INCREMENT`.
- Colunas: inglês; monetário `DECIMAL(15,2)`; data `DATE`/`DATETIME`; booleano `TINYINT(1)`; CPF/CNPJ `VARCHAR(14)` só dígitos.
- FK: `id_<tabela_referenciada>`, `CONSTRAINT fk_...`, `ON DELETE RESTRICT` salvo exceção justificada.
- `INDEX` em colunas de filtro/join/ordenação; `created_at` / `updated_at` conforme rule.
- `ENGINE=InnoDB`, `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci` na tabela (ou herdado do banco, se já padronizado).

## Regras Delphi relacionadas (avisar na revisão)

Use como **notas de implementação** na resposta ao usuário, sem substituir a rule SQL:

| Mudança no script | Rule a lembrar |
|-------------------|----------------|
| Nova coluna `id_*` (FK) | [delphi-lookup-referencias.mdc](../../rules/delphi-lookup-referencias.mdc) — tela com lookup de busca. |
| `DATE` / `DATETIME` / `TIMESTAMP` em entidade que terá **lista por período** | [delphi-filtro-data-abertura-tela.mdc](../../rules/delphi-filtro-data-abertura-tela.mdc) — filtro de data obrigatório ao abrir. |
| Cadastro mestre-detalhe no mesmo domínio | [delphi-ancestral-cadastro-master-detail.mdc](../../rules/delphi-ancestral-cadastro-master-detail.mdc) + [delphi-formulario-boas-praticas.mdc](../../rules/delphi-formulario-boas-praticas.mdc). |

## Saída esperada

- Resumo **conforme / não conforme** com a [banco-dados.mdc](../../rules/banco-dados.mdc).
- Script SQL revisado (bloco único ou diff conceitual) quando houver correções.
- Bullets curtos **“Impacto telas”** apenas quando FK ou colunas de data de listagem forem afetadas.
