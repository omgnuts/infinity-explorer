{ $Header: /cvsroot/InfExp/InfExp/src/FrameMOS.pas,v 1.6 2000/09/01 19:04:36 yole Exp $
  Infinity Engine MOS viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit FrameMOS;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Infinity, InfMain, ExtCtrls;

type
  TMOSFrame = class (TFrame)
    LblSize: TLabel;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    lblCursorAt: TLabel;
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FImage: TMOSImage;
    FBitmaps: array of array of TBitmap;
    procedure PaintImage (Canvas: TCanvas);
  public
    procedure ViewFile (AFile: TGameFile);
    procedure CloseFile;
  end;

  TMOSFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure CloseFile; override;
    function  GetExportFilter: string; override;
    procedure ExportFile (const FName: string; FilterIndex: integer); override;
  end;

implementation

uses JPEG, InfGraphics;

{$R *.DFM}

{ TMOSFrame }

procedure TMOSFrame.ViewFile (AFile: TGameFile);
var
  Row, Col: integer;
begin
  FImage := AFile as TMOSImage;
  LblSize.Caption := Format ('Size %d X %d', [FImage.Header.Width, FImage.Header.Height]);
  Panel1.Width := FImage.Header.Width+2;
  Panel1.Height := FImage.Header.Height+2;
  with FImage do begin
    SetLength (FBitmaps, Header.Rows, Header.Cols);
    for Row := 0 to Header.Rows-1 do
      for Col := 0 to Header.Cols-1 do begin
        FBitmaps [Row, Col] := TBitmap.Create;
        GetImageBlockBitmap (Blocks [Row, Col], FBitmaps [Row, Col]);
      end;
  end;
  PaintBox1.Invalidate;
end;

procedure TMOSFrame.CloseFile;
var
  X, Y: integer;
begin
  for X := 0 to Length (FBitmaps)-1 do
    for Y := 0 to Length (FBitmaps [X])-1 do
      FBitmaps [X, Y].Free;
  SetLength (FBitmaps, 0, 0);
  FImage := nil;
end;

procedure TMOSFrame.PaintBox1Paint (Sender: TObject);
begin
  PaintImage (PaintBox1.Canvas);
end;

procedure TMOSFrame.PaintImage (Canvas: TCanvas);
var
  Row, Col: integer;
  RC, IntersectRC: TRect;
begin
  if FImage = nil then Exit;
  with FImage do
    for Row := 0 to Header.Rows-1 do
      for Col := 0 to Header.Cols-1 do begin
        RC := Bounds (Col*Header.BlkSize, Row*Header.BlkSize,
                      Blocks [Row,Col].Width, Blocks [Row,Col].Height);
        if IntersectRect (IntersectRC, RC, Canvas.ClipRect) then
          Canvas.Draw (RC.Left, RC.Top, FBitmaps [Row,Col]);
      end;
end;

{ TMOSFrameProxy }

constructor TMOSFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TMOSFrame;
end;

procedure TMOSFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TMOSFrame).ViewFile (AFile);
end;

procedure TMOSFrameProxy.CloseFile;
begin
  (FFrame as TMOSFrame).CloseFile;
end;

function TMOSFrameProxy.GetExportFilter: string;
begin
  Result := 'BMP files (*.BMP)|*.BMP|JPEG files (*.JPG)|*.JPG';
end;

procedure TMOSFrameProxy.ExportFile (const FName: string; FilterIndex: integer);
var
  Filename: string;
  Bitmap: TBitmap;
  JPG: TJPEGImage;
const
  FilterExt: array [1..2] of string = ('.bmp', '.jpg');
begin
  if ExtractFileExt (FName) = '' then
    Filename := FName + FilterExt [FilterIndex]
  else
    Filename := FName;
  with FFrame as TMOSFrame do begin
    Bitmap := TBitmap.Create;
    try
      with Bitmap do begin
        PixelFormat := pf24Bit;
        Width := FImage.Header.Width;
        Height := FImage.Header.Height;
        PaintImage (Canvas);
      end;
      case FilterIndex of
        1: Bitmap.SaveToFile (Filename);
        2: begin
          JPG := TJPEGImage.Create;
          try
            JPG.Assign (Bitmap);
            JPG.SaveToFile (Filename);
          finally
            JPG.Free;
          end;
        end;
      end;
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TMOSFrame.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  lblCursorAt.Caption := Format ('Cursor at (%d,%d)', [X, Y]);
end;

procedure TMOSFrame.FrameMouseMove (Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lblCursorAt.Caption := '';
end;

end.
