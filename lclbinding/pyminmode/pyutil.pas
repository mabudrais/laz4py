unit pyutil;

{$mode delphi}

interface

uses
  Classes, SysUtils;

function booltoint(b: boolean): integer;
function inttobool(i:Integer):Boolean;
procedure freeoldcalbac(p:Integer);
implementation
uses callbacunit;
function booltoint(b: boolean): integer;
begin
  if b then
    Result := 1
  else
    Result := 0;
end;

function inttobool(i: Integer): Boolean;
begin
     if i=1 then
    Result := True
  else
    Result := False;
end;

procedure freeoldcalbac(p: Integer);
begin
  if p<>-1 then
    begin
     Tcallbac(Pointer(p)).Free;
    end;
end;

end.
