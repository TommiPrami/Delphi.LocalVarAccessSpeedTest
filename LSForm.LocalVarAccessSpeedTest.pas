unit LSForm.LocalVarAccessSpeedTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMeasuredProcedure = procedure(ALoopCount: Int64) of object;

type
  TLSLocalVarAccessSpeedTestForm = class(TForm)
    ButtonRun: TButton;
    MemoLog: TMemo;
    EditLoopCount: TEdit;
    procedure ButtonRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure GlobalLocalVarInt64(ALoopCount: Int64);
    procedure AccessParameterInt64(ALoopCount: Int64);
    procedure LocalVarInt64(ALoopCount: Int64);
    procedure TestInt64Procedure(const AProcName: string; const AProcedure: TMeasuredProcedure; const ALoopCount: Int64);
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
  {$IF Defined(DEBUG)}
    'Debug'
  {$ELSE}
    'Release'
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


procedure TLSLocalVarAccessSpeedTestForm.TestInt64Procedure(const AProcName: string; const AProcedure: TMeasuredProcedure; const ALoopCount: Int64);
begin
  var LStopWatch := TStopwatch.StartNew;

  AProcedure(ALoopCount);

  LStopWatch.Stop;

  MemoLog.Lines.Add('  - ' + AProcName + ': ' + FormatFloat('0.000', LStopWatch.Elapsed.TotalMilliseconds) + ' ms.');
end;

procedure TLSLocalVarAccessSpeedTestForm.ButtonRunClick(Sender: TObject);

  procedure InitRun;
  begin
    MemoLog.Lines.Clear;
    MemoLog.Lines.Add(BUILD_STR);
    MemoLog.Lines.Add('');

    MemoLog.Repaint;
    ButtonRun.Repaint;
  end;

begin
  Screen.Cursor := crHourGlass;
  ButtonRun.Enabled := False;
  try
    InitRun;

    var LLoopCount: Int64 := string(EditLoopCount.Text).ToInt64;

    TestInt64Procedure('GlobalLocalVarInt64', GlobalLocalVarInt64, LLoopCount);
    TestInt64Procedure('AccessParameterInt64', AccessParameterInt64, LLoopCount);
    TestInt64Procedure('LocalVarInt64', LocalVarInt64, LLoopCount);

    // TODO: Test more data types.
  finally
    Screen.Cursor := crDefault;
    ButtonRun.Enabled := True;
  end;
end;

end.
