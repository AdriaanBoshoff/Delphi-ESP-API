# Delphi-ESP-API
 Delphi API to interface with ESP API

## ESP API Key and Documentation
* You can get your API key from here: https://eskomsepush.gumroad.com/l/api

* You can view the documentation from here: https://documenter.getpostman.com/view/1296288/UzQuNk3E

## Compatibility
* This API was made and tested with Delphi 11.3.
* Versions below 11.3 are not tested.
* This project uses inline variables and Rest.Client.

## Delphi Usage
You can view the test application in this repo on how to use the api. Below is a small example on how to view your remaining api calls for the day.

```delphi
// Create ESP class
 var esp := TESP.Create;
  try
    // Assign your api key
    esp.Token := edtToken.Text;

    // Get Allownace menthod
    var allowance := esp.GetAllowance;

    mmoAllowanceResult.BeginUpdate;
    try
      mmoAllowanceResult.ClearContent;

      // Check if reponse was successful
      if allowance.ResponseCode = 200 then
      begin
        mmoAllowanceResult.Lines.Add('Used: ' + allowance.Count.ToString);
        mmoAllowanceResult.Lines.Add('Limit: ' + allowance.Limit.ToString);
        mmoAllowanceResult.Lines.Add('Type: ' + allowance.AllowanceType);
      end
      else
      begin
        // Handle reponse if not successful.
        mmoAllowanceResult.Lines.Add('Response Code: ' + allowance.ResponseCode.ToString);
        mmoAllowanceResult.Lines.Add('Code Meaning: https://documenter.getpostman.com/view/1296288/UzQuNk3E#responses');
      end;
    finally
      mmoAllowanceResult.EndUpdate;
    end;
  finally
    // Free ESP class
    esp.Free;
  end;
```
