unit TpylabelUnit;

{$mode delphi}

interface

uses
  Classes, SysUtils, Controls, PyAPI, objectlistunit, pyutil, StdCtrls,
  callbacunit, Forms;

type
  Tpylabel = class(TButton)
    constructor Create(obj: Tlaz4py);
    procedure reg(var k: integer; var Methods:  array of PyMethodDef);
  end;

implementation

function setShowAccelChar(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  control.ShowAccelChar := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getShowAccelChar(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  Result := PyInt_FromLong(booltoint(control.ShowAccelChar));
end;

function setTransparent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  control.Transparent := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getTransparent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  Result := PyInt_FromLong(booltoint(control.Transparent));
end;

function setWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  control.WordWrap := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  Result := PyInt_FromLong(booltoint(control.WordWrap));
end;

function setOptimalFill(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  control.OptimalFill := inttobool(para);
  Result := PyInt_FromLong(0);
end;

function getOptimalFill(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
  control: TLabel;
  para: integer;
  control_hash: integer;
begin
  PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
  control := TLabel(control_hash);
  Result := PyInt_FromLong(booltoint(control.OptimalFill));
end;

constructor Tpylabel.Create(obj: Tlaz4py);
begin

end;

procedure Tpylabel.reg(var k: integer; var Methods: packed array of PyMethodDef);
begin
  Inc(k);
  Methods[k].Name := 'setShowAccelChar';
  Methods[k].meth := @setShowAccelChar;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ShowAccelChar';
  Inc(k);
  Methods[k].Name := 'getShowAccelChar';
  Methods[k].meth := @getShowAccelChar;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set ShowAccelChar';
  Inc(k);
  Methods[k].Name := 'setTransparent';
  Methods[k].meth := @setTransparent;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Transparent';
  Inc(k);
  Methods[k].Name := 'getTransparent';
  Methods[k].meth := @getTransparent;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set Transparent';
  Inc(k);
  Methods[k].Name := 'setWordWrap';
  Methods[k].meth := @setWordWrap;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set WordWrap';
  Inc(k);
  Methods[k].Name := 'getWordWrap';
  Methods[k].meth := @getWordWrap;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set WordWrap';
  Inc(k);
  Methods[k].Name := 'setOptimalFill';
  Methods[k].meth := @setOptimalFill;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OptimalFill';
  Inc(k);
  Methods[k].Name := 'getOptimalFill';
  Methods[k].meth := @getOptimalFill;
  Methods[k].flags := METH_VARARGS;
  Methods[k].doc := 'set OptimalFill';
end;

end.
