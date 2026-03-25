-- =============================================================================
-- NF-e v4.00 — Migração a partir da estrutura v3.10
-- Schema: nfe_v4.00.xsd / leiauteNFe_v4.00.xsd
-- Principais NTs: NT2016.002, NT2017.001, NT2018.005, NT2020.006,
--                 NT2021.002, NT2023.001, NT2023.004, NT2024.003
-- Padrão: banco-dados.mdc (snake_case EN, utf8mb4)
-- =============================================================================
-- INSTRUÇÕES: Execute este script APÓS o 001_create_nfe.sql (v3.10)
-- Todas as tabelas base já existem — este script apenas adiciona
-- colunas novas e cria as novas tabelas exigidas pela v4.00.
-- =============================================================================


-- ─────────────────────────────────────────────────────────────────────────────
-- SEÇÃO 1 — ALTER TABLE em tabelas existentes
-- ─────────────────────────────────────────────────────────────────────────────

-- 1.1  nfe_ide — novos campos v4.00
-- Removido: indPag (mantido para compatibilidade retroativa — não excluir)
ALTER TABLE nfe_ide
  ADD COLUMN d_prev_entrega  DATE         NULL COMMENT 'tagXSD: dPrevEntrega — previsão de entrega'
                                               AFTER dh_sai_ent,
  ADD COLUMN cod_mun_fg_ibs  CHAR(7)      NULL COMMENT 'tagXSD: cMunFGIBS — município FG do IBS/CBS'
                                               AFTER cod_mun_fg,
  ADD COLUMN tp_nf_debito    VARCHAR(2)   NULL COMMENT 'tagXSD: tpNFDebito — tipo de nota de débito'
                                               AFTER fin_nfe,
  ADD COLUMN tp_nf_credito   VARCHAR(2)   NULL COMMENT 'tagXSD: tpNFCredito — tipo de nota de crédito'
                                               AFTER tp_nf_debito,
  ADD COLUMN ind_intermed    TINYINT(1)   NULL COMMENT 'tagXSD: indIntermed — 0=própria;1=marketplace'
                                               AFTER ind_pres;


-- 1.2  nfe_nf_ref — novo tipo de referência (refNFeSig)
ALTER TABLE nfe_nf_ref
  ADD COLUMN ref_nfe_sig  CHAR(44)  NULL COMMENT 'tagXSD: refNFeSig — NF-e com assinatura'
                                         AFTER ref_nfe;


-- 1.3  nfe_det — novo campo vItem
ALTER TABLE nfe_det
  ADD COLUMN v_item  DECIMAL(15,2)  NULL COMMENT 'tagXSD: vItem — valor do item (v4.00)'
                                         AFTER v_tot_trib;


-- 1.4  nfe_det_prod — novos campos v4.00
ALTER TABLE nfe_det_prod
  ADD COLUMN c_barra           VARCHAR(30)  NULL COMMENT 'tagXSD: cBarra — código de barras'
                                                 AFTER c_ean,
  ADD COLUMN ind_escala        CHAR(1)      NULL COMMENT 'tagXSD: indEscala — S=produção escala relevante; N=não'
                                                 AFTER cest,
  ADD COLUMN cnpj_fab          VARCHAR(14)  NULL COMMENT 'tagXSD: CNPJFab — CNPJ do fabricante (escala não relevante)'
                                                 AFTER ind_escala,
  ADD COLUMN c_benef           VARCHAR(10)  NULL COMMENT 'tagXSD: cBenef — código do benefício fiscal'
                                                 AFTER cnpj_fab,
  ADD COLUMN tp_cred_pres_ibs  VARCHAR(2)   NULL COMMENT 'tagXSD: tpCredPresIBSZFM — tipo crédito presumido IBS ZFM'
                                                 AFTER c_benef,
  ADD COLUMN c_barra_trib      VARCHAR(30)  NULL COMMENT 'tagXSD: cBarraTrib — código de barras tributável'
                                                 AFTER c_ean_trib,
  ADD COLUMN ind_bem_mov_usado TINYINT(1)   NULL COMMENT 'tagXSD: indBemMovelUsado — 1=bem móvel usado'
                                                 AFTER ind_tot;


