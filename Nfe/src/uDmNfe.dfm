object dmNfe: TdmNfe
  OnCreate = DataModuleCreate
  Height = 525
  Width = 613
  PixelsPerInch = 120
  object qryNfe: TFDQuery
    SQL.Strings = (
      'SELECT'
      '  n.id,'
      '  n.chave,'
      '  i.serie,'
      '  i.num_nf,'
      '  i.dh_emi,'
      '  i.nat_op,'
      '  e.x_nome AS emitente,'
      '  d.x_nome AS destinatario,'
      '  t.v_nf'
      'FROM nfe n'
      'LEFT JOIN nfe_ide  i ON i.id_nfe = n.id'
      'LEFT JOIN nfe_emit e ON e.id_nfe = n.id'
      'LEFT JOIN nfe_dest d ON d.id_nfe = n.id'
      'LEFT JOIN nfe_total t ON t.id_nfe = n.id'
      'WHERE DATE(i.dh_emi) BETWEEN :DataIni AND :DataFim'
      'ORDER BY i.dh_emi DESC')
    Left = 10
    Top = 20
  end
  object dsNfe: TDataSource
    DataSet = qryNfe
    Left = 140
    Top = 20
  end
  object qryNfeDet: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_det WHERE id_nfe = :id ORDER BY n_item')
    Left = 10
    Top = 100
  end
  object dsNfeDet: TDataSource
    DataSet = qryNfeDet
    Left = 140
    Top = 100
  end
  object qryNfeDetProd: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_det_prod WHERE id_nfe_det = :id')
    Left = 10
    Top = 180
  end
  object dsNfeDetProd: TDataSource
    DataSet = qryNfeDetProd
    Left = 140
    Top = 180
  end
  object qryNfeIde: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_ide WHERE id_nfe = :id')
    Left = 10
    Top = 260
  end
  object dsNfeIde: TDataSource
    DataSet = qryNfeIde
    Left = 140
    Top = 260
  end
  object qryNfeEmit: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_emit WHERE id_nfe = :id')
    Left = 10
    Top = 340
  end
  object dsNfeEmit: TDataSource
    DataSet = qryNfeEmit
    Left = 140
    Top = 340
  end
  object qryNfeDest: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_dest WHERE id_nfe = :id')
    Left = 10
    Top = 420
  end
  object dsNfeDest: TDataSource
    DataSet = qryNfeDest
    Left = 140
    Top = 420
  end
  object qryNfeTotal: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_total WHERE id_nfe = :id')
    Left = 310
    Top = 20
  end
  object dsNfeTotal: TDataSource
    DataSet = qryNfeTotal
    Left = 450
    Top = 20
  end
  object qryNfeTransp: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_transp WHERE id_nfe = :id')
    Left = 310
    Top = 100
  end
  object dsNfeTransp: TDataSource
    DataSet = qryNfeTransp
    Left = 450
    Top = 100
  end
  object qryNfeCobrFat: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_cobr_fat WHERE id_nfe = :id')
    Left = 310
    Top = 180
  end
  object dsNfeCobrFat: TDataSource
    DataSet = qryNfeCobrFat
    Left = 450
    Top = 180
  end
  object qryNfeCobrDup: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_cobr_dup WHERE id_nfe = :id ORDER BY d_venc')
    Left = 310
    Top = 260
  end
  object dsNfeCobrDup: TDataSource
    DataSet = qryNfeCobrDup
    Left = 450
    Top = 260
  end
  object qryNfePag: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_pag WHERE id_nfe = :id')
    Left = 310
    Top = 340
  end
  object dsNfePag: TDataSource
    DataSet = qryNfePag
    Left = 450
    Top = 340
  end
  object qryNfeProtocolo: TFDQuery
    SQL.Strings = (
      'SELECT * FROM nfe_protocolo WHERE id_nfe = :id')
    Left = 310
    Top = 420
  end
  object dsNfeProtocolo: TDataSource
    DataSet = qryNfeProtocolo
    Left = 450
    Top = 420
  end
end
