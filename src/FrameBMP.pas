{ $Header: /cvsroot/InfExp/InfExp/src/FrameBMP.pas,v 1.2 2000/02/07 15:15:58 yole Exp $
  Infinity Engine BMP viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit FrameBMP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, ExtCtrls;

type
  TBMPFrame = class (TFrame)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    procedure PaintBox1Paint(Sender: TObject);
  private
    FBmp: TBmpImage;
    FRect: TRect;
  public
    procedure ViewFile (AFile: TGameFile);
    procedure CloseFile;
  end;

  TBMPFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure CloseFile; override;
    function  GetExportFilter: string; override;
    procedure ExportFile (const FName: string; FilterIndex: integer); override;
  end;

implementation

{$R *.DFM}

// -- TBMPFrame --------------------------------------------------------------

procedure TBMPFrame.ViewFile (AFile: TGameFile);
begin
  FBmp := AFile as TBmpImage;
  with FBmp.Bitmap do begin
    Panel1.Width := Width+2;
    Panel1.Height := Height+2;
    FRect := Bounds (0, 0, Width, Height);
  end;
  PaintBox1.Invalidate;
end;

procedure TBMPFrame.CloseFile;
begin
  FBmp := nil;
end;

procedure TBMPFrame.PaintBox1Paint (Sender: TObject);
begin
  if FBmp <> nil then
    PaintBox1.Canvas.BrushCopy (FRect, FBmp.Bitmap, FRect, FBmp.Bitmap.TransparentColor);
end;

// -- TBMPFrameProxy ---------------------------------------------------------

constructor TBMPFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TBMPFrame;
end;

procedure TBMPFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TBMPFrame).ViewFile (AFile);
end;

procedure TBMPFrameProxy.CloseFile;
begin
  (FFrame as TBMPFrame).CloseFile;
end;

function TBMPFrameProxy.GetExportFilter: string;
begin
  Result := 'BMP files (*.BMP)|*.BMP';
end;

procedure TBMPFrameProxy.ExportFile (const FName: string;
  FilterIndex: integer);
var
  Filename: string;
begin
  if ExtractFileExt (FName) = '' then
    Filename := FName + '.bmp'
  else
    Filename := FName;
  (FFrame as TBMPFrame).FBmp.Bitmap.SaveToFile (Filename);
end;

end.
