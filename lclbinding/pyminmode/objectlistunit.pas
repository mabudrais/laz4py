unit objectlistunit;

{$mode delphi}

interface

uses
  Classes, SysUtils, contnrs, fgl;

type



  { Tlaz4py }



  Tlaz4py = class

  public

    objlist: TList;

    objshash: TFPHashList;

    last_num: integer;

    constructor Create();

    function add_obj(obj: Pointer): integer;

    function get_obj(hashnum: integer): Pointer;

  end;



implementation



{ Tlaz4py }



constructor Tlaz4py.Create;

begin

  objlist := TList.Create;

  objshash := objshash.Create;

  last_num := 0;

end;



function Tlaz4py.add_obj(obj: Pointer): integer;

begin

  objlist.Add(obj);

  Result := objlist.Count - 1;

end;



function Tlaz4py.get_obj(hashnum: integer): Pointer;

begin

  Result := objlist.Items[hashnum];

end;



end.


