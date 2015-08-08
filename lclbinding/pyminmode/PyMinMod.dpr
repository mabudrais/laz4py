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
  {TpyTbuttonUnit,
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
  reginterfaceunit, }
  ObjserUnit,
  Dialogs,pyutil,Menus,LCLClasses;

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
   // inter: Treginterface;
  begin
    //regall(k, Methods);
    //pyedit:=Tpyedit.create(Nil);
    //pyedit.reg(k,Methods);
    //inter := TFormpy.Create(nil);
  end;

function TWinControlgetBoundsLockCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).BoundsLockCount);
end;
function TWinControlgetCachedClientHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).CachedClientHeight);
end;
function TWinControlgetCachedClientWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).CachedClientWidth);
end;
function TWinControlgetControlCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).ControlCount);
end;
function TWinControlgetDockClientCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).DockClientCount);
end;
function TWinControlsetDockSite(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DockSite:=para50;
Result := PyInt_FromLong(0);
end;
function TWinControlgetDockSite(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).DockSite));
end;
function TWinControlsetDoubleBuffered(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DoubleBuffered:=para50;
Result := PyInt_FromLong(0);
end;
function TWinControlgetDoubleBuffered(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).DoubleBuffered));
end;
function TWinControlgetIsResizing(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).IsResizing));
end;
function TWinControlsetTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).TabStop:=para50;
Result := PyInt_FromLong(0);
end;
function TWinControlgetTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).TabStop));
end;
function TWinControlgetShowing(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).Showing));
end;
function TWinControlsetDesignerDeleting(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DesignerDeleting:=para50;
Result := PyInt_FromLong(0);
end;
function TWinControlgetDesignerDeleting(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).DesignerDeleting));
end;
function TWinControlAutoSizeDelayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).AutoSizeDelayed));
end;
function TWinControlAutoSizeDelayedReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TWinControl(Pointer(control_p)).AutoSizeDelayedReport)));
end;
function TWinControlAutoSizeDelayedHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).AutoSizeDelayedHandle));
end;
function TWinControlBeginUpdateBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).BeginUpdateBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlEndUpdateBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).EndUpdateBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlLockRealizeBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).LockRealizeBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlUnlockRealizeBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).UnlockRealizeBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlDoAdjustClientRectChange(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DoAdjustClientRectChange(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlInvalidateClientRectCache(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).InvalidateClientRectCache(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlClientRectNeedsInterfaceUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).ClientRectNeedsInterfaceUpdate));
end;
function TWinControlSetBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TWinControl(Pointer(control_p)).SetBounds(para47,para48,para49,para50);
Result := PyInt_FromLong(0);
end;
function TWinControlDisableAlign(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).DisableAlign();
Result := PyInt_FromLong(0);
end;
function TWinControlEnableAlign(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).EnableAlign();
Result := PyInt_FromLong(0);
end;
function TWinControlReAlign(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).ReAlign();
Result := PyInt_FromLong(0);
end;
function TWinControlScrollBy(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TWinControl(Pointer(control_p)).ScrollBy(para49,para50);
Result := PyInt_FromLong(0);
end;
function TWinControlWriteLayoutDebugReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:string;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TWinControl(Pointer(control_p)).WriteLayoutDebugReport(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlCanFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).CanFocus));
end;
function TWinControlFocused(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).Focused));
end;
function TWinControlPerformTab(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).PerformTab(para50)));
end;
{function TWinControlBroadCast(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).BroadCast();
Result := PyInt_FromLong(0);
end;
function TWinControlDefaultHandler(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).DefaultHandler();
Result := PyInt_FromLong(0);
end;          }
function TWinControlGetTextLen(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).GetTextLen);
end;
function TWinControlInvalidate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).Invalidate();
Result := PyInt_FromLong(0);
end;
function TWinControlAddControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).AddControl();
Result := PyInt_FromLong(0);
end;
function TWinControlRepaint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).Repaint();
Result := PyInt_FromLong(0);
end;
function TWinControlUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).Update();
Result := PyInt_FromLong(0);
end;
function TWinControlSetFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).SetFocus();
Result := PyInt_FromLong(0);
end;
function TWinControlFlipChildren(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).FlipChildren(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlScaleBy(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TWinControl(Pointer(control_p)).ScaleBy(para49,para50);
Result := PyInt_FromLong(0);
end;
function TWinControlHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).HandleAllocated));
end;
function TWinControlParentHandlesAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).ParentHandlesAllocated));
end;
function TWinControlHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TWinControlBrushCreated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).BrushCreated));
end;
function TPopupMenuPopUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TPopupMenu(Pointer(control_p)).PopUp();
Result := PyInt_FromLong(0);
end;
{function TPopupMenuPopUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TPopupMenu(Pointer(control_p)).PopUp(para49,para50);
Result := PyInt_FromLong(0);
end;        }
function TPopupMenusetAutoPopup(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TPopupMenu(Pointer(control_p)).AutoPopup:=para50;
Result := PyInt_FromLong(0);
end;
function TPopupMenugetAutoPopup(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TPopupMenu(Pointer(control_p)).AutoPopup));
end;
function TMenuItemGetIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).GetIsRightToLeft));
end;
function TMenuItemHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HandleAllocated));
end;
function TMenuItemHasIcon(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HasIcon));
end;
function TMenuItemHasParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HasParent));
end;
function TMenuItemInitiateAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).InitiateAction();
Result := PyInt_FromLong(0);
end;
function TMenuItemIntfDoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).IntfDoSelect();
Result := PyInt_FromLong(0);
end;
function TMenuItemIndexOfCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:string;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).IndexOfCaption(para50));
end;
function TMenuItemAddSeparator(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).AddSeparator();
Result := PyInt_FromLong(0);
end;
function TMenuItemClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).Click();
Result := PyInt_FromLong(0);
end;
function TMenuItemDelete(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).Delete(para50);
Result := PyInt_FromLong(0);
end;
function TMenuItemHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TMenuItemRecreateHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).RecreateHandle();
Result := PyInt_FromLong(0);
end;
function TMenuItemIsCheckItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).IsCheckItem));
end;
function TMenuItemIsLine(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).IsLine));
end;
function TMenuItemIsInMenuBar(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).IsInMenuBar));
end;
function TMenuItemClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TMenuItemHasBitmap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HasBitmap));
end;
function TMenuItemgetCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).Count);
end;
function TMenuItemsetMenuIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).MenuIndex:=para50;
Result := PyInt_FromLong(0);
end;
function TMenuItemgetMenuIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).MenuIndex);
end;
function TMenuItemMenuVisibleIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).MenuVisibleIndex);
end;
function TMenuItemsetAutoCheck(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).AutoCheck:=para50;
Result := PyInt_FromLong(0);
end;
function TMenuItemgetAutoCheck(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).AutoCheck));
end;
function TMenuItemsetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).Default:=para50;
Result := PyInt_FromLong(0);
end;
function TMenuItemgetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).Default));
end;
function TMenuItemsetRadioItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).RadioItem:=para50;
Result := PyInt_FromLong(0);
end;
function TMenuItemgetRadioItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).RadioItem));
end;
function TMenuItemsetRightJustify(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).RightJustify:=para50;
Result := PyInt_FromLong(0);
end;
function TMenuItemgetRightJustify(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).RightJustify));
end;
function TMenuDestroyHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenu(Pointer(control_p)).DestroyHandle();
Result := PyInt_FromLong(0);
end;
function TMenuHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).HandleAllocated));
end;
function TMenuIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).IsRightToLeft));
end;
function TMenuUseRightToLeftAlignment(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).UseRightToLeftAlignment));
end;
function TMenuUseRightToLeftReading(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).UseRightToLeftReading));
end;
function TMenuHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenu(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TMenusetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenu(Pointer(control_p)).ParentBidiMode:=para50;
Result := PyInt_FromLong(0);
end;
function TMenugetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).ParentBidiMode));
end;
function TMainMenugetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMainMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMainMenu(Pointer(control_p)).Height);
end;
{function TLCLComponentDestroyHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TLCLComponent(Pointer(control_p)).DestroyHandle();
Result := PyInt_FromLong(0);
end;
function TLCLComponentHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).HandleAllocated));
end;
function TLCLComponentIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).IsRightToLeft));
end;
function TLCLComponentUseRightToLeftAlignment(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).UseRightToLeftAlignment));
end;
function TLCLComponentUseRightToLeftReading(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).UseRightToLeftReading));
end;
function TLCLComponentHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TLCLComponent(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TLCLComponentsetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TLCLComponent(Pointer(control_p)).ParentBidiMode:=para50;
Result := PyInt_FromLong(0);
end;
function TLCLComponentgetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).ParentBidiMode));
end;    }
function TFormTile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TForm(Pointer(control_p)).Tile();
Result := PyInt_FromLong(0);
end;
function TFormsetLCLVersion(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:string;
control :TForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TForm(Pointer(control_p)).LCLVersion:=para50;
Result := PyInt_FromLong(0);
end;
function TFormgetLCLVersion(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TForm(Pointer(control_p)).LCLVersion)));
end;
function TCustomScrollBarSetParams(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:Integer;
para48:Integer;
para49:Integer;
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TCustomScrollBar(Pointer(control_p)).SetParams(para47,para48,para49,para50);
Result := PyInt_FromLong(0);
end;
function TCustomScrollBarsetMax(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).Max:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetMax(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).Max);
end;
function TCustomScrollBarsetMin(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).Min:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetMin(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).Min);
end;
function TCustomScrollBarsetPageSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).PageSize:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetPageSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).PageSize);
end;
function TCustomScrollBarsetPosition(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).Position:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetPosition(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).Position);
end;
function TCustomMemosetWantReturns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomMemo(Pointer(control_p)).WantReturns:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomMemogetWantReturns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomMemo(Pointer(control_p)).WantReturns));
end;
function TCustomMemosetWantTabs(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomMemo(Pointer(control_p)).WantTabs:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomMemogetWantTabs(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomMemo(Pointer(control_p)).WantTabs));
end;
function TCustomMemosetWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomMemo(Pointer(control_p)).WordWrap:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomMemogetWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomMemo(Pointer(control_p)).WordWrap));
end;
function TCustomListBoxClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).Click();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxClearSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).ClearSelection();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxGetIndexAtXY(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:integer;
para50:integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).GetIndexAtXY(para49,para50));
end;
function TCustomListBoxGetIndexAtY(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).GetIndexAtY(para50));
end;
function TCustomListBoxGetSelectedText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TCustomListBox(Pointer(control_p)).GetSelectedText)));
end;
function TCustomListBoxItemVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).ItemVisible(para50)));
end;
function TCustomListBoxItemFullyVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).ItemFullyVisible(para50)));
end;
function TCustomListBoxLockSelectionChange(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).LockSelectionChange();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxMakeCurrentVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).MakeCurrentVisible();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxMeasureItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TCustomListBox(Pointer(control_p)).MeasureItem(para49,para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxSelectAll(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).SelectAll();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxsetColumns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).Columns:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetColumns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).Columns);
end;
function TCustomListBoxgetCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).Count);
end;
function TCustomListBoxsetExtendedSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ExtendedSelect:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetExtendedSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).ExtendedSelect));
end;
function TCustomListBoxsetIntegralHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).IntegralHeight:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetIntegralHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).IntegralHeight));
end;
function TCustomListBoxsetItemHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ItemHeight:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetItemHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).ItemHeight);
end;
function TCustomListBoxsetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ItemIndex:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).ItemIndex);
end;
function TCustomListBoxsetMultiSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).MultiSelect:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetMultiSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).MultiSelect));
end;
function TCustomListBoxsetScrollWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ScrollWidth:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetScrollWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).ScrollWidth);
end;
function TCustomListBoxgetSelCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).SelCount);
end;
function TCustomListBoxsetSorted(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).Sorted:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetSorted(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).Sorted));
end;
function TCustomListBoxsetTopIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).TopIndex:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetTopIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).TopIndex);
end;
function TCustomLabelColorIsStored(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomLabel(Pointer(control_p)).ColorIsStored));
end;
function TCustomLabelAdjustFontForOptimalFill(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomLabel(Pointer(control_p)).AdjustFontForOptimalFill));
end;
function TCustomLabelPaint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomLabel(Pointer(control_p)).Paint();
Result := PyInt_FromLong(0);
end;
function TCustomLabelSetBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TCustomLabel(Pointer(control_p)).SetBounds(para47,para48,para49,para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormAfterConstruction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).AfterConstruction();
Result := PyInt_FromLong(0);
end;
function TCustomFormBeforeDestruction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).BeforeDestruction();
Result := PyInt_FromLong(0);
end;
function TCustomFormClose(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Close();
Result := PyInt_FromLong(0);
end;
function TCustomFormCloseQuery(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).CloseQuery));
end;
function TCustomFormDestroyWnd(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).DestroyWnd();
Result := PyInt_FromLong(0);
end;
function TCustomFormEnsureVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).EnsureVisible(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormFormIsUpdating(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).FormIsUpdating));
end;
function TCustomFormHide(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Hide();
Result := PyInt_FromLong(0);
end;
function TCustomFormAutoSizeDelayedHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).AutoSizeDelayedHandle));
end;
function TCustomFormRelease(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Release();
Result := PyInt_FromLong(0);
end;
function TCustomFormCanFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).CanFocus));
end;
function TCustomFormSetFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).SetFocus();
Result := PyInt_FromLong(0);
end;
function TCustomFormSetRestoredBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TCustomForm(Pointer(control_p)).SetRestoredBounds(para47,para48,para49,para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormShow(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Show();
Result := PyInt_FromLong(0);
end;
function TCustomFormShowModal(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).ShowModal);
end;
function TCustomFormShowOnTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).ShowOnTop();
Result := PyInt_FromLong(0);
end;
function TCustomFormMDIChildCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).MDIChildCount);
end;
function TCustomFormgetActive(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).Active));
end;
function TCustomFormsetAllowDropFiles(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).AllowDropFiles:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomFormgetAllowDropFiles(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).AllowDropFiles));
end;
function TCustomFormsetAlphaBlend(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).AlphaBlend:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomFormgetAlphaBlend(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).AlphaBlend));
end;
function TCustomFormsetDesignTimeDPI(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).DesignTimeDPI:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomFormgetDesignTimeDPI(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).DesignTimeDPI);
end;
function TCustomFormsetHelpFile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:string;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TCustomForm(Pointer(control_p)).HelpFile:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomFormgetHelpFile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TCustomForm(Pointer(control_p)).HelpFile)));
end;
function TCustomFormsetKeyPreview(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).KeyPreview:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomFormgetKeyPreview(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).KeyPreview));
end;
function TCustomFormgetRestoredLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredLeft);
end;
function TCustomFormgetRestoredTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredTop);
end;
function TCustomFormgetRestoredWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredWidth);
end;
function TCustomFormgetRestoredHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredHeight);
end;
function TCustomEditClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TCustomEditSelectAll(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).SelectAll();
Result := PyInt_FromLong(0);
end;
function TCustomEditClearSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).ClearSelection();
Result := PyInt_FromLong(0);
end;
function TCustomEditCopyToClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).CopyToClipboard();
Result := PyInt_FromLong(0);
end;
function TCustomEditCutToClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).CutToClipboard();
Result := PyInt_FromLong(0);
end;
function TCustomEditPasteFromClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).PasteFromClipboard();
Result := PyInt_FromLong(0);
end;
function TCustomEditgetCanUndo(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).CanUndo));
end;
function TCustomEditsetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).HideSelection:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).HideSelection));
end;
function TCustomEditsetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).MaxLength:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomEdit(Pointer(control_p)).MaxLength);
end;
function TCustomEditsetModified(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).Modified:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetModified(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).Modified));
end;
function TCustomEditsetNumbersOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).NumbersOnly:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetNumbersOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).NumbersOnly));
end;
function TCustomEditsetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).ReadOnly:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).ReadOnly));
end;
function TCustomEditsetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).SelLength:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomEdit(Pointer(control_p)).SelLength);
end;
function TCustomEditsetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).SelStart:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomEdit(Pointer(control_p)).SelStart);
end;
function TCustomEditsetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:String;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TCustomEdit(Pointer(control_p)).SelText:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomEditgetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TCustomEdit(Pointer(control_p)).SelText)));
end;
function TCustomComboBoxIntfGetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).IntfGetItems();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxClearSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).ClearSelection();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxsetDroppedDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).DroppedDown:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetDroppedDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).DroppedDown));
end;
function TCustomComboBoxSelectAll(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).SelectAll();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxsetAutoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).AutoSelect:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetAutoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).AutoSelect));
end;
function TCustomComboBoxsetAutoSelected(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).AutoSelected:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetAutoSelected(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).AutoSelected));
end;
function TCustomComboBoxsetDropDownCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).DropDownCount:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetDropDownCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).DropDownCount);
end;
function TCustomComboBoxsetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).ItemIndex:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).ItemIndex);
end;
function TCustomComboBoxsetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).ReadOnly:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).ReadOnly));
end;
function TCustomComboBoxsetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).SelLength:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).SelLength);
end;
function TCustomComboBoxsetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).SelStart:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).SelStart);
end;
function TCustomComboBoxsetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:String;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).SelText:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TCustomComboBox(Pointer(control_p)).SelText)));
end;
function TCustomCheckBoxsetAllowGrayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomCheckBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomCheckBox(Pointer(control_p)).AllowGrayed:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomCheckBoxgetAllowGrayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomCheckBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomCheckBox(Pointer(control_p)).AllowGrayed));
end;
function TCustomButtonClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).Click();
Result := PyInt_FromLong(0);
end;
function TCustomButtonExecuteDefaultAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).ExecuteDefaultAction();
Result := PyInt_FromLong(0);
end;
function TCustomButtonExecuteCancelAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).ExecuteCancelAction();
Result := PyInt_FromLong(0);
end;
function TCustomButtonUpdateRolesForForm(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).UpdateRolesForForm();
Result := PyInt_FromLong(0);
end;
function TCustomButtongetActive(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomButton(Pointer(control_p)).Active));
end;
function TCustomButtonsetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomButton(Pointer(control_p)).Default:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomButtongetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomButton(Pointer(control_p)).Default));
end;
function TCustomButtonsetCancel(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomButton(Pointer(control_p)).Cancel:=para50;
Result := PyInt_FromLong(0);
end;
function TCustomButtongetCancel(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomButton(Pointer(control_p)).Cancel));
end;
function TControlAdjustSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).AdjustSize();
Result := PyInt_FromLong(0);
end;
function TControlAutoSizeDelayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).AutoSizeDelayed));
end;
function TControlAutoSizeDelayedReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TControl(Pointer(control_p)).AutoSizeDelayedReport)));
end;
function TControlAutoSizeDelayedHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).AutoSizeDelayedHandle));
end;
function TControlAnchorClient(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).AnchorClient(para50);
Result := PyInt_FromLong(0);
end;
function TControlAnchoredControlCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).AnchoredControlCount);
end;
function TControlSetBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TControl(Pointer(control_p)).SetBounds(para47,para48,para49,para50);
Result := PyInt_FromLong(0);
end;
function TControlSetInitialBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TControl(Pointer(control_p)).SetInitialBounds(para47,para48,para49,para50);
Result := PyInt_FromLong(0);
end;
function TControlGetDefaultWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).GetDefaultWidth);
end;
function TControlGetDefaultHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).GetDefaultHeight);
end;
function TControlCNPreferredSizeChanged(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).CNPreferredSizeChanged();
Result := PyInt_FromLong(0);
end;
function TControlInvalidatePreferredSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).InvalidatePreferredSize();
Result := PyInt_FromLong(0);
end;
function TControlWriteLayoutDebugReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:string;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).WriteLayoutDebugReport(para50);
Result := PyInt_FromLong(0);
end;
function TControlShouldAutoAdjustLeftAndTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ShouldAutoAdjustLeftAndTop));
end;
function TControlBeforeDestruction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).BeforeDestruction();
Result := PyInt_FromLong(0);
end;
function TControlEditingDone(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).EditingDone();
Result := PyInt_FromLong(0);
end;
function TControlExecuteDefaultAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).ExecuteDefaultAction();
Result := PyInt_FromLong(0);
end;
function TControlExecuteCancelAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).ExecuteCancelAction();
Result := PyInt_FromLong(0);
end;
function TControlBeginDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Boolean;
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TControl(Pointer(control_p)).BeginDrag(para49,para50);
Result := PyInt_FromLong(0);
end;
function TControlEndDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).EndDrag(para50);
Result := PyInt_FromLong(0);
end;
function TControlBringToFront(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).BringToFront();
Result := PyInt_FromLong(0);
end;
function TControlHasParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).HasParent));
end;
function TControlIsVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsVisible));
end;
function TControlIsControlVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsControlVisible));
end;
function TControlIsEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsEnabled));
end;
function TControlIsParentColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsParentColor));
end;
function TControlIsParentFont(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsParentFont));
end;
function TControlFormIsUpdating(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).FormIsUpdating));
end;
function TControlIsProcessingPaintMsg(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsProcessingPaintMsg));
end;
function TControlHide(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Hide();
Result := PyInt_FromLong(0);
end;
function TControlRefresh(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Refresh();
Result := PyInt_FromLong(0);
end;
function TControlRepaint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Repaint();
Result := PyInt_FromLong(0);
end;
function TControlInvalidate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Invalidate();
Result := PyInt_FromLong(0);
end;
function TControlSendToBack(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).SendToBack();
Result := PyInt_FromLong(0);
end;
function TControlUpdateRolesForForm(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).UpdateRolesForForm();
Result := PyInt_FromLong(0);
end;
function TControlGetTextLen(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).GetTextLen);
end;
function TControlShow(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Show();
Result := PyInt_FromLong(0);
end;
function TControlUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Update();
Result := PyInt_FromLong(0);
end;
function TControlHandleObjectShouldBeVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).HandleObjectShouldBeVisible));
end;
function TControlParentDestroyingHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ParentDestroyingHandle));
end;
function TControlParentHandlesAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ParentHandlesAllocated));
end;
function TControlInitiateAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).InitiateAction();
Result := PyInt_FromLong(0);
end;
function TControlShowHelp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).ShowHelp();
Result := PyInt_FromLong(0);
end;
function TControlsetAccessibleDescription(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:String;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).AccessibleDescription:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetAccessibleDescription(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TControl(Pointer(control_p)).AccessibleDescription)));
end;
function TControlsetAccessibleValue(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:String;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).AccessibleValue:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetAccessibleValue(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TControl(Pointer(control_p)).AccessibleValue)));
end;
function TControlsetAutoSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).AutoSize:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetAutoSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).AutoSize));
end;
function TControlsetCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:String;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).Caption:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TControl(Pointer(control_p)).Caption)));
end;
function TControlsetClientHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).ClientHeight:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetClientHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).ClientHeight);
end;
function TControlsetClientWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).ClientWidth:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetClientWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).ClientWidth);
end;
function TControlsetEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Enabled:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).Enabled));
end;
function TControlsetIsControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).IsControl:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetIsControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsControl));
end;
function TControlgetMouseEntered(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).MouseEntered));
end;
function TControlsetShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).ShowHint:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ShowHint));
end;
function TControlsetVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Visible:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).Visible));
end;
function TControlgetFloating(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).Floating));
end;
function TControlsetLRDockWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).LRDockWidth:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetLRDockWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).LRDockWidth);
end;
function TControlsetTBDockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).TBDockHeight:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetTBDockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).TBDockHeight);
end;
function TControlsetUndockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).UndockHeight:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetUndockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).UndockHeight);
end;
function TControlUseRightToLeftAlignment(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).UseRightToLeftAlignment));
end;
function TControlUseRightToLeftReading(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).UseRightToLeftReading));
end;
function TControlUseRightToLeftScrollBar(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).UseRightToLeftScrollBar));
end;
function TControlIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsRightToLeft));
end;
function TControlsetLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Left:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Left);
end;
function TControlsetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Height:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Height);
end;
function TControlsetTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Top:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Top);
end;
function TControlsetWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Width:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Width);
end;
function TControlsetHelpKeyword(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:String;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).HelpKeyword:=para50;
Result := PyInt_FromLong(0);
end;
function TControlgetHelpKeyword(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PAnsiChar(ansistring(TControl(Pointer(control_p)).HelpKeyword)));
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
    Methods[k].Name := 'set_Tag';
    Methods[k].meth := @set_Tag;
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
    Inc(k);
    Methods[k].Name := 'Create_FormLfm';
    Methods[k].meth := @Create_FormLfm;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'creat formlfm';
    Inc(k);
    Methods[k].Name := nil;
