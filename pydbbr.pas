unit pydbbr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BaseDebugManager, Debugger, process,IDEMsgIntf,simpleipc;

type
  Tpydbthread = class;
  { TVDbg }

  Tpydbr = class(TDebugger)
  protected
    dbth: Tpydbthread;
    function GetSupportedCommands: TDBGCommands; override;
    function RequestCommand(const ACommand: TDBGCommand;
      const AParams: array of const): boolean; override;
  public
    class function Caption: string; override;
    function CreateBreakPoints: TDBGBreakPoints; override;
    function CreateLineInfo: TDBGLineInfo; override;
    function DoEvaluate(const AExpression: string; var AResult: string): boolean;
  end;

  { Tpydbthread }

  Tpydbthread = class(TThread)
  protected
    procedure start_process;
    procedure Execute; override;
  public
    cpydbr: Tpydbr;
    pdbpro,uipro: TProcess;
    mainfile: string;
    commands: TStringList;
    is_command_blocked, working_in_com_list: boolean;
    docurent_line,output_num: integer;
    docurent_source,last_output,msg: string;
    outputmsglist:TStringList;
    kill: boolean;
    ipcserver:TSimpleIPCServer;
    ipcclient:TSimpleIPCClient;
    procedure analys_input(const prooutput: string);
    constructor Create(pydbr: Tpydbr; file_name: string);
    procedure add_breakpoint(Source: string; line_num: integer);
    procedure execute_command(const com_to_execute: string);
    procedure set_breakpoint;
    function readinput(Process: TProcess): string;
    procedure SendInput(Process: TProcess; str: string);
    destructor Destroy; override;
    function wait_for_pdb: string;
    function wait_for_command: string;
    procedure add_command(command: string);
    procedure pause_ide;
    procedure contiue_ide;
    procedure Stop_ide;
    procedure error_ide;
    procedure docurent_ide;
    procedure addmessage_ide;
    function get_docurent_line(str: string): integer;
  end;

implementation

{ Tpydbthread }

procedure Tpydbthread.start_process;
var
  pro_arg: string;
begin
  pdbpro := TProcess.Create(nil);
  pro_arg := 'python -i -m pdb ' + mainfile;
  pdbpro.CommandLine := pro_arg;
  pdbpro.Options := [poUsePipes, poNoConsole];
  pdbpro.Execute;
  {uipro:=TProcess.Create(nil);
  uipro.CommandLine:='G:\dev\laz4py\temp3\p643254y.exe';
  uipro.Execute; }
  {ipcclient:=TSimpleIPCClient.Create(Nil);
  ipcclient.ServerID:='1545487';
  ipcclient.Connect;
  ipcserver:=TSimpleIPCServer.Create(Nil);
  ipcserver.ServerID:='19826378';
  ipcserver.Global:=True;
  ipcserver.StartServer;}
end;

constructor Tpydbthread.Create(pydbr: Tpydbr; file_name: string);
var
  i: integer;
begin
  FreeOnTerminate := True;
  inherited Create(False);
  cpydbr := pydbr;
  mainfile := file_name;
  is_command_blocked := False;
  working_in_com_list := False;
  kill := False;
  output_num:=0;
  commands := TStringList.Create;
  outputmsglist:=TStringList.Create;
end;

procedure Tpydbthread.analys_input(const prooutput: string);
begin
  if (pos('Uncaught exception', prooutput) > 0) then
  begin
    Synchronize(@error_ide);
    Exit;
  end;
  if (pos('The program finished and will be restarted', prooutput) > 0) then
  begin
    Synchronize(@Stop_ide);
    Exit;
  end;
  docurent_source := Trim(Copy(prooutput, 2, Pos('(', prooutput) - 2));
  docurent_line := get_docurent_line(prooutput);
  add_breakpoint(docurent_source, 6);
  if (FileExists(docurent_source)) then
  begin
    add_breakpoint('break on: ' + docurent_source, 100);
    Synchronize(@docurent_ide);
    Exit;
  end;
  if (pos('(Pdb)', prooutput) > 0) then
    Synchronize(@pause_ide)
  else
    Synchronize(@error_ide);
end;

procedure Tpydbthread.Execute;
var
  is_ready: boolean;
  prooutput, com_to_execute: string;
