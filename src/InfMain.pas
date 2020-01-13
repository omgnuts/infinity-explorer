{ $Header: /cvsroot/InfExp/InfExp/src/InfMain.pas,v 1.15 2000/11/01 19:00:14 yole Exp $
  Infinity Explorer: main form
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit InfMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, ImgList, ExtCtrls, StdCtrls, Mask, ToolEdit, Infinity,
  Placemnt, IniFiles, Registry, InfStruc, SCDecomp, Menus, ActnList,
  Hyperlink;

type
  TSearchType = (stCode);
  TSearchTypes = set of TSearchType;

  TSearchPos = class
  private
    FUserData: TObject;
    procedure SetUserData (const Value: TObject);
  public
    SearchType: TSearchType;
    FileType: TFileType;
    FileTypes: set of TFileType;  // file types to search
    Index: integer;
    Str: string;
    constructor Create (ASearchType: TSearchType; const AStr: string;
        AFileTypes: TFileTypes);
    destructor Destroy; override;
    property UserData: TObject read FUserData write SetUserData;  // specific for individual frame types
  end;

  TNodeFlag = (ienPopup, ienSave);
  TNodeFlags = set of TNodeFlag;

  TInfExpNode = class
  protected
    FNode: TTreeNode;
    procedure CreateNode (AOwner: TTreeNode; const AName: string);
    procedure CreateFileNode (const AName: string; AIndex: integer;
        AFileType: TFileType);
    function CreateExternalFileNode (const APath: string;
        AFileType: TFileType; AName: string = ''): TInfExpNode;
    function GetFlags: TNodeFlags; virtual;
    function GetSaveFileName: string; virtual;
    procedure SaveFile (const FileName: string); virtual;
  public
    Expanded: boolean;
    destructor Destroy; override;
    procedure Expand; virtual;
    procedure Select; virtual;
    procedure SelectFile (AIndex: integer; KeepExtraFrame: boolean = false);
    procedure SelectExternal (AIndex: integer; const ExternalPath: string;
        AFileType: TFileType; KeepExtraFrame: boolean = false);
  end;

  TFrameClass = class of TFrame;

  TFrameProxy = class
  protected
    FFrame: TFrame;
    FFrameClass: TFrameClass;
    FOwner: TComponent;
  public
    constructor Create (AOwner: TComponent); virtual;
    procedure FreeFrame;
    procedure SetFrameParent (AParent: TWinControl); virtual;
    procedure ViewFile (AFile: TGameFile);
    procedure DoViewFile (AFile: TGameFile); virtual; abstract;
    procedure CloseFile; virtual;
    function  CanSearch: TSearchTypes; virtual;
    function  DoSearch (AFile: TGameFile; SearchPos: TSearchPos): boolean; virtual;
    procedure LocatePos (SearchPos: TSearchPos); virtual;
    function  GetExportFilter: string; virtual;
    procedure ExportFile (const FName: string; FilterIndex: integer); virtual;
    procedure GetPosInfo (var PosInfo: pointer); virtual;
    procedure SetPosInfo (PosInfo: pointer); virtual;
  end;

  TMainForm = class (TForm)
    FormPlacement1: TFormPlacement;
    MainMenu1: TMainMenu;
    Fi1: TMenuItem;
    Actions: TActionList;
    actOpenGame: TAction;
    Opengame1: TMenuItem;
    actExit: TAction;
    N1: TMenuItem;
    Exit1: TMenuItem;
    actSaveCurrent: TAction;
    Savecurrentfile1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Help1: TMenuItem;
    actAbout: TAction;
    About1: TMenuItem;
    tvItems: TTreeView;
    Splitter1: TSplitter;
    Panel3: TPanel;
    lblNoCD: TLabel;
    StatusBar1: TStatusBar;
    actOpenExternal: TAction;
    Openexternalfile1: TMenuItem;
    OpenDialog1: TOpenDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    Images: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    EdtLocate: TEdit;
    miLocateFile: TMenuItem;
    actLocate: TAction;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    actBack: TAction;
    actForward: TAction;
    View1: TMenuItem;
    Back1: TMenuItem;
    actForward1: TMenuItem;
    actSearchForCode: TAction;
    N2: TMenuItem;
    Searchforcode1: TMenuItem;
    actSearchAgain: TAction;
    Savecurrentfile2: TMenuItem;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    actCancelSearch: TAction;
    actExport: TAction;
    DlgExport: TSaveDialog;
    Exportcurrentfile1: TMenuItem;
    N3: TMenuItem;
    mnuFilePopup: TPopupMenu;
    Savecurrentfile3: TMenuItem;
    Exportcurrentfile2: TMenuItem;
    ToolButton10: TToolButton;
    Jumper: THyperlinkJumper;
    actLookupStrref: TAction;
    N4: TMenuItem;
    LookupStrRef1: TMenuItem;
    procedure FormClose (Sender: TObject; var Action: TCloseAction);
    procedure FormCreate (Sender: TObject);
    procedure tvItemsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure actOpenGameExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveCurrentUpdate(Sender: TObject);
    procedure actSaveCurrentExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actOpenExternalUpdate(Sender: TObject);
    procedure actOpenExternalExecute(Sender: TObject);
    procedure EdtLocateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actLocateExecute(Sender: TObject);
    procedure actBackUpdate(Sender: TObject);
    procedure actForwardUpdate(Sender: TObject);
    procedure actBackExecute(Sender: TObject);
    procedure actForwardExecute(Sender: TObject);
    procedure actSearchForCodeExecute(Sender: TObject);
    procedure actSearchAgainUpdate(Sender: TObject);
    procedure actSearchAgainExecute(Sender: TObject);
    procedure actCancelSearchExecute(Sender: TObject);
    procedure actOpenGameUpdate(Sender: TObject);
    procedure actExportUpdate(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure tvItemsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure JumperJump(Sender: TObject; const Link: String;
      FileType: TFileType);
    procedure actLookupStrrefExecute(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FCurFrame: TFrameProxy;
    ExtraFrame: TFrame;
    CurFileType: TFileType;
    Ini: TRegistryIniFile;
    GamePath: string;
    ExternalFilesNode: TInfExpNode;
    RootNodes: TList;
    BrowseStack: TList;
    BrowseStackPos: integer;
    CodeSearchStr: string;
    CodeSearchDialogs, CodeSearchScripts: boolean;
    SearchPos: TSearchPos;
    Searching: boolean;
    procedure FreeGame;
    procedure GameNeedCD (CD_Number: integer);
    procedure LocateFileByName (const Name: string);
    function  LocateFile (Index: integer; NeedPush: boolean;
        PosInfo: pointer): boolean;
    procedure PushPosition;
    procedure RestorePosition;
    function  CreateFileFrame (AFileType: TFileType): TFrameProxy;
    procedure DoSearch;
  public
    CurFile: TGameFile;
    tvDialogHeight: integer;
    procedure CloseFrame;
    procedure ViewFile (AFile: TGameFile; KeepExtraFrame: boolean = false);
    procedure BrowseToFile (const Name: string; FileType: TFileType);
    function BrowseToFileEx (const Name: string; FileType: TFileType;
        PosInfo: pointer): boolean;
    procedure BrowseToLink (const LinkText: string);
    procedure SetExtraFrame (C: TFrameClass);
    procedure LookupStrref (StrRef: integer);
    property CurFrame: TFrameProxy read FCurFrame;
  end;

  ENoCD = class (Exception)
  end;

var
  MainForm: TMainForm;
  DC: TScriptDecompiler;

procedure SetEdit (Edit: TEdit; const Text: string);
procedure SetMemo (Memo: TCustomMemo; const Text: string);
function GetItemHeight (Font: TFont): Integer;

implementation

{$R *.DFM}

uses
  FTUtils, FrameMOS, FrameDLG, FrameSCR, FrameBAM, FrameARE, FrameQuest,
  FrameBMP, FrameCRE, FrameITM, FrameSPL, FrameSTOR, FrameAreaNPC,
  FrameAreaInfo,  FrameAreaDoor, FrameAreaCntr, FrameAreaGeneral,
  FrameAreaAnim, FrameAreaVars, FrameAreaSpawn, FrameChUIPanel, FrameWMapArea,
  FrameSaveGame, DlgOpenG, DlgAbout, DlgSearchCode, DlgStrref;

procedure SetEdit (Edit: TEdit; const Text: string);
begin
  Edit.Text := Text;
  if Text = '' then Edit.Cursor := crDefault
  else Edit.Cursor := crHandPoint;
end;

type
  TMemoHack = class (TCustomMemo)
  end;

procedure SetMemo (Memo: TCustomMemo; const Text: string);
var
  LineCount: integer;
  DC: HDC;
  SaveFont: HFont;
  SysMetrics, Metrics: TTextMetric;
begin
  Memo.Lines.Text := Text;
  LineCount := SendMessage (Memo.Handle, EM_GETLINECOUNT, 0, 0);
  // following code based on TCustomEdit.AdjustRect from StdCtrls.pas
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, TMemoHack (Memo).Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Memo.Height := Metrics.tmHeight * LineCount + GetSystemMetrics(SM_CYBORDER) * 8;
end;

function GetItemHeight (Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Result := Metrics.tmHeight;
end;

type
  TGroupNode = class (TInfExpNode)
  public
    constructor Create (AOwner: TTreeNode; const AName: string);
    procedure Select; override;
    procedure Expand; override;
    procedure DoExpand; virtual; abstract;
    function HasFile (const ChFile: TChitinFile): boolean; virtual;
    procedure LocateFileNode (AIndex: integer; PosInfo: pointer);
  end;

  TSimpleGroupNode = class (TGroupNode)
  public
    constructor Create (AOwner: TTreeNode; const AName: string);
    procedure DoExpand; override;
  end;

  TFileTypeNode = class (TGroupNode)
  private
    FFileType: TFileType;
  public
    constructor Create (AFileType: TFileType; const AName: string);
    procedure DoExpand; override;
    function HasFile (const ChFile: TChitinFile): boolean; override;
  end;

  TFileNode = class (TInfExpNode)
  protected
    function GetGameFile: TGameFile;
    function GetFlags: TNodeFlags; override;
    function GetSaveFileName: string; override;
    procedure SaveFile (const FileName: string); override;
  public
    Index: integer;
    FileType: TFileType;
    ExternalPath: string;
    constructor Create (AOwner: TTreeNode; const AName: string; AIndex: integer;
        AFileType: TFileType);
    constructor CreateExternal (AOwner: TTreeNode; const AName: string;
        const APath: string; AFileType: TFileType);
    procedure Select; override;
  end;

  TAreaNode = class (TFileNode)
  public
    constructor Create (AOwner: TTreeNode; const AName: string; AIndex: integer;
        AFileType: TFileType);
    constructor CreateExternal (AOwner: TTreeNode; const AName: string;
        const APath: string; AFileType: TFileType);
    procedure Expand; override;
    procedure Select; override;
  end;

  TAreaGroupNode = class (TSimpleGroupNode)
  public
    Index: integer;
    ExternalPath: string;
    constructor Create (AOwner: TTreeNode; const AName: string;
      AArea: TAreaFile; const AExternalPath: string);
    procedure Select; override;
  end;

  TAreaElemNode = class (TInfExpNode)
  public
    AreaIndex: integer;
    ElemPoint: TPoint;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile;
        const AName: string; const APoint: TPoint); overload;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer);
        overload; virtual; abstract;
    procedure Select; override;
  end;

  TAreaElemNodeClass = class of TAreaElemNode;

  TAreaGeneralNode = class (TAreaElemNode)
  public
    Hdr: TAreaHeaderRec;
    Offsets: TAreaOffsetsRec;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaNPCNode = class (TAreaElemNode)
  public
    NPC: TAreaNPCRec;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaInfoNode = class (TAreaElemNode)
  public
    Info: TAreaInfo;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaEntryNode = class (TAreaElemNode)
  public
    Entry: TAreaEntryRec;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaContainerNode = class (TAreaElemNode)
  public
    Container: TAreaContainer;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaDoorNode = class (TAreaElemNode)
  public
    Door: TAreaDoor;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaTiledObjNode = class (TAreaElemNode)
  public
    TiledObj: TAreaTiledObjectRec;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
  end;

  TAreaAnimNode = class (TAreaElemNode)
  public
    Anim: TAreaAnimRec;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaVarsNode = class (TAreaElemNode)
  public
    Vars: array of TGameVarRec;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TAreaSpawnPointNode = class (TAreaElemNode)
  public
    Spawn: TAreaSpawnRec;
    constructor Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer); override;
    procedure Select; override;
  end;

  TChUINode = class (TFileNode)
  public
    constructor Create (AOwner: TTreeNode; const AName: string; AIndex: integer;
        AFileType: TFileType);
    constructor CreateExternal (AOwner: TTreeNode; const AName: string;
        const APath: string; AFileType: TFileType);
    procedure Expand; override;
  end;

  TChUIPanelNode = class (TInfExpNode)
  public
    Panel: TChUIPanel;
    constructor Create (AOwner: TTreeNode; const APanel: TChUIPanel);
    procedure Select; override;
  end;

  TWorldMapNode = class (TGroupNode)
  public
    Map: TWorldMap;
    constructor Create (AOwner: TTreeNode; const AName, AResRef: string);
    constructor CreateExternal (AOwner: TTreeNode; const AName: string;
        const APath: string);
    procedure DoExpand; override;
  end;

  TWorldMapAreaNode = class (TInfExpNode)
  public
    Map: PWorldMap;
    Index: integer;
    constructor Create (AOwner: TTreeNode; AMap: PWorldMap; AIndex: integer);
    procedure Select; override;
  end;

  TBIFFGroupNode = class (TGroupNode)
  private
    FFileType: TFileType;
  public
    constructor Create (AFileType: TFileType; const AName: string);
    procedure DoExpand; override;
    function HasFile (const ChFile: TChitinFile): boolean; override;
  end;

  TBIFFNode = class (TGroupNode)
  private
    FFileType: TFileType;
    FBIFF: integer;
  public
    constructor Create (AOwner: TTreeNode; AFileType: TFileType; ABIFF: integer;
        const AName: string);
    procedure DoExpand; override;
    function HasFile (const ChFile: TChitinFile): boolean; override;
  end;

  TQuestsNode = class (TGroupNode)
  private
    FQuestsIni: TQuestsIni;
    FFileName: string;
  public
    constructor Create (const FName: string);
    destructor Destroy; override;
    procedure DoExpand; override;
  end;

  TQuestNode = class (TInfExpNode)
  public
    Quest: TQuest;
    constructor Create (AOwner: TTreeNode; const AQuest: TQuest);
    procedure Select; override;
  end;

  TSaveGamesNode = class (TGroupNode)
  private
    FGameList: TSaveGameList;
  public
    constructor Create (AGameList: TSaveGameList; const Name: string);
    procedure DoExpand; override;
  end;

  TSaveGameNode = class (TGroupNode)
  public
    SaveGame: TSaveGame;
    constructor Create (AOwner: TTreeNode; ASaveGame: TSaveGame);
    procedure DoExpand; override;
    procedure Select; override;
  end;

  TSaveGameCharNode = class (TInfExpNode)
  protected
    function GetFlags: TNodeFlags; override;
    function GetSaveFileName: string; override;
    procedure SaveFile (const FileName: string); override;
  public
    Char: TSaveGameCharacter;
    constructor Create (AOwner: TTreeNode; AChar: TSaveGameCharacter);
    procedure Select; override;
  end;

{ TInfExpNode }

destructor TInfExpNode.Destroy;
begin
  FNode.Data := nil;
  inherited Destroy;
end;

procedure TInfExpNode.Expand;
begin
  // do nothing
end;

procedure TInfExpNode.Select;
begin
  // do nothing
end;

procedure TInfExpNode.SelectFile (AIndex: integer; KeepExtraFrame: boolean = false);
var
  AFile: TGameFile;
begin
  with MainForm do
    if (CurFile <> nil) and (CurFile.Index <> -1) and (CurFile.Index = AIndex) then
      Exit;
  Screen.Cursor := crHourglass;
  try
    Game.FreeFiles;
    with MainForm do begin
      lblNoCD.Visible := false;
      try
        CurFile := nil;
        AFile := Game.GetFile (AIndex);
        if AFile <> nil then ViewFile (AFile, KeepExtraFrame);
      except
        on E: Exception do begin
          if CurFrame <> nil then begin
            CurFrame.FreeFrame;
            Pointer (FCurFrame) := nil;
          end;
          lblNoCD.Visible := true;
          lblNoCD.Caption := E.Message;
          CurFile := nil;
        end;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TInfExpNode.SelectExternal (AIndex: integer; const ExternalPath: string;
    AFileType: TFileType; KeepExtraFrame: boolean = false);
var
  ExtName: string;
  NeedReplace: boolean;
  AFile: TGameFile;
begin
  // either AIndex must be < 0, or ExternalPath must be empty, but not both
  Assert ((AIndex < 0) xor (ExternalPath = ''));
  if AIndex <> -1 then
    SelectFile (AIndex, KeepExtraFrame)
  else begin
    ExtName := ChangeFileExt (ExtractFileName (ExternalPath), '');
    NeedReplace := true;
    if MainForm.CurFile <> nil then
      with MainForm.CurFile do
        if (FileType = AFileType) and (Index = -1) and (Name = ExtName) then
          NeedReplace := false;
    if NeedReplace then begin
      AFile := Game.LoadExternalFile (ExternalPath, ExtName, AFileType);
      MainForm.ViewFile (AFile, KeepExtraFrame);
    end;
  end;
end;

procedure TInfExpNode.CreateNode (AOwner: TTreeNode; const AName: string);
begin
  FNode := MainForm.tvItems.Items.AddChildObject (AOwner, AName, Self);
end;

procedure TInfExpNode.CreateFileNode (const AName: string;
    AIndex: integer; AFileType: TFileType);
begin
  if AFileType = ftArea then
    TAreaNode.Create (FNode, AName, AIndex, AFileType)
  else if AFileType = ftCHU then
    TChUINode.Create (FNode, AName, AIndex, AFileType)
  else
    TFileNode.Create (FNode, AName, AIndex, AFileType);
end;

function TInfExpNode.CreateExternalFileNode (const APath: string;
    AFileType: TFileType; AName: string = ''): TInfExpNode;
begin
  if AName = '' then
    AName := ExtractFileName (APath);
  if AFileType = ftArea then
    Result := TAreaNode.CreateExternal (FNode, AName, APath, AFileType)
  else if AFileType = ftCHU then
    Result := TChUINode.CreateExternal (FNode, AName, APath, AFileType)
  else if AFileType = ftWMAP then
    Result := TWorldMapNode.CreateExternal (FNode, AName, APath)
  else
    Result := TFileNode.CreateExternal (FNode, AName, APath, AFileType);
end;

function TInfExpNode.GetFlags: TNodeFlags;
begin
  Result := [];
end;

function TInfExpNode.GetSaveFileName: string;
begin
  Result := '';
end;

procedure TInfExpNode.SaveFile;
begin
  // do nothing
end;

{ TGroupNode }

constructor TGroupNode.Create (AOwner: TTreeNode; const AName: string);
begin
  CreateNode (AOwner, AName);
  FNode.HasChildren := true;
end;

procedure TGroupNode.Select;
begin
  with MainForm do begin
    SetExtraFrame (nil);
    CloseFrame;
    CurFile := nil;
  end;
end;

procedure TGroupNode.Expand;
begin
  Screen.Cursor := crHourglass;
  FNode.Owner.BeginUpdate;
  try
    DoExpand;
  finally
    FNode.Owner.EndUpdate;
    Expanded := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TGroupNode.LocateFileNode (AIndex: integer; PosInfo: pointer);
var
  Node: TTreeNode;
begin
  if not Expanded then Expand;
  FNode.Expand (false);
  Node := FNode.GetFirstChild;
  while Node <> nil do begin
    if TObject (Node.Data) is TGroupNode then begin
      with TGroupNode (Node.Data) do
        if HasFile (Game.Key.Files [AIndex]) then begin
          LocateFileNode (AIndex, PosInfo);
          Exit;
        end;
    end
    else if TObject (Node.Data) is TFileNode then
      with TFileNode (Node.Data) do
        if Index = AIndex then begin
          FNode.TreeView.Selected := Node;
          if MainForm.CurFrame <> nil then
            MainForm.CurFrame.SetPosInfo (PosInfo);
          Exit;
        end;
    Node := FNode.GetNextChild (Node);
  end;
  raise Exception.CreateFmt ('Index %d not found', [AIndex]);
end;

function TGroupNode.HasFile (const ChFile: TChitinFile): boolean;
begin
  Result := false;
end;

{ TSimpleGroupNode }

constructor TSimpleGroupNode.Create (AOwner: TTreeNode; const AName: string);
begin
  inherited Create (AOwner, AName);
  Expanded := true;
end;

procedure TSimpleGroupNode.DoExpand;
begin
  // do nothing
end;

{ TFileTypeNode }

constructor TFileTypeNode.Create (AFileType: TFileType; const AName: string);
begin
  inherited Create (nil, AName);
  FFileType := AFileType;
end;

procedure TFileTypeNode.DoExpand;
var
  i: integer;
begin
  for i := 0 to Length (Game.Key.Files)-1 do
    with Game.Key.Files [i] do
      if FileType = FFileType then
        CreateFileNode (FName, i, FileType);
  FNode.AlphaSort;
end;

function TFileTypeNode.HasFile (const ChFile: TChitinFile): boolean;
begin
  Result := (ChFile.FileType = FFileType);
end;

{ TBIFFGroupNode }

constructor TBIFFGroupNode.Create (AFileType: TFileType;
  const AName: string);
begin
  inherited Create (nil, AName);
  FFileType := AFileType;
end;

procedure TBIFFGroupNode.DoExpand;
var
  i: integer;
  FBIFFs: TStringList;
begin
  FBIFFs := TStringList.Create;
  try
    for i := 0 to Length (Game.Key.Files)-1 do
      with Game.Key.Files [i] do
        if FileType = FFileType then begin
          if FBIFFs.IndexOfObject (TObject (BIFF)) = -1 then
            FBIFFs.AddObject (ExtractFileName (Game.Key.BIFFs [BIFF].FName), TObject (BIFF));
        end;
    if FBIFFs.Count = 1 then begin
      for i := 0 to Length (Game.Key.Files)-1 do
        with Game.Key.Files [i] do
          if FileType = FFileType then
            CreateFileNode (FName, i, FileType)
    end
    else
      for i := 0 to FBIFFs.Count-1 do
        TBIFFNode.Create (FNode, FFileType, Integer (FBIFFs.Objects [i]), FBIFFs [i]);
    FNode.AlphaSort;
  finally
    FBIFFs.Free;
  end;
end;

function TBIFFGroupNode.HasFile (const ChFile: TChitinFile): boolean;
begin
  Result := (FFileType = ChFile.FileType);
end;

{ TBIFFNode }

constructor TBIFFNode.Create (AOwner: TTreeNode; AFileType: TFileType;
  ABIFF: integer; const AName: string);
begin
  inherited Create (AOwner, AName);
  FFileType := AFileType;
  FBIFF := ABIFF;
end;

procedure TBIFFNode.DoExpand;
var
  i: integer;
begin
  for i := 0 to Length (Game.Key.Files)-1 do
    with Game.Key.Files [i] do
      if (FileType = FFileType) and (BIFF = FBIFF) then
        TFileNode.Create (FNode, FName, i, FileType);
  FNode.AlphaSort;
end;

function TBIFFNode.HasFile (const ChFile: TChitinFile): boolean;
begin
  Result := (FBIFF = ChFile.BIFF) and (FFileType = ChFile.FileType);
end;

{ TFileNode }

constructor TFileNode.Create (AOwner: TTreeNode; const AName: string;
    AIndex: integer; AFileType: TFileType);
begin
  Index := AIndex;
  FileType := AFileType;
  ExternalPath := '';
  CreateNode (AOwner, AName);
end;

constructor TFileNode.CreateExternal (AOwner: TTreeNode; const AName,
  APath: string; AFileType: TFileType);
begin
  Index := -1;
  FileType := AFileType;
  ExternalPath := APath;
  CreateNode (AOwner, AName);
end;

function TFileNode.GetGameFile: TGameFile;
var
  F: TStream;
begin
  if Index <> -1 then
    Result := Game.GetFile (Index)
  else begin
    F := CreateFileStream (ExternalPath);
    try
      Result := Game.LoadFileFromStream (F, -1,
          ChangeFileExt (ExtractFileName (ExternalPath), ''), FileType);
    finally
      F.Free;
    end;
  end;
end;

procedure TFileNode.Select;
var
  AFile: TGameFile;
begin
  if Index <> -1 then
    SelectFile (Index)
  else begin
    AFile := GetGameFile;
    MainForm.ViewFile (AFile);
  end;
end;

function TFileNode.GetFlags: TNodeFlags;
begin
  Result := [ienPopup, ienSave];
end;

function TFileNode.GetSaveFileName: string;
begin
  if Index <> -1 then
    Result := Game.Key.Files [Index].FName +
        FileTypeExts [Game.Key.Files [Index].FileType]
  else
    Result := ExtractFileName (ExternalPath);
end;

procedure TFileNode.SaveFile (const FileName: string);
var
  Src, Dest: TStream;
begin
  Dest := TFileStream.Create (FileName, fmCreate);
  Src := Game.Key.CreateStream (Index);
  try
    Dest.CopyFrom (Src, Src.Size);
  finally
    Src.Free;
    Dest.Free;
  end;
end;

{ TAreaNode }

constructor TAreaNode.Create (AOwner: TTreeNode; const AName: string;
  AIndex: integer; AFileType: TFileType);
var
  CDMask: word;
  S: string;
  i: integer;
begin
  inherited Create (AOwner, AName, AIndex, AFileType);
  FNode.HasChildren := true;
  CDMask := Game.Key.GetCDMask (AName, ftMAP);
  if CDMask <> 0 then begin
    {
    if CDMask and 1 <> 0 then
      FNode.Text := FNode.Text + ' (HD)'
    else begin }
      S := '';
      for i := 0 to 7 do
        if CDMask and (1 shl (i+1)) <> 0 then begin
          if S <> '' then S := S + ',';
          S := S + IntToStr (i);
        end;
      if S <> '' then
        FNode.Text := FNode.Text + ' (CD ' + S + ')';
{    end; }
  end;
end;

constructor TAreaNode.CreateExternal (AOwner: TTreeNode; const AName,
  APath: string; AFileType: TFileType);
begin
  inherited CreateExternal (AOwner, AName, APath, AFileType);
  FNode.HasChildren := true;
end;

procedure TAreaNode.Expand;
var
  Area: TAreaFile;
  AFile: TGameFile;
  Name, AreaID: string;

  procedure CreateGroup (const Name: string; NodeClass: TAreaElemNodeClass;
      Count: integer);
  var
    Grp: TAreaGroupNode;
    i: integer;
  begin
    if Count > 0 then begin
      Grp := TAreaGroupNode.Create (FNode, Name, Area, ExternalPath);
      for i := 0 to Count-1 do
        NodeClass.Create (Grp.FNode, Area, i);
    end;
  end;

begin
  Screen.Cursor := crHourglass;
  FNode.Owner.BeginUpdate;
  try
    Area := GetGameFile as TAreaFile;
    if Area <> nil then begin
      Name := Area.Name;
      TAreaGeneralNode.Create (FNode, Area, 0);
      CreateGroup ('NPCs', TAreaNPCNode, Length (Area.NPC));
      CreateGroup ('Triggers', TAreaInfoNode, Length (Area.Info));
      CreateGroup ('Entry points', TAreaEntryNode, Length (Area.Entries));
      CreateGroup ('Containers', TAreaContainerNode, Length (Area.Containers));
      CreateGroup ('Doors', TAreaDoorNode, Length (Area.Doors));
      //CreateGroup ('Tiled objects', TAreaTiledObjNode, Length (Area.TiledObjects));
      CreateGroup ('Animations', TAreaAnimNode, Length (Area.Anims));
      CreateGroup ('Spawn points', TAreaSpawnPointNode, Length (Area.SpawnPoints));
      if Length (Area.Vars) > 0 then
        TAreaVarsNode.Create (FNode, Area, 0);
      AreaId := Area.AreaHdr.AreaId;
      AFile := Game.GetFileByName (AreaID, ftMOS);
      if AFile <> nil then
        TFileNode.Create (FNode, 'Mini-map', AFile.Index, ftMOS);
      AFile := Game.GetFileByName (AreaId + 'HT', ftBMP);
      if AFile <> nil then
        TFileNode.Create (FNode, 'Height map', AFile.Index, ftBMP);
      AFile := Game.GetFileByName (AreaId + 'LM', ftBMP);
      if AFile <> nil then
        TFileNode.Create (FNode, 'Light map', AFile.Index, ftBMP);
      AFile := Game.GetFileByName (AreaId + 'LN', ftBMP);
      if AFile <> nil then
        TFileNode.Create (FNode, 'Night light map', AFile.Index, ftBMP);
      AFile := Game.GetFileByName (AreaId + 'SR', ftBMP);
      if AFile <> nil then
        TFileNode.Create (FNode, 'Search map', AFile.Index, ftBMP);
      AFile := Game.GetFileByName (Name, ftINI);
      if AFile <> nil then
        TFileNode.Create (FNode, 'INI file', AFile.Index, ftINI);
    end;
  finally
    FNode.Owner.EndUpdate;
    Expanded := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TAreaNode.Select;
begin
  inherited Select;
  MainForm.SetExtraFrame (nil);
end;

{ TAreaGroupNode }

constructor TAreaGroupNode.Create (AOwner: TTreeNode; const AName: string;
  AArea: TAreaFile; const AExternalPath: string);
begin
  inherited Create (AOwner, AName);
  Index := AArea.Index;
  ExternalPath := AExternalPath;
end;

procedure TAreaGroupNode.Select;
begin
  SelectExternal (Index, ExternalPath, ftAREA);
  MainForm.SetExtraFrame (nil);
  if MainForm.CurFrame <> nil then
    (MainForm.CurFrame as TAreaFrameProxy).RemoveOverlays;
end;

{ TAreaElemNode }

constructor TAreaElemNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
    const AName: string; const APoint: TPoint);