-- 1.5  nfe_det_imposto_icms — campos FCP e Monofásico (v4.00)
ALTER TABLE nfe_det_imposto_icms
  -- FCP no ICMS próprio (ICMS00, ICMS51, ICMS70, ICMS90)
  ADD COLUMN p_fcp              DECIMAL(7,4)   NULL COMMENT 'tagXSD: pFCP — alíq FCP'           AFTER v_icms,
  ADD COLUMN v_fcp              DECIMAL(15,2)  NULL COMMENT 'tagXSD: vFCP'                       AFTER p_fcp,
  -- FCP ST
  ADD COLUMN v_bc_fcp_st        DECIMAL(15,2)  NULL COMMENT 'tagXSD: vBCFCPST'                   AFTER v_icms_st,
  ADD COLUMN p_fcp_st           DECIMAL(7,4)   NULL COMMENT 'tagXSD: pFCPST'                     AFTER v_bc_fcp_st,
  ADD COLUMN v_fcp_st           DECIMAL(15,2)  NULL COMMENT 'tagXSD: vFCPST'                     AFTER p_fcp_st,
  -- FCP ST retido (ICMS60, ICMSST, ICMSSN500)
  ADD COLUMN v_bc_fcp_st_ret    DECIMAL(15,2)  NULL COMMENT 'tagXSD: vBCFCPSTRet'                AFTER v_fcp_st,
  ADD COLUMN p_fcp_st_ret       DECIMAL(7,4)   NULL COMMENT 'tagXSD: pFCPSTRet'                  AFTER v_bc_fcp_st_ret,
  ADD COLUMN v_fcp_st_ret       DECIMAL(15,2)  NULL COMMENT 'tagXSD: vFCPSTRet'                  AFTER p_fcp_st_ret,
  -- Desoneração com dedução e ST desoneração
  ADD COLUMN ind_deduz_deson    TINYINT(1)     NULL COMMENT 'tagXSD: indDeduzDeson — deduzir deson do total'  AFTER mot_des_icms,
  ADD COLUMN v_icms_st_deson    DECIMAL(15,2)  NULL COMMENT 'tagXSD: vICMSSTDeson'               AFTER ind_deduz_deson,
  ADD COLUMN mot_des_icms_st    TINYINT        NULL COMMENT 'tagXSD: motDesICMSST'                AFTER v_icms_st_deson,
  -- Efetivo (ICMS60, ICMSST, ICMSSN500) — cálculo efetivo do ICMS
  ADD COLUMN p_red_bc_efet      DECIMAL(7,4)   NULL COMMENT 'tagXSD: pRedBCEfet'                 AFTER v_icms_uf_remet,
  ADD COLUMN v_bc_efet          DECIMAL(15,2)  NULL COMMENT 'tagXSD: vBCEfet'                    AFTER p_red_bc_efet,
  ADD COLUMN p_icms_efet        DECIMAL(7,4)   NULL COMMENT 'tagXSD: pICMSEfet'                  AFTER v_bc_efet,
  ADD COLUMN v_icms_efet        DECIMAL(15,2)  NULL COMMENT 'tagXSD: vICMSEfet'                  AFTER p_icms_efet,
  -- ST substituto e pST
  ADD COLUMN v_icms_substituto  DECIMAL(15,2)  NULL COMMENT 'tagXSD: vICMSSubstituto'             AFTER v_icms_st_ret,
  ADD COLUMN p_st               DECIMAL(7,4)   NULL COMMENT 'tagXSD: pST — ICMSST/ICMSSN500'     AFTER v_icms_substituto,
  -- cBenefRBC — ICMS51
  ADD COLUMN c_benef_rbc        VARCHAR(10)    NULL COMMENT 'tagXSD: cBenefRBC — ICMS51'          AFTER p_red_bc,
  -- Monofásico — ICMS02, ICMS53, ICMS61
  ADD COLUMN ad_rem_icms        DECIMAL(7,4)   NULL COMMENT 'tagXSD: adRemICMS — alíq rem ICMS Mono' AFTER v_icms,
  ADD COLUMN q_bc_mono          DECIMAL(15,4)  NULL COMMENT 'tagXSD: qBCMono'                    AFTER ad_rem_icms,
  ADD COLUMN v_icms_mono        DECIMAL(15,2)  NULL COMMENT 'tagXSD: vICMSMono'                  AFTER q_bc_mono,
  ADD COLUMN v_icms_mono_op     DECIMAL(15,2)  NULL COMMENT 'tagXSD: vICMSMonoOp — ICMS53'       AFTER v_icms_mono,
  ADD COLUMN v_icms_mono_dif    DECIMAL(15,2)  NULL COMMENT 'tagXSD: vICMSMonoDif — ICMS53'      AFTER v_icms_mono_op,
  ADD COLUMN q_bc_mono_dif      DECIMAL(15,4)  NULL COMMENT 'tagXSD: qBCMonoDif — ICMS53'        AFTER v_icms_mono_dif,
  ADD COLUMN ad_rem_icms_dif    DECIMAL(7,4)   NULL COMMENT 'tagXSD: adRemICMSDif — ICMS53'      AFTER q_bc_mono_dif,
  ADD COLUMN q_bc_mono_ret      DECIMAL(15,4)  NULL COMMENT 'tagXSD: qBCMonoRet — ICMS61'        AFTER ad_rem_icms_dif,
  ADD COLUMN ad_rem_icms_ret    DECIMAL(7,4)   NULL COMMENT 'tagXSD: adRemICMSRet — ICMS61'      AFTER q_bc_mono_ret,
  ADD COLUMN v_icms_mono_ret    DECIMAL(15,2)  NULL COMMENT 'tagXSD: vICMSMonoRet — ICMS61'      AFTER ad_rem_icms_ret,
  -- FCP no ICMS51 (Diferimento)
  ADD COLUMN v_bc_fcp           DECIMAL(15,2)  NULL COMMENT 'tagXSD: ICMS51/vBCFCP'              AFTER v_fcp,
  ADD COLUMN p_fcp_dif          DECIMAL(7,4)   NULL COMMENT 'tagXSD: ICMS51/pFCPDif'             AFTER v_bc_fcp,
  ADD COLUMN v_fcp_dif          DECIMAL(15,2)  NULL COMMENT 'tagXSD: ICMS51/vFCPDif'             AFTER p_fcp_dif,
  ADD COLUMN v_fcp_efet         DECIMAL(15,2)  NULL COMMENT 'tagXSD: ICMS51/vFCPEfet'            AFTER v_fcp_dif;


