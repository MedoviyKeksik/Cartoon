object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 711
  ClientWidth = 1064
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object MediaPlayer1: TMediaPlayer
    Left = 432
    Top = -50
    Width = 253
    Height = 30
    AutoOpen = True
    FileName = #1088#1077#1087'.mp3'
    Visible = False
    TabOrder = 0
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 32
    Top = 32
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 112
    Top = 16
  end
  object Timer3: TTimer
    OnTimer = Timer3Timer
    Left = 536
    Top = 400
  end
  object Timer4: TTimer
    Interval = 30000
    OnTimer = Timer4Timer
    Left = 616
    Top = 280
  end
end
