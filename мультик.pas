unit �������;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.MPlayer, AthleticMan;

const
  Mainbody = 200; // �������� ���� ��������� ����� �������� � ������������

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    MediaPlayer1: TMediaPlayer;
    Timer3: TTimer;
    Timer4: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    Man: TJumpingMan;
    Man1: TJumpingMan;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  body, x, y, x1, y1, y11, x11: Integer;
  radius, rad1, body1, body2, body3, rad3, rad4, RadOfBlackEllips: Integer;
  IsUp, notidvig, g, f, IsClose, movestart: Boolean;
  i: Integer;

implementation

{$R *.dfm}

uses
  MainFormUnit;

procedure TForm1.FormCreate(Sender: TObject);

begin
  body := 200;
  // �������������� ����� ����, ����� ��� �������������� ���� ���������
  x := trunc(0.9 * clientwidth);
  y := trunc(0.12 * clientheight); // ��������� ����� ��������
  radius := body div 4; // ������ ������

  IsUp := false; // ���� ����� ��� ����, ����� ������� � ������ ����
  notidvig := false; // ����� ��� �������� ���
  movestart := true;
  Man := TJumpingMan.Create(Self);
  Man1 := TJumpingMan.Create(Self);
  Man.SetPosition(X + 400, Y + 100);
  Man1.SetPosition(X - 400, Y + 100);
  Man.Scale := 2.0;
  Man1.Scale := 2.0;
end;