-- 1.6  nfe_total — campos FCP, Monofásico e vIPIDevol / vNFTot (v4.00)
ALTER TABLE nfe_total
  ADD COLUMN v_fcp              DECIMAL(15,2)  NOT NULL DEFAULT 0 COMMENT 'tagXSD: ICMSTot/vFCP'
                                                                  AFTER v_icms_deson,
  ADD COLUMN v_fcp_st           DECIMAL(15,2)  NOT NULL DEFAULT 0 COMMENT 'tagXSD: ICMSTot/vFCPST'
                                                                  AFTER v_st,
  ADD COLUMN v_fcp_st_ret       DECIMAL(15,2)  NOT NULL DEFAULT 0 COMMENT 'tagXSD: ICMSTot/vFCPSTRet'
                                                                  AFTER v_fcp_st,
  ADD COLUMN q_bc_mono          DECIMAL(15,2)  NULL              COMMENT 'tagXSD: ICMSTot/qBCMono'
                                                                  AFTER v_fcp_st_ret,
  ADD COLUMN v_icms_mono        DECIMAL(15,2)  NULL              COMMENT 'tagXSD: ICMSTot/vICMSMono'
                                                                  AFTER q_bc_mono,
  ADD COLUMN q_bc_mono_reten    DECIMAL(15,2)  NULL              COMMENT 'tagXSD: ICMSTot/qBCMonoReten'
                                                                  AFTER v_icms_mono,
  ADD COLUMN v_icms_mono_reten  DECIMAL(15,2)  NULL              COMMENT 'tagXSD: ICMSTot/vICMSMonoReten'
                                                                  AFTER q_bc_mono_reten,
  ADD COLUMN q_bc_mono_ret      DECIMAL(15,2)  NULL              COMMENT 'tagXSD: ICMSTot/qBCMonoRet'
                                                                  AFTER v_icms_mono_reten,
  ADD COLUMN v_icms_mono_ret    DECIMAL(15,2)  NULL              COMMENT 'tagXSD: ICMSTot/vICMSMonoRet'
                                                                  AFTER q_bc_mono_ret,
  ADD COLUMN v_ipi_devol        DECIMAL(15,2)  NOT NULL DEFAULT 0 COMMENT 'tagXSD: ICMSTot/vIPIDevol'
                                                                  AFTER v_ipi,
  ADD COLUMN v_nf_tot           DECIMAL(15,2)  NULL              COMMENT 'tagXSD: vNFTot — valor total NF-e com IBS/CBS'
                                                                  AFTER v_tot_trib;


