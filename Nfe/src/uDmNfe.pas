unit uDmNfe;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Async,
  FireDAC.DApt;

type
  TdmNfe = class(TDataModule)
    qryNfe: TFDQuery;
    dsNfe: TDataSource;
    qryNfeDet: TFDQuery;
    dsNfeDet: TDataSource;
    qryNfeDetProd: TFDQuery;
    dsNfeDetProd: TDataSource;
    qryNfeIde: TFDQuery;
    dsNfeIde: TDataSource;
    qryNfeEmit: TFDQuery;
    dsNfeEmit: TDataSource;
    qryNfeDest: TFDQuery;
    dsNfeDest: TDataSource;
    qryNfeTotal: TFDQuery;
    dsNfeTotal: TDataSource;
    qryNfeTransp: TFDQuery;
    dsNfeTransp: TDataSource;
    qryNfeCobrFat: TFDQuery;
    dsNfeCobrFat: TDataSource;
    qryNfeCobrDup: TFDQuery;
    dsNfeCobrDup: TDataSource;
    qryNfePag: TFDQuery;
    dsNfePag: TDataSource;
    qryNfeProtocolo: TFDQuery;
    dsNfeProtocolo: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ConfigurarConexao;
    procedure ConfigurarMasterDetail;
    procedure FecharTodos;
  public
    procedure AbrirComFiltro(const DataIni, DataFim: TDateTime);
    procedure Salvar;
    procedure Cancelar;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  uDmPrincipal;

{ TdmNfe }

procedure TdmNfe.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexao;
  ConfigurarMasterDetail;
end;

procedure TdmNfe.ConfigurarConexao;
begin
  qryNfe.Connection          := dmPrincipal.FDConnection;
  qryNfeDet.Connection       := dmPrincipal.FDConnection;
  qryNfeDetProd.Connection   := dmPrincipal.FDConnection;
  qryNfeIde.Connection       := dmPrincipal.FDConnection;
  qryNfeEmit.Connection      := dmPrincipal.FDConnection;
  qryNfeDest.Connection      := dmPrincipal.FDConnection;
  qryNfeTotal.Connection     := dmPrincipal.FDConnection;
  qryNfeTransp.Connection    := dmPrincipal.FDConnection;
  qryNfeCobrFat.Connection   := dmPrincipal.FDConnection;
  qryNfeCobrDup.Connection   := dmPrincipal.FDConnection;
  qryNfePag.Connection       := dmPrincipal.FDConnection;
  qryNfeProtocolo.Connection := dmPrincipal.FDConnection;
end;

procedure TdmNfe.ConfigurarMasterDetail;
begin
  // nfe_det e nfe_det_prod
  qryNfeDet.MasterSource     := dsNfe;
  qryNfeDet.MasterFields     := 'id';

  qryNfeDetProd.MasterSource := dsNfeDet;
  qryNfeDetProd.MasterFields := 'id';

  // Sub-entidades 1:1 de nfe (todas ligadas ao mestre dsNfe pelo campo :id)
  qryNfeIde.MasterSource     := dsNfe;
  qryNfeIde.MasterFields     := 'id';

  qryNfeEmit.MasterSource    := dsNfe;
  qryNfeEmit.MasterFields    := 'id';

  qryNfeDest.MasterSource    := dsNfe;
  qryNfeDest.MasterFields    := 'id';

  qryNfeTotal.MasterSource   := dsNfe;
  qryNfeTotal.MasterFields   := 'id';

  qryNfeTransp.MasterSource  := dsNfe;
  qryNfeTransp.MasterFields  := 'id';

  qryNfeCobrFat.MasterSource := dsNfe;
  qryNfeCobrFat.MasterFields := 'id';

  // nfe_cobr_dup: 1:N, também ligado ao mestre por id_nfe
  qryNfeCobrDup.MasterSource := dsNfe;
  qryNfeCobrDup.MasterFields := 'id';

  qryNfePag.MasterSource     := dsNfe;
  qryNfePag.MasterFields     := 'id';

  qryNfeProtocolo.MasterSource := dsNfe;
  qryNfeProtocolo.MasterFields := 'id';
end;

procedure TdmNfe.AbrirComFiltro(const DataIni, DataFim: TDateTime);
begin
  FecharTodos;
  qryNfe.ParamByName('DataIni').AsDate := Int(DataIni);
  qryNfe.ParamByName('DataFim').AsDate := Int(DataFim);
  qryNfe.Open;
end;

procedure TdmNfe.FecharTodos;
begin
  if qryNfe.Active then
    qryNfe.Close;
  // As sub-queries fecham automaticamente pelo MasterSource quando qryNfe fecha
end;

procedure TdmNfe.Salvar;
var
  LQrys: array of TFDQuery;
  LQry: TFDQuery;
begin
  LQrys := [
    qryNfe, qryNfeIde, qryNfeEmit, qryNfeDest,
    qryNfeDet, qryNfeDetProd,
    qryNfeTotal, qryNfeTransp,
    qryNfeCobrFat, qryNfeCobrDup,
    qryNfePag, qryNfeProtocolo
  ];
  for LQry in LQrys do
    if LQry.State in [dsEdit, dsInsert] then
      LQry.Post;
end;

procedure TdmNfe.Cancelar;
var
  LQrys: array of TFDQuery;
  LQry: TFDQuery;
begin
  // Cancela na ordem inversa (detalhe antes do mestre)
  LQrys := [
    qryNfeDetProd, qryNfeDet,
    qryNfeProtocolo, qryNfePag,
    qryNfeCobrDup, qryNfeCobrFat,
    qryNfeTransp, qryNfeTotal,
    qryNfeDest, qryNfeEmit, qryNfeIde,
    qryNfe
  ];
  for LQry in LQrys do
    if LQry.State in [dsEdit, dsInsert] then
      LQry.Cancel;
end;

end.
