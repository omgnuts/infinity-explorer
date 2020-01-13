{ $Header: /cvsroot/InfExp/InfExp/src/DlgOpenG.pas,v 1.4 2000/09/01 19:04:36 yole Exp $
  Infinity Explorer: Open Game dialog
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit DlgOpenG;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, ComCtrls;

type
  TOpenGameDialog = class (TForm)
    Label1: TLabel;
    EdtGamePath: TDirectoryEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
    chkIgnoreOverrides: TCheckBox;
    Label2: TLabel;
    lvRecentGames: TListView;
    procedure FormCreate(Sender: TObject);
    procedure lvRecentGamesClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    procedure AddInstalledGame (const GameName, RegPath, RegValue: string);
    procedure AddRecentGame (const GamePath, GameName: string);
    procedure LoadRecentGames;
    procedure SaveRecentGame (const GamePath: string);
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses Registry, FTUtils;

procedure TOpenGameDialog.FormCreate (Sender: TObject);
begin
  AddInstalledGame ('Baldur''s Gate 2', 'SOFTWARE\Microsoft\DirectPlay\Applications\Baldur''s Gate2', 'Path');
  AddInstalledGame ('Icewind Dale 2', 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\IWD2.exe', 'Path');
  LoadRecentGames;
end;

procedure TOpenGameDialog.AddInstalledGame (const GameName, RegPath, RegValue: string);
var
  Reg: TRegistry;
  GamePath: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey (RegPath, false) then begin
      GamePath := Reg.ReadString (RegValue);
      if GamePath <> '' then AddRecentGame (GamePath, GameName);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TOpenGameDialog.AddRecentGame (const GamePath, GameName: string);
var
  Itm: TListItem;
begin
  Itm := lvRecentGames.Items.Add;
  Itm.Caption := GamePath;
  if GameName <> '' then
    Itm.SubItems.Add (GameName);
end;

procedure TOpenGameDialog.LoadRecentGames;
var
  Reg: TRegistry;
  i, RecentCount: integer;
begin
  Reg := TRegistry.Create;
  try
    if Reg.OpenKey ('Software\Yoletir\InfExp\Recent Games', false) then begin
      if Reg.ValueExists ('Count') then begin
        RecentCount := Reg.ReadInteger ('Count');
        for i := 0 to RecentCount-1 do
          AddRecentGame (Reg.ReadString (Format ('Game%d', [i])), '');
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TOpenGameDialog.lvRecentGamesClick (Sender: TObject);
begin
  if lvRecentGames.Selected <> nil then
    edtGamePath.Text := lvRecentGames.Selected.Caption;
end;

procedure TOpenGameDialog.BtnOKClick (Sender: TObject);
var
  GamePath: string;
begin
  GamePath := edtGamePath.Text;
  if not FileExists (MkPath ('chitin.key', GamePath)) then begin
    MessageDlg (Format ('The directory %s does not contain an Infinity Engine game',
        [GamePath]), mtInformation, [mbOk], 0);
    Exit;
  end;
  ModalResult := mrOk;
  SaveRecentGame (GamePath);
end;

procedure TOpenGameDialog.SaveRecentGame (const GamePath: string);
var
  i, RecentCount: integer;
  Reg: TRegistry;
begin
  if GamePath = '' then Exit;
  for i := 0 to lvRecentGames.Items.Count-1 do
    if SameText (GamePath, lvRecentGames.Items [i].Caption) then Exit;
  Reg := TRegistry.Create;
  try
    Reg.OpenKey ('Software\Yoletir\InfExp\Recent Games', true);
    RecentCount := 0;
    if Reg.ValueExists ('Count') then
      RecentCount := Reg.ReadInteger ('Count');
    Reg.WriteString (Format ('Game%d', [RecentCount]), GamePath);
    Reg.WriteInteger ('Count', RecentCount+1);
  finally
    Reg.Free;
  end;
end;

end.

