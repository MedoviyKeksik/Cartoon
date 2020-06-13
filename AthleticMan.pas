unit AthleticMan;

interface

uses
  Vcl.ExtCtrls, Vcl.Graphics, System.Classes, System.Types, Vcl.Controls, Vcl.Forms;

const
  INTERVAL = 50;

type
  // Части тела человека
  TPartsOfMan = (
    ptShoulderLeft, ptShoulderRight,
    ptArmLeft, ptArmRight,
    ptLegLeft, ptLegRight,
    ptHipLeft, pthipright,
    ptBody, ptNeck, ptHead, ptFull);

  // Состояние каждой части
  TState = record
    Angle: Real;
    Size:  Real;
    DelayNum, Num: Integer;
    DeltaAngle: Real;
    DeltaSize: Integer;
  end;

  // Односвязный список состояний
  TNodeP = ^TNode;
  TNode = record
    Data: TState;
    Next: TNodeP;
  end;

  // Список
  TList = class
  private
    FHead, FTail: TNodeP;
    FSize: Integer;
    function GetFront: TState;
    function GetBack: TState;
  public
    constructor Create;
    destructor Destroy;
    function Empty: Boolean;
    procedure PopFront;
    procedure PushBack(const Node: TState);
    property Front: TState read GetFront;
    property Back: TState read GetBack;
  end;

  // Часть тела
  TPart = record
    Angle: Real;
    Size: Real;
    DelayNum, Num: Integer;
    DeltaAngle: Real;
    DeltaSize: Integer;
    Queue: TList;
    constructor Create(const AAngle: Real; const ASize: Real);
    procedure UpdateValue;
  end;

  TPartP = ^TPart;

  // Прыгающий человек
  TJumpingMan = class(TComponent)
  private
    FOwner: TForm;                                  // Форма, на которой располагается
    FCanvas: TCanvas;
    FLeft, FTop: Integer;                           // Позиция соединения шеи с плечами
    FScale: Real;                                   // Масштаб
    FTimer: TTimer;

    FShoulderLeft, FShoulderRight: TPart;           // Плечи
    FArmLeft, FArmRight: TPart;                     // Предплечья
    FLegLeft, FLegRight: TPart;                     // Голень
    FHipLeft, FHipRight: TPart;                     // Бедра
    FBody: TPart;                                   // Тело
    FNeck: TPart;                                   // Шея
    FHead: TPart;                                   // Голова
    FFull: TPart;

    function GetPoint(const Start: TPoint; const APart: TPart): TPoint;
    procedure DrawLine(const AStart, AFinish: TPoint);
    procedure DrawCircle(const ACenter: TPoint; ASize: Integer);
    procedure ReDraw;
    procedure tmrUpdate(Sender: TObject);
    function DeterminePart(APart: TPartsOfMan): TPartP;
    function GetLastState(const APart: TPart): TState;

    procedure UpdateValues;
  public
    constructor Create(AOwner: TForm);  // Параметры: форма на которой отрисовывается человек
    destructor Destroy;

    procedure SetPosition(const X, Y: Integer); // Установить человека в позицию X, Y

    // Процедура отрисовки человека
    procedure Draw;

    // Движение частью тела
    // Параметры 1. Часть тела 2. Угол на который нужно повернуть. 3. Новый размер части тела 4. Задержка до начала движения. 5. Время движения
    procedure MovePart(APart: TPartsOfMan; AAngle: Real; ASize: Real; ADelay: Integer = 0; ATime: Integer = INTERVAL);
    // Движение частью тела, только опущены некоторые параметры.
    procedure MovePartByAngle(APart: TPartsOfMan; AAngle: Real; ADelay: Integer = 0; ATime: Integer = INTERVAL);
    procedure MovePartBySize(APart: TPartsOfMan; ASize: Real; ADelay: Integer = 0; ATime: Integer = INTERVAL);
    procedure DelayPart(APart: TPartsOfMan; ADelay: Integer);

    // Выполнить прыжок
    procedure Jump;
    // Поздороваться
    procedure Greeting;

    // Отрисовка дорожки и солнца
    procedure Background;

    // Положение человека и его масштаб
    property Left: Integer read FLeft;
    property Top: Integer read FTop;
    property Scale: Real read FScale write FScale;

  end;


