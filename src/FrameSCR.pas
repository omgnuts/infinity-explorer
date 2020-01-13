{ $Header: /cvsroot/InfExp/InfExp/src/FrameSCR.pas,v 1.10 2000/11/01 19:00:14 yole Exp $
  Infinity Engine script viewer frame
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit FrameSCR;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SCDecomp, Infinity, InfMain, InfStruc, RxRichEd;

type
  TTextFrame = class;

  TRichEditHighlighter = class
  private
    FRichEdit: TRxRichEdit;
    FLineStart: integer;
    FStartPosDelta: integer;
  protected
    FCurLine: integer;
    procedure HighlightLine (const S: string); virtual; abstract;
    procedure AddHyperlink (StartPos, EndPos: integer);
  public
    procedure Highlight (RE: TRxRichEdit);
  end;

  TScriptHighlighter = class (TRichEditHighlighter)
  protected
    procedure HighlightLine (const S: string); override;
  end;

  TWordHighlighter = class (TRichEditHighlighter)
  protected
    FCurWord: integer;
    procedure HighlightLine (const S: string); override;
    function HighlightWord (const S: string): boolean; virtual; abstract;
  end;

  T2DAHighlighter = class (TWordHighlighter)
  protected
    function HighlightWord (const S: string): boolean; override;
  end;

  TScriptFrameProxy = class (TFrameProxy)
  private
    FHighlighter: TScriptHighlighter;
    FFile: TScriptFile;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoViewFile (AFile: TGameFile); override;
    function  CanSearch: TSearchTypes; override;
    function  DoSearch (AFile: TGameFile; SearchPos: TSearchPos): boolean; override;
    function  GetExportFilter: string; override;
    procedure ExportFile (const FName: string; FilterIndex: integer); override;
  end;

  TGameTextFrameProxy = class (TFrameProxy)
  protected
    FHighlighter: TRichEditHighlighter;
    FWordWrap: boolean;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoViewFile (AFile: TGameFile); override;
  end;

  TIniFrameProxy = class (TGameTextFrameProxy)
  public
    procedure DoViewFile (AFile: TGameFile); override;
  end;

  TIDSFrameProxy = class (TGameTextFrameProxy)
  public
    procedure DoViewFile (AFile: TGameFile); override;
  end;

  T2DAFrameProxy = class (TGameTextFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
  end;

  TTextFrame = class (TFrame)
    reScript: TRxRichEdit;
    procedure reScriptURLClick(Sender: TObject; const URLText: String;
      Button: TMouseButton);
    procedure reScriptMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure reScriptMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameResize(Sender: TObject);
  private
    LinkClicked: boolean;
    LinkText: string;
  end;

procedure FormatScript (RE: TRxRichEdit);

implementation

{$R *.DFM}

{ TRichEditHighlighter }

procedure TRichEditHighlighter.Highlight (RE: TRxRichEdit);
var
  S: string;
  StartPos: integer;
begin
  FRichEdit := RE;
  RE.Lines.BeginUpdate;
  try
    S := RE.Text;
    StartPos := 0;
    FStartPosDelta := 1;
    FLineStart := 1;
    FCurLine := 1;
    while StartPos <= Length (S) do begin
      if S [StartPos] = #10 then begin
        HighlightLine (Copy (S, FLineStart, StartPos-FLineStart-1));
        Inc (FStartPosDelta);
        Inc (FCurLine);
        FLineStart := StartPos+1;
      end;
      Inc (StartPos);
    end;
    if FLineStart < StartPos then
      HighlightLine (Copy (S, FLineStart, StartPos-FLineStart-1));
  finally
    RE.Lines.EndUpdate;
    RE.SelStart := 0;
    RE.SelLength := 0;
  end;
end;

procedure TRichEditHighlighter.AddHyperlink (StartPos, EndPos: integer);
begin
  with FRichEdit do begin
    SelStart := FLineStart+StartPos-FStartPosDelta-1;
    SelLength := EndPos - StartPos + 1;
    SelAttributes.Color := clBlue;
    SelAttributes.Style := [fsUnderline];
    SelAttributes.Link := true;
  end;
end;

{ TScriptHighlighter }

procedure TScriptHighlighter.HighlightLine (const S: string);
var
  StartPos, EndPos: integer;
  LinkText: string;

  function IsNumber (const S: string): boolean;
  var
    i, L: integer;
  begin
    Result := false;
    L := Length (S);
    for i := 1 to L do
      if (Ord (S [i]) < Ord ('0')) or (Ord (S [i]) > Ord ('9')) then
        Exit;
    Result := true;
  end;

begin
  StartPos := 1;
  while StartPos <= Length (S) do
    if S [StartPos] = '"' then begin
      EndPos := StartPos+1;
      while (EndPos < Length (S)) and (S [EndPos] <> '"') do Inc (EndPos);
      if S [EndPos] <> '"' then Break;
      if (EndPos - StartPos > 1) and (EndPos - StartPos <= 9) then begin
        LinkText := Copy (S, StartPos+1, EndPos-StartPos-1);
        if not IsNumber (LinkText) and (LinkText <> 'GLOBAL') and
            (LinkText <> 'LOCALS') and (LinkText <> 'MYAREA')
        then
          AddHyperlink (StartPos+1, EndPos-1);
      end;
      StartPos := EndPos + 1;
    end
    else if S [StartPos] in ['0'..'9'] then begin
      if (StartPos > 1) and (S [StartPos-1] = '[') then begin
        Inc (StartPos);
        Continue;
      end;
      EndPos := StartPos+1;
      while (EndPos <= Length (S)) and (S [EndPos] in ['0'..'9']) do
        Inc (EndPos);
      if (EndPos-StartPos > 3) and ((EndPos = Length (S)) or (S [EndPos] <> ']')) then
        AddHyperlink (StartPos, EndPos-1);
      StartPos := EndPos;
    end
    else Inc (StartPos);
end;

procedure FormatScript (RE: TRxRichEdit);
begin
  with TScriptHighlighter.Create do
    try
      Highlight (RE);
    finally
      Free;
    end;
end;

{ T2DAHighlighter }

procedure TWordHighlighter.HighlightLine (const S: string);
var
  StartPos, EndPos, Len: integer;
const
  WordDelims: set of char = [' ', #9];
begin
  StartPos := 1;
  FCurWord := 1;
  Len := Length (S);
  while true do begin
    while (StartPos <= Len) and (S [StartPos] in WordDelims) do
      Inc (StartPos);
    if StartPos > Len then
      Break;
    EndPos := StartPos;
    while EndPos < Len do begin
      Inc (EndPos);
      if S [EndPos] in WordDelims then Break;
    end;
    if S [EndPos] in WordDelims then
      Dec (EndPos);
    if HighlightWord (Copy (S, StartPos, EndPos-StartPos+1)) then
      AddHyperlink (StartPos, EndPos);
    StartPos := EndPos+1;
    Inc (FCurWord);
  end;
end;

function T2DAHighlighter.HighlightWord (const S: string): boolean;
begin
  // skip first 3 lines - signature, default value and headings
  if (FCurLine <= 3) or (FCurWord <= 1) then
    Result := false
  else
    case S [1] of
      '0'..'9':
        Result := (Length (S) > 3);
      'a'..'z', 'A'..'Z':
        Result := (Length (S) <= 8);
      else
        Result := false;
      end;
end;

{ TTextFrame }

// If we do browsing directly from OnURLClick, the program will crash when
// trying to handle the OnMouseUp event, because the frame will already be
// destroyed.

procedure TTextFrame.reScriptMouseDown (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LinkClicked := false;
end;

procedure TTextFrame.reScriptURLClick (Sender: TObject;
  const URLText: String; Button: TMouseButton);
begin
  LinkClicked := true;
  LinkText := URLText;
end;

procedure TTextFrame.reScriptMouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if LinkClicked then
    MainForm.BrowseToLink (LinkText);
end;

procedure TTextFrame.FrameResize (Sender: TObject);
begin
  reScript.Invalidate;
end;

{ TScriptFrameProxy }

constructor TScriptFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TTextFrame;
  FHighlighter := TScriptHighlighter.Create;
end;

destructor TScriptFrameProxy.Destroy;
begin
  FHighlighter.Free;
  inherited Destroy;
end;

procedure TScriptFrameProxy.DoViewFile (AFile: TGameFile);
begin
  Screen.Cursor := crHourglass;
  FFile := AFile as TScriptFile;
  (FFrame as TTextFrame).reScript.WordWrap := true;
  (FFrame as TTextFrame).reScript.Lines.BeginUpdate;
  try
    DC.Decompile (FFile, (FFrame as TTextFrame).reScript.Lines);
    FHighlighter.Highlight ((FFrame as TTextFrame).reScript);
  finally
    (FFrame as TTextFrame).reScript.Lines.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

function TScriptFrameProxy.CanSearch: TSearchTypes;
begin
  Result := [stCode];
end;

function TScriptFrameProxy.DoSearch (AFile: TGameFile; SearchPos: TSearchPos): boolean;
var
  Scr: TStringList;
begin
  Result := false;
  if SearchPos.UserData <> nil then Exit;
  Scr := TStringList.Create;
  try
    DC.Decompile (AFile as TScriptFile, Scr);
    if Pos (UpperCase (SearchPos.Str), UpperCase (Scr.Text)) <> 0 then begin
      Result := true;
      SearchPos.UserData := TObject.Create; // just a marker
    end;
  finally
    Scr.Free;
  end;
end;

function TScriptFrameProxy.GetExportFilter: string;
begin
  Result := 'AI script source (*.BAF)|*.BAF';
end;

procedure TScriptFrameProxy.ExportFile (const FName: string; FilterIndex: integer);
var
  FileName: string;
  Strings: TStringList;
begin
  if ExtractFileExt (FName) = '' then
    Filename := FName + '.baf'
  else
    Filename := FName;
  Strings := TStringList.Create;
  try
    DC.Decompile (FFile, Strings, true);
    Strings.SaveToFile (Filename);
  finally
    Strings.Free;
  end;
end;

{ TGameTextFrameProxy }

constructor TGameTextFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TTextFrame;
  FHighlighter := nil;
  FWordWrap := true;
end;

destructor TGameTextFrameProxy.Destroy;
begin
  FHighlighter.Free;
  inherited Destroy;
end;

procedure TGameTextFrameProxy.DoViewFile (AFile: TGameFile);
begin
  with (FFrame as TTextFrame).reScript do begin
    Lines.BeginUpdate;
    try
      WordWrap := FWordWrap;
      Lines.Assign ((AFile as TGameTextFile).Strings);
      if FHighlighter <> nil then
        FHighlighter.Highlight ((FFrame as TTextFrame).reScript);
    finally
      Lines.EndUpdate;
    end;
  end;
end;

{ TIniFrameProxy }

procedure TIniFrameProxy.DoViewFile (AFile: TGameFile);
begin
  with (FFrame as TTextFrame).reScript do begin
    WordWrap := false;
    Lines.Assign ((AFile as TGameTextFile).Strings);
  end;
end;

{ TIDSFrameProxy }

procedure TIDSFrameProxy.DoViewFile (AFile: TGameFile);
begin
  with (FFrame as TTextFrame).reScript do begin
    WordWrap := true;
    Lines.Assign ((AFile as TIDSFile).OrigStrings);
  end;
end;

{ T2DAFrameProxy }

constructor T2DAFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FHighlighter := T2DAHighlighter.Create;
  FWordWrap := false;
end;

end.
