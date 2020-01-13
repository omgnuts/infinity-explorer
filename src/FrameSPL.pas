{ $Header: /cvsroot/InfExp/InfExp/src/FrameSPL.pas,v 1.3 2000/11/01 19:00:14 yole Exp $
  Infinity Explorer: SPL view
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameSPL;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Infinity, InfMain, ExtCtrls, FrameAbility,
  InfGraphics, Hyperlink;

type
  TSPLFrame = class (TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EdtName: TEdit;
    grpDescription: TGroupBox;
    MemDesc: TMemo;
    Label12: TLabel;
    EdtPicture: THyperlinkEdit;
    Image1: TBAMIcon;
    Label2: TLabel;
    EdtSound: THyperlinkEdit;
    TabSheet2: TTabSheet;
    AbilityFrame1: TAbilityFrame;
    Label3: TLabel;
    EdtLevel: TEdit;
    Label4: TLabel;
    EdtSpellType: TEdit;
    procedure AbilityFrame1AbilityComboChange(Sender: TObject);
  private
    FSpell: TSPLFile;
  public
    procedure ViewFile (AFile: TGameFile);
  end;

  TSPLFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure GetPosInfo (var PosInfo: pointer); override;
    procedure SetPosInfo (PosInfo: pointer); override;
  end;

implementation

{$R *.DFM}

uses InfStruc;

{ TSPLFrame }

procedure TSPLFrame.ViewFile (AFile: TGameFile);
var
  BAM: TBAMImage;
  S: string;
begin
  FSpell := AFile as TSPLFile;
  with FSpell do begin
    EdtName.Text := SpellName;
    MemDesc.Lines.Text := SpellDesc;
    grpDescription.Caption := Format ('Description (index %d)', [Hdr.TLKDesc]);
    EdtPicture.ResRef := Hdr.SpellIcon;
    S := PChar8ToStr (Hdr.SpellIcon);
    Image1.BAMId := S;
    BAM := Game.GetFileByName (S, ftBAM) as TBAMImage;
    if (BAM <> nil) and (Length (BAM.Frames) > 1) then
      Image1.BAMFrame := 1
    else
      Image1.BAMFrame := 0;
    EdtSound.ResRef := Hdr.SoundId;
    EdtLevel.Text := IntToStr (Hdr.Level);
    case Hdr.SpellType of
      1: EdtSpellType.Text := 'Wizard';
      2: EdtSpellType.Text := 'Priest';
      4: EdtSpellType.Text := 'Innate';
      else EdtSpellType.Text := IntToStr (Hdr.SpellType);
    end;
    if Length (Abilities) = 0 then TabSheet2.TabVisible := false
    else begin
      TabSheet2.TabVisible := true;
      AbilityFrame1.SetAbilities (Abilities, 0);
    end;
  end;
end;

{ TSPLFrameProxy }

constructor TSPLFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TSPLFrame;
end;

procedure TSPLFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TSPLFrame).ViewFile (AFile);
end;

procedure TSPLFrame.AbilityFrame1AbilityComboChange(Sender: TObject);
begin
  AbilityFrame1.ViewAbility ((Sender as TComboBox).ItemIndex);
end;

procedure TSPLFrameProxy.GetPosInfo(var PosInfo: pointer);
begin
  PosInfo := Pointer ((FFrame as TSPLFrame).PageControl1.ActivePageIndex);
end;

procedure TSPLFrameProxy.SetPosInfo(PosInfo: pointer);
begin
  (FFrame as TSPLFrame).PageControl1.ActivePageIndex := integer (PosInfo);
end;

end.