function Rad(const AAngle: Integer): Real;

implementation

function Rad(const AAngle: Integer): Real;
begin
  Result := AAngle / 180 * Pi;
end;


procedure TJumpingMan.Background;
var
  i, ty, sx, sy: Integer;
begin
  ty := 735;
  FCanvas.Brush.Color := clMaroon;
  FCanvas.Pen.Color := clBlack;
  FCanvas.Rectangle(0, ty + 60, 10000, ty + 70);
  FCanvas.Rectangle(0, ty + 15, 10000, ty + 25);
  FCanvas.Brush.Color := clOlive;
  FCanvas.Rectangle(0, ty + 24, 10000, ty + 61);
  FCanvas.Brush.Style := bsClear;
  FCanvas.Pen.Color := clBlack;

  sx := 55;
  sy := 55;
  FCanvas.Brush.Color := clYellow;
  FCanvas.Pen.Color := clRed;
  FCanvas.Ellipse(sx, sy, sx + 100,sy + 100);
  FCanvas.MoveTo(sx + 95, sy + 95);
  FCanvas.LineTo(sx + 130, sy + 130);
  FCanvas.MoveTo(sx + 5, sy + 5);
  FCanvas.LineTo(sx - 30, sy - 30);
  FCanvas.MoveTo(sx + 5, sy + 95);
  FCanvas.LineTo(sx - 30, sy + 130);
  FCanvas.MoveTo(sx + 95, sy + 5);
  FCanvas.LineTo(sx + 130, sy - 30);
  FCanvas.MoveTo(sx + 50, sy - 5);
  FCanvas.LineTo(sx + 50, sy - 50);
  FCanvas.MoveTo(sx + 50, sy + 105);
  FCanvas.LineTo(sx + 50, sy + 150);
  FCanvas.MoveTo(sx + 105, sy + 50);
  FCanvas.LineTo(sx + 150, sy + 50);
  FCanvas.MoveTo(sx - 5, sy + 50);
  FCanvas.LineTo(sx - 50, sy + 50);
  FCanvas.Pen.Color := clBlack;
  FCanvas.Brush.Style := bsClear;
end;


{ TJumpingMan }

function TJumpingMan.GetLastState(const APart: TPart): TState;
begin
  if APart.Queue.Empty then
  begin
    Result.Angle := APart.Angle;
    Result.Size := APart.Size;
    Result.DelayNum := APart.DelayNum;
    Result.Num := APart.Num;
    Result.DeltaAngle := Apart.DeltaAngle;
    Result.DeltaSize := Apart.DeltaSize;
  end
  else Result := APart.Queue.Back;
end;

function TJumpingMan.GetPoint(const Start: TPoint; const APart: TPart): TPoint;
begin
  Result.X := Round(Start.X + APart.Size * FScale * Cos(APart.Angle));
  Result.Y := Round(Start.Y + APart.Size * FScale * -Sin(APart.Angle));
end;

procedure TJumpingMan.tmrUpdate(Sender: TObject);
var
  Tmp: TJumpingMan;
begin
  if not (Sender is TTimer) then Exit;
  if not (TTimer(Sender).Owner is TJumpingMan) then Exit;
  Tmp := TTimer(Sender).Owner as TJumpingMan;
  Tmp.UpdateValues;
  Tmp.ReDraw;
end;

