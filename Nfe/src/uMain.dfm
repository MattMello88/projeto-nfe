object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Sistema NF-e'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mnuPrincipal
  TextHeight = 15
  object mnuPrincipal: TMainMenu
    object mnuCadastros: TMenuItem
      Caption = 'Cadastros'
      object mnuCadNfe: TMenuItem
        Caption = 'NF-e'
        OnClick = mnuCadNfeClick
      end
    end
  end
end
