unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Serial, Crt, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, MyTypes;

type



  { TForm1 }

  TForm1 = class(TForm)
    ReadButton: TButton;
    ConnectButton: TButton;
    Label2: TLabel;
    SizeLabel: TLabel;
    Memo1: TMemo;
    WriteButton: TButton;
    DisconnectButton: TButton;
    Edit1: TEdit;
    WriteEdit: TEdit;
    Label1: TLabel;
    ReadenLabel: TLabel;
    WrittenLabel: TLabel;
    Timer1: TTimer;
    procedure ConnectButtonClick(Sender: TObject);
    procedure ReadButtonClick(Sender: TObject);
    procedure WriteButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private

  public


 end;

var

  Form1: TForm1;

  PortHandle:THandle;
  PData:TData;
  Buff:PBuff;



implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ConnectButtonClick(Sender: TObject);
begin
      { Buff:=@PData;  }
       PortHandle:= Serial.SerOpen(Edit1.Text);
       Serial.SerSetParams(PortHandle,115200,8,NoneParity,1,[]);
       Label1.Caption:='PortHandle = '+InttoStr(PortHandle);
       ConnectButton.Enabled:=false;
       DisconnectButton.Enabled:=true;
        WriteButton.Enabled:=true;
end;

procedure TForm1.ReadButtonClick(Sender: TObject);
begin
  Timer1.Enabled:=true;
end;

procedure TForm1.WriteButtonClick(Sender: TObject);
var b:byte=242;
    written:LongInt;
begin
  b:=StrtoInt(WriteEdit.Text);
  written:= Serial.SerWrite(PortHandle,b,1);
  WrittenLabel.Caption:='BytesWrittem = ' + InttoStr(written);
 Serial.SerSync(PortHandle);
end;

procedure TForm1.DisconnectButtonClick(Sender: TObject);
begin
  Serial.SerClose(PortHandle);
  ConnectButton.Enabled:=true;
  DisconnectButton.Enabled:=false;
  WriteButton.Enabled:=false;
  Timer1.Enabled:=false;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
 var readen:LongInt;
begin

 readen:= Serial.SerRead(PortHandle,PData,8);

 SizeLabel.Caption:=inttostr(Sizeof(PData));
 label2.Caption:=inttostr(PData.vt + PData.im+ PData.temp );
 ReadenLabel.Caption:= 'Bytes readen = ' + InttoStr(readen);

 if not ConnectButton.Enabled then
 Memo1.Lines.Add(
 ' T = ' +
 InttoStr(PData.vt )+
 ' I = ' +
 InttoStr(PData.im)+
 ' t = ' +
 InttoStr(PData.temp div 16 )+
 ' crc = '+
 InttoStr(PData.crc)
 );
end;

end.

