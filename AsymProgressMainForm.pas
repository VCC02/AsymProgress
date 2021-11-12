unit AsymProgressMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Buttons, Spin, StdCtrls, AsymProgressSettingsForm;

type
  TFSMStates = (SInit, SWaitBeforeInc, SInc, SWaitBeforeDec, SDec);

  { TfrmAsymProgressMain }
  TfrmAsymProgressMain = class(TForm)
    bitbtnSettings: TBitBtn;
    bitbtnStart: TBitBtn;
    bitbtnStop: TBitBtn;
    bitbtnPause: TBitBtn;
    chkStopOnTimeout: TCheckBox;
    imgGraph: TImage;
    imglstGraphs: TImageList;
    lblOverallTime: TLabel;
    lblProgress: TLabel;
    lblHoldInc: TLabel;
    lblHoldDec: TLabel;
    lblInc: TLabel;
    lblDec: TLabel;
    lblHold: TLabel;
    lblActionProgress: TLabel;
    prbTime: TProgressBar;
    prbHold: TProgressBar;
    prbOverallTime: TProgressBar;
    shpHoldInc: TShape;
    shpInc: TShape;
    shpHoldDec: TShape;
    shpDec: TShape;
    shpProgress: TShape;
    shpMaxProgress: TShape;
    spnedtOverallTime: TSpinEdit;
    spnedtInc: TSpinEdit;
    spnedtHoldDec: TSpinEdit;
    spnedtDec: TSpinEdit;
    spnedtHoldInc: TSpinEdit;
    tmrOverallTime: TTimer;
    tmrStartup: TTimer;
    tmrFSM: TTimer;
    procedure bitbtnPauseClick(Sender: TObject);
    procedure bitbtnSettingsClick(Sender: TObject);
    procedure bitbtnStartClick(Sender: TObject);
    procedure bitbtnStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure spnedtOverallTimeChange(Sender: TObject);
    procedure tmrFSMTimer(Sender: TObject);
    procedure tmrOverallTimeTimer(Sender: TObject);
    procedure tmrStartupTimer(Sender: TObject);
  private
    FState: TFSMStates;
    FNextState: TFSMStates;
    FCustomSettings: TAsymSettings;

    function GetSettingsFileName: string;
    procedure UpdateComponentStateFromSettings;
    procedure LoadSettingsFromIni;
    procedure SaveSettingsToIni;

    procedure StartProgress;
    procedure PauseProgress;
    procedure StopProgress;
  public

  end;

var
  frmAsymProgressMain: TfrmAsymProgressMain;

implementation

{$R *.frm}

uses
  IniFiles;


{ TfrmAsymProgressMain }

procedure TfrmAsymProgressMain.FormCreate(Sender: TObject);
begin
  FState := SInit;
  FNextState := SInit;
  DoubleBuffered := True;
  tmrStartup.Enabled := True;
end;


procedure TfrmAsymProgressMain.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SaveSettingsToIni;
end;


function TfrmAsymProgressMain.GetSettingsFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'AsymProgress.ini';
end;


procedure TfrmAsymProgressMain.UpdateComponentStateFromSettings;
begin
  lblProgress.Visible := FCustomSettings.DisplayProgress;
  prbTime.Visible := FCustomSettings.DisplayProgress;

  lblHold.Visible := FCustomSettings.DisplayHoldProgress;
  prbHold.Visible := FCustomSettings.DisplayHoldProgress;

  lblActionProgress.Visible := FCustomSettings.DisplayActionProgress;
  shpProgress.Visible := FCustomSettings.DisplayActionProgress;
  shpMaxProgress.Visible := FCustomSettings.DisplayActionProgress;

  lblHoldDec.Visible := FCustomSettings.DisplayHoldComponents;
  shpHoldDec.Visible := FCustomSettings.DisplayHoldComponents;
  spnedtHoldDec.Visible := FCustomSettings.DisplayHoldComponents;
  lblHoldInc.Visible := FCustomSettings.DisplayHoldComponents;
  shpHoldInc.Visible := FCustomSettings.DisplayHoldComponents;
  spnedtHoldInc.Visible := FCustomSettings.DisplayHoldComponents;

  lblInc.Caption := FCustomSettings.IncText;
  lblHoldDec.Caption := FCustomSettings.HoldDecText;
  lblDec.Caption := FCustomSettings.DecText;
  lblHoldInc.Caption := FCustomSettings.HoldIncText;

  prbOverallTime.Max := spnedtOverallTime.Value;
end;