begin
  AreaIndex := AArea.Index;
  ElemPoint := APoint;
  CreateNode (AOwner, AName);
end;

procedure TAreaElemNode.Select;
var
  OwnerNode: TObject;
  ExternalPath: string;
begin
  // dirty hack!
  OwnerNode := TObject (FNode.Parent.Data);
  Assert (OwnerNode <> nil);
  if OwnerNode is TAreaNode then
    ExternalPath := (OwnerNode as TAreaNode).ExternalPath
  else
    ExternalPath := (OwnerNode as TAreaGroupNode).ExternalPath;
  SelectExternal (AreaIndex, ExternalPath, ftAREA, true);
end;

{ TAreaGeneralNode }

constructor TAreaGeneralNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
begin
  Hdr := AArea.AreaHdr;
  Offsets := AArea.AreaOffsets;
  inherited Create (AOwner, AArea, 'General', Point (0, 0));
end;

procedure TAreaGeneralNode.Select;
begin
  inherited Select;
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaGeneralFrame) then
    MainForm.SetExtraFrame (TAreaGeneralFrame);
  (MainForm.CurFrame as TAreaFrameProxy).RemoveOverlays;
  (MainForm.ExtraFrame as TAreaGeneralFrame).ShowArea (Hdr, Offsets);
end;