procedure TForm1.FormPaint(Sender: TObject);
  procedure HeadAndBody;
  begin
    with canvas do
    begin
      pen.Color := clBlack;
      brush.Color := clBtnFace;
      if IsUp then
      begin
        Ellipse(x - trunc(body / 4), y - trunc(body / 4), x + trunc(body / 4),
          y + trunc(body / 4)); // ������
        MoveTo(x, y + trunc(body / 4)); // ��� ������
        LineTo(x, y + trunc(body / 2)); // ��������� ���
      end
      else
      begin
        Ellipse(x - trunc(0.9 * body / 4), y - trunc(0.9 * body / 4),
          x + trunc(1.1 * body / 4), y + trunc(1.1 * body / 4));
        MoveTo(x + trunc(0.025 * body), y + trunc(1.1 * body / 4));
        // ��� ������
        LineTo(x, y + trunc(body / 2)); // ��������� ���
      end;
      LineTo(x, y + trunc(1.25 * body)); // ��������
    end;
  end;

  procedure notki;
  begin
    if notidvig = true then // ��������� ���
    begin
      with canvas do
      begin
        Ellipse(x1 + trunc(0.59 * body / 2), y1 - trunc(0.7 * body / 4),
          x1 + trunc(0.74 * body / 2), y1 - trunc(body / 8));
        MoveTo(x1 + trunc(0.37 * body), y1 - trunc(0.15 * body));
        LineTo(x1 + trunc(0.37 * body), y1 - trunc(0.28 * body)); // ������ ����

        Ellipse(x1 - trunc(0.37 * body), y1 - trunc(0.7 * body / 4),
          x1 - trunc(0.59 * 2 * body / 4), y1 - trunc(0.5 * body / 4));
        MoveTo(x1 - trunc(0.59 * 2 * body / 4), y1 - trunc(0.6 * body / 4));
        LineTo(x1 - trunc(0.59 * 2 * body / 4),
          y1 - trunc(0.56 * 2 * body / 4));
        LineTo(x1 - trunc(0.89 * 2 * body / 4),
          y1 - trunc(0.56 * 2 * body / 4));
        LineTo(x1 - trunc(0.89 * 2 * body / 4), y1 - trunc(0.6 * body / 4));
        Ellipse(x1 - trunc(2.06 * body / 4), y1 - trunc(0.7 * body / 4),
          x1 - trunc(0.88 * 2 * body / 4), y1 - trunc(0.5 * body / 4));
        // ������ ����

        Ellipse(x1 - trunc(0.74 * radius * 6), y1 + trunc(1.3 * body / 4),
          x1 - trunc(0.69 * 6 * body / 4), y1 + trunc(1.1 * body / 4));
        MoveTo(x1 - trunc(0.69 * 6 * body / 4), y1 + trunc(1.2 * body / 4));
        LineTo(x1 - trunc(0.69 * 6 * body / 4), y1 + trunc(0.56 * body / 4));
        LineTo(x1 - trunc(0.79 * 6 * body / 4), y1 + trunc(0.56 * body / 4));
        LineTo(x1 - trunc(0.79 * 6 * body / 4), y1 + trunc(1.2 * body / 4));
        Ellipse(x1 - trunc(2 * body / 4 * 2.5), y1 + trunc(1.3 * body / 4),
          x1 - trunc(1 * 2 * body / 4 * 2.35), y1 + trunc(1.1 * body / 4));
        // ������ ����

        Ellipse(x1 + trunc(0.74 * body / 4 * 6), y1 + trunc(2.6 * body / 4),
          x1 + trunc(0.69 * 6 * body / 4), y1 + trunc(2.4 * body / 4));
        MoveTo(x1 + trunc(0.83 * 6 * body / 4), y1 + trunc(2.5 * body / 4));
        LineTo(x1 + trunc(0.83 * 6 * body / 4), y1 + trunc(1.8 * body / 4));
        LineTo(x1 + trunc(0.73 * 6 * body / 4), y1 + trunc(1.8 * body / 4));
        LineTo(x1 + trunc(0.73 * 6 * body / 4), y1 + trunc(2.5 * body / 4));
        Ellipse(x1 + trunc(2 * body / 4 * 2.5), y1 + trunc(2.6 * body / 4),
          x1 + trunc(1 * 2 * body / 4 * 2.35), y1 + trunc(2.4 * body / 4));
        // ��������� ����

        Ellipse(x1 - trunc(0.78 * body), y1 + trunc(2.9 * body / 4),
          x1 - trunc(0.7 * 4 * body / 4), y1 + trunc(2.7 * body / 4));
        MoveTo(x1 - trunc(0.7 * 4 * body / 4), y1 + trunc(2.3 * body / 4));
        LineTo(x1 - trunc(0.7 * 4 * body / 4), y1 + trunc(2.8 * body / 4));
        // ����� ����
      end;
    end;
  end;

  procedure LeftLeg;
  begin
    with canvas do
    begin
      LineTo(x + trunc(body / 4), y + trunc(body / 4) + body * 2); // ����� ����
      LineTo(x + trunc(body / 2), y + trunc(body / 4) + body * 2);
      // ����� �����
    end;
  end;

  procedure RightLeg;
  begin
    with canvas do
    begin
      MoveTo(x, y + trunc(1.25 * body)); // ������ ����� ����
      LineTo(x - trunc(radius * 2.5), y + body + trunc(radius * 2.5));
      // ������ �����
      LineTo(x - trunc(radius * 2.5), y + body + trunc(radius * 4.2));
      // ������ ������
      if not IsUp then
        LineTo(x - trunc(radius * 4.2) + trunc(0.15 * body),
          y + body + trunc(radius * 4.2)) // ������ ����� �����
      else
        LineTo(x - trunc(radius * 4.2) + trunc(0.2 * body),
          y + body + trunc(radius * 4.2) - trunc(radius * 2.5) + trunc(body / 2)
          ); // ������ ����� �����
    end;
  end;

  procedure RightArm;
  begin
    with canvas do
    begin
      pen.Color := clBlack;
      MoveTo(x, y + trunc(body / 2)); // ������ ������ ����
      LineTo(x - trunc(2.1 * body / 4), y + trunc(3.2 * body / 4));
      // ������ �����
      LineTo(x - trunc(0.6 * body / 4), y + body + trunc(0.3 * body / 4));
      // ������ ����������
      if IsUp then
        LineTo(x, y + trunc(1.1 * body)) // ������ ������
      else
        LineTo(trunc(0.99 * x), y + body + trunc(0.15 * body));
      // ������ ��������� ������
    end;
  end;

  procedure LeftArm;
  begin
    with canvas do
    begin
      pen.Color := clBlack;
      brush.Color := clBlack;
      MoveTo(x, y + trunc(body / 2)); // ������ ����� ����, ����� ���
      case i of // ��� ��������� ����� ����
        0:
          begin
            LineTo(x + trunc(1.7 * body / 4), y + trunc(0.95 * body));
            // ����� �����
            LineTo(x + trunc(1.9 * body / 4), y + trunc(0.75 * body));
            // ���oe ����������
          end;

        1:
          begin
            LineTo(x + trunc(1.5 * body / 4), y + body - trunc(0.3 * body / 4));
            // ����� �����
            LineTo(x + trunc(2.1 * body / 4), y + body - trunc(1.15 * body / 4)
              ); // ���oe ����������
          end;

        2:
          begin
            LineTo(x + trunc(body / 2), y + trunc(0.875 * body)); // ����� �����
            LineTo(x + trunc(1.3 * body / 2), y + body - trunc(0.75 * body / 2)
              ); // ���oe ����������
          end;
      end;
    end;
  end;

  procedure LeftHand;
  begin
    with canvas do
    begin
      pen.Color := clBlack;
      brush.Color := clBlack;
      case i of
        0:
          begin
            MoveTo(x + trunc(1.9 * body / 4), y + trunc(0.75 * body));
            // ����� ��������
            LineTo(x + trunc(1.6 * body / 4), y + body - trunc(0.3 * body));
            // ����� ������
          end;

        1:
          begin
            MoveTo(x + trunc(2.1 * body / 4), y + body - trunc(1.15 * body / 4)
              ); // ����� ��������
            LineTo(x + trunc(2 * body / 4), y + body - trunc(1.55 * body / 4));
            // ����� ������
          end;

        2:
          begin
            MoveTo(x + trunc(2.6 * body / 4), y + body - trunc(1.5 * body / 4));
            // ����� ��������
            LineTo(x + trunc(2.25 * body / 4), y + body - trunc(1.75 * body / 4)
              ); // ����� ������
          end;
      end;
    end;
  end;
  procedure TheGuitar;
  var
    a, b, c, d: Real;
    l: Integer;
  begin
    with canvas do
    begin
      a := 1.28; // ������������ ��� �����
      b := 0.87;
      c := 2.87;
      d := 0.47;

      // ���� � ������
      brush.Color := clMaroon;
      pen.Color := clMaroon;
      MoveTo(x + trunc(radius * 1.5) - trunc(radius * 0.4),
        y + body - radius + trunc(radius * 0.1));
      LineTo(x + trunc(2.70 * radius), y + trunc(body * 0.47) + 10);
      LineTo(x + trunc(2.95 * radius), y + trunc(body * 0.42));
      LineTo(x + trunc(3.2 * radius), y + trunc(body * 0.48));
      LineTo(x + trunc(2.77 * radius), y + trunc(body * 0.545));
      LineTo(x + trunc(radius * 1.37), y + body - trunc(radius * 0.61));
      LineTo(x + trunc(radius * 1.5) - trunc(radius * 0.4),
        y + body - radius + trunc(radius * 0.1));
      FloodFill(x + trunc(c * radius), y + trunc(body * d), clMaroon, fsBorder);

      // ������
      brush.Color := clYellow;
      pen.Color := clYellow;
      Ellipse(x, y + trunc(radius * 2.5) + trunc(body / 2),
        x + trunc(radius * 1.5), y + body - radius);
      // ��������� �������� ��� ������
      Ellipse(x - trunc(radius * 2.5), y + body - trunc(radius * 1.5) + radius,
        x - radius + trunc(radius * 1.5), y + body + trunc(radius * 2.5));
      // ������� �������� ��� ������

      // ���� �������
      Arc(x - 3 * radius, y, x + trunc(1.2 * radius),
        y + body - trunc(0.5 * radius), x - radius, y + trunc(3.5 * radius),
        x + trunc(0.5 * radius), y + trunc(3.1 * radius));
      FloodFill(x - trunc(0.02 * radius), y + trunc(3.5 * radius), clYellow,
        fsBorder);

      // ���� ������
      pen.Color := clYellow;
      Arc(x + trunc(0.15 * radius), y + trunc(3.7 * radius), x + 6 * radius,
        y + radius + body * 2, x + trunc(1.35 * radius),
        y + trunc(4.1 * radius), x + trunc(0.16 * radius),
        y + trunc(5.8 * radius));
      FloodFill(x + trunc(0.45 * radius), y + trunc(body * 1.15), clYellow,
        fsBorder);

      // �������� (�����)
      brush.Color := clMaroon;
      pen.Color := clMaroon;
      Ellipse(x - trunc(0.3 * radius), y + trunc(body * 1.02) -
        trunc(0.5 * radius), x + trunc(0.7 * radius), y + trunc(body * 1.02) +
        trunc(0.5 * radius));

      // ������
      pen.Color := clgray;
      for l := 1 to 6 do
      begin
        MoveTo(x - trunc(a * radius) - trunc(0.5 * radius),
          y + body + trunc(0.5 * radius) + trunc(b * radius));
        LineTo(x + trunc(c * radius), y + trunc(body * d)); // 1 ������
        a := a - 0.04;
        b := b + 0.05;
        c := c + 0.03;
        d := d + 0.005;
      end;

      // ���������
      brush.Color := clMaroon;
      pen.Color := clMaroon;
      MoveTo(x - trunc(1.55 * radius) - trunc(0.5 * radius),
        y + body + trunc(0.5 * radius) + trunc(0.50 * radius));
      LineTo(x - trunc(0.85 * radius) - trunc(0.5 * radius),
        y + body + trunc(0.5 * radius) + trunc(1.4 * radius));
      LineTo(x - trunc(0.90 * radius) - trunc(0.5 * radius),
        y + body + trunc(0.5 * radius) + trunc(1.45 * radius));
      LineTo(x - trunc(1.60 * radius) - trunc(0.5 * radius),
        y + body + trunc(0.5 * radius) + trunc(0.55 * radius));
      LineTo(x - trunc(1.55 * radius) - trunc(0.5 * radius),
        y + body + trunc(0.5 * radius) + trunc(0.50 * radius));
      FloodFill(x - trunc(1.55 * radius) - trunc(0.5 * radius),
        y + body + trunc(0.5 * radius) + trunc(0.51 * radius), clMaroon,
        fsBorder);

    end;
  end;

