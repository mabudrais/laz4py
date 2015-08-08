unit PyAPI;
 
{ 
 
  Minimum set of Python function declarations for module libraries.
 
  Author: Phil (MacPgmr at fastermac.net).
 
  To add other Python function declarations, see the Python header
   files (.h) included with every Python distribution.
 
}
 
{$IFDEF FPC}
 {$MODE Delphi}
{$ENDIF} 
 
interface
 
{$DEFINE IS32BIT}
{$IFDEF CPUX64}  {Delphi}
 {$UNDEF IS32BIT}
{$ENDIF}
{$IFDEF CPU64}  {FPC}
 {$UNDEF IS32BIT}
{$ENDIF}
 
const
{$IFDEF MSWINDOWS}
 {$IFDEF USE_PYTHON23}
  PythonLib = 'python23.dll';
 {$ELSE}
  PythonLib = 'python27.dll';
 {$ENDIF}
{$ENDIF} 
 
{$IFDEF LINUX}
 {$IFDEF USE_PYTHON23}
  PythonLib = 'python23.so';
 {$ELSE}
  PythonLib = 'python27.so';
 {$ENDIF}
{$ENDIF} 
 
{$IFDEF DARWIN}
  PythonLib = '';  //Link against Python.framework (-k'-framework Python').
                   // To link against a specific version of Python, pass the
                   // full path to that version's library instead, for example,
                   //  -k'/System/Library/Frameworks/Python.framework/Versions/2.6/Python'
{$ENDIF} 
 
type
{$IFDEF IS32BIT}
  c_long = LongInt;
  c_ulong = LongWord;
  c_int  = LongInt;
{$ELSE}
  c_long = Int64;
  c_ulong = UInt64;
  c_int = Int64;  //"int" also appears to be 8 bytes with 64-bit Python
{$ENDIF}
 
  PyMethodDef = packed record
    name  : PAnsiChar;  //Python function name
    meth  : Pointer;    //Address of function that implements it
    flags : c_int;      //METH_xxx flags; describe function's arguments
    doc   : PAnsiChar;  //Description of funtion
    end;
 
  PyObject = Pointer;
 
const
{$IFDEF USE_PYTHON23}
  PYTHON_API_VERSION = 1012;  //Also used with Python 2.4
{$ELSE}
  PYTHON_API_VERSION = 1013;
{$ENDIF}
  METH_VARARGS = 1;
 
function Py_InitModule(    name    : PAnsiChar;
                       var methods : PyMethodDef;
                           doc     : PAnsiChar = nil;
                           self    : PyObject = nil;
                           apiver  : c_int = PYTHON_API_VERSION) : PyObject; cdecl; 
          external PythonLib name {$IFDEF IS32BIT}'Py_InitModule4'{$ELSE}'Py_InitModule4_64'{$ENDIF};
 
function PyArg_ParseTuple(args   : PyObject; 
                          format : PAnsiChar) : c_int; cdecl; varargs; external PythonLib;
 //Note varargs allows us to simulate C variable number of arguments (...).
 function Py_BuildValue(format : PAnsiChar) :PyObject; cdecl; varargs; external PythonLib;
function PyInt_FromLong(along : c_long) : PyObject; cdecl; external PythonLib;
 
function PyLong_FromLong(along : c_long) : PyObject; cdecl; external PythonLib;
 
function PyLong_FromUnsignedLong(aulong : c_ulong) : PyObject; cdecl; external PythonLib; 
 
function PyString_FromString(astr : PAnsiChar) : PyObject; cdecl; external PythonLib;

function PyCallable_Check(call:PyObject):c_int; cdecl; external PythonLib;

function Py_IncRef(obj:PyObject) : PyObject; cdecl; external PythonLib;

function Py_DecRef(obj:PyObject) : PyObject; cdecl; external PythonLib;

function Py_XINCREF(var obj:PyObject) : PyObject; cdecl; external PythonLib;

 function Py_XDECREF(var obj:PyObject) : PyObject; cdecl; external PythonLib;

// function Py_DECREF(var obj:PyObject) : PyObject; cdecl; external PythonLib;

 function PyCapsule_New( p:pointer; name: PAnsiChar; PyCapsule_Destructor :Pointer) : PyObject; cdecl; external PythonLib;

function PyModule_AddObject(module:PyObject ; name: PAnsiChar;value:PyObject ):c_int ; cdecl; external PythonLib;

function PyCapsule_Import(name: PAnsiChar; no_block:c_int):Pointer; cdecl; external PythonLib;

function PyObject_CallObject(callable_object:PyObject;arg:PyObject):PyObject; cdecl; external PythonLib;

function PyObject_GetAttrString(obj:PyObject;name: PAnsiChar):PyObject; cdecl; external PythonLib;

function PyObject_SetAttrString(obj:PyObject;name: PAnsiChar;val:PyObject):PyObject; cdecl; external PythonLib;
implementation
 
 
end.