{ TAreaNPCNode }

constructor TAreaNPCNode.Create (AOwner: TTreeNode; AArea: TAreaFile; AIndex: integer);
begin
  NPC := AArea.NPC [AIndex].Hdr;
  with NPC do
    inherited Create (AOwner, AArea, Name, Point (CurX, CurY));
end;

procedure TAreaNPCNode.Select;
var
  R: TRect;
begin
  inherited Select;
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaNPCFrame) then
    MainForm.SetExtraFrame (TAreaNPCFrame);
  with NPC do
    R := Rect (CurX-10, CurY-10, CurX+10, CurY+10);
  with MainForm.CurFrame as TAreaFrameProxy do begin
    ScrollToPoint (ElemPoint);
    RemoveOverlays;
    AddOverlayRect (R);
  end;
  (MainForm.ExtraFrame as TAreaNPCFrame).ShowNPC (NPC);
end;

{ TAreaInfoNode }

constructor TAreaInfoNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
var
  P: TPoint;
begin
  Info := AArea.Info [AIndex];
  with Info.Poly.Bounds do
    P := Point ((Left + Right) div 2, (Top + Bottom) div 2);
  with Info do
    inherited Create (AOwner, AArea, Hdr.Id, P);
end;

procedure TAreaInfoNode.Select;
begin
  inherited Select;
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaInfoFrame) then
    MainForm.SetExtraFrame (TAreaInfoFrame);
  with MainForm.CurFrame as TAreaFrameProxy do begin
    ScrollToPoint (ElemPoint);
    RemoveOverlays;
    AddOverlayPoly (Info.Poly);
  end;
  (MainForm.ExtraFrame as TAreaInfoFrame).ShowInfo (Info);