procedure TJumpingMan.UpdateValues;
begin
  FHead.UpdateValue;
  FBody.UpdateValue;
  FNeck.UpdateValue;
  FShoulderLeft.UpdateValue;
  FShoulderRight.UpdateValue;
  FArmLeft.UpdateValue;
  FArmRight.UpdateValue;
  FHipLeft.UpdateValue;
  FHipRight.UpdateValue;
  FLegLeft.UpdateValue;
  FLegRight.UpdateValue;
  FFull.UpdateValue;
  FLeft := Round(FFull.Angle);
  FTop := Round(FFull.Size);
end;

constructor TJumpingMan.Create(AOwner: TForm);
begin
  Inherited Create(AOwner);
  FOwner := AOwner;
  FCanvas := AOwner.Canvas;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := INTERVAL;
  FTimer.Enabled := True;
  FTimer.OnTimer := tmrUpdate;

  FScale := 1.0;

  FBody.Create(Rad(270), 80);
  FNeck.Create(Rad(90), 10);
  FHead.Create(Rad(90), 30);
  FShoulderLeft.Create(Rad(250), 50);
  FShoulderRight.Create(Rad(290), 40);
  FArmLeft.Create(Rad(270), 50);
  FArmRight.Create(Rad(270), 45);
  FHipLeft.Create(Rad(280), 60);
  FHipRight.Create(Rad(310), 55);
  FLegLeft.Create(Rad(260), 60);
  FLegRight.Create(Rad(270), 55);
  FFull.Queue := TList.Create;
end;

procedure TJumpingMan.DelayPart(APart: TPartsOfMan; ADelay: Integer);
var
  Tmp: TPartP;
  LastState: TState;
begin
  Tmp := DeterminePart(APart);
  LastState := GetLastState(Tmp^);
  MovePart(APart, LastState.Angle, LastState.Size, ADelay, 0);
end;

destructor TJumpingMan.Destroy;
begin
  FTimer.Free;
  FBody.Queue.Free;
  FNeck.Queue.Free;
  FHead.Queue.Free;
  FShoulderLeft.Queue.Free;
  FShoulderRight.Queue.Free;
  FArmLeft.Queue.Free;
  FArmRight.Queue.Free;
  FHipLeft.Queue.Free;
  FHipRight.Queue.Free;
  FLegLeft.Queue.Free;
  FLegRight.Queue.Free;
  FFull.Queue.Free;
  Inherited;
end;

function TJumpingMan.DeterminePart(APart: TPartsOfMan): TPartP;
begin
  case APart of
    ptShoulderLeft: Result := @FShoulderLeft;
    ptShoulderRight: Result := @FShoulderRight;
    ptArmLeft: Result := @FArmLeft;
    ptArmRight: Result := @FArmRight;
    ptLegLeft: Result := @FLegLeft;
    ptLegRight: Result := @FLegRight;
    ptHipLeft: Result := @FHipLeft;
    pthipright: Result := @FHipRight;
    ptBody: Result := @FBody;
    ptNeck: Result := @FNeck;
    ptHead: Result := @FHead;
    ptFull: Result := @FFull;
  end;
end;

procedure TJumpingMan.Draw;
var
  Now, Next: TPoint;
  TmpColor: TColor;
begin
  Now.Create(FLeft, FTop);

  // Neck and Head
  Next := GetPoint(Now, FNeck);
  DrawLine(Now, Next);
  TmpColor := FCanvas.Brush.Color;
  FCanvas.Brush.Color := clWhite;
  DrawCircle(GetPoint(Next, FHead), Round(FHead.Size * FScale));
  FCanvas.Brush.Color := TmpColor ;

  // Left Arm
  Next := GetPoint(Now, FShoulderLeft);
  DrawLine(Now, Next);
  DrawLine(Next, GetPoint(Next, FArmLeft));

  // Right Arm
  Next := GetPoint(Now, FShoulderRight);
  DrawLine(Now, Next);
  DrawLine(Next, GetPoint(Next, FArmRight));

  // Body
  Next := GetPoint(Now, FBody);
  DrawLine(Now, Next);

  Now := Next;
  // Left Leg
  Next := GetPoint(Now, FHipLeft);
  DrawLine(Now, Next);
  DrawLine(Next, GetPoint(Next, FLegLeft));

  // Right Leg
  Next := GetPoint(Now, FHipRight);
  DrawLine(Now, Next);
  DrawLine(Next, GetPoint(Next, FLegRight));
