unit TMemopyunit;

interface
uses
  Classes, SysUtils, Controls, PyAPI, objectlistunit, pyutil, StdCtrls,callbacunit, Forms;
type

  TMemopy = class
 public
  cont: TMemo;
 procedure reg(var k: integer; var Methods:  array of PyMethodDef);
    constructor Create(p: TMemo);
end;
implementation
function TMemosetTag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Tag:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetTag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.Tag);
 end;
function TMemosetCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Cursor:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.Cursor);
 end;
function TMemosetLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Left:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.Left);
 end;
function TMemosetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Height:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.Height);
 end;
function TMemosetTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Top:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.Top);
 end;
function TMemosetWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Width:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.Width);
 end;
function TMemosetHelpContext(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.HelpContext:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetHelpContext(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.HelpContext);
 end;
function TMemosetColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Color:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.Color);
 end;
function TMemosetDragCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.DragCursor:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetDragCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.DragCursor);
 end;
function TMemosetEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Enabled:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.Enabled));
 end;
function TMemosetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.HideSelection:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.HideSelection));
 end;
function TMemosetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.MaxLength:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.MaxLength);
 end;
function TMemosetOnChange(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnChange:= call.Change;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnClick:= call.Click;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnContextPopup(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnContextPopup:= call.ContextPopup;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnDblClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnDblClick:= call.DblClick;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnDragDrop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnDragDrop:= call.DragDrop;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnDragOver(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnDragOver:= call.DragOver;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnEditingDone(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnEditingDone:= call.EditingDone;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnEndDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnEndDrag:= call.EndDrag;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnEnter(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnEnter:= call.Enter;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnExit(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnExit:= call.Exit;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnKeyDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnKeyDown:= call.KeyDown;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnKeyPress(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnKeyPress:= call.KeyPress;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnKeyUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnKeyUp:= call.KeyUp;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseDown:= call.MouseDown;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseEnter(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseEnter:= call.MouseEnter;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseLeave(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseLeave:= call.MouseLeave;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseMove(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseMove:= call.MouseMove;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseUp:= call.MouseUp;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseWheel(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseWheel:= call.MouseWheel;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseWheelDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseWheelDown:= call.MouseWheelDown;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnMouseWheelUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnMouseWheelUp:= call.MouseWheelUp;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnStartDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnStartDrag:= call.StartDrag;
  Result := PyInt_FromLong(0);
 end;
function TMemosetOnUTF8KeyPress(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:PyObject;
control_hash:integer;
call: Tcallbac;
begin
 PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TMemo(control_hash);
 PyCallable_Check(para);
   call := Tcallbac.Create;
  Py_IncRef(para);
call.pyfun := para;
  control.OnUTF8KeyPress:= call.UTF8KeyPress;
  Result := PyInt_FromLong(0);
 end;
function TMemosetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.ParentBidiMode:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentBidiMode));
 end;
function TMemosetParentColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.ParentColor:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetParentColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentColor));
 end;
function TMemosetParentFont(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.ParentFont:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetParentFont(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentFont));
 end;
function TMemosetParentShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.ParentShowHint:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetParentShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentShowHint));
 end;
function TMemosetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.ReadOnly:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.ReadOnly));
 end;
function TMemosetShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.ShowHint:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.ShowHint));
 end;
function TMemosetTabOrder(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.TabOrder:= para;
  Result := PyInt_FromLong(0);
 end;
function TMemogetTabOrder(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(control.TabOrder);
 end;
function TMemosetTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.TabStop:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.TabStop));
 end;
function TMemosetVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.Visible:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.Visible));
 end;
function TMemosetWantReturns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.WantReturns:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetWantReturns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.WantReturns));
 end;
function TMemosetWantTabs(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.WantTabs:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetWantTabs(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.WantTabs));
 end;
function TMemosetWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  control.WordWrap:= inttobool(para);
  Result := PyInt_FromLong(0);
 end;
function TMemogetWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMemo;
para:Integer;
control_hash:integer;
begin
 PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TMemo(control_hash);
  Result := PyInt_FromLong(booltoint(control.WordWrap));
 end;
