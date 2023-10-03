unit ESPAPI.Types;

interface

  { /api_allowance }

type
  TESP_Allowance = record
    Count: Integer;
    Limit: Integer;
    AllowanceType: string;
    ResponseCode: Integer;
  end;

  { /status }

type
  TESP_Status_NextStatus = record
    Stage: string;
    StageStartDateTime: TDateTime;
  end;

type
  TESP_StatusObject = record
    Description: string;
    NextStages: TArray<TESP_Status_NextStatus>;
    Stage: string;
    StageUpdated: TDateTime;
  end;

type
  TESP_Status = record
    CapeTown: TESP_StatusObject;
    Eskom: TESP_StatusObject;
    ResponseCode: Integer;
  end;

  { /areas_search } { /areas_nearby }

type
  TESP_Area = record
    ID: string;
    AreaName: string;
    Region: string;
  end;

type
  TESP_AreaResponse = record
    Areas: TArray<TESP_Area>;
    ResponseCode: Integer;
  end;

  { /area }

type
  TESP_AreaInfo_Events = record
  end;

type
  TESP_AreaInfo_Info = record
  end;

type
  TESP_AreaInfo_Schedule = record
  end;

type
  TESP_AreaInfoResponse = record
  end;

implementation

end.

