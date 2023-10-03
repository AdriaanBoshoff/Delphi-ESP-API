unit ESPAPI;

interface

uses
  System.JSON, System.DateUtils, Rest.Client, Rest.Types, ESPAPI.Types;

type
  TESP = class
  private
  { Private Const }
    const
      API_URL = 'https://developer.sepush.co.za/business/2.0';
      APIPath_ALLOWANCE = '/api_allowance';
      APIPath_STATUS = '/status';
      APIPath_AREASEARCH_Text = '/areas_search';
      APIPath_AREASEARCH_GPS = '/areas_nearby';
  private
  { Private Methods }
    function SetupRest(const APIPath: string = ''): TRESTRequest;
  public
  { Public Variables }
    Token: string;
  public
  { Public Methods }
    function GetAllowance: TESP_Allowance;
    function GetStatus: TESP_Status;
    function GetAreaSearchText(const Text: string): TESP_AreaResponse;
    function GetAreaSearchGPS(const Lat, Long: string): TESP_AreaResponse;
  end;

implementation

{ TESP }

function TESP.GetAllowance: TESP_Allowance;
begin
  var rest := Self.SetupRest(APIPath_ALLOWANCE);
  try
    rest.Execute;

    Result.ResponseCode := rest.Response.StatusCode;

    if Result.ResponseCode = 200 then
    begin
      Result.Count := rest.Response.JSONValue.GetValue<Integer>('allowance.count');
      Result.Limit := rest.Response.JSONValue.GetValue<Integer>('allowance.limit');
      Result.AllowanceType := rest.Response.JSONValue.GetValue<string>('allowance.type');
    end;
  finally
    rest.Free;
  end;
end;

function TESP.GetAreaSearchGPS(const Lat, Long: string): TESP_AreaResponse;
begin
  var rest := Self.SetupRest(APIPath_AREASEARCH_GPS);
  try
    rest.AddParameter('lat', Lat);
    rest.AddParameter('lon', Lat);

    rest.Execute;

    Result.ResponseCode := rest.Response.StatusCode;

    if Result.ResponseCode = 200 then
    begin
      SetLength(Result.Areas, (rest.Response.JSONValue.FindValue('areas') as TJSONArray).Count);
      var index := 0;
      for var area in (rest.Response.JSONValue.FindValue('areas') as TJSONArray) do
      begin
        Result.Areas[index].ID := area.GetValue<string>('id');
        Result.Areas[index].AreaName := area.GetValue<string>('name');
        Result.Areas[index].Region := area.GetValue<string>('region');

        Inc(index);
      end;
    end;
  finally
    rest.Free;
  end;
end;

function TESP.GetAreaSearchText(const Text: string): TESP_AreaResponse;
begin
  var rest := Self.SetupRest(APIPath_AREASEARCH_Text);
  try
    rest.AddParameter('text', Text);

    rest.Execute;

    Result.ResponseCode := rest.Response.StatusCode;

    if Result.ResponseCode = 200 then
    begin
      SetLength(Result.Areas, (rest.Response.JSONValue.FindValue('areas') as TJSONArray).Count);
      var index := 0;
      for var area in (rest.Response.JSONValue.FindValue('areas') as TJSONArray) do
      begin
        Result.Areas[index].ID := area.GetValue<string>('id');
        Result.Areas[index].AreaName := area.GetValue<string>('name');
        Result.Areas[index].Region := area.GetValue<string>('region');

        Inc(index);
      end;
    end;
  finally
    rest.Free;
  end;
end;

function TESP.GetStatus: TESP_Status;
begin
  var rest := Self.SetupRest(APIPath_STATUS);
  try
    rest.Execute;

    Result.ResponseCode := rest.Response.StatusCode;

    if Result.ResponseCode = 200 then
    begin
      var StageIndex := 0;

      // Cape Town
      Result.CapeTown.Description := rest.Response.JSONValue.GetValue<string>('status.capetown.name');
      SetLength(Result.CapeTown.NextStages, (rest.Response.JSONValue.FindValue('status.capetown.next_stages') as TJSONArray).Count);
      for var stage in rest.Response.JSONValue.FindValue('status.capetown.next_stages') as TJSONArray do
      begin
        Result.CapeTown.NextStages[StageIndex].Stage := stage.GetValue<string>('stage');
        Result.CapeTown.NextStages[StageIndex].StageStartDateTime := ISO8601ToDate(stage.GetValue<string>('stage_start_timestamp'), False);

        Inc(StageIndex);
      end;
      Result.CapeTown.Stage := rest.Response.JSONValue.GetValue<string>('status.capetown.stage');
      Result.CapeTown.StageUpdated := ISO8601ToDate(rest.Response.JSONValue.GetValue<string>('status.capetown.stage_updated'), False);

      // Eskom
      StageIndex := 0;
      Result.Eskom.Description := rest.Response.JSONValue.GetValue<string>('status.eskom.name');
      SetLength(Result.eskom.NextStages, (rest.Response.JSONValue.FindValue('status.eskom.next_stages') as TJSONArray).Count);
      for var stage in rest.Response.JSONValue.FindValue('status.eskom.next_stages') as TJSONArray do
      begin
        Result.eskom.NextStages[StageIndex].Stage := stage.GetValue<string>('stage');
        Result.eskom.NextStages[StageIndex].StageStartDateTime := ISO8601ToDate(stage.GetValue<string>('stage_start_timestamp'), False);

        Inc(StageIndex);
      end;
      Result.eskom.Stage := rest.Response.JSONValue.GetValue<string>('status.eskom.stage');
      Result.eskom.StageUpdated := ISO8601ToDate(rest.Response.JSONValue.GetValue<string>('status.eskom.stage_updated'), False);
    end;
  finally
    rest.Free;
  end;
end;

function TESP.SetupRest(const APIPath: string): TRESTRequest;
begin
  Result := TRESTRequest.Create(nil);
  Result.Client := TRESTClient.Create(Result);
  Result.Response := TRESTResponse.Create(Result);

  // Options
  Result.Client.RaiseExceptionOn500 := False;
  Result.Method := TRESTRequestMethod.rmGET;

  // API URL
  Result.Client.BaseURL := Self.API_URL;

  // API Path
  Result.Resource := APIPath;

  // Token
  Result.AddParameter('token', Self.Token, TRESTRequestParameterKind.pkHTTPHEADER);
end;

end.

