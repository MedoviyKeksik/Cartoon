program Project1;

uses
  Vcl.Forms,
  мультик in 'мультик.pas' {Form1},
  AthleticMan in 'AthleticMan.pas',
  DrawManModule in 'DrawManModule.pas',
  SkiSlope in 'SkiSlope.pas',
  MainFormUnit in 'MainFormUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
