unit MainFormUnit;

interface

uses
  DrawManModule, SkiSlope,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Gauges,
  Vcl.ExtCtrls, Vcl.MPlayer, AthleticMan;

type
  TForm4 = class(TForm)
    AnimationTimer: TTimer;
    MediaPlayer1: TMediaPlayer;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AnimationTimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    State : integer;
    Frame : Integer;

    Man: TJumpingMan;
    CloseTime: TTimer;

    procedure DrawManUp(var ManConfig : TManConfig);
    procedure DrawManMid(var ManConfig : TManConfig);
    procedure DrawManDown(var ManConfig : TManConfig);
    procedure UpdateFirstPathMan(var ManConfig : TManConfig);
    procedure UpdateSecondPathMan(var ManConfig : TManConfig);
    procedure OnCloseTimer(Sender: TObject);
    { Private declarations }
  public
    ManConfig, ManConfig2, Back1 : TManConfig;
    procedure DrawAnimMan(var ManConfig : TManConfig);
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses
  мультик;

{$R *.dfm}

procedure TForm4.DrawAnimMan(var ManConfig : TManConfig);
// Данная процедура выполняет отрисовку человечка в соответствии с переменной состояния state
// После отрисовки каждого положения перемененная state изменяется, чтобы указывать на следующее
// состояние для отрисовки
var Temp : Integer;
begin
    with ManConfig do begin
        Temp := BodyLength;
        BodyLength := Round(BodyLength * Scale);
        case state of
           1: begin
            DrawManUp(ManConfig);    // Отрисовка человечка с поднятыми палками
           end;
           2: begin
            DrawManMid(ManConfig);   // Отрисовка человечка в среднем положении
           end;
           3: begin
            DrawManDown(ManConfig);  // Отрисовка человечка с палками сзади
           end;
           4: begin
            DrawManMid(ManConfig);   // Отрисовка человечка в среднем положении
           end;
        end;
        BodyLength := Temp;
    end;
end;

procedure TForm4.DrawManMid(var ManConfig : TManConfig); // Отрисовка человечка в среднем положении
var Temp : Integer;
begin
    //Canvas.FillRect(TRect.Create(0, Height, Width, 0));
    ManConfig.LArmUpAngle := -115;   // -|
    ManConfig.LArmDownAngle := -25;  //  |
    ManConfig.RArmUpAngle := -30;    //  |
    ManConfig.RArmDownAngle := 25;   //  | -  Изменения конфигурации человечка соответствующим образом
    ManConfig.LLegUpAngle := -5;     //  |
    ManConfig.LLegDownAngle := 15;   //  |
    ManConfig.RLegUpAngle := 45;     //  |
    ManConfig.RLegDownAngle := -55;  // -|

    DrawMan(ManConfig, Canvas); // Вызов подпрограммы отрисовки человечка на канвасе в соответствии с заданной конфигурацией
end;

procedure TForm4.DrawManUp(var ManConfig : TManConfig);     // Added
var Temp : Integer;
begin
    //Canvas.FillRect(TRect.Create(0, Height, Width, 0));
    ManConfig.LArmUpAngle := -185;   // -|
    ManConfig.LArmDownAngle := -25;  //  |
    ManConfig.RArmUpAngle := 35;     //  |
    ManConfig.RArmDownAngle := 25;   //  | -  Изменения конфигурации человечка соответствующим образом
    ManConfig.LLegUpAngle := 10;     //  |
    ManConfig.LLegDownAngle := 15;   //  |
    ManConfig.RLegUpAngle := 45;     //  |
    ManConfig.RLegDownAngle := -55;  // -|

    DrawMan(ManConfig, Canvas);  // Вызов подпрограммы отрисовки человечка на канвасе в соответствии с заданной конфигурацией
end;

procedure TForm4.DrawManDown(var ManConfig : TManConfig);  // Added
var Temp : Integer;
begin
    //Canvas.FillRect(TRect.Create(0, Height, Width, 0));
    ManConfig.LArmUpAngle := 25;     // -|
    ManConfig.LArmDownAngle := -25;  //  |
    ManConfig.RArmUpAngle := -145;   //  |
    ManConfig.RArmDownAngle := 25;   //  |
    ManConfig.LLegUpAngle := -5;     //  | -  Изменения конфигурации человечка соответствующим образом
    ManConfig.LLegDownAngle := 15;   //  |
    ManConfig.RLegUpAngle := 25;     //  |
    ManConfig.RLegDownAngle := -55;  // -|

    DrawMan(ManConfig, Canvas);    // Вызов подпрограммы отрисовки человечка на канвасе в соответствии с заданной конфигурацией
end;

procedure PlaySong(Player: TMediaPlayer; FileName: String);
// Подпрограммы для проигрывание выбранной композиции, принимает
// TMediaPlayer и строку с путем к файлу в качестве параметров
begin
  Player.FileName := FileName;  //  Выбор композиции
  Player.Open;                           // Инициализация плеера
  Player.Play;                           // Запуск проигрывания композиции
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
    PlaySong(MediaPlayer1, 'immigrant-song.mp3');
end;


procedure TForm4.FormCreate(Sender: TObject);
var
  I: Integer;