-- 1.7  nfe_pag — campos adicionais do detPag v4.00 e vTroco
-- Na v4.00 o pag/detPag substituiu o array pag[]. Adicionamos os novos campos
-- de detPag (ind_pag volta como optional dentro de detPag) e o troco.
ALTER TABLE nfe_pag
  ADD COLUMN ind_pag         TINYINT(1)   NULL COMMENT 'tagXSD: detPag/indPag — 0=à vista;1=a prazo'
                                               AFTER id_nfe,
  ADD COLUMN x_pag           VARCHAR(60)  NULL COMMENT 'tagXSD: detPag/xPag — descrição do meio de pagamento'
                                               AFTER t_pag,
  ADD COLUMN d_pag           DATE         NULL COMMENT 'tagXSD: detPag/dPag — data de pagamento'
                                               AFTER v_pag,
  ADD COLUMN cnpj_pag        VARCHAR(14)  NULL COMMENT 'tagXSD: detPag/CNPJPag — CNPJ do beneficiário'
                                               AFTER d_pag,
  ADD COLUMN uf_pag          CHAR(2)      NULL COMMENT 'tagXSD: detPag/UFPag — UF do beneficiário'
                                               AFTER cnpj_pag,
  ADD COLUMN card_cnpj_receb VARCHAR(14)  NULL COMMENT 'tagXSD: detPag/card/CNPJReceb — CNPJ recebedor'
                                               AFTER card_c_aut,
  ADD COLUMN card_id_term    VARCHAR(40)  NULL COMMENT 'tagXSD: detPag/card/idTermPag — terminal de pagamento'
                                               AFTER card_cnpj_receb,
  ADD COLUMN v_troco         DECIMAL(15,2) NULL COMMENT 'tagXSD: pag/vTroco — valor do troco'
                                               AFTER card_id_term;


-- 1.8  nfe_inf_adic_proc_ref — novo campo tpAto (v4.00)
ALTER TABLE nfe_inf_adic_proc_ref
  ADD COLUMN tp_ato  VARCHAR(3)  NULL COMMENT 'tagXSD: tpAto — tipo do ato'
                                     AFTER ind_proc;


-- ─────────────────────────────────────────────────────────────────────────────
-- SEÇÃO 2 — CREATE TABLE de novas entidades v4.00
-- ─────────────────────────────────────────────────────────────────────────────