procedure TfrmAsymProgressMain.LoadSettingsFromIni;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(GetSettingsFileName);
  try
    Left := Ini.ReadInteger('Window', 'Left', 100);
    Top := Ini.ReadInteger('Window', 'Top', 100);
    Width := Ini.ReadInteger('Window', 'Width', Width);
    Height := Ini.ReadInteger('Window', 'Height', Height);

    FCustomSettings.DisplayProgress := Ini.ReadBool('Settings', 'DisplayProgress', True);
    FCustomSettings.DisplayHoldProgress := Ini.ReadBool('Settings', 'DisplayHoldProgress', True);
    FCustomSettings.DisplayActionProgress := Ini.ReadBool('Settings', 'DisplayActionProgress', True);
    FCustomSettings.DisplayHoldComponents := Ini.ReadBool('Settings', 'DisplayHoldComponents', True);

    FCustomSettings.IncText := Ini.ReadString('Settings', 'IncText', lblInc.Caption);
    FCustomSettings.HoldDecText := Ini.ReadString('Settings', 'HoldDecText', lblHoldDec.Caption);
    FCustomSettings.DecText := Ini.ReadString('Settings', 'DecText', lblDec.Caption);
    FCustomSettings.HoldIncText := Ini.ReadString('Settings', 'HoldIncText', lblHoldInc.Caption);

    chkStopOnTimeout.Checked := Ini.ReadBool('Settings', 'StopOnTimeout', chkStopOnTimeout.Checked);
    spnedtOverallTime.Value := Ini.ReadInteger('Settings', 'OverallTime', spnedtOverallTime.Value);

    spnedtInc.Value := Ini.ReadInteger('Settings', 'Inc', spnedtInc.Value);
    spnedtHoldDec.Value := Ini.ReadInteger('spnedtHoldDec', 'HoldDec', spnedtHoldDec.Value);
    spnedtDec.Value := Ini.ReadInteger('Settings', 'Dec', spnedtDec.Value);
    spnedtHoldInc.Value := Ini.ReadInteger('Settings', 'HoldInc', spnedtHoldInc.Value);

    UpdateComponentStateFromSettings;
  finally
    Ini.Free;
  end;
end;


procedure TfrmAsymProgressMain.SaveSettingsToIni;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(GetSettingsFileName);
  try
    Ini.WriteInteger('Window', 'Left', Left);
    Ini.WriteInteger('Window', 'Top', Top);
    Ini.WriteInteger('Window', 'Width', Width);
    Ini.WriteInteger('Window', 'Height', Height);

    Ini.WriteBool('Settings', 'DisplayProgress', FCustomSettings.DisplayProgress);
    Ini.WriteBool('Settings', 'DisplayHoldProgress', FCustomSettings.DisplayHoldProgress);
    Ini.WriteBool('Settings', 'DisplayActionProgress', FCustomSettings.DisplayActionProgress);
    Ini.WriteBool('Settings', 'DisplayHoldComponents', FCustomSettings.DisplayHoldComponents);

    Ini.WriteString('Settings', 'IncText', FCustomSettings.IncText);
    Ini.WriteString('Settings', 'HoldDecText', FCustomSettings.HoldDecText);
    Ini.WriteString('Settings', 'DecText', FCustomSettings.DecText);
    Ini.WriteString('Settings', 'HoldIncText', FCustomSettings.HoldIncText);

    Ini.WriteBool('Settings', 'StopOnTimeout', chkStopOnTimeout.Checked);
    Ini.WriteInteger('Settings', 'OverallTime', spnedtOverallTime.Value);

    Ini.WriteInteger('Settings', 'Inc', spnedtInc.Value);
    Ini.WriteInteger('spnedtHoldDec', 'HoldDec', spnedtHoldDec.Value);
    Ini.WriteInteger('Settings', 'Dec', spnedtDec.Value);
    Ini.WriteInteger('Settings', 'HoldInc', spnedtHoldInc.Value);

    try
      Ini.UpdateFile;
    except
      MessageDlg('Can''t save settings to file. Please verify permissions.', mtInformation, [mbOK], 0);
    end;
  finally
    Ini.Free;
  end;
end;


procedure TfrmAsymProgressMain.StartProgress;
begin
  FState := SInit;
  FNextState := SInit;
  tmrOverallTime.Tag := 0;

  tmrFSM.Enabled := True;
  tmrOverallTime.Enabled := True;

  bitbtnStart.Enabled := False;
  bitbtnPause.Enabled := True;
  bitbtnStop.Enabled := True;
end;


procedure TfrmAsymProgressMain.PauseProgress;
begin
  tmrFSM.Enabled := not tmrFSM.Enabled;
  tmrOverallTime.Enabled := tmrFSM.Enabled;

  if tmrFSM.Enabled then
    bitbtnPause.Caption := 'Pause'
  else
    bitbtnPause.Caption := 'Continue';
end;


procedure TfrmAsymProgressMain.StopProgress;
begin
  FState := SInit;
  FNextState := SInit;

  tmrFSM.Enabled := False;
  tmrOverallTime.Enabled := False;

  bitbtnStart.Enabled := True;
  bitbtnPause.Enabled := False;
  bitbtnStop.Enabled := False;
