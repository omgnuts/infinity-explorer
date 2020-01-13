{ $Header: /cvsroot/InfExp/InfExp/src/FrameAreaDoor.pas,v 1.3 2000/09/01 19:04:36 yole Exp $
  Infinity Engine area door viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit FrameAreaDoor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, InfStruc, StdCtrls, ExtCtrls, Hyperlink;

type
  TAreaDoorFrame = class (TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EdtName: TEdit;
    ChkLocked: TCheckBox;
    EdtLockDifficulty: TEdit;
    ChkTrapped: TCheckBox;
    EdtTrapRemovalDifficulty: TEdit;
    ChkTrapDetected: TCheckBox;
    EdtTrapDetectionDifficulty: TEdit;
    EdtTrapScript: THyperlinkEdit;
    EdtKeyType: THyperlinkEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
  private
    { Private declarations }
  public
    procedure ShowDoor (const Door: TAreaDoor);
  end;

implementation

{$R *.DFM}

{ TAreaDoorFrame }

procedure TAreaDoorFrame.ShowDoor (const Door: TAreaDoor);
begin
  with Door do begin
    EdtName.Text := Hdr.Name;
    ChkLocked.Checked := (Hdr.Flags and 2 <> 0);
    EdtLockDifficulty.Text := IntToStr (Hdr.LockDifficulty);
    ChkTrapped.Checked := (Hdr.Trapped <> 0);
    EdtTrapRemovalDifficulty.Text := IntToStr (Hdr.TrapRemovalDifficulty);
    ChkTrapDetected.Checked := (Hdr.TrapDetected <> 0);
    EdtTrapDetectionDifficulty.Text := IntToStr (Hdr.TrapDetectionDifficulty);
    EdtTrapScript.ResRef := Hdr.TrapScript;
    EdtKeyType.ResRef := Hdr.KeyType;
  end;
end;

end.
