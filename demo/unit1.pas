unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, simpleipc, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    SimpleIPCClient1: TSimpleIPCClient;
    SimpleIPCServer1: TSimpleIPCServer;
    procedure Edit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SimpleIPCServer1Message(Sender: TObject);
  private
    { private declarations }
    oldstr: TStrings;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SimpleIPCServer1Message(Sender: TObject);
begin
  Memo1.Append(SimpleIPCServer1.StringMessage);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SimpleIPCServer1.StartServer;
end;

procedure TForm1.Edit1EditingDone(Sender: TObject);
begin
  try
    if not (SimpleIPCClient1.Active) then
      SimpleIPCClient1.Connect;
  except
    on e: Exception do
    begin
      Edit1.Text := 'no server';
      Exit;
    end;
  end;
  SimpleIPCClient1.SendStringMessage(Edit1.Text);
  Edit1.Text := '';
end;

end.

