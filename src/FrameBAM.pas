{ $Header: /cvsroot/InfExp/InfExp/src/FrameBAM.pas,v 1.7 2000/09/01 19:04:36 yole Exp $
  Infinity Engine BAM viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit FrameBAM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfMain, StdCtrls, ExtCtrls;

type
  TBAMFrame = class (TFrame)
    Label1: TLabel;
    lblAnims: TLabel;
    Label3: TLabel;
    lblFrames: TLabel;
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    BtnPrevAnim: TButton;
    BtnPrevFrame: TButton;
    BtnNextAnim: TButton;
    BtnNextFrame: TButton;
    BtnPlay: TButton;
    procedure PaintBox1Paint(Sender: TObject);
    procedure BtnPrevAnimClick(Sender: TObject);
    procedure BtnNextAnimClick(Sender: TObject);
    procedure BtnPrevFrameClick(Sender: TObject);
    procedure BtnNextFrameClick(Sender: TObject);
    procedure BtnPlayClick(Sender: TObject);
  private
    FImage: TBAMImage;
    CurAnim, CurFrame: integer;
    CurFrameBitmap: TBitmap;
    RefX, RefY: integer; // reference point coordinates
    CurFrameIndex: integer;
    Playing: boolean;
    procedure CalcSize;
    procedure ShowCurrentFrame;
    procedure PaintFrame (Canvas: TCanvas; FrameIndex: integer; FrameBitmap: TBitmap);
  public
    procedure ViewFile (AFile: TGameFile);
    procedure CloseFile;
    procedure GotoFrame (Seq, Frame: word);
  end;

  TBAMFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure CloseFile; override;
    function  GetExportFilter: string; override;
    procedure ExportFile (const FName: string; FilterIndex: integer); override;
    procedure SetPosInfo (PosInfo: pointer); override;
  end;

// Flag to stop the currently running BAM animation.
var
  BAMStopPlaying: boolean;

implementation

{$R *.DFM}

uses RXGif, JPEG, InfGraphics;

{ TBAMFrame }

procedure TBAMFrame.ViewFile (AFile: TGameFile);
begin
  FImage := AFile as TBAMImage;
  CurAnim := 0;
  CurFrame := 0;
  CurFrameBitmap := nil;
  Playing := false;
  BtnPrevFrame.Enabled := true;
  BtnNextFrame.Enabled := true;
  BtnPrevAnim.Enabled := true;
  BtnNextAnim.Enabled := true;
  BtnPlay.Enabled := true;
  CalcSize;
  ShowCurrentFrame;
end;

procedure TBAMFrame.CloseFile;
begin
  CurFrameBitmap.Free;
  BAMStopPlaying := true;
end;

procedure TBAMFrame.CalcSize;
var
  W, H: integer;
begin
  FImage.CalcAnimationSize (CurAnim, W, H, RefX, RefY);
  Panel1.Width := W+2;
  Panel1.Height := H+2;
end;

procedure TBAMFrame.ShowCurrentFrame;
begin
  lblAnims.Caption := Format ('%d/%d', [CurAnim+1, Length (FImage.Animations)]);
  lblFrames.Caption := Format ('%d/%d', [CurFrame+1, Length (FImage.Animations [CurAnim])]);
  BtnPrevAnim.Enabled := (CurAnim > 0);
  BtnNextAnim.Enabled := (CurAnim < Length (FImage.Animations)-1);
  BtnPrevFrame.Enabled := (CurFrame > 0);
  BtnNextFrame.Enabled := (CurFrame < Length (FImage.Animations [CurAnim])-1);
  BtnPlay.Enabled := (Length (FImage.Animations [CurAnim]) > 0);
  if CurFrameBitmap <> nil then CurFrameBitmap.Free;
  if Length (FImage.Animations [CurAnim]) > 0 then begin
    CurFrameIndex := FImage.Animations [CurAnim, CurFrame];
    if CurFrameIndex <> $FFFF then
      CurFrameBitmap := GetBAMBitmap (FImage, CurFrameIndex)
    else
      CurFrameBitmap := nil;
  end
  else CurFrameBitmap := nil;
  PaintBox1.Invalidate;
end;

procedure TBAMFrame.GotoFrame (Seq, Frame: word);
begin
  CurAnim := Seq;
  CurFrame := Frame;
  ShowCurrentFrame;
end;

procedure TBAMFrame.PaintBox1Paint(Sender: TObject);
begin
  if (CurFrameBitmap <> nil) and not Playing then
    PaintFrame (PaintBox1.Canvas, CurFrameIndex, CurFrameBitmap);
end;

procedure TBAMFrame.PaintFrame (Canvas: TCanvas; FrameIndex: integer;
    FrameBitmap: TBitmap);
var
  Src, Dest: TRect;
begin
  with FImage.Frames [FrameIndex] do begin
    Dest := Bounds (RefX - XPos, RefY - YPos, Width, Height);
    Src := Bounds (0, 0, Width, Height);
    Canvas.BrushCopy (Dest, FrameBitmap, Src, FrameBitmap.TransparentColor);
  end;
end;

procedure TBAMFrame.BtnPlayClick (Sender: TObject);
var
  Frame, FrameIndex: integer;
  Bitmap, FrameBitmap: TBitmap;
  R: TRect;
begin
  Playing := true;
  BAMStopPlaying := false;
  BtnPrevFrame.Enabled := false;
  BtnNextFrame.Enabled := false;
  BtnPrevAnim.Enabled := false;
  BtnNextAnim.Enabled := false;
  BtnPlay.Enabled := false;
  Bitmap := TBitmap.Create;
  with Bitmap do begin
    PixelFormat := pf24Bit;
    Width := PaintBox1.Width;
    Height := PaintBox1.Height;
    TransparentColor := CurFrameBitmap.TransparentColor;
    Canvas.Brush.Color := clBtnFace;
  end;
  R := Bounds (0, 0, PaintBox1.Width, PaintBox1.Height);
  try
    for Frame := 0 to Length (FImage.Animations [CurAnim])-1 do begin
      Bitmap.Canvas.FillRect (R);
      FrameIndex := FImage.Animations [CurAnim, Frame];
      FrameBitmap := GetBAMBitmap (FImage, FrameIndex);
      PaintFrame (Bitmap.Canvas, FrameIndex, FrameBitmap);
      PaintBox1.Canvas.BrushCopy (R, Bitmap, R, Bitmap.TransparentColor);
      FrameBitmap.Free;
      Application.ProcessMessages;
      if BAMStopPlaying then Exit;
      Sleep (100);
    end;
    Playing := false;
    BtnPrevFrame.Enabled := true;
    BtnNextFrame.Enabled := true;
    BtnPrevAnim.Enabled := true;
    BtnNextAnim.Enabled := true;
    BtnPlay.Enabled := true;
    CurFrame := Length (FImage.Animations [CurAnim])-1;
    ShowCurrentFrame;
  finally
    Bitmap.Free;
  end;
end;

procedure TBAMFrame.BtnPrevAnimClick (Sender: TObject);
begin
  Dec (CurAnim);
  CurFrame := 0;
  CalcSize;
  ShowCurrentFrame;
end;

procedure TBAMFrame.BtnNextAnimClick (Sender: TObject);
begin
  Inc (CurAnim);
  CurFrame := 0;
  CalcSize;
  ShowCurrentFrame;
end;

procedure TBAMFrame.BtnPrevFrameClick (Sender: TObject);
begin
  Dec (CurFrame);
  ShowCurrentFrame;
end;

procedure TBAMFrame.BtnNextFrameClick (Sender: TObject);
begin
  Inc (CurFrame);
  ShowCurrentFrame;
end;

{ TBAMFrameProxy }

constructor TBAMFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TBAMFrame;
end;

procedure TBAMFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TBAMFrame).ViewFile (AFile);
end;

