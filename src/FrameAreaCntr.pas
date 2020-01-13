{ $Header: /cvsroot/InfExp/InfExp/src/FrameAreaCntr.pas,v 1.4 2000/11/01 19:00:14 yole Exp $
  Infinity Engine area container viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameAreaCntr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, InfStruc, ComCtrls, StdCtrls, Grids, Hyperlink;

type
  TAreaCntrFrame = class (TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EdtName: TEdit;
    ChkTrapped: TCheckBox;
    Label8: TLabel;
    Label3: TLabel;
    EdtTrapRemovalDifficulty: TEdit;
    ChkTrapDetected: TCheckBox;
    Label9: TLabel;
    Label4: TLabel;
    EdtTrapDetectionDifficulty: TEdit;
    Label5: TLabel;
    EdtTrapScript: THyperlinkEdit;
    Label6: TLabel;
    EdtKeyType: THyperlinkEdit;
    ChkLocked: TCheckBox;
    Label7: TLabel;
    Label2: TLabel;
    EdtLockDifficulty: TEdit;
    TabSheet2: TTabSheet;
    ItemGrid: THyperlinkGrid;
    Label10: TLabel;
    EdtType: TEdit;
    procedure ItemGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure ItemGridJump(Sender: TObject; ACol, ARow: Integer);
  private
    FContainer: TAreaContainer;
    ItmReal: array of boolean;
  public
    procedure ShowContainer (Cntr: TAreaContainer);
  end;

implementation

{$R *.DFM}

uses FrameCRE;

{ TAreaCntrFrame }

procedure TAreaCntrFrame.ShowContainer (Cntr: TAreaContainer);
var
  Itm: TITMFile;
  i: integer;
const
  ContainerTypeNames: array [1..12] of string = ('Bag', 'Chest', 'Drawer',
      'Pile', 'Table', 'Shelf', 'Altar', 'Nonvisible', 'Spellbook',
      'Body', 'Barrel', 'Crate');
begin
  FContainer := Cntr;
  with Cntr.Hdr do begin
    EdtName.Text := Name;
    EdtType.Text := ContainerTypeNames [ContainerType];
    ChkLocked.Checked := (Locked <> 0);
    EdtLockDifficulty.Text := IntToStr (LockDifficulty);
    ChkTrapped.Checked := (Trapped <> 0);
    EdtTrapRemovalDifficulty.Text := IntToStr (TrapRemovalDifficulty);
    ChkTrapDetected.Checked := (TrapDetected <> 0);
    EdtTrapDetectionDifficulty.Text := IntToStr (TrapDetectionDifficulty);
    EdtTrapScript.ResRef := TrapScript;
    EdtKeyType.ResRef := KeyType;
  end;
  with Cntr do begin
    with ItemGrid do begin
      DefaultRowHeight := GetItemHeight (Font)+4;
      Cells [0, 0] := 'Name';
      Cells [1, 0] := 'Count';
      Cells [2, 0] := 'Count 2';
      Cells [3, 0] := 'Count 3';
      Cells [4, 0] := 'Identified';
      SetLength (ItmReal, Length (Items));
      if Length (Items) > 0 then begin
        RowCount := Length (Items)+1;
        for i := 0 to Length (Items)-1 do
          with Items [i] do begin
            if IsRandomTreasure (ItemID) then begin
              ItmReal [i] := true;
              Cells [0, i+1] := ItemID;
            end
            else begin
              Itm := Game.GetFileByName (ItemID, ftITM) as TITMFile;
              if Itm <> nil then begin
                Cells [0, i+1] := Itm.GetName;
                ItmReal [i] := true;
              end else begin
                Cells [0, i+1] := ItemID;
                ItmReal [i] := false;
              end;
            end;
            Cells [1, i+1] := IntToStr (Count);
            Cells [2, i+1] := IntToStr (Count2);
            Cells [3, i+1] := IntToStr (Count3);
            if Flags and 1 <> 0 then Cells [4, i+1] := 'Yes'
            else Cells [4, i+1] := 'No';
          end;
      end else begin
        RowCount := 2;
        Cells [0, 1] := 'None';
        for i := 1 to ColCount-1 do
          Cells [i, 1] := '';
      end;
    end;
  end;
end;

// item hyperlinks

procedure TAreaCntrFrame.ItemGridCanJump(Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0) and (ARow-1 < Length (ItmReal)) and ItmReal [ARow-1];
end;

procedure TAreaCntrFrame.ItemGridJump (Sender: TObject; ACol, ARow: Integer);
begin
  BrowseToItem (FContainer.Items [ARow-1].ItemID);
end;

end.