end;

{ TAreaEntryNode }

constructor TAreaEntryNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
begin
  Entry := AArea.Entries [AIndex];
  with Entry do
    inherited Create (AOwner, AArea, Name, Point (X, Y));
end;

procedure TAreaEntryNode.Select;
var
  R: TRect;
begin
  inherited Select;
  with Entry do
    R := Rect (X-10, Y-10, X+10, Y+10);
  MainForm.SetExtraFrame (nil);
  with MainForm.CurFrame as TAreaFrameProxy do begin
    ScrollToPoint (Point (Entry.X, Entry.Y));
    RemoveOverlays;
    AddOverlayRect (R);
  end;
end;

{ TAreaContainerNode }

constructor TAreaContainerNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
var
  AName: string;
begin
  Container := AArea.Containers [AIndex];
  // containers in areas loaded from savegames may have empty names
  with Container do begin
    if Hdr.Name = '' then
      AName := '<no name>'
    else
      AName := Hdr.Name;
    inherited Create (AOwner, AArea, AName, Point (Hdr.X, Hdr.Y));
  end;
end;

procedure TAreaContainerNode.Select;
begin
  inherited Select;
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaCntrFrame) then
    MainForm.SetExtraFrame (TAreaCntrFrame);
  with MainForm.CurFrame as TAreaFrameProxy do begin
    ScrollToPoint (ElemPoint);
    RemoveOverlays;
    // containers in areas loaded from savegames may have empty polys
    with Container do
      if Length (Poly.Points) = 0 then
        AddOverlayRect (Rect (Hdr.X - 10, Hdr.Y - 10, Hdr.X + 10, Hdr.Y + 10))
      else
      AddOverlayPoly (Container.Poly);
  end;
  (MainForm.ExtraFrame as TAreaCntrFrame).ShowContainer (Container);
end;

{ TAreaDoorNode }

constructor TAreaDoorNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
var
  P: TPoint;
begin
  Door := AArea.Doors [AIndex];
  with Door.ClosedPoly.Bounds do
    P := Point ((Left + Right) div 2, (Top + Bottom) div 2);
  with Door do
    inherited Create (AOwner, AArea, Hdr.Name, P);
end;

procedure TAreaDoorNode.Select;
begin
  inherited Select;
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaDoorFrame) then
    MainForm.SetExtraFrame (TAreaDoorFrame);
  with MainForm.CurFrame as TAreaFrameProxy do begin
    ScrollToPoint (ElemPoint);
    RemoveOverlays;
    AddOverlayPoly (Door.ClosedPoly);
  end;
  (MainForm.ExtraFrame as TAreaDoorFrame).ShowDoor (Door);
end;

{ TAreaTiledObjNode }

constructor TAreaTiledObjNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
begin
  TiledObj := AArea.TiledObjects [AIndex];
  with TiledObj do
    inherited Create (AOwner, AArea, Name, Point (0, 0));
end;

{ TAreaAnimNode }

constructor TAreaAnimNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
begin
  Anim := AArea.Anims [AIndex];
  with Anim do
    inherited Create (AOwner, AArea, Name, Point (X, Y));
end;

procedure TAreaAnimNode.Select;
var
  R: TRect;
begin
  inherited Select;
  with Anim do
    R := Rect (X-10, Y-10, X+10, Y+10);
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaAnimFrame) then
    MainForm.SetExtraFrame (TAreaAnimFrame);
  with MainForm.CurFrame as TAreaFrameProxy do begin
    ScrollToPoint (Point (Anim.X, Anim.Y));
    RemoveOverlays;
    AddOverlayRect (R);
  end;
  (MainForm.ExtraFrame as TAreaAnimFrame).ShowAnim (Anim);
