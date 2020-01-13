{ $Header: $
  Infinity Explorer savegame viewer frame
  Copyright (C) 2000-01 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameSaveGame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Infinity, InfMain, InfStruc, Grids, StdCtrls, Hyperlink;

type
  TSaveGameFrame = class(TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    VarGrid: TStringGrid;
    KillVarsPage: TTabSheet;
    KillVarGrid: TStringGrid;
    Label1: TLabel;
    EdtPartyGold: TEdit;
    Label2: TLabel;
    EdtArea: THyperlinkEdit;
    Label3: TLabel;
    EdtGameTime: TEdit;
    TabSheet3: TTabSheet;
    JournalGrid: TStringGrid;
  private
    procedure FillVarGrid (const Vars: array of TGameVarRec; AGrid: TStringGrid);
    procedure FillJournalGrid (const Journal: array of TGameJournalRec);
  public
    procedure ViewSaveGame (SaveGame: TSaveGame);
  end;

  TSaveGameFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure ViewSaveGame (SaveGame: TSaveGame);
  end;

implementation

{$R *.DFM}

{ TSaveGameFrame }

procedure TSaveGameFrame.ViewSaveGame (SaveGame: TSaveGame);
begin
  if not SaveGame.Loaded then SaveGame.Load;
  with SaveGame.HdrCommon do begin
    EdtGameTime.Text := IntToStr (GameTime div (5*60*24)) + ' days ' +
        IntToStr ((GameTime mod (5 * 60 *24)) div (5*60)) + ' hours';
    EdtPartyGold.Text := IntToStr (Gold);
    EdtArea.ResRef := AreaResRef;
  end;
  FillVarGrid (SaveGame.Vars, VarGrid);
  if Game.GameType = gtTorment then begin
    KillVarsPage.TabVisible := true;
    FillVarGrid (SaveGame.KillVars, KillVarGrid);
  end
  else
    KillVarsPage.TabVisible := false;
  FillJournalGrid (SaveGame.Journal);
end;

procedure TSaveGameFrame.FillVarGrid (const Vars: array of TGameVarRec;
  AGrid: TStringGrid);
var
  i: integer;
begin
  AGrid.RowCount := High (Vars) + 2;
  AGrid.Cells [0, 0] := 'Name';
  AGrid.Cells [1, 0] := 'Value';
  for i := 0 to High (Vars) do
    with Vars [i] do begin
      AGrid.Cells [0, i+1] := Name;
      AGrid.Cells [1, i+1] := IntToStr (Value);
    end;
end;

procedure TSaveGameFrame.FillJournalGrid (const Journal: array of TGameJournalRec);
var
  i: integer;
begin
  with JournalGrid do begin
    Cells [0, 0] := 'Chapter';
    Cells [1, 0] := 'Time';
    Cells [2, 0] := 'Text';
    if Length (Journal) = 0 then begin
      RowCount := 2;
      Cells [0, 1] := 'None';
      for i := 1 to ColCount-1 do
        Cells [i, 1] := '';
    end
    else begin
      RowCount := Length (Journal)+1;
      for i := 0 to Length (Journal)-1 do begin
        Cells [0, i+1] := IntToStr (Journal [i].Chapter);
        Cells [1, i+1] := IntToStr (Journal [i].Time);
        Cells [2, i+1] := Game.TLK.Text [Journal [i].TextStrref];
      end;
    end;
  end;
end;

{ TSaveGameFrameProxy }

constructor TSaveGameFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TSaveGameFrame;
end;

procedure TSaveGameFrameProxy.DoViewFile (AFile: TGameFile);
begin
  // because a TSaveGame is not a TGameFile, DoViewFile is just a do-nothing stub.
end;

procedure TSaveGameFrameProxy.ViewSaveGame (SaveGame: TSaveGame);
begin
  if FFrame = nil then FFrame := TSaveGameFrame.Create (FOwner);
  TSaveGameFrame (FFrame).ViewSaveGame (SaveGame);
end;

end.
