program PictureChan;

uses
  Vcl.Forms,
  PictureChanMain in 'PictureChanMain.pas' {Window},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TWindow, Window);
  Application.Run;
end.