end;

{ TAreaSpawnPointNode }

constructor TAreaSpawnPointNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
begin
  Spawn := AArea.SpawnPoints [AIndex];
  with Spawn do
    inherited Create (AOwner, AArea, Name, Point (X, Y));
end;

procedure TAreaSpawnPointNode.Select;
var
  R: TRect;
begin
  inherited Select;
  with Spawn do
    R := Rect (X-10, Y-10, X+10, Y+10);
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaSpawnFrame) then
    MainForm.SetExtraFrame (TAreaSpawnFrame);
  with MainForm.CurFrame as TAreaFrameProxy do begin
    ScrollToPoint (Point (Spawn.X, Spawn.Y));
    RemoveOverlays;
    AddOverlayRect (R);
  end;
  (MainForm.ExtraFrame as TAreaSpawnFrame).ShowSpawn (Spawn);
end;

{ TAreaVarsNode }

constructor TAreaVarsNode.Create (AOwner: TTreeNode; AArea: TAreaFile;
  AIndex: integer);
var
  i: integer;
begin
  SetLength (Vars, Length (AArea.Vars));
  for i := 0 to Length (AArea.Vars)-1 do
    Vars [i] := AArea.Vars [i];
  inherited Create (AOwner, AArea, 'Variables', Point (0, 0));
end;

procedure TAreaVarsNode.Select;
begin
  inherited Select;
  if (MainForm.ExtraFrame = nil) or not (MainForm.ExtraFrame is TAreaVarsFrame) then
    MainForm.SetExtraFrame (TAreaVarsFrame);
  (MainForm.CurFrame as TAreaFrameProxy).RemoveOverlays;
  (MainForm.ExtraFrame as TAreaVarsFrame).ShowVars (Vars);
end;

{ TChUINode }

constructor TChUINode.Create (AOwner: TTreeNode; const AName: string;
  AIndex: integer; AFileType: TFileType);
begin
  inherited Create (AOwner, AName, AIndex, AFileType);
  FNode.HasChildren := true;
end;

constructor TChUINode.CreateExternal (AOwner: TTreeNode; const AName,
  APath: string; AFileType: TFileType);
begin
  inherited CreateExternal (AOwner, AName, APath, AFileType);
  FNode.HasChildren := true;
end;

procedure TChUINode.Expand;
var
  ChUI: TChUIFile;
  i: integer;
begin
  Screen.Cursor := crHourglass;
  FNode.Owner.BeginUpdate;
  try
    ChUI := GetGameFile as TChUIFile;
    for i := 0 to Length (ChUI.Panels)-1 do
      TChUIPanelNode.Create (FNode, ChUI.Panels [i]);
  finally
    FNode.Owner.EndUpdate;
    Expanded := true;
    Screen.Cursor := crDefault;
  end;
end;

{ TChUIPanelNode }

constructor TChUIPanelNode.Create (AOwner: TTreeNode; const APanel: TChUIPanel);
begin
  Panel := APanel;
  CreateNode (AOwner, Panel.Name);
end;

procedure TChUIPanelNode.Select;
begin
  with MainForm do begin
    if not (CurFrame is TChUIFrameProxy) then begin
      CloseFrame;
      FCurFrame := TChUIFrameProxy.Create (MainForm);
      FCurFrame.SetFrameParent (Panel3);
      CurFile := nil;
      CurFileType := ftNone;
    end;
    (CurFrame as TChUIFrameProxy).ViewChUIPanel (Panel);
  end;
end;

{ TWorldMapNode }

constructor TWorldMapNode.Create (AOwner: TTreeNode; const AName, AResRef: string);
var
  WMap: TWMapFile;
begin
  inherited Create (AOwner, AName);
  WMap := Game.GetFileByName (AResRef, ftWMAP) as TWMapFile;
  try
    Assert (Length (WMap.Maps) > 0);
    Map := WMap.Maps [0];
  finally
    Game.FreeFile (WMap);
  end;
end;

constructor TWorldMapNode.CreateExternal (AOwner: TTreeNode; const AName,
  APath: string);
var
  WMap: TWMapFile;
  F: TStream;
begin
  inherited Create (AOwner, AName);
  F := CreateFileStream (APath);
  try
    WMap := Game.LoadFileFromStream (F, -1,
        ChangeFileExt (ExtractFileName (APath), ''), ftWMAP) as TWMapFile;
    Assert (Length (WMap.Maps) > 0);
    Map := WMap.Maps [0];
    Game.FreeFile (WMap);
  finally
    F.Free;
  end;
end;

procedure TWorldMapNode.DoExpand;
var
  i: integer;
begin
  for i := 0 to Length (Map.Areas)-1 do
    TWorldMapAreaNode.Create (FNode, @Map, i);
end;

{ TWorldMapAreaNode }

constructor TWorldMapAreaNode.Create (AOwner: TTreeNode; AMap: PWorldMap;
  AIndex: integer);
var
  AName: string;
begin
  Map := AMap;
  Index := AIndex;
  AName := PChar8ToStr (Map.Areas [Index].AreaId1);
  if AName = '' then
    AName := 'Area ' + IntToStr (Index);
  CreateNode (AOwner, AName);
end;

procedure TWorldMapAreaNode.Select;
begin
  with MainForm do begin
    if not (CurFrame is TWMapAreaFrameProxy) then begin
      CloseFrame;
      FCurFrame := TWMapAreaFrameProxy.Create (MainForm);
      CurFrame.SetFrameParent (Panel3);
      CurFile := nil;
      CurFileType := ftNone;
    end;
    (CurFrame as TWMapAreaFrameProxy).ViewWMapArea (Map, Index);
  end;
end;

{ TQuestsNode }

constructor TQuestsNode.Create (const FName: string);
begin
  inherited Create (nil, 'Quests');
  FFileName := FName;
  FQuestsIni := nil;
end;

destructor TQuestsNode.Destroy;
begin
  FQuestsIni.Free;
  inherited Destroy;
end;

procedure TQuestsNode.DoExpand;
var
  i: integer;
begin
  if FQuestsIni = nil then
    FQuestsIni := TQuestsIni.Create (FFileName);
  for i := 0 to Length (FQuestsIni.Quests)-1 do
    TQuestNode.Create (FNode, FQuestsIni.Quests [i]);
end;

{ TQuestNode }

constructor TQuestNode.Create (AOwner: TTreeNode; const AQuest: TQuest);
begin
  Quest := AQuest;
  CreateNode (AOwner, Game.TLK.Text [Quest.TitleIndex]);
end;

procedure TQuestNode.Select;
begin
  with MainForm do begin
    if not (CurFrame is TQuestFrameProxy) then begin
      CloseFrame;
      FCurFrame := TQuestFrameProxy.Create (MainForm);
      CurFrame.SetFrameParent (Panel3);
      CurFile := nil;
      CurFileType := ftNone;
    end;
    (CurFrame as TQuestFrameProxy).ViewQuest (Quest);
  end;
end;

{ TSaveGamesNode }

constructor TSaveGamesNode.Create (AGameList: TSaveGameList;
  const Name: string);
begin
  inherited Create (nil, Name);
  FGameList := AGameList;
end;

procedure TSaveGamesNode.DoExpand;
var
  i: integer;
begin
  for i := 0 to FGameList.Count-1 do
    TSaveGameNode.Create (FNode, FGameList [i]);
end;

{ TSaveGameNode }

constructor TSaveGameNode.Create (AOwner: TTreeNode; ASaveGame: TSaveGame);
begin
  SaveGame := ASaveGame;
  inherited Create (AOwner, ASaveGame.Name);
end;

procedure TSaveGameNode.DoExpand;
var
  Grp, GrpAreas, GrpStores, GrpWorldmaps: TSimpleGroupNode;
  i: integer;
  FName, Ext: string;
  WorldMaps: TStringList;
begin
  SaveGame.Load;
  if Length (SaveGame.Party) > 0 then begin
    Grp := TSimpleGroupNode.Create (FNode, 'Party');
    for i := 0 to Length (SaveGame.Party)-1 do
      TSaveGameCharNode.Create (Grp.FNode, SaveGame.Party [i]);
  end;
  if Length (SaveGame.NPC) > 0 then begin
    Grp := TSimpleGroupNode.Create (FNode, 'NPC');
    for i := 0 to Length (SaveGame.NPC)-1 do
      TSaveGameCharNode.Create (Grp.FNode, SaveGame.NPC [i]);
  end;
  GrpAreas := TSimpleGroupNode.Create (FNode, 'Areas');
  GrpStores := TSimpleGroupNode.Create (FNode, 'Stores');
  for i := 0 to SaveGame.SavFiles.Count-1 do begin
    FName := ChangeFileExt (ExtractFileName (SaveGame.SavFiles [i]), '');
    Ext := ExtractFileExt (SaveGame.SavFiles [i]);
    if SameText (Ext, '.ARE') then
      GrpAreas.CreateExternalFileNode (SaveGame.SavFiles [i], ftAREA, FName)
    else if SameText (Ext, '.STO') then
      GrpStores.CreateExternalFileNode (SaveGame.SavFiles [i], ftSTOR, FName);
  end;
  WorldMaps := TStringList.Create;
  try
    FindAllFiles (SaveGame.SavePath, '*.WMP', WorldMaps);
    if WorldMaps.Count = 1 then
      CreateExternalFileNode (WorldMaps [0], ftWMAP, 'World map')
    else if WorldMaps.Count > 1 then begin
      GrpWorldmaps := TSimpleGroupNode.Create (FNode, 'World maps');
      for i := 0 to WorldMaps.Count-1 do
        GrpWorldmaps.CreateExternalFileNode (WorldMaps [i], ftWMAP,
            ChangeFileExt (ExtractFileName (WorldMaps [i]), ''));
    end;
  finally
    WorldMaps.Free;
  end;