inc(k);
Methods[k].Name := 'TWinControlgetBoundsLockCount';
Methods[k].meth := @TWinControlgetBoundsLockCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetBoundsLockCount';
inc(k);
Methods[k].Name := 'TWinControlgetCachedClientHeight';
Methods[k].meth := @TWinControlgetCachedClientHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetCachedClientHeight';
inc(k);
Methods[k].Name := 'TWinControlgetCachedClientWidth';
Methods[k].meth := @TWinControlgetCachedClientWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetCachedClientWidth';
inc(k);
Methods[k].Name := 'TWinControlgetControlCount';
Methods[k].meth := @TWinControlgetControlCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetControlCount';
inc(k);
Methods[k].Name := 'TWinControlgetDockClientCount';
Methods[k].meth := @TWinControlgetDockClientCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDockClientCount';
inc(k);
Methods[k].Name := 'TWinControlsetDockSite';
Methods[k].meth := @TWinControlsetDockSite;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetDockSite';
inc(k);
Methods[k].Name := 'TWinControlgetDockSite';
Methods[k].meth := @TWinControlgetDockSite;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDockSite';
inc(k);
Methods[k].Name := 'TWinControlsetDoubleBuffered';
Methods[k].meth := @TWinControlsetDoubleBuffered;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetDoubleBuffered';
inc(k);
Methods[k].Name := 'TWinControlgetDoubleBuffered';
Methods[k].meth := @TWinControlgetDoubleBuffered;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDoubleBuffered';
inc(k);
Methods[k].Name := 'TWinControlgetIsResizing';
Methods[k].meth := @TWinControlgetIsResizing;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetIsResizing';
inc(k);
Methods[k].Name := 'TWinControlsetTabStop';
Methods[k].meth := @TWinControlsetTabStop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetTabStop';
inc(k);
Methods[k].Name := 'TWinControlgetTabStop';
Methods[k].meth := @TWinControlgetTabStop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetTabStop';
inc(k);
Methods[k].Name := 'TWinControlgetShowing';
Methods[k].meth := @TWinControlgetShowing;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetShowing';
inc(k);
Methods[k].Name := 'TWinControlsetDesignerDeleting';
Methods[k].meth := @TWinControlsetDesignerDeleting;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetDesignerDeleting';
inc(k);
Methods[k].Name := 'TWinControlgetDesignerDeleting';
Methods[k].meth := @TWinControlgetDesignerDeleting;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDesignerDeleting';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayed';
Methods[k].meth := @TWinControlAutoSizeDelayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAutoSizeDelayed';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayedReport';
Methods[k].meth := @TWinControlAutoSizeDelayedReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAutoSizeDelayedReport';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayedHandle';
Methods[k].meth := @TWinControlAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TWinControlBeginUpdateBounds';
Methods[k].meth := @TWinControlBeginUpdateBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlBeginUpdateBounds';
inc(k);
Methods[k].Name := 'TWinControlEndUpdateBounds';
Methods[k].meth := @TWinControlEndUpdateBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlEndUpdateBounds';
inc(k);
Methods[k].Name := 'TWinControlLockRealizeBounds';
Methods[k].meth := @TWinControlLockRealizeBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlLockRealizeBounds';
inc(k);
Methods[k].Name := 'TWinControlUnlockRealizeBounds';
Methods[k].meth := @TWinControlUnlockRealizeBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlUnlockRealizeBounds';
inc(k);
Methods[k].Name := 'TWinControlDoAdjustClientRectChange';
Methods[k].meth := @TWinControlDoAdjustClientRectChange;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlDoAdjustClientRectChange';
inc(k);
Methods[k].Name := 'TWinControlInvalidateClientRectCache';
Methods[k].meth := @TWinControlInvalidateClientRectCache;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlInvalidateClientRectCache';
inc(k);
Methods[k].Name := 'TWinControlClientRectNeedsInterfaceUpdate';
Methods[k].meth := @TWinControlClientRectNeedsInterfaceUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlClientRectNeedsInterfaceUpdate';
inc(k);
Methods[k].Name := 'TWinControlSetBounds';
Methods[k].meth := @TWinControlSetBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlSetBounds';
inc(k);
Methods[k].Name := 'TWinControlDisableAlign';
Methods[k].meth := @TWinControlDisableAlign;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlDisableAlign';
inc(k);
Methods[k].Name := 'TWinControlEnableAlign';
Methods[k].meth := @TWinControlEnableAlign;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlEnableAlign';
inc(k);
Methods[k].Name := 'TWinControlReAlign';
Methods[k].meth := @TWinControlReAlign;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlReAlign';
inc(k);
Methods[k].Name := 'TWinControlScrollBy';
Methods[k].meth := @TWinControlScrollBy;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlScrollBy';
inc(k);
Methods[k].Name := 'TWinControlWriteLayoutDebugReport';
Methods[k].meth := @TWinControlWriteLayoutDebugReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlWriteLayoutDebugReport';
inc(k);
Methods[k].Name := 'TWinControlCanFocus';
Methods[k].meth := @TWinControlCanFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlCanFocus';
inc(k);
Methods[k].Name := 'TWinControlFocused';
Methods[k].meth := @TWinControlFocused;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlFocused';
inc(k);
Methods[k].Name := 'TWinControlPerformTab';
Methods[k].meth := @TWinControlPerformTab;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlPerformTab';{
inc(k);
Methods[k].Name := 'TWinControlBroadCast';
Methods[k].meth := @TWinControlBroadCast;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlBroadCast';
inc(k);
Methods[k].Name := 'TWinControlDefaultHandler';
Methods[k].meth := @TWinControlDefaultHandler;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlDefaultHandler'; }
inc(k);
Methods[k].Name := 'TWinControlGetTextLen';
Methods[k].meth := @TWinControlGetTextLen;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlGetTextLen';
inc(k);
Methods[k].Name := 'TWinControlInvalidate';
Methods[k].meth := @TWinControlInvalidate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlInvalidate';
inc(k);
Methods[k].Name := 'TWinControlAddControl';
Methods[k].meth := @TWinControlAddControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAddControl';
inc(k);
Methods[k].Name := 'TWinControlRepaint';
Methods[k].meth := @TWinControlRepaint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlRepaint';
inc(k);
Methods[k].Name := 'TWinControlUpdate';
Methods[k].meth := @TWinControlUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlUpdate';
inc(k);
Methods[k].Name := 'TWinControlSetFocus';
Methods[k].meth := @TWinControlSetFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlSetFocus';
inc(k);
Methods[k].Name := 'TWinControlFlipChildren';
Methods[k].meth := @TWinControlFlipChildren;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlFlipChildren';
inc(k);
Methods[k].Name := 'TWinControlScaleBy';
Methods[k].meth := @TWinControlScaleBy;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlScaleBy';
inc(k);
Methods[k].Name := 'TWinControlHandleAllocated';
Methods[k].meth := @TWinControlHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlHandleAllocated';
inc(k);
Methods[k].Name := 'TWinControlParentHandlesAllocated';
Methods[k].meth := @TWinControlParentHandlesAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlParentHandlesAllocated';
inc(k);
Methods[k].Name := 'TWinControlHandleNeeded';
Methods[k].meth := @TWinControlHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlHandleNeeded';
inc(k);
Methods[k].Name := 'TWinControlBrushCreated';
Methods[k].meth := @TWinControlBrushCreated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlBrushCreated';
inc(k);
Methods[k].Name := 'TPopupMenuPopUp';
Methods[k].meth := @TPopupMenuPopUp;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenuPopUp';
inc(k);
Methods[k].Name := 'TPopupMenuPopUp';
Methods[k].meth := @TPopupMenuPopUp;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenuPopUp';
inc(k);
Methods[k].Name := 'TPopupMenusetAutoPopup';
Methods[k].meth := @TPopupMenusetAutoPopup;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenusetAutoPopup';
inc(k);
Methods[k].Name := 'TPopupMenugetAutoPopup';
Methods[k].meth := @TPopupMenugetAutoPopup;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenugetAutoPopup';
inc(k);
Methods[k].Name := 'TMenuItemGetIsRightToLeft';
Methods[k].meth := @TMenuItemGetIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemGetIsRightToLeft';
inc(k);
Methods[k].Name := 'TMenuItemHandleAllocated';
Methods[k].meth := @TMenuItemHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHandleAllocated';
inc(k);
Methods[k].Name := 'TMenuItemHasIcon';
Methods[k].meth := @TMenuItemHasIcon;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHasIcon';
inc(k);
Methods[k].Name := 'TMenuItemHasParent';
Methods[k].meth := @TMenuItemHasParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHasParent';
inc(k);
Methods[k].Name := 'TMenuItemInitiateAction';
Methods[k].meth := @TMenuItemInitiateAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemInitiateAction';
inc(k);
Methods[k].Name := 'TMenuItemIntfDoSelect';
Methods[k].meth := @TMenuItemIntfDoSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIntfDoSelect';
inc(k);
Methods[k].Name := 'TMenuItemIndexOfCaption';
Methods[k].meth := @TMenuItemIndexOfCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIndexOfCaption';
inc(k);
Methods[k].Name := 'TMenuItemAddSeparator';
Methods[k].meth := @TMenuItemAddSeparator;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemAddSeparator';
inc(k);
Methods[k].Name := 'TMenuItemClick';
Methods[k].meth := @TMenuItemClick;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemClick';
inc(k);
Methods[k].Name := 'TMenuItemDelete';
Methods[k].meth := @TMenuItemDelete;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemDelete';
inc(k);
Methods[k].Name := 'TMenuItemHandleNeeded';
Methods[k].meth := @TMenuItemHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHandleNeeded';
inc(k);
Methods[k].Name := 'TMenuItemRecreateHandle';
Methods[k].meth := @TMenuItemRecreateHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemRecreateHandle';
inc(k);
Methods[k].Name := 'TMenuItemIsCheckItem';
Methods[k].meth := @TMenuItemIsCheckItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIsCheckItem';
inc(k);
Methods[k].Name := 'TMenuItemIsLine';
Methods[k].meth := @TMenuItemIsLine;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIsLine';
inc(k);
Methods[k].Name := 'TMenuItemIsInMenuBar';
Methods[k].meth := @TMenuItemIsInMenuBar;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIsInMenuBar';
inc(k);
Methods[k].Name := 'TMenuItemClear';
Methods[k].meth := @TMenuItemClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemClear';
inc(k);
Methods[k].Name := 'TMenuItemHasBitmap';
Methods[k].meth := @TMenuItemHasBitmap;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHasBitmap';
inc(k);
Methods[k].Name := 'TMenuItemgetCount';
Methods[k].meth := @TMenuItemgetCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetCount';
inc(k);
Methods[k].Name := 'TMenuItemsetMenuIndex';
Methods[k].meth := @TMenuItemsetMenuIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetMenuIndex';
inc(k);
Methods[k].Name := 'TMenuItemgetMenuIndex';
Methods[k].meth := @TMenuItemgetMenuIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetMenuIndex';
inc(k);
Methods[k].Name := 'TMenuItemMenuVisibleIndex';
Methods[k].meth := @TMenuItemMenuVisibleIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemMenuVisibleIndex';
inc(k);
Methods[k].Name := 'TMenuItemsetAutoCheck';
Methods[k].meth := @TMenuItemsetAutoCheck;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetAutoCheck';
inc(k);
Methods[k].Name := 'TMenuItemgetAutoCheck';
Methods[k].meth := @TMenuItemgetAutoCheck;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetAutoCheck';
inc(k);
Methods[k].Name := 'TMenuItemsetDefault';
Methods[k].meth := @TMenuItemsetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetDefault';
inc(k);
Methods[k].Name := 'TMenuItemgetDefault';
Methods[k].meth := @TMenuItemgetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetDefault';
inc(k);
Methods[k].Name := 'TMenuItemsetRadioItem';
Methods[k].meth := @TMenuItemsetRadioItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetRadioItem';
inc(k);
Methods[k].Name := 'TMenuItemgetRadioItem';
Methods[k].meth := @TMenuItemgetRadioItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetRadioItem';
inc(k);
Methods[k].Name := 'TMenuItemsetRightJustify';
Methods[k].meth := @TMenuItemsetRightJustify;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetRightJustify';
inc(k);
Methods[k].Name := 'TMenuItemgetRightJustify';
Methods[k].meth := @TMenuItemgetRightJustify;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetRightJustify';
inc(k);
Methods[k].Name := 'TMenuDestroyHandle';
Methods[k].meth := @TMenuDestroyHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuDestroyHandle';
inc(k);
Methods[k].Name := 'TMenuHandleAllocated';
Methods[k].meth := @TMenuHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuHandleAllocated';
inc(k);
Methods[k].Name := 'TMenuIsRightToLeft';
Methods[k].meth := @TMenuIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuIsRightToLeft';
inc(k);
Methods[k].Name := 'TMenuUseRightToLeftAlignment';
Methods[k].meth := @TMenuUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TMenuUseRightToLeftReading';
Methods[k].meth := @TMenuUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TMenuHandleNeeded';
Methods[k].meth := @TMenuHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuHandleNeeded';
inc(k);
Methods[k].Name := 'TMenusetParentBidiMode';
Methods[k].meth := @TMenusetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenusetParentBidiMode';
inc(k);
Methods[k].Name := 'TMenugetParentBidiMode';
Methods[k].meth := @TMenugetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenugetParentBidiMode';
inc(k);
Methods[k].Name := 'TMainMenugetHeight';
Methods[k].meth := @TMainMenugetHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMainMenugetHeight'; {
inc(k);
Methods[k].Name := 'TLCLComponentDestroyHandle';
Methods[k].meth := @TLCLComponentDestroyHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentDestroyHandle';
inc(k);
Methods[k].Name := 'TLCLComponentHandleAllocated';
Methods[k].meth := @TLCLComponentHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentHandleAllocated';
inc(k);
Methods[k].Name := 'TLCLComponentIsRightToLeft';
Methods[k].meth := @TLCLComponentIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentIsRightToLeft';
inc(k);
Methods[k].Name := 'TLCLComponentUseRightToLeftAlignment';
Methods[k].meth := @TLCLComponentUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TLCLComponentUseRightToLeftReading';
Methods[k].meth := @TLCLComponentUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TLCLComponentHandleNeeded';
Methods[k].meth := @TLCLComponentHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentHandleNeeded';
inc(k);
Methods[k].Name := 'TLCLComponentsetParentBidiMode';
Methods[k].meth := @TLCLComponentsetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentsetParentBidiMode';
inc(k);
Methods[k].Name := 'TLCLComponentgetParentBidiMode';
Methods[k].meth := @TLCLComponentgetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentgetParentBidiMode'; }
inc(k);
Methods[k].Name := 'TFormTile';
Methods[k].meth := @TFormTile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TFormTile';
inc(k);
Methods[k].Name := 'TFormsetLCLVersion';
Methods[k].meth := @TFormsetLCLVersion;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TFormsetLCLVersion';
inc(k);
Methods[k].Name := 'TFormgetLCLVersion';
Methods[k].meth := @TFormgetLCLVersion;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TFormgetLCLVersion';
inc(k);
Methods[k].Name := 'TCustomScrollBarSetParams';
Methods[k].meth := @TCustomScrollBarSetParams;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarSetParams';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetMax';
Methods[k].meth := @TCustomScrollBarsetMax;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetMax';
inc(k);
Methods[k].Name := 'TCustomScrollBargetMax';
Methods[k].meth := @TCustomScrollBargetMax;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetMax';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetMin';
Methods[k].meth := @TCustomScrollBarsetMin;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetMin';
inc(k);
Methods[k].Name := 'TCustomScrollBargetMin';
Methods[k].meth := @TCustomScrollBargetMin;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetMin';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetPageSize';
Methods[k].meth := @TCustomScrollBarsetPageSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetPageSize';
inc(k);
Methods[k].Name := 'TCustomScrollBargetPageSize';
Methods[k].meth := @TCustomScrollBargetPageSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetPageSize';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetPosition';
Methods[k].meth := @TCustomScrollBarsetPosition;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetPosition';
inc(k);
Methods[k].Name := 'TCustomScrollBargetPosition';
Methods[k].meth := @TCustomScrollBargetPosition;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetPosition';
inc(k);
Methods[k].Name := 'TCustomMemosetWantReturns';
Methods[k].meth := @TCustomMemosetWantReturns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemosetWantReturns';
inc(k);
Methods[k].Name := 'TCustomMemogetWantReturns';
Methods[k].meth := @TCustomMemogetWantReturns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemogetWantReturns';
inc(k);
Methods[k].Name := 'TCustomMemosetWantTabs';
Methods[k].meth := @TCustomMemosetWantTabs;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemosetWantTabs';
inc(k);
Methods[k].Name := 'TCustomMemogetWantTabs';
Methods[k].meth := @TCustomMemogetWantTabs;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemogetWantTabs';
inc(k);
Methods[k].Name := 'TCustomMemosetWordWrap';
Methods[k].meth := @TCustomMemosetWordWrap;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemosetWordWrap';
inc(k);
Methods[k].Name := 'TCustomMemogetWordWrap';
Methods[k].meth := @TCustomMemogetWordWrap;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemogetWordWrap';
inc(k);
Methods[k].Name := 'TCustomListBoxClick';
Methods[k].meth := @TCustomListBoxClick;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxClick';
inc(k);
Methods[k].Name := 'TCustomListBoxClear';
Methods[k].meth := @TCustomListBoxClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxClear';
inc(k);
Methods[k].Name := 'TCustomListBoxClearSelection';
Methods[k].meth := @TCustomListBoxClearSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxClearSelection';
inc(k);
Methods[k].Name := 'TCustomListBoxGetIndexAtXY';
Methods[k].meth := @TCustomListBoxGetIndexAtXY;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxGetIndexAtXY';
inc(k);
Methods[k].Name := 'TCustomListBoxGetIndexAtY';
Methods[k].meth := @TCustomListBoxGetIndexAtY;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxGetIndexAtY';
inc(k);
Methods[k].Name := 'TCustomListBoxGetSelectedText';
Methods[k].meth := @TCustomListBoxGetSelectedText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxGetSelectedText';
inc(k);
Methods[k].Name := 'TCustomListBoxItemVisible';
Methods[k].meth := @TCustomListBoxItemVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxItemVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxItemFullyVisible';
Methods[k].meth := @TCustomListBoxItemFullyVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxItemFullyVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxLockSelectionChange';
Methods[k].meth := @TCustomListBoxLockSelectionChange;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxLockSelectionChange';
inc(k);
Methods[k].Name := 'TCustomListBoxMakeCurrentVisible';
Methods[k].meth := @TCustomListBoxMakeCurrentVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxMakeCurrentVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxMeasureItem';
Methods[k].meth := @TCustomListBoxMeasureItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxMeasureItem';
inc(k);
Methods[k].Name := 'TCustomListBoxSelectAll';
Methods[k].meth := @TCustomListBoxSelectAll;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxSelectAll';
inc(k);
Methods[k].Name := 'TCustomListBoxsetColumns';
Methods[k].meth := @TCustomListBoxsetColumns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetColumns';
inc(k);
Methods[k].Name := 'TCustomListBoxgetColumns';
Methods[k].meth := @TCustomListBoxgetColumns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetColumns';
inc(k);
Methods[k].Name := 'TCustomListBoxgetCount';
Methods[k].meth := @TCustomListBoxgetCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetCount';
inc(k);
Methods[k].Name := 'TCustomListBoxsetExtendedSelect';
Methods[k].meth := @TCustomListBoxsetExtendedSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetExtendedSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxgetExtendedSelect';
Methods[k].meth := @TCustomListBoxgetExtendedSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetExtendedSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxsetIntegralHeight';
Methods[k].meth := @TCustomListBoxsetIntegralHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetIntegralHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxgetIntegralHeight';
Methods[k].meth := @TCustomListBoxgetIntegralHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetIntegralHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItemHeight';
Methods[k].meth := @TCustomListBoxsetItemHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetItemHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItemHeight';
Methods[k].meth := @TCustomListBoxgetItemHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetItemHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItemIndex';
Methods[k].meth := @TCustomListBoxsetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetItemIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItemIndex';
Methods[k].meth := @TCustomListBoxgetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetItemIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxsetMultiSelect';
Methods[k].meth := @TCustomListBoxsetMultiSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetMultiSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxgetMultiSelect';
Methods[k].meth := @TCustomListBoxgetMultiSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetMultiSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxsetScrollWidth';
Methods[k].meth := @TCustomListBoxsetScrollWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetScrollWidth';
inc(k);
Methods[k].Name := 'TCustomListBoxgetScrollWidth';
Methods[k].meth := @TCustomListBoxgetScrollWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetScrollWidth';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSelCount';
Methods[k].meth := @TCustomListBoxgetSelCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetSelCount';
inc(k);
Methods[k].Name := 'TCustomListBoxsetSorted';
Methods[k].meth := @TCustomListBoxsetSorted;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetSorted';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSorted';
Methods[k].meth := @TCustomListBoxgetSorted;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetSorted';
inc(k);
Methods[k].Name := 'TCustomListBoxsetTopIndex';
Methods[k].meth := @TCustomListBoxsetTopIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetTopIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxgetTopIndex';
Methods[k].meth := @TCustomListBoxgetTopIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetTopIndex';
inc(k);
Methods[k].Name := 'TCustomLabelColorIsStored';
Methods[k].meth := @TCustomLabelColorIsStored;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelColorIsStored';
inc(k);
Methods[k].Name := 'TCustomLabelAdjustFontForOptimalFill';
Methods[k].meth := @TCustomLabelAdjustFontForOptimalFill;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelAdjustFontForOptimalFill';
inc(k);
Methods[k].Name := 'TCustomLabelPaint';
Methods[k].meth := @TCustomLabelPaint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelPaint';
inc(k);
Methods[k].Name := 'TCustomLabelSetBounds';
Methods[k].meth := @TCustomLabelSetBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelSetBounds';
inc(k);
Methods[k].Name := 'TCustomFormAfterConstruction';
Methods[k].meth := @TCustomFormAfterConstruction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormAfterConstruction';
inc(k);
Methods[k].Name := 'TCustomFormBeforeDestruction';
Methods[k].meth := @TCustomFormBeforeDestruction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormBeforeDestruction';
inc(k);
Methods[k].Name := 'TCustomFormClose';
Methods[k].meth := @TCustomFormClose;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormClose';
inc(k);
Methods[k].Name := 'TCustomFormCloseQuery';
Methods[k].meth := @TCustomFormCloseQuery;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormCloseQuery';
inc(k);
Methods[k].Name := 'TCustomFormDestroyWnd';
Methods[k].meth := @TCustomFormDestroyWnd;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormDestroyWnd';
inc(k);
Methods[k].Name := 'TCustomFormEnsureVisible';
Methods[k].meth := @TCustomFormEnsureVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormEnsureVisible';
inc(k);
Methods[k].Name := 'TCustomFormFormIsUpdating';
Methods[k].meth := @TCustomFormFormIsUpdating;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormFormIsUpdating';
inc(k);
Methods[k].Name := 'TCustomFormHide';
Methods[k].meth := @TCustomFormHide;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormHide';
inc(k);
Methods[k].Name := 'TCustomFormAutoSizeDelayedHandle';
Methods[k].meth := @TCustomFormAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TCustomFormRelease';
Methods[k].meth := @TCustomFormRelease;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormRelease';
inc(k);
Methods[k].Name := 'TCustomFormCanFocus';
Methods[k].meth := @TCustomFormCanFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormCanFocus';
inc(k);
Methods[k].Name := 'TCustomFormSetFocus';
Methods[k].meth := @TCustomFormSetFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormSetFocus';
inc(k);
Methods[k].Name := 'TCustomFormSetRestoredBounds';
Methods[k].meth := @TCustomFormSetRestoredBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormSetRestoredBounds';
inc(k);
Methods[k].Name := 'TCustomFormShow';
Methods[k].meth := @TCustomFormShow;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormShow';
inc(k);
Methods[k].Name := 'TCustomFormShowModal';
Methods[k].meth := @TCustomFormShowModal;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormShowModal';
inc(k);
Methods[k].Name := 'TCustomFormShowOnTop';
Methods[k].meth := @TCustomFormShowOnTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormShowOnTop';
inc(k);
Methods[k].Name := 'TCustomFormMDIChildCount';
Methods[k].meth := @TCustomFormMDIChildCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormMDIChildCount';
inc(k);
Methods[k].Name := 'TCustomFormgetActive';
Methods[k].meth := @TCustomFormgetActive;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetActive';
inc(k);
Methods[k].Name := 'TCustomFormsetAllowDropFiles';
Methods[k].meth := @TCustomFormsetAllowDropFiles;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetAllowDropFiles';
inc(k);
Methods[k].Name := 'TCustomFormgetAllowDropFiles';
Methods[k].meth := @TCustomFormgetAllowDropFiles;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetAllowDropFiles';
inc(k);
Methods[k].Name := 'TCustomFormsetAlphaBlend';
Methods[k].meth := @TCustomFormsetAlphaBlend;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetAlphaBlend';
inc(k);
Methods[k].Name := 'TCustomFormgetAlphaBlend';
Methods[k].meth := @TCustomFormgetAlphaBlend;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetAlphaBlend';
inc(k);
Methods[k].Name := 'TCustomFormsetDesignTimeDPI';
Methods[k].meth := @TCustomFormsetDesignTimeDPI;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetDesignTimeDPI';
inc(k);
Methods[k].Name := 'TCustomFormgetDesignTimeDPI';
Methods[k].meth := @TCustomFormgetDesignTimeDPI;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetDesignTimeDPI';
inc(k);
Methods[k].Name := 'TCustomFormsetHelpFile';
Methods[k].meth := @TCustomFormsetHelpFile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetHelpFile';
inc(k);
Methods[k].Name := 'TCustomFormgetHelpFile';
Methods[k].meth := @TCustomFormgetHelpFile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetHelpFile';
inc(k);
Methods[k].Name := 'TCustomFormsetKeyPreview';
Methods[k].meth := @TCustomFormsetKeyPreview;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetKeyPreview';
inc(k);
Methods[k].Name := 'TCustomFormgetKeyPreview';
Methods[k].meth := @TCustomFormgetKeyPreview;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetKeyPreview';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredLeft';
Methods[k].meth := @TCustomFormgetRestoredLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredLeft';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredTop';
Methods[k].meth := @TCustomFormgetRestoredTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredTop';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredWidth';
Methods[k].meth := @TCustomFormgetRestoredWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredWidth';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredHeight';
Methods[k].meth := @TCustomFormgetRestoredHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredHeight';
inc(k);
Methods[k].Name := 'TCustomEditClear';
Methods[k].meth := @TCustomEditClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditClear';
inc(k);
Methods[k].Name := 'TCustomEditSelectAll';
Methods[k].meth := @TCustomEditSelectAll;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditSelectAll';
inc(k);
Methods[k].Name := 'TCustomEditClearSelection';
Methods[k].meth := @TCustomEditClearSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditClearSelection';
inc(k);
Methods[k].Name := 'TCustomEditCopyToClipboard';
Methods[k].meth := @TCustomEditCopyToClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditCopyToClipboard';
inc(k);
Methods[k].Name := 'TCustomEditCutToClipboard';
Methods[k].meth := @TCustomEditCutToClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditCutToClipboard';
inc(k);
Methods[k].Name := 'TCustomEditPasteFromClipboard';
Methods[k].meth := @TCustomEditPasteFromClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditPasteFromClipboard';
inc(k);
Methods[k].Name := 'TCustomEditgetCanUndo';
Methods[k].meth := @TCustomEditgetCanUndo;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetCanUndo';
inc(k);
Methods[k].Name := 'TCustomEditsetHideSelection';
Methods[k].meth := @TCustomEditsetHideSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetHideSelection';
inc(k);
Methods[k].Name := 'TCustomEditgetHideSelection';
Methods[k].meth := @TCustomEditgetHideSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetHideSelection';
inc(k);
Methods[k].Name := 'TCustomEditsetMaxLength';
Methods[k].meth := @TCustomEditsetMaxLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetMaxLength';
inc(k);
Methods[k].Name := 'TCustomEditgetMaxLength';
Methods[k].meth := @TCustomEditgetMaxLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetMaxLength';
inc(k);
Methods[k].Name := 'TCustomEditsetModified';
Methods[k].meth := @TCustomEditsetModified;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetModified';
inc(k);
Methods[k].Name := 'TCustomEditgetModified';
Methods[k].meth := @TCustomEditgetModified;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetModified';
inc(k);
Methods[k].Name := 'TCustomEditsetNumbersOnly';
Methods[k].meth := @TCustomEditsetNumbersOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetNumbersOnly';
inc(k);
Methods[k].Name := 'TCustomEditgetNumbersOnly';
Methods[k].meth := @TCustomEditgetNumbersOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetNumbersOnly';
inc(k);
Methods[k].Name := 'TCustomEditsetReadOnly';
Methods[k].meth := @TCustomEditsetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetReadOnly';
inc(k);
Methods[k].Name := 'TCustomEditgetReadOnly';
Methods[k].meth := @TCustomEditgetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetReadOnly';
inc(k);
Methods[k].Name := 'TCustomEditsetSelLength';
Methods[k].meth := @TCustomEditsetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetSelLength';
inc(k);
Methods[k].Name := 'TCustomEditgetSelLength';
Methods[k].meth := @TCustomEditgetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetSelLength';
inc(k);
Methods[k].Name := 'TCustomEditsetSelStart';
Methods[k].meth := @TCustomEditsetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetSelStart';
inc(k);
Methods[k].Name := 'TCustomEditgetSelStart';
Methods[k].meth := @TCustomEditgetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetSelStart';
inc(k);
Methods[k].Name := 'TCustomEditsetSelText';
Methods[k].meth := @TCustomEditsetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetSelText';
inc(k);
Methods[k].Name := 'TCustomEditgetSelText';
Methods[k].meth := @TCustomEditgetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetSelText';
inc(k);
Methods[k].Name := 'TCustomComboBoxIntfGetItems';
Methods[k].meth := @TCustomComboBoxIntfGetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxIntfGetItems';
inc(k);
Methods[k].Name := 'TCustomComboBoxClear';
Methods[k].meth := @TCustomComboBoxClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxClear';
inc(k);
Methods[k].Name := 'TCustomComboBoxClearSelection';
Methods[k].meth := @TCustomComboBoxClearSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxClearSelection';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetDroppedDown';
Methods[k].meth := @TCustomComboBoxsetDroppedDown;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetDroppedDown';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetDroppedDown';
Methods[k].meth := @TCustomComboBoxgetDroppedDown;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetDroppedDown';
inc(k);
Methods[k].Name := 'TCustomComboBoxSelectAll';
Methods[k].meth := @TCustomComboBoxSelectAll;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxSelectAll';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetAutoSelect';
Methods[k].meth := @TCustomComboBoxsetAutoSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetAutoSelect';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetAutoSelect';
Methods[k].meth := @TCustomComboBoxgetAutoSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetAutoSelect';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetAutoSelected';
Methods[k].meth := @TCustomComboBoxsetAutoSelected;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetAutoSelected';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetAutoSelected';
Methods[k].meth := @TCustomComboBoxgetAutoSelected;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetAutoSelected';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetDropDownCount';
Methods[k].meth := @TCustomComboBoxsetDropDownCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetDropDownCount';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetDropDownCount';
Methods[k].meth := @TCustomComboBoxgetDropDownCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetDropDownCount';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetItemIndex';
Methods[k].meth := @TCustomComboBoxsetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetItemIndex';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetItemIndex';
Methods[k].meth := @TCustomComboBoxgetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetItemIndex';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetReadOnly';
Methods[k].meth := @TCustomComboBoxsetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetReadOnly';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetReadOnly';
Methods[k].meth := @TCustomComboBoxgetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetReadOnly';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelLength';
Methods[k].meth := @TCustomComboBoxsetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetSelLength';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelLength';
Methods[k].meth := @TCustomComboBoxgetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetSelLength';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelStart';
Methods[k].meth := @TCustomComboBoxsetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetSelStart';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelStart';
Methods[k].meth := @TCustomComboBoxgetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetSelStart';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelText';
Methods[k].meth := @TCustomComboBoxsetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetSelText';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelText';
Methods[k].meth := @TCustomComboBoxgetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetSelText';
inc(k);
Methods[k].Name := 'TCustomCheckBoxsetAllowGrayed';
Methods[k].meth := @TCustomCheckBoxsetAllowGrayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomCheckBoxsetAllowGrayed';
inc(k);
Methods[k].Name := 'TCustomCheckBoxgetAllowGrayed';
Methods[k].meth := @TCustomCheckBoxgetAllowGrayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomCheckBoxgetAllowGrayed';
inc(k);
Methods[k].Name := 'TCustomButtonClick';
Methods[k].meth := @TCustomButtonClick;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonClick';
inc(k);
Methods[k].Name := 'TCustomButtonExecuteDefaultAction';
Methods[k].meth := @TCustomButtonExecuteDefaultAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonExecuteDefaultAction';
inc(k);
Methods[k].Name := 'TCustomButtonExecuteCancelAction';
Methods[k].meth := @TCustomButtonExecuteCancelAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonExecuteCancelAction';
inc(k);
Methods[k].Name := 'TCustomButtonUpdateRolesForForm';
Methods[k].meth := @TCustomButtonUpdateRolesForForm;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonUpdateRolesForForm';
inc(k);
Methods[k].Name := 'TCustomButtongetActive';
Methods[k].meth := @TCustomButtongetActive;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtongetActive';
inc(k);
Methods[k].Name := 'TCustomButtonsetDefault';
Methods[k].meth := @TCustomButtonsetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonsetDefault';
inc(k);
Methods[k].Name := 'TCustomButtongetDefault';
Methods[k].meth := @TCustomButtongetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtongetDefault';
inc(k);
Methods[k].Name := 'TCustomButtonsetCancel';
Methods[k].meth := @TCustomButtonsetCancel;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonsetCancel';
inc(k);
Methods[k].Name := 'TCustomButtongetCancel';
Methods[k].meth := @TCustomButtongetCancel;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtongetCancel';
inc(k);
Methods[k].Name := 'TControlAdjustSize';
Methods[k].meth := @TControlAdjustSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAdjustSize';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayed';
Methods[k].meth := @TControlAutoSizeDelayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAutoSizeDelayed';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayedReport';
Methods[k].meth := @TControlAutoSizeDelayedReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAutoSizeDelayedReport';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayedHandle';
Methods[k].meth := @TControlAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TControlAnchorClient';
Methods[k].meth := @TControlAnchorClient;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAnchorClient';
inc(k);
Methods[k].Name := 'TControlAnchoredControlCount';
Methods[k].meth := @TControlAnchoredControlCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAnchoredControlCount';
inc(k);
Methods[k].Name := 'TControlSetBounds';
Methods[k].meth := @TControlSetBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlSetBounds';
inc(k);
Methods[k].Name := 'TControlSetInitialBounds';
Methods[k].meth := @TControlSetInitialBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlSetInitialBounds';
inc(k);
Methods[k].Name := 'TControlGetDefaultWidth';
Methods[k].meth := @TControlGetDefaultWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetDefaultWidth';
inc(k);
Methods[k].Name := 'TControlGetDefaultHeight';
Methods[k].meth := @TControlGetDefaultHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetDefaultHeight';
inc(k);
Methods[k].Name := 'TControlCNPreferredSizeChanged';
Methods[k].meth := @TControlCNPreferredSizeChanged;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlCNPreferredSizeChanged';
inc(k);
Methods[k].Name := 'TControlInvalidatePreferredSize';
Methods[k].meth := @TControlInvalidatePreferredSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlInvalidatePreferredSize';
inc(k);
Methods[k].Name := 'TControlWriteLayoutDebugReport';
Methods[k].meth := @TControlWriteLayoutDebugReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlWriteLayoutDebugReport';
inc(k);
Methods[k].Name := 'TControlShouldAutoAdjustLeftAndTop';
Methods[k].meth := @TControlShouldAutoAdjustLeftAndTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlShouldAutoAdjustLeftAndTop';
inc(k);
Methods[k].Name := 'TControlBeforeDestruction';
Methods[k].meth := @TControlBeforeDestruction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlBeforeDestruction';
inc(k);
Methods[k].Name := 'TControlEditingDone';
Methods[k].meth := @TControlEditingDone;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlEditingDone';
inc(k);
Methods[k].Name := 'TControlExecuteDefaultAction';
Methods[k].meth := @TControlExecuteDefaultAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlExecuteDefaultAction';
inc(k);
Methods[k].Name := 'TControlExecuteCancelAction';
Methods[k].meth := @TControlExecuteCancelAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlExecuteCancelAction';
inc(k);
Methods[k].Name := 'TControlBeginDrag';
Methods[k].meth := @TControlBeginDrag;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlBeginDrag';
inc(k);
Methods[k].Name := 'TControlEndDrag';
Methods[k].meth := @TControlEndDrag;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlEndDrag';
inc(k);
Methods[k].Name := 'TControlBringToFront';
Methods[k].meth := @TControlBringToFront;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlBringToFront';
inc(k);
Methods[k].Name := 'TControlHasParent';
Methods[k].meth := @TControlHasParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlHasParent';
inc(k);
Methods[k].Name := 'TControlIsVisible';
Methods[k].meth := @TControlIsVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsVisible';
inc(k);
Methods[k].Name := 'TControlIsControlVisible';
Methods[k].meth := @TControlIsControlVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsControlVisible';
inc(k);
Methods[k].Name := 'TControlIsEnabled';
Methods[k].meth := @TControlIsEnabled;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsEnabled';
inc(k);
Methods[k].Name := 'TControlIsParentColor';
Methods[k].meth := @TControlIsParentColor;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsParentColor';
inc(k);
Methods[k].Name := 'TControlIsParentFont';
Methods[k].meth := @TControlIsParentFont;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsParentFont';
inc(k);
Methods[k].Name := 'TControlFormIsUpdating';
Methods[k].meth := @TControlFormIsUpdating;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlFormIsUpdating';
inc(k);
Methods[k].Name := 'TControlIsProcessingPaintMsg';
Methods[k].meth := @TControlIsProcessingPaintMsg;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsProcessingPaintMsg';
inc(k);
Methods[k].Name := 'TControlHide';
Methods[k].meth := @TControlHide;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlHide';
inc(k);
Methods[k].Name := 'TControlRefresh';
Methods[k].meth := @TControlRefresh;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlRefresh';
inc(k);
Methods[k].Name := 'TControlRepaint';
Methods[k].meth := @TControlRepaint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlRepaint';
inc(k);
Methods[k].Name := 'TControlInvalidate';
Methods[k].meth := @TControlInvalidate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlInvalidate';
inc(k);
Methods[k].Name := 'TControlSendToBack';
Methods[k].meth := @TControlSendToBack;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlSendToBack';
inc(k);
Methods[k].Name := 'TControlUpdateRolesForForm';
Methods[k].meth := @TControlUpdateRolesForForm;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUpdateRolesForForm';
inc(k);
Methods[k].Name := 'TControlGetTextLen';
Methods[k].meth := @TControlGetTextLen;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetTextLen';
inc(k);
Methods[k].Name := 'TControlShow';
Methods[k].meth := @TControlShow;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlShow';
inc(k);
Methods[k].Name := 'TControlUpdate';
Methods[k].meth := @TControlUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUpdate';
inc(k);
Methods[k].Name := 'TControlHandleObjectShouldBeVisible';
Methods[k].meth := @TControlHandleObjectShouldBeVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlHandleObjectShouldBeVisible';
inc(k);
Methods[k].Name := 'TControlParentDestroyingHandle';
Methods[k].meth := @TControlParentDestroyingHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlParentDestroyingHandle';
inc(k);
Methods[k].Name := 'TControlParentHandlesAllocated';
Methods[k].meth := @TControlParentHandlesAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlParentHandlesAllocated';
inc(k);
Methods[k].Name := 'TControlInitiateAction';
Methods[k].meth := @TControlInitiateAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlInitiateAction';
inc(k);
Methods[k].Name := 'TControlShowHelp';
Methods[k].meth := @TControlShowHelp;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlShowHelp';
inc(k);
Methods[k].Name := 'TControlsetAccessibleDescription';
Methods[k].meth := @TControlsetAccessibleDescription;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetAccessibleDescription';
inc(k);
Methods[k].Name := 'TControlgetAccessibleDescription';
Methods[k].meth := @TControlgetAccessibleDescription;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetAccessibleDescription';
inc(k);
Methods[k].Name := 'TControlsetAccessibleValue';
Methods[k].meth := @TControlsetAccessibleValue;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetAccessibleValue';
inc(k);
Methods[k].Name := 'TControlgetAccessibleValue';
Methods[k].meth := @TControlgetAccessibleValue;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetAccessibleValue';
inc(k);
Methods[k].Name := 'TControlsetAutoSize';
Methods[k].meth := @TControlsetAutoSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetAutoSize';
inc(k);
Methods[k].Name := 'TControlgetAutoSize';
Methods[k].meth := @TControlgetAutoSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetAutoSize';
inc(k);
Methods[k].Name := 'TControlsetCaption';
Methods[k].meth := @TControlsetCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetCaption';
inc(k);
Methods[k].Name := 'TControlgetCaption';
Methods[k].meth := @TControlgetCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetCaption';
inc(k);
Methods[k].Name := 'TControlsetClientHeight';
Methods[k].meth := @TControlsetClientHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetClientHeight';
inc(k);
Methods[k].Name := 'TControlgetClientHeight';
Methods[k].meth := @TControlgetClientHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetClientHeight';
inc(k);
Methods[k].Name := 'TControlsetClientWidth';
Methods[k].meth := @TControlsetClientWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetClientWidth';
inc(k);
Methods[k].Name := 'TControlgetClientWidth';
Methods[k].meth := @TControlgetClientWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetClientWidth';
inc(k);
Methods[k].Name := 'TControlsetEnabled';
Methods[k].meth := @TControlsetEnabled;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetEnabled';
inc(k);
Methods[k].Name := 'TControlgetEnabled';
Methods[k].meth := @TControlgetEnabled;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetEnabled';
inc(k);
Methods[k].Name := 'TControlsetIsControl';
Methods[k].meth := @TControlsetIsControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetIsControl';
inc(k);
Methods[k].Name := 'TControlgetIsControl';
Methods[k].meth := @TControlgetIsControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetIsControl';
inc(k);
Methods[k].Name := 'TControlgetMouseEntered';
Methods[k].meth := @TControlgetMouseEntered;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetMouseEntered';
inc(k);
Methods[k].Name := 'TControlsetShowHint';
Methods[k].meth := @TControlsetShowHint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetShowHint';
inc(k);
Methods[k].Name := 'TControlgetShowHint';
Methods[k].meth := @TControlgetShowHint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetShowHint';
inc(k);
Methods[k].Name := 'TControlsetVisible';
Methods[k].meth := @TControlsetVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetVisible';
inc(k);
Methods[k].Name := 'TControlgetVisible';
Methods[k].meth := @TControlgetVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetVisible';
inc(k);
Methods[k].Name := 'TControlgetFloating';
Methods[k].meth := @TControlgetFloating;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetFloating';
inc(k);
Methods[k].Name := 'TControlsetLRDockWidth';
Methods[k].meth := @TControlsetLRDockWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetLRDockWidth';
inc(k);
Methods[k].Name := 'TControlgetLRDockWidth';
Methods[k].meth := @TControlgetLRDockWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetLRDockWidth';
inc(k);
Methods[k].Name := 'TControlsetTBDockHeight';
Methods[k].meth := @TControlsetTBDockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetTBDockHeight';
inc(k);
Methods[k].Name := 'TControlgetTBDockHeight';
Methods[k].meth := @TControlgetTBDockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetTBDockHeight';
inc(k);
Methods[k].Name := 'TControlsetUndockHeight';
Methods[k].meth := @TControlsetUndockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetUndockHeight';
inc(k);
Methods[k].Name := 'TControlgetUndockHeight';
Methods[k].meth := @TControlgetUndockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetUndockHeight';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftAlignment';
Methods[k].meth := @TControlUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftReading';
Methods[k].meth := @TControlUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftScrollBar';
Methods[k].meth := @TControlUseRightToLeftScrollBar;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUseRightToLeftScrollBar';
inc(k);
Methods[k].Name := 'TControlIsRightToLeft';
Methods[k].meth := @TControlIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsRightToLeft';
inc(k);
Methods[k].Name := 'TControlsetLeft';
Methods[k].meth := @TControlsetLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetLeft';
inc(k);
Methods[k].Name := 'TControlgetLeft';
Methods[k].meth := @TControlgetLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetLeft';
inc(k);
Methods[k].Name := 'TControlsetHeight';
Methods[k].meth := @TControlsetHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetHeight';
inc(k);
Methods[k].Name := 'TControlgetHeight';
Methods[k].meth := @TControlgetHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetHeight';
inc(k);
Methods[k].Name := 'TControlsetTop';
Methods[k].meth := @TControlsetTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetTop';
inc(k);
Methods[k].Name := 'TControlgetTop';
Methods[k].meth := @TControlgetTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetTop';
inc(k);
Methods[k].Name := 'TControlsetWidth';
Methods[k].meth := @TControlsetWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetWidth';
inc(k);
Methods[k].Name := 'TControlgetWidth';
Methods[k].meth := @TControlgetWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetWidth';
inc(k);
Methods[k].Name := 'TControlsetHelpKeyword';
Methods[k].meth := @TControlsetHelpKeyword;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetHelpKeyword';
inc(k);
Methods[k].Name := 'TControlgetHelpKeyword';
Methods[k].meth := @TControlgetHelpKeyword;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetHelpKeyword';
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