function Create_TMemo(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
compo: TComponent;
 cont: TMemo;
formhashnum :Integer;
begin
PyArg_ParseTuple(Args, 'i', @formhashnum);
compo := TComponent(formhashnum);
compo := TComponent(formhashnum);
cont := TMemo.Create(compo);
 cont.Parent := TWinControl(compo);
 Result := PyInt_FromLong(integer(Pointer(cont)));
end;
constructor TMemopy.Create(p: TMemo);
begin
end;
procedure TMemopy.reg(var k: integer; var Methods:packed array of PyMethodDef);
begin
inc(k);
 Methods[k].Name := 'TMemosetTag';
  Methods[k].meth := @TMemosetTag;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetTag';
inc(k);
 Methods[k].Name := 'TMemogetTag';
  Methods[k].meth := @TMemogetTag;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetTag';
inc(k);
 Methods[k].Name := 'TMemosetCursor';
  Methods[k].meth := @TMemosetCursor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetCursor';
inc(k);
 Methods[k].Name := 'TMemogetCursor';
  Methods[k].meth := @TMemogetCursor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetCursor';
inc(k);
 Methods[k].Name := 'TMemosetLeft';
  Methods[k].meth := @TMemosetLeft;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetLeft';
inc(k);
 Methods[k].Name := 'TMemogetLeft';
  Methods[k].meth := @TMemogetLeft;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetLeft';
inc(k);
 Methods[k].Name := 'TMemosetHeight';
  Methods[k].meth := @TMemosetHeight;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetHeight';
inc(k);
 Methods[k].Name := 'TMemogetHeight';
  Methods[k].meth := @TMemogetHeight;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetHeight';
inc(k);
 Methods[k].Name := 'TMemosetTop';
  Methods[k].meth := @TMemosetTop;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetTop';
inc(k);
 Methods[k].Name := 'TMemogetTop';
  Methods[k].meth := @TMemogetTop;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetTop';
inc(k);
 Methods[k].Name := 'TMemosetWidth';
  Methods[k].meth := @TMemosetWidth;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetWidth';
inc(k);
 Methods[k].Name := 'TMemogetWidth';
  Methods[k].meth := @TMemogetWidth;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetWidth';
inc(k);
 Methods[k].Name := 'TMemosetHelpContext';
  Methods[k].meth := @TMemosetHelpContext;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetHelpContext';
inc(k);
 Methods[k].Name := 'TMemogetHelpContext';
  Methods[k].meth := @TMemogetHelpContext;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetHelpContext';
inc(k);
 Methods[k].Name := 'TMemosetColor';
  Methods[k].meth := @TMemosetColor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetColor';
inc(k);
 Methods[k].Name := 'TMemogetColor';
  Methods[k].meth := @TMemogetColor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetColor';
inc(k);
 Methods[k].Name := 'TMemosetDragCursor';
  Methods[k].meth := @TMemosetDragCursor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetDragCursor';
inc(k);
 Methods[k].Name := 'TMemogetDragCursor';
  Methods[k].meth := @TMemogetDragCursor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetDragCursor';
inc(k);
 Methods[k].Name := 'TMemosetEnabled';
  Methods[k].meth := @TMemosetEnabled;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetEnabled';
inc(k);
 Methods[k].Name := 'TMemogetEnabled';
  Methods[k].meth := @TMemogetEnabled;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetEnabled';
inc(k);
 Methods[k].Name := 'TMemosetHideSelection';
  Methods[k].meth := @TMemosetHideSelection;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetHideSelection';
inc(k);
 Methods[k].Name := 'TMemogetHideSelection';
  Methods[k].meth := @TMemogetHideSelection;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetHideSelection';
inc(k);
 Methods[k].Name := 'TMemosetMaxLength';
  Methods[k].meth := @TMemosetMaxLength;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetMaxLength';
inc(k);
 Methods[k].Name := 'TMemogetMaxLength';
  Methods[k].meth := @TMemogetMaxLength;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetMaxLength';
inc(k);
 Methods[k].Name := 'TMemosetOnChange';
  Methods[k].meth := @TMemosetOnChange;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnChange';
inc(k);
 Methods[k].Name := 'TMemosetOnClick';
  Methods[k].meth := @TMemosetOnClick;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnClick';
inc(k);
 Methods[k].Name := 'TMemosetOnContextPopup';
  Methods[k].meth := @TMemosetOnContextPopup;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnContextPopup';
inc(k);
 Methods[k].Name := 'TMemosetOnDblClick';
  Methods[k].meth := @TMemosetOnDblClick;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnDblClick';
inc(k);
 Methods[k].Name := 'TMemosetOnDragDrop';
  Methods[k].meth := @TMemosetOnDragDrop;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnDragDrop';
inc(k);
 Methods[k].Name := 'TMemosetOnDragOver';
  Methods[k].meth := @TMemosetOnDragOver;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnDragOver';
inc(k);
 Methods[k].Name := 'TMemosetOnEditingDone';
  Methods[k].meth := @TMemosetOnEditingDone;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnEditingDone';
inc(k);
 Methods[k].Name := 'TMemosetOnEndDrag';
  Methods[k].meth := @TMemosetOnEndDrag;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnEndDrag';
inc(k);
 Methods[k].Name := 'TMemosetOnEnter';
  Methods[k].meth := @TMemosetOnEnter;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnEnter';
inc(k);
 Methods[k].Name := 'TMemosetOnExit';
  Methods[k].meth := @TMemosetOnExit;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnExit';
inc(k);
 Methods[k].Name := 'TMemosetOnKeyDown';
  Methods[k].meth := @TMemosetOnKeyDown;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnKeyDown';
inc(k);
 Methods[k].Name := 'TMemosetOnKeyPress';
  Methods[k].meth := @TMemosetOnKeyPress;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnKeyPress';
inc(k);
 Methods[k].Name := 'TMemosetOnKeyUp';
  Methods[k].meth := @TMemosetOnKeyUp;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnKeyUp';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseDown';
  Methods[k].meth := @TMemosetOnMouseDown;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseDown';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseEnter';
  Methods[k].meth := @TMemosetOnMouseEnter;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseEnter';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseLeave';
  Methods[k].meth := @TMemosetOnMouseLeave;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseLeave';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseMove';
  Methods[k].meth := @TMemosetOnMouseMove;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseMove';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseUp';
  Methods[k].meth := @TMemosetOnMouseUp;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseUp';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseWheel';
  Methods[k].meth := @TMemosetOnMouseWheel;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseWheel';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseWheelDown';
  Methods[k].meth := @TMemosetOnMouseWheelDown;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseWheelDown';
inc(k);
 Methods[k].Name := 'TMemosetOnMouseWheelUp';
  Methods[k].meth := @TMemosetOnMouseWheelUp;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnMouseWheelUp';
inc(k);
 Methods[k].Name := 'TMemosetOnStartDrag';
  Methods[k].meth := @TMemosetOnStartDrag;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnStartDrag';
inc(k);
 Methods[k].Name := 'TMemosetOnUTF8KeyPress';
  Methods[k].meth := @TMemosetOnUTF8KeyPress;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetOnUTF8KeyPress';
inc(k);
 Methods[k].Name := 'TMemosetParentBidiMode';
  Methods[k].meth := @TMemosetParentBidiMode;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetParentBidiMode';
inc(k);
 Methods[k].Name := 'TMemogetParentBidiMode';
  Methods[k].meth := @TMemogetParentBidiMode;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetParentBidiMode';
inc(k);
 Methods[k].Name := 'TMemosetParentColor';
  Methods[k].meth := @TMemosetParentColor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetParentColor';
inc(k);
 Methods[k].Name := 'TMemogetParentColor';
  Methods[k].meth := @TMemogetParentColor;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetParentColor';
inc(k);
 Methods[k].Name := 'TMemosetParentFont';
  Methods[k].meth := @TMemosetParentFont;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetParentFont';
inc(k);
 Methods[k].Name := 'TMemogetParentFont';
  Methods[k].meth := @TMemogetParentFont;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetParentFont';
inc(k);
 Methods[k].Name := 'TMemosetParentShowHint';
  Methods[k].meth := @TMemosetParentShowHint;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetParentShowHint';
inc(k);
 Methods[k].Name := 'TMemogetParentShowHint';
  Methods[k].meth := @TMemogetParentShowHint;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetParentShowHint';
inc(k);
 Methods[k].Name := 'TMemosetReadOnly';
  Methods[k].meth := @TMemosetReadOnly;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetReadOnly';
inc(k);
 Methods[k].Name := 'TMemogetReadOnly';
  Methods[k].meth := @TMemogetReadOnly;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetReadOnly';
inc(k);
 Methods[k].Name := 'TMemosetShowHint';
  Methods[k].meth := @TMemosetShowHint;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetShowHint';
inc(k);
 Methods[k].Name := 'TMemogetShowHint';
  Methods[k].meth := @TMemogetShowHint;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetShowHint';
inc(k);
 Methods[k].Name := 'TMemosetTabOrder';
  Methods[k].meth := @TMemosetTabOrder;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetTabOrder';
inc(k);
 Methods[k].Name := 'TMemogetTabOrder';
  Methods[k].meth := @TMemogetTabOrder;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetTabOrder';
inc(k);
 Methods[k].Name := 'TMemosetTabStop';
  Methods[k].meth := @TMemosetTabStop;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetTabStop';
inc(k);
 Methods[k].Name := 'TMemogetTabStop';
  Methods[k].meth := @TMemogetTabStop;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetTabStop';
inc(k);
 Methods[k].Name := 'TMemosetVisible';
  Methods[k].meth := @TMemosetVisible;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetVisible';
inc(k);
 Methods[k].Name := 'TMemogetVisible';
  Methods[k].meth := @TMemogetVisible;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetVisible';
inc(k);
 Methods[k].Name := 'TMemosetWantReturns';
  Methods[k].meth := @TMemosetWantReturns;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetWantReturns';
inc(k);
 Methods[k].Name := 'TMemogetWantReturns';
  Methods[k].meth := @TMemogetWantReturns;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetWantReturns';
inc(k);
 Methods[k].Name := 'TMemosetWantTabs';
  Methods[k].meth := @TMemosetWantTabs;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetWantTabs';
inc(k);
 Methods[k].Name := 'TMemogetWantTabs';
  Methods[k].meth := @TMemogetWantTabs;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetWantTabs';
inc(k);
 Methods[k].Name := 'TMemosetWordWrap';
  Methods[k].meth := @TMemosetWordWrap;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemosetWordWrap';
inc(k);
 Methods[k].Name := 'TMemogetWordWrap';
  Methods[k].meth := @TMemogetWordWrap;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'TMemogetWordWrap';
inc(k);
 Methods[k].Name := 'Create_TMemo';
  Methods[k].meth := @Create_TMemo;
  Methods[k].flags := METH_VARARGS;
   Methods[k].doc := 'Create_TMemo';
end;
end.