end;

procedure TSaveGameNode.Select;
begin
  with MainForm do begin
    SetExtraFrame (nil);
    if not (CurFrame is TSaveGameFrameProxy) then begin
      CloseFrame;
      FCurFrame := TSaveGameFrameProxy.Create (MainForm);
      CurFrame.SetFrameParent (Panel3);
      CurFile := nil;
      CurFileType := ftNone;
    end;
    (CurFrame as TSaveGameFrameProxy).ViewSaveGame (SaveGame);
  end;
end;

{ TSaveGameCharNode }

constructor TSaveGameCharNode.Create (AOwner: TTreeNode;
  AChar: TSaveGameCharacter);
var
  AName: string;
begin
  Char := AChar;
  AName := Char.Name;
  if AName = '' then
    AName := Char.CRE.Name;
  if AName = '' then
    AName := Char.CRE.TLKName;
  CreateNode (AOwner, AName);
end;

procedure TSaveGameCharNode.Select;
begin
  if Char.CRE <> nil then begin
    MainForm.ViewFile (Char.CRE);
    with MainForm.CurFrame as TCREFrameProxy do begin
      ViewPartyCommon (Char.PartyCommon);
      ViewStatistics (Char.Stats);
    end;
  end
  else
    with MainForm.lblNoCD do begin
      Visible := true;
      Caption := 'Failed to load the CRE file';
    end;
end;

function TSaveGameCharNode.GetFlags: TNodeFlags;
begin
  Result := [ienPopup, ienSave];
end;

function TSaveGameCharNode.GetSaveFileName: string;
begin
  Result := Copy (Char.Name, 1, 8) + '.cre';
end;

procedure TSaveGameCharNode.SaveFile (const FileName: string);
var
  F: TFileStream;
begin
  F := TFileStream.Create (FileName, fmCreate);
  try
    F.Write (Char.CREData [0], Length (Char.CREData));
  finally
    F.Free;
  end;
end;

{ TFrameProxy }

constructor TFrameProxy.Create (AOwner: TComponent);
begin
  FFrame := nil;
  FOwner := AOwner;
  FFrameClass := nil;
end;

procedure TFrameProxy.SetFrameParent (AParent: TWinControl);
begin
  if not Assigned (FFrameClass) then
    raise Exception.Create ('Unknown frame class');
  if FFrame = nil then FFrame := FFrameClass.Create (FOwner);
  FFrame.Parent := AParent;
end;

procedure TFrameProxy.ViewFile (AFile: TGameFile);
begin
  if not Assigned (FFrameClass) then
    raise Exception.Create ('Unknown frame class');
  if FFrame = nil then FFrame := FFrameClass.Create (FOwner);
  DoViewFile (AFile);
end;

procedure TFrameProxy.CloseFile;
begin
  // do nothing
end;

procedure TFrameProxy.FreeFrame;
begin
  FFrame.Free;
  Free;
end;

function TFrameProxy.CanSearch: TSearchTypes;
begin
  Result := [];
end;

function TFrameProxy.DoSearch (AFile: TGameFile; SearchPos: TSearchPos): boolean;
begin
  Result := false;
end;

procedure TFrameProxy.LocatePos (SearchPos: TSearchPos);
begin
  // do nothing
end;

function TFrameProxy.GetExportFilter: string;
begin
  Result := '';
end;

procedure TFrameProxy.ExportFile (const FName: string; FilterIndex: integer);
begin
  // do nothing
end;

procedure TFrameProxy.GetPosInfo (var PosInfo: pointer);
begin
  // do nothing
end;

procedure TFrameProxy.SetPosInfo (PosInfo: pointer);
begin
  // do nothing
end;

{ TMainForm }

procedure TMainForm.FormCreate (Sender: TObject);
begin
  Game := nil;
  FCurFrame := nil;
  Ini := TRegistryIniFile.Create ('Software\Yoletir\InfExp');
  GamePath := Ini.ReadString ('General', 'GamePath', '');
  tvItems.Width := Ini.ReadInteger ('General', 'tvItemsWidth', tvItems.Width);
  tvDialogHeight := Ini.ReadInteger ('General', 'tvDialogHeight', -1);
  CodeSearchDialogs := Ini.ReadBool ('General', 'CodeSearchDialogs', true);
  CodeSearchScripts := Ini.ReadBool ('General', 'CodeSearchScripts', true);
  ExternalFilesNode := nil;
  RootNodes := TList.Create;
  BrowseStack := TList.Create;
  BrowseStackPos := 0;
  CodeSearchStr := '';
  SearchPos := nil;
end;

procedure TMainForm.FormPaint (Sender: TObject);
begin
  OnPaint := nil;
  actOpenGame.Execute;
end;

procedure TMainForm.actOpenGameUpdate (Sender: TObject);
begin
  actOpenGame.Enabled := not Searching;
end;

procedure TMainForm.actOpenGameExecute (Sender: TObject);
var
  Dlg: TOpenGameDialog;

  procedure AddWorldmap;
  var
    i, WorldmapCount: integer;
    Grp: TSimpleGroupNode;
  begin
    WorldmapCount := 0;
    for i := 0 to Length (Game.Key.Files)-1 do
      if Game.Key.Files [i].FileType = ftWMAP then
        Inc (WorldmapCount);
    if WorldmapCount = 1 then
      TWorldMapNode.Create (nil, 'World map', 'WORLDMAP')
    else if WorldmapCount > 1 then begin
      Grp := TSimpleGroupNode.Create (nil, 'World maps');
      for i := 0 to Length (Game.Key.Files)-1 do
        if Game.Key.Files [i].FileType = ftWMAP then
          TWorldMapNode.Create (Grp.FNode, Game.Key.Files [i].FName,
               Game.Key.Files [i].FName);
    end;
  end;

begin
  Dlg := TOpenGameDialog.Create (Self);
  with Dlg do begin
    EdtGamePath.Text := GamePath;
    if ShowModal <> mrOk then Exit;
    Screen.Cursor := crHourglass;
    try
      FreeGame;
      try
        TInfinityGame.Create (EdtGamePath.Text);
      except
        on E: Exception do begin
          MessageDlg (E.Message, mtError, [mbOk], 0);
          Exit;
        end;
      end;
      Self.Caption := 'Infinity Explorer - ' + EdtGamePath.Text;
      lblNoCD.Visible := false;
      Game.Key.OnNeedCD := GameNeedCD;
      Game.Key.IgnoreOverrides := chkIgnoreOverrides.Checked;
      RootNodes.Add (TFileTypeNode.Create (ftArea, 'Areas'));
      RootNodes.Add (TBIFFGroupNode.Create (ftBAM, 'Graphics (BAM)'));
      RootNodes.Add (TFileTypeNode.Create (ftMOS, 'Graphics (MOS)'));
      RootNodes.Add (TFileTypeNode.Create (ftBMP, 'Graphics (BMP)'));
      RootNodes.Add (TFileTypeNode.Create (ftDLG, 'Dialogs'));
      //TBIFFGroupNode.Create (ftWAV, 'Sounds');
      RootNodes.Add (TBIFFGroupNode.Create (ftScript, 'Scripts'));
      RootNodes.Add (TFileTypeNode.Create (ftCRE, 'Creatures'));
      RootNodes.Add (TFileTypeNode.Create (ftITM, 'Items'));
      RootNodes.Add (TFileTypeNode.Create (ftSPL, 'Spells'));
      RootNodes.Add (TFileTypeNode.Create (ftSTOR, 'Stores'));
      RootNodes.Add (TFileTypeNode.Create (ft2DA, '2DA files'));
      //TFileTypeNode.Create (ftWED, '.WED files');
      RootNodes.Add (TFileTypeNode.Create (ftIDS, 'IDS files'));
      //TFileTypeNode.Create (ftEFF, 'EFF files');
      //TFileTypeNode.Create (ftVVC, 'VVC files');
      //TFileTypeNode.Create (ftPRO, 'Projectiles');
      //TFileTypeNode.Create (ftWFX, 'WFX files');
      //TFileTypeNode.Create (ftPLT, 'PLT files');
      RootNodes.Add (TFileTypeNode.Create (ftCHU, 'CHU files'));
      TFileTypeNode.Create (ftMVE, 'Movies');
      AddWorldmap;
      if Game.GameType <> gtBaldur then
        TFileTypeNode.Create (ftINI, 'INI files');
      GamePath := EdtGamePath.Text;
      DC := TScriptDecompiler.Create;
      if FileExists (MkPath ('quests.ini', EdtGamePath.Text)) then
        TQuestsNode.Create (MkPath ('quests.ini', EdtGamePath.Text));
      if Game.SaveGames.Count > 0 then
        TSaveGamesNode.Create (Game.SaveGames, 'Savegames');
      if Game.MPSaveGames.Count > 0 then
        TSaveGamesNode.Create (Game.MPSaveGames, 'Multiplayer savegames');
      EdtLocate.Enabled := true;
    finally
      Screen.Cursor := crDefault;
    end;
    Free;
  end;
