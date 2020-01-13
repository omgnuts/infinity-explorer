{ $Header: /cvsroot/InfExp/InfExp/src/FrameAreaInfo.pas,v 1.4 2000/11/01 19:00:14 yole Exp $
  Infinity Engine area info viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameAreaInfo;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Infinity, InfMain, InfStruc, ExtCtrls, ComCtrls, Hyperlink,
  InfGraphics;

type
  TAreaInfoFrame = class (TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    EdtName: TEdit;
    PageControl1: TPageControl;
    ProximityTab: TTabSheet;
    InfoTab: TTabSheet;
    TravelTab: TTabSheet;
    Label4: TLabel;
    EdtDestArea: THyperlinkEdit;
    Label5: TLabel;
    EdtDestEntrance: TEdit;
    lblDescription: TLabel;
    MemDesc: TMemo;
    Label3: TLabel;
    EdtDialog: THyperlinkEdit;
    ChkTrapped: TCheckBox;
    Label8: TLabel;
    Label2: TLabel;
    EdtTrapRemovalDifficulty: TEdit;
    ChkTrapDetected: TCheckBox;
    Label9: TLabel;
    Label7: TLabel;
    EdtTrapDetectionDifficulty: TEdit;
    Label11: TLabel;
    EdtKeyType: THyperlinkEdit;
    chkResetTrap: TCheckBox;
    Label6: TLabel;
    chkPartyRequired: TCheckBox;
    Label12: TLabel;
    Label10: TLabel;
    EdtScript: THyperlinkEdit;
    Label13: TLabel;
    EdtCursor: TEdit;
    BAMCursor: TBAMIcon;
  private
    { Private declarations }
  public
    procedure ShowInfo (const Info: TAreaInfo);
  end;

implementation

{$R *.DFM}

{ TAreaInfoFrame }

procedure TAreaInfoFrame.ShowInfo (const Info: TAreaInfo);
begin
  with Info.Hdr do begin
    EdtName.Text := Id;
    EdtDestArea.ResRef := DestArea;
    EdtDestEntrance.Text := DestEntrance;
    lblDescription.Caption := 'Description (index ' + IntToStr (DescTLKIndex) + ')';
    if Game.TLK.ValidID (DescTLKIndex) then
      MemDesc.Lines.Text := Game.TLK.Text [DescTLKIndex]
    else
      MemDesc.Lines.Clear;
    EdtDialog.ResRef := Dialog;
    EdtScript.ResRef := Script;
    EdtKeyType.ResRef := KeyType;
    ChkTrapped.Checked := (Trapped <> 0);
    ChkTrapDetected.Checked := (TrapDetected <> 0);
    EdtTrapDetectionDifficulty.Text := IntToStr (TrapDetectionDifficulty);
    EdtTrapRemovalDifficulty.Text := IntToStr (TrapRemovalDifficulty);
    chkResetTrap.Checked := (Flags and atfResetTrap <> 0);
    chkPartyRequired.Checked := (Flags and atfPartyRequired <> 0);
    EdtCursor.Text := IntToStr (CursorIndex);
    BAMCursor.BAMId := 'CURSORS';
    BAMCursor.SetSeqFrame (CursorIndex, 0);
    case TAreaTriggerType (TriggerType) of
      attProximity: PageControl1.ActivePage := ProximityTab;
      attInfo: PageControl1.ActivePage := InfoTab;
      attTravel: PageControl1.ActivePage := TravelTab;
      else MessageDlg (Format ('Unknown trigger type %d', [TriggerType]),
          mtInformation, [mbOk], 0); 
    end;
  end;
end;

end.
