{ $Header: /cvsroot/InfExp/InfExp/src/Hyperlink.pas,v 1.3 2000/11/01 19:00:14 yole Exp $
  Infinity Explorer hyperlink support components
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit Hyperlink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, InfStruc;

type
  TCanJumpEvent = procedure (Sender: TObject; ACol, ARow: integer;
      var Result: boolean) of object;
  TGridJumpEvent = procedure (Sender: TObject; ACol, ARow: integer) of object;

  THyperlinkGrid = class (TStringGrid)
  private
    FOnCanJump: TCanJumpEvent;
    FOnJump: TGridJumpEvent;
  protected
    function CanJump (ACol, ARow: integer): boolean;
    procedure DrawCell (ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure MouseMove (Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp (Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
  public
    { Public declarations }
  published
    property OnCanJump: TCanJumpEvent read FOnCanJump write FOnCanJump;
    property OnJump: TGridJumpEvent read FOnJump write FOnJump;
  end;

  TJumpEvent = procedure (Sender: TObject; const Link: string;
      FileType: TFileType) of object;

  THyperlinkJumper = class (TComponent)
  private
    FOnJump: TJumpEvent;
  public
    procedure DoJump (Sender: TObject; const Link: string; FileType: TFileType);
  published
    property OnJump: TJumpEvent read FOnJump write FOnJump;
  end;

  THyperlinkEdit = class (TEdit)
  private
    FHyperlinkJumper: THyperlinkJumper;
    FFileType: TFileType;
    FOnJump: TNotifyEvent;
    FIsHyperlink: boolean;
    procedure SetText (const S: TCaption);
    procedure SetResRef(const Value: TResRef);
    procedure SetIsHyperlink (Value: boolean);
  protected
    procedure MouseUp (Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
  public
    property ResRef: TResRef write SetResRef;
  published
    constructor Create (AOwner: TComponent); override;
    property HyperlinkJumper: THyperlinkJumper read FHyperlinkJumper write FHyperlinkJumper;
    property IsHyperlink: boolean read FIsHyperlink write SetIsHyperlink default true;
    property FileType: TFileType read FFileType write FFileType;
    property Text write SetText;
    property ReadOnly default true;
    property Color default clBtnFace;
    property OnJump: TNotifyEvent read FOnJump write FOnJump;
  end;

procedure Register;

implementation

uses VCLUtils;

{ THyperlinkGrid }

function THyperlinkGrid.CanJump (ACol, ARow: integer): boolean;
begin
  if Assigned (FOnCanJump) then
    FOnCanJump (Self, ACol, ARow, Result)
  else
    Result := false;
end;

procedure THyperlinkGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
begin
  if CanJump (ACol, ARow) then begin
    with Canvas.Font do begin
      if (gdSelected in AState) and not (gdFocused in AState) then Color := clWhite
      else Color := clBlue;
      Style := [fsUnderline];
    end;
    DrawCellText (Self, ACol, ARow, Cells [ACol, ARow], ARect,
        taLeftJustify, vaTopJustify);
  end
  else
    inherited DrawCell (ACol, ARow, ARect, AState);
end;

procedure THyperlinkGrid.MouseMove (Shift: TShiftState; X, Y: integer);
var
  ACol, ARow: integer;
begin
  MouseToCell (X, Y, ACol, ARow);
  if CanJump (ACol, ARow) then
    Cursor := crHandPoint
  else
    Cursor := crDefault;
  inherited;
end;

procedure THyperlinkGrid.MouseUp (Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  ACol, ARow: integer;
begin
  inherited;
  if Button = mbLeft then begin
    MouseToCell (X, Y, ACol, ARow);
    if CanJump (ACol, ARow) and Assigned (FOnJump) then
      FOnJump (Self, ACol, ARow);
  end;
end;

{ THyperlinkJumper }

procedure THyperlinkJumper.DoJump (Sender: TObject; const Link: string;
  FileType: TFileType);
begin
  if Assigned (FOnJump) then
    FOnJump (Sender, Link, FileType);
end;

{ THyperlinkEdit }

constructor THyperlinkEdit.Create (AOwner: TComponent);
begin
  inherited;
  ReadOnly := true;
  Color := clBtnFace;
  FIsHyperlink := true;
end;

procedure THyperlinkEdit.SetText (const S: TCaption);
begin
  TEdit (Self).Text := S;
  if IsHyperlink and (Trim (S) <> '') then begin
    Font.Color := clBlue;
    Font.Style := [fsUnderline];
    Cursor := crHandPoint;
  end
  else begin
    Font.Color := clWindowText;
    Font.Style := [];
    Cursor := crDefault;
  end;
end;

procedure THyperlinkEdit.SetResRef (const Value: TResRef);
var
  Buf: array [0..8] of char;
begin
  StrLCopy (Buf, Value, 8);
  Buf [8] := #0;
  Text := Buf;
end;

procedure THyperlinkEdit.SetIsHyperlink (Value: boolean);
begin
  if FIsHyperlink <> Value then begin
    FIsHyperlink := Value;
    SetText (Text);
  end;
end;

procedure THyperlinkEdit.MouseUp (Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  if (Button = mbLeft) and (Trim (Text) <> '') and IsHyperlink then begin
    if Assigned (FOnJump) then
      FOnJump (Self)
    else if Assigned (FHyperlinkJumper) then
      FHyperlinkJumper.DoJump (Self, Text, FileType);
  end;
end;

procedure Register;
begin
  RegisterComponents('InfExp', [THyperlinkGrid, THyperlinkJumper, THyperlinkEdit]);
end;

end.

