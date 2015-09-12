library PyMinMod;

{
 
  Minimal Python module (library) that includes simple functions.
 
  Author: Phil (MacPgmr at fastermac.net).
 
  To compile this module:
    - With Delphi: Open this .dpr file and compile.
    - With Lazarus: Open .lpi file and compile.
 
  To deploy module:
    - With Delphi: Rename compiled .dll to .pyd.
    - With Lazarus on Windows: Rename compiled .so to .pyd.
    - With Lazarus on OS X and Linux: .so extension is okay.
 
}

uses
  Interfaces,
  Classes,
  SysUtils,
  PyAPI,
  Forms,
  Controls,
  StdCtrls,
  objectlistunit,
  callbacunit,
  lfmunit,
  TpyTedUnit,
  TpyTbuttonUnit,
  TpylabelUnit,
  TMemopyunit,
  TButtonpyunit,
  TCheckBoxpyunit,
  TComboBoxpyunit,
  TEditpyunit,
  TFormpyunit,
  TLabelpyunit,
  TListBoxpyunit,
  TMainMenupyunit,
  TMenuItempyunit,
  TPopupMenupyunit,
  TRadioButtonpyunit,
  TScrollBarpyunit,
  TToggleBoxpyunit,
  regallUnit,
  reginterfaceunit,
  ObjserUnit,
  Dialogs,Menus,pyutil;

  function SumTwoIntegers(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Arg1: integer;
    Arg2: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @Arg1, @Arg2);  //Get the two int arguments
    Result := PyInt_FromLong(Arg1 + Arg2);  //Add them together and return sum
    //  Result := PyLong_FromLong(Arg1 + Arg2);
    //  Result := PyLong_FromUnsignedLong(Arg1 + Arg2);
  end;


  function ConcatTwoStrings(Self: PyObject; Args: PyObject): PyObject; cdecl;
 {From Python documentation for "s" format: "You must not provide storage for
   the string itself; a pointer to an existing string is stored into the
   character pointer variable whose address you pass."
  From Python documentation for PyString_FromString: "Return a new string
   object with a copy of the string v as value on success".}
  var
    Arg1: PAnsiChar;
    Arg2: PAnsiChar;
  begin
    PyArg_ParseTuple(Args, 'ss', @Arg1, @Arg2);  //Get the two string arguments
    Result := PyString_FromString(PAnsiChar(ansistring(Arg1) + ansistring(Arg2)));
    //Concatenate and return string
  end;


var
  Methods: packed array [0..800] of PyMethodDef;
  laz4pyobj: Tlaz4py;
  numofcall: integer;

  function Create_Form(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Reference: Pointer;
    hashnum, prehash: integer;
  begin
    Application.Initialize;
    Application.CreateForm(TForm, Reference);
    //hashnum := laz4pyobj.add_obj(Reference);
    hashnum := integer(Pointer(Reference));
    Result := PyInt_FromLong(hashnum);
  end;

  function Create_FormLfm(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Reference: Pointer;
    hashnum, prehash: integer;
    Arg1,Arg2: PChar;
    rsredeader: Tlfmreader;
    f: TForm;
    pstr:String;
  begin
    Application.Initialize;
    PyArg_ParseTuple(Args, 'ss', @Arg1,@Arg2);
    rsredeader := Tlfmreader.Create(f,StrPas(Arg1));
    rsredeader.readlfm(f, StrPas(Arg1));
    pstr:=rsredeader.setcompnentpointer(f,StrPas(Arg2));
    f.Show;
    //Application.CreateForm(TForm, Reference);
    //hashnum := laz4pyobj.add_obj(Reference);
    StrPCopy(arg1,pstr);
    rsredeader.free;
    Result :=PyString_FromString(Arg1);
  end;

  function Application_Run(Self: PyObject; Args: PyObject): PyObject; cdecl;
  begin
    Application.Run;
    Result := PyInt_FromLong(0);
  end;

  function Create_Label(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var

    Reference: Pointer;
    hashnum: integer;
    formhashnum: integer;
    form: TForm;
    lab: TLabel;
    //cal: Tcallbac;
  begin
    PyArg_ParseTuple(Args, 'i', @formhashnum);
    form := TForm(formhashnum);
    lab := TLabel.Create(form);
    lab.Parent := form;
    //lab.Visible := True;
    //cal := Tcallbac.Create;
    // button.OnClick := cal.onclick;
    Result := PyInt_FromLong(integer(Pointer(lab)));
  end;

  function Create_Button(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var

    Reference: Pointer;
    hashnum: integer;
    formhashnum: integer;
    form: TForm;
    button: TButton;
    //cal: Tcallbac;
  begin
    PyArg_ParseTuple(Args, 'i', @formhashnum);
    form := TForm(formhashnum);
    button := TButton.Create(form);
    button.Parent := form;
    button.Visible := True;
    //cal := Tcallbac.Create;
    // button.OnClick := cal.onclick;
    Result := PyInt_FromLong(integer(Pointer(button)));
  end;

  function SetOnClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    temp, arg, pyresult: PyObject;
    call: Tcallbac;
    targetBut, iscall: integer;
    but: TButton;
  begin
    temp := nil;
    if (PyArg_ParseTuple(args, 'Oi', @temp, @targetBut) > 0) then
    begin
      PyCallable_Check(temp);
      call := Tcallbac.Create;
      Py_IncRef(temp);         // Add a reference to new callback */
      {Py_XDECREF(call.pyfun);  }// Dispose of previous callback */
      call.pyfun := temp;
      //targetBut:=1;
      but := TButton(targetBut);
      but.OnClick := call.click;
      // arg := Py_BuildValue('');
      //pyresult := PyObject_CallObject(temp, arg);
      //iscall:=PyCallable_Check(temp);
    end;
    Result := PyInt_FromLong(integer(pyresult));
  end;

  function Control_SetOnClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    temp: ^PyObject;
    call: Tcallbac;
  begin
    if (PyArg_ParseTuple(args, 'O:set_callback', @temp) > 0) then
    begin
      call := Tcallbac.Create;
      Py_XINCREF(temp);         // Add a reference to new callback */
      Py_XDECREF(call.pyfun);  // Dispose of previous callback */
      call.pyfun := temp;       // Remember new callback */
      // Boilerplate to return "None" */
      //Py_INCREF(Py_None);
    end;
    Result := Py_BuildValue('');
  end;

  function Set_Caption(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Arg1: PAnsiChar;
    control_hash: integer;
    control: TControl;
  begin
    PyArg_ParseTuple(Args, 'is', @control_hash, @Arg1);  //Get the two string arguments
    control := TControl(control_hash);
    control.Caption := Arg1;
    Result := PyString_FromString(PAnsiChar(ansistring(Arg1)));
  end;

  function Set_Top(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control_hash, top: integer;
    control: TControl;
    F: TextFile;
  begin
   { AssignFile(F, 'G:\dev\laz4py\laz4py3\o.txt');
    Rewrite(F);
    numofcall := numofcall + 1;
    WriteLn(F, IntToStr(numofcall));
    CloseFile(F);    }
    PyArg_ParseTuple(Args, 'ii', @control_hash, @top);  //Get the two string arguments
    control := TControl(control_hash);
    control.Top := top;
    Result := PyInt_FromLong(top);
  end;
  //auto gen
  function Set_HelpContext(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    para, control_hash: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.HelpContext := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Tag(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Tag := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Cursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Cursor := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Left(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Left := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Height(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Height := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Width(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := TControl(control_hash);
    control.Width := para;
    Result := PyInt_FromLong(para);
  end;

  procedure Teditinteface(var k: integer);
  var
    pyedit: Tpyedit;
    inter: Treginterface;
  begin
    //regall(k, Methods);
    //pyedit:=Tpyedit.create(Nil);
    //pyedit.reg(k,Methods);
    //inter := TFormpy.Create(nil);
  end;

//fun TFormCreate
function TFormCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
TheOwner:Integer;
begin
PyArg_ParseTuple(Args, 'i',@TheOwner);
result:=PyInt_FromLong(Integer(pointer(TForm.Create(TComponent(TheOwner)))));
end;
//fun TFormTile
function TFormTile(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TForm(pointer(controlobj)).Tile;
Result := PyInt_FromLong(0);
end;
//fun TFormsetAutoScroll
function TFormsetAutoScroll(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TForm(pointer(controlobj)).AutoScroll:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TFormgetAutoScroll
function TFormgetAutoScroll(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TForm(pointer(controlobj)).AutoScroll));
end;
//fun TFormsetOnDblClick
function TFormsetOnDblClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDblClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TFormsetOnMouseEnter
function TFormsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TFormsetOnMouseLeave
function TFormsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TFormsetParentFont
function TFormsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TForm(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TFormgetParentFont
function TFormgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TForm(pointer(controlobj)).ParentFont));
end;
//fun TFormsetSessionProperties
function TFormsetSessionProperties(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TForm(pointer(controlobj)).SessionProperties:=string(para0);
Result := PyInt_FromLong(0);
end;
//fun TFormgetSessionProperties
function TFormgetSessionProperties(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TForm(pointer(controlobj)).SessionProperties));
end;
//fun TFormsetLCLVersion
function TFormsetLCLVersion(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TForm(pointer(controlobj)).LCLVersion:=string(para0);
Result := PyInt_FromLong(0);
end;
//fun TFormgetLCLVersion
function TFormgetLCLVersion(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TForm(pointer(controlobj)).LCLVersion));
end;
//fun TMainMenuCreate
function TMainMenuCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
AOwner:Integer;
begin
PyArg_ParseTuple(Args, 'i',@AOwner);
result:=PyInt_FromLong(Integer(pointer(TMainMenu.Create(TComponent(AOwner)))));
end;
//fun TMainMenugetHeight
function TMainMenugetHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TMainMenu(pointer(controlobj)).Height);
end;
//fun TMenuItemFind
function TMenuItemFind(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
ACaption:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@ACaption);
TMenuItem(pointer(controlobj)).Find(string(ACaption));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemGetParentComponent
function TMenuItemGetParentComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).GetParentComponent;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemGetParentMenu
function TMenuItemGetParentMenu(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).GetParentMenu;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemGetIsRightToLeft
function TMenuItemGetIsRightToLeft(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).GetIsRightToLeft;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemHandleAllocated
function TMenuItemHandleAllocated(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).HandleAllocated;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemHasIcon
function TMenuItemHasIcon(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).HasIcon;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemHasParent
function TMenuItemHasParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).HasParent;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemInitiateAction
function TMenuItemInitiateAction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).InitiateAction;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemIntfDoSelect
function TMenuItemIntfDoSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).IntfDoSelect;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemIndexOf
function TMenuItemIndexOf(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Item:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Item);
TMenuItem(pointer(controlobj)).IndexOf(TMenuItem(Item));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemIndexOfCaption
function TMenuItemIndexOfCaption(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
ACaption:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@ACaption);
TMenuItem(pointer(controlobj)).IndexOfCaption(string(ACaption));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemVisibleIndexOf
function TMenuItemVisibleIndexOf(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Item:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Item);
TMenuItem(pointer(controlobj)).VisibleIndexOf(TMenuItem(Item));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemAdd
function TMenuItemAdd(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Item:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Item);
TMenuItem(pointer(controlobj)).Add(TMenuItem(Item));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemAddSeparator
function TMenuItemAddSeparator(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).AddSeparator;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemClick
function TMenuItemClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).Click;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemDelete
function TMenuItemDelete(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Index);
TMenuItem(pointer(controlobj)).Delete(Integer(Index));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemHandleNeeded
function TMenuItemHandleNeeded(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).HandleNeeded;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemInsert
function TMenuItemInsert(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Item:Integer;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@Index,@Item);
TMenuItem(pointer(controlobj)).Insert(Integer(Index),TMenuItem(Item));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemRecreateHandle
function TMenuItemRecreateHandle(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).RecreateHandle;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemRemove
function TMenuItemRemove(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Item:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Item);
TMenuItem(pointer(controlobj)).Remove(TMenuItem(Item));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemIsCheckItem
function TMenuItemIsCheckItem(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).IsCheckItem;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemIsLine
function TMenuItemIsLine(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).IsLine;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemIsInMenuBar
function TMenuItemIsInMenuBar(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).IsInMenuBar;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemClear
function TMenuItemClear(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).Clear;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemHasBitmap
function TMenuItemHasBitmap(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).HasBitmap;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemRemoveAllHandlersOfObject
function TMenuItemRemoveAllHandlersOfObject(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AnObject:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AnObject);
TMenuItem(pointer(controlobj)).RemoveAllHandlersOfObject(TObject(AnObject));
Result := PyInt_FromLong(0);
end;
//fun TMenuItemgetCount
function TMenuItemgetCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TMenuItem(pointer(controlobj)).Count);
end;
//fun TMenuItemgetItems
function TMenuItemgetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyInt_FromLong(Integer(pointer(TMenuItem(pointer(controlobj)).Items[indexedpara0])));
end;
//fun TMenuItemsetMenuIndex
function TMenuItemsetMenuIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMenuItem(pointer(controlobj)).MenuIndex:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TMenuItemgetMenuIndex
function TMenuItemgetMenuIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TMenuItem(pointer(controlobj)).MenuIndex);
end;
//fun TMenuItemgetMenu
function TMenuItemgetMenu(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TMenuItem(pointer(controlobj)).Menu)));
end;
//fun TMenuItemgetParent
function TMenuItemgetParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TMenuItem(pointer(controlobj)).Parent)));
end;
//fun TMenuItemMenuVisibleIndex
function TMenuItemMenuVisibleIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenuItem(pointer(controlobj)).MenuVisibleIndex;
Result := PyInt_FromLong(0);
end;
//fun TMenuItemsetAutoCheck
function TMenuItemsetAutoCheck(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMenuItem(pointer(controlobj)).AutoCheck:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMenuItemgetAutoCheck
function TMenuItemgetAutoCheck(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMenuItem(pointer(controlobj)).AutoCheck));
end;
//fun TMenuItemsetDefault
function TMenuItemsetDefault(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMenuItem(pointer(controlobj)).Default:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMenuItemgetDefault
function TMenuItemgetDefault(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMenuItem(pointer(controlobj)).Default));
end;
//fun TMenuItemsetRadioItem
function TMenuItemsetRadioItem(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMenuItem(pointer(controlobj)).RadioItem:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMenuItemgetRadioItem
function TMenuItemgetRadioItem(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMenuItem(pointer(controlobj)).RadioItem));
end;
//fun TMenuItemsetRightJustify
function TMenuItemsetRightJustify(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMenuItem(pointer(controlobj)).RightJustify:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMenuItemgetRightJustify
function TMenuItemgetRightJustify(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMenuItem(pointer(controlobj)).RightJustify));
end;
//fun TMenuItemsetOnClick
function TMenuItemsetOnClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TMenuItem;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TMenuItem(targetBut);
freeoldcalbac(oldcall);
controlobj.OnClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TPopupMenuPopUp
function TPopupMenuPopUp(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TPopupMenu(pointer(controlobj)).PopUp;
Result := PyInt_FromLong(0);
end;
//fun TPopupMenusetPopupComponent
function TPopupMenusetPopupComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TPopupMenu(pointer(controlobj)).PopupComponent:=TComponent(para0);
Result := PyInt_FromLong(0);
end;
//fun TPopupMenugetPopupComponent
function TPopupMenugetPopupComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TPopupMenu(pointer(controlobj)).PopupComponent)));
end;
//fun TPopupMenusetAutoPopup
function TPopupMenusetAutoPopup(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TPopupMenu(pointer(controlobj)).AutoPopup:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TPopupMenugetAutoPopup
function TPopupMenugetAutoPopup(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TPopupMenu(pointer(controlobj)).AutoPopup));
end;
//fun TPopupMenusetOnPopup
function TPopupMenusetOnPopup(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TPopupMenu;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TPopupMenu(targetBut);
freeoldcalbac(oldcall);
controlobj.OnPopup:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TPopupMenusetOnClose
function TPopupMenusetOnClose(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TPopupMenu;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TPopupMenu(targetBut);
freeoldcalbac(oldcall);
controlobj.OnClose:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TButtonsetOnMouseEnter
function TButtonsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TButton;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TButton(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TButtonsetOnMouseLeave
function TButtonsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TButton;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TButton(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TButtonsetParentFont
function TButtonsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TButton(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TButtongetParentFont
function TButtongetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TButton(pointer(controlobj)).ParentFont));
end;
//fun TButtonsetParentShowHint
function TButtonsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TButton(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TButtongetParentShowHint
function TButtongetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TButton(pointer(controlobj)).ParentShowHint));
end;
//fun TLabelsetFocusControl
function TLabelsetFocusControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TLabel(pointer(controlobj)).FocusControl:=TWinControl(para0);
Result := PyInt_FromLong(0);
end;
//fun TLabelgetFocusControl
function TLabelgetFocusControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TLabel(pointer(controlobj)).FocusControl)));
end;
//fun TLabelsetParentColor
function TLabelsetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TLabel(pointer(controlobj)).ParentColor:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TLabelgetParentColor
function TLabelgetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TLabel(pointer(controlobj)).ParentColor));
end;
//fun TLabelsetParentFont
function TLabelsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TLabel(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TLabelgetParentFont
function TLabelgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TLabel(pointer(controlobj)).ParentFont));
end;
//fun TLabelsetParentShowHint
function TLabelsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TLabel(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TLabelgetParentShowHint
function TLabelgetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TLabel(pointer(controlobj)).ParentShowHint));
end;
//fun TLabelsetShowAccelChar
function TLabelsetShowAccelChar(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TLabel(pointer(controlobj)).ShowAccelChar:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TLabelgetShowAccelChar
function TLabelgetShowAccelChar(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TLabel(pointer(controlobj)).ShowAccelChar));
end;
//fun TLabelsetTransparent
function TLabelsetTransparent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TLabel(pointer(controlobj)).Transparent:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TLabelgetTransparent
function TLabelgetTransparent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TLabel(pointer(controlobj)).Transparent));
end;
//fun TLabelsetWordWrap
function TLabelsetWordWrap(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TLabel(pointer(controlobj)).WordWrap:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TLabelgetWordWrap
function TLabelgetWordWrap(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TLabel(pointer(controlobj)).WordWrap));
end;
//fun TLabelsetOnDblClick
function TLabelsetOnDblClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TLabel;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TLabel(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDblClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TLabelsetOnMouseEnter
function TLabelsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TLabel;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TLabel(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TLabelsetOnMouseLeave
function TLabelsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TLabel;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TLabel(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TEditsetAutoSelect
function TEditsetAutoSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TEdit(pointer(controlobj)).AutoSelect:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TEditgetAutoSelect
function TEditgetAutoSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TEdit(pointer(controlobj)).AutoSelect));
end;
//fun TEditsetOnDblClick
function TEditsetOnDblClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TEdit;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TEdit(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDblClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TEditsetOnMouseEnter
function TEditsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TEdit;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TEdit(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TEditsetOnMouseLeave
function TEditsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TEdit;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TEdit(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TEditsetParentColor
function TEditsetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TEdit(pointer(controlobj)).ParentColor:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TEditgetParentColor
function TEditgetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TEdit(pointer(controlobj)).ParentColor));
end;
//fun TEditsetParentFont
function TEditsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TEdit(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TEditgetParentFont
function TEditgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TEdit(pointer(controlobj)).ParentFont));
end;
//fun TEditsetParentShowHint
function TEditsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TEdit(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TEditgetParentShowHint
function TEditgetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TEdit(pointer(controlobj)).ParentShowHint));
end;
//fun TToggleBoxsetChecked
function TToggleBoxsetChecked(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TToggleBox(pointer(controlobj)).Checked:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TToggleBoxgetChecked
function TToggleBoxgetChecked(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TToggleBox(pointer(controlobj)).Checked));
end;
//fun TToggleBoxsetOnMouseEnter
function TToggleBoxsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TToggleBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TToggleBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TToggleBoxsetOnMouseLeave
function TToggleBoxsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TToggleBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TToggleBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TToggleBoxsetParentFont
function TToggleBoxsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TToggleBox(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TToggleBoxgetParentFont
function TToggleBoxgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TToggleBox(pointer(controlobj)).ParentFont));
end;
//fun TToggleBoxsetParentShowHint
function TToggleBoxsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TToggleBox(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TToggleBoxgetParentShowHint
function TToggleBoxgetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TToggleBox(pointer(controlobj)).ParentShowHint));
end;
//fun TCheckBoxsetChecked
function TCheckBoxsetChecked(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCheckBox(pointer(controlobj)).Checked:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCheckBoxgetChecked
function TCheckBoxgetChecked(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCheckBox(pointer(controlobj)).Checked));
end;
//fun TCheckBoxsetOnMouseEnter
function TCheckBoxsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCheckBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCheckBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCheckBoxsetOnMouseLeave
function TCheckBoxsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCheckBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCheckBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCheckBoxsetParentColor
function TCheckBoxsetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCheckBox(pointer(controlobj)).ParentColor:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCheckBoxgetParentColor
function TCheckBoxgetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCheckBox(pointer(controlobj)).ParentColor));
end;
//fun TCheckBoxsetParentFont
function TCheckBoxsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCheckBox(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCheckBoxgetParentFont
function TCheckBoxgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCheckBox(pointer(controlobj)).ParentFont));
end;
//fun TCheckBoxsetParentShowHint
function TCheckBoxsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCheckBox(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCheckBoxgetParentShowHint
function TCheckBoxgetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCheckBox(pointer(controlobj)).ParentShowHint));
end;
//fun TRadioButtonsetChecked
function TRadioButtonsetChecked(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TRadioButton(pointer(controlobj)).Checked:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TRadioButtongetChecked
function TRadioButtongetChecked(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TRadioButton(pointer(controlobj)).Checked));
end;
//fun TRadioButtonsetOnMouseEnter
function TRadioButtonsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TRadioButton;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TRadioButton(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TRadioButtonsetOnMouseLeave
function TRadioButtonsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TRadioButton;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TRadioButton(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TRadioButtonsetParentColor
function TRadioButtonsetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TRadioButton(pointer(controlobj)).ParentColor:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TRadioButtongetParentColor
function TRadioButtongetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TRadioButton(pointer(controlobj)).ParentColor));
end;
//fun TRadioButtonsetParentFont
function TRadioButtonsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TRadioButton(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TRadioButtongetParentFont
function TRadioButtongetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TRadioButton(pointer(controlobj)).ParentFont));
end;
//fun TRadioButtonsetParentShowHint
function TRadioButtonsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TRadioButton(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TRadioButtongetParentShowHint
function TRadioButtongetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TRadioButton(pointer(controlobj)).ParentShowHint));
end;
//fun TListBoxsetOnDblClick
function TListBoxsetOnDblClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TListBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TListBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDblClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TListBoxsetOnMouseEnter
function TListBoxsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TListBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TListBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TListBoxsetOnMouseLeave
function TListBoxsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TListBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TListBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TListBoxsetParentColor
function TListBoxsetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TListBox(pointer(controlobj)).ParentColor:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TListBoxgetParentColor
function TListBoxgetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TListBox(pointer(controlobj)).ParentColor));
end;
//fun TListBoxsetParentShowHint
function TListBoxsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TListBox(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TListBoxgetParentShowHint
function TListBoxgetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TListBox(pointer(controlobj)).ParentShowHint));
end;
//fun TListBoxsetParentFont
function TListBoxsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TListBox(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TListBoxgetParentFont
function TListBoxgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TListBox(pointer(controlobj)).ParentFont));
end;
//fun TComboBoxsetItemHeight
function TComboBoxsetItemHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TComboBox(pointer(controlobj)).ItemHeight:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TComboBoxgetItemHeight
function TComboBoxgetItemHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TComboBox(pointer(controlobj)).ItemHeight);
end;
//fun TComboBoxsetItemWidth
function TComboBoxsetItemWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TComboBox(pointer(controlobj)).ItemWidth:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TComboBoxgetItemWidth
function TComboBoxgetItemWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TComboBox(pointer(controlobj)).ItemWidth);
end;
//fun TComboBoxsetMaxLength
function TComboBoxsetMaxLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TComboBox(pointer(controlobj)).MaxLength:=integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TComboBoxgetMaxLength
function TComboBoxgetMaxLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TComboBox(pointer(controlobj)).MaxLength);
end;
//fun TComboBoxsetOnChange
function TComboBoxsetOnChange(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnChange:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetOnCloseUp
function TComboBoxsetOnCloseUp(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnCloseUp:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetOnDblClick
function TComboBoxsetOnDblClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDblClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetOnDropDown
function TComboBoxsetOnDropDown(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDropDown:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetOnGetItems
function TComboBoxsetOnGetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnGetItems:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetOnMouseEnter
function TComboBoxsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetOnMouseLeave
function TComboBoxsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetOnSelect
function TComboBoxsetOnSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TComboBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TComboBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnSelect:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TComboBoxsetParentColor
function TComboBoxsetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TComboBox(pointer(controlobj)).ParentColor:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TComboBoxgetParentColor
function TComboBoxgetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TComboBox(pointer(controlobj)).ParentColor));
end;
//fun TComboBoxsetParentFont
function TComboBoxsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TComboBox(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TComboBoxgetParentFont
function TComboBoxgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TComboBox(pointer(controlobj)).ParentFont));
end;
//fun TComboBoxsetParentShowHint
function TComboBoxsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TComboBox(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TComboBoxgetParentShowHint
function TComboBoxgetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TComboBox(pointer(controlobj)).ParentShowHint));
end;
//fun TScrollBarsetParentShowHint
function TScrollBarsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TScrollBar(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TScrollBargetParentShowHint
function TScrollBargetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TScrollBar(pointer(controlobj)).ParentShowHint));
end;
//fun TMemosetOnDblClick
function TMemosetOnDblClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TMemo;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TMemo(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDblClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TMemosetOnMouseEnter
function TMemosetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TMemo;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TMemo(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TMemosetOnMouseLeave
function TMemosetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TMemo;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TMemo(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TMemosetParentColor
function TMemosetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMemo(pointer(controlobj)).ParentColor:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMemogetParentColor
function TMemogetParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMemo(pointer(controlobj)).ParentColor));
end;
//fun TMemosetParentFont
function TMemosetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMemo(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMemogetParentFont
function TMemogetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMemo(pointer(controlobj)).ParentFont));
end;
//fun TMemosetParentShowHint
function TMemosetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMemo(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMemogetParentShowHint
function TMemogetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMemo(pointer(controlobj)).ParentShowHint));
end;
//fun TStringsAdd
function TStringsAdd(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
S:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@S);
TStrings(pointer(controlobj)).Add(string(S));
Result := PyInt_FromLong(0);
end;
//fun TStringsAddObject
function TStringsAddObject(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AObject:Integer;
S:PChar;
begin
PyArg_ParseTuple(Args, 'isi',@controlobj,@S,@AObject);
TStrings(pointer(controlobj)).AddObject(string(S),TObject(AObject));
Result := PyInt_FromLong(0);
end;
//fun TStringsAppend
function TStringsAppend(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
S:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@S);
TStrings(pointer(controlobj)).Append(string(S));
Result := PyInt_FromLong(0);
end;
//fun TStringsAddStrings
function TStringsAddStrings(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
TheStrings:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@TheStrings);
TStrings(pointer(controlobj)).AddStrings(TStrings(TheStrings));
Result := PyInt_FromLong(0);
end;
//fun TStringsBeginUpdate
function TStringsBeginUpdate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TStrings(pointer(controlobj)).BeginUpdate;
Result := PyInt_FromLong(0);
end;
//fun TStringsClear
function TStringsClear(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TStrings(pointer(controlobj)).Clear;
Result := PyInt_FromLong(0);
end;
//fun TStringsDelete
function TStringsDelete(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Index);
TStrings(pointer(controlobj)).Delete(Integer(Index));
Result := PyInt_FromLong(0);
end;
//fun TStringsEndUpdate
function TStringsEndUpdate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TStrings(pointer(controlobj)).EndUpdate;
Result := PyInt_FromLong(0);
end;
//fun TStringsEquals
function TStringsEquals(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Obj:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Obj);
TStrings(pointer(controlobj)).Equals(TObject(Obj));
Result := PyInt_FromLong(0);
end;
//fun TStringsExchange
function TStringsExchange(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Index2:Integer;
Index1:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@Index1,@Index2);
TStrings(pointer(controlobj)).Exchange(Integer(Index1),Integer(Index2));
Result := PyInt_FromLong(0);
end;
//fun TStringsIndexOf
function TStringsIndexOf(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
S:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@S);
TStrings(pointer(controlobj)).IndexOf(string(S));
Result := PyInt_FromLong(0);
end;
//fun TStringsIndexOfName
function TStringsIndexOfName(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Name:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@Name);
TStrings(pointer(controlobj)).IndexOfName(string(Name));
Result := PyInt_FromLong(0);
end;
//fun TStringsIndexOfObject
function TStringsIndexOfObject(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AObject:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AObject);
TStrings(pointer(controlobj)).IndexOfObject(TObject(AObject));
Result := PyInt_FromLong(0);
end;
//fun TStringsInsert
function TStringsInsert(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
S:PChar;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'iis',@controlobj,@Index,@S);
TStrings(pointer(controlobj)).Insert(Integer(Index),string(S));
Result := PyInt_FromLong(0);
end;
//fun TStringsLoadFromFile
function TStringsLoadFromFile(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
FileName:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@FileName);
TStrings(pointer(controlobj)).LoadFromFile(string(FileName));
Result := PyInt_FromLong(0);
end;
//fun TStringsMove
function TStringsMove(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
NewIndex:Integer;
CurIndex:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@CurIndex,@NewIndex);
TStrings(pointer(controlobj)).Move(Integer(CurIndex),Integer(NewIndex));
Result := PyInt_FromLong(0);
end;
//fun TStringsSaveToFile
function TStringsSaveToFile(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
FileName:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@FileName);
TStrings(pointer(controlobj)).SaveToFile(string(FileName));
Result := PyInt_FromLong(0);
end;
//fun TStringsGetNameValue
{function TStringsGetNameValue(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AValue:PChar;
AName:PChar;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'iiss',@controlobj,@Index,@AName,@AValue);
TStrings(pointer(controlobj)).GetNameValue(Integer(Index),String(AName),String(AValue));
Result := PyInt_FromLong(0);
end;    }
//fun TStringssetValueFromIndex
function TStringssetValueFromIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'isi',@controlobj,@para0,@indexedpara0);
TStrings(pointer(controlobj)).ValueFromIndex[indexedpara0]:=string(para0);
Result := PyInt_FromLong(0);
end;
//fun TStringsgetValueFromIndex
function TStringsgetValueFromIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyString_FromString(PChar(TStrings(pointer(controlobj)).ValueFromIndex[indexedpara0]));
end;
//fun TStringssetCapacity
function TStringssetCapacity(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TStrings(pointer(controlobj)).Capacity:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TStringsgetCapacity
function TStringsgetCapacity(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TStrings(pointer(controlobj)).Capacity);
end;
//fun TStringssetCommaText
function TStringssetCommaText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TStrings(pointer(controlobj)).CommaText:=string(para0);
Result := PyInt_FromLong(0);
end;
//fun TStringsgetCommaText
function TStringsgetCommaText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TStrings(pointer(controlobj)).CommaText));
end;
//fun TStringsgetCount
function TStringsgetCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TStrings(pointer(controlobj)).Count);
end;
//fun TStringsgetNames
function TStringsgetNames(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyString_FromString(PChar(TStrings(pointer(controlobj)).Names[indexedpara0]));
end;
//fun TStringssetObjects
function TStringssetObjects(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@para0,@indexedpara0);
TStrings(pointer(controlobj)).Objects[indexedpara0]:=TObject(para0);
Result := PyInt_FromLong(0);
end;
//fun TStringsgetObjects
function TStringsgetObjects(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyInt_FromLong(Integer(pointer(TStrings(pointer(controlobj)).Objects[indexedpara0])));
end;
//fun TStringssetValues
//function TStringssetValues(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//indexedpara0:Integer;
//para0:PChar;
//begin
//PyArg_ParseTuple(Args, 'isi',@controlobj,@para0,@indexedpara0);
//TStrings(pointer(controlobj)).Values[indexedpara0]:=string(para0);
//Result := PyInt_FromLong(0);
//end;
//fun TStringsgetValues
//function TStringsgetValues(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//indexedpara0:Integer;
//begin
//PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
//result:=PyString_FromString(PChar(TStrings(pointer(controlobj)).Values[indexedpara0]));
//end;
//fun TStringssetStrings
function TStringssetStrings(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'isi',@controlobj,@para0,@indexedpara0);
TStrings(pointer(controlobj)).Strings[indexedpara0]:=string(para0);
Result := PyInt_FromLong(0);
end;
//fun TStringsgetStrings
function TStringsgetStrings(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyString_FromString(PChar(TStrings(pointer(controlobj)).Strings[indexedpara0]));
end;
//fun TStringssetText
function TStringssetText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TStrings(pointer(controlobj)).Text:=string(para0);
Result := PyInt_FromLong(0);
end;
//fun TStringsgetText
function TStringsgetText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TStrings(pointer(controlobj)).Text));
end;
//fun TCustomFormAfterConstruction
function TCustomFormAfterConstruction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).AfterConstruction;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormBeforeDestruction
function TCustomFormBeforeDestruction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).BeforeDestruction;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormClose
function TCustomFormClose(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).Close;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormCloseQuery
function TCustomFormCloseQuery(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).CloseQuery;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormDefocusControl
function TCustomFormDefocusControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Removing:Integer;
Control:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@Control,@Removing);
TCustomForm(pointer(controlobj)).DefocusControl(TWinControl(Control),Boolean(Removing));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormDestroyWnd
function TCustomFormDestroyWnd(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).DestroyWnd;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormEnsureVisible
function TCustomFormEnsureVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AMoveToTop:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AMoveToTop);
TCustomForm(pointer(controlobj)).EnsureVisible(Boolean(AMoveToTop));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormFocusControl
function TCustomFormFocusControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
WinControl:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@WinControl);
TCustomForm(pointer(controlobj)).FocusControl(TWinControl(WinControl));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormFormIsUpdating
function TCustomFormFormIsUpdating(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).FormIsUpdating;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormHide
function TCustomFormHide(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).Hide;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormIntfHelp
function TCustomFormIntfHelp(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AComponent:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AComponent);
TCustomForm(pointer(controlobj)).IntfHelp(TComponent(AComponent));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormAutoSizeDelayedHandle
function TCustomFormAutoSizeDelayedHandle(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).AutoSizeDelayedHandle;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormRelease
function TCustomFormRelease(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).Release;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormCanFocus
function TCustomFormCanFocus(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).CanFocus;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormSetFocus
function TCustomFormSetFocus(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).SetFocus;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormSetFocusedControl
function TCustomFormSetFocusedControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Control:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Control);
TCustomForm(pointer(controlobj)).SetFocusedControl(TWinControl(Control));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormSetRestoredBounds
function TCustomFormSetRestoredBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AHeight:Integer;
AWidth:Integer;
ATop:Integer;
ALeft:Integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@controlobj,@ALeft,@ATop,@AWidth,@AHeight);
TCustomForm(pointer(controlobj)).SetRestoredBounds(integer(ALeft),integer(ATop),integer(AWidth),integer(AHeight));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormShow
function TCustomFormShow(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).Show;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormShowModal
function TCustomFormShowModal(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).ShowModal;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormShowOnTop
function TCustomFormShowOnTop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).ShowOnTop;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormRemoveAllHandlersOfObject
function TCustomFormRemoveAllHandlersOfObject(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AnObject:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AnObject);
TCustomForm(pointer(controlobj)).RemoveAllHandlersOfObject(TObject(AnObject));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormActiveMDIChild
function TCustomFormActiveMDIChild(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).ActiveMDIChild;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormGetMDIChildren
function TCustomFormGetMDIChildren(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AIndex:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AIndex);
TCustomForm(pointer(controlobj)).GetMDIChildren(Integer(AIndex));
Result := PyInt_FromLong(0);
end;
//fun TCustomFormMDIChildCount
function TCustomFormMDIChildCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomForm(pointer(controlobj)).MDIChildCount;
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetActive
function TCustomFormgetActive(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomForm(pointer(controlobj)).Active));
end;
//fun TCustomFormsetActiveControl
function TCustomFormsetActiveControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).ActiveControl:=TWinControl(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetActiveControl
function TCustomFormgetActiveControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomForm(pointer(controlobj)).ActiveControl)));
end;
//fun TCustomFormsetActiveDefaultControl
function TCustomFormsetActiveDefaultControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).ActiveDefaultControl:=TControl(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetActiveDefaultControl
function TCustomFormgetActiveDefaultControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomForm(pointer(controlobj)).ActiveDefaultControl)));
end;
//fun TCustomFormsetAllowDropFiles
function TCustomFormsetAllowDropFiles(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).AllowDropFiles:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetAllowDropFiles
function TCustomFormgetAllowDropFiles(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomForm(pointer(controlobj)).AllowDropFiles));
end;
//fun TCustomFormsetAlphaBlend
function TCustomFormsetAlphaBlend(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).AlphaBlend:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetAlphaBlend
function TCustomFormgetAlphaBlend(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomForm(pointer(controlobj)).AlphaBlend));
end;
//fun TCustomFormsetCancelControl
function TCustomFormsetCancelControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).CancelControl:=TControl(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetCancelControl
function TCustomFormgetCancelControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomForm(pointer(controlobj)).CancelControl)));
end;
//fun TCustomFormsetDefaultControl
function TCustomFormsetDefaultControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).DefaultControl:=TControl(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetDefaultControl
function TCustomFormgetDefaultControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomForm(pointer(controlobj)).DefaultControl)));
end;
//fun TCustomFormsetDesignTimeDPI
function TCustomFormsetDesignTimeDPI(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).DesignTimeDPI:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetDesignTimeDPI
function TCustomFormgetDesignTimeDPI(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomForm(pointer(controlobj)).DesignTimeDPI);
end;
//fun TCustomFormsetHelpFile
function TCustomFormsetHelpFile(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TCustomForm(pointer(controlobj)).HelpFile:=string(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetHelpFile
function TCustomFormgetHelpFile(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TCustomForm(pointer(controlobj)).HelpFile));
end;
//fun TCustomFormsetKeyPreview
function TCustomFormsetKeyPreview(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).KeyPreview:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetKeyPreview
function TCustomFormgetKeyPreview(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomForm(pointer(controlobj)).KeyPreview));
end;
//fun TCustomFormsetMenu
function TCustomFormsetMenu(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).Menu:=TMainMenu(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetMenu
function TCustomFormgetMenu(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomForm(pointer(controlobj)).Menu)));
end;
//fun TCustomFormsetPopupParent
function TCustomFormsetPopupParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomForm(pointer(controlobj)).PopupParent:=TCustomForm(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomFormgetPopupParent
function TCustomFormgetPopupParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomForm(pointer(controlobj)).PopupParent)));
end;
//fun TCustomFormsetOnActivate
function TCustomFormsetOnActivate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnActivate:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomFormsetOnCreate
function TCustomFormsetOnCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnCreate:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomFormsetOnDeactivate
function TCustomFormsetOnDeactivate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDeactivate:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomFormsetOnDestroy
function TCustomFormsetOnDestroy(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDestroy:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomFormsetOnHide
function TCustomFormsetOnHide(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnHide:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomFormsetOnShow
function TCustomFormsetOnShow(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomForm;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomForm(targetBut);
freeoldcalbac(oldcall);
controlobj.OnShow:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomFormgetRestoredLeft
function TCustomFormgetRestoredLeft(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomForm(pointer(controlobj)).RestoredLeft);
end;
//fun TCustomFormgetRestoredTop
function TCustomFormgetRestoredTop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomForm(pointer(controlobj)).RestoredTop);
end;
//fun TCustomFormgetRestoredWidth
function TCustomFormgetRestoredWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomForm(pointer(controlobj)).RestoredWidth);
end;
//fun TCustomFormgetRestoredHeight
function TCustomFormgetRestoredHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomForm(pointer(controlobj)).RestoredHeight);
end;
//fun TMenuDestroyHandle
function TMenuDestroyHandle(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenu(pointer(controlobj)).DestroyHandle;
Result := PyInt_FromLong(0);
end;
//fun TMenuHandleAllocated
function TMenuHandleAllocated(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenu(pointer(controlobj)).HandleAllocated;
Result := PyInt_FromLong(0);
end;
//fun TMenuIsRightToLeft
function TMenuIsRightToLeft(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenu(pointer(controlobj)).IsRightToLeft;
Result := PyInt_FromLong(0);
end;
//fun TMenuUseRightToLeftAlignment
function TMenuUseRightToLeftAlignment(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenu(pointer(controlobj)).UseRightToLeftAlignment;
Result := PyInt_FromLong(0);
end;
//fun TMenuUseRightToLeftReading
function TMenuUseRightToLeftReading(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenu(pointer(controlobj)).UseRightToLeftReading;
Result := PyInt_FromLong(0);
end;
//fun TMenuHandleNeeded
function TMenuHandleNeeded(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TMenu(pointer(controlobj)).HandleNeeded;
Result := PyInt_FromLong(0);
end;
//fun TMenusetParent
function TMenusetParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMenu(pointer(controlobj)).Parent:=TComponent(para0);
Result := PyInt_FromLong(0);
end;
//fun TMenugetParent
function TMenugetParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TMenu(pointer(controlobj)).Parent)));
end;
//fun TMenusetParentBidiMode
function TMenusetParentBidiMode(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TMenu(pointer(controlobj)).ParentBidiMode:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TMenugetParentBidiMode
function TMenugetParentBidiMode(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TMenu(pointer(controlobj)).ParentBidiMode));
end;
//fun TMenugetItems
function TMenugetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TMenu(pointer(controlobj)).Items)));
end;
//fun TLCLComponentRemoveAllHandlersOfObject
//function TLCLComponentRemoveAllHandlersOfObject(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//AnObject:Integer;
//begin
//PyArg_ParseTuple(Args, 'ii',@controlobj,@AnObject);
//TLCLComponent(pointer(controlobj)).RemoveAllHandlersOfObject(TObject(AnObject));
//Result := PyInt_FromLong(0);
//end;
//fun TLCLComponentIncLCLRefCount
//function TLCLComponentIncLCLRefCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//begin
//PyArg_ParseTuple(Args, 'i',@controlobj);
//TLCLComponent(pointer(controlobj)).IncLCLRefCount;
//Result := PyInt_FromLong(0);
//end;
////fun TLCLComponentDecLCLRefCount
//function TLCLComponentDecLCLRefCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//begin
//PyArg_ParseTuple(Args, 'i',@controlobj);
//TLCLComponent(pointer(controlobj)).DecLCLRefCount;
//Result := PyInt_FromLong(0);
//end;
////fun TLCLComponentgetLCLRefCount
//function TLCLComponentgetLCLRefCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//begin
//PyArg_ParseTuple(Args, 'i',@controlobj);
//result:=PyInt_FromLong(TLCLComponent(pointer(controlobj)).LCLRefCount);
//end;
//fun TCustomButtonCreate
function TCustomButtonCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
TheOwner:Integer;
begin
PyArg_ParseTuple(Args, 'i',@TheOwner);
result:=PyInt_FromLong(Integer(pointer(TCustomButton.Create(TComponent(TheOwner)))));
end;
//fun TCustomButtonClick
function TCustomButtonClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomButton(pointer(controlobj)).Click;
Result := PyInt_FromLong(0);
end;
//fun TCustomButtonExecuteDefaultAction
function TCustomButtonExecuteDefaultAction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomButton(pointer(controlobj)).ExecuteDefaultAction;
Result := PyInt_FromLong(0);
end;
//fun TCustomButtonExecuteCancelAction
function TCustomButtonExecuteCancelAction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomButton(pointer(controlobj)).ExecuteCancelAction;
Result := PyInt_FromLong(0);
end;
//fun TCustomButtonActiveDefaultControlChanged
function TCustomButtonActiveDefaultControlChanged(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
NewControl:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@NewControl);
TCustomButton(pointer(controlobj)).ActiveDefaultControlChanged(TControl(NewControl));
Result := PyInt_FromLong(0);
end;
//fun TCustomButtonUpdateRolesForForm
function TCustomButtonUpdateRolesForForm(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomButton(pointer(controlobj)).UpdateRolesForForm;
Result := PyInt_FromLong(0);
end;
//fun TCustomButtongetActive
function TCustomButtongetActive(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomButton(pointer(controlobj)).Active));
end;
//fun TCustomButtonsetDefault
function TCustomButtonsetDefault(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomButton(pointer(controlobj)).Default:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomButtongetDefault
function TCustomButtongetDefault(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomButton(pointer(controlobj)).Default));
end;
//fun TCustomButtonsetCancel
function TCustomButtonsetCancel(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomButton(pointer(controlobj)).Cancel:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomButtongetCancel
function TCustomButtongetCancel(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomButton(pointer(controlobj)).Cancel));
end;
//fun TCustomLabelCreate
function TCustomLabelCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
TheOwner:Integer;
begin
PyArg_ParseTuple(Args, 'i',@TheOwner);
result:=PyInt_FromLong(Integer(pointer(TCustomLabel.Create(TComponent(TheOwner)))));
end;
//fun TCustomLabelColorIsStored
function TCustomLabelColorIsStored(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomLabel(pointer(controlobj)).ColorIsStored;
Result := PyInt_FromLong(0);
end;
//fun TCustomLabelAdjustFontForOptimalFill
function TCustomLabelAdjustFontForOptimalFill(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomLabel(pointer(controlobj)).AdjustFontForOptimalFill;
Result := PyInt_FromLong(0);
end;
//fun TCustomLabelPaint
function TCustomLabelPaint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomLabel(pointer(controlobj)).Paint;
Result := PyInt_FromLong(0);
end;
//fun TCustomLabelSetBounds
function TCustomLabelSetBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
aHeight:Integer;
aWidth:Integer;
aTop:Integer;
aLeft:Integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@controlobj,@aLeft,@aTop,@aWidth,@aHeight);
TCustomLabel(pointer(controlobj)).SetBounds(integer(aLeft),integer(aTop),integer(aWidth),integer(aHeight));
Result := PyInt_FromLong(0);
end;
//fun TCustomEditCreate
function TCustomEditCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
AOwner:Integer;
begin
PyArg_ParseTuple(Args, 'i',@AOwner);
result:=PyInt_FromLong(Integer(pointer(TCustomEdit.Create(TComponent(AOwner)))));
end;
//fun TCustomEditClear
function TCustomEditClear(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomEdit(pointer(controlobj)).Clear;
Result := PyInt_FromLong(0);
end;
//fun TCustomEditSelectAll
function TCustomEditSelectAll(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomEdit(pointer(controlobj)).SelectAll;
Result := PyInt_FromLong(0);
end;
//fun TCustomEditClearSelection
function TCustomEditClearSelection(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomEdit(pointer(controlobj)).ClearSelection;
Result := PyInt_FromLong(0);
end;
//fun TCustomEditCopyToClipboard
function TCustomEditCopyToClipboard(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomEdit(pointer(controlobj)).CopyToClipboard;
Result := PyInt_FromLong(0);
end;
//fun TCustomEditCutToClipboard
function TCustomEditCutToClipboard(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomEdit(pointer(controlobj)).CutToClipboard;
Result := PyInt_FromLong(0);
end;
//fun TCustomEditPasteFromClipboard
function TCustomEditPasteFromClipboard(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomEdit(pointer(controlobj)).PasteFromClipboard;
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetCanUndo
function TCustomEditgetCanUndo(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomEdit(pointer(controlobj)).CanUndo));
end;
//fun TCustomEditsetHideSelection
function TCustomEditsetHideSelection(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).HideSelection:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetHideSelection
function TCustomEditgetHideSelection(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomEdit(pointer(controlobj)).HideSelection));
end;
//fun TCustomEditsetMaxLength
function TCustomEditsetMaxLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).MaxLength:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetMaxLength
function TCustomEditgetMaxLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomEdit(pointer(controlobj)).MaxLength);
end;
//fun TCustomEditsetModified
function TCustomEditsetModified(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).Modified:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetModified
function TCustomEditgetModified(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomEdit(pointer(controlobj)).Modified));
end;
//fun TCustomEditsetNumbersOnly
function TCustomEditsetNumbersOnly(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).NumbersOnly:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetNumbersOnly
function TCustomEditgetNumbersOnly(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomEdit(pointer(controlobj)).NumbersOnly));
end;
//fun TCustomEditsetOnChange
function TCustomEditsetOnChange(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomEdit;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomEdit(targetBut);
freeoldcalbac(oldcall);
controlobj.OnChange:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomEditsetReadOnly
function TCustomEditsetReadOnly(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).ReadOnly:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetReadOnly
function TCustomEditgetReadOnly(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomEdit(pointer(controlobj)).ReadOnly));
end;
//fun TCustomEditsetSelLength
function TCustomEditsetSelLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).SelLength:=integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetSelLength
function TCustomEditgetSelLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomEdit(pointer(controlobj)).SelLength);
end;
//fun TCustomEditsetSelStart
function TCustomEditsetSelStart(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).SelStart:=integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetSelStart
function TCustomEditgetSelStart(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomEdit(pointer(controlobj)).SelStart);
end;
//fun TCustomEditsetSelText
function TCustomEditsetSelText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TCustomEdit(pointer(controlobj)).SelText:=String(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomEditgetSelText
function TCustomEditgetSelText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TCustomEdit(pointer(controlobj)).SelText));
end;
//fun TCustomCheckBoxsetAllowGrayed
function TCustomCheckBoxsetAllowGrayed(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomCheckBox(pointer(controlobj)).AllowGrayed:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomCheckBoxgetAllowGrayed
function TCustomCheckBoxgetAllowGrayed(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomCheckBox(pointer(controlobj)).AllowGrayed));
end;
//fun TCustomListBoxAddItem
function TCustomListBoxAddItem(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AnObject:Integer;
Item:PChar;
begin
PyArg_ParseTuple(Args, 'isi',@controlobj,@Item,@AnObject);
TCustomListBox(pointer(controlobj)).AddItem(String(Item),TObject(AnObject));
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxClick
function TCustomListBoxClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomListBox(pointer(controlobj)).Click;
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxClear
function TCustomListBoxClear(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomListBox(pointer(controlobj)).Clear;
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxClearSelection
function TCustomListBoxClearSelection(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomListBox(pointer(controlobj)).ClearSelection;
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxGetIndexAtXY
function TCustomListBoxGetIndexAtXY(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Y:Integer;
X:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@X,@Y);
TCustomListBox(pointer(controlobj)).GetIndexAtXY(integer(X),integer(Y));
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxGetIndexAtY
function TCustomListBoxGetIndexAtY(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Y:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Y);
TCustomListBox(pointer(controlobj)).GetIndexAtY(integer(Y));
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxGetSelectedText
function TCustomListBoxGetSelectedText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomListBox(pointer(controlobj)).GetSelectedText;
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxItemVisible
function TCustomListBoxItemVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Index);
TCustomListBox(pointer(controlobj)).ItemVisible(Integer(Index));
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxItemFullyVisible
function TCustomListBoxItemFullyVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Index);
TCustomListBox(pointer(controlobj)).ItemFullyVisible(Integer(Index));
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxLockSelectionChange
function TCustomListBoxLockSelectionChange(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomListBox(pointer(controlobj)).LockSelectionChange;
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxMakeCurrentVisible
function TCustomListBoxMakeCurrentVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomListBox(pointer(controlobj)).MakeCurrentVisible;
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxMeasureItem
function TCustomListBoxMeasureItem(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
TheHeight:Integer;
Index:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@Index,@TheHeight);
TCustomListBox(pointer(controlobj)).MeasureItem(Integer(Index),Integer(TheHeight));
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxSelectAll
function TCustomListBoxSelectAll(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomListBox(pointer(controlobj)).SelectAll;
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxsetColumns
function TCustomListBoxsetColumns(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).Columns:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetColumns
function TCustomListBoxgetColumns(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomListBox(pointer(controlobj)).Columns);
end;
//fun TCustomListBoxgetCount
function TCustomListBoxgetCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomListBox(pointer(controlobj)).Count);
end;
//fun TCustomListBoxsetExtendedSelect
function TCustomListBoxsetExtendedSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).ExtendedSelect:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetExtendedSelect
function TCustomListBoxgetExtendedSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomListBox(pointer(controlobj)).ExtendedSelect));
end;
//fun TCustomListBoxsetIntegralHeight
function TCustomListBoxsetIntegralHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).IntegralHeight:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetIntegralHeight
function TCustomListBoxgetIntegralHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomListBox(pointer(controlobj)).IntegralHeight));
end;
//fun TCustomListBoxsetItemHeight
function TCustomListBoxsetItemHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).ItemHeight:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetItemHeight
function TCustomListBoxgetItemHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomListBox(pointer(controlobj)).ItemHeight);
end;
//fun TCustomListBoxsetItemIndex
function TCustomListBoxsetItemIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).ItemIndex:=integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetItemIndex
function TCustomListBoxgetItemIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomListBox(pointer(controlobj)).ItemIndex);
end;
//fun TCustomListBoxsetItems
function TCustomListBoxsetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).Items:=TStrings(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetItems
function TCustomListBoxgetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomListBox(pointer(controlobj)).Items)));
end;
//fun TCustomListBoxsetMultiSelect
function TCustomListBoxsetMultiSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).MultiSelect:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetMultiSelect
function TCustomListBoxgetMultiSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomListBox(pointer(controlobj)).MultiSelect));
end;
//fun TCustomListBoxsetOnDblClick
function TCustomListBoxsetOnDblClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomListBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomListBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnDblClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomListBoxsetOnMouseEnter
function TCustomListBoxsetOnMouseEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomListBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomListBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomListBoxsetOnMouseLeave
function TCustomListBoxsetOnMouseLeave(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomListBox;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomListBox(targetBut);
freeoldcalbac(oldcall);
controlobj.OnMouseLeave:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomListBoxsetParentFont
function TCustomListBoxsetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).ParentFont:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetParentFont
function TCustomListBoxgetParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomListBox(pointer(controlobj)).ParentFont));
end;
//fun TCustomListBoxsetParentShowHint
function TCustomListBoxsetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).ParentShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetParentShowHint
function TCustomListBoxgetParentShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomListBox(pointer(controlobj)).ParentShowHint));
end;
//fun TCustomListBoxsetScrollWidth
function TCustomListBoxsetScrollWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).ScrollWidth:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetScrollWidth
function TCustomListBoxgetScrollWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomListBox(pointer(controlobj)).ScrollWidth);
end;
//fun TCustomListBoxgetSelCount
function TCustomListBoxgetSelCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomListBox(pointer(controlobj)).SelCount);
end;
//fun TCustomListBoxsetSelected
function TCustomListBoxsetSelected(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@para0,@indexedpara0);
TCustomListBox(pointer(controlobj)).Selected[indexedpara0]:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetSelected
function TCustomListBoxgetSelected(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyInt_FromLong(booltoint(TCustomListBox(pointer(controlobj)).Selected[indexedpara0]));
end;
//fun TCustomListBoxsetSorted
function TCustomListBoxsetSorted(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).Sorted:=boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetSorted
function TCustomListBoxgetSorted(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomListBox(pointer(controlobj)).Sorted));
end;
//fun TCustomListBoxsetTopIndex
function TCustomListBoxsetTopIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomListBox(pointer(controlobj)).TopIndex:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomListBoxgetTopIndex
function TCustomListBoxgetTopIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomListBox(pointer(controlobj)).TopIndex);
end;
//fun TCustomComboBoxIntfGetItems
function TCustomComboBoxIntfGetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomComboBox(pointer(controlobj)).IntfGetItems;
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxAddItem
function TCustomComboBoxAddItem(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AnObject:Integer;
Item:PChar;
begin
PyArg_ParseTuple(Args, 'isi',@controlobj,@Item,@AnObject);
TCustomComboBox(pointer(controlobj)).AddItem(String(Item),TObject(AnObject));
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxClear
function TCustomComboBoxClear(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomComboBox(pointer(controlobj)).Clear;
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxClearSelection
function TCustomComboBoxClearSelection(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomComboBox(pointer(controlobj)).ClearSelection;
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxsetDroppedDown
function TCustomComboBoxsetDroppedDown(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).DroppedDown:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetDroppedDown
function TCustomComboBoxgetDroppedDown(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomComboBox(pointer(controlobj)).DroppedDown));
end;
//fun TCustomComboBoxSelectAll
function TCustomComboBoxSelectAll(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TCustomComboBox(pointer(controlobj)).SelectAll;
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxsetAutoSelect
function TCustomComboBoxsetAutoSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).AutoSelect:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetAutoSelect
function TCustomComboBoxgetAutoSelect(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomComboBox(pointer(controlobj)).AutoSelect));
end;
//fun TCustomComboBoxsetAutoSelected
function TCustomComboBoxsetAutoSelected(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).AutoSelected:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetAutoSelected
function TCustomComboBoxgetAutoSelected(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomComboBox(pointer(controlobj)).AutoSelected));
end;
//fun TCustomComboBoxsetDropDownCount
function TCustomComboBoxsetDropDownCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).DropDownCount:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetDropDownCount
function TCustomComboBoxgetDropDownCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomComboBox(pointer(controlobj)).DropDownCount);
end;
//fun TCustomComboBoxsetItems
function TCustomComboBoxsetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).Items:=TStrings(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetItems
function TCustomComboBoxgetItems(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomComboBox(pointer(controlobj)).Items)));
end;
//fun TCustomComboBoxsetItemIndex
function TCustomComboBoxsetItemIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).ItemIndex:=integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetItemIndex
function TCustomComboBoxgetItemIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomComboBox(pointer(controlobj)).ItemIndex);
end;
//fun TCustomComboBoxsetReadOnly
function TCustomComboBoxsetReadOnly(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).ReadOnly:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetReadOnly
function TCustomComboBoxgetReadOnly(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomComboBox(pointer(controlobj)).ReadOnly));
end;
//fun TCustomComboBoxsetSelLength
function TCustomComboBoxsetSelLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).SelLength:=integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetSelLength
function TCustomComboBoxgetSelLength(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomComboBox(pointer(controlobj)).SelLength);
end;
//fun TCustomComboBoxsetSelStart
function TCustomComboBoxsetSelStart(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).SelStart:=integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetSelStart
function TCustomComboBoxgetSelStart(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomComboBox(pointer(controlobj)).SelStart);
end;
//fun TCustomComboBoxsetSelText
function TCustomComboBoxsetSelText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TCustomComboBox(pointer(controlobj)).SelText:=String(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomComboBoxgetSelText
function TCustomComboBoxgetSelText(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TCustomComboBox(pointer(controlobj)).SelText));
end;
//fun TCustomScrollBarCreate
function TCustomScrollBarCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
AOwner:Integer;
begin
PyArg_ParseTuple(Args, 'i',@AOwner);
result:=PyInt_FromLong(Integer(pointer(TCustomScrollBar.Create(TComponent(AOwner)))));
end;
//fun TCustomScrollBarSetParams
function TCustomScrollBarSetParams(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
APageSize:Integer;
AMax:Integer;
AMin:Integer;
APosition:Integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@controlobj,@APosition,@AMin,@AMax,@APageSize);
TCustomScrollBar(pointer(controlobj)).SetParams(Integer(APosition),Integer(AMin),Integer(AMax),Integer(APageSize));
Result := PyInt_FromLong(0);
end;
//fun TCustomScrollBarsetMax
function TCustomScrollBarsetMax(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomScrollBar(pointer(controlobj)).Max:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomScrollBargetMax
function TCustomScrollBargetMax(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomScrollBar(pointer(controlobj)).Max);
end;
//fun TCustomScrollBarsetMin
function TCustomScrollBarsetMin(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomScrollBar(pointer(controlobj)).Min:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomScrollBargetMin
function TCustomScrollBargetMin(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomScrollBar(pointer(controlobj)).Min);
end;
//fun TCustomScrollBarsetPageSize
function TCustomScrollBarsetPageSize(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomScrollBar(pointer(controlobj)).PageSize:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomScrollBargetPageSize
function TCustomScrollBargetPageSize(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomScrollBar(pointer(controlobj)).PageSize);
end;
//fun TCustomScrollBarsetPosition
function TCustomScrollBarsetPosition(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomScrollBar(pointer(controlobj)).Position:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomScrollBargetPosition
function TCustomScrollBargetPosition(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TCustomScrollBar(pointer(controlobj)).Position);
end;
//fun TCustomScrollBarsetOnChange
function TCustomScrollBarsetOnChange(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomScrollBar;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomScrollBar(targetBut);
freeoldcalbac(oldcall);
controlobj.OnChange:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TCustomMemosetLines
function TCustomMemosetLines(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomMemo(pointer(controlobj)).Lines:=TStrings(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomMemogetLines
function TCustomMemogetLines(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TCustomMemo(pointer(controlobj)).Lines)));
end;
//fun TCustomMemosetWantReturns
function TCustomMemosetWantReturns(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomMemo(pointer(controlobj)).WantReturns:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomMemogetWantReturns
function TCustomMemogetWantReturns(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomMemo(pointer(controlobj)).WantReturns));
end;
//fun TCustomMemosetWantTabs
function TCustomMemosetWantTabs(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomMemo(pointer(controlobj)).WantTabs:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomMemogetWantTabs
function TCustomMemogetWantTabs(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomMemo(pointer(controlobj)).WantTabs));
end;
//fun TCustomMemosetWordWrap
function TCustomMemosetWordWrap(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TCustomMemo(pointer(controlobj)).WordWrap:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TCustomMemogetWordWrap
function TCustomMemogetWordWrap(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TCustomMemo(pointer(controlobj)).WordWrap));
end;
//fun TScrollingWinControlUpdateScrollbars
function TScrollingWinControlUpdateScrollbars(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TScrollingWinControl(pointer(controlobj)).UpdateScrollbars;
Result := PyInt_FromLong(0);
end;
//fun TComponentBeforeDestruction
function TComponentBeforeDestruction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TComponent(pointer(controlobj)).BeforeDestruction;
Result := PyInt_FromLong(0);
end;
//fun TComponentDestroyComponents
function TComponentDestroyComponents(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TComponent(pointer(controlobj)).DestroyComponents;
Result := PyInt_FromLong(0);
end;
//fun TComponentDestroying
function TComponentDestroying(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TComponent(pointer(controlobj)).Destroying;
Result := PyInt_FromLong(0);
end;
//fun TComponentFindComponent
function TComponentFindComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AName:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@AName);
TComponent(pointer(controlobj)).FindComponent(string(AName));
Result := PyInt_FromLong(0);
end;
//fun TComponentFreeNotification
function TComponentFreeNotification(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AComponent:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AComponent);
TComponent(pointer(controlobj)).FreeNotification(TComponent(AComponent));
Result := PyInt_FromLong(0);
end;
//fun TComponentRemoveFreeNotification
function TComponentRemoveFreeNotification(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AComponent:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AComponent);
TComponent(pointer(controlobj)).RemoveFreeNotification(TComponent(AComponent));
Result := PyInt_FromLong(0);
end;
//fun TComponentFreeOnRelease
function TComponentFreeOnRelease(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TComponent(pointer(controlobj)).FreeOnRelease;
Result := PyInt_FromLong(0);
end;
//fun TComponentGetNamePath
function TComponentGetNamePath(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TComponent(pointer(controlobj)).GetNamePath;
Result := PyInt_FromLong(0);
end;
//fun TComponentGetParentComponent
function TComponentGetParentComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TComponent(pointer(controlobj)).GetParentComponent;
Result := PyInt_FromLong(0);
end;
//fun TComponentHasParent
function TComponentHasParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TComponent(pointer(controlobj)).HasParent;
Result := PyInt_FromLong(0);
end;
//fun TComponentInsertComponent
function TComponentInsertComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AComponent:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AComponent);
TComponent(pointer(controlobj)).InsertComponent(TComponent(AComponent));
Result := PyInt_FromLong(0);
end;
//fun TComponentRemoveComponent
function TComponentRemoveComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AComponent:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AComponent);
TComponent(pointer(controlobj)).RemoveComponent(TComponent(AComponent));
Result := PyInt_FromLong(0);
end;
//fun TComponentSetSubComponent
function TComponentSetSubComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
ASubComponent:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@ASubComponent);
TComponent(pointer(controlobj)).SetSubComponent(Boolean(ASubComponent));
Result := PyInt_FromLong(0);
end;
//fun TComponentgetComponents
function TComponentgetComponents(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyInt_FromLong(Integer(pointer(TComponent(pointer(controlobj)).Components[indexedpara0])));
end;
//fun TComponentgetComponentCount
function TComponentgetComponentCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TComponent(pointer(controlobj)).ComponentCount);
end;
//fun TComponentsetComponentIndex
function TComponentsetComponentIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TComponent(pointer(controlobj)).ComponentIndex:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TComponentgetComponentIndex
function TComponentgetComponentIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TComponent(pointer(controlobj)).ComponentIndex);
end;
//fun TComponentgetOwner
function TComponentgetOwner(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TComponent(pointer(controlobj)).Owner)));
end;
//fun TButtonControlCreate
function TButtonControlCreate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
TheOwner:Integer;
begin
PyArg_ParseTuple(Args, 'i',@TheOwner);
result:=PyInt_FromLong(Integer(pointer(TButtonControl.Create(TComponent(TheOwner)))));
end;
//fun TWinControlgetBoundsLockCount
function TWinControlgetBoundsLockCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TWinControl(pointer(controlobj)).BoundsLockCount);
end;
//fun TWinControlgetCachedClientHeight
function TWinControlgetCachedClientHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TWinControl(pointer(controlobj)).CachedClientHeight);
end;
//fun TWinControlgetCachedClientWidth
function TWinControlgetCachedClientWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TWinControl(pointer(controlobj)).CachedClientWidth);
end;
//fun TWinControlgetControlCount
function TWinControlgetControlCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TWinControl(pointer(controlobj)).ControlCount);
end;
//fun TWinControlgetControls
function TWinControlgetControls(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyInt_FromLong(Integer(pointer(TWinControl(pointer(controlobj)).Controls[indexedpara0])));
end;
//fun TWinControlgetDockClientCount
function TWinControlgetDockClientCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TWinControl(pointer(controlobj)).DockClientCount);
end;
//fun TWinControlgetDockClients
function TWinControlgetDockClients(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyInt_FromLong(Integer(pointer(TWinControl(pointer(controlobj)).DockClients[indexedpara0])));
end;
//fun TWinControlsetDockSite
function TWinControlsetDockSite(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TWinControl(pointer(controlobj)).DockSite:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TWinControlgetDockSite
function TWinControlgetDockSite(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TWinControl(pointer(controlobj)).DockSite));
end;
//fun TWinControlsetDoubleBuffered
function TWinControlsetDoubleBuffered(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TWinControl(pointer(controlobj)).DoubleBuffered:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TWinControlgetDoubleBuffered
function TWinControlgetDoubleBuffered(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TWinControl(pointer(controlobj)).DoubleBuffered));
end;
//fun TWinControlgetIsResizing
function TWinControlgetIsResizing(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TWinControl(pointer(controlobj)).IsResizing));
end;
//fun TWinControlsetTabStop
function TWinControlsetTabStop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TWinControl(pointer(controlobj)).TabStop:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TWinControlgetTabStop
function TWinControlgetTabStop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TWinControl(pointer(controlobj)).TabStop));
end;
//fun TWinControlsetOnEnter
function TWinControlsetOnEnter(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TWinControl;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TWinControl(targetBut);
freeoldcalbac(oldcall);
controlobj.OnEnter:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TWinControlsetOnExit
function TWinControlsetOnExit(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TWinControl;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TWinControl(targetBut);
freeoldcalbac(oldcall);
controlobj.OnExit:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TWinControlgetShowing
function TWinControlgetShowing(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TWinControl(pointer(controlobj)).Showing));
end;
//fun TWinControlsetDesignerDeleting
function TWinControlsetDesignerDeleting(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TWinControl(pointer(controlobj)).DesignerDeleting:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TWinControlgetDesignerDeleting
function TWinControlgetDesignerDeleting(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TWinControl(pointer(controlobj)).DesignerDeleting));
end;
//fun TWinControlAutoSizeDelayed
function TWinControlAutoSizeDelayed(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).AutoSizeDelayed;
Result := PyInt_FromLong(0);
end;
//fun TWinControlAutoSizeDelayedReport
function TWinControlAutoSizeDelayedReport(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).AutoSizeDelayedReport;
Result := PyInt_FromLong(0);
end;
//fun TWinControlAutoSizeDelayedHandle
function TWinControlAutoSizeDelayedHandle(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).AutoSizeDelayedHandle;
Result := PyInt_FromLong(0);
end;
//fun TWinControlBeginUpdateBounds
function TWinControlBeginUpdateBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).BeginUpdateBounds;
Result := PyInt_FromLong(0);
end;
//fun TWinControlEndUpdateBounds
function TWinControlEndUpdateBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).EndUpdateBounds;
Result := PyInt_FromLong(0);
end;
//fun TWinControlLockRealizeBounds
function TWinControlLockRealizeBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).LockRealizeBounds;
Result := PyInt_FromLong(0);
end;
//fun TWinControlUnlockRealizeBounds
function TWinControlUnlockRealizeBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).UnlockRealizeBounds;
Result := PyInt_FromLong(0);
end;
//fun TWinControlContainsControl
function TWinControlContainsControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Control:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Control);
TWinControl(pointer(controlobj)).ContainsControl(TControl(Control));
Result := PyInt_FromLong(0);
end;
//fun TWinControlDoAdjustClientRectChange
function TWinControlDoAdjustClientRectChange(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
InvalidateRect:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@InvalidateRect);
TWinControl(pointer(controlobj)).DoAdjustClientRectChange(Boolean(InvalidateRect));
Result := PyInt_FromLong(0);
end;
//fun TWinControlInvalidateClientRectCache
function TWinControlInvalidateClientRectCache(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
WithChildControls:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@WithChildControls);
TWinControl(pointer(controlobj)).InvalidateClientRectCache(boolean(WithChildControls));
Result := PyInt_FromLong(0);
end;
//fun TWinControlClientRectNeedsInterfaceUpdate
function TWinControlClientRectNeedsInterfaceUpdate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).ClientRectNeedsInterfaceUpdate;
Result := PyInt_FromLong(0);
end;
//fun TWinControlSetBounds
function TWinControlSetBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AHeight:Integer;
AWidth:Integer;
ATop:Integer;
ALeft:Integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@controlobj,@ALeft,@ATop,@AWidth,@AHeight);
TWinControl(pointer(controlobj)).SetBounds(integer(ALeft),integer(ATop),integer(AWidth),integer(AHeight));
Result := PyInt_FromLong(0);
end;
//fun TWinControlDisableAlign
function TWinControlDisableAlign(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).DisableAlign;
Result := PyInt_FromLong(0);
end;
//fun TWinControlEnableAlign
function TWinControlEnableAlign(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).EnableAlign;
Result := PyInt_FromLong(0);
end;
//fun TWinControlReAlign
function TWinControlReAlign(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).ReAlign;
Result := PyInt_FromLong(0);
end;
//fun TWinControlScrollBy
function TWinControlScrollBy(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
DeltaY:Integer;
DeltaX:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@DeltaX,@DeltaY);
TWinControl(pointer(controlobj)).ScrollBy(Integer(DeltaX),Integer(DeltaY));
Result := PyInt_FromLong(0);
end;
//fun TWinControlWriteLayoutDebugReport
function TWinControlWriteLayoutDebugReport(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Prefix:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@Prefix);
TWinControl(pointer(controlobj)).WriteLayoutDebugReport(string(Prefix));
Result := PyInt_FromLong(0);
end;
//fun TWinControlCanFocus
function TWinControlCanFocus(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).CanFocus;
Result := PyInt_FromLong(0);
end;
//fun TWinControlGetControlIndex
function TWinControlGetControlIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AControl:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AControl);
TWinControl(pointer(controlobj)).GetControlIndex(TControl(AControl));
Result := PyInt_FromLong(0);
end;
//fun TWinControlSetControlIndex
function TWinControlSetControlIndex(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
NewIndex:Integer;
AControl:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@AControl,@NewIndex);
TWinControl(pointer(controlobj)).SetControlIndex(TControl(AControl),integer(NewIndex));
Result := PyInt_FromLong(0);
end;
//fun TWinControlFocused
function TWinControlFocused(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).Focused;
Result := PyInt_FromLong(0);
end;
//fun TWinControlPerformTab
function TWinControlPerformTab(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
ForwardTab:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@ForwardTab);
TWinControl(pointer(controlobj)).PerformTab(boolean(ForwardTab));
Result := PyInt_FromLong(0);
end;
//fun TWinControlFindChildControl
function TWinControlFindChildControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
ControlName:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@ControlName);
TWinControl(pointer(controlobj)).FindChildControl(String(ControlName));
Result := PyInt_FromLong(0);
end;
//fun TWinControlBroadCast
//function TWinControlBroadCast(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//begin
//PyArg_ParseTuple(Args, 'i',@controlobj);
//TWinControl(pointer(controlobj)).BroadCast;
//Result := PyInt_FromLong(0);
//end;
////fun TWinControlDefaultHandler
//function TWinControlDefaultHandler(Self:PyObject;Args:PyObject):PyObject; cdecl;
//var
//controlobj:Integer;
//begin
//PyArg_ParseTuple(Args, 'i',@controlobj);
//TWinControl(pointer(controlobj)).DefaultHandler;
//Result := PyInt_FromLong(0);
//end;
//fun TWinControlGetTextLen
function TWinControlGetTextLen(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).GetTextLen;
Result := PyInt_FromLong(0);
end;
//fun TWinControlInvalidate
function TWinControlInvalidate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).Invalidate;
Result := PyInt_FromLong(0);
end;
//fun TWinControlAddControl
function TWinControlAddControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).AddControl;
Result := PyInt_FromLong(0);
end;
//fun TWinControlInsertControl
function TWinControlInsertControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AControl:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AControl);
TWinControl(pointer(controlobj)).InsertControl(TControl(AControl));
Result := PyInt_FromLong(0);
end;
//fun TWinControlRepaint
function TWinControlRepaint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).Repaint;
Result := PyInt_FromLong(0);
end;
//fun TWinControlUpdate
function TWinControlUpdate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).Update;
Result := PyInt_FromLong(0);
end;
//fun TWinControlSetFocus
function TWinControlSetFocus(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).SetFocus;
Result := PyInt_FromLong(0);
end;
//fun TWinControlFlipChildren
function TWinControlFlipChildren(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AllLevels:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AllLevels);
TWinControl(pointer(controlobj)).FlipChildren(Boolean(AllLevels));
Result := PyInt_FromLong(0);
end;
//fun TWinControlScaleBy
function TWinControlScaleBy(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Divider:Integer;
Multiplier:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@Multiplier,@Divider);
TWinControl(pointer(controlobj)).ScaleBy(Integer(Multiplier),Integer(Divider));
Result := PyInt_FromLong(0);
end;
//fun TWinControlGetDockCaption
function TWinControlGetDockCaption(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AControl:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AControl);
TWinControl(pointer(controlobj)).GetDockCaption(TControl(AControl));
Result := PyInt_FromLong(0);
end;
//fun TWinControlUpdateDockCaption
function TWinControlUpdateDockCaption(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Exclude:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Exclude);
TWinControl(pointer(controlobj)).UpdateDockCaption(TControl(Exclude));
Result := PyInt_FromLong(0);
end;
//fun TWinControlHandleAllocated
function TWinControlHandleAllocated(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).HandleAllocated;
Result := PyInt_FromLong(0);
end;
//fun TWinControlParentHandlesAllocated
function TWinControlParentHandlesAllocated(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).ParentHandlesAllocated;
Result := PyInt_FromLong(0);
end;
//fun TWinControlHandleNeeded
function TWinControlHandleNeeded(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).HandleNeeded;
Result := PyInt_FromLong(0);
end;
//fun TWinControlBrushCreated
function TWinControlBrushCreated(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).BrushCreated;
Result := PyInt_FromLong(0);
end;
//fun TWinControlIntfGetDropFilesTarget
function TWinControlIntfGetDropFilesTarget(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TWinControl(pointer(controlobj)).IntfGetDropFilesTarget;
Result := PyInt_FromLong(0);
end;
//fun TCustomControlsetOnPaint
function TCustomControlsetOnPaint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TCustomControl;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TCustomControl(targetBut);
freeoldcalbac(oldcall);
controlobj.OnPaint:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TControlDragDrop
function TControlDragDrop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Y:Integer;
X:Integer;
Source:Integer;
begin
PyArg_ParseTuple(Args, 'iiii',@controlobj,@Source,@X,@Y);
TControl(pointer(controlobj)).DragDrop(TObject(Source),Integer(X),Integer(Y));
Result := PyInt_FromLong(0);
end;
//fun TControlAdjustSize
function TControlAdjustSize(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).AdjustSize;
Result := PyInt_FromLong(0);
end;
//fun TControlAutoSizeDelayed
function TControlAutoSizeDelayed(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).AutoSizeDelayed;
Result := PyInt_FromLong(0);
end;
//fun TControlAutoSizeDelayedReport
function TControlAutoSizeDelayedReport(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).AutoSizeDelayedReport;
Result := PyInt_FromLong(0);
end;
//fun TControlAutoSizeDelayedHandle
function TControlAutoSizeDelayedHandle(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).AutoSizeDelayedHandle;
Result := PyInt_FromLong(0);
end;
//fun TControlAnchorHorizontalCenterTo
function TControlAnchorHorizontalCenterTo(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Sibling:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Sibling);
TControl(pointer(controlobj)).AnchorHorizontalCenterTo(TControl(Sibling));
Result := PyInt_FromLong(0);
end;
//fun TControlAnchorVerticalCenterTo
function TControlAnchorVerticalCenterTo(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Sibling:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Sibling);
TControl(pointer(controlobj)).AnchorVerticalCenterTo(TControl(Sibling));
Result := PyInt_FromLong(0);
end;
//fun TControlAnchorClient
function TControlAnchorClient(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Space:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Space);
TControl(pointer(controlobj)).AnchorClient(Integer(Space));
Result := PyInt_FromLong(0);
end;
//fun TControlAnchoredControlCount
function TControlAnchoredControlCount(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).AnchoredControlCount;
Result := PyInt_FromLong(0);
end;
//fun TControlgetAnchoredControls
function TControlgetAnchoredControls(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
indexedpara0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@indexedpara0);
result:=PyInt_FromLong(Integer(pointer(TControl(pointer(controlobj)).AnchoredControls[indexedpara0])));
end;
//fun TControlSetBounds
function TControlSetBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
aHeight:Integer;
aWidth:Integer;
aTop:Integer;
aLeft:Integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@controlobj,@aLeft,@aTop,@aWidth,@aHeight);
TControl(pointer(controlobj)).SetBounds(integer(aLeft),integer(aTop),integer(aWidth),integer(aHeight));
Result := PyInt_FromLong(0);
end;
//fun TControlSetInitialBounds
function TControlSetInitialBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
aHeight:Integer;
aWidth:Integer;
aTop:Integer;
aLeft:Integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@controlobj,@aLeft,@aTop,@aWidth,@aHeight);
TControl(pointer(controlobj)).SetInitialBounds(integer(aLeft),integer(aTop),integer(aWidth),integer(aHeight));
Result := PyInt_FromLong(0);
end;
//fun TControlGetDefaultWidth
function TControlGetDefaultWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).GetDefaultWidth;
Result := PyInt_FromLong(0);
end;
//fun TControlGetDefaultHeight
function TControlGetDefaultHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).GetDefaultHeight;
Result := PyInt_FromLong(0);
end;
//fun TControlCNPreferredSizeChanged
function TControlCNPreferredSizeChanged(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).CNPreferredSizeChanged;
Result := PyInt_FromLong(0);
end;
//fun TControlInvalidatePreferredSize
function TControlInvalidatePreferredSize(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).InvalidatePreferredSize;
Result := PyInt_FromLong(0);
end;
//fun TControlWriteLayoutDebugReport
function TControlWriteLayoutDebugReport(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Prefix:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@Prefix);
TControl(pointer(controlobj)).WriteLayoutDebugReport(string(Prefix));
Result := PyInt_FromLong(0);
end;
//fun TControlShouldAutoAdjustLeftAndTop
function TControlShouldAutoAdjustLeftAndTop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).ShouldAutoAdjustLeftAndTop;
Result := PyInt_FromLong(0);
end;
//fun TControlBeforeDestruction
function TControlBeforeDestruction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).BeforeDestruction;
Result := PyInt_FromLong(0);
end;
//fun TControlEditingDone
function TControlEditingDone(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).EditingDone;
Result := PyInt_FromLong(0);
end;
//fun TControlExecuteDefaultAction
function TControlExecuteDefaultAction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).ExecuteDefaultAction;
Result := PyInt_FromLong(0);
end;
//fun TControlExecuteCancelAction
function TControlExecuteCancelAction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).ExecuteCancelAction;
Result := PyInt_FromLong(0);
end;
//fun TControlBeginDrag
function TControlBeginDrag(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Threshold:Integer;
Immediate:Integer;
begin
PyArg_ParseTuple(Args, 'iii',@controlobj,@Immediate,@Threshold);
TControl(pointer(controlobj)).BeginDrag(Boolean(Immediate),Integer(Threshold));
Result := PyInt_FromLong(0);
end;
//fun TControlEndDrag
function TControlEndDrag(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
Drop:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@Drop);
TControl(pointer(controlobj)).EndDrag(Boolean(Drop));
Result := PyInt_FromLong(0);
end;
//fun TControlBringToFront
function TControlBringToFront(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).BringToFront;
Result := PyInt_FromLong(0);
end;
//fun TControlHasParent
function TControlHasParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).HasParent;
Result := PyInt_FromLong(0);
end;
//fun TControlGetParentComponent
function TControlGetParentComponent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).GetParentComponent;
Result := PyInt_FromLong(0);
end;
//fun TControlIsParentOf
function TControlIsParentOf(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AControl:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AControl);
TControl(pointer(controlobj)).IsParentOf(TControl(AControl));
Result := PyInt_FromLong(0);
end;
//fun TControlGetTopParent
function TControlGetTopParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).GetTopParent;
Result := PyInt_FromLong(0);
end;
//fun TControlIsVisible
function TControlIsVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).IsVisible;
Result := PyInt_FromLong(0);
end;
//fun TControlIsControlVisible
function TControlIsControlVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).IsControlVisible;
Result := PyInt_FromLong(0);
end;
//fun TControlIsEnabled
function TControlIsEnabled(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).IsEnabled;
Result := PyInt_FromLong(0);
end;
//fun TControlIsParentColor
function TControlIsParentColor(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).IsParentColor;
Result := PyInt_FromLong(0);
end;
//fun TControlIsParentFont
function TControlIsParentFont(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).IsParentFont;
Result := PyInt_FromLong(0);
end;
//fun TControlFormIsUpdating
function TControlFormIsUpdating(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).FormIsUpdating;
Result := PyInt_FromLong(0);
end;
//fun TControlIsProcessingPaintMsg
function TControlIsProcessingPaintMsg(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).IsProcessingPaintMsg;
Result := PyInt_FromLong(0);
end;
//fun TControlHide
function TControlHide(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).Hide;
Result := PyInt_FromLong(0);
end;
//fun TControlRefresh
function TControlRefresh(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).Refresh;
Result := PyInt_FromLong(0);
end;
//fun TControlRepaint
function TControlRepaint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).Repaint;
Result := PyInt_FromLong(0);
end;
//fun TControlInvalidate
function TControlInvalidate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).Invalidate;
Result := PyInt_FromLong(0);
end;
//fun TControlCheckNewParent
function TControlCheckNewParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AParent:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AParent);
TControl(pointer(controlobj)).CheckNewParent(TWinControl(AParent));
Result := PyInt_FromLong(0);
end;
//fun TControlSendToBack
function TControlSendToBack(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).SendToBack;
Result := PyInt_FromLong(0);
end;
//fun TControlUpdateRolesForForm
function TControlUpdateRolesForForm(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).UpdateRolesForForm;
Result := PyInt_FromLong(0);
end;
//fun TControlActiveDefaultControlChanged
function TControlActiveDefaultControlChanged(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
NewControl:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@NewControl);
TControl(pointer(controlobj)).ActiveDefaultControlChanged(TControl(NewControl));
Result := PyInt_FromLong(0);
end;
//fun TControlGetTextLen
function TControlGetTextLen(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).GetTextLen;
Result := PyInt_FromLong(0);
end;
//fun TControlShow
function TControlShow(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).Show;
Result := PyInt_FromLong(0);
end;
//fun TControlUpdate
function TControlUpdate(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).Update;
Result := PyInt_FromLong(0);
end;
//fun TControlHandleObjectShouldBeVisible
function TControlHandleObjectShouldBeVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).HandleObjectShouldBeVisible;
Result := PyInt_FromLong(0);
end;
//fun TControlParentDestroyingHandle
function TControlParentDestroyingHandle(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).ParentDestroyingHandle;
Result := PyInt_FromLong(0);
end;
//fun TControlParentHandlesAllocated
function TControlParentHandlesAllocated(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).ParentHandlesAllocated;
Result := PyInt_FromLong(0);
end;
//fun TControlInitiateAction
function TControlInitiateAction(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).InitiateAction;
Result := PyInt_FromLong(0);
end;
//fun TControlShowHelp
function TControlShowHelp(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).ShowHelp;
Result := PyInt_FromLong(0);
end;
//fun TControlRemoveAllHandlersOfObject
function TControlRemoveAllHandlersOfObject(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
AnObject:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@AnObject);
TControl(pointer(controlobj)).RemoveAllHandlersOfObject(TObject(AnObject));
Result := PyInt_FromLong(0);
end;
//fun TControlsetAccessibleDescription
function TControlsetAccessibleDescription(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TControl(pointer(controlobj)).AccessibleDescription:=String(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetAccessibleDescription
function TControlgetAccessibleDescription(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TControl(pointer(controlobj)).AccessibleDescription));
end;
//fun TControlsetAccessibleValue
function TControlsetAccessibleValue(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TControl(pointer(controlobj)).AccessibleValue:=String(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetAccessibleValue
function TControlgetAccessibleValue(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TControl(pointer(controlobj)).AccessibleValue));
end;
//fun TControlsetAutoSize
function TControlsetAutoSize(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).AutoSize:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetAutoSize
function TControlgetAutoSize(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TControl(pointer(controlobj)).AutoSize));
end;
//fun TControlsetCaption
function TControlsetCaption(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TControl(pointer(controlobj)).Caption:=String(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetCaption
function TControlgetCaption(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TControl(pointer(controlobj)).Caption));
end;
//fun TControlsetClientHeight
function TControlsetClientHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).ClientHeight:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetClientHeight
function TControlgetClientHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).ClientHeight);
end;
//fun TControlsetClientWidth
function TControlsetClientWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).ClientWidth:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetClientWidth
function TControlgetClientWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).ClientWidth);
end;
//fun TControlsetEnabled
function TControlsetEnabled(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).Enabled:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetEnabled
function TControlgetEnabled(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TControl(pointer(controlobj)).Enabled));
end;
//fun TControlsetIsControl
function TControlsetIsControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).IsControl:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetIsControl
function TControlgetIsControl(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TControl(pointer(controlobj)).IsControl));
end;
//fun TControlgetMouseEntered
function TControlgetMouseEntered(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TControl(pointer(controlobj)).MouseEntered));
end;
//fun TControlsetOnChangeBounds
function TControlsetOnChangeBounds(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TControl;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TControl(targetBut);
freeoldcalbac(oldcall);
controlobj.OnChangeBounds:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TControlsetOnClick
function TControlsetOnClick(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TControl;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TControl(targetBut);
freeoldcalbac(oldcall);
controlobj.OnClick:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TControlsetOnResize
function TControlsetOnResize(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:TControl;
targetBut:Integer;
oldcall:Integer;
temp:PyObject;
call:Tcallbac;
begin
if (PyArg_ParseTuple(args, 'Oii', @temp, @targetBut,@oldcall) > 0) then
begin
call := Tcallbac.Create;
Py_IncRef(temp);
call.pyfun := temp;
controlobj:=TControl(targetBut);
freeoldcalbac(oldcall);
controlobj.OnResize:=call.TNotifyEventcall;
Result := PyInt_FromLong(integer(pointer(call)));
end;
end;
//fun TControlsetParent
function TControlsetParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).Parent:=TWinControl(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetParent
function TControlgetParent(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TControl(pointer(controlobj)).Parent)));
end;
//fun TControlsetPopupMenu
function TControlsetPopupMenu(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).PopupMenu:=TPopupmenu(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetPopupMenu
function TControlgetPopupMenu(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TControl(pointer(controlobj)).PopupMenu)));
end;
//fun TControlsetShowHint
function TControlsetShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).ShowHint:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetShowHint
function TControlgetShowHint(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TControl(pointer(controlobj)).ShowHint));
end;
//fun TControlsetVisible
function TControlsetVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).Visible:=Boolean(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetVisible
function TControlgetVisible(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TControl(pointer(controlobj)).Visible));
end;
//fun TControlgetFloating
function TControlgetFloating(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(booltoint(TControl(pointer(controlobj)).Floating));
end;
//fun TControlsetHostDockSite
function TControlsetHostDockSite(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).HostDockSite:=TWinControl(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetHostDockSite
function TControlgetHostDockSite(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(Integer(pointer(TControl(pointer(controlobj)).HostDockSite)));
end;
//fun TControlsetLRDockWidth
function TControlsetLRDockWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).LRDockWidth:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetLRDockWidth
function TControlgetLRDockWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).LRDockWidth);
end;
//fun TControlsetTBDockHeight
function TControlsetTBDockHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).TBDockHeight:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetTBDockHeight
function TControlgetTBDockHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).TBDockHeight);
end;
//fun TControlsetUndockHeight
function TControlsetUndockHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).UndockHeight:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetUndockHeight
function TControlgetUndockHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).UndockHeight);
end;
//fun TControlUseRightToLeftAlignment
function TControlUseRightToLeftAlignment(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).UseRightToLeftAlignment;
Result := PyInt_FromLong(0);
end;
//fun TControlUseRightToLeftReading
function TControlUseRightToLeftReading(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).UseRightToLeftReading;
Result := PyInt_FromLong(0);
end;
//fun TControlUseRightToLeftScrollBar
function TControlUseRightToLeftScrollBar(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).UseRightToLeftScrollBar;
Result := PyInt_FromLong(0);
end;
//fun TControlIsRightToLeft
function TControlIsRightToLeft(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
TControl(pointer(controlobj)).IsRightToLeft;
Result := PyInt_FromLong(0);
end;
//fun TControlsetLeft
function TControlsetLeft(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).Left:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetLeft
function TControlgetLeft(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).Left);
end;
//fun TControlsetHeight
function TControlsetHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).Height:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetHeight
function TControlgetHeight(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).Height);
end;
//fun TControlsetTop
function TControlsetTop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).Top:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetTop
function TControlgetTop(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).Top);
end;
//fun TControlsetWidth
function TControlsetWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:Integer;
begin
PyArg_ParseTuple(Args, 'ii',@controlobj,@para0);
TControl(pointer(controlobj)).Width:=Integer(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetWidth
function TControlgetWidth(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyInt_FromLong(TControl(pointer(controlobj)).Width);
end;
//fun TControlsetHelpKeyword
function TControlsetHelpKeyword(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
para0:PChar;
begin
PyArg_ParseTuple(Args, 'is',@controlobj,@para0);
TControl(pointer(controlobj)).HelpKeyword:=String(para0);
Result := PyInt_FromLong(0);
end;
//fun TControlgetHelpKeyword
function TControlgetHelpKeyword(Self:PyObject;Args:PyObject):PyObject; cdecl;
var
controlobj:Integer;
begin
PyArg_ParseTuple(Args, 'i',@controlobj);
result:=PyString_FromString(PChar(TControl(pointer(controlobj)).HelpKeyword));
end;

  procedure initPyMinMod; cdecl;
  var
    k: integer;
  begin
    Methods[0].Name := 'SumTwoIntegers';
    Methods[0].meth := @SumTwoIntegers;
    Methods[0].flags := METH_VARARGS;
    Methods[0].doc := 'Tests passing ints to and from module function';

    Methods[1].Name := 'ConcatTwoStrings';
    Methods[1].meth := @ConcatTwoStrings;
    Methods[1].flags := METH_VARARGS;
    Methods[1].doc := 'Tests passing strings to and from module function';

    Methods[2].Name := 'Create_Form';
    Methods[2].meth := @Create_Form;
    Methods[2].flags := METH_VARARGS;
    Methods[2].doc := 'creat form';

    Methods[3].Name := 'Create_Button';
    Methods[3].meth := @Create_Button;
    Methods[3].flags := METH_VARARGS;
    Methods[3].doc := 'creat form';

    Methods[4].Name := 'Application_Run';
    Methods[4].meth := @Application_Run;
    Methods[4].flags := METH_VARARGS;
    Methods[4].doc := 'application run';

    Methods[5].Name := 'Set_Caption';
    Methods[5].meth := @Set_Caption;
    Methods[5].flags := METH_VARARGS;
    Methods[5].doc := 'Set Caption';

    Methods[6].Name := 'SetOnClick';
    Methods[6].meth := @SetOnClick;
    Methods[6].flags := METH_VARARGS;
    Methods[6].doc := 'Control SetOnClick';

    Methods[7].Name := 'Set_Caption';
    Methods[7].meth := @Set_Caption;
    Methods[7].flags := METH_VARARGS;
    Methods[7].doc := 'SetCaption';

    Methods[7].Name := 'Set_Top';
    Methods[7].meth := @Set_Top;
    Methods[7].flags := METH_VARARGS;
    Methods[7].doc := 'SetCaption';
    k := 7;
    Inc(k);
    Methods[k].Name := 'setTNotifyEvent';
    Methods[k].meth := @SetOnClick;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Tag';
    Inc(k);
    Methods[k].Name := 'set_Cursor';
    Methods[k].meth := @set_Cursor;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Cursor';
    Inc(k);
    Methods[k].Name := 'set_Left';
    Methods[k].meth := @set_Left;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Left';
    Inc(k);
    Methods[k].Name := 'set_Height';
    Methods[k].meth := @set_Height;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Height';
    Inc(k);
    Methods[k].Name := 'set_Width';
    Methods[k].meth := @set_Width;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Width';
    Inc(k);
    Methods[k].Name := 'set_HelpContext';
    Methods[k].meth := @set_HelpContext;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set HelpContext';
    Teditinteface(k);









    //insert befor
inc(k);
Methods[k].Name := 'TFormCreate';
Methods[k].meth :=@TFormCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormCreate';
inc(k);
Methods[k].Name := 'TFormTile';
Methods[k].meth :=@TFormTile;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormTile';
inc(k);
Methods[k].Name := 'TFormsetAutoScroll';
Methods[k].meth :=@TFormsetAutoScroll;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormsetAutoScroll';
inc(k);
Methods[k].Name := 'TFormgetAutoScroll';
Methods[k].meth :=@TFormgetAutoScroll;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormgetAutoScroll';
inc(k);
Methods[k].Name := 'TFormsetOnDblClick';
Methods[k].meth :=@TFormsetOnDblClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormsetOnDblClick';
inc(k);
Methods[k].Name := 'TFormsetOnMouseEnter';
Methods[k].meth :=@TFormsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TFormsetOnMouseLeave';
Methods[k].meth :=@TFormsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TFormsetParentFont';
Methods[k].meth :=@TFormsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormsetParentFont';
inc(k);
Methods[k].Name := 'TFormgetParentFont';
Methods[k].meth :=@TFormgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormgetParentFont';
inc(k);
Methods[k].Name := 'TFormsetSessionProperties';
Methods[k].meth :=@TFormsetSessionProperties;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormsetSessionProperties';
inc(k);
Methods[k].Name := 'TFormgetSessionProperties';
Methods[k].meth :=@TFormgetSessionProperties;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormgetSessionProperties';
inc(k);
Methods[k].Name := 'TFormsetLCLVersion';
Methods[k].meth :=@TFormsetLCLVersion;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormsetLCLVersion';
inc(k);
Methods[k].Name := 'TFormgetLCLVersion';
Methods[k].meth :=@TFormgetLCLVersion;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TFormgetLCLVersion';
inc(k);
Methods[k].Name := 'TMainMenuCreate';
Methods[k].meth :=@TMainMenuCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMainMenuCreate';
inc(k);
Methods[k].Name := 'TMainMenugetHeight';
Methods[k].meth :=@TMainMenugetHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMainMenugetHeight';
inc(k);
Methods[k].Name := 'TMenuItemFind';
Methods[k].meth :=@TMenuItemFind;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemFind';
inc(k);
Methods[k].Name := 'TMenuItemGetParentComponent';
Methods[k].meth :=@TMenuItemGetParentComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemGetParentComponent';
inc(k);
Methods[k].Name := 'TMenuItemGetParentMenu';
Methods[k].meth :=@TMenuItemGetParentMenu;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemGetParentMenu';
inc(k);
Methods[k].Name := 'TMenuItemGetIsRightToLeft';
Methods[k].meth :=@TMenuItemGetIsRightToLeft;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemGetIsRightToLeft';
inc(k);
Methods[k].Name := 'TMenuItemHandleAllocated';
Methods[k].meth :=@TMenuItemHandleAllocated;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemHandleAllocated';
inc(k);
Methods[k].Name := 'TMenuItemHasIcon';
Methods[k].meth :=@TMenuItemHasIcon;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemHasIcon';
inc(k);
Methods[k].Name := 'TMenuItemHasParent';
Methods[k].meth :=@TMenuItemHasParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemHasParent';
inc(k);
Methods[k].Name := 'TMenuItemInitiateAction';
Methods[k].meth :=@TMenuItemInitiateAction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemInitiateAction';
inc(k);
Methods[k].Name := 'TMenuItemIntfDoSelect';
Methods[k].meth :=@TMenuItemIntfDoSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemIntfDoSelect';
inc(k);
Methods[k].Name := 'TMenuItemIndexOf';
Methods[k].meth :=@TMenuItemIndexOf;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemIndexOf';
inc(k);
Methods[k].Name := 'TMenuItemIndexOfCaption';
Methods[k].meth :=@TMenuItemIndexOfCaption;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemIndexOfCaption';
inc(k);
Methods[k].Name := 'TMenuItemVisibleIndexOf';
Methods[k].meth :=@TMenuItemVisibleIndexOf;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemVisibleIndexOf';
inc(k);
Methods[k].Name := 'TMenuItemAdd';
Methods[k].meth :=@TMenuItemAdd;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemAdd';
inc(k);
Methods[k].Name := 'TMenuItemAddSeparator';
Methods[k].meth :=@TMenuItemAddSeparator;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemAddSeparator';
inc(k);
Methods[k].Name := 'TMenuItemClick';
Methods[k].meth :=@TMenuItemClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemClick';
inc(k);
Methods[k].Name := 'TMenuItemDelete';
Methods[k].meth :=@TMenuItemDelete;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemDelete';
inc(k);
Methods[k].Name := 'TMenuItemHandleNeeded';
Methods[k].meth :=@TMenuItemHandleNeeded;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemHandleNeeded';
inc(k);
Methods[k].Name := 'TMenuItemInsert';
Methods[k].meth :=@TMenuItemInsert;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemInsert';
inc(k);
Methods[k].Name := 'TMenuItemRecreateHandle';
Methods[k].meth :=@TMenuItemRecreateHandle;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemRecreateHandle';
inc(k);
Methods[k].Name := 'TMenuItemRemove';
Methods[k].meth :=@TMenuItemRemove;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemRemove';
inc(k);
Methods[k].Name := 'TMenuItemIsCheckItem';
Methods[k].meth :=@TMenuItemIsCheckItem;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemIsCheckItem';
inc(k);
Methods[k].Name := 'TMenuItemIsLine';
Methods[k].meth :=@TMenuItemIsLine;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemIsLine';
inc(k);
Methods[k].Name := 'TMenuItemIsInMenuBar';
Methods[k].meth :=@TMenuItemIsInMenuBar;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemIsInMenuBar';
inc(k);
Methods[k].Name := 'TMenuItemClear';
Methods[k].meth :=@TMenuItemClear;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemClear';
inc(k);
Methods[k].Name := 'TMenuItemHasBitmap';
Methods[k].meth :=@TMenuItemHasBitmap;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemHasBitmap';
inc(k);
Methods[k].Name := 'TMenuItemRemoveAllHandlersOfObject';
Methods[k].meth :=@TMenuItemRemoveAllHandlersOfObject;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemRemoveAllHandlersOfObject';
inc(k);
Methods[k].Name := 'TMenuItemgetCount';
Methods[k].meth :=@TMenuItemgetCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetCount';
inc(k);
Methods[k].Name := 'TMenuItemgetItems';
Methods[k].meth :=@TMenuItemgetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetItems';
inc(k);
Methods[k].Name := 'TMenuItemsetMenuIndex';
Methods[k].meth :=@TMenuItemsetMenuIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemsetMenuIndex';
inc(k);
Methods[k].Name := 'TMenuItemgetMenuIndex';
Methods[k].meth :=@TMenuItemgetMenuIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetMenuIndex';
inc(k);
Methods[k].Name := 'TMenuItemgetMenu';
Methods[k].meth :=@TMenuItemgetMenu;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetMenu';
inc(k);
Methods[k].Name := 'TMenuItemgetParent';
Methods[k].meth :=@TMenuItemgetParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetParent';
inc(k);
Methods[k].Name := 'TMenuItemMenuVisibleIndex';
Methods[k].meth :=@TMenuItemMenuVisibleIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemMenuVisibleIndex';
inc(k);
Methods[k].Name := 'TMenuItemsetAutoCheck';
Methods[k].meth :=@TMenuItemsetAutoCheck;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemsetAutoCheck';
inc(k);
Methods[k].Name := 'TMenuItemgetAutoCheck';
Methods[k].meth :=@TMenuItemgetAutoCheck;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetAutoCheck';
inc(k);
Methods[k].Name := 'TMenuItemsetDefault';
Methods[k].meth :=@TMenuItemsetDefault;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemsetDefault';
inc(k);
Methods[k].Name := 'TMenuItemgetDefault';
Methods[k].meth :=@TMenuItemgetDefault;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetDefault';
inc(k);
Methods[k].Name := 'TMenuItemsetRadioItem';
Methods[k].meth :=@TMenuItemsetRadioItem;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemsetRadioItem';
inc(k);
Methods[k].Name := 'TMenuItemgetRadioItem';
Methods[k].meth :=@TMenuItemgetRadioItem;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetRadioItem';
inc(k);
Methods[k].Name := 'TMenuItemsetRightJustify';
Methods[k].meth :=@TMenuItemsetRightJustify;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemsetRightJustify';
inc(k);
Methods[k].Name := 'TMenuItemgetRightJustify';
Methods[k].meth :=@TMenuItemgetRightJustify;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemgetRightJustify';
inc(k);
Methods[k].Name := 'TMenuItemsetOnClick';
Methods[k].meth :=@TMenuItemsetOnClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuItemsetOnClick';
inc(k);
Methods[k].Name := 'TPopupMenuPopUp';
Methods[k].meth :=@TPopupMenuPopUp;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TPopupMenuPopUp';
inc(k);
Methods[k].Name := 'TPopupMenusetPopupComponent';
Methods[k].meth :=@TPopupMenusetPopupComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TPopupMenusetPopupComponent';
inc(k);
Methods[k].Name := 'TPopupMenugetPopupComponent';
Methods[k].meth :=@TPopupMenugetPopupComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TPopupMenugetPopupComponent';
inc(k);
Methods[k].Name := 'TPopupMenusetAutoPopup';
Methods[k].meth :=@TPopupMenusetAutoPopup;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TPopupMenusetAutoPopup';
inc(k);
Methods[k].Name := 'TPopupMenugetAutoPopup';
Methods[k].meth :=@TPopupMenugetAutoPopup;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TPopupMenugetAutoPopup';
inc(k);
Methods[k].Name := 'TPopupMenusetOnPopup';
Methods[k].meth :=@TPopupMenusetOnPopup;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TPopupMenusetOnPopup';
inc(k);
Methods[k].Name := 'TPopupMenusetOnClose';
Methods[k].meth :=@TPopupMenusetOnClose;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TPopupMenusetOnClose';
inc(k);
Methods[k].Name := 'TButtonsetOnMouseEnter';
Methods[k].meth :=@TButtonsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TButtonsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TButtonsetOnMouseLeave';
Methods[k].meth :=@TButtonsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TButtonsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TButtonsetParentFont';
Methods[k].meth :=@TButtonsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TButtonsetParentFont';
inc(k);
Methods[k].Name := 'TButtongetParentFont';
Methods[k].meth :=@TButtongetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TButtongetParentFont';
inc(k);
Methods[k].Name := 'TButtonsetParentShowHint';
Methods[k].meth :=@TButtonsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TButtonsetParentShowHint';
inc(k);
Methods[k].Name := 'TButtongetParentShowHint';
Methods[k].meth :=@TButtongetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TButtongetParentShowHint';
inc(k);
Methods[k].Name := 'TLabelsetFocusControl';
Methods[k].meth :=@TLabelsetFocusControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetFocusControl';
inc(k);
Methods[k].Name := 'TLabelgetFocusControl';
Methods[k].meth :=@TLabelgetFocusControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelgetFocusControl';
inc(k);
Methods[k].Name := 'TLabelsetParentColor';
Methods[k].meth :=@TLabelsetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetParentColor';
inc(k);
Methods[k].Name := 'TLabelgetParentColor';
Methods[k].meth :=@TLabelgetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelgetParentColor';
inc(k);
Methods[k].Name := 'TLabelsetParentFont';
Methods[k].meth :=@TLabelsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetParentFont';
inc(k);
Methods[k].Name := 'TLabelgetParentFont';
Methods[k].meth :=@TLabelgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelgetParentFont';
inc(k);
Methods[k].Name := 'TLabelsetParentShowHint';
Methods[k].meth :=@TLabelsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetParentShowHint';
inc(k);
Methods[k].Name := 'TLabelgetParentShowHint';
Methods[k].meth :=@TLabelgetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelgetParentShowHint';
inc(k);
Methods[k].Name := 'TLabelsetShowAccelChar';
Methods[k].meth :=@TLabelsetShowAccelChar;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetShowAccelChar';
inc(k);
Methods[k].Name := 'TLabelgetShowAccelChar';
Methods[k].meth :=@TLabelgetShowAccelChar;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelgetShowAccelChar';
inc(k);
Methods[k].Name := 'TLabelsetTransparent';
Methods[k].meth :=@TLabelsetTransparent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetTransparent';
inc(k);
Methods[k].Name := 'TLabelgetTransparent';
Methods[k].meth :=@TLabelgetTransparent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelgetTransparent';
inc(k);
Methods[k].Name := 'TLabelsetWordWrap';
Methods[k].meth :=@TLabelsetWordWrap;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetWordWrap';
inc(k);
Methods[k].Name := 'TLabelgetWordWrap';
Methods[k].meth :=@TLabelgetWordWrap;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelgetWordWrap';
inc(k);
Methods[k].Name := 'TLabelsetOnDblClick';
Methods[k].meth :=@TLabelsetOnDblClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetOnDblClick';
inc(k);
Methods[k].Name := 'TLabelsetOnMouseEnter';
Methods[k].meth :=@TLabelsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TLabelsetOnMouseLeave';
Methods[k].meth :=@TLabelsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TLabelsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TEditsetAutoSelect';
Methods[k].meth :=@TEditsetAutoSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditsetAutoSelect';
inc(k);
Methods[k].Name := 'TEditgetAutoSelect';
Methods[k].meth :=@TEditgetAutoSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditgetAutoSelect';
inc(k);
Methods[k].Name := 'TEditsetOnDblClick';
Methods[k].meth :=@TEditsetOnDblClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditsetOnDblClick';
inc(k);
Methods[k].Name := 'TEditsetOnMouseEnter';
Methods[k].meth :=@TEditsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TEditsetOnMouseLeave';
Methods[k].meth :=@TEditsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TEditsetParentColor';
Methods[k].meth :=@TEditsetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditsetParentColor';
inc(k);
Methods[k].Name := 'TEditgetParentColor';
Methods[k].meth :=@TEditgetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditgetParentColor';
inc(k);
Methods[k].Name := 'TEditsetParentFont';
Methods[k].meth :=@TEditsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditsetParentFont';
inc(k);
Methods[k].Name := 'TEditgetParentFont';
Methods[k].meth :=@TEditgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditgetParentFont';
inc(k);
Methods[k].Name := 'TEditsetParentShowHint';
Methods[k].meth :=@TEditsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditsetParentShowHint';
inc(k);
Methods[k].Name := 'TEditgetParentShowHint';
Methods[k].meth :=@TEditgetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TEditgetParentShowHint';
inc(k);
Methods[k].Name := 'TToggleBoxsetChecked';
Methods[k].meth :=@TToggleBoxsetChecked;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxsetChecked';
inc(k);
Methods[k].Name := 'TToggleBoxgetChecked';
Methods[k].meth :=@TToggleBoxgetChecked;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxgetChecked';
inc(k);
Methods[k].Name := 'TToggleBoxsetOnMouseEnter';
Methods[k].meth :=@TToggleBoxsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TToggleBoxsetOnMouseLeave';
Methods[k].meth :=@TToggleBoxsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TToggleBoxsetParentFont';
Methods[k].meth :=@TToggleBoxsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxsetParentFont';
inc(k);
Methods[k].Name := 'TToggleBoxgetParentFont';
Methods[k].meth :=@TToggleBoxgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxgetParentFont';
inc(k);
Methods[k].Name := 'TToggleBoxsetParentShowHint';
Methods[k].meth :=@TToggleBoxsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxsetParentShowHint';
inc(k);
Methods[k].Name := 'TToggleBoxgetParentShowHint';
Methods[k].meth :=@TToggleBoxgetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TToggleBoxgetParentShowHint';
inc(k);
Methods[k].Name := 'TCheckBoxsetChecked';
Methods[k].meth :=@TCheckBoxsetChecked;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxsetChecked';
inc(k);
Methods[k].Name := 'TCheckBoxgetChecked';
Methods[k].meth :=@TCheckBoxgetChecked;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxgetChecked';
inc(k);
Methods[k].Name := 'TCheckBoxsetOnMouseEnter';
Methods[k].meth :=@TCheckBoxsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TCheckBoxsetOnMouseLeave';
Methods[k].meth :=@TCheckBoxsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TCheckBoxsetParentColor';
Methods[k].meth :=@TCheckBoxsetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxsetParentColor';
inc(k);
Methods[k].Name := 'TCheckBoxgetParentColor';
Methods[k].meth :=@TCheckBoxgetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxgetParentColor';
inc(k);
Methods[k].Name := 'TCheckBoxsetParentFont';
Methods[k].meth :=@TCheckBoxsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxsetParentFont';
inc(k);
Methods[k].Name := 'TCheckBoxgetParentFont';
Methods[k].meth :=@TCheckBoxgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxgetParentFont';
inc(k);
Methods[k].Name := 'TCheckBoxsetParentShowHint';
Methods[k].meth :=@TCheckBoxsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxsetParentShowHint';
inc(k);
Methods[k].Name := 'TCheckBoxgetParentShowHint';
Methods[k].meth :=@TCheckBoxgetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCheckBoxgetParentShowHint';
inc(k);
Methods[k].Name := 'TRadioButtonsetChecked';
Methods[k].meth :=@TRadioButtonsetChecked;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtonsetChecked';
inc(k);
Methods[k].Name := 'TRadioButtongetChecked';
Methods[k].meth :=@TRadioButtongetChecked;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtongetChecked';
inc(k);
Methods[k].Name := 'TRadioButtonsetOnMouseEnter';
Methods[k].meth :=@TRadioButtonsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtonsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TRadioButtonsetOnMouseLeave';
Methods[k].meth :=@TRadioButtonsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtonsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TRadioButtonsetParentColor';
Methods[k].meth :=@TRadioButtonsetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtonsetParentColor';
inc(k);
Methods[k].Name := 'TRadioButtongetParentColor';
Methods[k].meth :=@TRadioButtongetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtongetParentColor';
inc(k);
Methods[k].Name := 'TRadioButtonsetParentFont';
Methods[k].meth :=@TRadioButtonsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtonsetParentFont';
inc(k);
Methods[k].Name := 'TRadioButtongetParentFont';
Methods[k].meth :=@TRadioButtongetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtongetParentFont';
inc(k);
Methods[k].Name := 'TRadioButtonsetParentShowHint';
Methods[k].meth :=@TRadioButtonsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtonsetParentShowHint';
inc(k);
Methods[k].Name := 'TRadioButtongetParentShowHint';
Methods[k].meth :=@TRadioButtongetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TRadioButtongetParentShowHint';
inc(k);
Methods[k].Name := 'TListBoxsetOnDblClick';
Methods[k].meth :=@TListBoxsetOnDblClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxsetOnDblClick';
inc(k);
Methods[k].Name := 'TListBoxsetOnMouseEnter';
Methods[k].meth :=@TListBoxsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TListBoxsetOnMouseLeave';
Methods[k].meth :=@TListBoxsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TListBoxsetParentColor';
Methods[k].meth :=@TListBoxsetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxsetParentColor';
inc(k);
Methods[k].Name := 'TListBoxgetParentColor';
Methods[k].meth :=@TListBoxgetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxgetParentColor';
inc(k);
Methods[k].Name := 'TListBoxsetParentShowHint';
Methods[k].meth :=@TListBoxsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxsetParentShowHint';
inc(k);
Methods[k].Name := 'TListBoxgetParentShowHint';
Methods[k].meth :=@TListBoxgetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxgetParentShowHint';
inc(k);
Methods[k].Name := 'TListBoxsetParentFont';
Methods[k].meth :=@TListBoxsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxsetParentFont';
inc(k);
Methods[k].Name := 'TListBoxgetParentFont';
Methods[k].meth :=@TListBoxgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TListBoxgetParentFont';
inc(k);
Methods[k].Name := 'TComboBoxsetItemHeight';
Methods[k].meth :=@TComboBoxsetItemHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetItemHeight';
inc(k);
Methods[k].Name := 'TComboBoxgetItemHeight';
Methods[k].meth :=@TComboBoxgetItemHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxgetItemHeight';
inc(k);
Methods[k].Name := 'TComboBoxsetItemWidth';
Methods[k].meth :=@TComboBoxsetItemWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetItemWidth';
inc(k);
Methods[k].Name := 'TComboBoxgetItemWidth';
Methods[k].meth :=@TComboBoxgetItemWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxgetItemWidth';
inc(k);
Methods[k].Name := 'TComboBoxsetMaxLength';
Methods[k].meth :=@TComboBoxsetMaxLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetMaxLength';
inc(k);
Methods[k].Name := 'TComboBoxgetMaxLength';
Methods[k].meth :=@TComboBoxgetMaxLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxgetMaxLength';
inc(k);
Methods[k].Name := 'TComboBoxsetOnChange';
Methods[k].meth :=@TComboBoxsetOnChange;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnChange';
inc(k);
Methods[k].Name := 'TComboBoxsetOnCloseUp';
Methods[k].meth :=@TComboBoxsetOnCloseUp;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnCloseUp';
inc(k);
Methods[k].Name := 'TComboBoxsetOnDblClick';
Methods[k].meth :=@TComboBoxsetOnDblClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnDblClick';
inc(k);
Methods[k].Name := 'TComboBoxsetOnDropDown';
Methods[k].meth :=@TComboBoxsetOnDropDown;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnDropDown';
inc(k);
Methods[k].Name := 'TComboBoxsetOnGetItems';
Methods[k].meth :=@TComboBoxsetOnGetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnGetItems';
inc(k);
Methods[k].Name := 'TComboBoxsetOnMouseEnter';
Methods[k].meth :=@TComboBoxsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TComboBoxsetOnMouseLeave';
Methods[k].meth :=@TComboBoxsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TComboBoxsetOnSelect';
Methods[k].meth :=@TComboBoxsetOnSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetOnSelect';
inc(k);
Methods[k].Name := 'TComboBoxsetParentColor';
Methods[k].meth :=@TComboBoxsetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetParentColor';
inc(k);
Methods[k].Name := 'TComboBoxgetParentColor';
Methods[k].meth :=@TComboBoxgetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxgetParentColor';
inc(k);
Methods[k].Name := 'TComboBoxsetParentFont';
Methods[k].meth :=@TComboBoxsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetParentFont';
inc(k);
Methods[k].Name := 'TComboBoxgetParentFont';
Methods[k].meth :=@TComboBoxgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxgetParentFont';
inc(k);
Methods[k].Name := 'TComboBoxsetParentShowHint';
Methods[k].meth :=@TComboBoxsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxsetParentShowHint';
inc(k);
Methods[k].Name := 'TComboBoxgetParentShowHint';
Methods[k].meth :=@TComboBoxgetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComboBoxgetParentShowHint';
inc(k);
Methods[k].Name := 'TScrollBarsetParentShowHint';
Methods[k].meth :=@TScrollBarsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TScrollBarsetParentShowHint';
inc(k);
Methods[k].Name := 'TScrollBargetParentShowHint';
Methods[k].meth :=@TScrollBargetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TScrollBargetParentShowHint';
inc(k);
Methods[k].Name := 'TMemosetOnDblClick';
Methods[k].meth :=@TMemosetOnDblClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemosetOnDblClick';
inc(k);
Methods[k].Name := 'TMemosetOnMouseEnter';
Methods[k].meth :=@TMemosetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemosetOnMouseEnter';
inc(k);
Methods[k].Name := 'TMemosetOnMouseLeave';
Methods[k].meth :=@TMemosetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemosetOnMouseLeave';
inc(k);
Methods[k].Name := 'TMemosetParentColor';
Methods[k].meth :=@TMemosetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemosetParentColor';
inc(k);
Methods[k].Name := 'TMemogetParentColor';
Methods[k].meth :=@TMemogetParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemogetParentColor';
inc(k);
Methods[k].Name := 'TMemosetParentFont';
Methods[k].meth :=@TMemosetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemosetParentFont';
inc(k);
Methods[k].Name := 'TMemogetParentFont';
Methods[k].meth :=@TMemogetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemogetParentFont';
inc(k);
Methods[k].Name := 'TMemosetParentShowHint';
Methods[k].meth :=@TMemosetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemosetParentShowHint';
inc(k);
Methods[k].Name := 'TMemogetParentShowHint';
Methods[k].meth :=@TMemogetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMemogetParentShowHint';
inc(k);
Methods[k].Name := 'TStringsAdd';
Methods[k].meth :=@TStringsAdd;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsAdd';
inc(k);
Methods[k].Name := 'TStringsAddObject';
Methods[k].meth :=@TStringsAddObject;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsAddObject';
inc(k);
Methods[k].Name := 'TStringsAppend';
Methods[k].meth :=@TStringsAppend;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsAppend';
inc(k);
Methods[k].Name := 'TStringsAddStrings';
Methods[k].meth :=@TStringsAddStrings;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsAddStrings';
inc(k);
Methods[k].Name := 'TStringsBeginUpdate';
Methods[k].meth :=@TStringsBeginUpdate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsBeginUpdate';
inc(k);
Methods[k].Name := 'TStringsClear';
Methods[k].meth :=@TStringsClear;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsClear';
inc(k);
Methods[k].Name := 'TStringsDelete';
Methods[k].meth :=@TStringsDelete;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsDelete';
inc(k);
Methods[k].Name := 'TStringsEndUpdate';
Methods[k].meth :=@TStringsEndUpdate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsEndUpdate';
inc(k);
Methods[k].Name := 'TStringsEquals';
Methods[k].meth :=@TStringsEquals;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsEquals';
inc(k);
Methods[k].Name := 'TStringsExchange';
Methods[k].meth :=@TStringsExchange;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsExchange';
inc(k);
Methods[k].Name := 'TStringsIndexOf';
Methods[k].meth :=@TStringsIndexOf;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsIndexOf';
inc(k);
Methods[k].Name := 'TStringsIndexOfName';
Methods[k].meth :=@TStringsIndexOfName;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsIndexOfName';
inc(k);
Methods[k].Name := 'TStringsIndexOfObject';
Methods[k].meth :=@TStringsIndexOfObject;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsIndexOfObject';
inc(k);
Methods[k].Name := 'TStringsInsert';
Methods[k].meth :=@TStringsInsert;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsInsert';
inc(k);
Methods[k].Name := 'TStringsLoadFromFile';
Methods[k].meth :=@TStringsLoadFromFile;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsLoadFromFile';
inc(k);
Methods[k].Name := 'TStringsMove';
Methods[k].meth :=@TStringsMove;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsMove';
inc(k);
Methods[k].Name := 'TStringsSaveToFile';
Methods[k].meth :=@TStringsSaveToFile;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsSaveToFile';
//inc(k);
//Methods[k].Name := 'TStringsGetNameValue';
//Methods[k].meth :=@TStringsGetNameValue;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TStringsGetNameValue';
inc(k);
Methods[k].Name := 'TStringssetValueFromIndex';
Methods[k].meth :=@TStringssetValueFromIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringssetValueFromIndex';
inc(k);
Methods[k].Name := 'TStringsgetValueFromIndex';
Methods[k].meth :=@TStringsgetValueFromIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetValueFromIndex';
inc(k);
Methods[k].Name := 'TStringssetCapacity';
Methods[k].meth :=@TStringssetCapacity;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringssetCapacity';
inc(k);
Methods[k].Name := 'TStringsgetCapacity';
Methods[k].meth :=@TStringsgetCapacity;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetCapacity';
inc(k);
Methods[k].Name := 'TStringssetCommaText';
Methods[k].meth :=@TStringssetCommaText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringssetCommaText';
inc(k);
Methods[k].Name := 'TStringsgetCommaText';
Methods[k].meth :=@TStringsgetCommaText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetCommaText';
inc(k);
Methods[k].Name := 'TStringsgetCount';
Methods[k].meth :=@TStringsgetCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetCount';
inc(k);
Methods[k].Name := 'TStringsgetNames';
Methods[k].meth :=@TStringsgetNames;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetNames';
inc(k);
Methods[k].Name := 'TStringssetObjects';
Methods[k].meth :=@TStringssetObjects;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringssetObjects';
inc(k);
Methods[k].Name := 'TStringsgetObjects';
Methods[k].meth :=@TStringsgetObjects;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetObjects';
//inc(k);
//Methods[k].Name := 'TStringssetValues';
//Methods[k].meth :=@TStringssetValues;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TStringssetValues';
//inc(k);
//Methods[k].Name := 'TStringsgetValues';
//Methods[k].meth :=@TStringsgetValues;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TStringsgetValues';
inc(k);
Methods[k].Name := 'TStringssetStrings';
Methods[k].meth :=@TStringssetStrings;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringssetStrings';
inc(k);
Methods[k].Name := 'TStringsgetStrings';
Methods[k].meth :=@TStringsgetStrings;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetStrings';
inc(k);
Methods[k].Name := 'TStringssetText';
Methods[k].meth :=@TStringssetText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringssetText';
inc(k);
Methods[k].Name := 'TStringsgetText';
Methods[k].meth :=@TStringsgetText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TStringsgetText';
inc(k);
Methods[k].Name := 'TCustomFormAfterConstruction';
Methods[k].meth :=@TCustomFormAfterConstruction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormAfterConstruction';
inc(k);
Methods[k].Name := 'TCustomFormBeforeDestruction';
Methods[k].meth :=@TCustomFormBeforeDestruction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormBeforeDestruction';
inc(k);
Methods[k].Name := 'TCustomFormClose';
Methods[k].meth :=@TCustomFormClose;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormClose';
inc(k);
Methods[k].Name := 'TCustomFormCloseQuery';
Methods[k].meth :=@TCustomFormCloseQuery;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormCloseQuery';
inc(k);
Methods[k].Name := 'TCustomFormDefocusControl';
Methods[k].meth :=@TCustomFormDefocusControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormDefocusControl';
inc(k);
Methods[k].Name := 'TCustomFormDestroyWnd';
Methods[k].meth :=@TCustomFormDestroyWnd;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormDestroyWnd';
inc(k);
Methods[k].Name := 'TCustomFormEnsureVisible';
Methods[k].meth :=@TCustomFormEnsureVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormEnsureVisible';
inc(k);
Methods[k].Name := 'TCustomFormFocusControl';
Methods[k].meth :=@TCustomFormFocusControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormFocusControl';
inc(k);
Methods[k].Name := 'TCustomFormFormIsUpdating';
Methods[k].meth :=@TCustomFormFormIsUpdating;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormFormIsUpdating';
inc(k);
Methods[k].Name := 'TCustomFormHide';
Methods[k].meth :=@TCustomFormHide;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormHide';
inc(k);
Methods[k].Name := 'TCustomFormIntfHelp';
Methods[k].meth :=@TCustomFormIntfHelp;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormIntfHelp';
inc(k);
Methods[k].Name := 'TCustomFormAutoSizeDelayedHandle';
Methods[k].meth :=@TCustomFormAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TCustomFormRelease';
Methods[k].meth :=@TCustomFormRelease;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormRelease';
inc(k);
Methods[k].Name := 'TCustomFormCanFocus';
Methods[k].meth :=@TCustomFormCanFocus;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormCanFocus';
inc(k);
Methods[k].Name := 'TCustomFormSetFocus';
Methods[k].meth :=@TCustomFormSetFocus;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormSetFocus';
inc(k);
Methods[k].Name := 'TCustomFormSetFocusedControl';
Methods[k].meth :=@TCustomFormSetFocusedControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormSetFocusedControl';
inc(k);
Methods[k].Name := 'TCustomFormSetRestoredBounds';
Methods[k].meth :=@TCustomFormSetRestoredBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormSetRestoredBounds';
inc(k);
Methods[k].Name := 'TCustomFormShow';
Methods[k].meth :=@TCustomFormShow;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormShow';
inc(k);
Methods[k].Name := 'TCustomFormShowModal';
Methods[k].meth :=@TCustomFormShowModal;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormShowModal';
inc(k);
Methods[k].Name := 'TCustomFormShowOnTop';
Methods[k].meth :=@TCustomFormShowOnTop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormShowOnTop';
inc(k);
Methods[k].Name := 'TCustomFormRemoveAllHandlersOfObject';
Methods[k].meth :=@TCustomFormRemoveAllHandlersOfObject;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormRemoveAllHandlersOfObject';
inc(k);
Methods[k].Name := 'TCustomFormActiveMDIChild';
Methods[k].meth :=@TCustomFormActiveMDIChild;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormActiveMDIChild';
inc(k);
Methods[k].Name := 'TCustomFormGetMDIChildren';
Methods[k].meth :=@TCustomFormGetMDIChildren;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormGetMDIChildren';
inc(k);
Methods[k].Name := 'TCustomFormMDIChildCount';
Methods[k].meth :=@TCustomFormMDIChildCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormMDIChildCount';
inc(k);
Methods[k].Name := 'TCustomFormgetActive';
Methods[k].meth :=@TCustomFormgetActive;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetActive';
inc(k);
Methods[k].Name := 'TCustomFormsetActiveControl';
Methods[k].meth :=@TCustomFormsetActiveControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetActiveControl';
inc(k);
Methods[k].Name := 'TCustomFormgetActiveControl';
Methods[k].meth :=@TCustomFormgetActiveControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetActiveControl';
inc(k);
Methods[k].Name := 'TCustomFormsetActiveDefaultControl';
Methods[k].meth :=@TCustomFormsetActiveDefaultControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetActiveDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormgetActiveDefaultControl';
Methods[k].meth :=@TCustomFormgetActiveDefaultControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetActiveDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormsetAllowDropFiles';
Methods[k].meth :=@TCustomFormsetAllowDropFiles;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetAllowDropFiles';
inc(k);
Methods[k].Name := 'TCustomFormgetAllowDropFiles';
Methods[k].meth :=@TCustomFormgetAllowDropFiles;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetAllowDropFiles';
inc(k);
Methods[k].Name := 'TCustomFormsetAlphaBlend';
Methods[k].meth :=@TCustomFormsetAlphaBlend;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetAlphaBlend';
inc(k);
Methods[k].Name := 'TCustomFormgetAlphaBlend';
Methods[k].meth :=@TCustomFormgetAlphaBlend;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetAlphaBlend';
inc(k);
Methods[k].Name := 'TCustomFormsetCancelControl';
Methods[k].meth :=@TCustomFormsetCancelControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetCancelControl';
inc(k);
Methods[k].Name := 'TCustomFormgetCancelControl';
Methods[k].meth :=@TCustomFormgetCancelControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetCancelControl';
inc(k);
Methods[k].Name := 'TCustomFormsetDefaultControl';
Methods[k].meth :=@TCustomFormsetDefaultControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormgetDefaultControl';
Methods[k].meth :=@TCustomFormgetDefaultControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormsetDesignTimeDPI';
Methods[k].meth :=@TCustomFormsetDesignTimeDPI;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetDesignTimeDPI';
inc(k);
Methods[k].Name := 'TCustomFormgetDesignTimeDPI';
Methods[k].meth :=@TCustomFormgetDesignTimeDPI;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetDesignTimeDPI';
inc(k);
Methods[k].Name := 'TCustomFormsetHelpFile';
Methods[k].meth :=@TCustomFormsetHelpFile;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetHelpFile';
inc(k);
Methods[k].Name := 'TCustomFormgetHelpFile';
Methods[k].meth :=@TCustomFormgetHelpFile;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetHelpFile';
inc(k);
Methods[k].Name := 'TCustomFormsetKeyPreview';
Methods[k].meth :=@TCustomFormsetKeyPreview;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetKeyPreview';
inc(k);
Methods[k].Name := 'TCustomFormgetKeyPreview';
Methods[k].meth :=@TCustomFormgetKeyPreview;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetKeyPreview';
inc(k);
Methods[k].Name := 'TCustomFormsetMenu';
Methods[k].meth :=@TCustomFormsetMenu;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetMenu';
inc(k);
Methods[k].Name := 'TCustomFormgetMenu';
Methods[k].meth :=@TCustomFormgetMenu;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetMenu';
inc(k);
Methods[k].Name := 'TCustomFormsetPopupParent';
Methods[k].meth :=@TCustomFormsetPopupParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetPopupParent';
inc(k);
Methods[k].Name := 'TCustomFormgetPopupParent';
Methods[k].meth :=@TCustomFormgetPopupParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetPopupParent';
inc(k);
Methods[k].Name := 'TCustomFormsetOnActivate';
Methods[k].meth :=@TCustomFormsetOnActivate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetOnActivate';
inc(k);
Methods[k].Name := 'TCustomFormsetOnCreate';
Methods[k].meth :=@TCustomFormsetOnCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetOnCreate';
inc(k);
Methods[k].Name := 'TCustomFormsetOnDeactivate';
Methods[k].meth :=@TCustomFormsetOnDeactivate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetOnDeactivate';
inc(k);
Methods[k].Name := 'TCustomFormsetOnDestroy';
Methods[k].meth :=@TCustomFormsetOnDestroy;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetOnDestroy';
inc(k);
Methods[k].Name := 'TCustomFormsetOnHide';
Methods[k].meth :=@TCustomFormsetOnHide;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetOnHide';
inc(k);
Methods[k].Name := 'TCustomFormsetOnShow';
Methods[k].meth :=@TCustomFormsetOnShow;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormsetOnShow';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredLeft';
Methods[k].meth :=@TCustomFormgetRestoredLeft;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetRestoredLeft';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredTop';
Methods[k].meth :=@TCustomFormgetRestoredTop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetRestoredTop';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredWidth';
Methods[k].meth :=@TCustomFormgetRestoredWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetRestoredWidth';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredHeight';
Methods[k].meth :=@TCustomFormgetRestoredHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomFormgetRestoredHeight';
inc(k);
Methods[k].Name := 'TMenuDestroyHandle';
Methods[k].meth :=@TMenuDestroyHandle;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuDestroyHandle';
inc(k);
Methods[k].Name := 'TMenuHandleAllocated';
Methods[k].meth :=@TMenuHandleAllocated;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuHandleAllocated';
inc(k);
Methods[k].Name := 'TMenuIsRightToLeft';
Methods[k].meth :=@TMenuIsRightToLeft;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuIsRightToLeft';
inc(k);
Methods[k].Name := 'TMenuUseRightToLeftAlignment';
Methods[k].meth :=@TMenuUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TMenuUseRightToLeftReading';
Methods[k].meth :=@TMenuUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TMenuHandleNeeded';
Methods[k].meth :=@TMenuHandleNeeded;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenuHandleNeeded';
inc(k);
Methods[k].Name := 'TMenusetParent';
Methods[k].meth :=@TMenusetParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenusetParent';
inc(k);
Methods[k].Name := 'TMenugetParent';
Methods[k].meth :=@TMenugetParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenugetParent';
inc(k);
Methods[k].Name := 'TMenusetParentBidiMode';
Methods[k].meth :=@TMenusetParentBidiMode;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenusetParentBidiMode';
inc(k);
Methods[k].Name := 'TMenugetParentBidiMode';
Methods[k].meth :=@TMenugetParentBidiMode;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenugetParentBidiMode';
inc(k);
Methods[k].Name := 'TMenugetItems';
Methods[k].meth :=@TMenugetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TMenugetItems';
//inc(k);
//Methods[k].Name := 'TLCLComponentRemoveAllHandlersOfObject';
//Methods[k].meth :=@TLCLComponentRemoveAllHandlersOfObject;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TLCLComponentRemoveAllHandlersOfObject';
//inc(k);
//Methods[k].Name := 'TLCLComponentIncLCLRefCount';
//Methods[k].meth :=@TLCLComponentIncLCLRefCount;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TLCLComponentIncLCLRefCount';
//inc(k);
//Methods[k].Name := 'TLCLComponentDecLCLRefCount';
//Methods[k].meth :=@TLCLComponentDecLCLRefCount;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TLCLComponentDecLCLRefCount';
//inc(k);
//Methods[k].Name := 'TLCLComponentgetLCLRefCount';
//Methods[k].meth :=@TLCLComponentgetLCLRefCount;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TLCLComponentgetLCLRefCount';
inc(k);
Methods[k].Name := 'TCustomButtonCreate';
Methods[k].meth :=@TCustomButtonCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonCreate';
inc(k);
Methods[k].Name := 'TCustomButtonClick';
Methods[k].meth :=@TCustomButtonClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonClick';
inc(k);
Methods[k].Name := 'TCustomButtonExecuteDefaultAction';
Methods[k].meth :=@TCustomButtonExecuteDefaultAction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonExecuteDefaultAction';
inc(k);
Methods[k].Name := 'TCustomButtonExecuteCancelAction';
Methods[k].meth :=@TCustomButtonExecuteCancelAction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonExecuteCancelAction';
inc(k);
Methods[k].Name := 'TCustomButtonActiveDefaultControlChanged';
Methods[k].meth :=@TCustomButtonActiveDefaultControlChanged;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonActiveDefaultControlChanged';
inc(k);
Methods[k].Name := 'TCustomButtonUpdateRolesForForm';
Methods[k].meth :=@TCustomButtonUpdateRolesForForm;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonUpdateRolesForForm';
inc(k);
Methods[k].Name := 'TCustomButtongetActive';
Methods[k].meth :=@TCustomButtongetActive;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtongetActive';
inc(k);
Methods[k].Name := 'TCustomButtonsetDefault';
Methods[k].meth :=@TCustomButtonsetDefault;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonsetDefault';
inc(k);
Methods[k].Name := 'TCustomButtongetDefault';
Methods[k].meth :=@TCustomButtongetDefault;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtongetDefault';
inc(k);
Methods[k].Name := 'TCustomButtonsetCancel';
Methods[k].meth :=@TCustomButtonsetCancel;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtonsetCancel';
inc(k);
Methods[k].Name := 'TCustomButtongetCancel';
Methods[k].meth :=@TCustomButtongetCancel;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomButtongetCancel';
inc(k);
Methods[k].Name := 'TCustomLabelCreate';
Methods[k].meth :=@TCustomLabelCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomLabelCreate';
inc(k);
Methods[k].Name := 'TCustomLabelColorIsStored';
Methods[k].meth :=@TCustomLabelColorIsStored;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomLabelColorIsStored';
inc(k);
Methods[k].Name := 'TCustomLabelAdjustFontForOptimalFill';
Methods[k].meth :=@TCustomLabelAdjustFontForOptimalFill;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomLabelAdjustFontForOptimalFill';
inc(k);
Methods[k].Name := 'TCustomLabelPaint';
Methods[k].meth :=@TCustomLabelPaint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomLabelPaint';
inc(k);
Methods[k].Name := 'TCustomLabelSetBounds';
Methods[k].meth :=@TCustomLabelSetBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomLabelSetBounds';
inc(k);
Methods[k].Name := 'TCustomEditCreate';
Methods[k].meth :=@TCustomEditCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditCreate';
inc(k);
Methods[k].Name := 'TCustomEditClear';
Methods[k].meth :=@TCustomEditClear;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditClear';
inc(k);
Methods[k].Name := 'TCustomEditSelectAll';
Methods[k].meth :=@TCustomEditSelectAll;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditSelectAll';
inc(k);
Methods[k].Name := 'TCustomEditClearSelection';
Methods[k].meth :=@TCustomEditClearSelection;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditClearSelection';
inc(k);
Methods[k].Name := 'TCustomEditCopyToClipboard';
Methods[k].meth :=@TCustomEditCopyToClipboard;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditCopyToClipboard';
inc(k);
Methods[k].Name := 'TCustomEditCutToClipboard';
Methods[k].meth :=@TCustomEditCutToClipboard;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditCutToClipboard';
inc(k);
Methods[k].Name := 'TCustomEditPasteFromClipboard';
Methods[k].meth :=@TCustomEditPasteFromClipboard;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditPasteFromClipboard';
inc(k);
Methods[k].Name := 'TCustomEditgetCanUndo';
Methods[k].meth :=@TCustomEditgetCanUndo;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetCanUndo';
inc(k);
Methods[k].Name := 'TCustomEditsetHideSelection';
Methods[k].meth :=@TCustomEditsetHideSelection;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetHideSelection';
inc(k);
Methods[k].Name := 'TCustomEditgetHideSelection';
Methods[k].meth :=@TCustomEditgetHideSelection;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetHideSelection';
inc(k);
Methods[k].Name := 'TCustomEditsetMaxLength';
Methods[k].meth :=@TCustomEditsetMaxLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetMaxLength';
inc(k);
Methods[k].Name := 'TCustomEditgetMaxLength';
Methods[k].meth :=@TCustomEditgetMaxLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetMaxLength';
inc(k);
Methods[k].Name := 'TCustomEditsetModified';
Methods[k].meth :=@TCustomEditsetModified;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetModified';
inc(k);
Methods[k].Name := 'TCustomEditgetModified';
Methods[k].meth :=@TCustomEditgetModified;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetModified';
inc(k);
Methods[k].Name := 'TCustomEditsetNumbersOnly';
Methods[k].meth :=@TCustomEditsetNumbersOnly;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetNumbersOnly';
inc(k);
Methods[k].Name := 'TCustomEditgetNumbersOnly';
Methods[k].meth :=@TCustomEditgetNumbersOnly;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetNumbersOnly';
inc(k);
Methods[k].Name := 'TCustomEditsetOnChange';
Methods[k].meth :=@TCustomEditsetOnChange;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetOnChange';
inc(k);
Methods[k].Name := 'TCustomEditsetReadOnly';
Methods[k].meth :=@TCustomEditsetReadOnly;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetReadOnly';
inc(k);
Methods[k].Name := 'TCustomEditgetReadOnly';
Methods[k].meth :=@TCustomEditgetReadOnly;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetReadOnly';
inc(k);
Methods[k].Name := 'TCustomEditsetSelLength';
Methods[k].meth :=@TCustomEditsetSelLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetSelLength';
inc(k);
Methods[k].Name := 'TCustomEditgetSelLength';
Methods[k].meth :=@TCustomEditgetSelLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetSelLength';
inc(k);
Methods[k].Name := 'TCustomEditsetSelStart';
Methods[k].meth :=@TCustomEditsetSelStart;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetSelStart';
inc(k);
Methods[k].Name := 'TCustomEditgetSelStart';
Methods[k].meth :=@TCustomEditgetSelStart;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetSelStart';
inc(k);
Methods[k].Name := 'TCustomEditsetSelText';
Methods[k].meth :=@TCustomEditsetSelText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetSelText';
inc(k);
Methods[k].Name := 'TCustomEditgetSelText';
Methods[k].meth :=@TCustomEditgetSelText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditgetSelText';
inc(k);
Methods[k].Name := 'TCustomCheckBoxsetAllowGrayed';
Methods[k].meth :=@TCustomCheckBoxsetAllowGrayed;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomCheckBoxsetAllowGrayed';
inc(k);
Methods[k].Name := 'TCustomCheckBoxgetAllowGrayed';
Methods[k].meth :=@TCustomCheckBoxgetAllowGrayed;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomCheckBoxgetAllowGrayed';
inc(k);
Methods[k].Name := 'TCustomListBoxAddItem';
Methods[k].meth :=@TCustomListBoxAddItem;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxAddItem';
inc(k);
Methods[k].Name := 'TCustomListBoxClick';
Methods[k].meth :=@TCustomListBoxClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxClick';
inc(k);
Methods[k].Name := 'TCustomListBoxClear';
Methods[k].meth :=@TCustomListBoxClear;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxClear';
inc(k);
Methods[k].Name := 'TCustomListBoxClearSelection';
Methods[k].meth :=@TCustomListBoxClearSelection;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxClearSelection';
inc(k);
Methods[k].Name := 'TCustomListBoxGetIndexAtXY';
Methods[k].meth :=@TCustomListBoxGetIndexAtXY;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxGetIndexAtXY';
inc(k);
Methods[k].Name := 'TCustomListBoxGetIndexAtY';
Methods[k].meth :=@TCustomListBoxGetIndexAtY;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxGetIndexAtY';
inc(k);
Methods[k].Name := 'TCustomListBoxGetSelectedText';
Methods[k].meth :=@TCustomListBoxGetSelectedText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxGetSelectedText';
inc(k);
Methods[k].Name := 'TCustomListBoxItemVisible';
Methods[k].meth :=@TCustomListBoxItemVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxItemVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxItemFullyVisible';
Methods[k].meth :=@TCustomListBoxItemFullyVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxItemFullyVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxLockSelectionChange';
Methods[k].meth :=@TCustomListBoxLockSelectionChange;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxLockSelectionChange';
inc(k);
Methods[k].Name := 'TCustomListBoxMakeCurrentVisible';
Methods[k].meth :=@TCustomListBoxMakeCurrentVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxMakeCurrentVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxMeasureItem';
Methods[k].meth :=@TCustomListBoxMeasureItem;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxMeasureItem';
inc(k);
Methods[k].Name := 'TCustomListBoxSelectAll';
Methods[k].meth :=@TCustomListBoxSelectAll;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxSelectAll';
inc(k);
Methods[k].Name := 'TCustomListBoxsetColumns';
Methods[k].meth :=@TCustomListBoxsetColumns;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetColumns';
inc(k);
Methods[k].Name := 'TCustomListBoxgetColumns';
Methods[k].meth :=@TCustomListBoxgetColumns;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetColumns';
inc(k);
Methods[k].Name := 'TCustomListBoxgetCount';
Methods[k].meth :=@TCustomListBoxgetCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetCount';
inc(k);
Methods[k].Name := 'TCustomListBoxsetExtendedSelect';
Methods[k].meth :=@TCustomListBoxsetExtendedSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetExtendedSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxgetExtendedSelect';
Methods[k].meth :=@TCustomListBoxgetExtendedSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetExtendedSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxsetIntegralHeight';
Methods[k].meth :=@TCustomListBoxsetIntegralHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetIntegralHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxgetIntegralHeight';
Methods[k].meth :=@TCustomListBoxgetIntegralHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetIntegralHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItemHeight';
Methods[k].meth :=@TCustomListBoxsetItemHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetItemHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItemHeight';
Methods[k].meth :=@TCustomListBoxgetItemHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetItemHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItemIndex';
Methods[k].meth :=@TCustomListBoxsetItemIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetItemIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItemIndex';
Methods[k].meth :=@TCustomListBoxgetItemIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetItemIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItems';
Methods[k].meth :=@TCustomListBoxsetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetItems';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItems';
Methods[k].meth :=@TCustomListBoxgetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetItems';
inc(k);
Methods[k].Name := 'TCustomListBoxsetMultiSelect';
Methods[k].meth :=@TCustomListBoxsetMultiSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetMultiSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxgetMultiSelect';
Methods[k].meth :=@TCustomListBoxgetMultiSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetMultiSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxsetOnDblClick';
Methods[k].meth :=@TCustomListBoxsetOnDblClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetOnDblClick';
inc(k);
Methods[k].Name := 'TCustomListBoxsetOnMouseEnter';
Methods[k].meth :=@TCustomListBoxsetOnMouseEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetOnMouseEnter';
inc(k);
Methods[k].Name := 'TCustomListBoxsetOnMouseLeave';
Methods[k].meth :=@TCustomListBoxsetOnMouseLeave;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetOnMouseLeave';
inc(k);
Methods[k].Name := 'TCustomListBoxsetParentFont';
Methods[k].meth :=@TCustomListBoxsetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetParentFont';
inc(k);
Methods[k].Name := 'TCustomListBoxgetParentFont';
Methods[k].meth :=@TCustomListBoxgetParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetParentFont';
inc(k);
Methods[k].Name := 'TCustomListBoxsetParentShowHint';
Methods[k].meth :=@TCustomListBoxsetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetParentShowHint';
inc(k);
Methods[k].Name := 'TCustomListBoxgetParentShowHint';
Methods[k].meth :=@TCustomListBoxgetParentShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetParentShowHint';
inc(k);
Methods[k].Name := 'TCustomListBoxsetScrollWidth';
Methods[k].meth :=@TCustomListBoxsetScrollWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetScrollWidth';
inc(k);
Methods[k].Name := 'TCustomListBoxgetScrollWidth';
Methods[k].meth :=@TCustomListBoxgetScrollWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetScrollWidth';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSelCount';
Methods[k].meth :=@TCustomListBoxgetSelCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetSelCount';
inc(k);
Methods[k].Name := 'TCustomListBoxsetSelected';
Methods[k].meth :=@TCustomListBoxsetSelected;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetSelected';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSelected';
Methods[k].meth :=@TCustomListBoxgetSelected;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetSelected';
inc(k);
Methods[k].Name := 'TCustomListBoxsetSorted';
Methods[k].meth :=@TCustomListBoxsetSorted;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetSorted';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSorted';
Methods[k].meth :=@TCustomListBoxgetSorted;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetSorted';
inc(k);
Methods[k].Name := 'TCustomListBoxsetTopIndex';
Methods[k].meth :=@TCustomListBoxsetTopIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxsetTopIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxgetTopIndex';
Methods[k].meth :=@TCustomListBoxgetTopIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomListBoxgetTopIndex';
inc(k);
Methods[k].Name := 'TCustomComboBoxIntfGetItems';
Methods[k].meth :=@TCustomComboBoxIntfGetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxIntfGetItems';
inc(k);
Methods[k].Name := 'TCustomComboBoxAddItem';
Methods[k].meth :=@TCustomComboBoxAddItem;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxAddItem';
inc(k);
Methods[k].Name := 'TCustomComboBoxClear';
Methods[k].meth :=@TCustomComboBoxClear;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxClear';
inc(k);
Methods[k].Name := 'TCustomComboBoxClearSelection';
Methods[k].meth :=@TCustomComboBoxClearSelection;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxClearSelection';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetDroppedDown';
Methods[k].meth :=@TCustomComboBoxsetDroppedDown;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetDroppedDown';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetDroppedDown';
Methods[k].meth :=@TCustomComboBoxgetDroppedDown;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetDroppedDown';
inc(k);
Methods[k].Name := 'TCustomComboBoxSelectAll';
Methods[k].meth :=@TCustomComboBoxSelectAll;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxSelectAll';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetAutoSelect';
Methods[k].meth :=@TCustomComboBoxsetAutoSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetAutoSelect';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetAutoSelect';
Methods[k].meth :=@TCustomComboBoxgetAutoSelect;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetAutoSelect';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetAutoSelected';
Methods[k].meth :=@TCustomComboBoxsetAutoSelected;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetAutoSelected';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetAutoSelected';
Methods[k].meth :=@TCustomComboBoxgetAutoSelected;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetAutoSelected';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetDropDownCount';
Methods[k].meth :=@TCustomComboBoxsetDropDownCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetDropDownCount';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetDropDownCount';
Methods[k].meth :=@TCustomComboBoxgetDropDownCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetDropDownCount';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetItems';
Methods[k].meth :=@TCustomComboBoxsetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetItems';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetItems';
Methods[k].meth :=@TCustomComboBoxgetItems;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetItems';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetItemIndex';
Methods[k].meth :=@TCustomComboBoxsetItemIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetItemIndex';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetItemIndex';
Methods[k].meth :=@TCustomComboBoxgetItemIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetItemIndex';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetReadOnly';
Methods[k].meth :=@TCustomComboBoxsetReadOnly;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetReadOnly';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetReadOnly';
Methods[k].meth :=@TCustomComboBoxgetReadOnly;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetReadOnly';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelLength';
Methods[k].meth :=@TCustomComboBoxsetSelLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetSelLength';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelLength';
Methods[k].meth :=@TCustomComboBoxgetSelLength;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetSelLength';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelStart';
Methods[k].meth :=@TCustomComboBoxsetSelStart;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetSelStart';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelStart';
Methods[k].meth :=@TCustomComboBoxgetSelStart;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetSelStart';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelText';
Methods[k].meth :=@TCustomComboBoxsetSelText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxsetSelText';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelText';
Methods[k].meth :=@TCustomComboBoxgetSelText;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomComboBoxgetSelText';
inc(k);
Methods[k].Name := 'TCustomScrollBarCreate';
Methods[k].meth :=@TCustomScrollBarCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBarCreate';
inc(k);
Methods[k].Name := 'TCustomScrollBarSetParams';
Methods[k].meth :=@TCustomScrollBarSetParams;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBarSetParams';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetMax';
Methods[k].meth :=@TCustomScrollBarsetMax;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBarsetMax';
inc(k);
Methods[k].Name := 'TCustomScrollBargetMax';
Methods[k].meth :=@TCustomScrollBargetMax;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBargetMax';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetMin';
Methods[k].meth :=@TCustomScrollBarsetMin;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBarsetMin';
inc(k);
Methods[k].Name := 'TCustomScrollBargetMin';
Methods[k].meth :=@TCustomScrollBargetMin;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBargetMin';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetPageSize';
Methods[k].meth :=@TCustomScrollBarsetPageSize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBarsetPageSize';
inc(k);
Methods[k].Name := 'TCustomScrollBargetPageSize';
Methods[k].meth :=@TCustomScrollBargetPageSize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBargetPageSize';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetPosition';
Methods[k].meth :=@TCustomScrollBarsetPosition;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBarsetPosition';
inc(k);
Methods[k].Name := 'TCustomScrollBargetPosition';
Methods[k].meth :=@TCustomScrollBargetPosition;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBargetPosition';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetOnChange';
Methods[k].meth :=@TCustomScrollBarsetOnChange;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomScrollBarsetOnChange';
inc(k);
Methods[k].Name := 'TCustomMemosetLines';
Methods[k].meth :=@TCustomMemosetLines;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemosetLines';
inc(k);
Methods[k].Name := 'TCustomMemogetLines';
Methods[k].meth :=@TCustomMemogetLines;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemogetLines';
inc(k);
Methods[k].Name := 'TCustomMemosetWantReturns';
Methods[k].meth :=@TCustomMemosetWantReturns;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemosetWantReturns';
inc(k);
Methods[k].Name := 'TCustomMemogetWantReturns';
Methods[k].meth :=@TCustomMemogetWantReturns;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemogetWantReturns';
inc(k);
Methods[k].Name := 'TCustomMemosetWantTabs';
Methods[k].meth :=@TCustomMemosetWantTabs;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemosetWantTabs';
inc(k);
Methods[k].Name := 'TCustomMemogetWantTabs';
Methods[k].meth :=@TCustomMemogetWantTabs;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemogetWantTabs';
inc(k);
Methods[k].Name := 'TCustomMemosetWordWrap';
Methods[k].meth :=@TCustomMemosetWordWrap;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemosetWordWrap';
inc(k);
Methods[k].Name := 'TCustomMemogetWordWrap';
Methods[k].meth :=@TCustomMemogetWordWrap;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomMemogetWordWrap';
inc(k);
Methods[k].Name := 'TScrollingWinControlUpdateScrollbars';
Methods[k].meth :=@TScrollingWinControlUpdateScrollbars;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TScrollingWinControlUpdateScrollbars';
inc(k);
Methods[k].Name := 'TComponentBeforeDestruction';
Methods[k].meth :=@TComponentBeforeDestruction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentBeforeDestruction';
inc(k);
Methods[k].Name := 'TComponentDestroyComponents';
Methods[k].meth :=@TComponentDestroyComponents;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentDestroyComponents';
inc(k);
Methods[k].Name := 'TComponentDestroying';
Methods[k].meth :=@TComponentDestroying;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentDestroying';
inc(k);
Methods[k].Name := 'TComponentFindComponent';
Methods[k].meth :=@TComponentFindComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentFindComponent';
inc(k);
Methods[k].Name := 'TComponentFreeNotification';
Methods[k].meth :=@TComponentFreeNotification;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentFreeNotification';
inc(k);
Methods[k].Name := 'TComponentRemoveFreeNotification';
Methods[k].meth :=@TComponentRemoveFreeNotification;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentRemoveFreeNotification';
inc(k);
Methods[k].Name := 'TComponentFreeOnRelease';
Methods[k].meth :=@TComponentFreeOnRelease;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentFreeOnRelease';
inc(k);
Methods[k].Name := 'TComponentGetNamePath';
Methods[k].meth :=@TComponentGetNamePath;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentGetNamePath';
inc(k);
Methods[k].Name := 'TComponentGetParentComponent';
Methods[k].meth :=@TComponentGetParentComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentGetParentComponent';
inc(k);
Methods[k].Name := 'TComponentHasParent';
Methods[k].meth :=@TComponentHasParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentHasParent';
inc(k);
Methods[k].Name := 'TComponentInsertComponent';
Methods[k].meth :=@TComponentInsertComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentInsertComponent';
inc(k);
Methods[k].Name := 'TComponentRemoveComponent';
Methods[k].meth :=@TComponentRemoveComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentRemoveComponent';
inc(k);
Methods[k].Name := 'TComponentSetSubComponent';
Methods[k].meth :=@TComponentSetSubComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentSetSubComponent';
inc(k);
Methods[k].Name := 'TComponentgetComponents';
Methods[k].meth :=@TComponentgetComponents;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentgetComponents';
inc(k);
Methods[k].Name := 'TComponentgetComponentCount';
Methods[k].meth :=@TComponentgetComponentCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentgetComponentCount';
inc(k);
Methods[k].Name := 'TComponentsetComponentIndex';
Methods[k].meth :=@TComponentsetComponentIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentsetComponentIndex';
inc(k);
Methods[k].Name := 'TComponentgetComponentIndex';
Methods[k].meth :=@TComponentgetComponentIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentgetComponentIndex';
inc(k);
Methods[k].Name := 'TComponentgetOwner';
Methods[k].meth :=@TComponentgetOwner;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TComponentgetOwner';
inc(k);
Methods[k].Name := 'TButtonControlCreate';
Methods[k].meth :=@TButtonControlCreate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TButtonControlCreate';
inc(k);
Methods[k].Name := 'TWinControlgetBoundsLockCount';
Methods[k].meth :=@TWinControlgetBoundsLockCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetBoundsLockCount';
inc(k);
Methods[k].Name := 'TWinControlgetCachedClientHeight';
Methods[k].meth :=@TWinControlgetCachedClientHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetCachedClientHeight';
inc(k);
Methods[k].Name := 'TWinControlgetCachedClientWidth';
Methods[k].meth :=@TWinControlgetCachedClientWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetCachedClientWidth';
inc(k);
Methods[k].Name := 'TWinControlgetControlCount';
Methods[k].meth :=@TWinControlgetControlCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetControlCount';
inc(k);
Methods[k].Name := 'TWinControlgetControls';
Methods[k].meth :=@TWinControlgetControls;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetControls';
inc(k);
Methods[k].Name := 'TWinControlgetDockClientCount';
Methods[k].meth :=@TWinControlgetDockClientCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetDockClientCount';
inc(k);
Methods[k].Name := 'TWinControlgetDockClients';
Methods[k].meth :=@TWinControlgetDockClients;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetDockClients';
inc(k);
Methods[k].Name := 'TWinControlsetDockSite';
Methods[k].meth :=@TWinControlsetDockSite;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetDockSite';
inc(k);
Methods[k].Name := 'TWinControlgetDockSite';
Methods[k].meth :=@TWinControlgetDockSite;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetDockSite';
inc(k);
Methods[k].Name := 'TWinControlsetDoubleBuffered';
Methods[k].meth :=@TWinControlsetDoubleBuffered;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetDoubleBuffered';
inc(k);
Methods[k].Name := 'TWinControlgetDoubleBuffered';
Methods[k].meth :=@TWinControlgetDoubleBuffered;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetDoubleBuffered';
inc(k);
Methods[k].Name := 'TWinControlgetIsResizing';
Methods[k].meth :=@TWinControlgetIsResizing;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetIsResizing';
inc(k);
Methods[k].Name := 'TWinControlsetTabStop';
Methods[k].meth :=@TWinControlsetTabStop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetTabStop';
inc(k);
Methods[k].Name := 'TWinControlgetTabStop';
Methods[k].meth :=@TWinControlgetTabStop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetTabStop';
inc(k);
Methods[k].Name := 'TWinControlsetOnEnter';
Methods[k].meth :=@TWinControlsetOnEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetOnEnter';
inc(k);
Methods[k].Name := 'TWinControlsetOnExit';
Methods[k].meth :=@TWinControlsetOnExit;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetOnExit';
inc(k);
Methods[k].Name := 'TWinControlgetShowing';
Methods[k].meth :=@TWinControlgetShowing;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetShowing';
inc(k);
Methods[k].Name := 'TWinControlsetDesignerDeleting';
Methods[k].meth :=@TWinControlsetDesignerDeleting;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetDesignerDeleting';
inc(k);
Methods[k].Name := 'TWinControlgetDesignerDeleting';
Methods[k].meth :=@TWinControlgetDesignerDeleting;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlgetDesignerDeleting';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayed';
Methods[k].meth :=@TWinControlAutoSizeDelayed;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlAutoSizeDelayed';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayedReport';
Methods[k].meth :=@TWinControlAutoSizeDelayedReport;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlAutoSizeDelayedReport';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayedHandle';
Methods[k].meth :=@TWinControlAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TWinControlBeginUpdateBounds';
Methods[k].meth :=@TWinControlBeginUpdateBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlBeginUpdateBounds';
inc(k);
Methods[k].Name := 'TWinControlEndUpdateBounds';
Methods[k].meth :=@TWinControlEndUpdateBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlEndUpdateBounds';
inc(k);
Methods[k].Name := 'TWinControlLockRealizeBounds';
Methods[k].meth :=@TWinControlLockRealizeBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlLockRealizeBounds';
inc(k);
Methods[k].Name := 'TWinControlUnlockRealizeBounds';
Methods[k].meth :=@TWinControlUnlockRealizeBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlUnlockRealizeBounds';
inc(k);
Methods[k].Name := 'TWinControlContainsControl';
Methods[k].meth :=@TWinControlContainsControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlContainsControl';
inc(k);
Methods[k].Name := 'TWinControlDoAdjustClientRectChange';
Methods[k].meth :=@TWinControlDoAdjustClientRectChange;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlDoAdjustClientRectChange';
inc(k);
Methods[k].Name := 'TWinControlInvalidateClientRectCache';
Methods[k].meth :=@TWinControlInvalidateClientRectCache;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlInvalidateClientRectCache';
inc(k);
Methods[k].Name := 'TWinControlClientRectNeedsInterfaceUpdate';
Methods[k].meth :=@TWinControlClientRectNeedsInterfaceUpdate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlClientRectNeedsInterfaceUpdate';
inc(k);
Methods[k].Name := 'TWinControlSetBounds';
Methods[k].meth :=@TWinControlSetBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlSetBounds';
inc(k);
Methods[k].Name := 'TWinControlDisableAlign';
Methods[k].meth :=@TWinControlDisableAlign;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlDisableAlign';
inc(k);
Methods[k].Name := 'TWinControlEnableAlign';
Methods[k].meth :=@TWinControlEnableAlign;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlEnableAlign';
inc(k);
Methods[k].Name := 'TWinControlReAlign';
Methods[k].meth :=@TWinControlReAlign;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlReAlign';
inc(k);
Methods[k].Name := 'TWinControlScrollBy';
Methods[k].meth :=@TWinControlScrollBy;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlScrollBy';
inc(k);
Methods[k].Name := 'TWinControlWriteLayoutDebugReport';
Methods[k].meth :=@TWinControlWriteLayoutDebugReport;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlWriteLayoutDebugReport';
inc(k);
Methods[k].Name := 'TWinControlCanFocus';
Methods[k].meth :=@TWinControlCanFocus;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlCanFocus';
inc(k);
Methods[k].Name := 'TWinControlGetControlIndex';
Methods[k].meth :=@TWinControlGetControlIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlGetControlIndex';
inc(k);
Methods[k].Name := 'TWinControlSetControlIndex';
Methods[k].meth :=@TWinControlSetControlIndex;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlSetControlIndex';
inc(k);
Methods[k].Name := 'TWinControlFocused';
Methods[k].meth :=@TWinControlFocused;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlFocused';
inc(k);
Methods[k].Name := 'TWinControlPerformTab';
Methods[k].meth :=@TWinControlPerformTab;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlPerformTab';
inc(k);
Methods[k].Name := 'TWinControlFindChildControl';
Methods[k].meth :=@TWinControlFindChildControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlFindChildControl';
//inc(k);
//Methods[k].Name := 'TWinControlBroadCast';
//Methods[k].meth :=@TWinControlBroadCast;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TWinControlBroadCast';
//inc(k);
//Methods[k].Name := 'TWinControlDefaultHandler';
//Methods[k].meth :=@TWinControlDefaultHandler;
//Methods[k].flags := METH_VARARGS;
// Methods[k].doc := 'TWinControlDefaultHandler';
inc(k);
Methods[k].Name := 'TWinControlGetTextLen';
Methods[k].meth :=@TWinControlGetTextLen;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlGetTextLen';
inc(k);
Methods[k].Name := 'TWinControlInvalidate';
Methods[k].meth :=@TWinControlInvalidate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlInvalidate';
inc(k);
Methods[k].Name := 'TWinControlAddControl';
Methods[k].meth :=@TWinControlAddControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlAddControl';
inc(k);
Methods[k].Name := 'TWinControlInsertControl';
Methods[k].meth :=@TWinControlInsertControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlInsertControl';
inc(k);
Methods[k].Name := 'TWinControlRepaint';
Methods[k].meth :=@TWinControlRepaint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlRepaint';
inc(k);
Methods[k].Name := 'TWinControlUpdate';
Methods[k].meth :=@TWinControlUpdate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlUpdate';
inc(k);
Methods[k].Name := 'TWinControlSetFocus';
Methods[k].meth :=@TWinControlSetFocus;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlSetFocus';
inc(k);
Methods[k].Name := 'TWinControlFlipChildren';
Methods[k].meth :=@TWinControlFlipChildren;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlFlipChildren';
inc(k);
Methods[k].Name := 'TWinControlScaleBy';
Methods[k].meth :=@TWinControlScaleBy;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlScaleBy';
inc(k);
Methods[k].Name := 'TWinControlGetDockCaption';
Methods[k].meth :=@TWinControlGetDockCaption;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlGetDockCaption';
inc(k);
Methods[k].Name := 'TWinControlUpdateDockCaption';
Methods[k].meth :=@TWinControlUpdateDockCaption;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlUpdateDockCaption';
inc(k);
Methods[k].Name := 'TWinControlHandleAllocated';
Methods[k].meth :=@TWinControlHandleAllocated;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlHandleAllocated';
inc(k);
Methods[k].Name := 'TWinControlParentHandlesAllocated';
Methods[k].meth :=@TWinControlParentHandlesAllocated;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlParentHandlesAllocated';
inc(k);
Methods[k].Name := 'TWinControlHandleNeeded';
Methods[k].meth :=@TWinControlHandleNeeded;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlHandleNeeded';
inc(k);
Methods[k].Name := 'TWinControlBrushCreated';
Methods[k].meth :=@TWinControlBrushCreated;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlBrushCreated';
inc(k);
Methods[k].Name := 'TWinControlIntfGetDropFilesTarget';
Methods[k].meth :=@TWinControlIntfGetDropFilesTarget;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlIntfGetDropFilesTarget';
inc(k);
Methods[k].Name := 'TCustomEditsetOnChange';
Methods[k].meth :=@TCustomEditsetOnChange;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomEditsetOnChange';
inc(k);
Methods[k].Name := 'TCustomControlsetOnPaint';
Methods[k].meth :=@TCustomControlsetOnPaint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TCustomControlsetOnPaint';
inc(k);
Methods[k].Name := 'TControlDragDrop';
Methods[k].meth :=@TControlDragDrop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlDragDrop';
inc(k);
Methods[k].Name := 'TControlAdjustSize';
Methods[k].meth :=@TControlAdjustSize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAdjustSize';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayed';
Methods[k].meth :=@TControlAutoSizeDelayed;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAutoSizeDelayed';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayedReport';
Methods[k].meth :=@TControlAutoSizeDelayedReport;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAutoSizeDelayedReport';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayedHandle';
Methods[k].meth :=@TControlAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TControlAnchorHorizontalCenterTo';
Methods[k].meth :=@TControlAnchorHorizontalCenterTo;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAnchorHorizontalCenterTo';
inc(k);
Methods[k].Name := 'TControlAnchorVerticalCenterTo';
Methods[k].meth :=@TControlAnchorVerticalCenterTo;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAnchorVerticalCenterTo';
inc(k);
Methods[k].Name := 'TControlAnchorClient';
Methods[k].meth :=@TControlAnchorClient;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAnchorClient';
inc(k);
Methods[k].Name := 'TControlAnchoredControlCount';
Methods[k].meth :=@TControlAnchoredControlCount;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlAnchoredControlCount';
inc(k);
Methods[k].Name := 'TControlgetAnchoredControls';
Methods[k].meth :=@TControlgetAnchoredControls;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetAnchoredControls';
inc(k);
Methods[k].Name := 'TControlSetBounds';
Methods[k].meth :=@TControlSetBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlSetBounds';
inc(k);
Methods[k].Name := 'TControlSetInitialBounds';
Methods[k].meth :=@TControlSetInitialBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlSetInitialBounds';
inc(k);
Methods[k].Name := 'TControlGetDefaultWidth';
Methods[k].meth :=@TControlGetDefaultWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlGetDefaultWidth';
inc(k);
Methods[k].Name := 'TControlGetDefaultHeight';
Methods[k].meth :=@TControlGetDefaultHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlGetDefaultHeight';
inc(k);
Methods[k].Name := 'TControlCNPreferredSizeChanged';
Methods[k].meth :=@TControlCNPreferredSizeChanged;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlCNPreferredSizeChanged';
inc(k);
Methods[k].Name := 'TControlInvalidatePreferredSize';
Methods[k].meth :=@TControlInvalidatePreferredSize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlInvalidatePreferredSize';
inc(k);
Methods[k].Name := 'TControlWriteLayoutDebugReport';
Methods[k].meth :=@TControlWriteLayoutDebugReport;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlWriteLayoutDebugReport';
inc(k);
Methods[k].Name := 'TControlShouldAutoAdjustLeftAndTop';
Methods[k].meth :=@TControlShouldAutoAdjustLeftAndTop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlShouldAutoAdjustLeftAndTop';
inc(k);
Methods[k].Name := 'TControlBeforeDestruction';
Methods[k].meth :=@TControlBeforeDestruction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlBeforeDestruction';
inc(k);
Methods[k].Name := 'TControlEditingDone';
Methods[k].meth :=@TControlEditingDone;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlEditingDone';
inc(k);
Methods[k].Name := 'TControlExecuteDefaultAction';
Methods[k].meth :=@TControlExecuteDefaultAction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlExecuteDefaultAction';
inc(k);
Methods[k].Name := 'TControlExecuteCancelAction';
Methods[k].meth :=@TControlExecuteCancelAction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlExecuteCancelAction';
inc(k);
Methods[k].Name := 'TControlBeginDrag';
Methods[k].meth :=@TControlBeginDrag;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlBeginDrag';
inc(k);
Methods[k].Name := 'TControlEndDrag';
Methods[k].meth :=@TControlEndDrag;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlEndDrag';
inc(k);
Methods[k].Name := 'TControlBringToFront';
Methods[k].meth :=@TControlBringToFront;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlBringToFront';
inc(k);
Methods[k].Name := 'TControlHasParent';
Methods[k].meth :=@TControlHasParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlHasParent';
inc(k);
Methods[k].Name := 'TControlGetParentComponent';
Methods[k].meth :=@TControlGetParentComponent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlGetParentComponent';
inc(k);
Methods[k].Name := 'TControlIsParentOf';
Methods[k].meth :=@TControlIsParentOf;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsParentOf';
inc(k);
Methods[k].Name := 'TControlGetTopParent';
Methods[k].meth :=@TControlGetTopParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlGetTopParent';
inc(k);
Methods[k].Name := 'TControlIsVisible';
Methods[k].meth :=@TControlIsVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsVisible';
inc(k);
Methods[k].Name := 'TControlIsControlVisible';
Methods[k].meth :=@TControlIsControlVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsControlVisible';
inc(k);
Methods[k].Name := 'TControlIsEnabled';
Methods[k].meth :=@TControlIsEnabled;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsEnabled';
inc(k);
Methods[k].Name := 'TControlIsParentColor';
Methods[k].meth :=@TControlIsParentColor;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsParentColor';
inc(k);
Methods[k].Name := 'TControlIsParentFont';
Methods[k].meth :=@TControlIsParentFont;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsParentFont';
inc(k);
Methods[k].Name := 'TControlFormIsUpdating';
Methods[k].meth :=@TControlFormIsUpdating;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlFormIsUpdating';
inc(k);
Methods[k].Name := 'TControlIsProcessingPaintMsg';
Methods[k].meth :=@TControlIsProcessingPaintMsg;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsProcessingPaintMsg';
inc(k);
Methods[k].Name := 'TControlHide';
Methods[k].meth :=@TControlHide;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlHide';
inc(k);
Methods[k].Name := 'TControlRefresh';
Methods[k].meth :=@TControlRefresh;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlRefresh';
inc(k);
Methods[k].Name := 'TControlRepaint';
Methods[k].meth :=@TControlRepaint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlRepaint';
inc(k);
Methods[k].Name := 'TControlInvalidate';
Methods[k].meth :=@TControlInvalidate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlInvalidate';
inc(k);
Methods[k].Name := 'TControlCheckNewParent';
Methods[k].meth :=@TControlCheckNewParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlCheckNewParent';
inc(k);
Methods[k].Name := 'TControlSendToBack';
Methods[k].meth :=@TControlSendToBack;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlSendToBack';
inc(k);
Methods[k].Name := 'TControlUpdateRolesForForm';
Methods[k].meth :=@TControlUpdateRolesForForm;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlUpdateRolesForForm';
inc(k);
Methods[k].Name := 'TControlActiveDefaultControlChanged';
Methods[k].meth :=@TControlActiveDefaultControlChanged;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlActiveDefaultControlChanged';
inc(k);
Methods[k].Name := 'TControlGetTextLen';
Methods[k].meth :=@TControlGetTextLen;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlGetTextLen';
inc(k);
Methods[k].Name := 'TControlShow';
Methods[k].meth :=@TControlShow;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlShow';
inc(k);
Methods[k].Name := 'TControlUpdate';
Methods[k].meth :=@TControlUpdate;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlUpdate';
inc(k);
Methods[k].Name := 'TControlHandleObjectShouldBeVisible';
Methods[k].meth :=@TControlHandleObjectShouldBeVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlHandleObjectShouldBeVisible';
inc(k);
Methods[k].Name := 'TControlParentDestroyingHandle';
Methods[k].meth :=@TControlParentDestroyingHandle;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlParentDestroyingHandle';
inc(k);
Methods[k].Name := 'TControlParentHandlesAllocated';
Methods[k].meth :=@TControlParentHandlesAllocated;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlParentHandlesAllocated';
inc(k);
Methods[k].Name := 'TControlInitiateAction';
Methods[k].meth :=@TControlInitiateAction;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlInitiateAction';
inc(k);
Methods[k].Name := 'TControlShowHelp';
Methods[k].meth :=@TControlShowHelp;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlShowHelp';
inc(k);
Methods[k].Name := 'TControlRemoveAllHandlersOfObject';
Methods[k].meth :=@TControlRemoveAllHandlersOfObject;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlRemoveAllHandlersOfObject';
inc(k);
Methods[k].Name := 'TControlsetAccessibleDescription';
Methods[k].meth :=@TControlsetAccessibleDescription;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetAccessibleDescription';
inc(k);
Methods[k].Name := 'TControlgetAccessibleDescription';
Methods[k].meth :=@TControlgetAccessibleDescription;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetAccessibleDescription';
inc(k);
Methods[k].Name := 'TControlsetAccessibleValue';
Methods[k].meth :=@TControlsetAccessibleValue;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetAccessibleValue';
inc(k);
Methods[k].Name := 'TControlgetAccessibleValue';
Methods[k].meth :=@TControlgetAccessibleValue;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetAccessibleValue';
inc(k);
Methods[k].Name := 'TControlsetAutoSize';
Methods[k].meth :=@TControlsetAutoSize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetAutoSize';
inc(k);
Methods[k].Name := 'TControlgetAutoSize';
Methods[k].meth :=@TControlgetAutoSize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetAutoSize';
inc(k);
Methods[k].Name := 'TControlsetCaption';
Methods[k].meth :=@TControlsetCaption;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetCaption';
inc(k);
Methods[k].Name := 'TControlgetCaption';
Methods[k].meth :=@TControlgetCaption;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetCaption';
inc(k);
Methods[k].Name := 'TControlsetClientHeight';
Methods[k].meth :=@TControlsetClientHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetClientHeight';
inc(k);
Methods[k].Name := 'TControlgetClientHeight';
Methods[k].meth :=@TControlgetClientHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetClientHeight';
inc(k);
Methods[k].Name := 'TControlsetClientWidth';
Methods[k].meth :=@TControlsetClientWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetClientWidth';
inc(k);
Methods[k].Name := 'TControlgetClientWidth';
Methods[k].meth :=@TControlgetClientWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetClientWidth';
inc(k);
Methods[k].Name := 'TControlsetEnabled';
Methods[k].meth :=@TControlsetEnabled;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetEnabled';
inc(k);
Methods[k].Name := 'TControlgetEnabled';
Methods[k].meth :=@TControlgetEnabled;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetEnabled';
inc(k);
Methods[k].Name := 'TControlsetIsControl';
Methods[k].meth :=@TControlsetIsControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetIsControl';
inc(k);
Methods[k].Name := 'TControlgetIsControl';
Methods[k].meth :=@TControlgetIsControl;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetIsControl';
inc(k);
Methods[k].Name := 'TControlgetMouseEntered';
Methods[k].meth :=@TControlgetMouseEntered;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetMouseEntered';
inc(k);
Methods[k].Name := 'TControlsetOnChangeBounds';
Methods[k].meth :=@TControlsetOnChangeBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetOnChangeBounds';
inc(k);
Methods[k].Name := 'TControlsetOnClick';
Methods[k].meth :=@TControlsetOnClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetOnClick';
inc(k);
Methods[k].Name := 'TControlsetOnResize';
Methods[k].meth :=@TControlsetOnResize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetOnResize';
inc(k);
Methods[k].Name := 'TControlsetParent';
Methods[k].meth :=@TControlsetParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetParent';
inc(k);
Methods[k].Name := 'TControlgetParent';
Methods[k].meth :=@TControlgetParent;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetParent';
inc(k);
Methods[k].Name := 'TControlsetPopupMenu';
Methods[k].meth :=@TControlsetPopupMenu;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetPopupMenu';
inc(k);
Methods[k].Name := 'TControlgetPopupMenu';
Methods[k].meth :=@TControlgetPopupMenu;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetPopupMenu';
inc(k);
Methods[k].Name := 'TControlsetShowHint';
Methods[k].meth :=@TControlsetShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetShowHint';
inc(k);
Methods[k].Name := 'TControlgetShowHint';
Methods[k].meth :=@TControlgetShowHint;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetShowHint';
inc(k);
Methods[k].Name := 'TControlsetVisible';
Methods[k].meth :=@TControlsetVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetVisible';
inc(k);
Methods[k].Name := 'TControlgetVisible';
Methods[k].meth :=@TControlgetVisible;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetVisible';
inc(k);
Methods[k].Name := 'TControlgetFloating';
Methods[k].meth :=@TControlgetFloating;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetFloating';
inc(k);
Methods[k].Name := 'TControlsetHostDockSite';
Methods[k].meth :=@TControlsetHostDockSite;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetHostDockSite';
inc(k);
Methods[k].Name := 'TControlgetHostDockSite';
Methods[k].meth :=@TControlgetHostDockSite;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetHostDockSite';
inc(k);
Methods[k].Name := 'TControlsetLRDockWidth';
Methods[k].meth :=@TControlsetLRDockWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetLRDockWidth';
inc(k);
Methods[k].Name := 'TControlgetLRDockWidth';
Methods[k].meth :=@TControlgetLRDockWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetLRDockWidth';
inc(k);
Methods[k].Name := 'TControlsetTBDockHeight';
Methods[k].meth :=@TControlsetTBDockHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetTBDockHeight';
inc(k);
Methods[k].Name := 'TControlgetTBDockHeight';
Methods[k].meth :=@TControlgetTBDockHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetTBDockHeight';
inc(k);
Methods[k].Name := 'TControlsetUndockHeight';
Methods[k].meth :=@TControlsetUndockHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetUndockHeight';
inc(k);
Methods[k].Name := 'TControlgetUndockHeight';
Methods[k].meth :=@TControlgetUndockHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetUndockHeight';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftAlignment';
Methods[k].meth :=@TControlUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftReading';
Methods[k].meth :=@TControlUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftScrollBar';
Methods[k].meth :=@TControlUseRightToLeftScrollBar;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlUseRightToLeftScrollBar';
inc(k);
Methods[k].Name := 'TControlIsRightToLeft';
Methods[k].meth :=@TControlIsRightToLeft;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlIsRightToLeft';
inc(k);
Methods[k].Name := 'TControlsetLeft';
Methods[k].meth :=@TControlsetLeft;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetLeft';
inc(k);
Methods[k].Name := 'TControlgetLeft';
Methods[k].meth :=@TControlgetLeft;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetLeft';
inc(k);
Methods[k].Name := 'TControlsetHeight';
Methods[k].meth :=@TControlsetHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetHeight';
inc(k);
Methods[k].Name := 'TControlgetHeight';
Methods[k].meth :=@TControlgetHeight;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetHeight';
inc(k);
Methods[k].Name := 'TControlsetTop';
Methods[k].meth :=@TControlsetTop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetTop';
inc(k);
Methods[k].Name := 'TControlgetTop';
Methods[k].meth :=@TControlgetTop;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetTop';
inc(k);
Methods[k].Name := 'TControlsetWidth';
Methods[k].meth :=@TControlsetWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetWidth';
inc(k);
Methods[k].Name := 'TControlgetWidth';
Methods[k].meth :=@TControlgetWidth;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetWidth';
inc(k);
Methods[k].Name := 'TControlsetHelpKeyword';
Methods[k].meth :=@TControlsetHelpKeyword;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetHelpKeyword';
inc(k);
Methods[k].Name := 'TControlgetHelpKeyword';
Methods[k].meth :=@TControlgetHelpKeyword;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlgetHelpKeyword';
inc(k);
Methods[k].Name := 'TWinControlsetOnEnter';
Methods[k].meth :=@TWinControlsetOnEnter;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetOnEnter';
inc(k);
Methods[k].Name := 'TWinControlsetOnExit';
Methods[k].meth :=@TWinControlsetOnExit;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TWinControlsetOnExit';
inc(k);
Methods[k].Name := 'TControlsetOnChangeBounds';
Methods[k].meth :=@TControlsetOnChangeBounds;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetOnChangeBounds';
inc(k);
Methods[k].Name := 'TControlsetOnClick';
Methods[k].meth :=@TControlsetOnClick;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetOnClick';
inc(k);
Methods[k].Name := 'TControlsetOnResize';
Methods[k].meth :=@TControlsetOnResize;
Methods[k].flags := METH_VARARGS;
 Methods[k].doc := 'TControlsetOnResize';
    Inc(k);
    Methods[k].Name := 'Create_FormLfm';
    Methods[k].meth := @Create_FormLfm;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'creat formlfm';
    Inc(k);
    Methods[k].Name := nil;
    Methods[k].meth := nil;
    Methods[k].flags := 0;
    Methods[k].doc := nil;

    numofcall := 0;
    laz4pyobj := Tlaz4py.Create();
    Py_InitModule('PyMinMod', Methods[0]);
  end;


exports
  initPyMinMod;

end.
