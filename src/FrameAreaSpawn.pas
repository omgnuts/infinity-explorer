{ $Header: $
  Infinity Engine area spawn point viewer frame
  Copyright (C) 2001 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameAreaSpawn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Hyperlink, StdCtrls, Infinity, InfMain, InfStruc;

type
  TAreaSpawnFrame = class (TFrame)
    GroupBox1: TGroupBox;
    CreGrid: THyperlinkGrid;
    procedure CreGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure CreGridJump(Sender: TObject; ACol, ARow: Integer);
  private
    FSpawn: TAreaSpawnRec;
  public
    procedure ShowSpawn (const Spawn: TAreaSpawnRec);
  end;

implementation

{$R *.DFM}

// -- TAreaSpawnFrame -------------------------------------------------------

procedure TAreaSpawnFrame.ShowSpawn (const Spawn: TAreaSpawnRec);
var
  i: integer;
begin
  FSpawn := Spawn;
  CreGrid.RowCount := Spawn.CreatureCount;
  for i := 0 to Spawn.CreatureCount-1 do
    CreGrid.Cells [0, i] := PChar8ToStr (Spawn.Creatures [i]);
end;

procedure TAreaSpawnFrame.CreGridCanJump (Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := true;
end;

procedure TAreaSpawnFrame.CreGridJump (Sender: TObject; ACol, ARow: Integer);
begin
  if (Game.GameType = gtBaldur) and (Copy (FSpawn.Creatures [ARow], 1, 2) = 'RD') then
    MainForm.BrowseToFile ('SPAWNGRP', ft2DA)
  else
    MainForm.BrowseToFile (FSpawn.Creatures [ARow], ftCRE);
end;

end.
