unit TpyTedUnit;

{$mode delphi}

interface

uses
  Classes, SysUtils, Controls, PyAPI, objectlistunit, pyutil, StdCtrls, callbacunit, Forms;

type

  { Tpyedit }

  Tpyedit = class
  public

    constructor Create(obj: Tlaz4py);
   class procedure reg(var k: integer; var Methods: array of PyMethodDef);
  end;

implementation
function Create_Edit(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  Reference: Pointer;
  hashnum: integer;
  formhashnum: integer;
  form: TForm;
  button: TEdit;
  //cal: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'i', @formhashnum);
  form := TForm(formhashnum);
  button := TEdit.Create(form);
  button.Parent := form;
  button.Visible := True;
  //cal := Tcallbac.Create;
  // button.OnClick := cal.onclick;
  Result := PyInt_FromLong(integer(Pointer(button)));
end;

function setTag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Tag := para;
  Result := PyInt_FromLong(0);
end;

function getTag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.Tag);
end;

function setCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Cursor := para;
  Result := PyInt_FromLong(0);
end;

function getCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.Cursor);
end;

function setLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Left := para;
  Result := PyInt_FromLong(0);
end;

function getLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.Left);
end;

function setHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Height := para;
  Result := PyInt_FromLong(0);
end;

function getHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.Height);
end;

function setTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Top := para;
  Result := PyInt_FromLong(0);
end;

function getTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.Top);
end;

function setWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Width := para;
  Result := PyInt_FromLong(0);
end;

function getWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.Width);
end;

function setHelpContext(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.HelpContext := para;
  Result := PyInt_FromLong(0);
end;

function getHelpContext(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.HelpContext);
end;

function setAutoSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.AutoSize := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getAutoSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.AutoSize));
end;

function setAutoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.AutoSelect := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getAutoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.AutoSelect));
end;

function setColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Color := para;
  Result := PyInt_FromLong(0);
end;

function getColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.Color);
end;

function setDragCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.DragCursor := para;
  Result := PyInt_FromLong(0);
end;

function getDragCursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.DragCursor);
end;

function setEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Enabled := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.Enabled));
end;

function setHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.HideSelection := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.HideSelection));
end;

function setMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.MaxLength := para;
  Result := PyInt_FromLong(0);
end;

function getMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.MaxLength);
end;

function setParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.ParentBidiMode := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentBidiMode));
end;