end;


procedure TfrmAsymProgressMain.bitbtnStartClick(Sender: TObject);
begin
  StartProgress;
end;


procedure TfrmAsymProgressMain.bitbtnPauseClick(Sender: TObject);
begin
  PauseProgress;
end;


procedure TfrmAsymProgressMain.bitbtnStopClick(Sender: TObject);
begin
  StopProgress;
end;


procedure TfrmAsymProgressMain.spnedtOverallTimeChange(Sender: TObject);
begin
  prbOverallTime.Max := spnedtOverallTime.Value;
end;


procedure TfrmAsymProgressMain.bitbtnSettingsClick(Sender: TObject);
begin
  if EditAsymSettings(FCustomSettings) then
  begin
    UpdateComponentStateFromSettings;
    SaveSettingsToIni;
  end;
end;


procedure TfrmAsymProgressMain.tmrFSMTimer(Sender: TObject);
begin
  case FState of
    SInit:
    begin
      FNextState := SInc;
      imglstGraphs.Draw(imgGraph.Canvas, 0, 0, 1, True);
    end;

    SWaitBeforeInc:
      if prbHold.Position < prbHold.Max then
        FNextState := SWaitBeforeInc
      else
      begin
        FNextState := SInc;
        imglstGraphs.Draw(imgGraph.Canvas, 0, 0, 1, True);
      end;

    SInc:
      if prbTime.Position < prbTime.Max then
        FNextState := SInc
      else
      begin
        FNextState := SWaitBeforeDec;
        imglstGraphs.Draw(imgGraph.Canvas, 0, 0, 2, True);
      end;

    SWaitBeforeDec:
      if prbHold.Position > 0 then
        FNextState := SWaitBeforeDec
      else
      begin
        FNextState := SDec;
        imglstGraphs.Draw(imgGraph.Canvas, 0, 0, 3, True);
      end;

    SDec:
      if prbTime.Position > 0 then
        FNextState := SDec
      else
      begin
        FNextState := SWaitBeforeInc;
        imglstGraphs.Draw(imgGraph.Canvas, 0, 0, 4, True);
      end;
  end;

  case FState of
    SInit:
    begin
      prbTime.Max := spnedtInc.Value * 10;
      prbTime.Position := 0;

      prbHold.Max := spnedtHoldInc.Value * 10;
      prbHold.Position := prbHold.Max;
    end;

    SWaitBeforeInc:
    begin
      prbTime.Max := spnedtInc.Value * 10;
      prbTime.Position := 0;
      prbHold.Position := prbHold.Position + 1;

      shpHoldInc.Brush.Color := clLime;
      shpInc.Brush.Color := clGreen;
      shpHoldDec.Brush.Color := clGreen;
      shpDec.Brush.Color := clGreen;
    end;

    SInc:
    begin
      prbHold.Max := spnedtHoldDec.Value * 10 * Ord(spnedtHoldDec.Visible);
      prbHold.Position := prbHold.Max;
      prbTime.Position := prbTime.Position + 1;

      shpHoldInc.Brush.Color := clGreen;
      shpInc.Brush.Color := clLime;
      shpHoldDec.Brush.Color := clGreen;
      shpDec.Brush.Color := clGreen;
    end;

    SWaitBeforeDec:
    begin
      prbTime.Max := spnedtDec.Value * 10;
      prbTime.Position := prbTime.Max;
      prbHold.Position := prbHold.Position - 1;

      shpHoldInc.Brush.Color := clGreen;
      shpInc.Brush.Color := clGreen;
      shpHoldDec.Brush.Color := clLime;
      shpDec.Brush.Color := clGreen;
    end;

    SDec:
    begin
      prbHold.Max := spnedtHoldInc.Value * 10 * Ord(spnedtHoldInc.Visible);
      prbHold.Position := 0;
      prbTime.Position := prbTime.Position - 1;

      shpHoldInc.Brush.Color := clGreen;
      shpInc.Brush.Color := clGreen;
      shpHoldDec.Brush.Color := clGreen;
      shpDec.Brush.Color := clLime;
    end;
  end;

  FState := FNextState;

  shpProgress.Width := Round(prbTime.Position * shpMaxProgress.Width / prbTime.Max);
end;


procedure TfrmAsymProgressMain.tmrOverallTimeTimer(Sender: TObject);
begin
  tmrOverallTime.Tag := tmrOverallTime.Tag + 1;

  if chkStopOnTimeout.Checked then
  begin;
    prbOverallTime.Position := tmrOverallTime.Tag;

    if tmrOverallTime.Tag >= spnedtOverallTime.Value then
      StopProgress;
  end;
end;


procedure TfrmAsymProgressMain.tmrStartupTimer(Sender: TObject);
begin
  tmrStartup.Enabled := False;
  LoadSettingsFromIni;
end;

end.

