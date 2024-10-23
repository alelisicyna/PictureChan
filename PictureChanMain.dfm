object Window: TWindow
  Left = 0
  Top = 0
  Caption = 'PictureChan'
  ClientHeight = 557
  ClientWidth = 379
  Color = clBackground
  Constraints.MaxHeight = 640
  Constraints.MaxWidth = 395
  Constraints.MinHeight = 596
  Constraints.MinWidth = 360
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Image: TImage
    Left = 8
    Top = 87
    Width = 369
    Height = 466
    Center = True
    Proportional = True
    Stretch = True
  end
  object Link: TEdit
    Left = 8
    Top = 24
    Width = 281
    Height = 23
    CanUndoSelText = True
    TabOrder = 0
    TextHint = 'Thread id'
  end
  object Run: TButton
    Left = 304
    Top = 24
    Width = 57
    Height = 57
    Caption = 'Run'
    TabOrder = 1
    OnClick = parsing
  end
  object NetHTTPClient: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 312
    Top = 112
  end
end
