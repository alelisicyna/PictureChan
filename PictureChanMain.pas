unit PictureChanMain;
{$APPTYPE CONSOLE}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdSSLOpenSSL, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, HtmlParserEx, Vcl.ExtCtrls, Vcl.OleCtrls,
  SHDocVw, Vcl.VirtualImage;

type
  TWindow = class(TForm)
    Link: TEdit;
    Run: TButton;
    NetHTTPClient: TNetHTTPClient;
    Image: TImage;
    procedure Parsing(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Window: TWindow;

implementation

{$R *.dfm}


function GetCurrentUserName: string;
  const
    cnMaxUserNameLen = 254;
  var
    sUserName: string;
    dwUserNameLen: DWORD;
  begin
    dwUserNameLen := cnMaxUserNameLen - 1;
    SetLength(sUserName, cnMaxUserNameLen);
    GetUserName(PChar(sUserName), dwUserNameLen);
    SetLength(sUserName, dwUserNameLen);
    Result := sUserName;
  end;


function StreamToString(aStream: TStream): string;
var
  SS: TStringStream;
begin
  if aStream <> nil then
  begin
    SS := TStringStream.Create('');
    try
      SS.CopyFrom(aStream, 0); // Exception: TStream.Seek not implemented
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end else
  begin
    Result := '';
  end;
end;


procedure TWindow.Parsing(Sender: TObject);
var
  LinkText, FolderDirectory, AdminName, Html, PictureLink: string;
  s: string;
  LHtml: IHtmlElement;
  LList: IHtmlElementList;
  LStrStream: TStringStream;
  img: Timage;
  strStream: String;
  memStream: TMemoryStream;
  jpegimg: TPicture;
begin
  LinkText := Link.Text;
  // AdminName := GetCurrentUserName;
  // Writeln('Link: https://', LinkText, #13#10'', 'The thread is parsed!', #13#10'');
  // FolderDirectory := 'C:\Users\' + TrimRight(AdminName) + '\Desktop\Pictures';
  // CreateDir(FolderDirectory);

  Link.Text := '';
  Html := StreamToString(NetHTTPClient.Get(LinkText).ContentStream);
  LStrStream := TStringStream.Create('', TEncoding.UTF8);
  try
    LHtml := ParserHTML(Html);
    if LHtml <> nil then
    begin
      Writeln('picture: https://www.2chan.net/b/src/' + LHtml.Find('a')[15].Text);
      PictureLink := 'https://www.2chan.net/b/src/' + LHtml.Find('a')[15].Text;
      jpegimg := TPicture.Create;
      try
        jpegimg.LoadFromStream(NetHTTPClient.Get(PictureLink).ContentStream);
        Image.Picture := jpegimg;
      finally
        memStream.Free;
        jpegimg.Free;
      end;
    end;
  finally
    LStrStream.Free;
  end;
end;

end.
