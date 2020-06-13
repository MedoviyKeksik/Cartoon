unit DrawManModule;

interface
Uses VCL.Graphics;

type
{
   TManConfig - «апись дл€ хранени€ состо€ни€ человечка
   на форме.

   LArmUpAngle       - угол наклона левого плеча человечка
   LArmDownAngle     - угол наклона левого предплечь€ человечка
   RArmUpAngle       - угол наклона правого плеча человечка
   RArmDownAngle     - угол наклона правого предплечь€ человечка
   LLegUpAngle       - угол наклона левого бедра человечка
   LLegDownAngle     - угол наклона левой голени человечка
   RLegUpAngle       - угол наклона правого бедра человечка
   RLegDownAngle     - угол наклона правой голени человечка

   HasSkiLeft        - будет ли нарисована лева€ лыжа
   HasSkiRight       - будет ли нарисована права€ лыжа
   HasStickLeft      - будет ли нарисована лева€ палка
   HasStickRight     - будет ли нарисована права€ палка

   BodyLength        - длина туловища человечка. ќт нее
                       скалируютс€ длины всех других частей
                       тела
   ArmHeightFactor   - множитель высоты рук
   ArmLengthFactor   - множитель длины рук
   LegLengthFactor   - ћножитель длины ног
   StickSizeFactor   - множитель длины палока
   SkiSizeFactor     - множитель длины лыж

   Scale             - ќбщий множитель размера.

}
    TManConfig = Record
        X : Integer;
        Y : Integer;
        BodyAngle : Integer;
        LArmUpAngle : Integer;
        LArmDownAngle : Integer;
        RArmUpAngle : Integer;
        RArmDownAngle : Integer;
        LLegUpAngle : Integer;
        LLegDownAngle : Integer;
        RLegUpAngle : Integer;
        RLegDownAngle : Integer;

        HasSkiLeft : Boolean;
        HasSkiRight : Boolean;
        HasStickLeft : Boolean;
        HasStickRight : Boolean;
        LeftSkiAngle : Integer;
        RightSkiAngle : Integer;
        LeftStickAngle : Integer;
        RightStickAngle : Integer;

        BodyLength : Integer;
        ArmHeightFactor : Real;
        ArmLengthFactor : Real;
        LegLengthFactor : Real;
        StickSizeFactor : Real;
        SkiSizeFactor : Real;
        HeadFactor : Real;

        Scale : Real;
        AutoScale : Boolean;
    End;

{
    DrawMan - функци€, котора€ рисует человчека
    с  онфигурацией ManConfig на канвасе Canvas
}
procedure DrawMan(var ManConfig : TManConfig; const Canvas : TCanvas);

implementation

{“ут вс€ка€ геометри€ страшна€. я не помню как она рабтает \_(-_-)_/ }
procedure DrawBody(var ManConfig : TManConfig; const Canvas : TCanvas);
var dx, dy : Integer;
begin
    with ManConfig do
    begin
        Canvas.MoveTo(X, Y);
        Canvas.LineTo(X + Trunc(BodyLength * sin(BodyAngle * 3.14 / 180)), Y - Trunc(BodyLength * cos(BodyAngle * 3.14 / 180)));
    end;
end;

procedure DrawLLeg(var ManConfig : TManConfig; const Canvas : TCanvas);
var
    _X, _Y, dx, dy, LegLength, Radius : Integer;
    RadMainAngle, RadLLegUpAngle, RadLLegDownAngle, RadLSkiAngle : Real;
begin
    with ManConfig do begin
        _X := X;
        _Y := Y;
        Canvas.MoveTo(X, Y);
        RadLLegUpAngle := LLegUpAngle * 3.14 / 180;
        RadLLegDownAngle := LLegDownAngle * 3.14 / 180;
        RadMainAngle := BodyAngle * 3.14 / 180;
        LegLength := Round(BodyLength * LegLengthFactor / 2);
        dx := Round(LegLength * sin(RadLLegUpAngle + RadMainAngle));
        dy := Round(LegLength * cos(RadLLegUpAngle + RadMainAngle));
        Canvas.LineTo(X - dx, Y + dy);
        Dec(_X, dx);
        Inc(_Y, dy);
        dx := Round(LegLength * sin(RadMainAngle + RadLLegUpAngle + RadLLegDownAngle));
        dy := Round(LegLength * cos(RadMainAngle + RadLLegUpAngle + RadLLegDownAngle));
        Canvas.LineTo(_X - dx, _Y + dy);
        if HasSkiLeft then
        begin
            RadLSkiAngle := LeftSkiAngle * 3.14 / 180;
            Dec(_X, dx);
            Inc(_Y, dy);
            dx := Round(SkiSizeFactor * BodyLength * (1/3) * cos(RadMainAngle + RadLLegUpAngle + RadLLegDownAngle + RadLSkiAngle));
            dy := Round(SkiSizeFactor * BodyLength * (1/3) * sin(RadMainAngle + RadLLegUpAngle + RadLLegDownAngle + RadLSkiAngle));
            Canvas.MoveTo(_X - dx, _Y - dy);
            Canvas.LineTo(_X + 2 * dx, _Y + 2*dy);
            Inc(_X, 2 * dx);
            Inc(_Y, 2 * dy);
            Radius := Round(SkiSizeFactor * BodyLength / 6);
            dx := Round(Radius * sin(RadMainAngle + RadLLegUpAngle + RadLLegDownAngle + RadLSkiAngle));
            dy := Round(Radius * cos(RadMainAngle + RadLLegUpAngle + RadLLegDownAngle + RadLSkiAngle));
            if (LeftSkiAngle mod 360 > 90) and (LeftSkiAngle mod 360 < 270) then
            begin
                dy := -dy;
                dx := -dx;
                Canvas.Arc(_X + dx - Radius, _Y - dy - Radius, _X + dx + Radius, _Y - dy + Radius,
                       _X + dx - dy, _Y - dy - dx, _X, _Y);
            end else
            begin
                Canvas.Arc(_X + dx - Radius, _Y - dy - Radius, _X + dx + Radius, _Y - dy + Radius,
                           _X, _Y, _X + dx + dy, _Y - dy + dx);
            end;
        end;
    end;
