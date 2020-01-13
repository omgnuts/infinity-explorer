{ $Header: /cvsroot/InfExp/InfExp/src/FrameARE.pas,v 1.8 2000/11/01 19:00:14 yole Exp $
  Infinity Engine area viewer frame
  Copyright (C) 2000-01 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameARE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Infinity, InfStruc, InfMain, ExtCtrls, StdCtrls;

type
  TAreaOverlay = class
  public
    procedure Draw (Canvas: TCanvas); virtual; abstract;
    procedure GetBoundsRect (var R: TRect); virtual; abstract;
  end;

  TAreaOverlayPoly = class (TAreaOverlay)
  private
    FPoly: TWEDPoly;
  public
    constructor Create (const APoly: TWEDPoly);
    procedure Draw (Canvas: TCanvas); override;
    procedure GetBoundsRect (var R: TRect); override;
  end;

  TAreaOverlayRect = class (TAreaOverlay)
  private
    FRect: TRect;
  public
    constructor Create (const ARect: TRect);
    procedure Draw (Canvas: TCanvas); override;
    procedure GetBoundsRect (var R: TRect); override;
  end;

  TAreaFrame = class (TFrame)
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
    FArea: TAreaFile;
    FMap: TAreaMap;
    FWED: TAreaWED;
    FOverlays: TList;
    procedure PaintRect (const UpdRC: TRect);
      // draws the map and overlays
    procedure PaintMapRect (ACanvas: TCanvas; const UpdRC: TRect);
      // draws only the map
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ViewFile (AFile: TGameFile);
    procedure CloseFile;
    procedure AddOverlayRect (const R: TRect);
    procedure SetOverlayDoor (const Id: string);
    procedure AddOverlayPoly (const Poly: TWEDPoly);
    procedure RemoveOverlays;
    procedure ShowImpassable;
    function GetMapBitmap: TBitmap;
  end;

  TAreaFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure CloseFile; override;
    function  GetExportFilter: string; override;
    procedure ExportFile (const FName: string; FilterIndex: integer); override;
    procedure ScrollToPoint (const P: TPoint);
    procedure AddOverlayRect (const R: TRect);
    procedure SetOverlayDoor (const Id: string);
    procedure AddOverlayPoly (Poly: TWEDPoly);
    procedure RemoveOverlays;
    procedure ShowImpassable;
  end;

implementation

{$R *.DFM}

uses InfGraphics, FTUtils, JPEG;

{ TAreaOverlayPoly }

constructor TAreaOverlayPoly.Create (const APoly: TWEDPoly);
begin
  FPoly := APoly;
end;

procedure TAreaOverlayPoly.Draw (Canvas: TCanvas);
begin
  with Canvas do begin
    Pen.Color := clLime;
    Brush.Style := bsClear;
    Polygon (FPoly.Points);
  end;
end;

procedure TAreaOverlayPoly.GetBoundsRect (var R: TRect);
begin
  R := FPoly.Bounds;
end;

{ TAreaOverlayRect }

constructor TAreaOverlayRect.Create (const ARect: TRect);
begin
  FRect := ARect;
end;

procedure TAreaOverlayRect.Draw (Canvas: TCanvas);
begin
  with Canvas do begin
    Pen.Color := clLime;
    Brush.Style := bsClear;
    Rectangle (FRect);
  end;
end;

procedure TAreaOverlayRect.GetBoundsRect (var R: TRect);
begin
  R := FRect;
end;

{ TAreaFrame }

constructor TAreaFrame.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FOverlays := TList.Create;
end;

destructor TAreaFrame.Destroy;
begin
  FOverlays.Free;
  inherited Destroy;
end;

procedure TAreaFrame.ViewFile (AFile: TGameFile);
begin
  FArea := AFile as TAreaFile;
  FMap := Game.GetFileByName (FArea.AreaHdr.AreaID, ftMAP) as TAreaMap;
  FWED := Game.GetFileByName (FArea.AreaHdr.AreaID, ftWED) as TAreaWED;
  if FWED <> nil then begin
    Assert (Length (FWED.Overlays) > 0);
    Panel1.Width := FWED.Overlays [0].XBlocks * 64 + 2;
    Panel1.Height := FWED.Overlays [0].YBlocks * 64 + 2;
    RemoveOverlays;
    ScrollBox1.Visible := true;
    PaintBox1.Invalidate;
  end
  else
    ScrollBox1.Visible := false;
end;

procedure TAreaFrame.CloseFile;
begin
  // they'll be freed automatically
  FMap := nil;
  FWed := nil;
  FArea := nil;
end;

procedure TAreaFrame.AddOverlayRect (const R: TRect);
var
  OverlayRect: TAreaOverlayRect;
  BoundsRC: TRect;
begin
  OverlayRect := TAreaOverlayRect.Create (R);
  FOverlays.Add (OverlayRect);
  OverlayRect.GetBoundsRect (BoundsRC);
  PaintRect (BoundsRC);
end;

procedure TAreaFrame.SetOverlayDoor (const Id: string);
var
  i: integer;
begin
  for i := 0 to Length (FWED.Doors)-1 do
    if SameText (FWED.Doors [i].Id, Id) then begin
      AddOverlayPoly (FWED.Doors [i].Polys [0]);
      Break;
    end;
end;

procedure TAreaFrame.AddOverlayPoly (const Poly: TWEDPoly);
var
  OverlayPoly: TAreaOverlayPoly;
  BoundsRC: TRect;
begin
  OverlayPoly := TAreaOverlayPoly.Create (Poly);
  FOverlays.Add (OverlayPoly);
  OverlayPoly.GetBoundsRect (BoundsRC);
  PaintRect (BoundsRC);
end;

procedure TAreaFrame.RemoveOverlays;
var
  i: integer;
  Bounds, TotalBounds: TRect;
begin
  for i := FOverlays.Count-1 downto 0 do begin
    with TAreaOverlay (FOverlays [i]) do begin
      GetBoundsRect (Bounds);
      Free;
    end;
    UnionRect (TotalBounds, TotalBounds, Bounds);
  end;
  FOverlays.Clear;
  PaintRect (TotalBounds);
end;

procedure TAreaFrame.PaintBox1Paint (Sender: TObject);
begin
  PaintRect (PaintBox1.Canvas.ClipRect);
end;

procedure TAreaFrame.PaintRect (const UpdRC: TRect);
var
  OverlayRC, IntersectRC: TRect;
  i: integer;
begin
  if (FMap = nil) or (FWED = nil) then Exit;
  PaintMapRect (PaintBox1.Canvas, UpdRC);
  for i := 0 to FOverlays.Count-1 do begin
    TAreaOverlay (FOverlays [i]).GetBoundsRect (OverlayRC);
    if IntersectRect (IntersectRC, OverlayRC, UpdRC) then
      TAreaOverlay (FOverlays [i]).Draw (PaintBox1.Canvas);
  end;
end;

procedure TAreaFrame.PaintMapRect (ACanvas: TCanvas; const UpdRC: TRect);
var
  Row, Col: integer;
  RC, IntersectRC: TRect;
  BlockIndex: integer;
  Block: TImageBlock;
  Bitmap: TBitmap;
  XBlockCount, YBlockCount: integer;
begin
  with FWED do begin
    XBlockCount := Overlays [0].XBlocks;
    YBlockCount := Overlays [0].YBlocks;
    Bitmap := TBitmap.Create;
    Block := TImageBlock.CreateEmpty;
    try
      for Row := 0 to YBlockCount-1 do
        for Col := 0 to XBlockCount-1 do begin
          RC := Bounds (Col*64, Row*64, 64, 64);
          if IntersectRect (IntersectRC, RC, UpdRC) then begin
            BlockIndex := Overlays [0].Tilemap [Col, Row].PrimaryTile [0];
            FMap.GetBlock (BlockIndex, Block);
            GetImageBlockBitmap (Block, Bitmap);
            ACanvas.Draw (RC.Left, RC.Top, Bitmap);
          end;
        end;
    finally
      Bitmap.Free;
      Block.Free;
    end;
  end;
end;

function TAreaFrame.GetMapBitmap: TBitmap;
var
  AWidth, AHeight: integer;
begin
  Result := TBitmap.Create;
  AWidth := FWED.Overlays [0].XBlocks * 64;
  AHeight := FWED.Overlays [0].YBlocks * 64;
  with Result do begin
    PixelFormat := pf24Bit;
    Width := AWidth;
    Height := AHeight;
  end;
  PaintMapRect (Result.Canvas, Bounds (0, 0, AWidth, AHeight));
end;

procedure TAreaFrame.ShowImpassable;
var
  i: integer;
begin
  for i := 0 to Length (FWED.WallPolys)-1 do
    {if not FWED.WallPolys [i].Passable then} begin
      AddOverlayRect (FWED.WallPolys [i].Bounds);
      AddOverlayPoly (FWED.WallPolys [i]);
    end;
end;

procedure TAreaFrame.PaintBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
	rect : TRect;
begin
  lblCursorAt.Caption := Format ('Cursor at (%d,%d)', [X, Y]);
	rect := PaintBox1.Canvas.ClipRect;
  lblCursorAt.SetBounds(rect.Left+5, rect.Top+5, 120, 13);
end;                   
                
procedure TAreaFrame.FrameMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lblCursorAt.Caption := '';
end;
{ TAreaFrameProxy }

constructor TAreaFrameProxy.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FFrameClass := TAreaFrame;
end;

procedure TAreaFrameProxy.DoViewFile (AFile: TGameFile);
begin
  (FFrame as TAreaFrame).ViewFile (AFile);
end;

procedure TAreaFrameProxy.CloseFile;
begin
  (FFrame as TAreaFrame).CloseFile;
end;

function TAreaFrameProxy.GetExportFilter: string;
begin
  Result := 'BMP files (*.BMP)|*.BMP|JPEG files (*.JPG)|*.JPG';
end;

procedure TAreaFrameProxy.ExportFile (const FName: string; FilterIndex: integer);
var
  Bitmap: TBitmap;
  Filename: string;
  JPG: TJPEGImage;
const
  FilterExt: array [1..2] of string = ('.bmp', '.jpg');
begin
  Screen.Cursor := crHourglass;
  try
    if ExtractFileExt (FName) = '' then
      Filename := FName + FilterExt [FilterIndex]
    else
      Filename := FName;
    Bitmap := (FFrame as TAreaFrame).GetMapBitmap;
    try
      if FilterIndex = 1 then
        Bitmap.SaveToFile (Filename)
      else if FilterIndex = 2 then begin
        JPG := TJPEGImage.Create;
        try
          JPG.Assign (Bitmap);
          JPG.SaveToFile (Filename);
        finally
          JPG.Free;
        end;
      end;
    finally
      Bitmap.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TAreaFrameProxy.ScrollToPoint (const P: TPoint);

  function CalcPos (C, SB, PB, ScrollSize: integer): integer;
  begin
    Result := C - (SB - ScrollSize) div 2;
    if Result < 0 then Result := 0
    else if Result > PB - SB + ScrollSize then
      Result := PB - SB + ScrollSize;
  end;

var
  R: TRect;
  HScrollSize, VScrollSize: integer;
begin
  with FFrame as TAreaFrame do begin
    with ScrollBox1 do begin
      if HorzScrollBar.Visible then
        HScrollSize := GetSystemMetrics (SM_CYHSCROLL)
      else
        HScrollSize := 0;
      if VertScrollBar.Visible then
        VScrollSize := GetSystemMetrics (SM_CYVSCROLL)
      else
        VScrollSize := 0;
      R := Bounds (HorzScrollBar.Position, VertScrollBar.Position,
          Width - VScrollSize, Height - HScrollSize);
    end;
    if not PtInRect (R, P) then begin
      ScrollBox1.HorzScrollBar.Position := CalcPos (P.X, ScrollBox1.Width,
          PaintBox1.Width, VScrollSize);
      ScrollBox1.VertScrollBar.Position := CalcPos (P.Y, ScrollBox1.Height,
          PaintBox1.Height, HScrollSize);
      Update;
    end;
  end;
end;

procedure TAreaFrameProxy.AddOverlayRect (const R: TRect);
begin
  (FFrame as TAreaFrame).AddOverlayRect (R);
end;

procedure TAreaFrameProxy.SetOverlayDoor (const Id: string);
begin
  (FFrame as TAreaFrame).SetOverlayDoor (Id);
end;

procedure TAreaFrameProxy.AddOverlayPoly (Poly: TWEDPoly);
begin
  (FFrame as TAreaFrame).AddOverlayPoly (Poly);
end;

procedure TAreaFrameProxy.RemoveOverlays;
begin
  (FFrame as TAreaFrame).RemoveOverlays;
end;

procedure TAreaFrameProxy.ShowImpassable;
begin
  (FFrame as TAreaFrame).ShowImpassable;
end;

end.