function setOnChange(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnChange := call.Change;
  Result := PyInt_FromLong(0);
end;

function setOnChangeBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnChangeBounds := call.ChangeBounds;
  Result := PyInt_FromLong(0);
end;

function setOnClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnClick := call.Click;
  Result := PyInt_FromLong(0);
end;

function setOnContextPopup(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnContextPopup := call.ContextPopup;
  Result := PyInt_FromLong(0);
end;

function setOnDblClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnDblClick := call.DblClick;
  Result := PyInt_FromLong(0);
end;

function setOnDragDrop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnDragDrop := call.DragDrop;
  Result := PyInt_FromLong(0);
end;

function setOnDragOver(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnDragOver := call.DragOver;
  Result := PyInt_FromLong(0);
end;

function setOnEditingDone(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnEditingDone := call.EditingDone;
  Result := PyInt_FromLong(0);
end;

function setOnEndDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnEndDrag := call.EndDrag;
  Result := PyInt_FromLong(0);
end;

function setOnEnter(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnEnter := call.Enter;
  Result := PyInt_FromLong(0);
end;

function setOnExit(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnExit := call.Exit;
  Result := PyInt_FromLong(0);
end;

function setOnKeyDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnKeyDown := call.KeyDown;
  Result := PyInt_FromLong(0);
end;

function setOnKeyPress(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnKeyPress := call.KeyPress;
  Result := PyInt_FromLong(0);
end;

function setOnKeyUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnKeyUp := call.KeyUp;
  Result := PyInt_FromLong(0);
end;

function setOnMouseDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnMouseDown := call.MouseDown;
  Result := PyInt_FromLong(0);
end;

function setOnMouseEnter(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnMouseEnter := call.MouseEnter;
  Result := PyInt_FromLong(0);
end;

function setOnMouseLeave(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnMouseLeave := call.MouseLeave;
  Result := PyInt_FromLong(0);
end;

function setOnMouseMove(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnMouseMove := call.MouseMove;
  Result := PyInt_FromLong(0);
end;

function setOnMouseUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnMouseUp := call.MouseUp;
  Result := PyInt_FromLong(0);
end;

function setOnResize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnResize := call.Resize;
  Result := PyInt_FromLong(0);
end;

function setOnStartDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnStartDrag := call.StartDrag;
  Result := PyInt_FromLong(0);
end;

function setOnUTF8KeyPress(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: PyObject;
  control_hash: integer;
  call: Tcallbac;
begin
  PyArg_ParseTuple(Args, 'iO', @control_hash, @para);
  control := TEdit(control_hash);
  PyCallable_Check(para);
  call := Tcallbac.Create;
  Py_IncRef(para);
  call.pyfun := para;
  control.OnUTF8KeyPress := call.UTF8KeyPress;
  Result := PyInt_FromLong(0);
end;

function setParentColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.ParentColor := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getParentColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentColor));
end;

function setParentFont(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.ParentFont := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getParentFont(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentFont));
end;

function setParentShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.ParentShowHint := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getParentShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.ParentShowHint));
end;

function setReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.ReadOnly := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.ReadOnly));
end;

function setShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.ShowHint := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.ShowHint));
end;

function setTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.TabStop := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.TabStop));
end;

function setTabOrder(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.TabOrder := para;
  Result := PyInt_FromLong(0);
end;

function getTabOrder(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(control.TabOrder);
end;

function setVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  control.Visible := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TEdit;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TEdit(control_hash);
  Result := PyInt_FromLong(booltoint(control.Visible));
end;


{ Tpyedit }

constructor Tpyedit.Create(obj: Tlaz4py);
begin

end;

class procedure Tpyedit.reg(var k: integer; var Methods:packed array of PyMethodDef);
begin
  Inc(k);
  Methods[k].Name := 'Create_Edit';
  Methods[k].meth := @Create_Edit;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'creat new edit';
  Inc(k);
  Methods[k].Name := 'setTag';
  Methods[k].meth := @setTag;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Tag';
  Inc(k);
  Methods[k].Name := 'getTag';
  Methods[k].meth := @getTag;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Tag';
  Inc(k);
  Methods[k].Name := 'setCursor';
  Methods[k].meth := @setCursor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Cursor';
  Inc(k);
  Methods[k].Name := 'getCursor';
  Methods[k].meth := @getCursor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Cursor';
  Inc(k);
  Methods[k].Name := 'setLeft';
  Methods[k].meth := @setLeft;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Left';
  Inc(k);
  Methods[k].Name := 'getLeft';
  Methods[k].meth := @getLeft;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Left';
  Inc(k);
  Methods[k].Name := 'setHeight';
  Methods[k].meth := @setHeight;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Height';
  Inc(k);
  Methods[k].Name := 'getHeight';
  Methods[k].meth := @getHeight;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Height';
  Inc(k);
  Methods[k].Name := 'setTop';
  Methods[k].meth := @setTop;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Top';
  Inc(k);
  Methods[k].Name := 'getTop';
  Methods[k].meth := @getTop;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Top';
  Inc(k);
  Methods[k].Name := 'setWidth';
  Methods[k].meth := @setWidth;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Width';
  Inc(k);
  Methods[k].Name := 'getWidth';
  Methods[k].meth := @getWidth;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Width';
  Inc(k);
  Methods[k].Name := 'setHelpContext';
  Methods[k].meth := @setHelpContext;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set HelpContext';
  Inc(k);
  Methods[k].Name := 'getHelpContext';
  Methods[k].meth := @getHelpContext;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set HelpContext';
  Inc(k);
  Methods[k].Name := 'setAutoSize';
  Methods[k].meth := @setAutoSize;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set AutoSize';
  Inc(k);
  Methods[k].Name := 'getAutoSize';
  Methods[k].meth := @getAutoSize;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set AutoSize';
  Inc(k);
  Methods[k].Name := 'setAutoSelect';
  Methods[k].meth := @setAutoSelect;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set AutoSelect';
  Inc(k);
  Methods[k].Name := 'getAutoSelect';
  Methods[k].meth := @getAutoSelect;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set AutoSelect';
  Inc(k);
  Methods[k].Name := 'setColor';
  Methods[k].meth := @setColor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Color';
  Inc(k);
  Methods[k].Name := 'getColor';
  Methods[k].meth := @getColor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Color';
  Inc(k);
  Methods[k].Name := 'setDragCursor';
  Methods[k].meth := @setDragCursor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set DragCursor';
  Inc(k);
  Methods[k].Name := 'getDragCursor';
  Methods[k].meth := @getDragCursor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set DragCursor';
  Inc(k);
  Methods[k].Name := 'setEnabled';
  Methods[k].meth := @setEnabled;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Enabled';
  Inc(k);
  Methods[k].Name := 'getEnabled';
  Methods[k].meth := @getEnabled;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Enabled';
  Inc(k);
  Methods[k].Name := 'setHideSelection';
  Methods[k].meth := @setHideSelection;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set HideSelection';
  Inc(k);
  Methods[k].Name := 'getHideSelection';
  Methods[k].meth := @getHideSelection;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set HideSelection';
  Inc(k);
  Methods[k].Name := 'setMaxLength';
  Methods[k].meth := @setMaxLength;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set MaxLength';
  Inc(k);
  Methods[k].Name := 'getMaxLength';
  Methods[k].meth := @getMaxLength;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set MaxLength';
  Inc(k);
  Methods[k].Name := 'setParentBidiMode';
  Methods[k].meth := @setParentBidiMode;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentBidiMode';
  Inc(k);
  Methods[k].Name := 'getParentBidiMode';
  Methods[k].meth := @getParentBidiMode;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentBidiMode';
  Inc(k);
  Methods[k].Name := 'setOnChange';
  Methods[k].meth := @setOnChange;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnChange';
  Inc(k);
  Methods[k].Name := 'setOnChangeBounds';
  Methods[k].meth := @setOnChangeBounds;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnChangeBounds';
  Inc(k);
  Methods[k].Name := 'setOnClick';
  Methods[k].meth := @setOnClick;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnClick';
  Inc(k);
  Methods[k].Name := 'setOnContextPopup';
  Methods[k].meth := @setOnContextPopup;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnContextPopup';
  Inc(k);
  Methods[k].Name := 'setOnDblClick';
  Methods[k].meth := @setOnDblClick;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnDblClick';
  Inc(k);
  Methods[k].Name := 'setOnDragDrop';
  Methods[k].meth := @setOnDragDrop;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnDragDrop';
  Inc(k);
  Methods[k].Name := 'setOnDragOver';
  Methods[k].meth := @setOnDragOver;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnDragOver';
  Inc(k);
  Methods[k].Name := 'setOnEditingDone';
  Methods[k].meth := @setOnEditingDone;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnEditingDone';
  Inc(k);
  Methods[k].Name := 'setOnEndDrag';
  Methods[k].meth := @setOnEndDrag;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnEndDrag';
  Inc(k);
  Methods[k].Name := 'setOnEnter';
  Methods[k].meth := @setOnEnter;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnEnter';
  Inc(k);
  Methods[k].Name := 'setOnExit';
  Methods[k].meth := @setOnExit;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnExit';
  Inc(k);
  Methods[k].Name := 'setOnKeyDown';
  Methods[k].meth := @setOnKeyDown;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnKeyDown';
  Inc(k);
  Methods[k].Name := 'setOnKeyPress';
  Methods[k].meth := @setOnKeyPress;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnKeyPress';
  Inc(k);
  Methods[k].Name := 'setOnKeyUp';
  Methods[k].meth := @setOnKeyUp;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnKeyUp';
  Inc(k);
  Methods[k].Name := 'setOnMouseDown';
  Methods[k].meth := @setOnMouseDown;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnMouseDown';
  Inc(k);
  Methods[k].Name := 'setOnMouseEnter';
  Methods[k].meth := @setOnMouseEnter;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnMouseEnter';
  Inc(k);
  Methods[k].Name := 'setOnMouseLeave';
  Methods[k].meth := @setOnMouseLeave;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnMouseLeave';
  Inc(k);
  Methods[k].Name := 'setOnMouseMove';
  Methods[k].meth := @setOnMouseMove;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnMouseMove';
  Inc(k);
  Methods[k].Name := 'setOnMouseUp';
  Methods[k].meth := @setOnMouseUp;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnMouseUp';
  Inc(k);
  Methods[k].Name := 'setOnResize';
  Methods[k].meth := @setOnResize;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnResize';
  Inc(k);
  Methods[k].Name := 'setOnStartDrag';
  Methods[k].meth := @setOnStartDrag;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnStartDrag';
  Inc(k);
  Methods[k].Name := 'setOnUTF8KeyPress';
  Methods[k].meth := @setOnUTF8KeyPress;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OnUTF8KeyPress';
  Inc(k);
  Methods[k].Name := 'setParentColor';
  Methods[k].meth := @setParentColor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentColor';
  Inc(k);
  Methods[k].Name := 'getParentColor';
  Methods[k].meth := @getParentColor;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentColor';
  Inc(k);
  Methods[k].Name := 'setParentFont';
  Methods[k].meth := @setParentFont;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentFont';
  Inc(k);
  Methods[k].Name := 'getParentFont';
  Methods[k].meth := @getParentFont;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentFont';
  Inc(k);
  Methods[k].Name := 'setParentShowHint';
  Methods[k].meth := @setParentShowHint;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentShowHint';
  Inc(k);
  Methods[k].Name := 'getParentShowHint';
  Methods[k].meth := @getParentShowHint;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ParentShowHint';
  Inc(k);
  Methods[k].Name := 'setReadOnly';
  Methods[k].meth := @setReadOnly;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ReadOnly';
  Inc(k);
  Methods[k].Name := 'getReadOnly';
  Methods[k].meth := @getReadOnly;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ReadOnly';
  Inc(k);
  Methods[k].Name := 'setShowHint';
  Methods[k].meth := @setShowHint;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ShowHint';
  Inc(k);
  Methods[k].Name := 'getShowHint';
  Methods[k].meth := @getShowHint;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ShowHint';
  Inc(k);
  Methods[k].Name := 'setTabStop';
  Methods[k].meth := @setTabStop;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set TabStop';
  Inc(k);
  Methods[k].Name := 'getTabStop';
  Methods[k].meth := @getTabStop;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set TabStop';
  Inc(k);
  Methods[k].Name := 'setTabOrder';
  Methods[k].meth := @setTabOrder;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set TabOrder';
  Inc(k);
  Methods[k].Name := 'getTabOrder';
  Methods[k].meth := @getTabOrder;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set TabOrder';
  Inc(k);
  Methods[k].Name := 'setVisible';
  Methods[k].meth := @setVisible;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Visible';
  Inc(k);
  Methods[k].Name := 'getVisible';
  Methods[k].meth := @getVisible;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Visible';
end;

end.
