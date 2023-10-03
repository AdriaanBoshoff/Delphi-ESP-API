unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Layouts;

type
  TfrmMain = class(TForm)
    tbcMain: TTabControl;
    tbtmAllowance: TTabItem;
    tlbHeader: TToolBar;
    lblTokenHeader: TLabel;
    edtToken: TEdit;
    mmoAllowanceResult: TMemo;
    btnCheckAllowance: TButton;
    tbtmStatus: TTabItem;
    btnGetStatus: TButton;
    mmoStatusResult: TMemo;
    tbtmSearchAreasText: TTabItem;
    mmoSearchAreasText: TMemo;
    lytSearchAreasText: TLayout;
    edtSearchAreasText: TEdit;
    btnSearchAreasText: TEditButton;
    tbtmSearchAreasGPS: TTabItem;
    mmoSearchAreasGPSResult: TMemo;
    lytSearchAreasGPS: TLayout;
    lblLatHeader: TLabel;
    edtLat: TEdit;
    lblLongitude: TLabel;
    edtLong: TEdit;
    btnSearchAreasGPS: TButton;
    tbtmGetAreaInformation: TTabItem;
    mmoGetAreaInformationResult: TMemo;
    lytGetAreaInformation: TLayout;
    edtGetAreaInformation: TEdit;
    btnGetAreaInformationSearch: TEditButton;
    procedure btnGetStatusClick(Sender: TObject);
    procedure btnCheckAllowanceClick(Sender: TObject);
    procedure btnSearchAreasGPSClick(Sender: TObject);
    procedure btnSearchAreasTextClick(Sender: TObject);
    procedure edtSearchAreasTextKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  ESPAPI;

{$R *.fmx}

procedure TfrmMain.btnGetStatusClick(Sender: TObject);
begin
  var esp := TESP.Create;
  try
    esp.Token := edtToken.Text;

    var status := esp.GetStatus;

    mmoStatusResult.BeginUpdate;
    try
      mmoStatusResult.ClearContent;

      if status.ResponseCode = 200 then
      begin
        // Cape Town
        mmoStatusResult.Lines.Add('Cape Town:');
        mmoStatusResult.Lines.Add('Name: ' + status.CapeTown.Description);
        mmoStatusResult.Lines.Add('Stage: ' + status.CapeTown.Stage);
        mmoStatusResult.Lines.Add('Stage Updates: ' + DateTimeToStr(status.CapeTown.StageUpdated));
        mmoStatusResult.Lines.Add('Stages:');
        for var stage in status.CapeTown.NextStages do
        begin
          mmoStatusResult.Lines.Add('- Stage: ' + stage.Stage);
          mmoStatusResult.Lines.Add('- Stage Starts At: ' + DateTimeToStr(stage.StageStartDateTime));
        end;

        mmoStatusResult.Lines.Add('-----------------------------------------------------');

        // Eskom
        mmoStatusResult.Lines.Add('Eskom:');
        mmoStatusResult.Lines.Add('Name: ' + status.Eskom.Description);
        mmoStatusResult.Lines.Add('Stage: ' + status.Eskom.Stage);
        mmoStatusResult.Lines.Add('Stage Updates: ' + DateTimeToStr(status.Eskom.StageUpdated));
        mmoStatusResult.Lines.Add('Stages:');
        for var stage in status.Eskom.NextStages do
        begin
          mmoStatusResult.Lines.Add('- Stage: ' + stage.Stage);
          mmoStatusResult.Lines.Add('- Stage Starts At: ' + DateTimeToStr(stage.StageStartDateTime));
        end;
      end
      else
      begin
        mmoAllowanceResult.Lines.Add('Response Code: ' + status.ResponseCode.ToString);
        mmoAllowanceResult.Lines.Add('Code Meaning: https://documenter.getpostman.com/view/1296288/UzQuNk3E#responses');
      end;
    finally
      mmoStatusResult.EndUpdate;
    end;
  finally
    esp.Free;
  end;
end;

procedure TfrmMain.btnCheckAllowanceClick(Sender: TObject);
begin
  var esp := TESP.Create;
  try
    esp.Token := edtToken.Text;

    var allowance := esp.GetAllowance;

    mmoAllowanceResult.BeginUpdate;
    try
      mmoAllowanceResult.ClearContent;

      if allowance.ResponseCode = 200 then
      begin
        mmoAllowanceResult.Lines.Add('Used: ' + allowance.Count.ToString);
        mmoAllowanceResult.Lines.Add('Limit: ' + allowance.Limit.ToString);
        mmoAllowanceResult.Lines.Add('Type: ' + allowance.AllowanceType);
      end
      else
      begin
        mmoAllowanceResult.Lines.Add('Response Code: ' + allowance.ResponseCode.ToString);
        mmoAllowanceResult.Lines.Add('Code Meaning: https://documenter.getpostman.com/view/1296288/UzQuNk3E#responses');
      end;
    finally
      mmoAllowanceResult.EndUpdate;
    end;
  finally
    esp.Free;
  end;
end;

procedure TfrmMain.btnSearchAreasGPSClick(Sender: TObject);
begin
  var esp := TESP.Create;
  try
    esp.Token := edtToken.Text;

    var areas := esp.GetAreaSearchGPS(edtLat.Text, edtLong.Text);

    mmoSearchAreasGPSResult.BeginUpdate;
    try
      mmoSearchAreasGPSResult.ClearContent;

      if areas.ResponseCode = 200 then
      begin
        for var area in areas.Areas do
        begin
          mmoSearchAreasGPSResult.Lines.Add('ID: ' + area.ID);
          mmoSearchAreasGPSResult.Lines.Add('Name: ' + area.AreaName);
          mmoSearchAreasGPSResult.Lines.Add('Region: ' + area.Region);

          mmoSearchAreasGPSResult.Lines.Add(' ');
        end;
      end
      else
      begin
        mmoSearchAreasGPSResult.Lines.Add('Response Code: ' + areas.ResponseCode.ToString);
        mmoSearchAreasGPSResult.Lines.Add('Code Meaning: https://documenter.getpostman.com/view/1296288/UzQuNk3E#responses');
      end;
    finally
      mmoSearchAreasGPSResult.EndUpdate;
    end;
  finally
    esp.Free;
  end;
end;

procedure TfrmMain.btnSearchAreasTextClick(Sender: TObject);
begin
  var esp := TESP.Create;
  try
    esp.Token := edtToken.Text;

    var areas := esp.GetAreaSearchText(edtSearchAreasText.Text);

    mmoSearchAreasText.BeginUpdate;
    try
      mmoSearchAreasText.ClearContent;

      if areas.ResponseCode = 200 then
      begin
        for var area in areas.Areas do
        begin
          mmoSearchAreasText.Lines.Add('ID: ' + area.ID);
          mmoSearchAreasText.Lines.Add('Name: ' + area.AreaName);
          mmoSearchAreasText.Lines.Add('Region: ' + area.Region);

          mmoSearchAreasText.Lines.Add(' ');
        end;
      end
      else
      begin
        mmoSearchAreasText.Lines.Add('Response Code: ' + areas.ResponseCode.ToString);
        mmoSearchAreasText.Lines.Add('Code Meaning: https://documenter.getpostman.com/view/1296288/UzQuNk3E#responses');
      end;
    finally
      mmoSearchAreasText.EndUpdate;
    end;
  finally
    esp.Free;
  end;
end;

procedure TfrmMain.edtSearchAreasTextKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    btnSearchAreasTextClick(edtSearchAreasText);
end;

end.