end;

procedure TMainForm.FreeGame;
var
  i: integer;
begin
  CloseFrame;
  FreeAndNil (ExtraFrame);
  FreeAndNil (SearchPos);
  FreeAndNil (DC);
  CurFile := nil;
  Game.Free;
  RootNodes.Clear;
  with tvItems do begin
    Items.BeginUpdate;
    for i := 0 to Items.Count-1 do
      if Items [i].Data <> nil then TObject (Items [i].Data).Free;
    Items.Clear;
    Items.EndUpdate;
  end;
  EdtLocate.Enabled := false;
  for i := BrowseStack.Count-1 downto 0 do
    TObject (BrowseStack [i]).Free;
  BrowseStack.Clear;
  BrowseStackPos := 0;
end;

procedure TMainForm.FormClose (Sender: TObject; var Action: TCloseAction);
begin
  FreeGame;
  Ini.WriteString ('General', 'GamePath', GamePath);
  Ini.WriteInteger ('General', 'tvItemsWidth', tvItems.Width);
  Ini.WriteInteger ('General', 'tvDialogHeight', tvDialogHeight);
  Ini.WriteBool ('General', 'CodeSearchDialogs', CodeSearchDialogs);
  Ini.WriteBool ('General', 'CodeSearchScripts', CodeSearchScripts);
  Ini.Free;
  RootNodes.Free;
  BrowseStack.Free;
end;

function TMainForm.CreateFileFrame (AFileType: TFileType): TFrameProxy;
begin
  case AFileType of
    ftMOS: Result := TMOSFrameProxy.Create (Self);
    ftBAM: Result := TBAMFrameProxy.Create (Self);
    ftBMP: Result := TBMPFrameProxy.Create (Self);
    ftDLG: Result := TDlgFrameProxy.Create (Self);
    //ftWAV: CurFrame := TWAVFrame.Create (MainForm);
    ftScript: Result := TScriptFrameProxy.Create (Self);
    ftArea: Result := TAreaFrameProxy.Create (Self);
    ftINI: Result := TIniFrameProxy.Create (Self);
    ftIDS: Result := TIDSFrameProxy.Create (Self);
    ft2DA: Result := T2DAFrameProxy.Create (Self);
    ftCRE: Result := TCREFrameProxy.Create (Self);
    ftITM: Result := TITMFrameProxy.Create (Self);
    ftSPL: Result := TSPLFrameProxy.Create (Self);
    ftSTOR: Result := TStoreFrameProxy.Create (Self);
    else Result := nil;
  end;
end;

procedure TMainForm.ViewFile (AFile: TGameFile; KeepExtraFrame: boolean = false);
begin
  if (CurFile <> nil) and (CurFile.Index = AFile.Index)
      and (CurFile.Index <> -1)
  then
    Exit;
  if (ExtraFrame <> nil) and not KeepExtraFrame then
    FreeAndNil (ExtraFrame);
  if CurFrame <> nil then
    CurFrame.CloseFile;
  if (CurFrame = nil) or (CurFileType <> AFile.FileType) then begin
    if CurFrame <> nil then begin
      CurFrame.FreeFrame;
      Pointer (FCurFrame) := nil;
    end;
    FCurFrame := CreateFileFrame (AFile.FileType);
    if CurFrame <> nil then begin
      CurFrame.SetFrameParent (Panel3);
      CurFileType := AFile.FileType;
    end;
  end;
  // view file
  if CurFrame <> nil then
    CurFrame.ViewFile (AFile);
  CurFile := AFile;
end;

procedure TMainForm.CloseFrame;
begin
  if CurFrame <> nil then begin
    CurFrame.CloseFile;
    CurFrame.FreeFrame;
    Pointer (FCurFrame) := nil;
  end;
end;

procedure TMainForm.SetExtraFrame (C: TFrameClass);
begin
  if ExtraFrame <> nil then FreeAndNil (ExtraFrame);
  if C <> nil then begin
    ExtraFrame := C.Create (Self);
    ExtraFrame.Parent := Panel3;
  end;
end;

procedure TMainForm.tvItemsExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  InfExpNode: TInfExpNode;
begin
  InfExpNode := TObject (Node.Data) as TInfExpNode;
  if (InfExpNode <> nil) and not InfExpNode.Expanded then
    InfExpNode.Expand;
end;

procedure TMainForm.tvItemsChange (Sender: TObject; Node: TTreeNode);
begin
  if (Node.Data = nil) or not (TObject (Node.Data) is TInfExpNode) then Exit;
  TInfExpNode (Node.Data).Select;
  StatusBar1.Panels [1].Text := Format ('%d files loaded', [Game.FilesLoaded]);
end;

