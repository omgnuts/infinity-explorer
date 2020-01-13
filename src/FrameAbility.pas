{ $Header: /cvsroot/InfExp/InfExp/src/FrameAbility.pas,v 1.5 2000/11/01 19:00:14 yole Exp $
  Infinity Explorer: ability view (shared between spells and items)
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameAbility;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Infinity, InfStruc, Grids, Hyperlink, InfGraphics;

type
  TAbilityFrame = class(TFrame)
    Label7: TLabel;
    EdtRange: TEdit;
    AbilityCombo: TComboBox;
    EdtSpeed: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    EdtTHAC0: TEdit;
    EdtDamage: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    EdtChargeCount: TEdit;
    EffectGrid: TStringGrid;
    Label1: TLabel;
    EdtIcon: THyperlinkEdit;
    BAMIcon1: TBAMIcon;
    lblLauncherLevel: TLabel;
    EdtLauncherLevel: TEdit;
    Label2: TLabel;
    EdtType: TEdit;
    chkUseOnlyIdentified: TCheckBox;
    lblUseOnlyIdentified: TLabel;
    Label4: TLabel;
    EdtTargetType: TEdit;
    Label5: TLabel;
    EdtDamageType: TEdit;
    Label3: TLabel;
    EdtProjectile: THyperlinkEdit;
  private
    FAbilities: array of TItemAbility;
    FEnchanted: integer;
  public
    procedure SetAbilities (const Abilities: array of TItemAbility; Enchanted: integer);
    procedure ViewAbility (Index: integer);
  end;

procedure SetEffectGrid (EffectGrid: TStringGrid; const Effects: array of TEffectRec);

implementation

{$R *.DFM}

uses VCLUtils, InfMain;

{ TAbilityFrame }

procedure TAbilityFrame.SetAbilities (const Abilities: array of TItemAbility;
    Enchanted: integer);
var
  i: integer;
begin
  SetLength (FAbilities, High (Abilities)+1);
  for i := 0 to High (Abilities) do
    FAbilities [i] := Abilities [i];
  if Length (FAbilities) = 1 then
    AbilityCombo.Visible := false
  else begin
    with AbilityCombo.Items do begin
      BeginUpdate;
      try
        Clear;
        for i := 1 to Length (FAbilities) do
          if FAbilities [i-1].IsSpell then
            Add ('Level ' + IntToStr (FAbilities [i-1].Hdr.LauncherType))
          else
            Add ('Ability ' + IntToStr (i));
      finally
        EndUpdate;
      end;
    end;
    AbilityCombo.ItemIndex := 0;
    AbilityCombo.Visible := true;
  end;
  EffectGrid.Height := ClientHeight - EffectGrid.Top - 8;
  ViewAbility (0);
end;

procedure TAbilityFrame.ViewAbility (Index: integer);
var
  TotalBonus: integer;
  Wpn: TItemAbility;
  Projectl: TIDSFile;
const
  LauncherTypes: array [0..3] of string =
      ('None', 'Bow', 'Crossbow', 'Sling');
  AbilityTypes: array [0..4] of string =
      ('Default', 'Melee', 'Ranged', 'Magical', 'Launcher');
  TargetTypes: array [0..5] of string =
      ('None (0)', 'Living actor', 'Inventory', 'Dead actor', 'Any point', 'Caster');
  DamageTypes: array [0..4] of string =
      ('None (0)', 'Piercing', 'Crushing', 'Slashing', 'Missile');
begin
  Wpn := FAbilities [Index];
  with Wpn.Hdr do begin
    EdtRange.Text := IntToStr (Range);
    EdtSpeed.Text := IntToStr (Speed);
    EdtTHAC0.Text := IntToStr (Bonus + FEnchanted);
    if Bonus + FEnchanted > 0 then
      EdtTHAC0.Text := '+' + EdtTHAC0.Text;
    EdtDamage.Text := IntToStr (DiceCount) + 'd' + IntToStr (DiceValue);
    TotalBonus := DmgBonus + FEnchanted;
    if TotalBonus > 0 then
      EdtDamage.Text := EdtDamage.Text + '+' + IntToStr (TotalBonus)
    else if TotalBonus < 0 then
      EdtDamage.Text := EdtDamage.Text + IntToStr (TotalBonus);
    //radDamageType.ItemIndex := integer (Wpn.DamageType);
    EdtChargeCount.Text := IntToStr (ChargeCount);
    EdtIcon.ResRef := BAMIcon;
    BAMIcon1.BAMId := PChar8ToStr (BAMIcon);
    if Wpn.IsSpell then begin
      lblLauncherLevel.Caption := 'Min level';
      EdtLauncherLevel.Width := 40;
      EdtLauncherLevel.Text := IntToStr (LauncherType);
    end
    else begin
      lblLauncherLevel.Caption := 'Launcher type';
      EdtLauncherLevel.Width := 89;
      if LauncherType < 4 then
        EdtLauncherLevel.Text := LauncherTypes [LauncherType]
      else
        EdtLauncherLevel.Text := IntToStr (LauncherType);
    end;
    if AbilityType < 5 then
      EdtType.Text := AbilityTypes [AbilityType]
    else
      EdtType.Text := IntToStr (AbilityType);
    with chkUseOnlyIdentified do
      if not Wpn.IsSpell then begin
        Visible := true;
        lblUseOnlyIdentified.Visible := true;
        Checked := (UseOnlyIdentified <> 0);
      end
      else begin
        Visible := false;
        lblUseOnlyIdentified.Visible := false;
      end;
    if TargetType < 6 then
      EdtTargetType.Text := TargetTypes [TargetType]
    else
      EdtTargetType.Text := IntToStr (TargetType);
    if DamageType < 5 then
      EdtDamageType.Text := DamageTypes [DamageType]
    else
      EdtDamageType.Text := IntToStr (DamageType);
    Projectl := Game.GetFileByName ('PROJECTL', ftIDS) as TIDSFile;
    if (Projectl <> nil) and Projectl.HasIndex (Wpn.ProjectileType-1) then begin
      EdtProjectile.IsHyperlink := true;
      EdtProjectile.Text := Projectl.LookupString (Wpn.ProjectileType-1);
    end
    else begin
      EdtProjectile.IsHyperlink := false;
      EdtProjectile.Text := IntToStr (Wpn.ProjectileType);
    end;
  end;
  if Length (Wpn.Effects) > 0 then begin
    EffectGrid.Visible := true;
    SetEffectGrid (EffectGrid, Wpn.Effects);
  end
  else
    EffectGrid.Visible := false;
end;

{ effect hyperlinks }

type
  THyperlinkHelper = class
    procedure DrawCell (Sender: TObject; ACol, ARow: Integer; Rect: TRect;
        State: TGridDrawState);
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MouseUp (Sender: TObject; Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer);
  end;

var
  HyperlinkHelper: THyperlinkHelper;

function EffectCanJump (EffectGrid: TStringGrid; ACol, ARow: integer): boolean;
var
  Effect: PEffectRec;
begin
  if (ARow > 0) and (ACol = 7) then begin
    Effect := PEffectRec (EffectGrid.Objects [0, ARow]);
    if Effect = nil then
      Result := false
    else
      Result := (Effect.Resource <> '');
  end
  else
    Result := false;
end;

procedure THyperlinkHelper.DrawCell (Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  EffectGrid: TStringGrid;
begin
  EffectGrid := Sender as TStringGrid;
  if EffectCanJump (EffectGrid, ACol, ARow) then begin
    with EffectGrid.Canvas.Font do begin
      if (gdSelected in State) and not (gdFocused in State) then Color := clWhite
      else Color := clBlue;
      Style := [fsUnderline];
    end;
    DrawCellText (EffectGrid, ACol, ARow, EffectGrid.Cells [ACol, ARow], Rect,
        taLeftJustify, vaTopJustify);
  end;
end;

procedure THyperlinkHelper.MouseMove (Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  EffectGrid: TStringGrid;
  ACol, ARow: integer;
begin
  EffectGrid := Sender as TStringGrid;
  EffectGrid.MouseToCell (X, Y, ACol, ARow);
  if EffectCanJump (EffectGrid, ACol, ARow) then
    EffectGrid.Cursor := crHandPoint
  else
    EffectGrid.Cursor := crDefault;
end;

procedure THyperlinkHelper.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  EffectGrid: TStringGrid;
  ACol, ARow: integer;
begin
  EffectGrid := Sender as TStringGrid;
  EffectGrid.MouseToCell (X, Y, ACol, ARow);
  if EffectCanJump (EffectGrid, ACol, ARow) then
    MainForm.BrowseToFile (EffectGrid.Cells [ACol, ARow], ftNone);
end;

{ effect decoding }

function DecodeEffectParam1 (const Effect: TEffectRec): string;
begin
  Result := '---';
  with Effect do
    case EffectType of
      $08 { COLORGLOW_SOLID },
      $09 { COLORGLOW_PULSE },
      $32 { SINGLECOLORPULSEALL },
      $34 { COLORLIGHT_SOLID } :
        Result := IntToHex (NP1 shr 8, 6) + 'h';  // RGB
      $8B: { DISPLAYSTRING }
        if Game.TLK.ValidID (NP1) then
          Result := '"' + Game.TLK.Text [NP1] + '"';
  end;
  if Result = '---' then
    Result := IntToStr (Effect.NP1);
end;

const
  EffectAnimations: array [1..$47] of string =
      ('AbjurH', 'AlterH', 'InvocH', 'NecroH', 'ConjuH',
       'EnchaH', 'IllusH', 'DivinH', 'ArmorH', 'SArmorH', 'GArmorH',
       'StrengH', 'ConfusH', 'SOFlamH', 'DSpellH', 'DisintH', 'PWSileH',
       'PWStunH', 'FODeatH', 'MSwordH', 'MSumm1H', 'MSumm2H', 'MSumm3H',
       'MSumm4H', 'MSumm5H', 'MSumm6H', 'MSumm7H', 'CFElemH', 'CEElemH',
       'CWElemH', 'BlessH', 'CurseH', 'PrayerH', 'RecitaH', 'CLWounH',
       'CMWounH', 'CSWounH', 'CCWounH', 'HealH', 'ASumm1H', 'ASumm2H',
       'ASumm3H', 'SPoisoH', 'NPoisoH', 'CallLiH', 'SChargH', 'RParalH',
       'FActioH', 'MMagicH', 'SOOneH', 'CStrenH', 'FStrikH', 'RDeadH',
       'ResurrH', 'CCommaH', 'RWOTFaH', 'SunrayX', 'SStoneA', 'DDoorH',
       'DDoorH', 'CoColdH', 'SSOrbH', 'FireH', 'ColdH', 'ElectrH', 'AcidH',
       'ParalH', 'MRageH', 'RWOTFaG', 'BDeath', 'PortalH');

function DecodeEffectParam2 (const Effect: TEffectRec): string;
var
  IDSFile: TIDSFile;
begin
  Result := '---';
  with Effect do
    case EffectType of
      $0C: begin { DAMAGE }
        try
          IDSFile := Game.GetFileByName ('DAMAGES', ftIDS) as TIDSFile;
        except
          IDSFile := nil;
        end;
        if IDSFile <> nil then
          Result := IDSFile.LookupText (NP2 shr 16)
      end;
      $E9: { Effect Animation }
        if Game.GameType = gtIcewind then begin
          if (NP2 >= 1) and (NP2 <= $47) then
            Result := EffectAnimations [NP2];
        end;
      $65 { IMMUNITYTOEFFECT },
      $105: { Immunity to Effect }
        Result := Effect2Name (NP2, Game.GameType);
    end;
  if Result = '---' then
    Result := IntToStr (Effect.NP2);
end;

procedure SetEffectGrid (EffectGrid: TStringGrid; const Effects: array of TEffectRec);
var
  i, k: integer;
  CurCol, CurRow: integer;
  S: string;

  procedure SetCell (const S: string);
  begin
    EffectGrid.Cells [CurCol, CurRow] := S;
    Inc (CurCol);
  end;

  procedure NextRow;
  begin
    Inc (CurRow);
    CurCol := 0;
  end;

const
  STTypes: array [0..5] of string = ('None', 'Spells', 'BW', 'PPDM', 'RSW', 'PP');
begin
  Assert (Low (Effects) = 0);
  with EffectGrid do begin
    CurRow := 0;
    CurCol := 0;
    SetCell ('Effect');
    SetCell ('Targ.type');
    SetCell ('Param 1');
    SetCell ('Param 2');
    SetCell ('Flags');
    SetCell ('Time');
    SetCell ('Prob.');
    SetCell ('ResRef');
    SetCell ('Dice');
    SetCell ('ST type');
    SetCell ('ST bonus');
    //SetCell ('Unknown');
    if High (Effects) < 0 then begin
      RowCount := 2;
      Objects [0, 1] := nil;
      for i := 0 to ColCount-1 do
        Cells [i, 1] := '';
    end
    else begin
      RowCount := High (Effects)+2;
      for i := 0 to High (Effects) do begin
        NextRow;
        Objects [0, CurRow] := TObject (@Effects [i]);
        with Effects [i] do begin
          SetCell (Effect2Name (EffectType, Game.GameType));
          SetCell (IntToStr (TargetType));
          SetCell (DecodeEffectParam1 (Effects [i]));
          SetCell (DecodeEffectParam2 (Effects [i]));
          SetCell (IntToHex (Flags, 4) + 'h');
          SetCell (IntToStr (Time));
          S := IntToStr (Prob1) + '%';
          if Prob2 <> 0 then
            S := S + '/' + IntToStr (Prob2) + '%';
          SetCell (S);
          SetCell (PChar8ToStr (Resource));
          if (DiceCount = 0) and (DiceValue <= 0) then
            SetCell ('-')
          else
            SetCell (IntToStr (DiceCount) + 'd' + IntToStr (DiceValue));
          // saving throw type
          if SaveType = 0 then
            S := STTypes [0]
          else if SaveType > 16 then
            S := 'Unknown (' + IntToHex (SaveType, 2) + ')'
          else begin
            S := '';
            for k := 0 to 4 do
              if SaveType and (1 shl k) <> 0 then begin
                if S <> '' then S := S + ',';
                S := S + STTypes [k+1];
              end;
          end;
          SetCell (S);
          SetCell (IntToStr (SaveBonus));
          //SetCell (IntToStr (Unknown));
        end;
      end;
    end;
    OnDrawCell := HyperlinkHelper.DrawCell;
    OnMouseMove := HyperlinkHelper.MouseMove;
    OnMouseUp := HyperlinkHelper.MouseUp;
  end;
end;

initialization
  HyperlinkHelper := THyperlinkHelper.Create;

finalization
  HyperlinkHelper.Free;

end.
