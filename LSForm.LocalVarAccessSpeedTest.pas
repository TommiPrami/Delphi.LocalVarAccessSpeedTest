unit LSForm.LocalVarAccessSpeedTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMeasuredProcedure = procedure(ALoopCount: Int64) of object;

type
  TValueRecord = record
    In64Value: Int64;
    IntegerValue: Integer;
  end;


  TLSLocalVarAccessSpeedTestForm = class(TForm)
    ButtonRun: TButton;
    MemoLog: TMemo;
    procedure ButtonRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure GlobalLocalVarInt64(ALoopCount: Int64);
    procedure AccessParameterInt64(ALoopCount: Int64);
    procedure LocalVarInt64(ALoopCount: Int64);
    procedure GlobalLocalVarString(ALoopCount: Int64);
    procedure LocalVarString(ALoopCount: Int64);
    procedure GlobalLocalVarRecord(ALoopCount: Int64);
    procedure LocalVarRecord(ALoopCount: Int64);
    procedure RunTestProcedure(const AProcName: string; const AProcedure: TMeasuredProcedure; const ALoopCount: Int64);
  public
  end;

var
  LSLocalVarAccessSpeedTestForm: TLSLocalVarAccessSpeedTestForm;

implementation

{$R *.dfm}

uses
  System.Diagnostics;

const
  BUILD_STR =
  {$IF Defined(WIN32)}
    'Win32'
  {$ELSEIF Defined(WIN64)}
    'Win64'
  {$ELSE}
    unsupported platform
  {$ENDIF}
  {$IF Defined(DEBUG)}
    + ' Debug'
  {$ELSE}
    + ' Release'
  {$ENDIF}
    + ' build';

procedure TLSLocalVarAccessSpeedTestForm.FormCreate(Sender: TObject);
begin
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
end;

procedure TLSLocalVarAccessSpeedTestForm.GlobalLocalVarInt64(ALoopCount: Int64);
var
  LVariable: Int64;

  procedure LocalProc;
  begin
    LVariable := LVariable + 1;
  end;

begin
  LVariable := 0;

  for var LIndex := 1 to ALoopCount do
    LocalProc;
end;

procedure TLSLocalVarAccessSpeedTestForm.LocalVarInt64(ALoopCount: Int64);

  procedure LocalProc(var AVariable: Int64);
  begin
    AVariable := AVariable + 1;
  end;

begin
  var LVariable: Int64 := 0;

  for var LIndex := 1 to ALoopCount do
    LocalProc(LVariable);
end;

procedure TLSLocalVarAccessSpeedTestForm.GlobalLocalVarRecord(ALoopCount: Int64);
var
  LVariable: TValueRecord;

  procedure LocalProc;
  begin
    LVariable.In64Value := LVariable.In64Value + 1;
    LVariable.IntegerValue := LVariable.IntegerValue + 1;
  end;

begin
  FillChar(LVariable, SizeOf(TValueRecord), 0);

  for var LIndex := 1 to ALoopCount do
    LocalProc;
end;

procedure TLSLocalVarAccessSpeedTestForm.LocalVarRecord(ALoopCount: Int64);

  procedure LocalProc(var AValue: TValueRecord);
  begin
    AValue.In64Value := AValue.In64Value + 1;
    AValue.IntegerValue := AValue.IntegerValue + 1;
  end;

begin
  var LVariable: TValueRecord;
  FillChar(LVariable, SizeOf(TValueRecord), 0);

  for var LIndex := 1 to ALoopCount do
    LocalProc(LVariable);
end;

procedure TLSLocalVarAccessSpeedTestForm.AccessParameterInt64(ALoopCount: Int64);

  procedure LocalProc;
  begin
    ALoopCount := ALoopCount + 1;
  end;

begin
  var LLoopCount := ALoopCount;
  ALoopCount := 0;

  for var LIndex := 1 to LLoopCount do
    LocalProc;
end;


procedure TLSLocalVarAccessSpeedTestForm.RunTestProcedure(const AProcName: string; const AProcedure: TMeasuredProcedure; const ALoopCount: Int64);
begin
  var LStopWatch := TStopwatch.StartNew;

  AProcedure(ALoopCount);

  LStopWatch.Stop;

  MemoLog.Lines.Add('  - ' + AProcName + ': ' + FormatFloat('0.000', LStopWatch.Elapsed.TotalMilliseconds) + ' ms.');
end;

const
  STRING_VALUE = 'asdqworide2039ure2po9ejdfwldifjqwopliwej2op34rjh2qwoleidjnm';

procedure TLSLocalVarAccessSpeedTestForm.LocalVarString(ALoopCount: Int64);

  procedure LocalProc(var AVariable: string);
  begin
    for var LIndex := 1 to Length(AVariable) do
      AVariable[LIndex] := AVariable[LIndex];
  end;

begin
  var LVariable: string := STRING_VALUE;

  for var LIndex := 1 to ALoopCount do
    LocalProc(LVariable);
end;

procedure TLSLocalVarAccessSpeedTestForm.GlobalLocalVarString(ALoopCount: Int64);
var
  LVariable: string;

  procedure LocalProc;
  begin
    for var LIndex := 1 to Length(LVariable) do
      LVariable[LIndex] := LVariable[LIndex];
  end;

begin
  LVariable := STRING_VALUE;

  for var LIndex := 1 to ALoopCount do
    LocalProc;
end;

procedure TLSLocalVarAccessSpeedTestForm.ButtonRunClick(Sender: TObject);

  procedure InitRun;
  begin
    Screen.Cursor := crHourGlass;
    ButtonRun.Enabled := False;

    MemoLog.Lines.Clear;
    MemoLog.Lines.Add(BUILD_STR);
    MemoLog.Lines.Add('');

    MemoLog.Repaint;
    ButtonRun.Repaint;
  end;
const
  INT64_LOOP_COUNT = 900_000_000;
  STRING_LOOP_COUNT = 20_000_000;
  RECORD_LOOP_COUNT = 900_000_000;
begin
  InitRun;
  try

    MemoLog.Lines.Add('In64');
    RunTestProcedure('AccessParameterInt64', AccessParameterInt64, INT64_LOOP_COUNT);
    RunTestProcedure('GlobalLocalVarInt64', GlobalLocalVarInt64, INT64_LOOP_COUNT);
    RunTestProcedure('LocalVarInt64', LocalVarInt64, INT64_LOOP_COUNT);
    MemoLog.Lines.Add('');

    //
    MemoLog.Lines.Add('string');
    RunTestProcedure('GlobalLocalVarString', GlobalLocalVarString, STRING_LOOP_COUNT);
    RunTestProcedure('LocalVarString', LocalVarString, STRING_LOOP_COUNT);
    MemoLog.Lines.Add('');

    //
    MemoLog.Lines.Add('record');
    RunTestProcedure('GlobalLocalVarRecord', GlobalLocalVarRecord, RECORD_LOOP_COUNT);
    RunTestProcedure('LocalVarRecord', LocalVarRecord, RECORD_LOOP_COUNT);
    MemoLog.Lines.Add('');

    // TODO: Test more data types.
  finally
    Screen.Cursor := crDefault;
    ButtonRun.Enabled := True;
  end;
end;

end.
