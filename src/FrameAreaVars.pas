{ $Header: $
  Infinity Engine area variable viewer frame
  Copyright (C) 2001 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameAreaVars;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, InfStruc;

type
  TAreaVarsFrame = class(TFrame)
    VarsGrid: TStringGrid;
  private
    { Private declarations }
  public
    procedure ShowVars (const Vars: array of TGameVarRec);
  end;

implementation

{$R *.DFM}

{ TAreaVarsFrame }

procedure TAreaVarsFrame.ShowVars (const Vars: array of TGameVarRec);
var
  i: integer;
begin
  with VarsGrid do begin
    Cells [0, 0] := 'Name';
    Cells [1, 0] := 'Value';
    if Length (Vars) = 0 then begin
      RowCount := 2;
      Cells [0, 1] := 'None';
      Cells [1, 1] := '';
    end
    else begin
      RowCount := Length (Vars)+1;
      for i := 0 to High (Vars) do begin
        Cells [0, i+1] := Vars [i].Name;
        Cells [1, i+1] := IntToStr (Vars [i].Value);
      end;
    end;
  end;
end;

end.
