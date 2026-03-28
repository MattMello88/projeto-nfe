unit uFrmCadastroPai;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.DBGrids,
  Data.DB, Vcl.Grids, Vcl.Buttons;

type
  TfrmCadastroPai = class(TForm)
    pnlTopo: TPanel;
    dbnavMestre: TDBNavigator;
    btnExportarExcel: TButton;
    btnImportarExcel: TButton;
    sbarStatus: TStatusBar;
    pgcCadastro: TPageControl;
    tabLista: TTabSheet;
    grdLista: TDBGrid;
    tabFormulario: TTabSheet;
    pnlBotoesForm: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    pnlCampos: TPanel;
    dsMestre: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExportarExcelClick(Sender: TObject);
    procedure btnImportarExcelClick(Sender: TObject);
    procedure dsMestreStateChange(Sender: TObject);
    procedure grdListaDblClick(Sender: TObject);
    procedure dbnavMestreClick(Sender: TObject; Button: TNavigateBtn);
  protected
    { Filho deve sobrescrever para persistência }
    procedure DoSalvar; virtual; abstract;
    procedure DoCancelar; virtual;
    { Filho deve sobrescrever para validação de campos obrigatórios }
    function ValidarCampos: Boolean; virtual;
    { Navegação entre abas }
    procedure IrParaLista; virtual;
    procedure IrParaFormulario; virtual;
    { Hooks para Excel — filho sobrescreve para usar NativeExcel }
    procedure DoExportarExcel; virtual;
    procedure DoImportarExcel; virtual;
    { Atualiza sbarStatus com o estado atual do dsMestre.DataSet }
    procedure AtualizarStatus; virtual;
  end;

{ Não instanciar diretamente — usar apenas como ancestral herdado }

implementation

{$R *.dfm}

{ TfrmCadastroPai }

procedure TfrmCadastroPai.FormCreate(Sender: TObject);
begin
  pgcCadastro.ActivePage := tabLista;
  AtualizarStatus;
end;

procedure TfrmCadastroPai.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(dsMestre.DataSet) and
     (dsMestre.DataSet.State in [dsEdit, dsInsert]) then
  begin
    case MessageDlg('Existem alterações não salvas. Deseja descartá-las?',
                    mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
        begin
          dsMestre.DataSet.Cancel;
          CanClose := True;
        end;
      mrNo:
        CanClose := False;
    end;
  end;
end;

function TfrmCadastroPai.ValidarCampos: Boolean;
begin
  Result := True;
end;

procedure TfrmCadastroPai.DoCancelar;
begin
  if Assigned(dsMestre.DataSet) and
     (dsMestre.DataSet.State in [dsEdit, dsInsert]) then
    dsMestre.DataSet.Cancel;
end;

procedure TfrmCadastroPai.IrParaLista;
begin
  pgcCadastro.ActivePage := tabLista;
  AtualizarStatus;
end;

procedure TfrmCadastroPai.IrParaFormulario;
begin
  pgcCadastro.ActivePage := tabFormulario;
  AtualizarStatus;
end;

procedure TfrmCadastroPai.grdListaDblClick(Sender: TObject);
begin
  if Assigned(dsMestre.DataSet) and not dsMestre.DataSet.IsEmpty then
  begin
    dsMestre.DataSet.Edit;
    IrParaFormulario;
  end;
end;

procedure TfrmCadastroPai.dbnavMestreClick(Sender: TObject; Button: TNavigateBtn);
begin
  if Button = nbInsert then
    IrParaFormulario;
end;

procedure TfrmCadastroPai.AtualizarStatus;
var
  LEstado: string;
begin
  if not Assigned(dsMestre.DataSet) then
  begin
    sbarStatus.Panels[0].Text := 'Sem dataset';
    Exit;
  end;

  case dsMestre.DataSet.State of
    dsInactive: LEstado := 'Inativo';
    dsBrowse:   LEstado := 'Navegando';
    dsEdit:     LEstado := 'Editando';
    dsInsert:   LEstado := 'Inserindo';
    dsSetKey:   LEstado := 'Buscando';
  else
    LEstado := 'Aguarde...';
  end;

  sbarStatus.Panels[0].Text := LEstado;
end;

procedure TfrmCadastroPai.btnSalvarClick(Sender: TObject);
begin
  if not ValidarCampos then
    Exit;
  DoSalvar;
  IrParaLista;
  ModalResult := mrOk;
end;

procedure TfrmCadastroPai.btnCancelarClick(Sender: TObject);
begin
  DoCancelar;
  IrParaLista;
  ModalResult := mrCancel;
end;

procedure TfrmCadastroPai.btnExportarExcelClick(Sender: TObject);
begin
  DoExportarExcel;
end;

procedure TfrmCadastroPai.btnImportarExcelClick(Sender: TObject);
begin
  DoImportarExcel;
end;

procedure TfrmCadastroPai.dsMestreStateChange(Sender: TObject);
begin
  AtualizarStatus;
end;

procedure TfrmCadastroPai.DoExportarExcel;
var
  LSaveDialog: TSaveDialog;
begin
  {
    Sobrescreva este método na tela filha para integrar com NativeExcel.

    Exemplo de estrutura esperada no filho:

    procedure TfrmCliente.DoExportarExcel;
    var
      LSaveDialog: TSaveDialog;
      LXls: TXLSFile;        // NativeExcel
      LPlan: IXLSWorksheet;  // NativeExcel
    begin
      LSaveDialog := TSaveDialog.Create(nil);
      try
        LSaveDialog.DefaultExt := 'xlsx';
        LSaveDialog.Filter := 'Excel (*.xlsx)|*.xlsx';
        if not LSaveDialog.Execute then Exit;

        LXls := TXLSFile.Create;
        try
          LXls.NewFile(1);
          LPlan := LXls.GetSheet(0);
          LPlan.Name := 'Clientes';
          // escrever cabeçalhos e linhas percorrendo dsMestre.DataSet...
          LXls.Save(LSaveDialog.FileName);
        finally
          LXls.Free;
        end;
      finally
        LSaveDialog.Free;
      end;
    end;
  }
  LSaveDialog := TSaveDialog.Create(nil);
  try
    LSaveDialog.DefaultExt := 'xlsx';
    LSaveDialog.Filter := 'Excel (*.xlsx)|*.xlsx';
    LSaveDialog.Title := 'Exportar para Excel';
    if not LSaveDialog.Execute then
      Exit;
    ShowMessage('Exportação não implementada. Sobrescreva DoExportarExcel na tela filha.');
  finally
    LSaveDialog.Free;
  end;
end;

procedure TfrmCadastroPai.DoImportarExcel;
var
  LOpenDialog: TOpenDialog;
begin
  {
    Sobrescreva este método na tela filha para ler o arquivo com NativeExcel,
    validar cabeçalhos/tipos/FKs e gravar os registros em transação.
  }
  LOpenDialog := TOpenDialog.Create(nil);
  try
    LOpenDialog.DefaultExt := 'xlsx';
    LOpenDialog.Filter := 'Excel (*.xlsx)|*.xlsx|Excel 97-2003 (*.xls)|*.xls';
    LOpenDialog.Title := 'Importar do Excel';
    if not LOpenDialog.Execute then
      Exit;
    ShowMessage('Importação não implementada. Sobrescreva DoImportarExcel na tela filha.');
  finally
    LOpenDialog.Free;
  end;
end;

end.
