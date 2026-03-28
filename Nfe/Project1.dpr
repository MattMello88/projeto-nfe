program Project1;

uses
  Vcl.Forms,
  uMain          in 'src\uMain.pas'                {frmMain},
  uDmPrincipal   in 'src\uDmPrincipal.pas'         {dmPrincipal: TDataModule},
  uFrmCadastroPai      in 'src\uFrmCadastroPai.pas'      {frmCadastroPai},
  uFrmCadastroPaiFilho in 'src\uFrmCadastroPaiFilho.pas' {frmCadastroPaiFilho},
  uDmNfe         in 'src\uDmNfe.pas'               {dmNfe: TDataModule},
  uFrmNfe        in 'src\uFrmNfe.pas'              {frmNfe};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrincipal, dmPrincipal);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
