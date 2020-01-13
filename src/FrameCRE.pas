{ $Header: /cvsroot/InfExp/InfExp/src/FrameCRE.pas,v 1.9 2000/11/01 19:00:14 yole Exp $
  Infinity Engine CRE viewer frame
  Copyright (C) 2000-01 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameCRE;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, InfStruc, ComCtrls, StdCtrls, ExtCtrls, Grids,
  Hyperlink;

type
  TCREFrame = class (TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EdtCurHP: TEdit;
    Label2: TLabel;
    EdtMaxHP: TEdit;
    Label4: TLabel;
    EdtTHAC0: TEdit;
    Label5: TLabel;
    EdtName: TEdit;
    Label6: TLabel;
    EdtKillXP: TEdit;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    EdtResistFire: TEdit;
    Label8: TLabel;
    EdtResistCold: TEdit;
    Label9: TLabel;
    EdtResistElec: TEdit;
    Label10: TLabel;
    EdtResistAcid: TEdit;
    Label11: TLabel;
    EdtResistMagic: TEdit;
    Label12: TLabel;
    EdtResistMagFire: TEdit;
    Label13: TLabel;
    EdtResistMagCold: TEdit;
    Label14: TLabel;
    EdtResistSlashing: TEdit;
    Label15: TLabel;
    EdtResistPiercing: TEdit;
    Label16: TLabel;
    EdtResistCrushing: TEdit;
    Label17: TLabel;
    EdtResistMissile: TEdit;
    GroupBox2: TGroupBox;
    Label18: TLabel;
    EdtST_PPDM: TEdit;
    Label19: TLabel;
    EdtST_RSW: TEdit;
    Label20: TLabel;
    EdtST_BW: TEdit;
    Label21: TLabel;
    EdtST_PP: TEdit;
    Label22: TLabel;
    EdtST_Spells: TEdit;
    Label23: TLabel;
    EdtNumberOfAttacks: TEdit;
    TabSheet2: TTabSheet;
    Label24: TLabel;
    grpClass: TGroupBox;
    EdtClass1: TEdit;
    Panel1: TPanel;
    Label25: TLabel;
    EdtLevel1: TEdit;
    EdtClass2: TEdit;
    LblLevel2: TLabel;
    EdtLevel2: TEdit;
    EdtClass3: TEdit;
    LblLevel3: TLabel;
    EdtLevel3: TEdit;
    EdtRace: TEdit;
    grpAbilities: TGroupBox;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    EdtCon: TEdit;
    EdtDex: TEdit;
    Label27: TLabel;
    EdtStrPercent: TEdit;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    EdtCha: TEdit;
    EdtWis: TEdit;
    EdtInt: TEdit;
    Label33: TLabel;
    EdtGender: TEdit;
    Label34: TLabel;
    EdtAlignment: TEdit;
    TabItems: TTabSheet;
    ItemGrid: THyperlinkGrid;
    TabSpells: TTabSheet;
    KnownSpellGrid: THyperlinkGrid;
    TabSheet5: TTabSheet;
    GroupBox4: TGroupBox;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    EdtScriptOverride: THyperlinkEdit;
    EdtScriptClass: THyperlinkEdit;
    EdtScriptRace: THyperlinkEdit;
    EdtScriptGeneral: THyperlinkEdit;
    EdtScriptDefault: THyperlinkEdit;
    Label40: TLabel;
    EdtDialog: THyperlinkEdit;
    grpAI: TGroupBox;
    Label41: TLabel;
    EdtAI_EA: TEdit;
    Label42: TLabel;
    EdtAI_General: TEdit;
    Label43: TLabel;
    EdtAI_Specific: TEdit;
    Label44: TLabel;
    EdtAI_Team: TEdit;
    lblFaction: TLabel;
    EdtFaction: TEdit;
    Label46: TLabel;
    EdtLuck: TEdit;
    TabStatistics: TTabSheet;
    Label47: TLabel;
    EdtMostPowerful: TEdit;
    GroupBox3: TGroupBox;
    GroupBox5: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    EdtKillCountChapter: TEdit;
    EdtKillXPChapter: TEdit;
    EdtKillXPGame: TEdit;
    EdtKillCountGame: TEdit;
    GroupBox6: TGroupBox;
    FavSpellGrid: THyperlinkGrid;
    GroupBox7: TGroupBox;
    FavWeaponGrid: THyperlinkGrid;
    Label50: TLabel;
    EdtGold: TEdit;
    Panel2: TPanel;
    GroupBox8: TGroupBox;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    EdtMorale: TEdit;
    EdtMoraleBreakingPoint: TEdit;
    EdtMoraleRecoveryTime: TEdit;
    Label54: TLabel;
    EdtReputation: TEdit;
    GroupBox9: TGroupBox;
    Label55: TLabel;
    EdtAC: TEdit;
    Label56: TLabel;
    EdtACCrushing: TEdit;
    Label57: TLabel;
    EdtACPiercing: TEdit;
    Label58: TLabel;
    Label59: TLabel;
    EdtACMissile: TEdit;
    EdtACSlashing: TEdit;
    Label3: TLabel;
    EdtXP: TEdit;
    Label60: TLabel;
    EdtDeathVar: TEdit;
    TabEffects: TTabSheet;
    EffectGrid: TStringGrid;
    Label61: TLabel;
    EdtRacialEnemy: TEdit;
    TabParty: TTabSheet;
    Label62: TLabel;
    EdtStr: TEdit;
    GroupBox10: TGroupBox;
    Label63: TLabel;
    EdtPartyPosition: TEdit;
    EdtCurArea: THyperlinkEdit;
    Label64: TLabel;
    EdtX: TEdit;
    Label65: TLabel;
    EdtY: TEdit;
    Label66: TLabel;
    EdtFacing: TEdit;
    Label67: TLabel;
    EdtHappiness: TEdit;
    TabStatus: TTabSheet;
    Label68: TLabel;
    EdtFatigue: TEdit;
    Label69: TLabel;
    EdtIntoxication: TEdit;
    GroupBox11: TGroupBox;
    chkState0: TCheckBox;
    Label70: TLabel;
    chkState1: TCheckBox;
    Label71: TLabel;
    chkState2: TCheckBox;
    Label72: TLabel;
    chkState3: TCheckBox;
    Label73: TLabel;
    chkState4: TCheckBox;
    lblState4: TLabel;
    chkState5: TCheckBox;
    Label75: TLabel;
    chkState6: TCheckBox;
    Label76: TLabel;
    chkState7: TCheckBox;
    Label77: TLabel;
    chkState8: TCheckBox;
    lblState8: TLabel;
    chkState9: TCheckBox;
    Label79: TLabel;
    chkState10: TCheckBox;
    Label80: TLabel;
    chkState11: TCheckBox;
    Label81: TLabel;
    chkState12: TCheckBox;
    Label82: TLabel;
    Label83: TLabel;
    chkState13: TCheckBox;
    chkState14: TCheckBox;
    Label84: TLabel;
    lblState15: TLabel;
    chkState15: TCheckBox;
    chkState16: TCheckBox;
    chkState17: TCheckBox;
    lblState16: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    chkState18: TCheckBox;
    chkState19: TCheckBox;
    Label89: TLabel;
    Label90: TLabel;
    chkState20: TCheckBox;
    chkState21: TCheckBox;
    Label91: TLabel;
    lblState22: TLabel;
    chkState22: TCheckBox;
    Label93: TLabel;
    chkState23: TCheckBox;
    chkState24: TCheckBox;
    lblState24: TLabel;
    lblState25: TLabel;
    chkState25: TCheckBox;
    chkState26: TCheckBox;
    Label96: TLabel;
    Label97: TLabel;
    chkState27: TCheckBox;
    chkState28: TCheckBox;
    lblState28: TLabel;
    Label99: TLabel;
    chkState29: TCheckBox;
    chkState30: TCheckBox;
    lblState30: TLabel;
    Label101: TLabel;
    chkState31: TCheckBox;
    TabSheet3: TTabSheet;
    Label45: TLabel;
    EdtLore: TEdit;
    Label74: TLabel;
    EdtOpenLocks: TEdit;
    Label78: TLabel;
    EdtStealth: TEdit;
    Label85: TLabel;
    EdtDetectTraps: TEdit;
    Label86: TLabel;
    EdtPickPockets: TEdit;
    Label92: TLabel;
    EdtTracking: TEdit;
    lblDualClass: TLabel;
    GroupBox12: TGroupBox;
    WpnProfGrid: TStringGrid;
    procedure ItemGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure ItemGridJump(Sender: TObject; ACol, ARow: Integer);
    procedure KnownSpellGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure KnownSpellGridJump(Sender: TObject; ACol, ARow: Integer);
    procedure FavSpellGridCanJmp(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure FavSpellGridJump(Sender: TObject; ACol, ARow: Integer);
    procedure FavWeaponGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure FavWeaponGridJump(Sender: TObject; ACol, ARow: Integer);
    procedure PageControl1Change(Sender: TObject);
  private
    FCREFile: TCREFile;
    FStats: TGameCharacterStatsRec;
    ItmReal: array of boolean;
    ItemsFilled, SpellsFilled: boolean;
    procedure FillItems;
    procedure FillSpells;
    procedure FillState;
    procedure InitWeaponProfs;
    procedure FillWeaponProfs;
  protected
    procedure Loaded; override;
  public
    procedure ViewFile (AFile: TGameFile);
    procedure ViewPartyCommon (const PartyCommon: TGameCharacterCommonRec);
    procedure ViewStatistics (const Statistics: TGameCharacterStatsRec);
  end;

  TCREFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure GetPosInfo (var PosInfo: pointer); override;
    procedure SetPosInfo (PosInfo: pointer); override;
    procedure ViewPartyCommon (const PartyCommon: TGameCharacterCommonRec);
    procedure ViewStatistics (const Statistics: TGameCharacterStatsRec);
  end;

function IsRandomTreasure (const ItemID: TResRef): boolean;
procedure BrowseToItem (const ItemID: TResRef);
  // correctly handles hyperlinks to random treasure

implementation

{$R *.DFM}

uses FrameAbility;

{ TCREFrame }

procedure TCREFrame.Loaded;
begin
  inherited;
  if Game.GameType = gtTorment then begin
    lblState4.Caption := 'Curse';
    lblState8.Caption := 'Mirror Image';
    lblState15.Caption := 'Critical Protection';
    lblState16.Caption := 'Critical Enhancement';
    lblState22.Caption := 'EE Duplication';
    lblState24.Caption := 'Detect Evil';
    lblState25.Caption := 'Invisible';
    lblState28.Caption := 'AntiMagic';
    lblState30.Caption := 'Embalming';        
  end;
  InitWeaponProfs;
end;

procedure TCREFrame.ViewFile (AFile: TGameFile);
var
  ClassCount: integer;

  function ClassToString (Index: integer): string;
  begin
    Result := FCREFile.CharClass [Index];
    if (Result = 'Mage') and
        (FCREFile.MageSpec <> '0') and (FCREFile.MageSpec <> 'Generalist')
    then
      Result := Result + ' (' + FCREFile.MageSpec + ')';
  end;

  procedure SetScript (Edit: TEdit; const Script: string);
  begin
    with Edit do begin
      Text := Script;
      if (Script <> '') and not SameText (Script, 'None') then begin
        Cursor := crHandPoint;
        Font.Color := clBlue;
        Font.Style := [fsUnderline];
      end else begin
        Cursor := crDefault;
        Font.Color := clBlack;
        Font.Style := [];
      end;
    end;
  end;

  procedure SetIntEdit (Edit: TEdit; Value: integer);
  begin
    if Value > 0 then
      Edit.Text := '+' + IntToStr (Value)
    else
      Edit.Text := IntToStr (Value);
  end;

begin
  FCREFile := AFile as TCREFile;
  TabParty.TabVisible := (AFile is TCharCREFile);
  TabStatistics.TabVisible := (AFile is TCharCREFile);
  with FCREFile do begin
    EdtName.Text := TLKName;
    EdtCurHP.Text := IntToStr (CurHP);
    EdtMaxHP.Text := IntToStr (MaxHP);
    with Common0 do begin
      EdtAC.Text := IntToStr (AC);
      SetIntEdit (EdtACCrushing, ACCrushing);
      SetIntEdit (EdtACMissile, ACMissile);
      SetIntEdit (EdtACPiercing, ACPiercing);
      SetIntEdit (EdtACSlashing, ACSlashing);
      EdtTHAC0.Text := IntToStr (THAC0);
      EdtNumberOfAttacks.Text := IntToStr (NumberOfAttacks);
      EdtKillXP.Text := IntToStr (KillXP);
      EdtST_PPDM.Text := IntToStr (ST_PPDM);
      EdtST_RSW.Text := IntToStr (ST_RSW);
      EdtST_BW.Text := IntToStr (ST_BW);
      EdtST_PP.Text := IntToStr (ST_PP);
      EdtST_Spells.Text := IntToStr (ST_Spells);
      EdtResistFire.Text := IntToStr (ResistFire);
      EdtResistCold.Text := IntToStr (ResistCold);
      EdtResistElec.Text := IntToStr (ResistElec);
      EdtResistAcid.Text := IntToStr (ResistAcid);
      EdtResistMagic.Text := IntToStr (ResistMagic);
      EdtResistMagFire.Text := IntToStr (ResistMagFire);
      EdtResistMagCold.Text := IntToStr (ResistMagCold);
      EdtResistSlashing.Text := IntToStr (ResistSlashing);
      EdtResistPiercing.Text := IntToStr (ResistPiercing);
      EdtResistCrushing.Text := IntToStr (ResistCrushing);
      EdtResistMissile.Text := IntToStr (ResistMissile);
    end;
    EdtRace.Text := Race;
    ClassCount := 1;
    EdtClass1.Text := ClassToString (1);
    EdtLevel1.Text := IntToStr (Level [1]);
    if CharClass [2] = '' then begin
      EdtClass2.Visible := false;
      LblLevel2.Visible := false;
      EdtLevel2.Visible := false;
    end else begin
      EdtClass2.Visible := true;
      EdtClass2.Text := ClassToString (2);
      LblLevel2.Visible := true;
      EdtLevel2.Visible := true;
      EdtLevel2.Text := IntToStr (Level [2]);
      ClassCount := 2;
    end;
    if DualClass then begin
       EdtClass3.Visible := false;
       LblLevel3.Visible := false;
       EdtLevel3.Visible := false;
      lblDualClass.Visible := true;
      ClassCount := 3;
    end
    else begin
      lblDualClass.Visible := false;
      if CharClass [3] = '' then begin
        EdtClass3.Visible := false;
        LblLevel3.Visible := false;
        EdtLevel3.Visible := false;
      end else begin
        EdtClass3.Visible := true;
        EdtClass3.Text := ClassToString (3);
        LblLevel3.Visible := true;
        EdtLevel3.Visible := true;
        EdtLevel3.Text := IntToStr (Level [3]);
        ClassCount := 3;
      end;
    end;
    grpClass.Height := 25 + 32 * ClassCount;
    Panel1.Height := TabSheet1.Height - (grpClass.Top + grpClass.Height) - 1;
    EdtGender.Text := Gender;
    EdtAlignment.Text := Alignment;
    with Common1 do begin
      EdtStr.Text := IntToStr (Str);
      if Str = 18 then EdtStrPercent.Text := IntToStr (StrPercent)
      else EdtStrPercent.Text := '';
      EdtDex.Text := IntToStr (Dex);
      EdtCon.Text := IntToStr (Con);
      EdtInt.Text := IntToStr (Int);
      EdtWis.Text := IntToStr (Wis);
      EdtCha.Text := IntToStr (Cha);
      EdtLuck.Text := IntToStr (Common0.Luck);
      SetScript (EdtScriptOverride, PChar8ToStr (ScriptOverride));
      SetScript (EdtScriptClass, PChar8ToStr (ScriptClass));
      SetScript (EdtScriptRace, PChar8ToStr (ScriptRace));
      SetScript (EdtScriptGeneral, PChar8ToStr (ScriptGeneral));
      SetScript (EdtScriptDefault, PChar8ToStr (ScriptDefault));
      EdtGold.Text := IntToStr (Common0.Gold);
      EdtMorale.Text := IntToStr (Morale);
      EdtMoraleBreakingPoint.Text := IntToStr (MoraleBreak);
      EdtMoraleRecoveryTime.Text := IntToStr (MoraleRecoveryTime);
      EdtReputation.Text := IntToStr (Common0.Reputation);
    end;
    with Common0 do begin
      EdtXP.Text := IntToStr (Common0.CurXP);
      EdtOpenLocks.Text := IntToStr (OpenLocks);
      EdtStealth.Text := IntToStr (Stealth);
      EdtDetectTraps.Text := IntToStr (DetectTraps);
      EdtPickPockets.Text := IntToStr (PickPockets);
      EdtLore.Text := IntToStr (Lore);
    end;
    EdtTracking.Text := IntToStr (Common1.Tracking);
    SetScript (EdtDialog, Dialog);
    EdtAI_EA.Text := AI_EAName;
    EdtAI_General.Text := AI_GeneralName;
    EdtAI_Specific.Text := AI_SpecificName;
    if Version = 12 then begin
      EdtAI_Team.Visible := true;
      EdtAI_Team.Text := AI_TeamName;
      grpAI.Height := EdtAI_Team.Top + EdtAI_Team.Height + 9;
      EdtFaction.Visible := true;
      lblFaction.Visible := true;
      EdtFaction.Text := Faction;
      grpAbilities.Top := EdtFaction.Top + EdtFaction.Height + 8;
    end else begin
      EdtAI_Team.Visible := false;
      grpAI.Height := EdtAI_Specific.Top + EdtAI_Specific.Height + 9;
      EdtFaction.Visible := false;
      lblFaction.Visible := false;
      grpAbilities.Top := EdtAlignment.Top + EdtAlignment.Height + 8;
    end;
    EdtDeathVar.Text := DeathVar;
    EdtRacialEnemy.Text := RacialEnemy;
  end;
  FillState;
  if PageControl1.ActivePage = TabItems then
    FillItems
  else
    ItemsFilled := false;
  if PageControl1.ActivePage = TabSpells then
    FillSpells
  else
    SpellsFilled := false;
  if Length (FCREFile.Effects) = 0 then
    TabEffects.TabVisible := false
  else begin
    TabEffects.TabVisible := true;
    SetEffectGrid (EffectGrid, FCREFile.Effects);
  end;
  FillWeaponProfs;
end;

procedure TCREFrame.FillItems;
var
  i: integer;
  Itm: TITMFile;
begin
  if Length (FCREFile.Items) > 0 then
    Screen.Cursor := crHourglass;
  try
    with ItemGrid do begin
      DefaultRowHeight := GetItemHeight (Font)+4;
      Cells [0, 0] := 'Name';
      Cells [1, 0] := 'Count';
      Cells [2, 0] := 'Count 2';
      Cells [3, 0] := 'Count 3';
      Cells [4, 0] := 'Identified';
      Cells [5, 0] := 'NoPick';
      Cells [6, 0] := 'Stolen';
      Cells [7, 0] := 'NoDrop';
      SetLength (ItmReal, Length (FCREFile.Items));
      if Length (FCREFile.Items) > 0 then begin
        RowCount := Length (FCREFile.Items)+1;
        for i := 0 to Length (FCREFile.Items)-1 do
          with FCREFile.Items [i] do begin
            if IsRandomTreasure (ItemID) then begin
              ItmReal [i] := true;
              Cells [0, i+1] := UpperCase (PChar8ToStr (ItemID));
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

            if Flags and 2 <> 0 then Cells [5, i+1] := 'Yes'
            else Cells [5, i+1] := 'No';
            if Flags and 4 <> 0 then Cells [6, i+1] := 'Yes'
            else Cells [6, i+1] := 'No';
            if Flags and 8 <> 0 then Cells [7, i+1] := 'Yes'
            else Cells [7, i+1] := 'No';

          end;
      end else begin
        RowCount := 2;
        Cells [0, 1] := 'None';
        for i := 1 to ColCount-1 do
          Cells [i, 1] := '';
      end;
    end;
    ItemsFilled := true;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCREFrame.FillSpells;
var
  i, j, Memorized, Remaining: integer;
  Spl: TSPLFile;
  OldCursor: TCursor;
const
  SpellTypeNames: array [0..2] of string =
     ('Priest', 'Wizard', 'Innate');
begin
  OldCursor := Screen.Cursor;
  if Length (FCREFile.KnownSpells) > 0 then
    Screen.Cursor := crHourglass;
  try
    with KnownSpellGrid do begin
      DefaultRowHeight := GetItemHeight (Font)+4;
      Cells [0, 0] := 'Name';
      Cells [1, 0] := 'Level';
      Cells [2, 0] := 'Type';
      Cells [3, 0] := 'Memorized';
      Cells [4, 0] := 'Remaining';
      if Length (FCREFile.KnownSpells) > 0 then begin
        RowCount := Length (FCREFile.KnownSpells)+1;
        for i := 0 to Length (FCREFile.KnownSpells)-1 do
          with FCREFile.KnownSpells [i] do begin
            Spl := Game.GetFileByName (SpellID, ftSPL) as TSPLFile;
            if Spl <> nil then
              Cells [0, i+1] := Spl.SpellName
            else
              Cells [0, i+1] := PChar8ToStr (SpellID);
            Cells [1, i+1] := IntToStr (Level+1);
            if SpellType <= 2 then
              Cells [2, i+1] := SpellTypeNames [SpellType]
            else
              Cells [2, i+1] := IntToStr (SpellType);
            Memorized := 0;
            Remaining := 0;
            for j := 0 to Length (FCREFile.MemorizedSpells)-1 do
              if FCREFile.MemorizedSpells [j].SpellID = SpellID then begin
                Inc (Memorized);
                if FCREFile.MemorizedSpells [j].Available then Inc (Remaining);
              end;
            Cells [3, i+1] := IntToStr (Memorized);
            Cells [4, i+1] := IntToStr (Remaining);
          end;
      end else begin
        RowCount := 2;
        Cells [0, 1] := 'None';
        for i := 1 to ColCount-1 do
          Cells [i, 1] := '';
      end;
    end;
    SpellsFilled := true;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

const
  ProfCounts: array [TGameType] of integer = (8, 6, 15, 15);

procedure TCREFrame.InitWeaponProfs;
var
  ProfCount, i: integer;
const
  ProfNamesBaldur: array [1..8] of string =
      ('Large swords', 'Small swords', 'Bows', 'Spears', 'Blunt weapons',
       'Spiked weapons', 'Axe', 'Missile weapons');
  ProfNamesTorment: array [1..6] of string =
      ('Fist', 'Edged weapons', 'Hammer', 'Axe', 'Club', 'Bow');
  ProfNamesIcewind: array [1..15] of string =
      ('Large swords', 'Small swords', 'Bows', 'Spears', 'Axes',
       'Missile weapons', 'Great swords', 'Daggers', 'Halberds', 'Maces',
       'Flails', 'Hammers', 'Clubs', 'Quarterstaves', 'Crossbow');
begin
  ProfCount := ProfCounts [Game.GameType];
  with WpnProfGrid do begin
    RowCount := ProfCount+1;
    Cells [0, 0] := 'Name';
    for i := 1 to ProfCount do
      case Game.GameType of
        gtBaldur: Cells [0, i] := ProfNamesBaldur [i];
        gtTorment: Cells [0, i] := ProfNamesTorment [i];
        gtIcewind: Cells [0, i] := ProfNamesIcewind [i];
      end;
  end;
end;

procedure TCREFrame.FillWeaponProfs;
var
  i: integer;
  Prof: byte;
begin
  with WpnProfGrid do begin
    if FCREFile.DualClass then begin
      ColCount := 3;
      Cells [1, 0] := 'Class 1';
      Cells [2, 0] := 'Class 2';
    end
    else begin
      ColCount := 2;
      Cells [1, 0] := 'Value';
    end;
    for i := 1 to ProfCounts [Game.GameType] do begin
      Prof := FCREFile.Common1.WeaponProf [i];
      Cells [1, i] := IntToStr (Prof and 7);
      if FCREFile.DualCLass then
        Cells [2, i] := IntToStr (Prof shr 3);
    end;
  end;
end;

procedure TCREFrame.PageControl1Change(Sender: TObject);
begin
  if not ItemsFilled and (PageControl1.ActivePage = TabItems) then
    FillItems
  else if not SpellsFilled and (PageControl1.ActivePage = TabSpells) then
    FillSpells;
end;

// item hyperlinks

function IsRandomTreasure (const ItemID: TResRef): boolean;
begin
  if Game.GameType in [gtBaldur, gtTorment] then
    Result := (SameText (Copy (ItemID, 1, 6), 'RNDTRE'))
  else
    Result := false;
end;

procedure BrowseToItem (const ItemID: TResRef);
begin
  if IsRandomTreasure (ItemID) then begin
    if Game.GameType in [gtBaldur, gtTorment] then
      MainForm.BrowseToFile ('RNDTREAS', ft2DA);
  end
  else
    MainForm.BrowseToFile (ItemID, ftITM);
end;

procedure TCREFrame.ItemGridCanJump (Sender: TObject; ACol, ARow: Integer;
  var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0) and (ARow-1 < Length (ItmReal)) and ItmReal [ARow-1];
end;

procedure TCREFrame.ItemGridJump (Sender: TObject; ACol, ARow: Integer);
begin
  BrowseToItem (FCREFile.Items [ARow-1].ItemID);
end;

// spell hyperlinks

procedure TCREFrame.KnownSpellGridCanJump(Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0) and
      not SameText (KnownSpellGrid.Cells [ACol, ARow], 'None');
end;

procedure TCREFrame.KnownSpellGridJump (Sender: TObject; ACol, ARow: Integer);
begin
  MainForm.BrowseToFile (FCREFile.KnownSpells [ARow-1].SpellID, ftSPL);
end;

// state

procedure TCREFrame.FillState;
var
  i: integer;
  Chk: TCheckBox;
begin
  EdtFatigue.Text := IntToStr (FCREFile.Common0.Fatigue);
  EdtIntoxication.Text := IntToStr (FCREFile.Common0.Intoxication);
  for i := 0 to 31 do begin
    Chk := FindComponent ('chkState' + IntToStr (i)) as TCheckBox;
    Chk.Checked := (FCREFile.Common0.Status and (1 shl i) <> 0);
  end;
end;

// party common

procedure TCREFrame.ViewPartyCommon (const PartyCommon: TGameCharacterCommonRec);
begin
  EdtPartyPosition.Text := IntToStr (PartyCommon.PartyPosition);
  EdtCurArea.ResRef := PartyCommon.CurArea;
  EdtX.Text := IntToStr (PartyCommon.XCoord);
  EdtY.Text := IntToStr (PartyCommon.YCoord);
  EdtFacing.Text := IntToStr (PartyCommon.Facing);
  EdtHappiness.Text := IntToStr (PartyCommon.Happiness);  
end;

// statistics

procedure TCREFrame.ViewStatistics (const Statistics: TGameCharacterStatsRec);
var
  i: integer;
  Spl: TSPLFile;
  Itm: TITMFile;
begin
  FStats := Statistics;
  with Statistics do begin
    if not Game.TLK.ValidID (MostPowerfulStrref) then
      EdtMostPowerful.Text := ''
    else
      EdtMostPowerful.Text := Game.TLK.Text [MostPowerfulStrref];
    EdtKillCountChapter.Text := IntToStr (KillCountChapter);
    EdtKillXPChapter.Text := IntToStr (KillXPChapter);
    EdtKillCountGame.Text := IntToStr (KillCountGame);
    EdtKillXPGame.Text := IntToStr (KillXPGame);
    with FavSpellGrid do begin
      Cells [0, 0] := 'Spell';
      Cells [1, 0] := 'Usage count';
      for i := 1 to 4 do begin
        if FavSpells [i] [0] <> #0 then begin
          Spl := Game.GetFileByName (FavSpells [i], ftSPL) as TSPLFile;
          if Spl <> nil then
            Cells [0, i] := Spl.SpellName
          else
            Cells [0, i] := PChar8ToStr (FavSpells [i]);
          Cells [1, i] := IntToStr (FavSpellCount [i]);
        end
        else begin
          Cells [0, i] := '';
          Cells [1, i] := '';
        end;
      end;
    end;
    with FavWeaponGrid do begin
      Cells [0, 0] := 'Weapon';
      Cells [1, 0] := 'Usage count';
      for i := 1 to 4 do begin
        if FavWeapons [i] [0] <> #0 then begin
          Itm := Game.GetFileByName (FavWeapons [i], ftITM) as TITMFile;
          if Itm <> nil then
            Cells [0, i] := Itm.NameIdent
          else
            Cells [0, i] := PChar8ToStr (FavWeapons [i]);
          Cells [1, i] := IntToStr (FavWeaponCount [i]);
        end
        else begin
          Cells [0, i] := '';
          Cells [1, i] := '';
        end;
      end;
    end;
  end;
end;

procedure TCREFrame.FavSpellGridCanJmp(Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0) and (FavSpellGrid.Cells [ACol, ARow] <> '');
end;

procedure TCREFrame.FavSpellGridJump (Sender: TObject; ACol, ARow: Integer);
begin
  MainForm.BrowseToFile (PChar8ToStr (FStats.FavSpells [ARow]), ftSPL);
end;

procedure TCREFrame.FavWeaponGridCanJump(Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0) and (FavWeaponGrid.Cells [ACol, ARow] <> '');
end;

procedure TCREFrame.FavWeaponGridJump(Sender: TObject; ACol,
  ARow: Integer);
begin
  MainForm.BrowseToFile (PChar8ToStr (FStats.FavWeapons [ARow]), ftITM);
end;

{ TCREFrameProxy }

constructor TCREFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TCREFrame;
end;

procedure TCREFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TCREFrame).ViewFile (AFile);
end;

procedure TCREFrameProxy.GetPosInfo (var PosInfo: pointer);
begin
  PosInfo := Pointer ((FFrame as TCREFrame).PageControl1.ActivePageIndex);
end;

procedure TCREFrameProxy.SetPosInfo (PosInfo: pointer);
begin
  with FFrame as TCREFrame do begin
    PageControl1.ActivePageIndex := integer (PosInfo);
    PageControl1Change (nil);
  end;
end;

procedure TCREFrameProxy.ViewPartyCommon (const PartyCommon: TGameCharacterCommonRec);
begin
  (FFrame as TCREFrame).ViewPartyCommon (PartyCommon);
end;

procedure TCREFrameProxy.ViewStatistics (const Statistics: TGameCharacterStatsRec);
begin
  (FFrame as TCREFrame).ViewStatistics (Statistics);
end;

end.