procedure TBAMFrameProxy.CloseFile;
begin
  (FFrame as TBAMFrame).CloseFile;
end;

function TBAMFrameProxy.GetExportFilter: string;
begin
  Result := 'BMP files (*.BMP)|*.BMP|Animated GIF files (*.GIF)|*.GIF|JPEG files (*.JPG)|*.JPG';
end;

procedure TBAMFrameProxy.ExportFile (const FName: string; FilterIndex: integer);
var
  FileName: string;
  BAMBitmap: TBitmap;
  GIF: TGIFImage;
  i, FrameIndex: integer;
  W, H, ARefX, ARefY: integer;
  OriginPnt: TPoint;
  JPG: TJPEGImage;
const
  FilterExt: array [1..3] of string = ('.bmp', '.gif', '.jpg');
begin
  if ExtractFileExt (FName) = '' then
    Filename := FName + FilterExt [FilterIndex]
  else
    Filename := FName;
  with FFrame as TBAMFrame do begin
    if FilterIndex = 1 then begin
      BAMBitmap := GetBAMBitmap (FImage, CurFrameIndex);
      try
        BAMBitmap.SaveToFile (Filename);
      finally
        BAMBitmap.Free;
      end;
    end
    else if FilterIndex = 3 then begin
      BAMBitmap := GetBAMBitmap (FImage, CurFrameIndex);
      try
        JPG := TJPEGImage.Create;
        JPG.Assign (BAMBitmap);
        JPG.SaveToFile (Filename);
        JPG.Free;
      finally
        BAMBitmap.Free;
      end;
    end
    else if FilterIndex = 2 then begin
      GIF := TGIFImage.Create;
      try
        FImage.CalcAnimationSize (CurAnim, W, H, ARefX, ARefY);
        for i := 0 to Length (FImage.Animations [CurAnim])-1 do begin
          FrameIndex := FImage.Animations [CurAnim, i];
          BAMBitmap := GetBAMBitmap (FImage, FrameIndex);
          with FImage.Frames [FrameIndex] do
            OriginPnt := Point (ARefX - XPos, ARefY - YPos);
          GIF.AddFrame (BAMBitmap);
          with GIF.Frames [GIF.FrameIndex] do begin
            AnimateInterval := 1000 div 15; // 15 fps
            Origin := OriginPnt;
            DisposalMethod := dmRestoreBackground;
            TransparentColor := $00FF00;
          end;
          BAMBitmap.Free;
        end;
        GIF.SaveToFile (Filename);
      finally
        GIF.Free;
      end;
    end;
  end;
end;

procedure TBAMFrameProxy.SetPosInfo (PosInfo: pointer);
var
  Seq, Frame: word;
begin
  Seq := Integer (PosInfo) shr 16;
  Frame := Integer (PosInfo) and $FFFF;
  (FFrame as TBAMFrame).GotoFrame (Seq, Frame);
end;

end.