end;

procedure TJumpingMan.DrawCircle(const ACenter: TPoint; ASize: Integer);
begin
  FCanvas.Ellipse(
    ACenter.X - ASize, ACenter.Y - ASize,
    ACenter.X + ASize, ACenter.Y + ASize);
end;

procedure TJumpingMan.DrawLine(const AStart, AFinish: TPoint);
begin
  FCanvas.MoveTo(AStart.X, AStart.Y);
  FCanvas.LineTo(AFinish.X, AFinish.Y);
end;

procedure TJumpingMan.Greeting;
begin
  MovePartByAngle(ptArmLeft, Rad(70), 0, 1000);
  MovePartByAngle(ptShoulderLeft, Rad(180), 0, 1000);
  MovePartByAngle(ptArmLeft, Rad(110), 0, 400);
  MovePartByAngle(ptArmLeft, Rad(70), 0, 400);
  MovePartByAngle(ptArmLeft, Rad(110), 0, 400);
  MovePartByAngle(ptShoulderLeft, Rad(250), 1000, 1000);
  MovePartByAngle(ptArmLeft, Rad(270), 0, 1000);
  DelayPart(ptShoulderLeft, 200);

  DelayPart(ptShoulderRight, 3200);
  DelayPart(ptArmRight, 3200);
  DelayPart(ptLegLeft, 3200);
  DelayPart(ptLegRight, 3200);
  DelayPart(ptHipLeft, 3200);
  DelayPart(pthipright, 3200);
  DelayPart(ptBody, 3200);
  DelayPart(ptNeck, 3200);
  DelayPart(ptHead, 3200);
  DelayPart(ptFull, 3200);
end;