end;

procedure DrawRLeg(var ManConfig : TManConfig; const Canvas : TCanvas);
var
    _X, _Y, dx, dy, LegLength, Radius : Integer;
    RadMainAngle, RadRLegUpAngle, RadRLegDownAngle, RadRSkiAngle : Real;
begin
    with ManConfig do begin
        _X := X;
        _Y := Y;
        Canvas.MoveTo(X, Y);
        RadRLegUpAngle := RLegUpAngle * 3.14 / 180;
        RadRLegDownAngle := RLegDownAngle * 3.14 / 180;
        RadMainAngle := BodyAngle * 3.14 / 180;
        LegLength := Round(BodyLength * LegLengthFactor / 2);
        dx := Round(LegLength * sin(-RadMainAngle + RadRLegUpAngle));
        dy := Round(LegLength * cos(-RadMainAngle + RadRLegUpAngle));
        Canvas.LineTo(X + dx, Y + dy);
        Inc(_X, dx);
        Inc(_Y, dy);
        dx := Round(LegLength * sin(-RadMainAngle + RadRLegUpAngle + RadRLegDownAngle));
        dy := Round(LegLength * cos(-RadMainAngle + RadRLegUpAngle + RadRLegDownAngle));
        Canvas.LineTo(_X + dx, _Y + dy);
        if HasSkiRight then
        begin
            RadRSkiAngle := RightSkiAngle * 3.14 / 180;
            Inc(_X, dx);
            Inc(_Y, dy);
            dx := Round(SkiSizeFactor * BodyLength * (1/3) * cos(-RadMainAngle + RadRLegUpAngle + RadRLegDownAngle - RadRSkiAngle));
            dy := Round(SkiSizeFactor * BodyLength * (1/3) * sin(-RadMainAngle + RadRLegUpAngle + RadRLegDownAngle - RadRSkiAngle));
            Canvas.MoveTo(_X - dx, _Y + dy);
            Canvas.LineTo(_X + 2 * dx, _Y - 2*dy);
            Inc(_X, 2 * dx);
            Dec(_Y, 2 * dy);
            Radius := Round(SkiSizeFactor * BodyLength / 6);
            dx := Round(Radius * sin(-RadMainAngle + RadRLegUpAngle + RadRLegDownAngle - RadRSkiAngle));
            dy := Round(Radius * cos(-RadMainAngle + RadRLegUpAngle + RadRLegDownAngle - RadRSkiAngle));
            if (RightSkiAngle mod 360 > 90) and (RightSkiAngle mod 360 < 270) then
            begin
                dy := -dy;
                dx := -dx;
                Canvas.Arc(_X - dx - Radius, _Y - dy - Radius, _X - dx + Radius, _Y - dy + Radius,
                       _X - dx - dy, _Y - dy + dx, _X, _Y);
            end else
            begin
                Canvas.Arc(_X - dx - Radius, _Y - dy - Radius, _X - dx + Radius, _Y - dy + Radius,
                           _X, _Y, _X - dx + dy, _Y - dy - dx);
            end;
        end;
    end;
end;

procedure DrawHead(var ManConfig : TManConfig; const Canvas : TCanvas);
var
    X_, Y_, dX, dY, X_1, Y_1, dX1, dY1, Radius : integer;
    RadAngle : real;
    //Rect : TRect;
begin
    with Manconfig do begin
        Radius := Round(BodyLength * HeadFactor);
        RadAngle := BodyAngle * 3.14 / 180;
        X_ := X + Round((BodyLength + Radius - 3) * sin(RadAngle));
        Y_ := Y - Round((BodyLength + Radius - 3) * cos(RadAngle));
        Canvas.Ellipse(X_ - Radius, Y_ + Radius, X_ + Radius, Y_ - Radius);
    end;