begin
  start_process;
  is_ready := False;
  wait_for_pdb();
  set_breakpoint();
  wait_for_pdb();
  SendInput(pdbpro, 'c' + LineEnding);
  docurent_line := -1;
  while (not kill) do
  begin
    analys_input(wait_for_pdb());
    execute_command(wait_for_command());
  end;
end;

procedure Tpydbthread.add_breakpoint(Source: string; line_num: integer);
var
  strl: TStringList;
begin
  strl := TStringList.Create;
  strl.LoadFromFile('G:\dev\laz4py\laz4py3\vdbg.txt');
  strl.Add(Source);
  strl.Add(IntToStr(line_num));
  strl.SaveToFile('G:\dev\laz4py\laz4py3\vdbg.txt');
end;

procedure Tpydbthread.execute_command(const com_to_execute: string);
begin
  SendInput(pdbpro, com_to_execute);
end;

procedure Tpydbthread.set_breakpoint;
var
  breakpointstr: string;
  i: integer;
begin
  for i := 0 to cpydbr.BreakPoints.Count - 1 do
  begin
    breakpointstr := breakpointstr + 'b ' + cpydbr.BreakPoints[i].Source +
      ':' + IntToStr(cpydbr.BreakPoints[i].Line);
    if not (i = cpydbr.BreakPoints.Count - 1) then
      breakpointstr := breakpointstr + ';;';
  end;
  breakpointstr := breakpointstr + LineEnding;
  if Length(breakpointstr) > 0 then
    SendInput(pdbpro, breakpointstr);
  add_breakpoint(breakpointstr, 10);
end;

function Tpydbthread.readinput(Process: TProcess): string;
var
  Buffer: string;
  BytesAvailable: DWord;
  BytesRead: longint;
  Outputstr: string;
begin
  if Process.Running then
  begin
    BytesAvailable := Process.Output.NumBytesAvailable;
    BytesRead := 0;
    while BytesAvailable > 0 do
    begin
      SetLength(Buffer, BytesAvailable);
      BytesRead := Process.OutPut.Read(Buffer[1], BytesAvailable);
      Outputstr := Outputstr + copy(Buffer, 1, BytesRead);
      BytesAvailable := Process.Output.NumBytesAvailable;
    end;
  end;
  last_output:=Outputstr;
  outputmsglist.AddText(Outputstr);
  Inc(output_num);
  //Synchronize(@addmessage_ide);
 // if not(Outputstr='') then
 // ipcclient.SendStringMessage(Outputstr);
  Result := Outputstr;
end;

procedure Tpydbthread.SendInput(Process: TProcess; str: string);
var
  InputStrings: string;
begin
  if Process.Running then
  begin
    InputStrings := str;
    Process.Input.Write(InputStrings[1], length(InputStrings));
  end;
end;

destructor Tpydbthread.Destroy;
begin
  pdbpro.Terminate(0);
  pdbpro.Free;
  inherited Destroy;
end;

function Tpydbthread.wait_for_pdb: string;
var
  proinput: string;
begin
  proinput := readinput(pdbpro);
  while ((Pos('(Pdb)', proinput) < 1) and (not kill)) do
  begin
    proinput := proinput + readinput(pdbpro);
    Sleep(100);
  end;
  add_breakpoint(proinput, 10);
  Result := proinput;
end;

function Tpydbthread.wait_for_command: string;
var
  found: boolean;
  server_msg:String;
begin
  found := False;
  while not found do
  begin
    working_in_com_list := True;
    while ((is_command_blocked) and (not kill)) do
      Sleep(100);
    {if ipcserver.PeekMessage(100,True) then
    begin
      Result:=ipcserver.StringMessage;
      found:=True;
    end;  }
    if commands.Count > 0 then
    begin
      Result := commands.Strings[0];
      commands.Delete(0);
      found := True;
    end;
    working_in_com_list := False;
    Sleep(100);
  end;
end;

procedure Tpydbthread.add_command(command: string);
begin
  is_command_blocked := True;
  while working_in_com_list do
    Sleep(100);
  commands.Add(command);
  is_command_blocked := False;
end;

procedure Tpydbthread.pause_ide;
begin
  cpydbr.SetState(dsPause);
end;

procedure Tpydbthread.contiue_ide;
begin
  cpydbr.SetState(dsRun);
end;

procedure Tpydbthread.Stop_ide;
begin
  cpydbr.SetState(dsStop);