procedure TJumpingMan.Jump;
begin
  // Развел руки
  MovePart(ptArmLeft,         Rad(180), 35, 0, 600);
  MovePart(ptArmRight,        Rad(360), 35, 0, 600);
  MovePart(ptShoulderLeft,    Rad(180), 30, 0, 500);
  MovePart(ptShoulderRight,   Rad(360), 30, 0, 500);

  // Поднял вверх
  MovePart(ptArmLeft,         Rad(135), 45, 50, 500);
  MovePart(ptArmRight,        Rad(405), 50, 50, 500);
  MovePart(ptShoulderLeft,    Rad(135), 40, 50, 400);
  MovePart(ptShoulderRight,   Rad(405), 50, 50, 400);

  // Нагнулся)
  MovePartByAngle(ptHead,     Rad(45),  600, 1700);
  MovePartByAngle(ptBody,     Rad(240), 600, 1700);
  MovePartByAngle(ptNeck,     Rad(60),  600, 1700);
  MovePart(ptFull, FLeft + FScale * 50, FTop + FScale * 35, 600, 1700);

  // Присел
  MovePartByAngle(ptHipLeft,  Rad(300), 900, 1700);
  MovePartByAngle(ptHipRight, Rad(330), 900, 1700);
  MovePartByAngle(ptLegleft,  Rad(240), 900, 1700);
  MovePartByAngle(ptLegright, Rad(250), 900, 1700);

  // Руки назад (как наруто)
  MovePart(ptArmLeft,         Rad(-140), 50, 500, 800);
  MovePart(ptArmRight,        Rad(215), 45, 450, 900);
  MovePart(ptShoulderLeft,    Rad(-140), 50, 500, 1200);
  MovePart(ptShoulderRight,   Rad(215), 40, 450, 1200);

  // выпрямил ноги
  MovePartByAngle(ptHipLeft,  Rad(270), 100, 1000);
  MovePartByAngle(ptHipRight, Rad(290), 100, 1000);
  MovePartByAngle(ptLegLeft,  Rad(260), 100, 1000);
  MovePartByAngle(ptLegRight, Rad(270), 100, 1000);

  // Руки Вперед
  MovePart(ptArmLeft,         Rad(-15), 45, 70, 1000);
  MovePart(ptArmRight,        Rad(360), 50, 70, 800);
  MovePart(ptShoulderLeft,    Rad(-15), 40, 80, 1000);
  MovePart(ptShoulderRight,   Rad(360), 50, 80, 800);

  DelayPart(ptFull, 1000);
  MovePart(ptFull, FLeft + FScale * 110, FTop - FScale * 85, 0, 1800);

  // Поджим ног
  MovePartByAngle(ptHipLeft,  Rad(330), 60, 1800);
  MovePartByAngle(ptHipRight, Rad(350), 60, 1800);

  // Передвижение
  MovePart(ptFull, FLeft + FScale * 175, FTop - FScale * 110, 0, 600);
  MovePart(ptFull, FLeft + FScale * 240, FTop - FScale * 85, 0, 600);
  MovePart(ptFull, FLeft + FScale * 340, FTop, 0, 1800);

  // Выставление ног на преземление
  MovePartByAngle(ptHipLeft,  Rad(290), 610, 2000);
  MovePartByAngle(ptHipRight, Rad(310), 610, 2000);
  MovePartByAngle(ptLegLeft,  Rad(290), 710, 1900);
  MovePartByAngle(ptLegRight, Rad(300), 710, 1900);

  // Выравнивание
  MovePartByAngle(ptBody,     Rad(260), 3600, 1800);
  MovePartByAngle(ptNeck,     Rad(80), 3600, 1800);

  // Присел
  MovePartByAngle(ptHipLeft,  Rad(350), 1100, 700);
  MovePartByAngle(ptHipRight, Rad(370), 1100, 700);
  MovePartByAngle(ptLegLeft,  Rad(240), 1300, 700);
  MovePartByAngle(ptLegRight, Rad(250), 1300, 700);
  // Согнулся
  MovePartByAngle(ptBody,     Rad(220), 300, 1200);
  MovePartByAngle(ptNeck,     Rad(40), 300, 1200);

  MovePart(ptFull, FLeft + FScale * 315, FTop + FScale * 50, 200, 1500);
  MovePart(ptFull, FLeft + FScale * 320, FTop, 0, 1500);

  MovePartByAngle(ptBody,     Rad(270), 50, 1900);
  MovePartByAngle(ptNeck,     Rad(90), 50, 1900);

  MovePart(ptShoulderLeft,    Rad(-70), 50, 6000, 1600);
  MovePart(ptShoulderRight,   Rad(260), 40, 6000, 1600);
  MovePart(ptArmLeft,         Rad(-90), 50, 6000, 2000);
  MovePart(ptArmRight,        Rad(270), 45, 6000, 2000);

  MovePartByAngle(ptHipLeft,  Rad(280), 50, 1300);
  MovePartByAngle(ptHipRight, Rad(310), 50, 1300);
  MovePartByAngle(ptLegLeft,  Rad(260), 50, 1300);
  MovePartByAngle(ptLegRight, Rad(270), 50, 1300);
  MovePartByAngle(ptHead,     Rad(90), 7000, 1900);
end;

procedure TJumpingMan.MovePart(APart: TPartsOfMan; AAngle: Real;
  ASize: Real; ADelay: Integer; ATime: Integer);
var
  Tmp: TPartP;
  State, LastState: TState;
