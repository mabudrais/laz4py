unit TpyTbuttonUnit;

{$mode delphi}

interface

uses
  Classes, SysUtils, Controls, PyAPI, objectlistunit, pyutil, StdCtrls,
  callbacunit, Forms;

type
  Tpybutton = class(TButton)
    constructor Create(obj: Tlaz4py);
    procedure reg(var k: integer; var Methods:  array of PyMethodDef);
  end;

implementation

function setCancel(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TButton;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TButton(control_hash);
  control.Cancel := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getCancel(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TButton;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TButton(control_hash);
  Result := PyInt_FromLong(booltoint(control.Cancel));
end;

function setDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TButton;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TButton(control_hash);
  control.Default := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TButton;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TButton(control_hash);
  Result := PyInt_FromLong(booltoint(control.Default));
end;

function setModalResult(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TButton;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TButton(control_hash);
  control.ModalResult := para;
  Result := PyInt_FromLong(0);
end;

function getModalResult(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TButton;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TButton(control_hash);
  Result := PyInt_FromLong(control.ModalResult);
end;

constructor Tpybutton.Create(obj: Tlaz4py);
begin

end;

procedure Tpybutton.reg(var k: integer; var Methods: packed array of PyMethodDef);
begin
  Inc(k);
  Methods[k].Name := 'setCancel';
  Methods[k].meth := @setCancel;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Cancel';
  Inc(k);
  Methods[k].Name := 'getCancel';
  Methods[k].meth := @getCancel;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Cancel';
  Inc(k);
  Methods[k].Name := 'setDefault';
  Methods[k].meth := @setDefault;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Default';
  Inc(k);
  Methods[k].Name := 'getDefault';
  Methods[k].meth := @getDefault;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Default';
  Inc(k);
  Methods[k].Name := 'setModalResult';
  Methods[k].meth := @setModalResult;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ModalResult';
  Inc(k);
  Methods[k].Name := 'getModalResult';
  Methods[k].meth := @getModalResult;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ModalResult';
end;

end.