-- 2.1  Compra governamental (gCompraGov em ide, TCompraGov)
CREATE TABLE IF NOT EXISTS nfe_ide_compra_gov (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_ide    INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_ide',
  tp_ente_gov   TINYINT        NOT NULL                   COMMENT 'tagXSD: tpEnteGov — 1=União;2=Estados;3=DF;4=Municípios',
  p_redutor     DECIMAL(7,4)   NOT NULL                   COMMENT 'tagXSD: pRedutor — % redução alíquota',
  tp_oper_gov   TINYINT        NOT NULL                   COMMENT 'tagXSD: tpOperGov — 1=Fornecimento;2=Recebimento Pagamento',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_compragov_ide (id_nfe_ide),
  CONSTRAINT fk_compragov_ide FOREIGN KEY (id_nfe_ide) REFERENCES nfe_ide (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Compra governamental — elemento ide/gCompraGov (TCompraGov)';


-- 2.2  Pagamento antecipado referenciado (gPagAntecipado em ide)
CREATE TABLE IF NOT EXISTS nfe_ide_pag_antecipado (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_ide    INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_ide',
  ref_nfe       CHAR(44)       NOT NULL                   COMMENT 'tagXSD: refNFe — chave NF-e de antecipação',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_pagant_ide (id_nfe_ide),
  CONSTRAINT fk_pagant_ide FOREIGN KEY (id_nfe_ide) REFERENCES nfe_ide (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='NF-e antecipação referenciada — elemento ide/gPagAntecipado/refNFe (maxOccurs=99)';


-- 2.3  Crédito presumido do produto (gCred em prod)
CREATE TABLE IF NOT EXISTS nfe_det_prod_gcred (
  id                INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det_prod   INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det_prod',
  c_cred_presumido  VARCHAR(20)    NOT NULL                   COMMENT 'tagXSD: cCredPresumido — código do crédito presumido',
  p_cred_presumido  DECIMAL(7,4)   NOT NULL                   COMMENT 'tagXSD: pCredPresumido — percentual',
  v_cred_presumido  DECIMAL(15,2)  NOT NULL                   COMMENT 'tagXSD: vCredPresumido — valor',
  created_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_gcred_prod (id_nfe_det_prod),
  CONSTRAINT fk_gcred_prod FOREIGN KEY (id_nfe_det_prod) REFERENCES nfe_det_prod (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Crédito presumido do produto — elemento det/prod/gCred (maxOccurs=4)';


-- 2.4  Rastreabilidade do produto (rastro em prod)
-- Substitui os campos nLote/qLote/dFab/dVal/vPMC do antigo elemento med v3.10
CREATE TABLE IF NOT EXISTS nfe_det_prod_rastro (
  id              INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det',
  n_lote          VARCHAR(20)    NOT NULL                   COMMENT 'tagXSD: rastro/nLote — número do lote',
  q_lote          DECIMAL(11,3)  NOT NULL                   COMMENT 'tagXSD: rastro/qLote — quantidade do lote',
  d_fab           DATE           NOT NULL                   COMMENT 'tagXSD: rastro/dFab — data de fabricação',
  d_val           DATE           NOT NULL                   COMMENT 'tagXSD: rastro/dVal — data de validade',
  c_agreg         VARCHAR(20)        NULL                   COMMENT 'tagXSD: rastro/cAgreg — código de agregação (embalagem)',
  created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_rastro_det (id_nfe_det),
  CONSTRAINT fk_rastro_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Rastreabilidade do produto — elemento det/prod/rastro (maxOccurs=500)';


-- 2.5  Medicamento novo (med em prod — reestruturado na v4.00)
-- Na v4.00 med contém apenas cProdANVISA + xMotivoIsencao + vPMC
-- nLote/qLote/dFab/dVal foram movidos para rastro (tabela 2.4)
CREATE TABLE IF NOT EXISTS nfe_det_prod_med (
  id                  INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det          INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det',
  c_prod_anvisa       VARCHAR(13)    NOT NULL                   COMMENT 'tagXSD: cProdANVISA — código ANVISA / isento',
  x_motivo_isencao    VARCHAR(255)       NULL                   COMMENT 'tagXSD: xMotivoIsencao — motivo da isenção ANVISA',
  v_pmc               DECIMAL(15,2)  NOT NULL                   COMMENT 'tagXSD: vPMC — preço máximo ao consumidor',
  created_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_med_det (id_nfe_det),
  CONSTRAINT fk_med_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Medicamento — elemento det/prod/med (estrutura v4.00)';


-- 2.6  Informações do produto NFF (infProdNFF em prod)
CREATE TABLE IF NOT EXISTS nfe_det_prod_inf_nff (
  id              INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det',
  c_prod_fisco    VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: infProdNFF/cProdFisco — código fiscal do produto',
  c_oper_nff      VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: infProdNFF/cOperNFF — código da operação NFF',
  created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_nff_det (id_nfe_det),
  CONSTRAINT fk_nff_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Informações produto NFF — elemento det/prod/infProdNFF';


-- 2.7  Informações de embalagem (infProdEmb em prod)
CREATE TABLE IF NOT EXISTS nfe_det_prod_inf_emb (
  id              INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det',
  x_emb           VARCHAR(8)     NOT NULL                   COMMENT 'tagXSD: infProdEmb/xEmb — marca da embalagem',
  q_vol_emb       DECIMAL(11,3)  NOT NULL                   COMMENT 'tagXSD: infProdEmb/qVolEmb',
  u_emb           VARCHAR(8)     NOT NULL                   COMMENT 'tagXSD: infProdEmb/uEmb — unidade da embalagem',
  created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_emb_det (id_nfe_det),
  CONSTRAINT fk_emb_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Informações de embalagem — elemento det/prod/infProdEmb';


-- 2.8  Origem do combustível (origComb em prod/comb)
-- O elemento comb na v4.00 inclui origComb (maxOccurs=30) com indImport, cUFOrig, pOrig
-- e novos campos no comb: descANP, pGLP, pGNn, pGNi, vPart, pBio
-- Como não existia tabela comb separada na v3.10, criamos aqui para v4.00
CREATE TABLE IF NOT EXISTS nfe_det_prod_comb (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  c_prod_anp      VARCHAR(9)       NOT NULL                   COMMENT 'tagXSD: cProdANP — código ANP',
  desc_anp        VARCHAR(95)      NOT NULL                   COMMENT 'tagXSD: descANP — descrição produto ANP',
  p_glp           DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pGLP — % GLP derivado do petróleo',
  p_g_nn          DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pGNn — % gás natural nacional',
  p_g_ni          DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pGNi — % gás natural importado',
  v_part          DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vPart — valor partilhado',
  codif           VARCHAR(21)          NULL                   COMMENT 'tagXSD: CODIF',
  q_temp          DECIMAL(16,4)        NULL                   COMMENT 'tagXSD: qTemp — qtd a temp ambiente',
  uf_cons         CHAR(2)          NOT NULL                   COMMENT 'tagXSD: UFCons — UF de consumo',
  -- CIDE (opcional)
  cide_q_bc_prod  DECIMAL(16,4)        NULL                   COMMENT 'tagXSD: CIDE/qBCProd',
  cide_v_aliq_prod DECIMAL(15,4)       NULL                   COMMENT 'tagXSD: CIDE/vAliqProd',
  cide_v_cide     DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: CIDE/vCIDE',
  -- Encerrante (opcional)
  enc_n_bico      VARCHAR(3)           NULL                   COMMENT 'tagXSD: encerrante/nBico',
  enc_n_bomba     VARCHAR(3)           NULL                   COMMENT 'tagXSD: encerrante/nBomba',
  enc_n_tanque    VARCHAR(3)           NULL                   COMMENT 'tagXSD: encerrante/nTanque',
  enc_v_enc_ini   DECIMAL(15,3)        NULL                   COMMENT 'tagXSD: encerrante/vEncIni',
  enc_v_enc_fin   DECIMAL(15,3)        NULL                   COMMENT 'tagXSD: encerrante/vEncFin',
  p_bio           DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pBio — % biodiesel/etanol',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_comb_det (id_nfe_det),
  CONSTRAINT fk_comb_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Combustível — elemento det/prod/comb (estrutura v4.00)';


-- 2.9  Origem do combustível por UF (origComb dentro de comb, maxOccurs=30)
CREATE TABLE IF NOT EXISTS nfe_det_prod_comb_orig (
  id                  INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det_prod_comb INT UNSIGNED  NOT NULL                   COMMENT 'FK → nfe_det_prod_comb',
  ind_import          TINYINT(1)     NOT NULL                   COMMENT 'tagXSD: indImport — 0=nacional;1=importado',
  cod_uf_orig         TINYINT        NOT NULL                   COMMENT 'tagXSD: cUFOrig — código IBGE da UF de origem',
  p_orig              DECIMAL(7,4)   NOT NULL                   COMMENT 'tagXSD: pOrig — percentual de origem',
  created_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_orig_comb (id_nfe_det_prod_comb),
  CONSTRAINT fk_orig_comb FOREIGN KEY (id_nfe_det_prod_comb) REFERENCES nfe_det_prod_comb (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Origem do combustível por UF — elemento det/prod/comb/origComb (maxOccurs=30)';


-- 2.10  Observação do item (obsItem em det — v4.00)
CREATE TABLE IF NOT EXISTS nfe_det_obs_item (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det    INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det',
  tipo          VARCHAR(5)     NOT NULL                   COMMENT 'cont | fisco',
  x_campo       VARCHAR(20)    NOT NULL                   COMMENT 'tagXSD: @xCampo',
  x_texto       VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: xTexto',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_obsitem_det (id_nfe_det),
  CONSTRAINT fk_obsitem_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Observações do item — elemento det/obsItem (obsCont + obsFisco)';


-- 2.11  DF-e referenciado no item (DFeReferenciado em det — v4.00)
CREATE TABLE IF NOT EXISTS nfe_det_dfe_ref (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_det    INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det',
  chave_acesso  CHAR(44)       NOT NULL                   COMMENT 'tagXSD: DFeReferenciado/chaveAcesso',
  n_item        VARCHAR(3)         NULL                   COMMENT 'tagXSD: DFeReferenciado/nItem — item referenciado',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_dferef_det (id_nfe_det),
  CONSTRAINT fk_dferef_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='DF-e referenciado no item — elemento det/DFeReferenciado';


-- 2.12  Intermediador / Marketplace (infIntermed — v4.00)
CREATE TABLE IF NOT EXISTS nfe_inf_intermed (
  id              INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe          INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe',
  cnpj            VARCHAR(14)    NOT NULL                   COMMENT 'tagXSD: infIntermed/CNPJ — CNPJ intermediador',
  id_cad_int_tran VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: infIntermed/idCadIntTran — identificador cadastro transacional',
  created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_intermed_nfe (id_nfe),
  CONSTRAINT fk_intermed_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Intermediador/Marketplace — elemento infIntermed (v4.00)';


-- 2.13  Responsável técnico (infRespTec — v4.00)
CREATE TABLE IF NOT EXISTS nfe_resp_tec (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe',
  cnpj          VARCHAR(14)    NOT NULL                   COMMENT 'tagXSD: infRespTec/CNPJ',
  x_contato     VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: infRespTec/xContato — nome do contato',
  email         VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: infRespTec/email',
  fone          VARCHAR(14)    NOT NULL                   COMMENT 'tagXSD: infRespTec/fone',
  id_csrt       VARCHAR(3)         NULL                   COMMENT 'tagXSD: infRespTec/idCSRT — identificador CSRT',
  hash_csrt     VARCHAR(28)        NULL                   COMMENT 'tagXSD: infRespTec/hashCSRT — hash SHA-1 CSRT em Base64',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_resptec_nfe (id_nfe),
  CONSTRAINT fk_resptec_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Responsável técnico — elemento infRespTec (TInfRespTec, v4.00)';


-- 2.14  Solicitação NFF (infSolicNFF — v4.00)
CREATE TABLE IF NOT EXISTS nfe_solic_nff (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe',
  x_solic       TEXT           NOT NULL                   COMMENT 'tagXSD: infSolicNFF/xSolic — texto da solicitação NFF',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_solicnff_nfe (id_nfe),
  CONSTRAINT fk_solicnff_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Solicitação NFF — elemento infSolicNFF (v4.00)';


-- 2.15  Agropecuário — cabeçalho (agropecuario — NT2024.003)
CREATE TABLE IF NOT EXISTS nfe_agropecuario (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_agro_nfe (id_nfe),
  CONSTRAINT fk_agro_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Agropecuário — elemento agropecuario (NT2024.003)';


-- 2.16  Defensivo agrícola (defensivo dentro de agropecuario, maxOccurs=20)
CREATE TABLE IF NOT EXISTS nfe_agropecuario_defensivo (
  id                INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_agro       INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_agropecuario',
  n_receituario     VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: defensivo/nReceituario',
  cpf_resp_tec      VARCHAR(11)    NOT NULL                   COMMENT 'tagXSD: defensivo/CPFRespTec — CPF responsável técnico',
  created_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_def_agro (id_nfe_agro),
  CONSTRAINT fk_def_agro FOREIGN KEY (id_nfe_agro) REFERENCES nfe_agropecuario (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Defensivo agrícola — elemento agropecuario/defensivo (maxOccurs=20)';


-- 2.17  Guia de trânsito agropecuário (guiaTransito dentro de agropecuario)
CREATE TABLE IF NOT EXISTS nfe_agropecuario_guia (
  id                INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  id_nfe_agro       INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_agropecuario',
  tp_guia           VARCHAR(2)     NOT NULL                   COMMENT 'tagXSD: guiaTransito/tpGuia — tipo de guia',
  uf_guia           CHAR(2)        NOT NULL                   COMMENT 'tagXSD: guiaTransito/UFGuia',
  serie_guia        VARCHAR(3)         NULL                   COMMENT 'tagXSD: guiaTransito/serieGuia',
  n_guia            VARCHAR(60)    NOT NULL                   COMMENT 'tagXSD: guiaTransito/nGuia — número da guia',
  created_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_guia_agro (id_nfe_agro),
  CONSTRAINT fk_guia_agro FOREIGN KEY (id_nfe_agro) REFERENCES nfe_agropecuario (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Guia de trânsito agropecuário — elemento agropecuario/guiaTransito';
