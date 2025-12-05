program LocalVarAccessSpeedTest;

uses
  Vcl.Forms,
  LSForm.LocalVarAccessSpeedTest in 'LSForm.LocalVarAccessSpeedTest.pas' {LSLocalVarAccessSpeedTestForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLSLocalVarAccessSpeedTestForm, LSLocalVarAccessSpeedTestForm);
  Application.Run;
end.
