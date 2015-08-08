unit callbacunit;

{$mode delphi}

interface



uses
  Classes, SysUtils, Forms, LMessages, StdCtrls, Controls, Graphics,
  PyAPI, LCLType, pyutil;

type



  { Tcallbac }



  Tcallbac = class
  private



  public

    pyfun: PyObject;
    procedure Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
     procedure Popup(Sender: TObject);
    procedure DrawItem(Control: TWinControl; Index: Integer; ARect: TRect;
      State: TOwnerDrawState);
    procedure MeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure SelectionChange(Sender: TObject; User: boolean);
    procedure EndDock(Sender, Target: TObject; X, Y: integer);
    procedure GetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: boolean);
    function Help(Command: word; Data: PtrInt; var CallHelp: boolean): boolean;
    procedure Hide(Sender: TObject);
    procedure Paint(Sender: TObject);
    procedure ShortCut(var Msg: TLMKey; var Handled: boolean);
    procedure Show(Sender: TObject);
    procedure ShowHint(Sender: TObject; HintInfo: PHintInfo);
    procedure StartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure UnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl;
      var Allow: boolean);
    procedure WindowStateChange(Sender: TObject);
    procedure DockDrop(Sender: TObject; Source: TDragDockObject; X, Y: integer);
    procedure DockOver(Sender: TObject; Source: TDragDockObject;
      X, Y: integer; State: TDragState; var Accept: boolean);
    procedure DropFiles(Sender: TObject; const FileNames: array of string);
    procedure onDestroy(Sender: TObject);
    procedure onCreate(Sender: TObject);
    procedure Activate(Sender: TObject);
    procedure Close(Sender: TObject; var CloseAction: TCloseAction);
    procedure CloseQuery(Sender: TObject; var CanClose: boolean);
    procedure Deactivate(Sender: TObject);
    procedure GetItems(Sender: TObject);
    procedure Select(Sender: TObject);
    procedure DropDown(Sender: TObject);
    procedure CloseUp(Sender: TObject);
    procedure MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure EditingDone(Sender: TObject);
    procedure DblClick(Sender: TObject);
    procedure ChangeBounds(Sender: TObject);
    procedure ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
    procedure DragDrop(Sender, Source: TObject; X, Y: integer);
    procedure DragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: boolean);
    procedure EndDrag(Sender, Target: TObject; X, Y: integer);
    procedure Enter(Sender: TObject);
    procedure Exit(Sender: TObject);
    procedure KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure KeyPress(Sender: TObject; var Key: char);
    procedure KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure MouseEnter(Sender: TObject);
    procedure MouseLeave(Sender: TObject);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Resize(Sender: TObject);
    procedure StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure UTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure Change(Sender: TObject);
    procedure callobj_and_dec(const arg: PyObject);
    procedure click(obj: TObject);
    constructor Create;
  end;

implementation

{ Tcallbac }

procedure Tcallbac.click(obj: TObject);
var
  but: TButton;
  arg: PyObject;
  pyresult: PyObject;
  strlis: TStringList;
begin
  but := TButton(obj);

  arg := Py_BuildValue('()');
  pyresult := PyObject_CallObject(pyfun, arg);
  //strlis := TStringList.Create;
  //if(py)then
  //but.Caption := 'ooop';
  //strlis.SaveToFile('G:\dev\laz4py\laz4py3\o2.txt');

  Py_DecRef(arg);
end;

procedure Tcallbac.callobj_and_dec(const arg: PyObject);
var
  pyresult: PyObject;
begin
  pyresult := PyObject_CallObject(pyfun, arg);
  Py_DecRef(arg);
end;

procedure Tcallbac.EditingDone(Sender: TObject);
begin

end;

procedure Tcallbac.DblClick(Sender: TObject);
begin

end;

procedure Tcallbac.ChangeBounds(Sender: TObject);
begin

end;

procedure Tcallbac.ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: boolean);
var
  arg: PyObject;
begin
  arg := Py_BuildValue('(iiii)', integer(Pointer(Sender)), integer(
    MousePos.x), integer(MousePos.y), booltoint(Handled));
  callobj_and_dec(arg);
end;

procedure Tcallbac.DragDrop(Sender, Source: TObject; X, Y: integer);
var
  arg: PyObject;
