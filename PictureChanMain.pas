unit PictureChanMain;
{$APPTYPE CONSOLE}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.IOUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdSSLOpenSSL, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, HtmlParserEx, Vcl.ExtCtrls, Vcl.OleCtrls,
  SHDocVw, Vcl.VirtualImage, Vcl.Buttons, Vcl.BaseImageCollection,
  Vcl.ImageCollection, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList;

type
  TWindow = class(TForm)
    Link: TEdit;
    NetHTTPClient: TNetHTTPClient;
    MainPanel: TPanel;
    BackgroundPanel: TPanel;
    Run: TSpeedButton;
    Logo: TLabel;
    Shape: TShape;
    Save: TSpeedButton;
    TextError: TLabel;
    ColorError: TShape;
    Author: TLabel;
    ScrollBar: TScrollBar;
    PicturesPanel: TPanel;
    Border0: TPanel;
    Border1: TPanel;
    Border3: TPanel;
    Border2: TPanel;
    Border4: TPanel;
    Border5: TPanel;
    ImageCollection: TImageCollection;
    Image: TImage;
    procedure Parsing(Sender: TObject);
    procedure Saving(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Window: TWindow;

implementation

{$R *.dfm}


function StreamToString(aStream: TStream): string;
var
  StringStream: TStringStream;
begin
  if aStream <> nil then
  begin
    StringStream := TStringStream.Create('');
    try
      StringStream.CopyFrom(aStream, 0); // Exception: TStream.Seek not implemented
      Result := StringStream.DataString;
    finally
      StringStream.Free;
    end;
  end else
  begin
    Result := '';
  end;
end;


procedure TWindow.Parsing(Sender: TObject);
var
  LinkText, Html, PictureLink: string;
  LHtml: IHtmlElement;
  LList: IHtmlElementList;
  LStrStream: TStringStream;
  GetPicture: TPicture;
begin
  Save.Visible := False;
  TextError.Visible := False;
  ColorError.Visible := False;
  LinkText := Link.Text;

  if(LinkText <> '') then
  begin
    if Pos('4chan.org', LinkText) <> 0 then
      begin
        Writeln('American');
        try
          Html := StreamToString(NetHTTPClient.Get(LinkText).ContentStream);
        except
          TextError.Visible := True;
          ColorError.Visible := True;
        end;
        LStrStream := TStringStream.Create('', TEncoding.UTF8);
        LHtml := ParserHTML(Html);
        if LHtml <> nil then
          begin // 4chan.org
            LList := LHtml.Find('a');
            for LHtml in LList do
              if '.' = LHtml.Attributes['href'][length(LHtml.Attributes['href']) - 3] then
                if ('j' = LHtml.Attributes['href'][length(LHtml.Attributes['href']) - 2]) or ('p' = LHtml.Attributes['href'][length(LHtml.Attributes['href']) - 2]) then
                  begin
                  // array
                  end;

              { захаваць карцінкі ў ImageCollection
                ImageCollection.Add(LHtml.Attributes['href'], NetHTTPClient.Get(LHtml.Attributes['href']).ContentStream); }

            { Стары код, частка зь яго потым спатрэбіцца
              PictureLink := 'https://www.2chan.net/b/src/' + LHtml.Find('a')[15].Text;
              GetPicture := TPicture.Create;
              try
                GetPicture.LoadFromStream(NetHTTPClient.Get(PictureLink).ContentStream);
                ImageCollection.Add('gg', GetPictrure);
                Image.Picture := GetPicture;
                Image.Hint := PictureLink;
                Save.Caption := 'Save 0/1';
                Save.Visible := True;
              except
                TextError.Visible := True;
                ColorError.Visible := True;
                GetPicture.Free;
              end; }
          end;
      end;
      if Pos('2chan.net', LinkText) <> 0 then
        begin
          Writeln('japanese');
        end;
  end;
end;


procedure TWindow.Saving(Sender: TObject);
var
  LinkText, FolderDirectory: string;
begin
  LinkText := Link.Text;
  FolderDirectory := TPath.Combine(TPath.GetDesktopPath(), 'Pictures', '');
  CreateDir(FolderDirectory);
  Link.Text := '';
  Save.Visible := False;
  TextError.Visible := False;
  ColorError.Visible := False;
end;

end.