end;

procedure Tpydbthread.error_ide;
begin
  cpydbr.SetState(dsError);
end;

procedure Tpydbthread.docurent_ide;
var
  loc: TDBGLocationRec;
begin
  loc.SrcFullName := docurent_source;
  loc.SrcLine := docurent_line;
  cpydbr.DoCurrent(loc);
  cpydbr.SetState(dsPause);
end;

procedure Tpydbthread.addmessage_ide;
var
  i:Integer;
begin
  IDEMessagesWindow.BeginBlock;
  for i:=0 to outputmsglist.Count-1 do
  IDEMessagesWindow.AddMsg(last_output,IntToStr(output_num),output_num);
  IDEMessagesWindow.EndBlock;
end;

function Tpydbthread.get_docurent_line(str: string): integer;
var
  par1, par2: integer;
  num_string: string;
  line_num: integer;
begin
  par1 := Pos('(', str);
  par2 := Pos(')', str);
  num_string := Trim(Copy(str, par1 + 1, par2 - par1 - 1));
  if TryStrToInt(num_string, line_num) then
    Result := StrToInt(num_string)
  else
    Result := -1;
end;

function Tpydbr.GetSupportedCommands: TDBGCommands;
begin
  Result := [dcRun, dcPause, dcStop, dcStepInto, dcBreak, dcEvaluate, dcStepOver];
end;

function Tpydbr.RequestCommand(const ACommand: TDBGCommand;
  const AParams: array of const): boolean;
var
  strl: TStringList;
  F: TextFile;
  loc: TDBGLocationRec;
  str: string;
begin
  if ACommand = dcStop then
  begin
    SetState(dsStop);
    dbth.pdbpro.Free;
    Exit(False);
  end;
  {if ACommand = dcEvaluate then
  begin
    str := string(AParams[0].VAnsiString);
    //AParams[1].VAnsiString:=Pointer(str);
    {if length(str) < 100 then
    begin
      AssignFile(F, 'G:\dev\laz4py\laz4py3\vdbg.txt');
      Rewrite(F);
      WriteLn(F, str + LineEnding);
      CloseFile(F);
      Exit(True);
    end;  }
    Exit(True);
  end;    }
  if ((ACommand = dcRun) and (State = dsStop)) then
  begin
    str := string(FileName);
    dbth := Tpydbthread.Create(Self, ExtractFilePath(FileName) + 'main.py');
    //loc.FuncName := 'project1.lpr';
    //loc.SrcFullName := 'G:\dev\laz4py\laz4py_testpro\main.py';
    //loc.SrcLine := 8;
    //DoCurrent(loc);
    SetState(dsRun);
    Exit(True);
  end;
  if ((ACommand = dcRun) and (State = dsPause)) then
  begin
    dbth.add_command('c' + LineEnding);
  end;
  if ((ACommand = dcStepOver) and (State = dsPause)) then
    dbth.add_command('n' + LineEnding);
  if ((ACommand = dcStepInto) and (State = dsPause)) then
    dbth.add_command('s' + LineEnding);
  if (ACommand = dcEvaluate) then
  begin
    Result := DoEvaluate(string(AParams[0].VAnsiString),
      string(AParams[1].VPointer^));
  end;
end;

class function Tpydbr.Caption: string;
begin
  Result := 'python debuger';
end;

function Tpydbr.DoEvaluate(const AExpression: string; var AResult: string): boolean;
var
  i,num_of_out:Integer;
  anystrlist:TStringList;
begin
  AResult :='failed to get value';
  dbth.add_command('p '+AExpression+LineEnding);
  num_of_out:=dbth.output_num;
  anystrlist:=TStringList.Create;
    i:=0;
    while ((i<4) and(num_of_out=dbth.output_num)) do
    begin
    Inc(i);
    Sleep(500);
    end;
    anystrlist.AddText(dbth.last_output);
    AResult:=anystrlist.Strings[0];
    anystrlist.Free;
  Result := True;
end;

function Tpydbr.CreateBreakPoints: TDBGBreakPoints;
begin
  Result := inherited CreateBreakPoints;
end;

function Tpydbr.CreateLineInfo: TDBGLineInfo;
begin
  Result := inherited CreateLineInfo;
end;

initialization

  RegisterDebugger(Tpydbr);
end.
