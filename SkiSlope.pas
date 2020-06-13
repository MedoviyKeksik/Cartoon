unit SkiSlope;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

procedure DrawBackground(Canvas : TCanvas; FileName: string; x, y: integer; const Scale: real = 1);
procedure DrawSlope(Canvas : TCanvas; x1, y1, x2, y2 : integer; const Scale: real = 1);
procedure DrawFlag(Canvas : TCanvas; FileName: string; x, y: integer; const Scale: real = 1);
procedure DrawFinishLine(Canvas : TCanvas; x1, y1, x2, y2: integer);

implementation

procedure DrawSlope(Canvas : TCanvas; x1, y1, x2, y2 : integer; const Scale: real = 1);
{ Рисование склона на Canvas, x1, y1 - координаты начала, x2, y2 - координаты конца
  Scale - масштабирование}
var
  Bezier : array[0..3] of TPoint;
  k1, k2, k3, k4: real;
  w1, w2: integer;
begin
  // Коэффициенты кривизны
  k1 := 0.4;
  k2 := 0.4;
  k3 := 0.5;
  k4 := 0.6;
  w1 := round(120*Scale);
  w2 := round(200*Scale);
  // Рисование кривой Безье по 4 точкам
  Canvas.PolyBezier([Point(x1, y1),
                     Point(trunc((x1+x2)*k1), trunc((y1+y2)*k2)),
                     Point(trunc((x1+x2)*k3), trunc((y1+y2)*k4)),
                     Point(x2, y2)]);
  // Смещение координат для росование второй кривой
  inc(x1, w1);
  inc(x2, w2);
  if x1 < x2 then
    begin
      dec(y1, 20);
      dec(y2, 40);
    end
  else
    begin
      inc(y1, 20);
      inc(y2, 40);
    end;
  // Рисование кривой Безье по 4 точкам
  Canvas.PolyBezier([Point(x1, y1),
                     Point(trunc((x1+x2)*k1), trunc((y1+y2)*k2)),
                     Point(trunc((x1+x2)*k3), trunc((y1+y2)*k4)),
                     Point(x2, y2)]);
end;

procedure DrawBackground(Canvas : TCanvas; FileName: string; x, y: integer; const Scale: real = 1);
{ Рисование фоновой картинки на Canvas; x, y - координаты;
  FileName - имя файла в директории программы; Scale - масштабирование }
var
  Background: TBitmap;
  FileDir: string;
begin
  Background := TBitmap.Create;
  Background.Transparent := true;
  Background.TransparentColor := clBlack;  // Прозрачность цвета
  FileDir := ExtractFileDir(Application.ExeName);
  Background.LoadFromFile(FileDir +'\'+ FileName);
  Canvas.StretchDraw(Rect(x, y, round(Background.Width*Scale), round(Background.Height*Scale)), Background);
  Background.Destroy;
end;

procedure DrawFlag(Canvas : TCanvas; FileName: string; x, y: integer; const Scale: real = 1);
{ Рисование флага на Canvas; FileName - имя файла в директории программы;
  x, y - координаты; Scale - масштабирование }
var
  Flag: TBitmap;
  FileDir: string;
begin
  Flag := TBitmap.Create;
  Flag.Transparent := true;
  Flag.TransparentColor := clBlack;  // Прозрачность цвета
  FileDir := ExtractFileDir(Application.ExeName);
  Flag.LoadFromFile(FileDir +'\'+ FileName);
  Canvas.StretchDraw(Rect(x, y-round(Flag.Height*Scale), x-round(Flag.Width*Scale), y), Flag);
  Flag.Destroy;
end;

procedure DrawFinishLine(Canvas : TCanvas; x1, y1, x2, y2: integer);
{ Рисование финишной линии на Canvas; x, y - координаты }
var
  OldPenWidth, x, y, dx, dy, shiftX, shiftY, i: integer;
  OldPenColor: TColor;
  OldBrushColor: TColor;
begin
  OldPenWidth := Canvas.Pen.Width;
  OldPenColor := Canvas.Pen.Color;
  OldBrushColor := Canvas.Brush.Color;
  Canvas.Pen.Width := 2;
  Canvas.Pen.Color := $002E2323;
  Canvas.Brush.Color := $002E2323;
  dx := (x2-x1) div 9;
  dy := (y2-y1) div 9;
  x := x1;
  y := y1;
  for i := 1 to 4 do
    begin
      Canvas.Polygon([Point(x, y),
                      Point(x+dx, y-dy),
                      Point(x+dx*2, y),
                      Point(x+dx, y+dy)]);
      inc(x, dx);
      inc(y, dy);
      Canvas.Polygon([Point(x+dx, y-dy),
                      Point(x+dx*2, y-dy*2),
                      Point(x+dx*3, y-dy),
                      Point(x+dx*2, y)]);
      inc(x, dx);
      inc(y, dy);
    end;
    Canvas.Polygon([Point(x, y),
                    Point(x+dx, y-dy),
                    Point(x+dx*2, y),
                    Point(x+dx, y+dy)]);
  Canvas.Pen.Width := OldPenWidth;
  Canvas.Pen.Color := OldPenColor;
  Canvas.Brush.Color := OldBrushColor;
end;

end.
