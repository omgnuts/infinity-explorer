{ $Header: /cvsroot/InfExp/InfExp/src/FrameCHUIPanel.pas,v 1.2 2000/11/01 19:00:14 yole Exp $
  Infinity Engine ChUI panel viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit FrameChUIPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  InfMain, Infinity, InfStruc, StdCtrls, Grids, Hyperlink;

type
  TChUIPanelFrame = class (TFrame)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtLeft: TEdit;
    Label2: TLabel;
    edtTop: TEdit;
    Label3: TLabel;
    edtWidth: TEdit;
    edtHeight: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtBackground: THyperlinkEdit;
    Label6: TLabel;
    ControlGrid: THyperlinkGrid;
    procedure ControlGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure ControlGridJump(Sender: TObject; ACol, ARow: Integer);
  private
    FPanel: TChUIPanel;
  public
    procedure SetPanel (const Panel: TChUIPanel);
  end;

  TChUIFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure ViewChUIPanel (const Panel: TChUIPanel);
  end;

implementation

{$R *.DFM}

{ TChUIPanelFrame }

procedure TChUIPanelFrame.SetPanel (const Panel: TChUIPanel);
var
  i: integer;
  CurCol, CurRow: integer;

  procedure SetCell (const S: string);
  begin
    ControlGrid.Cells [CurCol, CurRow] := S;
    Inc (CurCol);
  end;

  procedure NextRow;
  begin
    Inc (CurRow);
    CurCol := 0;
  end;

const
  ControlTypeNames: array [TChUIControlType] of string = ('Button', '1', 'Slider',
      'Text edit', '4', 'Text area', 'Label', 'Scroll bar');
begin
  FPanel := Panel;
  with Panel do begin
    with Hdr do begin
      edtLeft.Text := IntToStr (X);
      edtTop.Text := IntToStr (Y);
      edtWidth.Text := IntToStr (Width);
      edtHeight.Text := IntToStr (Height);
      edtBackground.ResRef := BackgroundMOS;
    end;
    CurCol := 0;
    CurRow := 0;
    SetCell ('ID');
    SetCell ('Type');
    SetCell ('Left');
    SetCell ('Top');
    SetCell ('Width');
    SetCell ('Height');
    SetCell ('Text');
    SetCell ('Picture');
    if Length (Controls) = 0 then begin
      ControlGrid.RowCount := 2;
      ControlGrid.Cells [0, 1] := 'Empty';
      for i := 1 to ControlGrid.ColCount-1 do
        ControlGrid.Cells [i, 1] := '';
    end
    else begin
      ControlGrid.RowCount := Length (Controls)+1;
      for i := 0 to Length (Controls)-1 do begin
        NextRow;
        with Controls [i] do begin
          SetCell (IntToHex (ControlID, 2) + 'h');
          SetCell (ControlTypeNames [ControlType]);
          SetCell (IntToStr (X));
          SetCell (IntToStr (Y));
          SetCell (IntToStr (Width));
          SetCell (IntToStr (Height));
          // Text
          if (ControlType = ctStatic) and (Text.TextStrref > 0) then begin
            if Game.TLK.ValidID (Text.TextStrref) then
              SetCell (Game.TLK.Text [Text.TextStrref])
            else
              SetCell (Format ('? <%x>', [Text.TextStrref]));
          end
          else
            SetCell ('');
          // Picture
          case ControlType of
            ctButton: SetCell (PChar8ToStr (Btn.BAMName));
            ctSlider: SetCell (PChar8ToStr (Slider.BAMKnob));
            ctEdit: SetCell (PChar8ToStr (TextEdit.BAMFont));
            ctTextArea: SetCell (PChar8ToStr (TextArea.BAMFont1));
            ctStatic: SetCell (PChar8ToStr (Text.BAMFont));
            ctScrollBar: SetCell (PChar8ToStr (ScrollBar.BAMFile));
            else SetCell ('');
          end;
        end;
      end;
    end;
  end;
end;

procedure TChUIPanelFrame.ControlGridCanJump (Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := (ACol = 7) and (ARow > 0) and (ControlGrid.Cells [ACol, ARow] <> '');
end;

procedure TChUIPanelFrame.ControlGridJump (Sender: TObject; ACol,
  ARow: Integer);
var
  Seq, Frame: word;
begin
  with FPanel.Controls [ARow-1] do
    case ControlType of
      ctButton: begin
        Seq := Btn.BAMSeq;
        Frame := Btn.UpFrame;
      end;
      else begin
        Seq := 0;
        Frame := 0;
      end;
    end;
  MainForm.BrowseToFileEx (ControlGrid.Cells [ACol, ARow], ftBAM,
      Pointer (Seq shl 16 or Frame));
end;

{ TChUIFrameProxy }

constructor TChUIFrameProxy.Create (AOwner: TComponent);
begin
  inherited;
  FFrameClass := TChUIPanelFrame;
end;

procedure TChUIFrameProxy.DoViewFile (AFile: TGameFile);
begin
  // because a TChUIPanel is not a TGameFile, DoViewFile is just a do-nothing stub.
end;

procedure TChUIFrameProxy.ViewChUIPanel (const Panel: TChUIPanel);
begin
  if FFrame = nil then FFrame := TChUIPanelFrame.Create (FOwner);
  TChUIPanelFrame (FFrame).SetPanel (Panel);
end;

end.