procedure TMainForm.tvItemsContextPopup (Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if (tvItems.Selected <> nil) and (tvItems.Selected.Data <> nil) and
      (ienPopup in TInfExpNode (tvItems.Selected.Data).GetFlags)
  then begin
    MousePos := tvItems.ClientToScreen (MousePos);
    mnuFilePopup.Popup (MousePos.X, MousePos.Y);
    Handled := true;
  end;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.actSaveCurrentUpdate (Sender: TObject);
begin
  actSaveCurrent.Enabled := (tvItems.Selected <> nil)
      and (ienSave in TInfExpNode (tvItems.Selected.Data).GetFlags) and not Searching;
end;

procedure TMainForm.actSaveCurrentExecute(Sender: TObject);
var
  Node: TInfExpNode;
begin
  Node := TInfExpNode (tvItems.Selected.Data);
  with SaveDialog1 do begin
    FileName := Node.GetSaveFileName;
    if not Execute then Exit;
  end;
  Node.SaveFile (SaveDialog1.FileName);
end;

procedure TMainForm.actExportUpdate (Sender: TObject);
begin
  actExport.Enabled := (CurFrame <> nil) and (CurFile <> nil) and
      (CurFile.Index <> -1) and (CurFrame.GetExportFilter <> '') and not Searching;
end;

procedure TMainForm.actExportExecute (Sender: TObject);
begin
  with DlgExport do begin
    Filter := CurFrame.GetExportFilter;
    FileName := Game.Key.Files [CurFile.Index].FName;
    if not Execute then Exit;
    Screen.Cursor := crHourglass;
    try
      CurFrame.ExportFile (FileName, FilterIndex);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TMainForm.GameNeedCD (CD_Number: integer);
begin
  if MessageDlg (Format ('Please insert game CD %d', [CD_Number]),
      mtConfirmation, [mbOk, mbCancel], 0) = mrCancel
  then
    raise ENoCD.Create ('CD not available');
end;

procedure TMainForm.actAboutExecute (Sender: TObject);
var
  Frm: TAboutDialog;
begin
  Frm := TAboutDialog.Create (Self);
  with Frm do begin
    ShowModal;
    Free;
  end;
end;

procedure TMainForm.actOpenExternalUpdate (Sender: TObject);
begin
  (Sender as TAction).Enabled := (Game <> nil) and not Searching;
end;

procedure TMainForm.actOpenExternalExecute (Sender: TObject);
var
  Ext: string;
  FT, FileType: TFileType;
  Found: boolean;
  Node: TInfExpNode;
begin
  if not OpenDialog1.Execute then Exit;
  Ext := ExtractFileExt (OpenDialog1.FileName);
  if SameText (Ext, '.BS') then
    FileType := ftScript
  else begin
    Found := false;
    FileType := ftBMP;   // shut down compiler warning
    for FT := Low (TFileType) to High (TFileType) do
      if SameText (FileTypeExts [FT], Ext) then begin
        FileType := FT;
        Found := true;
        Break;
      end;
    if not Found then begin
      MessageDlg (Format ('File %s has an unrecognized extension and therefore cannot be displayed',
          [OpenDialog1.FileName]),
          mtError, [mbOk], 0);
      Exit;
    end;
  end;
  if ExternalFilesNode = nil then
    ExternalFilesNode := TSimpleGroupNode.Create (nil, 'External files');
  Node := ExternalFilesNode.CreateExternalFileNode (OpenDialog1.FileName, FileType);
  tvItems.Selected := Node.FNode;
end;

function TMainForm.LocateFile (Index: integer; NeedPush: boolean;
    PosInfo: pointer): boolean;
var
  i: integer;
  ChFile: TChitinFile;
begin
  ChFile := Game.Key.Files [Index];
  for i := 0 to RootNodes.Count-1 do begin
    if TObject (RootNodes [i]) is TGroupNode then
      with TGroupNode (RootNodes [i]) do begin
        if not HasFile (ChFile) then Continue;
        if NeedPush then PushPosition;
        LocateFileNode (Index, PosInfo);
        Result := true;
        Exit;
      end;
  end;
  Result := false;
end;

procedure TMainForm.LocateFileByName (const Name: string);
var
  Ext, AName: string;
  FT, aFT: TFileType;
  P: integer;
begin
  FT := ftNone;
  AName := Name;
  P := Pos ('.', Name);
  if P <> 0 then begin
    Ext := ExtractFileExt (Name);
    for aFT := Low (TFileType) to High (TFileType) do
      if SameText (FileTypeExts [aFT], Ext) then begin
        FT := aFT;
        Break;
      end;
    if FT = ftNone then begin
      MessageDlg (Format ('Unknown file extension %s', [Ext]), mtError, [mbOk], 0);
      Exit;
    end;
    AName := Copy (Name, 1, P-1);
  end;
  if not BrowseToFileEx (AName, FT, nil) then
    MessageDlg (Format ('File %s was not found', [Name]), mtError, [mbOk], 0);
end;

procedure TMainForm.EdtLocateKeyDown (Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  StrRef: integer;
begin
  if Key = VK_RETURN then begin
    StrRef := StrToIntDef (EdtLocate.Text, -1);
    if StrRef <> -1 then
      LookupStrref (StrRef)
    else
      LocateFileByName (EdtLocate.Text);
  end;
end;

procedure TMainForm.actLocateExecute(Sender: TObject);
begin
  EdtLocate.SetFocus;
end;

// browsing

type
  TBrowseStackElem = class
    Node: TTreeNode;
    PosInfo: pointer;
  end;

procedure TMainForm.JumperJump (Sender: TObject; const Link: String;
  FileType: TFileType);
begin
  BrowseToFile (Link, FileType);
end;

procedure TMainForm.BrowseToFile (const Name: string; FileType: TFileType);
begin
  BrowseToFileEx (Name, FileType, nil);
end;

function TMainForm.BrowseToFileEx (const Name: string; FileType: TFileType;
  PosInfo: pointer): boolean;
var
  i: integer;
begin
  Result := false;
  Screen.Cursor := crHourglass;
  try
    for i := 0 to Length (Game.Key.Files)-1 do
      if SameText (Game.Key.Files [i].FName, Name) and
          (((FileType = ftNone) and not (Game.Key.Files [i].FileType in [ftMAP, ftWED]))
            or (Game.Key.Files [i].FileType = FileType))
      then begin
        Result := true;
        LocateFile (i, true, PosInfo);
        Exit;
      end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.BrowseToLink (const LinkText: string);
var
  StrRef: integer;
begin
  if LinkText [1] in ['0'..'9'] then begin
    StrRef := StrToIntDef (LinkText, -1);
    if (StrRef >= 0) and Game.TLK.ValidID (StrRef) then begin
      LookupStrref (StrRef);
      Exit;
    end;
  end;
  BrowseToFile (LinkText, ftNone);
end;

procedure TMainForm.PushPosition;
var
  i: integer;
  Elem: TBrowseStackElem;
begin
  // destroy items higher than current position
  for i := BrowseStack.Count-1 downto BrowseStackPos do begin
    TBrowseStackElem (BrowseStack [i]).Free;
    BrowseStack.Delete (i);
  end;
  if CurFrame <> nil then begin
    Elem := TBrowseStackElem.Create;
    Elem.Node := tvItems.Selected;
    CurFrame.GetPosInfo (Elem.PosInfo);
    BrowseStack.Add (Elem);
    Inc (BrowseStackPos);
  end;
end;

procedure TMainForm.RestorePosition;
begin
  with TBrowseStackElem (BrowseStack [BrowseStackPos]) do begin
    tvItems.Selected := Node;
    CurFrame.SetPosInfo (PosInfo);
  end;
end;

procedure TMainForm.actBackUpdate (Sender: TObject);
begin
  actBack.Enabled := (BrowseStackPos > 0) and not Searching;
end;

procedure TMainForm.actBackExecute (Sender: TObject);
begin
  if CurFrame is TBAMFrameProxy then
    BAMStopPlaying := true;
  if CurFrame <> nil then begin
    PushPosition;
    Dec (BrowseStackPos, 2);
  end
  else
    Dec (BrowseStackPos);
  RestorePosition;
end;

procedure TMainForm.actForwardUpdate (Sender: TObject);
begin
  actForward.Enabled := (BrowseStackPos < BrowseStack.Count-1) and not Searching;
end;

procedure TMainForm.actForwardExecute (Sender: TObject);
begin
  Inc (BrowseStackPos);
  RestorePosition;
end;

// search code

constructor TSearchPos.Create (ASearchType: TSearchType; const AStr: string;
    AFileTypes: TFileTypes);
begin
  SearchType := ASearchType;
  FileTypes := AFileTypes;
  FileType := Low (TFileType);
  Index := 0;
  Str := AStr;
  FUserData := nil;
end;

destructor TSearchPos.Destroy;
begin
  if FUserData <> nil then FUserData.Free;
  inherited;
end;

procedure TSearchPos.SetUserData (const Value: TObject);
begin
  if FUserData <> nil then FUserData.Free;
  FUserData := Value;
end;

procedure TMainForm.actSearchForCodeExecute (Sender: TObject);
var
  Frm: TSearchCodeDlg;
  FileTypes: TFileTypes;
begin
  // cancel previous search
  FreeAndNil (SearchPos);
  Frm := TSearchCodeDlg.Create (Self);
  with Frm do begin
    EdtCodeString.Text := CodeSearchStr;
    ChkSearchDialogs.Checked := CodeSearchDialogs;
    ChkSearchScripts.Checked := CodeSearchScripts;
    if ShowModal = mrOk then begin
      CodeSearchStr := EdtCodeString.Text;
      CodeSearchDialogs := ChkSearchDialogs.Checked;
      CodeSearchScripts := ChkSearchScripts.Checked;
      Free;
      if CodeSearchStr = '' then Exit;
      FileTypes := [];
      if CodeSearchDialogs then Include (FileTypes, ftDLG);
      if CodeSearchScripts then Include (FileTypes, ftScript);
      if FileTypes = [] then Exit;
      SearchPos := TSearchPos.Create (stCode, CodeSearchStr, FileTypes);
      DoSearch;
    end;
  end;
end;

procedure TMainForm.actSearchAgainUpdate (Sender: TObject);
begin
  actSearchAgain.Enabled := (SearchPos <> nil) and not Searching;
end;

procedure TMainForm.actSearchAgainExecute (Sender: TObject);
begin
  DoSearch;
end;

procedure TMainForm.actCancelSearchExecute (Sender: TObject);
begin
  if Searching then Searching := false;
end;

// A separate invisible frame instance is created for searching. If the search
// results in a success, the search frame is destroyed, then the "real" frame
// is positioned to the file in which the text has been found, and then LocatePos
// is called to show the exact place in the file where the search string is
// present.

procedure TMainForm.DoSearch;
var
  FT: TFileType;
  SearchFrame: TFrameProxy;
  Index: integer;
  AFile: TGameFile;
  MR: TModalResult;
  LastTickCount, CurTickCount: integer;
begin
  if SearchPos = nil then Exit;
  Screen.Cursor := crHourglass;
  StatusBar1.Panels [0].Text := 'Searching... (Esc to cancel)';
  Searching := true;
  LastTickCount := 0;
  try
    for FT := SearchPos.FileType to High (TFileType) do begin
      if not (FT in SearchPos.FileTypes) then Continue;
      SearchFrame := CreateFileFrame (FT);
      if (SearchFrame <> nil) and (SearchPos.SearchType in SearchFrame.CanSearch) then begin
        for Index := SearchPos.Index to Length (Game.Key.Files)-1 do
          if Game.Key.Files [Index].FileType = FT then begin
            if Index > SearchPos.Index then
              SearchPos.UserData := nil;
            AFile := nil;
            try
              AFile := Game.GetFile (Index);
              CurTickCount := GetTickCount;
              if CurTickCount - LastTickCount > 500 then begin
                StatusBar1.Panels [0].Text := Format ('Searching %s%s... (Esc to cancel)',
                   [AFile.Name, FileTypeExts [AFile.FileType]]);
                LastTickCount := CurTickCount;
              end;
              Application.ProcessMessages;
              if SearchFrame.DoSearch (AFile, SearchPos) then begin
                SearchFrame.FreeFrame;
                LocateFile (Index, false, nil);
                if CurFrame <> nil then
                  CurFrame.LocatePos (SearchPos);
                SearchPos.FileType := FT;
                SearchPos.Index := Index;
                Searching := false;
                Exit;
              end;
            except
              on E: Exception do begin
                MR := MessageDlg (Format ('Error searching %s%s: %s. Continue search?',
                    [Game.Key.Files [Index].FName, FileTypeExts [Game.Key.Files [Index].FileType], E.Message]),
                    mtError, mbOkCancel, 0);
                if MR = mrCancel then begin
                  SearchFrame.FreeFrame;
                  Searching := false;
                end;
              end;
            end;
            if AFile <> nil then Game.FreeFile (AFile);
            if not Searching then begin // search cancelled
               FreeAndNil (SearchPos);
               Exit;
            end;
          end;
        SearchPos.Index := 0;
        SearchFrame.FreeFrame;
        SearchPos.UserData := nil;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    StatusBar1.Panels [0].Text := '';
  end;
  MessageDlg (Format ('Found no more occurrences of %s', [SearchPos.Str]),
      mtInformation, [mbOk], 0);
  Searching := false;
  FreeAndNil (SearchPos);
end;

// strref lookup

procedure TMainForm.actLookupStrrefExecute (Sender: TObject);
begin
  LookupStrref (-1);
end;

procedure TMainForm.LookupStrref (StrRef: integer);
var
  Frm: TStrrefForm;
begin
  Frm := TStrrefForm.Create (Self);
  try
    if (StrRef = -1) or Frm.LookupStrref (StrRef) then
      Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

end.
