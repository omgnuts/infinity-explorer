{ $Header: /cvsroot/InfExp/InfExp/src/FrameAreaNPC.pas,v 1.4 2000/11/01 19:00:14 yole Exp $
  Infinity Engine area NPC viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameAreaNPC;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Infinity, InfMain, InfStruc, ExtCtrls, Hyperlink;

type
  TAreaNPCFrame = class (TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    EdtName: TEdit;
    GroupBox1: TGroupBox;
    EdtScriptOverride: THyperlinkEdit;
    EdtScriptClass: THyperlinkEdit;
    EdtScriptRace: THyperlinkEdit;
    EdtCREFile: THyperlinkEdit;
    Label3: TLabel;
    EdtDialog: THyperlinkEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EdtScriptGeneral: THyperlinkEdit;
    Label8: TLabel;
    EdtScriptDefault: THyperlinkEdit;
    Label9: TLabel;
    EdtScriptSpecifics: THyperlinkEdit;
    chkVisible: TCheckBox;
    Label10: TLabel;
  private
    { Private declarations }
  public
    procedure ShowNPC (const NPC: TAreaNPCRec);
  end;

implementation

{$R *.DFM}

{ TAreaNPCFrame }

procedure TAreaNPCFrame.ShowNPC (const NPC: TAreaNPCRec);
begin
  with NPC do begin
    EdtName.Text := Name;
    EdtCREFile.ResRef := CREfile;
    EdtDialog.ResRef := Dialog;
    EdtScriptOverride.ResRef := ScriptOverride;
    EdtScriptClass.ResRef := ScriptClass;
    EdtScriptGeneral.ResRef := ScriptGeneral;
    EdtScriptDefault.ResRef := ScriptDefault;
    EdtScriptSpecifics.ResRef := ScriptSpecifics;
    chkVisible.Checked := (Visible <> 0);
  end;
end;

end.
 