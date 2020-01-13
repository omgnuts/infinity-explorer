{ $Header: $
  Infinity Engine STOR viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameSTOR;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, InfStruc, ComCtrls, StdCtrls, Hyperlink, Grids;

type
  TStoreFrame = class (TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EdtStoreName: TEdit;
    Label2: TLabel;
    EdtStoreType: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    EdtBuyPrice: TEdit;
    Label4: TLabel;
    EdtSellPrice: TEdit;
    GroupBox2: TGroupBox;
    chkRoom0: TCheckBox;
    Label6: TLabel;
    EdtRoom0: TEdit;
    chkRoom1: TCheckBox;
    Label7: TLabel;
    EdtRoom1: TEdit;
    chkRoom2: TCheckBox;
    Label8: TLabel;
    EdtRoom2: TEdit;
    chkRoom3: TCheckBox;
    Label9: TLabel;
    EdtRoom3: TEdit;
    DrinksTab: TTabSheet;
    DrinkGrid: TStringGrid;
    Label10: TLabel;
    EdtBuyPriceReduction: TEdit;
    Label11: TLabel;
    EdtStealDifficulty: TEdit;
    Label12: TLabel;
    EdtIdentifyLore: TEdit;
    SpellsTab: TTabSheet;
    SpellGrid: THyperlinkGrid;
    GroupBox3: TGroupBox;
    EdtRumorDlg: THyperlinkEdit;
    Label13: TLabel;
    Label14: TLabel;
    EdtDonateRumorDlg: THyperlinkEdit;
    GroupBox4: TGroupBox;
    chkFlag0: TCheckBox;
    Label5: TLabel;
    chkFlag1: TCheckBox;
    Label15: TLabel;
    chkFlag2: TCheckBox;
    Label16: TLabel;
    chkFlag3: TCheckBox;
    Label17: TLabel;
    chkFlag4: TCheckBox;
    Label18: TLabel;
    chkFlag5: TCheckBox;
    Label19: TLabel;
    chkFlag6: TCheckBox;
    Label20: TLabel;
    ItemsTab: TTabSheet;
    ItemGrid: THyperlinkGrid;
    BoughtItemsTab: TTabSheet;
    GroupBox5: TGroupBox;
    lbxBoughtItems: TListBox;
    procedure PageControl1Change(Sender: TObject);
    procedure SpellGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure SpellGridJump(Sender: TObject; ACol, ARow: Integer);
    procedure ItemGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure ItemGridJump(Sender: TObject; ACol, ARow: Integer);
  private
    FStoreFile: TStoreFile;
    ItemsFilled: boolean;
    SpellsFilled: boolean;
    procedure FillItems;
    procedure FillSpells;
  public
    procedure ViewFile (AFile: TStoreFile);
  end;

  TStoreFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure GetPosInfo (var PosInfo: pointer); override;
    procedure SetPosInfo (PosInfo: pointer); override;
  end;

implementation

{$R *.DFM}

{ TStoreFrame }

procedure TStoreFrame.ViewFile (AFile: TStoreFile);
const
  StoreTypeNames: array [0..5] of string =
      ('Store', 'Tavern', 'Inn', 'Temple', '4', 'Bag/Case');
var
  i: integer;
  Chk: TCheckBox;
  Edt: TEdit;
begin
  FStoreFile := AFile;
  with AFile.Hdr do begin
    if Game.TLK.ValidID (NameStrref) then
      EdtStoreName.Text := Game.TLK.Text [NameStrref]
    else
      EdtStoreName.Text := IntToStr (NameStrref) + ' <?>';
    if (StoreType >= 0) and (StoreType <= High (StoreTypeNames)) then
      EdtStoreType.Text := StoreTypeNames [StoreType]
    else
      EdtStoreType.Text := IntToStr (StoreType);
    EdtBuyPrice.Text := IntToStr (BuyPrice) + '%';
    EdtSellPrice.Text := IntToStr (SellPrice) + '%';
    EdtRumorDlg.ResRef := RumorDlg;
    EdtDonateRumorDlg.ResRef := DonateRumorDlg;
    EdtBuyPriceReduction.Text := IntToStr (BuyPriceReduction) + '%';
    if StoreType = 5 then
      EdtStealDifficulty.Text := ''
    else
      EdtStealDifficulty.Text := IntToStr (StealDifficulty) + '%';
    EdtIdentifyLore.Text := IntToStr (IdentifyLore);
    for i := 0 to 3 do begin
      Chk := FindComponent ('chkRoom' + IntToStr (i)) as TCheckBox;
      Edt := FindComponent ('EdtRoom' + IntToStr (i)) as TEdit;
      if RoomTypes and (1 shl i) <> 0 then begin
        Chk.Checked := true;
        Edt.Text := IntToStr (RoomPrices [i]);
      end
      else begin
        Chk.Checked := false;
        Edt.Text := '';
      end;
    end;
    for i := 0 to 6 do begin
      Chk := FindComponent ('chkFlag' + IntToStr (i)) as TCheckBox;
      Chk.Checked := (Flags and (1 shl i) <> 0);
    end;
  end;

  // items
  if PageControl1.ActivePage = ItemsTab then
    FillItems
  else
    ItemsFilled := false;

  // bought items
  if Length (AFile.BoughtItems) = 0 then
    BoughtItemsTab.TabVisible := false
  else begin
    BoughtItemsTab.TabVisible := true;
    lbxBoughtItems.Items.BeginUpdate;
    lbxBoughtItems.Clear;
    try
      for i := 0 to Length (AFile.BoughtItems)-1 do
        lbxBoughtItems.Items.Add (CategoryNames [AFile.BoughtItems [i]]);
    finally
      lbxBoughtItems.Items.EndUpdate;
    end;
  end;

  // drinks
  if Length (AFile.Drinks) = 0 then
    DrinksTab.TabVisible := false
  else begin
    DrinksTab.TabVisible := true;
    with DrinkGrid do begin
      RowCount := Length (AFile.Drinks)+1;
      Cells [0, 0] := 'Name';
      Cells [1, 0] := 'Price';
      Cells [2, 0] := 'Rumor chance';
      for i := 0 to Length (AFile.Drinks)-1 do begin
        if not Game.TLK.ValidID (AFile.Drinks [i].NameStrref) then
          Cells [0, i+1] := IntToStr (AFile.Drinks [i].NameStrref) + ' <?>'
        else
          Cells [0, i+1] := Game.TLK.Text [AFile.Drinks [i].NameStrref];
        Cells [1, i+1] := IntToStr (AFile.Drinks [i].Price);
        Cells [2, i+1] := IntToStr (AFile.Drinks [i].RumorChance) + '%';
      end;
    end;
  end;

  // spells
  if Length (AFile.Spells) = 0 then
    SpellsTab.TabVisible := false
  else begin
    SpellsTab.TabVisible := true;
    if PageControl1.ActivePage = SpellsTab then
      FillSpells
    else
      SpellsFilled := false;
  end;
end;

procedure TStoreFrame.FillSpells;
var
  OldCursor: TCursor;
  i: integer;
  Spl: TSPLFile;
begin
  OldCursor := Screen.Cursor;
  if Length (FStoreFile.Spells) > 0 then
    Screen.Cursor := crHourglass;
  try
    with SpellGrid do begin
      DefaultRowHeight := GetItemHeight (Font) + 4;
      Cells [0, 0] := 'Name';
      Cells [1, 0] := 'Price';
      RowCount := Length (FStoreFile.Spells) + 1;
      for i := 0 to Length (FStoreFile.Spells)-1 do
        with FStoreFile.Spells [i] do begin
          Spl := Game.GetFileByName (SpellID, ftSPL) as TSPLFile;
          if Spl <> nil then
            Cells [0, i+1] := Spl.SpellName
          else
            Cells [0, i+1] := PChar8ToStr (SpellID);
          Cells [1, i+1] := IntToStr (SpellPrice);
        end;
    end;
    SpellsFilled := true;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TStoreFrame.FillItems;
var
  OldCursor: TCursor;
  i: integer;
  Itm: TItmFile;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  try
    with ItemGrid do begin
      DefaultRowHeight := GetItemHeight (Font) + 4;
      Cells [0, 0] := 'Name';
      Cells [1, 0] := 'Charges';
      Cells [2, 0] := 'Charges 2';
      Cells [3, 0] := 'Charges 3';
      Cells [4, 0] := 'In stock';
      if Length (FStoreFile.Items) = 0 then begin
        RowCount := 2;
        Cells [0, 1] := 'None';
        for i := 1 to ColCount-1 do
          Cells [i, 1] := '';
      end
      else begin
        RowCount := Length (FStoreFile.Items) + 1;
        for i := 0 to Length (FStoreFile.Items)-1 do
          with FStoreFile.Items [i] do begin
            Itm := Game.GetFileByName (Base.ItemID, ftITM) as TITMFile;
            if Itm <> nil then
              Cells [0, i+1] := Itm.NameIdent
            else
              Cells [0, i+1] := PChar8ToStr (Base.ItemID);
            Cells [1, i+1] := IntToStr (Base.Count);
            Cells [2, i+1] := IntToStr (Base.Count2);
            Cells [3, i+1] := IntToStr (Base.Count3);
            if Flags and 1 <> 0 then
              Cells [4, i+1] := 'Infinite'
            else
              Cells [4, i+1] := IntToStr (NumberInStock);
          end;
      end;
    end;
    ItemsFilled := true;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TStoreFrame.PageControl1Change (Sender: TObject);
begin
  if not ItemsFilled and (PageControl1.ActivePage = ItemsTab) then
    FillItems;
  if not SpellsFilled and (PageControl1.ActivePage = SpellsTab) then
    FillSpells;
end;

procedure TStoreFrame.ItemGridCanJump(Sender: TObject; ACol, ARow: Integer;
  var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0) and (Length (FStoreFile.Items) > 0);
end;

procedure TStoreFrame.ItemGridJump(Sender: TObject; ACol, ARow: Integer);
begin
  MainForm.BrowseToFile (FStoreFile.Items [ARow-1].Base.ItemID, ftITM);
end;

procedure TStoreFrame.SpellGridCanJump (Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0);
end;

procedure TStoreFrame.SpellGridJump (Sender: TObject; ACol, ARow: Integer);
begin
  MainForm.BrowseToFile (FStoreFile.Spells [ARow-1].SpellID, ftSPL);
end;

{ TStoreFrameProxy }

constructor TStoreFrameProxy.Create (AOwner: TComponent);
begin
  inherited;
  FFrameClass := TStoreFrame;
end;

procedure TStoreFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TStoreFrame).ViewFile (AFile as TStoreFile);
end;

procedure TStoreFrameProxy.GetPosInfo (var PosInfo: pointer);
begin
  PosInfo := Pointer ((FFrame as TStoreFrame).PageControl1.ActivePageIndex);
end;

procedure TStoreFrameProxy.SetPosInfo (PosInfo: pointer);
begin
  with FFrame as TStoreFrame do begin
    PageControl1.ActivePageIndex := integer (PosInfo);
    PageControl1Change (nil);
  end;
end;

end.
