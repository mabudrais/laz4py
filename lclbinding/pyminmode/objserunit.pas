unit ObjserUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, typinfo, StdCtrls, Forms, Controls, Dialogs, Menus,
  LResources, PyAPI;

type

  { Tlfmreader }

  Tlfmreader = class
  private
    function create_object(objname, objtype: string): boolean;
    procedure OnFindClass(Reader: TReader; const AClassName: string;
      var ComponentClass: TComponentClass);

  public
    objlist: TList;
    objectType: TStringList;
    constructor Create(var f: TForm; filename: string);
    procedure readlfm(var f: TForm; filename: string);
    function setcompnentpointer(f: TForm; target: string): string;
  end;

implementation

{ Tlfmreader }

constructor Tlfmreader.Create(var f: TForm; filename: string);
begin
end;

procedure Tlfmreader.readlfm(var f: TForm; filename: string);
var
  strlist: TStringList;
  NewComponent: TComponent;
  AStream: TMemoryStream;
  ststream: TStringStream;
  txtf: TextFile;
  cntentstr, temp: string;
begin
  strlist := TStringList.Create;
  strlist.LoadFromFile(filename);
 { AssignFile(txtf,'G:\dev\laz4py\laz4py3\streamtest\unit2.lfm');
   Reset(txtf);
    while not EOF(txtf) do
  begin
    Readln(txtf, temp);
    cntentstr:=cntentstr+temp;
    cntentstr:=cntentstr+LineEnding;
  end;
  CloseFile(txtf);   }
  try
    //cntentstr := 'object Form22: TForm'#13#10'  Left = 229'#13#10'  Height = 393'#13#10'  Top = 130'#13#10'  Width = 668'#13#10'  Caption = ''Form1'''#13#10'  ClientHeight = 393'#13#10'  ClientWidth = 668'#13#10'  LCLVersion = ''1.2.6.0'''#13#10'  object Button1: TButton'#13#10'    Left = 494'#13#10'    Height = 25'#13#10'    Top = 97'#13#10'    Width = 75'#13#10'    Caption = ''Button1'''#13#10'    TabOrder = 1'#13#10'  end'#13#10'end'#13#10;
    cntentstr := strlist.Text;
    //AStream := TMemoryStream.Create;
    ststream := TStringStream.Create(cntentstr);

    // ReadStreamFromString(AStream);

    NewComponent := nil;

    // ReadComponentFromBinaryStream(AStream,NewComponent,
    //                          @OnFindClass,DestinationGroupBox);
    ReadComponentFromTextStream(ststream, NewComponent, @OnFindClass);
    // ShowMessage('oo2');
  finally
    ststream.Free;
  end;
  f := TForm(NewComponent);
  strlist.Free;
end;

function Tlfmreader.setcompnentpointer(f: TForm; target: string): string;
var
  i, k: integer;
  compname, pstr: string;
  strlist: TStringList;
begin
  strlist := TStringList.Create;
  ExtractStrings(['*'], [' '], PChar(target), strlist);
  pstr := IntToStr(integer(Pointer(f)));
  for k := 0 to strlist.Count - 1 do
  begin
    i := 0;
    while i < f.ComponentCount do
    begin
      compname := f.Components[i].Name;
      if compname = strlist[k] then
        Break;
      Inc(i);
    end;
    if i < f.ComponentCount then
      pstr := pstr + '*' + IntToStr(integer(Pointer(f.Components[i])))
    else
      pstr := pstr + '*' + '-1';
  end;
  strlist.Free;
  Result := pstr;
end;

procedure Tlfmreader.OnFindClass(Reader: TReader; const AClassName: string;
  var ComponentClass: TComponentClass);