begin
  HeadAndBody;
  LeftLeg;
  RightLeg; // ������ ����
  LeftArm; // ����� ����
  TheGuitar; // ������
  LeftHand; // ����� ������
  RightArm; // ������ ����
  notki; // ����
  Man.Draw;
  Man1.Draw;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

//  Form4.Show;
  MediaPlayer1.Play; // ���������� �����
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Interval := 150; // ���� ��� ����, ������ � ������ ����
  IsUp := not IsUp;
  repaint;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Timer2.Interval := 400; // ������� ��������� ��������� ����� ����
  i := random(3);
  repaint;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  Timer3.Interval := 100;
  if body < Mainbody then // ����������� ���������
  begin
    inc(body, 5);
    x := x - 30;
    y := y + 4;
    radius := body div 4;
    repaint;
  end
  else // ��������� ��������, ��������� ���
  begin
    notidvig := true;
    if movestart = true then
    begin
      y1 := y; // ������������� ��������������� �������� ����� ��������� ���
      x1 := x;
      movestart := false;
    end;

    if notidvig = true then
    begin
      if y1 > (y / 2.2) then // �������� ������ ����� �� �����
      begin
        with canvas do
        begin
          dec(y1, 6);
          inc(x1, 3);
          repaint;
        end;
      end
      else // �������� ����� ����� �� ����� �����
        if y1 > 0 then
        begin
          with canvas do
          begin
            dec(y1, 7);
            dec(x1, 3);
            repaint;
          end;
        end
        else // ���������� �������� �1,�1 ��� ����� ���
        begin
          y1 := y;
          x1 := x;
        end;
    end;
  end;

end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
  Timer4.Interval := 61000;
  if not IsClose then
  begin
    IsClose := true;
      Man.Greeting;
      Man.Greeting;
      Man1.Greeting;
      Man1.Greeting;
      Man.Greeting;
      Man.Greeting;
      Man1.Greeting;
      Man1.Greeting;
      Man.Greeting;
      Man.Greeting;
      Man1.Greeting;
      Man1.Greeting;
      Man.Greeting;
      Man.Greeting;
      Man1.Greeting;
      Man1.Greeting;
  end
  else
  begin
    Form4.Close;
  end; // �������� ����� �� ��������� �������
end;

end.
