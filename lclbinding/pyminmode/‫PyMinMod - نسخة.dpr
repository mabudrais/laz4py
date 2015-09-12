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
    regall(k, Methods);
    //pyedit:=Tpyedit.create(Nil);
    //pyedit.reg(k,Methods);
    //inter := TFormpy.Create(nil);
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
