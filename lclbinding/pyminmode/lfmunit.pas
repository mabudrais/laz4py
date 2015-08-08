unit lfmunit;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms;

type

  { lfmform }

  lfmform = class
    constructor Create(f: TForm; filenam: string);
  end;

implementation

{ lfmform }

constructor lfmform.Create(f: TForm; filenam: string);
var
  strlist: TStringList;
begin
  strlist := TStringList.Create;
  //strlist.load;
end;

end.
