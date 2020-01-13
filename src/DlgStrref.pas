{ $Header: /cvsroot/InfExp/InfExp/src/DlgStrref.pas,v 1.2 2000/11/01 19:00:14 yole Exp $
  Infinity Explorer: StrRef lookup
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit DlgStrref;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Infinity, Hyperlink;

type
  TStrrefForm = class (TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EdtDecimal: TEdit;
    Label2: TLabel;
    EdtHex: TEdit;
    GroupBox2: TGroupBox;
    BtnLookup: TButton;
    MemText: TMemo;
    BtnCancel: TButton;
    Label3: TLabel;
    EdtSound: THyperlinkEdit;
    procedure BtnLookupClick(Sender: TObject);
    procedure EdtDecimalKeyPress(Sender: TObject; var Key: Char);
    procedure EdtHexKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure EdtDecimalChange(Sender: TObject);
    procedure EdtHexChange(Sender: TObject);
    procedure MemTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FInChange: boolean;
  public
    function LookupStrref (StrRef: integer): boolean;
  end;

implementation

{$R *.DFM}

uses RxStrUtils;

{ TStrrefForm}

procedure TStrrefForm.FormCreate (Sender: TObject);
begin
  FInChange := false;
end;

procedure TStrrefForm.BtnLookupClick (Sender: TObject);
begin
  LookupStrref (StrToInt (EdtDecimal.Text));
end;

function TStrrefForm.LookupStrref (StrRef: integer): boolean;
begin
  if Game.TLK.ValidID (StrRef) then begin
    EdtDecimal.Text := IntToStr (StrRef);
    if Game.TLK.Text [StrRef] = '' then
      MemText.Text := '<empty>'
    else
      MemText.Text := AdjustLineBreaks (Game.TLK.Text [StrRef]);
    EdtSound.Text := Game.TLK.Sound [StrRef];
    Result := true;
  end
  else begin
    MessageDlg (Format ('Invalid StrRef %d', [StrRef]), mtError, [mbOk], 0);
    EdtDecimal.Text := '';
    Result := false;
  end;
end;

procedure TStrrefForm.EdtDecimalKeyPress (Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then Key := #0;
end;

procedure TStrrefForm.EdtHexKeyPress (Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', 'a'..'f', 'A'..'F']) then Key := #0;
end;

procedure TStrrefForm.EdtDecimalChange (Sender: TObject);
begin
  if FInChange then Exit;
  FInChange := true;
  try
    if EdtDecimal.Text <> '' then
      EdtHex.Text := IntToHex (StrToInt (EdtDecimal.Text), 0)
    else
      EdtHex.Text := '';
  finally
    FInChange := false;
  end;
end;

procedure TStrrefForm.EdtHexChange (Sender: TObject);
begin
  if FInChange then Exit;
  FInChange := true;
  try
    if EdtHex.Text <> '' then
      EdtDecimal.Text := IntToStr (Hex2Dec (EdtHex.Text))
    else
      EdtDecimal.Text := '';
  finally
    FInChange := false;
  end;
end;

procedure TStrrefForm.MemTextKeyDown (Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

end.
