object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 300
  Width = 400
  object FDConnection: TFDConnection
    LoginPrompt = False
    Left = 56
    Top = 48
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Options.Isolation = xiReadCommitted
    Left = 176
    Top = 48
  end
  object FDTransactionLeitura: TFDTransaction
    Connection = FDConnection
    Options.AutoCommit = True
    Options.Isolation = xiReadCommitted
    Options.ReadOnly = True
    Left = 296
    Top = 48
  end
end
