{ $Header: /cvsroot/InfExp/InfExp/src/FrameDLG.pas,v 1.7 2000/11/01 19:00:14 yole Exp $
  Infinity Engine DLG browser frame
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit FrameDLG;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, InfMain, Infinity, InfStruc, RxRichEd;

type
  TDlgFrame = class (TFrame)
    tvDialog: TTreeView;
    Splitter1: TSplitter;
    ScrollBox1: TScrollBox;
    grpCond: TGroupBox;
    LeftMarginPanel: TPanel;
    RightMarginPanel: TPanel;
    Panel1: TPanel;
    grpAction: TGroupBox;
    Panel2: TPanel;
    grpJournal: TGroupBox;
    JournalLeftMarginPanel: TPanel;
    JournalRightMarginPanel: TPanel;
    grpText: TGroupBox;
    MemText: TMemo;
    memJournal: TMemo;
    reCond: TRxRichEdit;
    reAction: TRxRichEdit;
    procedure tvDialogExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvDialogChange(Sender: TObject; Node: TTreeNode);
    procedure FrameResize(Sender: TObject);
    procedure tvDialogKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure reCondMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure reCondURLClick(Sender: TObject; const URLText: String;
      Button: TMouseButton);
    procedure reCondMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FClosing: boolean;
    LinkClicked: boolean;
    LinkText: string;
  public
    FDlg: TDlg;
    procedure ViewFile (AFile: TGameFile);
    procedure CloseFile;
  end;

  TDlgFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure CloseFile; override;
    function  CanSearch: TSearchTypes; override;
    function  DoSearch (AFile: TGameFile; SearchPos: TSearchPos): boolean; override;
    function  SearchForCode (AFile: TGameFile; SearchPos: TSearchPos): boolean;
    procedure LocatePos (SearchPos: TSearchPos); override;
  end;

implementation

{$R *.DFM}

uses FTUtils, RxStrUtils, FrameSCR;

procedure SetGrpMemo (Memo: TCustomMemo; Grp: TGroupBox; const Text: string);
begin
  Grp.Visible := true;
  SetMemo (Memo, Text);
  Grp.Height := Memo.Height + 24;
end;

procedure SetGrpMemoHide (Memo: TCustomMemo; Grp: TGroupBox; const Text: string);
begin
  if Text = '' then Grp.Visible := false
  else SetGrpMemo (Memo, Grp, Text);
end;

type
  TDlgNode = class
  protected
    FText: string;
    FNode: TTreeNode;
    FOwner: TDlgFrame;
    FDlg: TDlg;
    procedure SetText (AText: string);
  public
    Expanded: boolean;
    constructor Create (AOwner: TDlgFrame; ADlg: TDlg);
    procedure BeginExpand;
    procedure EndExpand;
    procedure Expand; virtual; abstract;
    procedure Select; virtual; abstract;
  end;

  TPhraseNode = class (TDlgNode)
  private
    FPhrase: TDlgPhrase;
    FDlgName: string;
    FPhraseIndex: integer;
    FTopLevel: boolean;
  public
    constructor Create (AOwner: TDlgFrame; ADlg: TDlg; AParent: TTreeNode;
        APhraseIndex: Integer);
    procedure Expand; override;
    procedure Select; override;
    property TopLevel: boolean read FTopLevel write FTopLevel;
  end;

  TResponceNode = class (TDlgNode)
  private
    FResponse: TDlgResponce;
    FResponseIndex: integer;
    FDlgName: string;
  public
    constructor Create (AOwner: TDlgFrame; ADlg: TDlg; AParent: TTreeNode;
        AResponseIndex: integer);
    procedure Expand; override;
    procedure Select; override;
  end;

{ TDlgNode }

constructor TDlgNode.Create (AOwner: TDlgFrame; ADlg: TDlg);
begin
  FOwner := AOwner;
  FDlg := ADlg;
  Expanded := false;
end;

procedure TDlgNode.SetText (AText: string);
var
  P: integer;
begin
  if Length (AText) <= 64 then FText := AText
  else begin
    P := 64;
    while (AText [P] <> ' ') and (P > 1) do
      Dec (P);
    FText := ReplaceStr (Copy (AText, 1, P-1), #13#10, ' ') + '...';
  end;
end;

procedure TDlgNode.BeginExpand;
begin
  Screen.Cursor := crHourglass;
  FOwner.tvDialog.Items.BeginUpdate;
end;

procedure TDlgNode.EndExpand;
begin
  FOwner.tvDialog.Items.EndUpdate;
  Screen.Cursor := crDefault;
  Expanded := true;
end;

{ TPhraseNode }

constructor TPhraseNode.Create (AOwner: TDlgFrame; ADlg: TDlg; AParent: TTreeNode;
  APhraseIndex: integer);
begin
  inherited Create (AOwner, ADlg);
  FTopLevel := false;
  FPhraseIndex := APhraseIndex;
  FDlgName := ADlg.Name;
  if (FPhraseIndex < 0) or (FPhraseIndex >= Length (ADlg.Phrases)) then
    FPhrase := nil
  else
    FPhrase := ADlg.Phrases [FPhraseIndex];
  if FPhrase <> nil then
    SetText (Game.TLK.Text [FPhrase.TextIndex])
  else
    SetText ('<INVALID PHRASE>');
  FNode := FOwner.tvDialog.Items.AddChildObject (AParent, FText, Self);
  if FPhrase <> nil then
    FNode.HasChildren := (FPhrase.ResponceCount > 0)
  else
    FNode.HasChildren := false;
end;

procedure TPhraseNode.Expand;
var
  i: integer;
begin
  BeginExpand;
  try
    for i := 0 to FPhrase.ResponceCount-1 do
      TResponceNode.Create (FOwner, FDlg, FNode, FPhrase.FirstResponce+i);
  finally
    EndExpand;
  end;
end;

procedure TPhraseNode.Select;
var
  Snd, Txt, GrpCaption: string;
begin
  with FOwner do begin
    grpAction.Visible := false;
    grpJournal.Visible := false;
    if FPhrase = nil then begin
      grpText.Visible := false;
      grpCond.Visible := false;
    end
    else begin
      Txt := Game.TLK.Text [FPhrase.TextIndex];
      Snd := Game.TLK.Sound [FPhrase.TextIndex];
      if Snd <> '' then
        SetGrpMemo (MemText, grpText, '[SOUND '+Snd+'] '+Txt)
      else
        SetGrpMemo (MemText, grpText, Txt);
      GrpCaption := Format ('Text (index %d): %s phrase %d',
          [FPhrase.TextIndex, FDlgName, FPhraseIndex]);
      if TopLevel then GrpCaption := GrpCaption + Format (', weight %d', [FPhrase.CondIndex]);
      grpText.Caption := GrpCaption;
      SetGrpMemoHide (reCond, grpCond, FPhrase.Cond);
      if FPhrase.Cond <> '' then FormatScript (reCond);
      if grpCond.Top < grpText.Top then grpCond.Top := grpText.Top + 1;
    end;
  end;
end;

{ TResponceNode }

constructor TResponceNode.Create (AOwner: TDlgFrame; ADlg: TDlg; AParent: TTreeNode;
    AResponseIndex: integer);
begin
  inherited Create (AOwner, ADlg);
  FResponseIndex := AResponseIndex;
  FDlgName := FDlg.Name;
  FResponse := FDlg.Responces [FResponseIndex];
  if rfReply in FResponse.Flags then
    SetText (Game.TLK.Text [FResponse.TextIndex])
  else
    SetText ('<NO TEXT>');
  FNode := FOwner.tvDialog.Items.AddChildObject (AParent, FText, Self);
  FNode.HasChildren := not (rfEnd in FResponse.Flags);
end;

procedure TResponceNode.Expand;
var
  DestDlg: TDlg;
begin
  BeginExpand;
  try
    DestDlg := Game.GetFileByName (FResponse.Dlg, ftDLG) as TDlg;
    if DestDlg = nil then begin
      MessageDlg (Format ('Cannot find dialog %s', [FResponse.Dlg]),
          mtError, [mbOk], 0);
      FNode.HasChildren := false;
      Exit;
    end;
    TPhraseNode.Create (FOwner, DestDlg, FNode, FResponse.DlgPhrase);
  finally
    EndExpand;
  end;
end;

procedure TResponceNode.Select;
var
  TextCaption: string;
begin
  with FOwner do begin
    if not (rfReply in FResponse.Flags) then begin
      SetGrpMemo (MemText, grpText, '<NO TEXT>');
      TextCaption := 'Text';
    end else begin
      SetGrpMemo (MemText, grpText, Game.TLK.Text [FResponse.TextIndex]);
      TextCaption := Format ('Text (index %d)', [FResponse.TextIndex]);
    end;
    grpText.Caption := Format ('%s: %s response %d', [TextCaption, FDlgName, FResponseIndex]);
    if (rfCond in FResponse.Flags) and (FResponse.Cond <> '') then begin
      SetGrpMemo (reCond, grpCond, FResponse.Cond);
      FormatScript (reCond);
      if grpCond.Top < grpText.Top then grpCond.Top := grpText.Top + 1;
    end
    else
      grpCond.Visible := false;
    if (rfAction in FResponse.Flags) and (FResponse.Action <> '') then begin
      SetGrpMemo (reAction, grpAction, FResponse.Action);
      FormatScript (reAction);
      if grpAction.Top < grpCond.Top then grpAction.Top := grpCond.Top + 1;
    end
    else
      grpAction.Visible := false;
    if rfJournal in FResponse.Flags then begin
      SetGrpMemo (memJournal, grpJournal, Game.TLK.Text [FResponse.JournalTextIndex]);
      grpJournal.Caption := Format ('Journal (index %d)', [FResponse.JournalTextIndex]);
      if grpJournal.Top < grpAction.Top then grpJournal.Top := grpAction.Top + 1;
    end
    else
      grpJournal.Visible := false;
  end;
end;

{ TDlgFrame }

procedure TDlgFrame.ViewFile (AFile: TGameFile);
var
  i: integer;
  PhraseNode: TPhraseNode;
begin
  FDlg := AFile as TDlg;
  FDlg.Lock;
  Screen.Cursor := crHourglass;
  if (MainForm.tvDialogHeight <> -1) and (MainForm.tvDialogHeight <> tvDialog.Height) then
    tvDialog.Height := MainForm.tvDialogHeight;
  tvDialog.Items.BeginUpdate;
  try
    for i := 0 to Length (FDlg.Phrases)-1 do
      if FDlg.Phrases [i].Cond <> '' then begin
        PhraseNode := TPhraseNode.Create (Self, FDlg, nil, i);
        PhraseNode.TopLevel := true;
      end;
  finally
    tvDialog.Items.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TDlgFrame.CloseFile;
var
  i: integer;
begin
  FClosing := true;
  with tvDialog.Items do begin
    BeginUpdate;
    try
      for i := 0 to Count-1 do
        if Item [i].Data <> nil then
          TObject (Item [i].Data).Free;
      Clear;
    finally
      EndUpdate;
    end;
  end;
  FDlg.Unlock;
  FClosing := false;
  grpText.Visible := false;
  grpCond.Visible := false;
  grpAction.Visible := false;
  grpJournal.Visible := false;
  MainForm.tvDialogHeight := tvDialog.Height;
end;

procedure TDlgFrame.tvDialogExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  DlgNode: TDlgNode;
begin
  DlgNode := TObject (Node.Data) as TDlgNode;
  if (DlgNode <> nil) and not DlgNode.Expanded then
    DlgNode.Expand;
end;

procedure TDlgFrame.tvDialogChange (Sender: TObject; Node: TTreeNode);
var
  DlgNode: TDlgNode;
begin
  if FClosing then Exit;
  DlgNode := TObject (Node.Data) as TDlgNode;
  if DlgNode <> nil then DlgNode.Select;
end;

procedure TDlgFrame.FrameResize (Sender: TObject);
begin
  if grpText.Visible then
    SetGrpMemo (memText, grpText, memText.Lines.Text);
  if grpCond.Visible then
    SetGrpMemo (reCond, grpCond, reCond.Lines.Text);
  if grpAction.Visible then
    SetGrpMemo (reAction, grpAction, reAction.Lines.Text);
  if grpJournal.Visible then
    SetGrpMemo (memJournal, grpJournal, memJournal.Lines.Text);
end;

procedure TDlgFrame.tvDialogKeyDown (Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_MULTIPLY then Key := 0;
end;

procedure TDlgFrame.reCondMouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LinkClicked := false;
end;

procedure TDlgFrame.reCondURLClick (Sender: TObject; const URLText: String;
  Button: TMouseButton);
begin
  LinkClicked := true;
  LinkText := URLText;
end;

procedure TDlgFrame.reCondMouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if LinkClicked then
    MainForm.BrowseToLink (LinkText);
end;

{ TDlgFrameProxy }

constructor TDlgFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TDlgFrame;
end;

procedure TDlgFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TDlgFrame).ViewFile (AFile);
end;

procedure TDlgFrameProxy.CloseFile;
begin
  if FFrame <> nil then
    (FFrame as TDlgFrame).CloseFile;
end;

// search

type
  TSearchDialog = class
  public
    Dlg: TDlg;
    SearchedPhrases, SearchedResponses: TBits;
    constructor Create (ADlg: TDlg);
    destructor Destroy; override;
  end;

  TDlgSearchStackElemType = (etPhrase, etResponse);
  TDlgSearchStackElem = class
    SDlg: TSearchDialog;
    Index: integer;
    CurChild: integer;
    ElemType: TDlgSearchStackElemType;
  end;

  TDlgSearchUserData = class
  private
    SearchStack: TList;
    FDlg: TSearchDialog;
    procedure PushElem (ADlg: TSearchDialog; AIndex: integer; AType: TDlgSearchStackElemType);
  public
    CurTopPhrase: integer;
    ChildDialogs: TList;
    constructor Create (ADlg: TDlg);
    destructor Destroy; override;
    function Top: TDlgSearchStackElem;
    function Empty: boolean;
    procedure PushPhrase (ADlg: TSearchDialog; APhrase: integer);
    procedure PushResponse (ADlg: TSearchDialog; AResponse: integer);
    procedure Drop;
    function CanSearchResponse: boolean;
    function GetDialog (const Name: string): TSearchDialog;
  end;

constructor TSearchDialog.Create (ADlg: TDlg);
begin
  Dlg := ADlg;
  Dlg.Lock;
  SearchedPhrases := TBits.Create;
  SearchedPhrases.Size := Length (ADlg.Phrases);
  SearchedResponses := TBits.Create;
  SearchedResponses.Size := Length (ADlg.Responces);
end;

destructor TSearchDialog.Destroy;
begin
  SearchedPhrases.Free;
  SearchedResponses.Free;
  Dlg.Unlock;
  inherited Destroy;
end;

constructor TDlgSearchUserData.Create (ADlg: TDlg);
begin
  SearchStack := TList.Create;
  ChildDialogs := TList.Create;
  FDlg := TSearchDialog.Create (ADlg);
  ChildDialogs.Add (FDlg);
  CurTopPhrase := 0;
end;

destructor TDlgSearchUserData.Destroy;
begin
  DestroyList (SearchStack);
  DestroyList (ChildDialogs);
  inherited Destroy;
end;

function TDlgSearchUserData.Top: TDlgSearchStackElem;
begin
  Result := TDlgSearchStackElem (SearchStack.Last);
end;

function TDlgSearchUserData.Empty: boolean;
begin
  Result := (SearchStack.Count = 0);
end;

procedure TDlgSearchUserData.Drop;
begin
  if SearchStack.Count = 0 then
    raise Exception.Create ('Attempt to drop from an empty stack');
  //TraceFmt ('drop (stack count %d)', [SearchStack.Count]);
  TObject (SearchStack.Last).Free;
  SearchStack.Delete (SearchStack.Count-1);
end;

procedure TDlgSearchUserData.PushElem (ADlg: TSearchDialog; AIndex: integer;
  AType: TDlgSearchStackElemType);
var
  Elem: TDlgSearchStackElem;
begin
  Elem := TDlgSearchStackElem.Create;
  Elem.SDlg := ADlg;
  Elem.Index := AIndex;
  Elem.CurChild := -1;
  Elem.ElemType := AType;
  SearchStack.Add (Elem);
end;

procedure TDlgSearchUserData.PushPhrase (ADlg: TSearchDialog; APhrase: integer);
begin
  PushElem (ADlg, APhrase, etPhrase);
  //TraceFmt ('pushing phrase %s.%d (stack count %d) %s', [ADlg.Name, APhrase, SearchStack.Count, ADlg.Phrases [APhrase].Text]);
  ADlg.SearchedPhrases [APhrase] := true;
end;

procedure TDlgSearchUserData.PushResponse (ADlg: TSearchDialog; AResponse: integer);
begin
  PushElem (ADlg, AResponse, etResponse);
  //TraceFmt ('pushing response %s.%d (stack count %d) %s', [ADlg.Name, AResponse, SearchStack.Count, ADlg.Responces [AResponse].Text]);
  ADlg.SearchedResponses [AResponse] := true;
end;

function TDlgSearchUserData.CanSearchResponse: boolean;
begin
  with Top do
    if (CurChild >= SDlg.Dlg.Phrases [Index].ResponceCount) then
      Result := false
    else if SDlg.SearchedResponses [SDlg.Dlg.Phrases [Index].FirstResponce + CurChild] then
      Result := false
    else
      Result := true;
end;

function TDlgSearchUserData.GetDialog (const Name: string): TSearchDialog;
var
  Dlg: TDlg;
  i: integer;
begin
  if Name = '' then Result := FDlg
  else begin
    for i := 0 to ChildDialogs.Count-1 do
      if SameText (TSearchDialog (ChildDialogs [i]).Dlg.Name, Name) then begin
        Result := TSearchDialog (ChildDialogs [i]);
        Exit;
      end;
    Dlg := Game.GetFileByName (Name, ftDLG) as TDlg;
    Result := TSearchDialog.Create (Dlg);
    ChildDialogs.Add (Result);
  end;
end;

// TDlgFrameProxy search code

function TDlgFrameProxy.CanSearch: InfMain.TSearchTypes;
begin
  Result := [stCode];
end;

function TDlgFrameProxy.DoSearch (AFile: TGameFile; SearchPos: TSearchPos): boolean;
begin
  if SearchPos.SearchType = stCode then
    Result := SearchForCode (AFile, SearchPos)
  else
    raise Exception.Create ('Unsupported search type');
end;

function TDlgFrameProxy.SearchForCode (AFile: TGameFile; SearchPos: TSearchPos): boolean;
var
  UData: TDlgSearchUserData;
  ADlg: TDlg;
  ChildDlg: TSearchDialog;
  Response, Phrase: integer;
  UpStr: string;
begin
  ADlg := AFile as TDlg;
  UData := SearchPos.UserData as TDlgSearchUserData;
  UpStr := UpperCase (SearchPos.Str);
  if UData = nil then begin
    UData := TDlgSearchUserData.Create (ADlg);
    SearchPos.UserData := UData;
  end;
  while true do begin
    if not UData.Empty then
      with UData.Top do begin
        if ElemType = etPhrase then begin
          Inc (CurChild);
          if not UData.CanSearchResponse then UData.Drop
          else begin
            // push and search response
            Response := SDlg.Dlg.Phrases [Index].FirstResponce + CurChild;
            UData.PushResponse (SDlg, Response);
            if (Pos (UpStr, UpperCase (SDlg.Dlg.Responces [Response].Cond)) <> 0) or
                (Pos (UpStr, UpperCase (SDlg.Dlg.Responces [Response].Action)) <> 0)
            then begin
              Result := true;
              Exit;
            end;
          end;
        end
        else if ElemType = etResponse then begin
          if (CurChild = 0) or (rfEnd in SDlg.Dlg.Responces [Index].Flags) then UData.Drop
          else begin
            Inc (CurChild);
            Phrase := SDlg.Dlg.Responces [Index].DlgPhrase;
            ChildDlg := UData.GetDialog (SDlg.Dlg.Responces [Index].Dlg);
            if (Phrase < 0) or (Phrase >= Length (ChildDlg.Dlg.Phrases)) or
                ChildDlg.SearchedPhrases [Phrase]
            then
              UData.Drop
            else begin
              // push and search phrase
              UData.PushPhrase (ChildDlg, Phrase);
              if Pos (UpStr, UpperCase (ChildDlg.Dlg.Phrases [Phrase].Cond)) <> 0 then begin
                Result := true;
                Exit;
              end;
            end;
          end;
        end;
      end
    else begin // UData.Empty
      while UData.CurTopPhrase < Length (ADlg.Phrases) do begin
        if not UData.FDlg.SearchedPhrases [UData.CurTopPhrase] and
            (ADlg.Phrases [UData.CurTopPhrase].Cond <> '')
        then begin
          UData.PushPhrase (UData.FDlg, UData.CurTopPhrase);
          if Pos (UpStr, UpperCase (ADlg.Phrases [UData.CurTopPhrase].Cond)) <> 0 then begin
            Result := true;
            Inc (UData.CurTopPhrase);
            Exit;
          end;
          Break;
        end;
        Inc (UData.CurTopPhrase);
      end;
    end;
    if UData.Empty and (UData.CurTopPhrase = Length (ADlg.Phrases)) then begin
      Result := false;
      SearchPos.UserData := nil;
      Exit;
    end;
  end;
end;

procedure TDlgFrameProxy.LocatePos (SearchPos: TSearchPos);
var
  UData: TDlgSearchUserData;
  i: integer;
  CurNode: TTreeNode;
  CurElem: TDlgSearchStackElem;
  ADlg: TDlg;
begin
  if SearchPos.UserData = nil then Exit;
  UData := SearchPos.UserData as TDlgSearchUserData;
  if UData.Empty then Exit;
  ADlg := (FFrame as TDlgFrame).FDlg;
  // find the top phrase
  CurNode := (FFrame as TDlgFrame).tvDialog.Items [0];
  CurElem := TDlgSearchStackElem (UData.SearchStack [0]);
  while CurNode <> nil do begin
    if TPhraseNode (CurNode.Data).FPhrase = ADlg.Phrases [CurElem.Index] then
      Break;
    CurNode := CurNode.GetNextSibling;
  end;
  if CurNode = nil then Exit;
  // dump stack
  {
  for i := 0 to UData.SearchStack.Count-1 do begin
    CurElem := TDlgSearchStackElem (UData.SearchStack [i]);
    if CurElem.ElemType = etPhrase then
      Trace (ADlg.Phrases [CurElem.Index].Text)
    else
      Trace (ADlg.Responces [CurElem.Index].Text);
  end;
  }
  for i := 0 to UData.SearchStack.Count-2 do begin
    CurNode.Expand (false);
    CurElem := TDlgSearchStackElem (UData.SearchStack [i]);
    //TraceFmt ('%d', [CurElem.CurChild]);
    CurNode := CurNode.Item [CurElem.CurChild];
  end;
  (FFrame as TDlgFrame).tvDialog.Selected := CurNode;
end;

end.

