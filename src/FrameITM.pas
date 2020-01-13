{ $Header: /cvsroot/InfExp/InfExp/src/FrameITM.pas,v 1.7 2000/10/03 06:50:32 yole Exp $
  Infinity Explorer: ITM view
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameITM;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, InfStruc, StdCtrls, ComCtrls, ExtCtrls, FrameAbility,
  Grids, Hyperlink, InfGraphics;

type
  TITMFrame = class (TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EdtName: TEdit;
    grpDescription: TGroupBox;
    MemDesc: TMemo;
    Image1: TBAMIcon;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    EdtPrice: TEdit;
    Label3: TLabel;
    EdtWeight: TEdit;
    Label4: TLabel;
    EdtMaxInStack: TEdit;
    Label5: TLabel;
    EdtLoreToIdentify: TEdit;
    Label6: TLabel;
    EdtEnchanted: TEdit;
    lblDialog: TLabel;
    EdtDialog: THyperlinkEdit;
    AbilityTab: TTabSheet;
    Label12: TLabel;
    EdtPicture: THyperlinkEdit;
    lblPictureCarried: TLabel;
    EdtPictureCarried: THyperlinkEdit;
    Label14: TLabel;
    EdtPictureGround: THyperlinkEdit;
    chkFlag0: TCheckBox;
    chkFlag1: TCheckBox;
    chkFlag2: TCheckBox;
    chkFlag3: TCheckBox;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    chkFlag4: TCheckBox;
    Label18: TLabel;
    chkFlag5: TCheckBox;
    Label19: TLabel;
    chkFlag6: TCheckBox;
    Label20: TLabel;
    chkFlag7: TCheckBox;
    Label21: TLabel;
    chkFlag8: TCheckBox;
    Label22: TLabel;
    chkFlag9: TCheckBox;
    Label23: TLabel;
    chkFlag10: TCheckBox;
    Label24: TLabel;
    chkFlag11: TCheckBox;
    lblFlag11: TLabel;
    chkFlag12: TCheckBox;
    Label26: TLabel;
    AbilityFrame1: TAbilityFrame;
    GlobalEffectTab: TTabSheet;
    GlobalEffectGrid: TStringGrid;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    chkUse0: TCheckBox;
    Label7: TLabel;
    chkUse1: TCheckBox;
    chkUse2: TCheckBox;
    chkUse3: TCheckBox;
    chkUse4: TCheckBox;
    chkUse5: TCheckBox;
    chkUse6: TCheckBox;
    chkUse7: TCheckBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label27: TLabel;
    lblUse6: TLabel;
    Label29: TLabel;
    chkUse8: TCheckBox;
    chkUse9: TCheckBox;
    lblUse8: TLabel;
    Label31: TLabel;
    chkUse10: TCheckBox;
    chkUse11: TCheckBox;
    chkUse12: TCheckBox;
    chkUse13: TCheckBox;
    chkUse14: TCheckBox;
    chkUse15: TCheckBox;
    chkUse16: TCheckBox;
    chkUse17: TCheckBox;
    chkUse18: TCheckBox;
    chkUse19: TCheckBox;
    lblUse10: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    lblUse14: TLabel;
    Label37: TLabel;
    lblUse16: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    chkUse20: TCheckBox;
    chkUse21: TCheckBox;
    chkUse22: TCheckBox;
    chkUse23: TCheckBox;
    chkUse24: TCheckBox;
    chkUse25: TCheckBox;
    chkUse26: TCheckBox;
    chkUse27: TCheckBox;
    chkUse28: TCheckBox;
    chkUse30: TCheckBox;
    lblUse20: TLabel;
    lblUse21: TLabel;
    Label44: TLabel;
    lblUse23: TLabel;
    lblUse24: TLabel;
    lblUse25: TLabel;
    lblUse26: TLabel;
    Label49: TLabel;
    lblUse28: TLabel;
    lblUse30: TLabel;
    Label28: TLabel;
    EdtUsedUp: THyperlinkEdit;
    Label30: TLabel;
    EdtInventoryID: TEdit;
    Label32: TLabel;
    EdtCategory: TEdit;
    GroupBox2: TGroupBox;
    Label36: TLabel;
    EdtMinStr: TEdit;
    Label38: TLabel;
    EdtMinInt: TEdit;
    EdtMinDex: TEdit;
    Label42: TLabel;
    Label43: TLabel;
    EdtMinCon: TEdit;
    EdtMinStrBonus: TEdit;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    EdtMinWis: TEdit;
    EdtMinCha: TEdit;
    procedure AbilityFrame1AbilityComboChange(Sender: TObject);
  private
    FItem: TITMFile;
  protected
    procedure Loaded; override;
  public
    procedure ViewFile (AFile: TGameFile);
  end;

  TITMFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure GetPosInfo (var PosInfo: pointer); override;
    procedure SetPosInfo (PosInfo: pointer); override;
  end;

implementation

{$R *.DFM}

{ TITMFrame }

procedure TITMFrame.Loaded;
begin
  inherited;
  if Game.GameType = gtTorment then begin
    lblUse6.Caption := 'Sensates';
    lblUse8.Caption := 'Godsmen';
    lblUse10.Caption := 'Chaosmen';
    lblUse14.Caption := 'Dustmen';
    lblUse16.Caption := 'Indeps';
    lblUse20.Caption := 'Dak''kon';
    lblUse21.Caption := 'Fall-from-Grace';
    lblUse23.Caption := 'Vhailor';
    lblUse24.Caption := 'Ignus';
    lblUse25.Caption := 'Morte';
    lblUse26.Caption := 'Modrons';
    lblUse28.Caption := 'Annah';
    lblUse30.Caption := 'Nameless One';
    lblFlag11.Caption := 'Single use';
  end;
end;

procedure TITMFrame.ViewFile (AFile: TGameFile);
var
  Flag: TItemFlag;
  Chk: TComponent;
  i: integer;
  BAM: TBAMImage;
begin
  FItem := AFile as TITMFile;
  with FItem do begin
    EdtName.Text := GetName;
    if DescIdent = '?' then begin
      MemDesc.Lines.Text := DescUnident;
      grpDescription.Caption := Format ('Description (index %d)', [Hdr10.DescUnident]);
    end else begin
      MemDesc.Lines.Text := DescIdent;
      grpDescription.Caption := Format ('Description (index %d)', [Hdr10.DescIdent]);
    end;
    with Hdr10 do begin
      EdtPicture.ResRef := BAMIdInv;
      EdtPictureGround.ResRef := BAMIdGround;
      EdtUsedUp.ResRef := Destroyed;
      Image1.BAMId := BAMIdInv;
      BAM := Game.GetFileByName (BAMIdInv, ftBAM) as TBAMImage;
      if (BAM <> nil) and (Length (BAM.Frames) > 1) then
        Image1.BAMFrame := 1
      else
        Image1.BAMFrame := 0;
      EdtInventoryID.Text := WeaponID [0] + WeaponID [1];
      if ItemType > $39 then
        EdtCategory.Text := 'Unknown (' + IntToHex (ItemType, 2) + ')'
      else
        EdtCategory.Text := CategoryNames [ItemType];
    end;
    if Version = 10 then begin
      EdtPictureCarried.Visible := true;
      lblPictureCarried.Visible := true;
      EdtPictureCarried.ResRef := Hdr10.BAMIdCarried;
    end else begin
      EdtPictureCarried.Visible := false;
      lblPictureCarried.Visible := false;
    end;
    with Hdr10 do begin
      EdtPrice.Text := IntToStr (Price);
      EdtWeight.Text := IntToStr (Weight);
      EdtMaxInStack.Text := IntToStr (MaxInStack);
      EdtLoreToIdentify.Text := IntToStr (LoreToIdentify);
      if Enchanted = 0 then EdtEnchanted.Text := 'No'
      else EdtEnchanted.Text := '+' + IntToStr (Enchanted);
    end;
    if Version = 10 then begin
      lblDialog.Visible := false;
      EdtDialog.Visible := false;
    end else begin
      lblDialog.Visible := true;
      with EdtDialog do begin
        Visible := true;
        Text := Dialog;
      end;
    end;
    for Flag := Low (TItemFlag) to High (TItemFlag) do begin
      Chk := FindComponent ('chkFlag' + IntToStr (Ord (Flag)));
      if Chk <> nil then
        (Chk as TCheckBox).Checked := (Flag in Flags);
    end;
    for i := 0 to 31 do begin
      Chk := FindComponent ('chkUse' + IntToStr (i));
      if Chk <> nil then
        (Chk as TCheckBox).Checked := (Hdr10.ItemUsability and (1 shl i) <> 0);
    end;
    with Hdr10 do begin
      EdtMinStr.Text := IntToStr (MinStr);
      if MinStr = 18 then EdtMinStrBonus.Text := IntToStr (MinStrBonus)
      else EdtMinStrBonus.Text := '';
      EdtMinDex.Text := IntToStr (MinDex);
      EdtMinCon.Text := IntToStr (MinCon);
      EdtMinInt.Text := IntToStr (MinInt);
      EdtMinWis.Text := IntToStr (MinWis);
      EdtMinCha.Text := IntToStr (MinCha);
    end;
    if Length (GlobalEffects) = 0 then GlobalEffectTab.TabVisible := false
    else begin
      GlobalEffectTab.TabVisible := true;
      SetEffectGrid (GlobalEffectGrid, GlobalEffects);
    end;
    if Length (Abilities) = 0 then AbilityTab.TabVisible := false
    else begin
      AbilityTab.TabVisible := true;
      AbilityFrame1.SetAbilities (Abilities, Hdr10.Enchanted);
    end;
  end;
end;

procedure TITMFrame.AbilityFrame1AbilityComboChange(Sender: TObject);
begin
  AbilityFrame1.ViewAbility ((Sender as TComboBox).ItemIndex);
end;

{ TITMFrameProxy }

constructor TITMFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TITMFrame;
end;

procedure TITMFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TITMFrame).ViewFile (AFile);
end;

procedure TITMFrameProxy.GetPosInfo(var PosInfo: pointer);
begin
  PosInfo := Pointer ((FFrame as TITMFrame).PageControl1.ActivePageIndex);
end;

procedure TITMFrameProxy.SetPosInfo(PosInfo: pointer);
begin
  (FFrame as TITMFrame).PageControl1.ActivePageIndex := integer (PosInfo);
end;

end.
