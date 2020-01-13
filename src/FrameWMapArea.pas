{ $Header: /cvsroot/InfExp/InfExp/src/FrameWMapArea.pas,v 1.3 2000/11/01 19:00:14 yole Exp $
  Infinity Explorer: worldmap area view
  Copyright (C) 2000 Dmitry Jemerov <yole@spb.cityline.ru>
  See the file COPYING for license information
}

unit FrameWMapArea;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Infinity, InfMain, InfStruc, StdCtrls, Hyperlink, ExtCtrls,
  InfGraphics, Grids;

type
  TWMapAreaFrame = class (TFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EdtMapBackground: THyperlinkEdit;
    Label2: TLabel;
    EdtMapIcons: THyperlinkEdit;
    Label3: TLabel;
    EdtAreaID: THyperlinkEdit;
    Label4: TLabel;
    EdtAreaName: TEdit;
    Label5: TLabel;
    EdtLocationName: TEdit;
    Label6: TLabel;
    EdtLoadScreen: THyperlinkEdit;
    Label7: TLabel;
    EdtIconIndex: TEdit;
    Label8: TLabel;
    EdtIconX: TEdit;
    Label9: TLabel;
    EdtIconY: TEdit;
    BAMIcon1: TBAMIcon;
    LinkGrid: THyperlinkGrid;
    chkVisible: TCheckBox;
    Label10: TLabel;
    chkCanVisit: TCheckBox;
    Label11: TLabel;
    chkVisited: TCheckBox;
    Label12: TLabel;
    procedure LinkGridCanJump(Sender: TObject; ACol, ARow: Integer;
      var Result: Boolean);
    procedure LinkGridJump(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public
    procedure ViewWMapArea (AMap: PWorldMap; AIndex: integer);
  end;

  TWMapAreaFrameProxy = class (TFrameProxy)
  public
    constructor Create (AOwner: TComponent); override;
    procedure DoViewFile (AFile: TGameFile); override;
    procedure ViewWMapArea (AMap: PWorldMap; AIndex: integer);
    procedure GetPosInfo (var PosInfo: pointer); override;
    procedure SetPosInfo (PosInfo: pointer); override;
  end;

implementation

{$R *.DFM}

{ TWMapAreaFrame }

procedure TWMapAreaFrame.ViewWMapArea (AMap: PWorldMap; AIndex: integer);
var
  i, j, TotalLinks, CurRow: integer;
begin
  EdtMapBackground.ResRef := AMap.Hdr.MapResName;
  EdtMapIcons.ResRef := AMap.Hdr.MapIconResName;
  with LinkGrid do begin
    Cells [0, 0] := 'To area';
    Cells [1, 0] := 'Entry point';
    Cells [2, 0] := 'Travel hours';
  end;
  with AMap.Areas [AIndex] do begin
    EdtAreaID.ResRef := AreaId1;
    EdtAreaName.Text := AreaName;
    if Game.TLK.ValidID (TLKIndex1) then
      EdtLocationName.Text := Game.TLK.Text [TLKIndex1]
    else
      EdtLocationName.Text := '?';
    EdtLoadScreen.ResRef := LoadScreen;
    EdtIconIndex.Text := IntToStr (BAMFrame);
    EdtIconX.Text := IntToStr (X);
    EdtIconY.Text := IntToStr (Y);
    BAMIcon1.BAMId := PChar8ToStr (AMap.Hdr.MapIconResName);
    BAMIcon1.SetSeqFrame (BAMFrame, 0);
    chkVisible.Checked := (Flags and wmaVisible <> 0);
    chkCanVisit.Checked := (Flags and wmaCanVisit <> 0);
    chkVisited.Checked := (Flags and wmaVisited <> 0);
    // Links page
    TotalLinks := 0;
    for i := 1 to 4 do
      Inc (TotalLinks, Links [i].LinkCount);
    if TotalLinks = 0 then
      with LinkGrid do begin
        RowCount := 2;
        Cells [0, 1] := 'None';
        for i := 1 to ColCount-1 do
          Cells [i, 1] := '';
      end
    else begin
      LinkGrid.RowCount := TotalLinks+1;
      CurRow := 1;
      for i := 1 to 4 do
        for j := Links [i].FirstLink to Links [i].FirstLink+Links [i].LinkCount-1 do begin
          LinkGrid.Cells [0, CurRow] := AMap.Areas [AMap.Links [j].ToAreaIndex].AreaId1;
          LinkGrid.Cells [1, CurRow] := AMap.Links [j].EntryPoint;
          LinkGrid.Cells [2, CurRow] := IntToStr (AMap.Links [j].TravelHours);
          Inc (CurRow);
        end;
    end;
  end;
end;

procedure TWMapAreaFrame.LinkGridCanJump (Sender: TObject; ACol,
  ARow: Integer; var Result: Boolean);
begin
  Result := (ACol = 0) and (ARow > 0) and (LinkGrid.Cells [ACol, ARow] <> '')
      and (LinkGrid.Cells [ACol, ARow] <> 'None');
end;

procedure TWMapAreaFrame.LinkGridJump (Sender: TObject; ACol,
  ARow: Integer);
begin
  MainForm.BrowseToFile (LinkGrid.Cells [ACol, ARow], ftAREA);
end;

{ TWMapAreaFrameProxy }

constructor TWMapAreaFrameProxy.Create (AOwner: TComponent);
begin
  inherited;
  FFrameClass := TWMapAreaFrame;
end;

procedure TWMapAreaFrameProxy.DoViewFile (AFile: TGameFile);
begin
  // because a worldmap area is not a TGameFile, DoViewFile is just a do-nothing stub.
end;

procedure TWMapAreaFrameProxy.ViewWMapArea (AMap: PWorldMap;
  AIndex: integer);
begin
  if FFrame = nil then FFrame := TWMapAreaFrame.Create (FOwner);
  TWMapAreaFrame (FFrame).ViewWMapArea (AMap, AIndex);
end;

procedure TWMapAreaFrameProxy.GetPosInfo (var PosInfo: pointer);
begin
  PosInfo := Pointer ((FFrame as TWMapAreaFrame).PageControl1.ActivePageIndex);
end;

procedure TWMapAreaFrameProxy.SetPosInfo (PosInfo: pointer);
begin
  (FFrame as TWMapAreaFrame).PageControl1.ActivePageIndex := integer (PosInfo);
end;

end.
