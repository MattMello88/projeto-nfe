-- =============================================================================
-- NF-e v3.10 — Script de criação do banco de dados MySQL
-- Gerado a partir do schema: nfe_v3.10.xsd / leiauteNFe_v3.10.xsd
-- Padrão: banco-dados.mdc (snake_case, inglês, utf8mb4, id AUTO_INCREMENT)
-- =============================================================================

-- 01. TABELA RAIZ DA NF-e
-- Representa o elemento infNFe — cabeçalho principal de cada Nota Fiscal
CREATE TABLE IF NOT EXISTS nfe (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  chave         CHAR(44)         NOT NULL                   COMMENT 'tagXSD: @Id — chave de acesso 44 dígitos',
  versao        VARCHAR(4)       NOT NULL                   COMMENT 'tagXSD: @versao',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_nfe_chave (chave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Nota Fiscal Eletrônica — raiz infNFe';


-- 02. IDENTIFICAÇÃO DA NF-e
-- Representa o elemento ide dentro de infNFe
CREATE TABLE IF NOT EXISTS nfe_ide (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  cod_uf        TINYINT          NOT NULL                   COMMENT 'tagXSD: cUF — código IBGE da UF emitente',
  cod_nf        CHAR(8)          NOT NULL                   COMMENT 'tagXSD: cNF — código numérico aleatório',
  nat_op        VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: natOp — natureza da operação',
  ind_pag       TINYINT          NOT NULL                   COMMENT 'tagXSD: indPag — 0=à vista;1=a prazo;2=outros',
  mod           CHAR(2)          NOT NULL                   COMMENT 'tagXSD: mod — 55=NF-e;65=NFC-e',
  serie         VARCHAR(3)       NOT NULL                   COMMENT 'tagXSD: serie',
  num_nf        VARCHAR(9)       NOT NULL                   COMMENT 'tagXSD: nNF — número do documento',
  dh_emi        DATETIME         NOT NULL                   COMMENT 'tagXSD: dhEmi — data/hora de emissão',
  dh_sai_ent    DATETIME             NULL                   COMMENT 'tagXSD: dhSaiEnt — data/hora saída ou entrada',
  tp_nf         TINYINT(1)       NOT NULL                   COMMENT 'tagXSD: tpNF — 0=entrada;1=saída',
  id_dest       TINYINT          NOT NULL                   COMMENT 'tagXSD: idDest — 1=interna;2=interestadual;3=exterior',
  cod_mun_fg    CHAR(7)          NOT NULL                   COMMENT 'tagXSD: cMunFG — município fato gerador (IBGE)',
  tp_imp        TINYINT          NOT NULL                   COMMENT 'tagXSD: tpImp — formato DANFE (0–5)',
  tp_emis       TINYINT          NOT NULL                   COMMENT 'tagXSD: tpEmis — forma de emissão (1–9)',
  dv            CHAR(1)          NOT NULL                   COMMENT 'tagXSD: cDV — dígito verificador da chave',
  tp_amb        TINYINT(1)       NOT NULL                   COMMENT 'tagXSD: tpAmb — 1=produção;2=homologação',
  fin_nfe       TINYINT          NOT NULL                   COMMENT 'tagXSD: finNFe — 1=normal;2=compl;3=ajuste;4=devolução',
  ind_final     TINYINT(1)       NOT NULL                   COMMENT 'tagXSD: indFinal — 0=não;1=consumidor final',
  ind_pres      TINYINT          NOT NULL                   COMMENT 'tagXSD: indPres — presença do comprador (0–9)',
  proc_emi      TINYINT          NOT NULL                   COMMENT 'tagXSD: procEmi — processo de emissão (0–3)',
  ver_proc      VARCHAR(20)      NOT NULL                   COMMENT 'tagXSD: verProc — versão do aplicativo',
  dh_cont       DATETIME             NULL                   COMMENT 'tagXSD: dhCont — data/hora de entrada em contingência',
  x_just        TEXT                 NULL                   COMMENT 'tagXSD: xJust — justificativa de contingência',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_ide_nfe (id_nfe),
  CONSTRAINT fk_ide_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Identificação da NF-e — elemento ide';


-- 03. NF REFERENCIADA
-- Elemento NFref dentro de ide (maxOccurs=500)
CREATE TABLE IF NOT EXISTS nfe_nf_ref (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_ide      INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_ide',
  tipo_ref        VARCHAR(10)      NOT NULL                   COMMENT 'refNFe | refNF | refNFP | refCTe | refECF',
  ref_nfe         CHAR(44)             NULL                   COMMENT 'tagXSD: refNFe — chave NF-e referenciada',
  ref_cte         CHAR(44)             NULL                   COMMENT 'tagXSD: refCTe — chave CT-e referenciada',
  ref_nf_cod_uf   TINYINT              NULL                   COMMENT 'tagXSD: refNF/cUF',
  ref_nf_aamm     CHAR(4)              NULL                   COMMENT 'tagXSD: refNF/AAMM',
  ref_nf_cnpj     VARCHAR(14)          NULL                   COMMENT 'tagXSD: refNF/CNPJ',
  ref_nf_mod      CHAR(2)              NULL                   COMMENT 'tagXSD: refNF/mod',
  ref_nf_serie    VARCHAR(3)           NULL                   COMMENT 'tagXSD: refNF/serie',
  ref_nf_num      VARCHAR(9)           NULL                   COMMENT 'tagXSD: refNF/nNF',
  ref_nfp_cnpj    VARCHAR(14)          NULL                   COMMENT 'tagXSD: refNFP/CNPJ',
  ref_nfp_cpf     VARCHAR(11)          NULL                   COMMENT 'tagXSD: refNFP/CPF',
  ref_nfp_ie      VARCHAR(14)          NULL                   COMMENT 'tagXSD: refNFP/IE',
  ref_nfp_mod     CHAR(2)              NULL                   COMMENT 'tagXSD: refNFP/mod',
  ref_nfp_serie   VARCHAR(3)           NULL                   COMMENT 'tagXSD: refNFP/serie',
  ref_nfp_num     VARCHAR(9)           NULL                   COMMENT 'tagXSD: refNFP/nNF',
  ref_ecf_mod     CHAR(2)              NULL                   COMMENT 'tagXSD: refECF/mod — 2B/2C/2D',
  ref_ecf_n_ecf   VARCHAR(3)           NULL                   COMMENT 'tagXSD: refECF/nECF',
  ref_ecf_n_coo   VARCHAR(6)           NULL                   COMMENT 'tagXSD: refECF/nCOO',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_nfref_ide (id_nfe_ide),
  CONSTRAINT fk_nfref_ide FOREIGN KEY (id_nfe_ide) REFERENCES nfe_ide (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='NF referenciada — elemento NFref (maxOccurs=500)';


-- 04. EMITENTE
-- Elemento emit com endereço TEnderEmi embutido
CREATE TABLE IF NOT EXISTS nfe_emit (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  cnpj          VARCHAR(14)          NULL                   COMMENT 'tagXSD: CNPJ — CNPJ do emitente',
  cpf           VARCHAR(11)          NULL                   COMMENT 'tagXSD: CPF — CPF do emitente',
  x_nome        VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xNome — razão social / nome',
  x_fant        VARCHAR(60)          NULL                   COMMENT 'tagXSD: xFant — nome fantasia',
  ie            VARCHAR(14)      NOT NULL                   COMMENT 'tagXSD: IE — inscrição estadual',
  iest          VARCHAR(14)          NULL                   COMMENT 'tagXSD: IEST — IE do substituto tributário',
  im            VARCHAR(15)          NULL                   COMMENT 'tagXSD: IM — inscrição municipal',
  cnae          CHAR(7)              NULL                   COMMENT 'tagXSD: CNAE',
  crt           TINYINT          NOT NULL                   COMMENT 'tagXSD: CRT — 1=SN;2=SN excesso;3=Regime Normal',
  -- Endereço do emitente (TEnderEmi)
  end_x_lgr     VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: enderEmit/xLgr',
  end_nro       VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: enderEmit/nro',
  end_x_cpl     VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderEmit/xCpl',
  end_x_bairro  VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: enderEmit/xBairro',
  end_cod_mun   CHAR(7)          NOT NULL                   COMMENT 'tagXSD: enderEmit/cMun',
  end_x_mun     VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: enderEmit/xMun',
  end_uf        CHAR(2)          NOT NULL                   COMMENT 'tagXSD: enderEmit/UF',
  end_cep       CHAR(8)          NOT NULL                   COMMENT 'tagXSD: enderEmit/CEP',
  end_cod_pais  CHAR(4)              NULL                   COMMENT 'tagXSD: enderEmit/cPais',
  end_x_pais    VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderEmit/xPais',
  end_fone      VARCHAR(14)          NULL                   COMMENT 'tagXSD: enderEmit/fone',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_emit_nfe (id_nfe),
  CONSTRAINT fk_emit_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Emitente — elemento emit com endereço TEnderEmi';


-- 05. AVULSA
-- Elemento avulsa (minOccurs=0) — dados do Fisco emitente
CREATE TABLE IF NOT EXISTS nfe_avulsa (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  cnpj          VARCHAR(14)      NOT NULL                   COMMENT 'tagXSD: CNPJ — órgão emissor',
  x_orgao       VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xOrgao',
  matr          VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: matr — matrícula do agente',
  x_agente      VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xAgente',
  fone          VARCHAR(14)          NULL                   COMMENT 'tagXSD: fone',
  uf            CHAR(2)          NOT NULL                   COMMENT 'tagXSD: UF',
  n_dar         VARCHAR(60)          NULL                   COMMENT 'tagXSD: nDAR',
  d_emi         DATE                 NULL                   COMMENT 'tagXSD: dEmi',
  v_dar         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vDAR',
  rep_emi       VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: repEmi',
  d_pag         DATE                 NULL                   COMMENT 'tagXSD: dPag',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_avulsa_nfe (id_nfe),
  CONSTRAINT fk_avulsa_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Avulsa — emissão avulsa pelo Fisco';


-- 06. DESTINATÁRIO
-- Elemento dest (minOccurs=0) com endereço TEndereco embutido
CREATE TABLE IF NOT EXISTS nfe_dest (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe          INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  cnpj            VARCHAR(14)          NULL                   COMMENT 'tagXSD: CNPJ',
  cpf             VARCHAR(11)          NULL                   COMMENT 'tagXSD: CPF',
  id_estrangeiro  VARCHAR(20)          NULL                   COMMENT 'tagXSD: idEstrangeiro',
  x_nome          VARCHAR(60)          NULL                   COMMENT 'tagXSD: xNome',
  ind_ie_dest     TINYINT          NOT NULL                   COMMENT 'tagXSD: indIEDest — 1=contrib;2=isento;9=não contrib',
  ie              VARCHAR(14)          NULL                   COMMENT 'tagXSD: IE',
  isuf            VARCHAR(9)           NULL                   COMMENT 'tagXSD: ISUF',
  im              VARCHAR(15)          NULL                   COMMENT 'tagXSD: IM',
  email           VARCHAR(60)          NULL                   COMMENT 'tagXSD: email',
  -- Endereço do destinatário (TEndereco), minOccurs=0
  end_x_lgr       VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderDest/xLgr',
  end_nro         VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderDest/nro',
  end_x_cpl       VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderDest/xCpl',
  end_x_bairro    VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderDest/xBairro',
  end_cod_mun     CHAR(7)              NULL                   COMMENT 'tagXSD: enderDest/cMun',
  end_x_mun       VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderDest/xMun',
  end_uf          CHAR(2)              NULL                   COMMENT 'tagXSD: enderDest/UF',
  end_cep         CHAR(8)              NULL                   COMMENT 'tagXSD: enderDest/CEP',
  end_cod_pais    CHAR(4)              NULL                   COMMENT 'tagXSD: enderDest/cPais',
  end_x_pais      VARCHAR(60)          NULL                   COMMENT 'tagXSD: enderDest/xPais',
  end_fone        VARCHAR(14)          NULL                   COMMENT 'tagXSD: enderDest/fone',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_dest_nfe (id_nfe),
  CONSTRAINT fk_dest_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Destinatário — elemento dest';


-- 07. LOCAL DE RETIRADA / ENTREGA
-- Elementos retirada e entrega (ambos tipo TLocal, minOccurs=0)
-- Coluna "tipo" distingue: 'retirada' ou 'entrega'
CREATE TABLE IF NOT EXISTS nfe_local (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  tipo          VARCHAR(8)       NOT NULL                   COMMENT 'retirada | entrega',
  cnpj          VARCHAR(14)          NULL                   COMMENT 'tagXSD: CNPJ',
  cpf           VARCHAR(11)          NULL                   COMMENT 'tagXSD: CPF',
  x_lgr         VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xLgr',
  nro           VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: nro',
  x_cpl         VARCHAR(60)          NULL                   COMMENT 'tagXSD: xCpl',
  x_bairro      VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xBairro',
  cod_mun       CHAR(7)          NOT NULL                   COMMENT 'tagXSD: cMun',
  x_mun         VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xMun',
  uf            CHAR(2)          NOT NULL                   COMMENT 'tagXSD: UF',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_local_nfe (id_nfe),
  CONSTRAINT fk_local_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Local de retirada / entrega — elementos retirada e entrega (TLocal)';


-- 08. AUTORIZAÇÃO DE ACESSO AO XML
-- Elemento autXML (minOccurs=0, maxOccurs=10)
CREATE TABLE IF NOT EXISTS nfe_aut_xml (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  cnpj          VARCHAR(14)          NULL                   COMMENT 'tagXSD: CNPJ',
  cpf           VARCHAR(11)          NULL                   COMMENT 'tagXSD: CPF',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_autxml_nfe (id_nfe),
  CONSTRAINT fk_autxml_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Autorização de acesso ao XML — elemento autXML (maxOccurs=10)';


-- 09. ITEM / DETALHE DA NF-e
-- Elemento det (maxOccurs=990) — cabeçalho de cada item
CREATE TABLE IF NOT EXISTS nfe_det (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  n_item        SMALLINT         NOT NULL                   COMMENT 'tagXSD: @nItem — número do item (1–990)',
  inf_ad_prod   TEXT                 NULL                   COMMENT 'tagXSD: infAdProd — informações adicionais do produto',
  p_devol       DECIMAL(5,2)         NULL                   COMMENT 'tagXSD: impostoDevol/pDevol — % mercadoria devolvida',
  v_ipi_devol   DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: impostoDevol/IPI/vIPIDevol',
  v_tot_trib    DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: imposto/vTotTrib',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_det_nfe (id_nfe),
  CONSTRAINT fk_det_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Item / detalhe da NF-e — elemento det (maxOccurs=990)';


-- 10. PRODUTO DO ITEM
-- Elemento prod dentro de det
CREATE TABLE IF NOT EXISTS nfe_det_prod (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det    INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  c_prod        VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: cProd — código do produto do emitente',
  c_ean         VARCHAR(14)      NOT NULL                   COMMENT 'tagXSD: cEAN — GTIN/EAN',
  x_prod        VARCHAR(120)     NOT NULL                   COMMENT 'tagXSD: xProd — descrição do produto',
  ncm           VARCHAR(8)       NOT NULL                   COMMENT 'tagXSD: NCM',
  cest          VARCHAR(7)           NULL                   COMMENT 'tagXSD: CEST',
  ext_ipi       VARCHAR(3)           NULL                   COMMENT 'tagXSD: EXTIPI',
  cfop          VARCHAR(4)       NOT NULL                   COMMENT 'tagXSD: CFOP',
  u_com         VARCHAR(6)       NOT NULL                   COMMENT 'tagXSD: uCom — unidade comercial',
  q_com         DECIMAL(15,4)    NOT NULL                   COMMENT 'tagXSD: qCom — quantidade comercial',
  v_un_com      DECIMAL(21,10)   NOT NULL                   COMMENT 'tagXSD: vUnCom — valor unitário comercial',
  v_prod        DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vProd — valor total bruto dos produtos',
  c_ean_trib    VARCHAR(14)      NOT NULL                   COMMENT 'tagXSD: cEANTrib — GTIN tributável',
  u_trib        VARCHAR(6)       NOT NULL                   COMMENT 'tagXSD: uTrib — unidade tributável',
  q_trib        DECIMAL(15,4)    NOT NULL                   COMMENT 'tagXSD: qTrib — quantidade tributável',
  v_un_trib     DECIMAL(21,10)   NOT NULL                   COMMENT 'tagXSD: vUnTrib — valor unitário tributável',
  v_frete       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vFrete',
  v_seg         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vSeg',
  v_desc        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vDesc',
  v_outro       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vOutro — outras despesas',
  ind_tot       TINYINT(1)       NOT NULL                   COMMENT 'tagXSD: indTot — 0=não compõe total;1=compõe',
  x_ped         VARCHAR(15)          NULL                   COMMENT 'tagXSD: xPed — número do pedido de compra',
  n_item_ped    VARCHAR(6)           NULL                   COMMENT 'tagXSD: nItemPed',
  n_fci         VARCHAR(36)          NULL                   COMMENT 'tagXSD: nFCI — Ficha de Conteúdo de Importação (GUID)',
  n_recopi      VARCHAR(20)          NULL                   COMMENT 'tagXSD: nRECOPI',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_prod_det (id_nfe_det),
  CONSTRAINT fk_prod_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Produto do item — elemento prod';


-- 11. NVE DO PRODUTO
-- Elemento NVE dentro de prod (minOccurs=0, maxOccurs=8)
CREATE TABLE IF NOT EXISTS nfe_det_prod_nve (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det_prod INT UNSIGNED   NOT NULL                   COMMENT 'FK → nfe_det_prod',
  nve           VARCHAR(6)       NOT NULL                   COMMENT 'tagXSD: NVE — Nomenclatura de Valor Aduaneiro',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_nve_prod (id_nfe_det_prod),
  CONSTRAINT fk_nve_prod FOREIGN KEY (id_nfe_det_prod) REFERENCES nfe_det_prod (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='NVE do produto — elemento NVE (maxOccurs=8)';


-- 12. DECLARAÇÃO DE IMPORTAÇÃO
-- Elemento DI dentro de prod (minOccurs=0, maxOccurs=100)
CREATE TABLE IF NOT EXISTS nfe_det_di (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  n_di            VARCHAR(12)      NOT NULL                   COMMENT 'tagXSD: nDI — número da DI/DSI/DA/DRI-E',
  d_di            DATE             NOT NULL                   COMMENT 'tagXSD: dDI — data de registro',
  x_loc_desemb    VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xLocDesemb — local de desembaraço',
  uf_desemb       CHAR(2)          NOT NULL                   COMMENT 'tagXSD: UFDesemb',
  d_desemb        DATE             NOT NULL                   COMMENT 'tagXSD: dDesemb — data do desembaraço',
  tp_via_transp   TINYINT          NOT NULL                   COMMENT 'tagXSD: tpViaTransp — 1=Marítima;...;7=Fluvial',
  v_afrmm         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vAFRMM — valor da AFRMM (apenas marítima)',
  tp_intermedio   TINYINT          NOT NULL                   COMMENT 'tagXSD: tpIntermedio — 1=conta própria;2=conta e ordem;3=encomenda',
  cnpj            VARCHAR(14)          NULL                   COMMENT 'tagXSD: CNPJ — do adquirente/encomendante',
  uf_terceiro     CHAR(2)              NULL                   COMMENT 'tagXSD: UFTerceiro',
  c_exportador    VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: cExportador — código do exportador',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_di_det (id_nfe_det),
  CONSTRAINT fk_di_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Declaração de Importação — elemento DI (maxOccurs=100)';


-- 13. ADIÇÕES DA DECLARAÇÃO DE IMPORTAÇÃO
-- Elemento adi dentro de DI (maxOccurs=100)
CREATE TABLE IF NOT EXISTS nfe_det_di_adi (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det_di   INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det_di',
  n_adicao        SMALLINT         NOT NULL                   COMMENT 'tagXSD: nAdicao — número da adição',
  n_seq_adic      SMALLINT         NOT NULL                   COMMENT 'tagXSD: nSeqAdic — sequencial do item na adição',
  c_fabricante    VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: cFabricante — código do fabricante estrangeiro',
  v_desc_di       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vDescDI — valor do desconto da adição',
  n_draw          VARCHAR(20)          NULL                   COMMENT 'tagXSD: nDraw — número do ato concessório de drawback',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_adi_di (id_nfe_det_di),
  CONSTRAINT fk_adi_di FOREIGN KEY (id_nfe_det_di) REFERENCES nfe_det_di (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Adição da DI — elemento adi (maxOccurs=100)';


-- 14. DETALHAMENTO DE EXPORTAÇÃO
-- Elemento detExport dentro de prod (minOccurs=0, maxOccurs=500)
CREATE TABLE IF NOT EXISTS nfe_det_export (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det    INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  n_draw        VARCHAR(20)          NULL                   COMMENT 'tagXSD: nDraw',
  n_re          VARCHAR(12)          NULL                   COMMENT 'tagXSD: exportInd/nRE — número do registro de exportação',
  ch_nfe        CHAR(44)             NULL                   COMMENT 'tagXSD: exportInd/chNFe',
  q_export      DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: exportInd/qExport',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_export_det (id_nfe_det),
  CONSTRAINT fk_export_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Detalhamento de exportação — elemento detExport (maxOccurs=500)';


-- 15. ICMS DO ITEM
-- Elemento imposto/ICMS — tabela única com todas as modalidades (CST/CSOSN)
CREATE TABLE IF NOT EXISTS nfe_det_imposto_icms (
  id                INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  tipo_cst          VARCHAR(10)      NOT NULL                   COMMENT 'ICMS00|ICMS10|...|ICMS90|ICMSPart|ICMSST|ICMSSN101|...',
  orig              TINYINT          NOT NULL                   COMMENT 'tagXSD: orig — origem da mercadoria (0–8)',
  cst               VARCHAR(3)           NULL                   COMMENT 'tagXSD: CST — regime normal',
  csosn             VARCHAR(3)           NULL                   COMMENT 'tagXSD: CSOSN — Simples Nacional',
  mod_bc            TINYINT              NULL                   COMMENT 'tagXSD: modBC — modalidade BC ICMS',
  p_red_bc          DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pRedBC — % de redução da BC',
  v_bc              DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vBC',
  p_icms            DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pICMS — alíquota',
  v_icms            DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vICMS',
  v_icms_deson      DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vICMSDeson',
  mot_des_icms      TINYINT              NULL                   COMMENT 'tagXSD: motDesICMS',
  mod_bc_st         TINYINT              NULL                   COMMENT 'tagXSD: modBCST',
  p_mva_st          DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pMVAST',
  p_red_bc_st       DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pRedBCST',
  v_bc_st           DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vBCST',
  p_icms_st         DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pICMSST',
  v_icms_st         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vICMSST',
  v_bc_st_ret       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vBCSTRet',
  v_icms_st_ret     DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vICMSSTRet',
  v_bc_st_dest      DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSST/vBCSTDest',
  v_icms_st_dest    DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSST/vICMSSTDest',
  p_cred_sn         DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pCredSN',
  v_cred_icms_sn    DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vCredICMSSN',
  p_bc_op           DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: ICMSPart/pBCOp',
  uf_st             CHAR(2)              NULL                   COMMENT 'tagXSD: ICMSPart/UFST',
  v_icms_op         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMS51/vICMSOp',
  p_dif             DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: ICMS51/pDif',
  v_icms_dif        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMS51/vICMSDif',
  -- ICMSUFDest — vendas interestaduais consumidor final
  v_bc_uf_dest      DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSUFDest/vBCUFDest',
  p_fcp_uf_dest     DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: ICMSUFDest/pFCPUFDest',
  p_icms_uf_dest    DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: ICMSUFDest/pICMSUFDest',
  p_icms_inter      DECIMAL(5,2)         NULL                   COMMENT 'tagXSD: ICMSUFDest/pICMSInter — 4/7/12%',
  p_icms_inter_part DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: ICMSUFDest/pICMSInterPart',
  v_fcp_uf_dest     DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSUFDest/vFCPUFDest',
  v_icms_uf_dest    DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSUFDest/vICMSUFDest',
  v_icms_uf_remet   DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSUFDest/vICMSUFRemet',
  created_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_icms_det (id_nfe_det),
  CONSTRAINT fk_icms_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='ICMS do item — elemento imposto/ICMS (todas as modalidades)';


-- 16. IPI DO ITEM
-- Tipo TIpi — usado em imposto/IPI (minOccurs=0)
CREATE TABLE IF NOT EXISTS nfe_det_imposto_ipi (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det    INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  cl_enq        VARCHAR(5)           NULL                   COMMENT 'tagXSD: clEnq — classe de enquadramento',
  cnpj_prod     VARCHAR(14)          NULL                   COMMENT 'tagXSD: CNPJProd',
  c_selo        VARCHAR(60)          NULL                   COMMENT 'tagXSD: cSelo',
  q_selo        VARCHAR(12)          NULL                   COMMENT 'tagXSD: qSelo',
  c_enq         VARCHAR(3)       NOT NULL                   COMMENT 'tagXSD: cEnq — código de enquadramento legal',
  cst           VARCHAR(2)       NOT NULL                   COMMENT 'tagXSD: IPITrib/CST ou IPINT/CST',
  v_bc          DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: IPITrib/vBC',
  p_ipi         DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: IPITrib/pIPI',
  q_bc_prod     DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: IPITrib/qBCProd',
  v_aliq_prod   DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: IPITrib/vAliqProd',
  v_ipi         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: IPITrib/vIPI',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_ipi_det (id_nfe_det),
  CONSTRAINT fk_ipi_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='IPI do item — elemento imposto/IPI (TIpi)';


-- 17. II DO ITEM
-- Elemento imposto/II (minOccurs=0) — Imposto de Importação
CREATE TABLE IF NOT EXISTS nfe_det_imposto_ii (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det    INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  v_bc          DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vBC',
  v_desp_adu    DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vDespAdu — despesas aduaneiras',
  v_ii          DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vII',
  v_iof         DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vIOF',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_ii_det (id_nfe_det),
  CONSTRAINT fk_ii_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Imposto de Importação do item — elemento imposto/II';


-- 18. PIS DO ITEM
-- Elemento imposto/PIS (minOccurs=0)
CREATE TABLE IF NOT EXISTS nfe_det_imposto_pis (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  tipo_pis        VARCHAR(10)      NOT NULL                   COMMENT 'PISAliq | PISQtde | PISNT | PISOutr',
  cst             VARCHAR(2)       NOT NULL                   COMMENT 'tagXSD: CST',
  v_bc            DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vBC',
  p_pis           DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pPIS — alíquota %',
  q_bc_prod       DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: qBCProd',
  v_aliq_prod     DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: vAliqProd — alíquota R$',
  v_pis           DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vPIS',
  -- PISST
  st_v_bc         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: PISST/vBC',
  st_p_pis        DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: PISST/pPIS',
  st_q_bc_prod    DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: PISST/qBCProd',
  st_v_aliq_prod  DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: PISST/vAliqProd',
  st_v_pis        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: PISST/vPIS',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_pis_det (id_nfe_det),
  CONSTRAINT fk_pis_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='PIS do item — elemento imposto/PIS + PISST';


-- 19. COFINS DO ITEM
-- Elemento imposto/COFINS (minOccurs=0)
CREATE TABLE IF NOT EXISTS nfe_det_imposto_cofins (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  tipo_cofins     VARCHAR(10)      NOT NULL                   COMMENT 'COFINSAliq | COFINSQtde | COFINSNT | COFINSOutr',
  cst             VARCHAR(2)       NOT NULL                   COMMENT 'tagXSD: CST',
  v_bc            DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vBC',
  p_cofins        DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: pCOFINS',
  q_bc_prod       DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: qBCProd',
  v_aliq_prod     DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: vAliqProd',
  v_cofins        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vCOFINS',
  -- COFINSST
  st_v_bc         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: COFINSST/vBC',
  st_p_cofins     DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: COFINSST/pCOFINS',
  st_q_bc_prod    DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: COFINSST/qBCProd',
  st_v_aliq_prod  DECIMAL(15,4)        NULL                   COMMENT 'tagXSD: COFINSST/vAliqProd',
  st_v_cofins     DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: COFINSST/vCOFINS',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_cofins_det (id_nfe_det),
  CONSTRAINT fk_cofins_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='COFINS do item — elemento imposto/COFINS + COFINSST';


-- 20. ISSQN DO ITEM
-- Elemento imposto/ISSQN (segunda opção de imposto, para serviços)
CREATE TABLE IF NOT EXISTS nfe_det_imposto_issqn (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_det      INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_det',
  v_bc            DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vBC',
  v_aliq          DECIMAL(7,4)     NOT NULL                   COMMENT 'tagXSD: vAliq — alíquota do ISSQN',
  v_issqn         DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vISSQN',
  cod_mun_fg      CHAR(7)          NOT NULL                   COMMENT 'tagXSD: cMunFG — município fato gerador',
  c_list_serv     VARCHAR(5)       NOT NULL                   COMMENT 'tagXSD: cListServ — item lista serviços LC 116/2003',
  v_deducao       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vDeducao',
  v_outro         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vOutro',
  v_desc_incond   DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vDescIncond',
  v_desc_cond     DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vDescCond',
  v_iss_ret       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vISSRet',
  ind_iss         TINYINT          NOT NULL                   COMMENT 'tagXSD: indISS — exigibilidade (1–6)',
  c_servico       VARCHAR(20)          NULL                   COMMENT 'tagXSD: cServico',
  cod_mun         CHAR(7)              NULL                   COMMENT 'tagXSD: cMun',
  cod_pais        CHAR(4)              NULL                   COMMENT 'tagXSD: cPais',
  n_processo      VARCHAR(30)          NULL                   COMMENT 'tagXSD: nProcesso',
  ind_incentivo   TINYINT(1)       NOT NULL                   COMMENT 'tagXSD: indIncentivo — 1=sim;2=não',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_issqn_det (id_nfe_det),
  CONSTRAINT fk_issqn_det FOREIGN KEY (id_nfe_det) REFERENCES nfe_det (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='ISSQN do item — elemento imposto/ISSQN';


-- 21. TOTAIS DA NF-e
-- Elemento total — ICMSTot obrigatório + ISSQNtot + retTrib opcionais
CREATE TABLE IF NOT EXISTS nfe_total (
  id                    INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe                INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  -- ICMSTot
  v_bc                  DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vBC',
  v_icms                DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vICMS',
  v_icms_deson          DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vICMSDeson',
  v_fcp_uf_dest         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSTot/vFCPUFDest',
  v_icms_uf_dest        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSTot/vICMSUFDest',
  v_icms_uf_remet       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSTot/vICMSUFRemet',
  v_bc_st               DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vBCST',
  v_st                  DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vST',
  v_prod                DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vProd',
  v_frete               DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vFrete',
  v_seg                 DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vSeg',
  v_desc                DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vDesc',
  v_ii                  DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vII',
  v_ipi                 DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vIPI',
  v_pis                 DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vPIS',
  v_cofins              DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vCOFINS',
  v_outro               DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vOutro',
  v_nf                  DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: ICMSTot/vNF — valor total da NF-e',
  v_tot_trib            DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ICMSTot/vTotTrib',
  -- ISSQNtot (minOccurs=0)
  issqn_v_serv          DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vServ',
  issqn_v_bc            DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vBC',
  issqn_v_iss           DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vISS',
  issqn_v_pis           DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vPIS',
  issqn_v_cofins        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vCOFINS',
  issqn_d_compet        DATE                 NULL                   COMMENT 'tagXSD: ISSQNtot/dCompet',
  issqn_v_deducao       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vDeducao',
  issqn_v_outro         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vOutro',
  issqn_v_desc_incond   DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vDescIncond',
  issqn_v_desc_cond     DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vDescCond',
  issqn_v_iss_ret       DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: ISSQNtot/vISSRet',
  issqn_c_reg_trib      TINYINT              NULL                   COMMENT 'tagXSD: ISSQNtot/cRegTrib (1–6)',
  -- retTrib (minOccurs=0)
  ret_v_ret_pis         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTrib/vRetPIS',
  ret_v_ret_cofins      DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTrib/vRetCOFINS',
  ret_v_ret_csll        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTrib/vRetCSLL',
  ret_v_bc_irrf         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTrib/vBCIRRF',
  ret_v_irrf            DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTrib/vIRRF',
  ret_v_bc_ret_prev     DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTrib/vBCRetPrev',
  ret_v_ret_prev        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTrib/vRetPrev',
  created_at            DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_total_nfe (id_nfe),
  CONSTRAINT fk_total_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Totais da NF-e — elemento total (ICMSTot + ISSQNtot + retTrib)';


-- 22. TRANSPORTE
-- Elemento transp — transportador + veículo + reboque embutidos
CREATE TABLE IF NOT EXISTS nfe_transp (
  id                  INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe              INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  mod_frete           TINYINT          NOT NULL                   COMMENT 'tagXSD: modFrete — 0=emit;1=dest;2=terc;9=sem frete',
  -- transporta (minOccurs=0)
  transp_cnpj         VARCHAR(14)          NULL                   COMMENT 'tagXSD: transporta/CNPJ',
  transp_cpf          VARCHAR(11)          NULL                   COMMENT 'tagXSD: transporta/CPF',
  transp_x_nome       VARCHAR(60)          NULL                   COMMENT 'tagXSD: transporta/xNome',
  transp_ie           VARCHAR(14)          NULL                   COMMENT 'tagXSD: transporta/IE',
  transp_x_ender      VARCHAR(60)          NULL                   COMMENT 'tagXSD: transporta/xEnder',
  transp_x_mun        VARCHAR(60)          NULL                   COMMENT 'tagXSD: transporta/xMun',
  transp_uf           CHAR(2)              NULL                   COMMENT 'tagXSD: transporta/UF',
  -- retTransp (minOccurs=0)
  ret_v_serv          DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTransp/vServ',
  ret_v_bc_ret        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTransp/vBCRet',
  ret_p_icms_ret      DECIMAL(7,4)         NULL                   COMMENT 'tagXSD: retTransp/pICMSRet',
  ret_v_icms_ret      DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: retTransp/vICMSRet',
  ret_cfop            VARCHAR(4)           NULL                   COMMENT 'tagXSD: retTransp/CFOP',
  ret_cod_mun_fg      CHAR(7)              NULL                   COMMENT 'tagXSD: retTransp/cMunFG',
  -- veicTransp (TVeiculo, minOccurs=0)
  veic_placa          VARCHAR(8)           NULL                   COMMENT 'tagXSD: veicTransp/placa',
  veic_uf             CHAR(2)              NULL                   COMMENT 'tagXSD: veicTransp/UF',
  veic_rntc           VARCHAR(20)          NULL                   COMMENT 'tagXSD: veicTransp/RNTC',
  -- vagao / balsa (xs:choice com veicTransp/reboque)
  vagao               VARCHAR(20)          NULL                   COMMENT 'tagXSD: vagao',
  balsa               VARCHAR(20)          NULL                   COMMENT 'tagXSD: balsa',
  created_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_transp_nfe (id_nfe),
  CONSTRAINT fk_transp_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Transporte da NF-e — elemento transp';


-- 23. REBOQUE
-- Elemento reboque (TVeiculo, minOccurs=0, maxOccurs=5)
CREATE TABLE IF NOT EXISTS nfe_transp_reboque (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_transp INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_transp',
  placa         VARCHAR(8)       NOT NULL                   COMMENT 'tagXSD: placa',
  uf            CHAR(2)          NOT NULL                   COMMENT 'tagXSD: UF',
  rntc          VARCHAR(20)          NULL                   COMMENT 'tagXSD: RNTC',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_reboque_transp (id_nfe_transp),
  CONSTRAINT fk_reboque_transp FOREIGN KEY (id_nfe_transp) REFERENCES nfe_transp (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Reboque / Dolly — elemento reboque (maxOccurs=5)';


-- 24. VOLUMES TRANSPORTADOS
-- Elemento vol dentro de transp (minOccurs=0, maxOccurs=5000)
CREATE TABLE IF NOT EXISTS nfe_transp_vol (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_transp INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_transp',
  q_vol         VARCHAR(15)          NULL                   COMMENT 'tagXSD: qVol — quantidade de volumes',
  esp           VARCHAR(60)          NULL                   COMMENT 'tagXSD: esp — espécie',
  marca         VARCHAR(60)          NULL                   COMMENT 'tagXSD: marca',
  n_vol         VARCHAR(60)          NULL                   COMMENT 'tagXSD: nVol — numeração',
  peso_l        DECIMAL(15,3)        NULL                   COMMENT 'tagXSD: pesoL — peso líquido (kg)',
  peso_b        DECIMAL(15,3)        NULL                   COMMENT 'tagXSD: pesoB — peso bruto (kg)',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_vol_transp (id_nfe_transp),
  CONSTRAINT fk_vol_transp FOREIGN KEY (id_nfe_transp) REFERENCES nfe_transp (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Volumes transportados — elemento vol (maxOccurs=5000)';


-- 25. LACRES DOS VOLUMES
-- Elemento lacres dentro de vol (minOccurs=0, maxOccurs=5000)
CREATE TABLE IF NOT EXISTS nfe_transp_lacre (
  id                  INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_transp_vol   INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_transp_vol',
  n_lacre             VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: nLacre — número do lacre',
  created_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_lacre_vol (id_nfe_transp_vol),
  CONSTRAINT fk_lacre_vol FOREIGN KEY (id_nfe_transp_vol) REFERENCES nfe_transp_vol (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Lacres dos volumes — elemento lacres (maxOccurs=5000)';


-- 26. FATURA
-- Elemento cobr/fat (minOccurs=0)
CREATE TABLE IF NOT EXISTS nfe_cobr_fat (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  n_fat         VARCHAR(60)          NULL                   COMMENT 'tagXSD: nFat — número da fatura',
  v_orig        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vOrig — valor original',
  v_desc        DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vDesc — desconto da fatura',
  v_liq         DECIMAL(15,2)        NULL                   COMMENT 'tagXSD: vLiq — valor líquido',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_fat_nfe (id_nfe),
  CONSTRAINT fk_fat_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fatura de cobrança — elemento cobr/fat';


-- 27. DUPLICATAS
-- Elemento cobr/dup (minOccurs=0, maxOccurs=120)
CREATE TABLE IF NOT EXISTS nfe_cobr_dup (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  n_dup         VARCHAR(60)          NULL                   COMMENT 'tagXSD: nDup — número da duplicata',
  d_venc        DATE                 NULL                   COMMENT 'tagXSD: dVenc — data de vencimento',
  v_dup         DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vDup — valor da duplicata',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_dup_nfe (id_nfe),
  CONSTRAINT fk_dup_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Duplicatas — elemento cobr/dup (maxOccurs=120)';


-- 28. PAGAMENTOS
-- Elemento pag (minOccurs=0, maxOccurs=100) — obrigatório para NFC-e
CREATE TABLE IF NOT EXISTS nfe_pag (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe          INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  t_pag           CHAR(2)          NOT NULL                   COMMENT 'tagXSD: tPag — 01=din;02=chq;03=cartCred;...',
  v_pag           DECIMAL(15,2)    NOT NULL                   COMMENT 'tagXSD: vPag',
  card_tp_integra TINYINT              NULL                   COMMENT 'tagXSD: card/tpIntegra — 1=integrado;2=não integrado',
  card_cnpj       VARCHAR(14)          NULL                   COMMENT 'tagXSD: card/CNPJ — credenciadora',
  card_t_band     CHAR(2)              NULL                   COMMENT 'tagXSD: card/tBand — 01=Visa;...;99=Outros',
  card_c_aut      VARCHAR(20)          NULL                   COMMENT 'tagXSD: card/cAut — número de autorização',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_pag_nfe (id_nfe),
  CONSTRAINT fk_pag_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Pagamentos — elemento pag (maxOccurs=100)';


-- 29. INFORMAÇÕES ADICIONAIS
-- Elemento infAdic (minOccurs=0)
CREATE TABLE IF NOT EXISTS nfe_inf_adic (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe          INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  inf_ad_fisco    TEXT                 NULL                   COMMENT 'tagXSD: infAdFisco (até 2000 chars)',
  inf_cpl         TEXT                 NULL                   COMMENT 'tagXSD: infCpl — informações complementares (até 5000 chars)',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_infadic_nfe (id_nfe),
  CONSTRAINT fk_infadic_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Informações adicionais — elemento infAdic';


-- 30. OBSERVAÇÕES DO CONTRIBUINTE / FISCO
-- Elementos obsCont e obsFisco dentro de infAdic (maxOccurs=10 cada)
CREATE TABLE IF NOT EXISTS nfe_inf_adic_obs (
  id                INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_inf_adic   INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_inf_adic',
  tipo              VARCHAR(10)      NOT NULL                   COMMENT 'cont | fisco',
  x_campo           VARCHAR(20)      NOT NULL                   COMMENT 'tagXSD: @xCampo',
  x_texto           VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xTexto',
  created_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_obs_infadic (id_nfe_inf_adic),
  CONSTRAINT fk_obs_infadic FOREIGN KEY (id_nfe_inf_adic) REFERENCES nfe_inf_adic (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Observações do contribuinte/fisco — obsCont + obsFisco (maxOccurs=10 cada)';


-- 31. PROCESSOS REFERENCIADOS
-- Elemento procRef dentro de infAdic (minOccurs=0, maxOccurs=100)
CREATE TABLE IF NOT EXISTS nfe_inf_adic_proc_ref (
  id                INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe_inf_adic   INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe_inf_adic',
  n_proc            VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: nProc — identificador do processo',
  ind_proc          TINYINT          NOT NULL                   COMMENT 'tagXSD: indProc — 0=SEFAZ;1=Fed;2=Est;3=Secex;9=Outros',
  created_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_procref_infadic (id_nfe_inf_adic),
  CONSTRAINT fk_procref_infadic FOREIGN KEY (id_nfe_inf_adic) REFERENCES nfe_inf_adic (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Processos referenciados — elemento procRef (maxOccurs=100)';


-- 32. EXPORTAÇÃO
-- Elemento exporta (minOccurs=0)
CREATE TABLE IF NOT EXISTS nfe_exporta (
  id              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe          INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  uf_saida_pais   CHAR(2)          NOT NULL                   COMMENT 'tagXSD: UFSaidaPais — UF de embarque',
  x_loc_exporta   VARCHAR(60)      NOT NULL                   COMMENT 'tagXSD: xLocExporta',
  x_loc_despacho  VARCHAR(60)          NULL                   COMMENT 'tagXSD: xLocDespacho',
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_exporta_nfe (id_nfe),
  CONSTRAINT fk_exporta_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Informações de exportação — elemento exporta';


-- 33. COMPRA
-- Elemento compra (minOccurs=0) — nota de empenho, pedido e contrato
CREATE TABLE IF NOT EXISTS nfe_compra (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  x_n_emp       VARCHAR(22)          NULL                   COMMENT 'tagXSD: xNEmp — nota de empenho (compras públicas)',
  x_ped         VARCHAR(60)          NULL                   COMMENT 'tagXSD: xPed',
  x_cont        VARCHAR(60)          NULL                   COMMENT 'tagXSD: xCont',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_compra_nfe (id_nfe),
  CONSTRAINT fk_compra_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Informações de compra — elemento compra';


-- 34. PROTOCOLO DE AUTORIZAÇÃO
-- Tipo TProtNFe — resultado do processamento da NF-e pela SEFAZ
CREATE TABLE IF NOT EXISTS nfe_protocolo (
  id            INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_nfe        INT UNSIGNED     NOT NULL                   COMMENT 'FK → nfe',
  tp_amb        TINYINT(1)       NOT NULL                   COMMENT 'tagXSD: tpAmb — 1=produção;2=homologação',
  ver_aplic     VARCHAR(20)      NOT NULL                   COMMENT 'tagXSD: verAplic',
  ch_nfe        CHAR(44)         NOT NULL                   COMMENT 'tagXSD: chNFe — chave de acesso',
  dh_recbto     DATETIME         NOT NULL                   COMMENT 'tagXSD: dhRecbto — data/hora de processamento',
  n_prot        CHAR(15)             NULL                   COMMENT 'tagXSD: nProt — número do protocolo',
  c_stat        CHAR(3)          NOT NULL                   COMMENT 'tagXSD: cStat — código do status',
  x_motivo      VARCHAR(255)     NOT NULL                   COMMENT 'tagXSD: xMotivo — descrição do status',
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_fk_prot_nfe (id_nfe),
  CONSTRAINT fk_prot_nfe FOREIGN KEY (id_nfe) REFERENCES nfe (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Protocolo de autorização da NF-e — TProtNFe';