begin
  Tmp := DeterminePart(APart);
  LastState := GetLastState(Tmp^);
  State.Num := ATime div INTERVAL;
  State.DelayNum := ADelay div INTERVAL;
  if State.Num = 0 then
  begin
    State.DeltaAngle := 0;
    State.DeltaSize := 0;
  end
  else
  begin
    State.DeltaAngle := (AAngle - LastState.Angle) / State.Num;
    State.DeltaSize := Round(ASize - LastState.Size) div State.Num;
  end;
  State.Angle := AAngle;
  State.Size := ASize;
  if Tmp^.Queue.Empty then
  begin
    Tmp^.Num := State.Num;
    Tmp^.DelayNum := State.DelayNum;
    Tmp^.DeltaAngle := State.DeltaAngle;
    Tmp^.DeltaSize := State.DeltaSize;
  end;
  Tmp^.Queue.PushBack(State);
end;

procedure TJumpingMan.MovePartByAngle(APart: TPartsOfMan; AAngle: Real; ADelay,
  ATime: Integer);
var
  Tmp: TPartP;
  LastState: TState;
begin
  Tmp := DeterminePart(APart);
  LastState := GetLastState(Tmp^);
  MovePart(APart, AAngle, LastState.Size, ADelay, ATime);
end;

procedure TJumpingMan.MovePartBySize(APart: TPartsOfMan; ASize: Real; ADelay,
  ATime: Integer);
var
  Tmp: TPartP;
  LastState: TState;
begin
  Tmp := DeterminePart(APart);
  LastState := GetLastState(Tmp^);
  MovePart(APart, LastState.Angle, ASize, ADelay, ATime);
end;

procedure TJumpingMan.ReDraw;
begin
  FOwner.Invalidate;
end;

procedure TJumpingMan.SetPosition(const X, Y: Integer);
begin
  FLeft := X;
  FTop := Y;
  FFull.Angle := X;
  FFull.Size := Y;
end;

{ TPart }

constructor TPart.Create(const AAngle: Real; const ASize: Real);
begin
  Angle := AAngle;
  Size := ASize;
  Num := 0;
  Queue := TList.Create;
end;

procedure TPart.UpdateValue;
var
  Tmp: TState;
begin
  if (DelayNum = 0) and (Num = 0) and (not Queue.Empty) then
  begin
    Queue.PopFront;
    if (not Queue.Empty) then
    begin
      Tmp := Queue.Front;
      DelayNum := Tmp.DelayNum;
      Num := Tmp.Num;
      DeltaAngle := Tmp.DeltaAngle;
      DeltaSize := Tmp.DeltaSize;
    end;
  end;
  if DelayNum > 0 then
    Dec(DelayNum)
  else
    if Num > 0 then
    begin
      Angle := Angle + DeltaAngle;
      Size := Size + DeltaSize;
      Dec(Num);
    end;
end;

{ TList }

constructor TList.Create;
begin
  New(FHead);
  FHead^.Next := Nil;
  FTail := FHead;
end;

destructor TList.Destroy;
begin
  while FTail <> nil do
  begin
    FTail := FHead^.Next;
    Dispose(FHead);
    FHead := FTail;
  end;
end;

function TList.Empty: Boolean;
begin
  Result := FSize = 0;
end;

function TList.GetBack: TState;
begin
  Result := FTail^.Data
end;

function TList.GetFront: TState;
begin
  Result := FHead^.Next^.Data
end;

procedure TList.PopFront;
var
  Tmp: TNodeP;
begin
  Tmp := FHead^.Next;
  if Tmp = FTail then
  begin
    FHead^.Next := nil;
    FTail := FHead;
  end
  else
    FHead^.Next := Tmp^.Next;
  Dispose(Tmp);
  Dec(FSize);
end;

procedure TList.PushBack(const Node: TState);
var
  Tmp: TNodeP;
begin
  New(Tmp);
  Tmp^.Data := Node;
  FTail^.Next := Tmp;
  FTail := Tmp;
  FTail^.Next := nil;
  Inc(FSize);
end;


initialization

end.
