program Delphi_ESP_API_Test;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ESPAPI in 'API\ESPAPI.pas',
  ESPAPI.Types in 'API\ESPAPI.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
