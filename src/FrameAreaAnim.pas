{ $Header: /cvsroot/InfExp/InfExp/src/FrameAreaAnim.pas,v 1.1 2000/09/06 18:52:19 yole Exp $
  Infinity Engine area container viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameAreaAnim;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, InfStruc, StdCtrls, Hyperlink;

type
  TAreaAnimFrame = class (TFrame)
    Label1: TLabel;
    EdtBAM: THyperlinkEdit;
    Label2: TLabel;
    EdtAnim: TEdit;
    procedure EdtBAMJump(Sender: TObject);
  private
    FAnim: TAreaAnimRec;
  public
    procedure ShowAnim (const Anim: TAreaAnimRec);
  end;

implementation

{$R *.DFM}

{ TAreaAnimFrame }

procedure TAreaAnimFrame.ShowAnim (const Anim: TAreaAnimRec);
begin
  FAnim := Anim;
  with Anim do begin
    EdtBAM.ResRef := Anim.BAMId;
    EdtAnim.Text := IntToStr (Anim.BAMCycle);
  end;
end;

procedure TAreaAnimFrame.EdtBAMJump (Sender: TObject);
begin
  MainForm.BrowseToFileEx (PChar8ToStr (FAnim.BAMId), ftBAM,
      Pointer (FAnim.BAMCycle shl 16));
end;

end.
 