begin
    CloseTime := TTimer.Create(Self);
    CloseTime.Enabled := True;
    CloseTime.Interval := 30000;
    CloseTime.OnTimer := OnCloseTimer;
    DoubleBuffered := true;
    Canvas.Brush.Color := clWhite;
    AnimationTimer.Enabled := True;
    AnimationTimer.Interval := 30;
    state := 1;
    Canvas.Pen.Width := 2;
    MediaPlayer1.Hide;
    with ManConfig do begin
        HeadFactor := 0.2;
        ArmLengthFactor := 0.8;
        ArmHeightFactor := 0.75;
        LegLengthFactor := 0.8;
        X := 0;
        Y := 370;
        BodyLength := 50;
        HasSkiRight := True;
        HasSkiLeft := True;
        SkiSizeFactor := 1.5;
        HasStickLeft := true;
        HasStickRight := true;
        StickSizeFactor := 1.8;
        HasStickLeft := True;
        HasStickRight := True;
        HasSkiLeft := True;
        HasSkiRight := True;
        Scale := 1;
        LArmDownAngle := -70;
        RArmDownAngle := 70;
        BodyAngle := 15;
    end;
    ManConfig2 := ManConfig;
    ManConfig2.X := 450;
    Back1 := ManConfig;
    with Back1 do begin
        Back1.X := 1080;
        Back1.Scale := 0.6;
        Back1.LArmDownAngle := 70;
        Back1.RArmDownAngle := -70;
        LeftStickAngle := 180;
        RightStickAngle := 180;
        LeftSkiAngle := 180;
        RightSkiAngle := 180;
    end;
    Man := TJumpingMan.Create(Self);
    Man.SetPosition(1090, 540);
    Man.Scale := 0.4;
    for I := 0 to 10 do
        Man.Greeting;
end;

procedure TForm4.FormPaint(Sender: TObject);
begin
    DrawBackground(Canvas, 'Hill.bmp', 0, 0);
    Canvas.Pen.Width := 4;
    Canvas.Pen.Color := $00E4DFDA;

    DrawSlope(Canvas, 1130, 320, 640, 450, 0.5);
    DrawFlag(Canvas, 'Flag.bmp', 640, 450, 0.5);
    DrawFinishLine(Canvas, 640+100, 450+40, 640, 450);

    Canvas.Pen.Width := 2;
    Canvas.Pen.Color := clBlack;
    DrawMan(Back1, Canvas);
    DrawFlag(Canvas, 'Flag.bmp', 640+100, 450+40, 0.5);
    DrawBackground(Canvas, 'Hill_2.bmp', 0, 0, 1);

    Canvas.Pen.Width := 4;
    Canvas.Pen.Color := $00E4DFDA;
    DrawSlope(Canvas, 50, 400, 850, 680);
    DrawFlag(Canvas, 'Flag.bmp', 850+200, 680-40);
    DrawFinishLine(Canvas, 850, 680, 850+200, 680-40);

    Canvas.Pen.Width := 2;
    Canvas.Pen.Color := clBlack;
    DrawMan(ManConfig, Canvas);
    DrawMan(ManConfig2, Canvas);
//
    DrawFlag(Canvas, 'Flag.bmp', 850, 680);
    Man.Draw;
end;

procedure TForm4.OnCloseTimer(Sender: TObject);
begin
  Form1.Show;
  Self.MediaPlayer1.Stop;
  CloseTime.Enabled := False;
end;

procedure TForm4.UpdateFirstPathMan(var ManConfig : TManConfig);
begin
    with ManConfig do begin
        Inc(X, 6);
        Y := Round((arctan((X - 80) / 100 - 4)) * 100 + 480);
        LArmUpAngle := Round(cos(X) * 90 - 80);
        RArmUpAngle := Round(-cos(X) * 90 - 50);
        LLegUpAngle := Round(cos(X) * 30);
        RLegUpAngle := Round(cos(X) * 30 - 10);
        LeftSkiAngle :=  -Round(cos(X) * 30 + 30);
        RightSkiAngle :=  Round(cos(X) * 30 - 30);
        LLegDownAngle := 30;
        RLegDownAngle := -30;
        BodyAngle := Round(15 - (X - 180) * 15 / 800);
        if X > 1380 then
            X := -100;
    end;
end;

procedure TForm4.UpdateSecondPathMan(var ManConfig : TManConfig);
begin
    with ManConfig do begin
        Dec(X, 6);
        Y := -Round((arctan((X - 700) / 40. - 4)) * 45.0) + 390;
        LArmUpAngle := Round(cos(X) * 90 - 80);
        RArmUpAngle := Round(-cos(X) * 90 - 50);
        LLegUpAngle := Round(cos(X) * 30);
        RLegUpAngle := Round(cos(X) * 30 - 10);
        LeftSkiAngle :=  180 - Round(cos(X) * 30 - 30);
        RightSkiAngle :=  180 + Round(cos(X) * 30 + 30);
        LLegDownAngle := -30;
        RLegDownAngle := 30;
        BodyAngle := -Round(15 - (X - 700) * 15 / 400);
        if X < 400 then
            X := 1380
    end;
end;

procedure TForm4.AnimationTimerTimer(Sender: TObject);
var Y : Real;
begin
    UpdateFirstPathMan(ManConfig);
    UpdateFirstPathMan(ManConfig2);
    UpdateSecondPathMan(Back1);
    Refresh;
end;

end.