end;

procedure DrawLArm(var ManConfig : TManConfig; const Canvas : TCanvas);
var
    _X, _Y, dx, dy, ArmLength, ArmHeight : Integer;
    RadMainAngle, RadLArmUpAngle, RadLArmDownAngle : Real;
begin
    with ManConfig do begin
        RadMainAngle := BodyAngle * 3.14 / 180;
        RadLArmUpAngle := LArmUpAngle * 3.14 / 180;
        RadLArmDownAngle := LArmDownAngle * 3.14 / 180;
        ArmHeight := Round(BodyLength * ArmHeightFactor);
        _X := X + Trunc(ArmHeight * sin(RadMainAngle));
        _Y := Y - Trunc(ArmHeight * cos(RadMainAngle));
        ArmLength := Round(BodyLength * ArmLengthFactor / 2);
        dx := Round(ArmLength * cos(RadLArmUpAngle + RadMainAngle));
        dy := Round(ArmLength * sin(RadLArmUpAngle + RAdMainAngle));
        Canvas.MoveTo(_X, _Y);
        Canvas.LineTo(_X - dx, _Y - dy);
        Dec(_X, dx);
        Dec(_Y, dy);
        dx := Round(ArmLength * cos(RadLArmUpAngle + RadMainAngle + RadLArmDownAngle));
        dy := Round(ArmLength * sin(RadLArmUpAngle + RadMainAngle + RadLArmDownAngle));
        Canvas.LineTo(_X - dx, _Y - dy);
        Dec(_X, dx);
        Dec(_Y, dy);
        if HasStickLeft then
        begin
             dx := Round(BodyLength * StickSizeFactor * sin(RadLArmUpAngle + RadMainAngle + RadLArmDownAngle + LeftStickAngle * 3.14 / 180) / 5);
             dy := Round(BodyLength * StickSizeFactor * cos(RadLArmUpAngle + RadMainAngle + RadLArmDownAngle + LeftStickAngle * 3.14 / 180) / 5);
             Canvas.MoveTo(_X - dx, _Y + dy);
             Canvas.LineTo(_X + dx * 4, _Y - dy * 4);
        end;
    end;
end;

procedure DrawRArm(var ManConfig : TManConfig; const Canvas : TCanvas);
var
    _X, _Y, dx, dy, ArmLength, ArmHeight : Integer;
    RadMainAngle, RadRArmUpAngle, RadRArmDownAngle : Real;
begin
    with ManConfig do begin
        RadMainAngle := BodyAngle * 3.14 / 180;
        RadRArmUpAngle := RArmUpAngle * 3.14 / 180;
        RadRArmDownAngle := RArmDownAngle * 3.14 / 180;
        ArmHeight := Round(BodyLength * ArmHeightFactor);
        _X := X + Trunc(ArmHeight * sin(RadMainAngle));
        _Y := Y - Trunc(ArmHeight * cos(RadMainAngle));
        ArmLength := Round(BodyLength * ArmLengthFactor / 2);
        dx := Round(ArmLength * cos(RadMainAngle - RadRArmUpAngle));
        dy := Round(ArmLength * sin(RadMainAngle - RadRArmUpAngle));
        Canvas.MoveTo(_X, _Y);
        Canvas.LineTo(_X + dx, _Y + dy);
        Inc(_X, dx);
        Inc(_Y, dy);
        dx := Round(ArmLength * cos(RadMainAngle - RadRArmUpAngle - RadRArmDownAngle));
        dy := Round(ArmLength * sin(RadMainAngle - RadRArmUpAngle - RadRArmDownAngle));
        Canvas.LineTo(_X + dx, _Y + dy);
        Inc(_X, dx);
        Inc(_y, dy);
        if HasStickRight then
        begin
             dx := Round(BodyLength * StickSizeFactor * sin(RadMainAngle - RadRArmUpAngle - RadRArmDownAngle - RightStickAngle * 3.14/180) / 5);
             dy := Round(BodyLength * StickSizeFactor * cos(RadMainAngle - RadRArmUpAngle - RadRArmDownAngle - RightStickAngle * 3.14/180) / 5);
             Canvas.MoveTo(_X + dx, _Y - dy);
             Canvas.LineTo(_X - dx * 4, _Y + dy * 4);
        end;
    end;
end;

procedure DrawMan(var ManConfig: TManConfig; const Canvas : TCanvas);
var Temp : Integer;
begin
    with ManConfig do begin
        Temp := BodyLength;
        BodyLength := Round(BodyLength * Scale);
        DrawBody(ManConfig, Canvas);
        DrawHead(ManConfig, Canvas);
        DrawLLeg(ManConfig, Canvas);
        DrawRLeg(ManConfig, Canvas);
        DrawLArm(ManConfig, Canvas);
        DrawRArm(ManConfig, Canvas);
        BodyLength := Temp;
    end;
end;


end.
