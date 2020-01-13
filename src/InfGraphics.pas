{ $Header: /cvsroot/InfExp/InfExp/src/InfGraphics.pas,v 1.2 2000/11/01 19:00:14 yole Exp $
  Infinity Explorer graphics code and components
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit InfGraphics;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Infinity;

type
  TBAMIcon = class (TImage)
  private
    FBAMId: string;
    FBAMFrame: integer;
    procedure SetBAMId (const S: string);
    procedure SetBAMFrame (AFrame: integer);
    procedure UpdatePicture;
  protected
    { Protected declarations }
  public
    procedure SetSeqFrame (Seq, Frame: integer);
    property BAMFrame: integer read FBAMFrame write SetBAMFrame;
  published
    property BAMId: string read FBAMId write SetBAMId;
  end;

function GetBAMBitmap (AImage: TBAMImage; Frame: integer): TBitmap;
procedure GetImageBlockBitmap (Img: TImageBlock; Bitmap: TBitmap);
  // draws image Img to bitmap Bitmap

procedure Register;

implementation

uses InfStruc;

function GetBAMBitmap (AImage: TBAMImage; Frame: integer): TBitmap;
var
  Bitmap: TBitmap;
  CurPixel, PixelCount: integer;
  PSrc: PChar;
  i, X, Y, W: integer;
  PDest: ^Byte;
  NoRLE: boolean;

  procedure EmitPixel (R, G, B: byte);
  begin
    if X >= W then begin
      Inc (Y);
      PDest := Bitmap.ScanLine [Y];
      X := 0;
    end;
    //if Y >= H then Exit;
    PDest^ := R;  Inc (PDest);
    PDest^ := G;  Inc (PDest);
    PDest^ := B;  Inc (PDest);
    Inc (X);
  end;

begin
  Bitmap := TBitmap.Create;
  with Bitmap do begin
    PixelFormat := pf24Bit;
    Width := AImage.Frames [Frame].Width;
    Height := AImage.Frames [Frame].Height;
    PixelCount := Width * Height;
    CurPixel := 0;
    PSrc := AImage.Frames [Frame].Data;
    NoRLE := AImage.Frames [Frame].NoRLE;
    X := 9999; Y := -1;
    W := Width; // H := Height;
    while CurPixel < PixelCount do begin
      if (PSrc^ = #0) and not NoRLE then begin
        Inc (PSrc);
        for i := 0 to Byte (PSrc^) do
          with AImage.Palette [AImage.TransparentColor] do
            EmitPixel (R, G, B);
        Inc (CurPixel, Byte (PSrc^));
      end
      else
        with AImage.Palette [Byte (PSrc^)] do
          EmitPixel (R, G, B);
      Inc (PSrc);
      Inc (CurPixel);
    end;
    TransparentMode := tmFixed;
    with AImage.Palette [AImage.TransparentColor] do
      TransparentColor := Integer (R) or (Integer (G) shl 8) or (Integer (B) shl 16);
  end;
  Result := Bitmap;
end;

procedure GetImageBlockBitmap (Img: TImageBlock; Bitmap: TBitmap);
var
  Row, Col: integer;
  PSrc: PChar;
  PDest: ^Byte;
  C: byte;
begin
  with Bitmap do begin
    PixelFormat := pf24Bit;
    Width := Img.Width;
    Height := Img.Height;
    PSrc := Img.ImageData;
    for Row := 0 to Height-1 do begin
      PDest := ScanLine [Row];
      for Col := 0 to Width-1 do begin
        C := Byte (PSrc^);
        PDest^ := Img.Palette [C].R;
        Inc (PDest);
        PDest^ := Img.Palette [C].G;
        Inc (PDest);
        PDest^ := Img.Palette [C].B;
        Inc (PDest);
        Inc (PSrc);
      end;
    end;
  end;
end;

{ TBAMIcon }

procedure TBAMIcon.SetBAMId (const S: string);
begin
  FBAMId := S;
  FBAMFrame := 0;
  UpdatePicture;
end;

procedure TBAMIcon.SetBAMFrame (AFrame: integer);
begin
  if FBAMFrame <> AFrame then begin
    FBAMFrame := AFrame;
    UpdatePicture;
  end;
end;

procedure TBAMIcon.SetSeqFrame (Seq, Frame: integer);
var
  BAM: TBAMImage;
begin
  if FBAMId <> '' then begin
    BAM := Game.GetFileByName (FBAMId, ftBAM) as TBAMImage;
    if BAM <> nil then begin
      if (Seq < 0) or (Seq >= Length (BAM.Animations)) then
        raise Exception.CreateFmt ('Invalid sequence %d', [Seq]);
      if (Frame < 0) or (Frame >= Length (BAM.Animations [Seq])) then
        raise Exception.CreateFmt ('Invalid frame %d', [Frame]);
      BAMFrame := BAM.Animations [Seq] [Frame];
      UpdatePicture;
    end;
  end;
end;

procedure TBAMIcon.UpdatePicture;
var
  BAM: TBAMImage;
  Bmp: TBitmap;
begin
  if Picture = nil then Picture := TPicture.Create;
  if FBAMId <> '' then begin
    BAM := Game.GetFileByName (FBAMId, ftBAM) as TBAMImage;
    if (BAM <> nil) and (Length (BAM.Frames) > FBAMFrame) then begin
      Bmp := GetBAMBitmap (BAM, FBAMFrame);
      Picture.Bitmap := Bmp;
      Bmp.Free;
    end
    else Picture.Bitmap := nil;
  end
  else
    Picture.Bitmap := nil;
end;

procedure Register;
begin
  RegisterComponents('InfExp', [TBAMIcon]);
end;

end.
