unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TfrmMain = class(TForm)
    mnuPrincipal: TMainMenu;
    mnuCadastros: TMenuItem;
    mnuCadNfe: TMenuItem;
    procedure mnuCadNfeClick(Sender: TObject);
  private
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uFrmNfe;

{ TfrmMain }

procedure TfrmMain.mnuCadNfeClick(Sender: TObject);
var
  LFrm: TfrmNfe;
begin
  LFrm := TfrmNfe.Create(Self);
  LFrm.Show;
end;

end.
