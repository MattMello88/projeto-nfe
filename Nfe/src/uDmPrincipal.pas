unit uDmPrincipal;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmPrincipal = class(TDataModule)
    FDConnection: TFDConnection;
    FDTransaction: TFDTransaction;
    FDTransactionLeitura: TFDTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure CarregarConfiguracao;
  public
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmPrincipal.DataModuleCreate(Sender: TObject);
begin
  CarregarConfiguracao;
  FDConnection.Connected := True;
end;

procedure TdmPrincipal.DataModuleDestroy(Sender: TObject);
begin
  if FDConnection.Connected then
    FDConnection.Connected := False;
end;

procedure TdmPrincipal.CarregarConfiguracao;
var
  Ini: TIniFile;
  CaminhoIni: string;
begin
  CaminhoIni := ChangeFileExt(ParamStr(0), '.ini');

  if not FileExists(CaminhoIni) then
    raise Exception.CreateFmt(
      'Arquivo de configuração não encontrado: %s', [CaminhoIni]);

  Ini := TIniFile.Create(CaminhoIni);
  try
    FDConnection.Params.DriverID    := 'MySQL';
    FDConnection.Params.Database    := Ini.ReadString('Database', 'Database', '');
    FDConnection.Params.Add('Server='      + Ini.ReadString('Database', 'Server', 'localhost'));
    FDConnection.Params.Add('Port='        + Ini.ReadString('Database', 'Port', '3306'));
    FDConnection.Params.UserName          := Ini.ReadString('Database', 'UserName', '');
    FDConnection.Params.Password          := Ini.ReadString('Database', 'Password', '');
    FDConnection.Params.Add('CharacterSet=utf8mb4');
  finally
    Ini.Free;
  end;
end;

end.