begin
  if CompareText(AClassName, 'TGroupBox') = 0 then
    ComponentClass := TGroupBox
  else if CompareText(AClassName, 'TCheckBox') = 0 then
    ComponentClass := TCheckBox
  else if CompareText(AClassName, 'TRadioButton') = 0 then
    ComponentClass := TRadioButton
  else if CompareText(AClassName, 'TForm') = 0 then
    ComponentClass := TForm
  else if CompareText(AClassName, 'TButton') = 0 then
    ComponentClass := TButton
  else if CompareText(AClassName, 'TEdit') = 0 then
    ComponentClass := TEdit
  else if CompareText(AClassName, 'TLabel') = 0 then
    ComponentClass := TLabel
  else if CompareText(AClassName, 'TMemo') = 0 then
    ComponentClass := TMemo
  else if CompareText(AClassName, 'TMainMenu') = 0 then
    ComponentClass := TMainMenu
  else if CompareText(AClassName, 'TMenuItem') = 0 then
    ComponentClass := TMenuItem
  else if CompareText(AClassName, 'TPopupMenu') = 0 then
    ComponentClass := TPopupMenu;
end;

function Tlfmreader.create_object(objname, objtype: string): boolean;
var
  cont: Pointer;
  cname: string;
  created: boolean;
  ind: integer;
begin
  created := False;
  ind := objectType.IndexOf('unknown');
  if ind > -1 then
  begin
    cont := TButton.Create(TComponent(objlist.Last));
    objlist.Add(cont);
    objectType.Add('unknown');
    exit;
  end;
  cname := StringReplace(objname, ':', '', []); //name correction

  if objtype = 'TScrollBar' then
  begin
    cont := TScrollBar.Create(TComponent(objlist.Last));
    TScrollBar(cont).Name := cname;
    TScrollBar(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TComboBox' then
  begin
    cont := TComboBox.Create(TComponent(objlist.Last));
    TComboBox(cont).Name := cname;
    TComboBox(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TListBox' then
  begin
    cont := TListBox.Create(TComponent(objlist.Last));
    TListBox(cont).Name := cname;
    TListBox(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TRadioButton' then
  begin
    cont := TRadioButton.Create(TComponent(objlist.Last));
    TRadioButton(cont).Name := cname;
    TRadioButton(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TCheckBox' then
  begin
    cont := TCheckBox.Create(TComponent(objlist.Last));
    TCheckBox(cont).Name := cname;
    TCheckBox(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TToggleBox' then
  begin
    cont := TToggleBox.Create(TComponent(objlist.Last));
    TToggleBox(cont).Name := cname;
    TToggleBox(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TEdit' then
  begin
    cont := TEdit.Create(TComponent(objlist.Last));
    TEdit(cont).Name := cname;
    TEdit(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TLabel' then
  begin
    cont := TLabel.Create(TComponent(objlist.Last));
    TLabel(cont).Name := cname;
    TLabel(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TButton' then
  begin
    cont := TButton.Create(TComponent(objlist.Last));
    TButton(cont).Name := cname;
    TButton(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TPopupMenu' then
  begin
    cont := TPopupMenu.Create(TComponent(objlist.Last));
    TPopupMenu(cont).Name := cname;
    TPopupMenu(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TMainMenu' then
  begin
    cont := TMainMenu.Create(TComponent(objlist.Last));
    TMainMenu(cont).Name := cname;
    TMainMenu(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TForm' then
  begin
    cont := TForm.Create(TComponent(objlist.Last));
    TForm(cont).Name := cname;
    TForm(cont).Parent := TWinControl(objlist.Last);
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;


  if objtype = 'TMenuItem' then
  begin
    cont := TMenuItem.Create(TComponent(objlist.Last));
    TMenuItem(cont).Name := cname;
    if (objectType.Strings[objectType.Count - 1] = 'TMenuItem') then
      TMenuItem(objlist.Last).Add(TMenuItem(cont))
    else
      TMainMenu(objlist.Last).Items.Add(TMenuItem(cont));
    objlist.Add(cont);
    objectType.Add(objtype);
    created := True;
  end;
  if objtype = 'TForm' then
  begin
    created := True;
  end;
  if not created then
  begin
    cont := TButton.Create(TComponent(objlist.Last));
    objlist.Add(cont);
    objectType.Add('unknown');
  end;
  Result := created;
end;

end.