begin
  arg := Py_BuildValue('(iiii)', integer(Pointer(Sender)), Pointer(Source), x, y);
  callobj_and_dec(arg);
end;

procedure Tcallbac.DragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: boolean);
var
  arg: PyObject;
begin
  arg := Py_BuildValue('(iiiii)', integer(Pointer(Sender)), Pointer(
    Source), x, y, booltoint(Accept));
  callobj_and_dec(arg);

end;

procedure Tcallbac.EndDrag(Sender, Target: TObject; X, Y: integer);
begin

end;

procedure Tcallbac.Enter(Sender: TObject);
begin

end;

procedure Tcallbac.Exit(Sender: TObject);
begin

end;

procedure Tcallbac.KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

end;

procedure Tcallbac.KeyPress(Sender: TObject; var Key: char);
begin

end;

procedure Tcallbac.KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin

end;

procedure Tcallbac.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

end;

procedure Tcallbac.MouseEnter(Sender: TObject);
begin

end;

procedure Tcallbac.MouseLeave(Sender: TObject);
begin

end;

procedure Tcallbac.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin

end;

procedure Tcallbac.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

end;

procedure Tcallbac.MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
begin

end;

procedure Tcallbac.MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin

end;

procedure Tcallbac.MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin

end;

procedure Tcallbac.Resize(Sender: TObject);
begin

end;

procedure Tcallbac.StartDrag(Sender: TObject; var DragObject: TDragObject);
begin

end;

procedure Tcallbac.CloseUp(Sender: TObject);
begin

end;

procedure Tcallbac.DropDown(Sender: TObject);
begin

end;

procedure Tcallbac.GetItems(Sender: TObject);
begin

end;

procedure Tcallbac.Select(Sender: TObject);
begin

end;

procedure Tcallbac.UTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin

end;

procedure Tcallbac.Activate(Sender: TObject);
begin

end;

procedure Tcallbac.Close(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure Tcallbac.CloseQuery(Sender: TObject; var CanClose: boolean);
begin

end;

procedure Tcallbac.Deactivate(Sender: TObject);
begin

end;

procedure Tcallbac.onCreate(Sender: TObject);
begin

end;

procedure Tcallbac.onDestroy(Sender: TObject);
begin

end;

procedure Tcallbac.DockDrop(Sender: TObject; Source: TDragDockObject; X, Y: integer);
begin

end;

procedure Tcallbac.DockOver(Sender: TObject; Source: TDragDockObject;
  X, Y: integer; State: TDragState; var Accept: boolean);
begin

end;

procedure Tcallbac.DropFiles(Sender: TObject; const FileNames: array of string);
begin

end;
procedure Tcallbac.Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin

end;
procedure Tcallbac.Popup(Sender: TObject);
begin

end;
procedure Tcallbac.DrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin

end;

procedure Tcallbac.MeasureItem(Control: TWinControl; Index: Integer;
  var AHeight: Integer);
begin

end;

procedure Tcallbac.SelectionChange(Sender: TObject; User: boolean);
begin

end;
procedure Tcallbac.EndDock(Sender, Target: TObject; X, Y: integer);
begin

end;

procedure Tcallbac.GetSiteInfo(Sender: TObject; DockClient: TControl;
  var InfluenceRect: TRect; MousePos: TPoint; var CanDock: boolean);
begin

end;

function Tcallbac.Help(Command: word; Data: PtrInt; var CallHelp: boolean): boolean;
begin

end;

procedure Tcallbac.Hide(Sender: TObject);
begin

end;

procedure Tcallbac.Paint(Sender: TObject);
begin

end;

procedure Tcallbac.ShortCut(var Msg: TLMKey; var Handled: boolean);
begin

end;

procedure Tcallbac.Show(Sender: TObject);
begin

end;

procedure Tcallbac.ShowHint(Sender: TObject; HintInfo: PHintInfo);
begin

end;

procedure Tcallbac.StartDock(Sender: TObject; var DragObject: TDragDockObject);
begin

end;

procedure Tcallbac.UnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: boolean);
begin

end;

procedure Tcallbac.WindowStateChange(Sender: TObject);
begin

end;

procedure Tcallbac.Change(Sender: TObject);
begin

end;



constructor Tcallbac.Create;
begin

end;

end.
