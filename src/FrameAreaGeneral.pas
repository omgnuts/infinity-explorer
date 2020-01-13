{ $Header: /cvsroot/InfExp/InfExp/src/FrameAreaGeneral.pas,v 1.1 2000/07/23 12:26:12 yole Exp $
  Infinity Engine area general information viewer frame
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit FrameAreaGeneral;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Infinity, InfStruc;

type
  TAreaGeneralFrame = class(TFrame)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EdtExitN: TEdit;
    Label2: TLabel;
    EdtExitW: TEdit;
    EdtExitS: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EdtExitE: TEdit;
    Label5: TLabel;
    EdtAIScript: TEdit;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EdtRainProbability: TEdit;
    EdtSnowProbability: TEdit;
    EdtFogProbability: TEdit;
    EdtLightningProbability: TEdit;
    chkFlag0: TCheckBox;
    chkFlag1: TCheckBox;
    chkFlag2: TCheckBox;
    chkFlag6: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EdtAreaType: TEdit;
    procedure EdtAIScriptMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EdtExitNMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnShowImpassableClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowArea (const Area: TAreaHeaderRec; const Offsets: TAreaOffsetsRec);
  end;

implementation

{$R *.DFM}

uses InfMain, FrameARE;

{ TAreaGeneralFrame }

procedure TAreaGeneralFrame.ShowArea (const Area: TAreaHeaderRec;
    const Offsets: TAreaOffsetsRec);
var
  i: integer;
  Chk: TComponent;
begin
  with Area do begin
    SetEdit (EdtExitN, ExitN);
    SetEdit (EdtExitW, ExitW);
    SetEdit (EdtExitS, ExitS);
    SetEdit (EdtExitE, ExitE);
    SetEdit (EdtAIScript, Offsets.AIScript);
    EdtRainProbability.Text := IntToStr (RainProbability) + '%';
    EdtSnowProbability.Text := IntToStr (SnowProbability) + '%';
    EdtFogProbability.Text := IntToStr (FogProbability) + '%';
    EdtLightningProbability.Text := IntToStr (LightningProbability) + '%';
    for i := 0 to 6 do begin
      Chk := FindComponent ('chkFlag' + IntToStr (i));
      if Chk <> nil then
        (Chk as TCheckBox).Checked := (Flags and (1 shl i) <> 0);
    end;
    if Flags and 8 <> 0 then
      EdtAreaType.Text := 'City'
    else if Flags and $10 <> 0 then
      EdtAreaType.Text := 'Forest'
    else if Flags and $20 <> 0 then
      EdtAreaType.Text := 'Dungeon'
    else
      EdtAreaType.Text := 'Normal';
  end;
end;

procedure TAreaGeneralFrame.EdtAIScriptMouseUp (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender as TEdit).Text <> '' then
    MainForm.BrowseToFile ((Sender as TEdit).Text, ftSCRIPT);
end;

procedure TAreaGeneralFrame.EdtExitNMouseUp (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender as TEdit).Text <> '' then
    MainForm.BrowseToFile ((Sender as TEdit).Text, ftAREA);
end;

procedure TAreaGeneralFrame.BtnShowImpassableClick (Sender: TObject);
begin
  (MainForm.CurFrame as TAreaFrameProxy).ShowImpassable;
end;

end.
