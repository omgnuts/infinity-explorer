{ $Header: /cvsroot/InfExp/InfExp/src/FrameQuest.pas,v 1.4 2000/11/01 19:00:14 yole Exp $
  Infinity Engine quest viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameQuest;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Infinity, InfMain;

type
  TQuestFrame = class (TFrame)
    TabControl1: TTabControl;
    GroupBox1: TGroupBox;
    MemCond: TMemo;
    grpDesc: TGroupBox;
    MemDesc: TMemo;
    procedure TabControl1Change(Sender: TObject);
  private
    procedure SetElem (Elem: TQuestElem);
  public
    Quest: TQuest;
    procedure SetQuest (AQuest: TQuest);
  end;

  TQuestFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure ViewQuest (const Quest: TQuest);
  end;

implementation

{$R *.DFM}

{ TQuestFrame }

procedure TQuestFrame.SetQuest (AQuest: TQuest);
var
  i: integer;
  OldTabIndex: integer;
begin
  Quest := AQuest;
  OldTabIndex := TabControl1.TabIndex;
  with TabControl1.Tabs do begin
    BeginUpdate;
    try
      for i := Count-1 downto 2 do Delete (i);  // leave Assigned and Completed
      for i := 1 to Length (AQuest.Complete)-1 do
        Add ('Completed '+Char (Ord ('A')+i));
    finally
      EndUpdate;
    end;
  end;
  if OldTabIndex > TabControl1.Tabs.Count-1 then
    TabControl1.TabIndex := 1;
  TabControl1Change (nil);  // update current page
end;

procedure TQuestFrame.TabControl1Change (Sender: TObject);
begin
  if TabControl1.TabIndex = 0 then SetElem (Quest.Assigned)
  else if TabControl1.TabIndex-1 < Length (Quest.Complete) then
    SetElem (Quest.Complete [TabControl1.TabIndex-1]);
end;

procedure TQuestFrame.SetElem (Elem: TQuestElem);
var
  i: integer;
begin
  MemCond.Lines.Clear;
  for i := 0 to Length (Elem.Checks)-1 do
    MemCond.Lines.Add (Elem.Checks [i]);
  MemDesc.Text := Game.TLK.Text [Elem.DescIndex];
  grpDesc.Caption := Format ('Description (index %d)', [Elem.DescIndex]);
end;

{ TQuestFrameProxy }

constructor TQuestFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TQuestFrame;
end;

procedure TQuestFrameProxy.DoViewFile (AFile: TGameFile);
begin
  // because a TQuest is not a TGameFile, DoViewFile is just a do-nothing stub.
end;

procedure TQuestFrameProxy.ViewQuest (const Quest: TQuest);
begin
  if FFrame = nil then FFrame := TQuestFrame.Create (FOwner);
  TQuestFrame (FFrame).SetQuest (Quest);
end;

end.
