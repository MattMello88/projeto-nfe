inherited frmNfe: TfrmNfe
  Caption = 'Cadastro de NF-e'
  ClientHeight = 640
  ClientWidth = 900
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 916
  ExplicitHeight = 679
  TextHeight = 15
  inherited pnlTopo: TPanel
    Width = 900
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 898
    inherited dbnavMestre: TDBNavigator
      Hints.Strings = ()
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inherited sbarStatus: TStatusBar
    Top = 617
    Width = 900
    ExplicitTop = 609
    ExplicitWidth = 898
  end
  inherited pgcCadastro: TPageControl
    Width = 900
    Height = 576
    ExplicitWidth = 898
    ExplicitHeight = 568
    inherited tabLista: TTabSheet
      ExplicitWidth = 892
      ExplicitHeight = 546
      inherited grdLista: TDBGrid
        Top = 41
        Width = 892
        Height = 505
      end
      object pnlFiltro: TPanel
        Left = 0
        Top = 0
        Width = 892
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object lblDataIni: TLabel
          Left = 8
          Top = 13
          Width = 17
          Height = 15
          Caption = 'De:'
        end
        object lblDataFim: TLabel
          Left = 172
          Top = 13
          Width = 21
          Height = 15
          Caption = 'At'#233':'
        end
        object edDataIni: TDateTimePicker
          Left = 32
          Top = 9
          Width = 121
          Height = 23
          Date = 46109.00000000000000000
          Time = 0.71096462963032540
          TabOrder = 0
        end
        object edDataFim: TDateTimePicker
          Left = 200
          Top = 9
          Width = 121
          Height = 23
          Date = 46109.00000000000000000
          Time = 0.71096462963032540
          TabOrder = 1
        end
        object btnConsultar: TButton
          Left = 336
          Top = 8
          Width = 90
          Height = 25
          Caption = 'Consultar'
          TabOrder = 2
          OnClick = btnConsultarClick
        end
      end
    end
    inherited tabFormulario: TTabSheet
      ExplicitWidth = 892
      ExplicitHeight = 546
      inherited pnlBotoesForm: TPanel
        Width = 892
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 890
      end
      inherited pnlCampos: TPanel
        Width = 892
        Height = 505
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 890
        ExplicitHeight = 497
        inherited splMestreDetalhe: TSplitter
          Width = 892
        end
        inherited pnlMestre: TPanel
          Width = 892
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 890
          object pgcNfe: TPageControl
            Left = 0
            Top = 0
            Width = 892
            Height = 200
            ActivePage = tabIdentificacao
            Align = alClient
            TabOrder = 0
            ExplicitWidth = 890
            object tabIdentificacao: TTabSheet
              Caption = 'Identifica'#231#227'o'
              object lblSerie: TLabel
                Left = 8
                Top = 12
                Width = 28
                Height = 15
                Caption = 'S'#233'rie:'
              end
              object lblNumNf: TLabel
                Left = 8
                Top = 42
                Width = 47
                Height = 15
                Caption = 'N'#250'mero:'
              end
              object lblDhEmi: TLabel
                Left = 8
                Top = 72
                Width = 46
                Height = 15
                Caption = 'Emiss'#227'o:'
              end
              object lblNatOp: TLabel
                Left = 8
                Top = 102
                Width = 47
                Height = 15
                Caption = 'Nat. Op.:'
              end
              object lblTpNf: TLabel
                Left = 340
                Top = 12
                Width = 37
                Height = 15
                Caption = 'Tp. NF:'
              end
              object lblTpAmb: TLabel
                Left = 340
                Top = 42
                Width = 55
                Height = 15
                Caption = 'Ambiente:'
              end
              object lblFinNfe: TLabel
                Left = 340
                Top = 72
                Width = 57
                Height = 15
                Caption = 'Finalidade:'
              end
              object edSerie: TDBEdit
                Left = 80
                Top = 8
                Width = 60
                Height = 23
                DataField = 'serie'
                TabOrder = 0
              end
              object edNumNf: TDBEdit
                Left = 80
                Top = 38
                Width = 100
                Height = 23
                DataField = 'num_nf'
                TabOrder = 1
              end
              object edDhEmi: TDBEdit
                Left = 80
                Top = 68
                Width = 150
                Height = 23
                DataField = 'dh_emi'
                TabOrder = 2
              end
              object edNatOp: TDBEdit
                Left = 80
                Top = 98
                Width = 240
                Height = 23
                DataField = 'nat_op'
                TabOrder = 3
              end
              object edTpNf: TDBEdit
                Left = 408
                Top = 8
                Width = 60
                Height = 23
                DataField = 'tp_nf'
                TabOrder = 4
              end
              object edTpAmb: TDBEdit
                Left = 408
                Top = 38
                Width = 60
                Height = 23
                DataField = 'tp_amb'
                TabOrder = 5
              end
              object edFinNfe: TDBEdit
                Left = 408
                Top = 68
                Width = 60
                Height = 23
                DataField = 'fin_nfe'
                TabOrder = 6
              end
            end
            object tabEmitente: TTabSheet
              Caption = 'Emitente'
              object lblEmitCnpj: TLabel
                Left = 8
                Top = 12
                Width = 30
                Height = 15
                Caption = 'CNPJ:'
              end
              object lblEmitNome: TLabel
                Left = 8
                Top = 42
                Width = 59
                Height = 15
                Caption = 'Raz'#227'o Soc.:'
              end
              object lblEmitFant: TLabel
                Left = 8
                Top = 72
                Width = 29
                Height = 15
                Caption = 'Fant.:'
              end
              object lblEmitIe: TLabel
                Left = 8
                Top = 102
                Width = 12
                Height = 15
                Caption = 'IE:'
              end
              object lblEmitCrt: TLabel
                Left = 8
                Top = 132
                Width = 24
                Height = 15
                Caption = 'CRT:'
              end
              object edEmitCnpj: TDBEdit
                Left = 80
                Top = 8
                Width = 160
                Height = 23
                DataField = 'cnpj'
                TabOrder = 0
              end
              object edEmitNome: TDBEdit
                Left = 80
                Top = 38
                Width = 300
                Height = 23
                DataField = 'x_nome'
                TabOrder = 1
              end
              object edEmitFant: TDBEdit
                Left = 80
                Top = 68
                Width = 300
                Height = 23
                DataField = 'x_fant'
                TabOrder = 2
              end
              object edEmitIe: TDBEdit
                Left = 80
                Top = 98
                Width = 160
                Height = 23
                DataField = 'ie'
                TabOrder = 3
              end
              object edEmitCrt: TDBEdit
                Left = 80
                Top = 128
                Width = 60
                Height = 23
                DataField = 'crt'
                TabOrder = 4
              end
            end
            object tabDestinatario: TTabSheet
              Caption = 'Destinat'#225'rio'
              object lblDestCnpj: TLabel
                Left = 8
                Top = 12
                Width = 30
                Height = 15
                Caption = 'CNPJ:'
              end
              object lblDestCpf: TLabel
                Left = 8
                Top = 42
                Width = 24
                Height = 15
                Caption = 'CPF:'
              end
              object lblDestNome: TLabel
                Left = 8
                Top = 72
                Width = 36
                Height = 15
                Caption = 'Nome:'
              end
              object lblDestIe: TLabel
                Left = 8
                Top = 102
                Width = 12
                Height = 15
                Caption = 'IE:'
              end
              object lblDestEmail: TLabel
                Left = 8
                Top = 132
                Width = 37
                Height = 15
                Caption = 'E-mail:'
              end
              object edDestCnpj: TDBEdit
                Left = 80
                Top = 8
                Width = 160
                Height = 23
                DataField = 'cnpj'
                TabOrder = 0
              end
              object edDestCpf: TDBEdit
                Left = 80
                Top = 38
                Width = 120
                Height = 23
                DataField = 'cpf'
                TabOrder = 1
              end
              object edDestNome: TDBEdit
                Left = 80
                Top = 68
                Width = 300
                Height = 23
                DataField = 'x_nome'
                TabOrder = 2
              end
              object edDestIe: TDBEdit
                Left = 80
                Top = 98
                Width = 160
                Height = 23
                DataField = 'ie'
                TabOrder = 3
              end
              object edDestEmail: TDBEdit
                Left = 80
                Top = 128
                Width = 240
                Height = 23
                DataField = 'email'
                TabOrder = 4
              end
            end
            object tabTotais: TTabSheet
              Caption = 'Totais'
              object lblTotVBc: TLabel
                Left = 8
                Top = 12
                Width = 45
                Height = 15
                Caption = 'Base BC:'
              end
              object lblTotVIcms: TLabel
                Left = 8
                Top = 42
                Width = 31
                Height = 15
                Caption = 'ICMS:'
              end
              object lblTotVProd: TLabel
                Left = 8
                Top = 72
                Width = 67
                Height = 15
                Caption = 'Vl. Produtos:'
              end
              object lblTotVNf: TLabel
                Left = 8
                Top = 102
                Width = 58
                Height = 15
                Caption = 'Total NF-e:'
              end
              object edTotVBc: TDBEdit
                Left = 100
                Top = 8
                Width = 120
                Height = 23
                DataField = 'v_bc'
                ReadOnly = True
                TabOrder = 0
              end
              object edTotVIcms: TDBEdit
                Left = 100
                Top = 38
                Width = 120
                Height = 23
                DataField = 'v_icms'
                ReadOnly = True
                TabOrder = 1
              end
              object edTotVProd: TDBEdit
                Left = 100
                Top = 68
                Width = 120
                Height = 23
                DataField = 'v_prod'
                ReadOnly = True
                TabOrder = 2
              end
              object edTotVNf: TDBEdit
                Left = 100
                Top = 98
                Width = 120
                Height = 23
                DataField = 'v_nf'
                ReadOnly = True
                TabOrder = 3
              end
            end
            object tabTransporte: TTabSheet
              Caption = 'Transporte'
              object lblModFrete: TLabel
                Left = 8
                Top = 12
                Width = 60
                Height = 15
                Caption = 'Mod. Frete:'
              end
              object lblTranspNome: TLabel
                Left = 8
                Top = 42
                Width = 83
                Height = 15
                Caption = 'Transportadora:'
              end
              object lblTranspIe: TLabel
                Left = 8
                Top = 72
                Width = 53
                Height = 15
                Caption = 'IE Transp.:'
              end
              object edModFrete: TDBEdit
                Left = 100
                Top = 8
                Width = 60
                Height = 23
                DataField = 'mod_frete'
                TabOrder = 0
              end
              object edTranspNome: TDBEdit
                Left = 100
                Top = 38
                Width = 280
                Height = 23
                DataField = 'transp_x_nome'
                TabOrder = 1
              end
              object edTranspIe: TDBEdit
                Left = 100
                Top = 68
                Width = 160
                Height = 23
                DataField = 'transp_ie'
                TabOrder = 2
              end
            end
            object tabCobranca: TTabSheet
              Caption = 'Cobran'#231'a'
              object pnlFatura: TPanel
                Left = 0
                Top = 0
                Width = 884
                Height = 60
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                object lblFatNFat: TLabel
                  Left = 8
                  Top = 12
                  Width = 51
                  Height = 15
                  Caption = 'N. Fatura:'
                end
                object lblFatVOrig: TLabel
                  Left = 200
                  Top = 12
                  Width = 45
                  Height = 15
                  Caption = 'Vl. Orig.:'
                end
                object lblFatVDesc: TLabel
                  Left = 370
                  Top = 12
                  Width = 53
                  Height = 15
                  Caption = 'Desconto:'
                end
                object lblFatVLiq: TLabel
                  Left = 540
                  Top = 12
                  Width = 59
                  Height = 15
                  Caption = 'Vl. L'#237'quido:'
                end
                object edFatNFat: TDBEdit
                  Left = 72
                  Top = 8
                  Width = 110
                  Height = 23
                  DataField = 'n_fat'
                  TabOrder = 0
                end
                object edFatVOrig: TDBEdit
                  Left = 256
                  Top = 8
                  Width = 100
                  Height = 23
                  DataField = 'v_orig'
                  TabOrder = 1
                end
                object edFatVDesc: TDBEdit
                  Left = 430
                  Top = 8
                  Width = 100
                  Height = 23
                  DataField = 'v_desc'
                  TabOrder = 2
                end
                object edFatVLiq: TDBEdit
                  Left = 606
                  Top = 8
                  Width = 100
                  Height = 23
                  DataField = 'v_liq'
                  TabOrder = 3
                end
              end
              object grdDuplicatas: TDBGrid
                Left = 0
                Top = 60
                Width = 884
                Height = 110
                Align = alClient
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -12
                TitleFont.Name = 'Segoe UI'
                TitleFont.Style = []
              end
            end
            object tabPagamentos: TTabSheet
              Caption = 'Pagamentos'
              object grdPagamentos: TDBGrid
                Left = 0
                Top = 0
                Width = 884
                Height = 170
                Align = alClient
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -12
                TitleFont.Name = 'Segoe UI'
                TitleFont.Style = []
              end
            end
            object tabProtocolo: TTabSheet
              Caption = 'Protocolo'
              object lblProtNProt: TLabel
                Left = 8
                Top = 12
                Width = 55
                Height = 15
                Caption = 'Protocolo:'
              end
              object lblProtDhRecbto: TLabel
                Left = 8
                Top = 42
                Width = 67
                Height = 15
                Caption = 'Dt. Recebto.:'
              end
              object lblProtCStat: TLabel
                Left = 8
                Top = 72
                Width = 35
                Height = 15
                Caption = 'Status:'
              end
              object lblProtXMotivo: TLabel
                Left = 8
                Top = 102
                Width = 41
                Height = 15
                Caption = 'Motivo:'
              end
              object edProtNProt: TDBEdit
                Left = 100
                Top = 8
                Width = 160
                Height = 23
                DataField = 'n_prot'
                ReadOnly = True
                TabOrder = 0
              end
              object edProtDhRecbto: TDBEdit
                Left = 100
                Top = 38
                Width = 160
                Height = 23
                DataField = 'dh_recbto'
                ReadOnly = True
                TabOrder = 1
              end
              object edProtCStat: TDBEdit
                Left = 100
                Top = 68
                Width = 60
                Height = 23
                DataField = 'c_stat'
                ReadOnly = True
                TabOrder = 2
              end
              object edProtXMotivo: TDBEdit
                Left = 100
                Top = 98
                Width = 500
                Height = 23
                DataField = 'x_motivo'
                ReadOnly = True
                TabOrder = 3
              end
            end
          end
        end
        inherited pnlDetalhe: TPanel
          Width = 892
          Height = 301
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 890
          ExplicitHeight = 293
          inherited dbnavDetalhe: TDBNavigator
            Width = 892
            Hints.Strings = ()
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 890
          end
          inherited grdItens: TDBGrid
            Width = 892
            Height = 276
          end
        end
      end
    end
  end
end
