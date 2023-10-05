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
  TESP_AreaInfo_Event = record
    EventEnd: TDateTime;
    Note: string;
    EventStart: TDateTime;
  end;

type
  TESP_AreaInfo_Info = record
    Name: string;
    Region: string;
  end;

type
  TESP_AreaInfo_ScheduleDay = record
    Date: string;
    Name: string;
    Stages: TArray<TArray<string>>;
  end;

type
  TESP_AreaInfo_Schedule = record
    Days: TArray<TESP_AreaInfo_ScheduleDay>;
    Source: string;
  end;

type
  TESP_AreaInfoResponse = record
    Events: TArray<TESP_AreaInfo_Event>;
    Info: TESP_AreaInfo_Info;
    Schedule: TESP_AreaInfo_Schedule;
    ResponseCode: Integer;
  end;

  { /topics_nearby }

type
  TESP_NearbyTopic = record
    Active: TDateTime;
    Body: string;
    Category: string;
    Distance: Double;
    Followers: Integer;
    Timestamp: TDateTime;
  end;

type
  TESP_NearbyTopicResponse = record
    Topics: TArray<TESP_NearbyTopic>;
    ResponseCode: Integer;
  end;

implementation

end.

