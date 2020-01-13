{ $Header: /cvsroot/InfExp/InfExp/src/Infinity.pas,v 1.16 2000/11/01 19:00:14 yole Exp $
  Infinity Engine structures and processing classes
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit Infinity;

interface

uses Classes, SysUtils, InfStruc, IniFiles, Windows, Graphics, Zlib;

// -- game (start) -----------------------------------------------------------

type
  TInfinityGame = class;

  TGameFile = class
  private
    LockCount: integer;
  public
    Index: integer;
    Name: string;
    FileType: TFileType;
    constructor Create (AIndex: integer; const AName: string;
        AFileType: TFileType);
    procedure Lock;
    procedure Unlock;
    procedure Load (F: TStream); virtual; abstract;
  end;
  TGameFileClass = class of TGameFile;

// -- CHITIN.KEY and BIFFs ---------------------------------------------------

  TBIFFEntry = record
    Offset, Size: integer;
  end;

  TBIFFMapEntry = record
    Offset, BlockCount, BlockSize: integer;
  end;

  TChitinBIFF = class
  private
    F: TFileStream;
  public
    FName: string;
    Size: LongInt;
    CD_Mask: word;
    Entries: array of TBIFFEntry;
    MapEntries: array of TBIFFMapEntry;
    constructor Create (const AFName: string; ASize: LongInt; ACD_Mask: word);
    destructor Destroy; override;
    procedure Open (const Path: string);
    procedure Close;
  end;

  TChitinFile = class
    FName: string;
    FileType: TFileType;
    Index, MapIndex, BIFF: word;
  end;

  TOnNeedCDEvent = procedure (CD_Number: integer) of object;

  TChitinKey = class
  private
    FGameDrive: byte;
    FOverridePath, FCachePath: string;
    FCDPath: array [0..7] of TStringList;
    FCacheSize: integer;
    FCurCacheSize: integer;
    FCachedFiles: TList;
    procedure CacheNeedSize (Size: integer);
    procedure ScanCacheDir (const Dir: string);
    procedure AddCachedFile (const FName: string; Size: integer);
    function CheckBiffOnCD (BIFFIndex, CD: integer;
        var BIFFPath: string): boolean;
    function CheckBIFC (const FName, DirName: string; Size: integer): boolean;
    procedure UnpackBIFC (Src: TStream; const DestPath: string);
  public
    BIFFs: array of TChitinBIFF;
    Files: array of TChitinFile;
    OnNeedCD: TOnNeedCDEvent;
    IgnoreOverrides: boolean;
    constructor Create (FName: string);
    destructor Destroy; override;
    procedure ReadIniFile (const FName: string);
    function CreateStream (FileIndex: integer): TStream;
    function GetCDMask (const Name: string; FileType: TFileType): word;
    property OverridePath: string read FOverridePath;
  end;

// -- TLK --------------------------------------------------------------------

  TTLKEntry = class
    Flag: word;
    Sound: string;
    Text: string;
  end;

  TTLKFile = class
  private
    FEntries: array of TTLKEntry;
    F: TFileStream;
    FTextOffset: LongInt;
    function GetSound(i: integer): string;
    function GetText(i: integer): string;
    procedure LoadEntry (i: integer);
  public
    constructor Create (const Fsrc, FName: string);
    destructor Destroy; override;
    function ValidID (i: integer): boolean;
    property Text [i: integer]: string read GetText;
    property Sound [i: integer]: string read GetSound;
    procedure FileCopy(const FSrc, FDst: string);
  end;

// -- DLG --------------------------------------------------------------------

  TDlgPhrase = class
    TextIndex: integer;
    FirstResponce, ResponceCount: LongInt;
    CondIndex: integer;
    Cond: string;
  end;

  TDlgResponceFlag = (rfReply, rfCond, rfAction, rfEnd, rfJournal);

  TDlgResponce = class
    Flags: set of TDlgResponceFlag;
    TextIndex: integer;
    JournalTextIndex: integer;
    Cond, Action: string;
    Dlg: string;
    DlgPhrase: LongInt;
  end;

  TDlg = class (TGameFile)
  private
    function LoadStrings (F: TStream; Offset: LongInt; Count: integer): TStringList;
  public
    Phrases: array of TDlgPhrase;
    Responces: array of TDlgResponce;
    destructor Destroy; override;
    procedure Load (F: TStream); override;
  end;

// -- IDS --------------------------------------------------------------------

  TIDSFile = class (TGameFile)
  public
    OrigStrings, Strings: TStrings;
    destructor Destroy; override;
    procedure Load (F: TStream); override;
    function LookupString (Index: integer): string;
    function HasIndex (Index: integer): boolean;
    function LookupText (Index: integer): string;
  end;

// -- AI scripts -------------------------------------------------------------

  TLexemType = (ltID, ltNumber, ltString, ltPoint, ltRect);

  TScriptPoint = record
    X, Y: integer;
  end;

  TScriptRect = record
    X1, Y1, X2, Y2: integer;
  end;

  TScriptObject = record
    IntArg: array [1..9] of integer;      // last two elements - new for Torment
    Ident: array [1..5] of integer;
    RectArg: TScriptRect;                 // new for Torment
    StrArg: string;
  end;

  TScriptTrigger = record
    TriggerID: integer;
    IntArg: array [1..4] of integer;
    PointArg: TScriptPoint;               // new for Torment
    StrArg: array [1..2] of string;
    ObjArg: TScriptObject;
  end;

  TScriptAction = record
    ActionID: integer;
    ObjArg: array [1..3] of TScriptObject;
    IntArg: integer;
    PointArg: TScriptPoint;
    IntArg2: array [2..3] of integer;
    StrArg: array [1..2] of string;
  end;

  TScriptResponce = record
    Probability: integer;
    Actions: array of TScriptAction;
  end;

  TScriptCondResponce = record
    Condition: array of TScriptTrigger;
    Responce: array of TScriptResponce;
  end;

  TScriptLexem = record
    case LexemType: TLexemType of
      ltID: (ID: string [2]);
      ltNumber: (Number: integer);
      ltString: (Str: string [255]);
      ltPoint: (Point: TScriptPoint);
      ltRect: (Rect: TScriptRect);
  end;

  TScriptBuffer = class
  private
    Buf, P, BufEnd: PChar;
    function GetChar: char;
    procedure UngetChar;
  public
    constructor Create (F: TStream);
    destructor Destroy; override;
    procedure ReadLexem (var Lexem: TScriptLexem);
    procedure ReadLexemExpect (var Lexem: TScriptLexem; LexemType: TLexemType);
    procedure ReadLexemExpectID (var Lexem: TScriptLexem; const IDs: array of string);
    function ReadLexemExpectNumber: integer;
    function ReadLexemExpectString: string;
  end;

  TScriptFile = class (TGameFile)
  private
    Buf: TScriptBuffer;
    procedure ReadCondResponce;
    procedure ReadObject (var Obj: TScriptObject; StartSignature: boolean = true);
    procedure ReadTrigger (var CR: TScriptCondResponce);
    procedure ReadResponce (var CR: TScriptCondResponce);
    procedure ReadAction (var RS: TScriptResponce);
  public
    ScriptVersion: integer;   // 0 - unknown, 1 - Baldur's Gate, 2 - Planescape: Torment
    CondResponces: array of TScriptCondResponce;
    procedure Load (F: TStream); override;
  end;

// -- MOS --------------------------------------------------------------------

  TImageBlock = class
  public
    Width, Height: integer;
    Palette: TImagePalette;
    ImageData: PChar;
    constructor Create (AWidth, AHeight: integer);
    constructor CreateEmpty;
    destructor Destroy; override;
    procedure SetSize (AWidth, AHeight: integer);
    procedure LoadPalette (F: TStream);
    procedure LoadImage (F: TStream);
  end;

  TMOSImage = class (TGameFile)
    procedure LoadUnpacked (F: TStream);
  public
    Header: TMOSHeaderRec;
    Blocks: array of array of TImageBlock;
    procedure Load (F: TStream); override;
    destructor Destroy; override;
  end;

// -- BAM --------------------------------------------------------------------

  TBAMImageFrame = record
    Width, Height: word;
    XPos, YPos: SmallInt;
    Data: PChar;  // points into TBAMImage.ImageData
    NoRLE: boolean;
  end;

  TBAMImage = class (TGameFile)
    procedure LoadUnpacked (F: TStream);
  public
    Palette: TImagePalette;
    Frames: array of TBAMImageFrame;
    Animations: array of array of integer;
    TransparentColor: byte;
    ImageData: PChar;
    procedure Load (F: TStream); override;
    destructor Destroy; override;
    procedure CalcAnimationSize (AnimIndex: integer; var W, H, RefX, RefY: integer);
  end;

// -- BMP --------------------------------------------------------------------

  TBMPImage = class (TGameFile)
  public
    Bitmap: TBitmap;
    procedure Load (F: TStream); override;
    destructor Destroy; override;
  end;

// -- area -------------------------------------------------------------------

  TAreaMap = class (TGameFile)
  private
    FStream: TStream;
  public
    procedure Load (F: TStream); override;
    destructor Destroy; override;
    procedure GetBlock (Index: integer; Block: TImageBlock);
  end;

  TWEDTile = record
    PrimaryTile: array of word;     // possibly an animation
    SecondaryTile: integer;         // for open doors
    OverlayMask: byte;
  end;

  TWEDOverlay = record
    XBlocks, YBlocks: word;
    TileMap: array of array of TWEDTile;
  end;

  TWEDPoly = record
    Bounds: TRect;
    Points: array of TPoint;
    Passable: boolean;
  end;

  TWEDDoor = record
    Id: string;
    Polys: array of TWEDPoly;
  end;

  TWEDWallGroup = record
    Polys: array of TWEDPoly;
  end;

  TAreaWED = class (TGameFile)
  public
    Overlays: array of TWEDOverlay;
    Doors: array of TWEDDoor;
    WallPolys: array of TWEDPoly;
    WallGroups: array of TWEDWallGroup;
    procedure Load (F: TStream); override;
  end;

  TCREFile = class;

  TAreaNPC = record
    Hdr: TAreaNPCRec;
    CREFile: TCREFile;
  end;

  TAreaInfo = record
    Hdr: TAreaInfoRec;
    Poly: TWEDPoly;
  end;

  TAreaContainer = record
    Hdr: TAreaContainerRec;
    Poly: TWEDPoly;
    Items: array of TCREItemRec;
  end;

  TAreaDoor = record
    Hdr: TAreaDoorRec;
    OpenPoly, ClosedPoly: TWEDPoly;
  end;

  TAreaFile = class (TGameFile)
  public
    AreaHdr: TAreaHeaderRec;
    AreaOffsets: TAreaOffsetsRec;
    NPC: array of TAreaNPC;
    Info: array of TAreaInfo;
    Entries: array of TAreaEntryRec;
    Containers: array of TAreaContainer;
    Doors: array of TAreaDoor;
    TiledObjects: array of TAreaTiledObjectRec;
    Anims: array of TAreaAnimRec;
    Vars: array of TGameVarRec;
    SpawnPoints: array of TAreaSpawnRec;
    procedure Load (F: TStream); override;
  end;

  TGameTextFile = class (TGameFile)
  public
    Strings: TStrings;
    procedure Load (F: TStream); override;
    destructor Destroy; override;
  end;

  TGameIniFile = class (TGameTextFile)
  end;

  TGame2DAFile = class (TGameTextFile)
  end;

// -- WAV --------------------------------------------------------------------

  TWAVFile = class (TGameFile)
  private
    FWave: PChar;
  public
    destructor Destroy; override;
    procedure Load (F: TStream); override;
    property Wave: PChar read FWave;
  end;

// -- CRE --------------------------------------------------------------------

  TCREMemorizedSpell = record
    SpellID: string;
    Available: boolean;
  end;

  TCREFile = class (TGameFile)
  private
    procedure LoadCommon0 (const Hdr: TCRECommon0Rec);
    procedure LoadCommon1 (const Hdr: TCRECommon1Rec);
    procedure LoadExt12 (const Hdr: TCRE12ExtRec);
    procedure LoadAIRec (const Hdr: TCREAIRec);
    procedure LoadMemorizedSpells (F: TStream; Offset, Count: integer);
    procedure LoadAbilities22 (F: TStream);
    procedure LoadScripts22 (F: TStream);
  public
    Version: integer; // 10, 12, 90 or 22
    Common0: TCRECommon0Rec;
    Common1: TCRECommon1Rec;
    TLKName, TLKTooltip: string;
    CurHP, MaxHP: word;
    CharClass: array [1..3] of string;
    Level: array [1..3] of word;
    DualClass: boolean;
    Race, Gender, Alignment, MageSpec: string;
    AI_TeamName, Faction, AI_EAName, AI_GeneralName, AI_SpecificName: string;
    RacialEnemy: string;
    AI_Race, AI_Class: byte;
    Items: array of TCREItemRec;
    Dialog: string;
    DeathVar: string;
    KnownSpells: array of TCREKnownSpellRec;
    MemorizedSpells: array of TCREMemorizedSpell;
    Effects: array of TEffectRec;
    procedure Load (F: TStream); override;
  end;

  // Derived class for CRE files loaded from savegames
  TCharCREFile = class (TCREFile)
  end;

// -- ITM --------------------------------------------------------------------

  TWeaponDamageType = (dtPiercing, dtCrushing, dtSlashing, dtMissile, dtStun);
  TItemFlag = (ifIndestructible, ifTwoHanded, ifDroppable, ifDisplayable,
      ifCursed, ifCopyable, ifMagical, ifIsBow, ifSilver, ifColdIron,
      ifUnknown10, ifUnknown11, ifUnknown12);
  TItemFlags = set of TItemFlag;

  TItemAbility = record
    Hdr: TAbilityRec;
    ProjectileType: word;
    IsSpell: boolean;
    Effects: array of TEffectRec;
  end;

  TITMFile = class (TGameFile)
  public
    Version: integer; // 10, 11 or 20
    NameUnident, NameIdent: string;
    DescUnident, DescIdent: string;
    Hdr10: TItem10HeaderRec;
    Dialog: string;
    Flags: set of TItemFlag;
    Abilities: array of TItemAbility;
    GlobalEffects: array of TEffectRec;
    procedure Load (F: TStream); override;
    function GetName: string;
  end;

// -- SPL --------------------------------------------------------------------

  TSPLFile = class (TGameFile)
  public
    Version: integer;  // 10 or 20
    SpellName, SpellDesc: string;
    Hdr: TSpellHeaderRec;
    Abilities: array of TItemAbility;
    procedure Load (F: TStream); override;
  end;

// -- CHUI -------------------------------------------------------------------

  TChUIPanel = record
    Name: string;
    Hdr: TChUIPanelRec;
    Controls: array of TChUIControlRec;
  end;

  TChUIFile = class (TGameFile)
  public
    Panels: array of TChUIPanel;
    procedure Load (F: TStream); override;
  end;

// -- WMAP -------------------------------------------------------------------

  TWorldMap = record
    Hdr: TWorldMapRec;
    Areas: array of TWorldMapAreaRec;
    Links: array of TWorldMapLinkRec;
  end;
  PWorldMap = ^TWorldMap;

  TWMapFile = class (TGameFile)
  public
    Maps: array of TWorldMap;
    procedure Load (F: TStream); override;
  end;

// -- STOR -------------------------------------------------------------------

  TStoreFile = class (TGameFile)
  public
    Version: integer;
    Hdr: TStoreHeaderRec;
    Items: array of TStore10ItemRec;
    BoughtItems: array of LongInt;
    Drinks: array of TStoreDrinkRec;
    Spells: array of TStoreSpellRec;
    procedure Load (F: TStream); override;
  end;

// -- QUESTS.INI -------------------------------------------------------------

   TQuestElem = record
     DescIndex: integer;
     Checks: array of string;
   end;

   TQuest = record
     TitleIndex: integer;
     Assigned: TQuestElem;
     Complete: array of TQuestElem;
   end;

   TQuestsIni = class
   public
     Quests: array of TQuest;
     constructor Create (const FName: string);
   end;

// -- savegames --------------------------------------------------------------

  TSaveGameCharacter = record
    CREData: array of byte;
    CRE: TCharCREFile;
    Name: string;
    PartyCommon: TGameCharacterCommonRec;
    Stats: TGameCharacterStatsRec;
  end;

  TSaveGame = class
  private
    FSavePath: string;
    FUnpPath: string;
    FSavFiles: TStringList;
    procedure LoadGameFile (const FName: string);
    procedure LoadGameCharacter (F: TStream; var Char: TSaveGameCharacter);
  public
    Index: integer;
    Name: string;
    Loaded: boolean;
    HdrCommon: TGameHeaderCommonRec;
    Party: array of TSaveGameCharacter;
    NPC: array of TSaveGameCharacter;
    Vars: array of TGameVarRec;
    KillVars: array of TGameVarRec;
    Journal: array of TGameJournalRec;
    constructor Create (const ASavePath: string);
    destructor Destroy; override;
    procedure Load;
    procedure Unload;
    property SavePath: string read FSavePath;
    property UnpPath: string read FUnpPath;
    property SavFiles: TStringList read FSavFiles;
  end;

  TSaveGameList = class
  private
    FSaveGames: TList;
    function GetItems(i: integer): TSaveGame;
  public
    constructor Create (const SavePath: string);
    destructor Destroy; override;
    function Count: integer;
    property Items [i: integer]: TSaveGame read GetItems; default;
  end;

// -- overall ----------------------------------------------------------------

  TInfinityGame = class
  private
    FFiles: TList;
    function LoadFile (AIndex: integer): TGameFile;
    procedure FixCategoryNames;
  public
    Key: TChitinKey;
    TLK: TTLKFile;
    Path: string;
    GameType: TGameType;
    SaveGames, MPSaveGames: TSaveGameList;
    constructor Create (const Directory: string);
    destructor Destroy; override;
    function GetFile (AIndex: integer): TGameFile;
    function GetFileByName (const Name: string; FileType: TFileType): TGameFile; overload;
    function GetFileByName (const Name: TResRef; FileType: TFileType): TGameFile; overload;
    function LoadFileFromStream (F: TStream; AIndex: integer;
      const AFName: string; AFileType: TFileType): TGameFile;
    function LoadExternalFile (const AFilePath, AName: string; AFileType: TFileType): TGameFile;
    procedure FreeFile (AFile: TGameFile);
    procedure FreeFiles;  // frees all unlocked files
    function FilesLoaded: integer;
    procedure UnpackFile (const PackFName, DestDir: string;
        OutFiles: TStrings = nil);
    function UnpackStream (F: TStream): TMemoryStream;
  end;

const
  FileTypeCodes: array [TFileType] of word =
    (0, 1, 2, 4, 5, 6, $3E8, $3E9, $3EA, $3EB, $3EC, $3ED, $3EE, $3EF, $3F0, $3F1,
     $3F2, $3F3, $3F4, $3F5, $3F6, $3F7, $3F8, $3FB, $3FD, $802, $803);

  FileTypeExts: array [TFileType] of string =
    ('', '.BMP', '.MVE', '.WAV', '.WFX', '.PLT', '.BAM', '.WED', '.CHU', '.MAP', '.MOS',
     '.ITM', '.SPL', '.BCS', '.IDS', '.CRE', '.ARE', '.DLG', '.2DA',
     '.GAM', '.STO', '.WMP', '.EFF', '.VVC', '.PRO', '.INI', '.SRC');

  // responce flags
  RESP_REPLY   = 1;
  RESP_COND    = 2;
  RESP_ACTION  = 4;
  RESP_END     = 8;
  RESP_JOURNAL = 16;

var
  Game: TInfinityGame;
  CategoryNames: array [0..$39] of string;

function CreateFileStream (const FName: string): TStream;
function PChar8ToStr (P: PChar): string;
procedure FindAllFiles (const Dir, FileMask: string; Dest: TStrings);

implementation

uses FTUtils, RxStrUtils;

function PChar8ToStr (P: PChar): string;
var
  Buf: array [0..8] of char;
begin
  StrLCopy (Buf, P, 8);
  Buf [8] := #0;
  Result := Buf;
end;

procedure IDSToText (var S: string);
var
  i: integer;
  Capitalize: boolean;
begin
  Capitalize := true;
  for i := 1 to Length (S) do
    if S [i] = '_' then begin
      S [i] := ' ';
      Capitalize := true;
    end
    else if Capitalize then begin
      S [i] := UpCase (S [i]);
      Capitalize := false;
    end
    else S [i] := LoCase (S [i]);
end;

procedure FindAllFiles (const Dir, FileMask: string; Dest: TStrings);
var
  SR: TSearchRec;
  FindResult: integer;
begin
  FindResult := FindFirst (MkPath (FileMask, Dir), faReadOnly or faArchive, SR);
  while FindResult = 0 do begin
    Dest.Add (MkPath (SR.Name, Dir));
    FindResult := FindNext (SR);
  end;
  SysUtils.FindClose (SR);
end;

{ TGameFile }

constructor TGameFile.Create (AIndex: integer; const AName: string;
    AFileType: TFileType);
begin
  Index := AIndex;
  Name := ChangeFileExt (ExtractFileName (AName), '');
  FileType := AFileType;
  LockCount := 0;
end;

procedure TGameFile.Lock;
begin
  Inc (LockCount);
end;

procedure TGameFile.Unlock;
begin
  Dec (LockCount);
end;

{ TChitinBIFF }

constructor TChitinBIFF.Create (const AFName: string; ASize: Integer;
  ACD_Mask: word);
begin
  FName := AFName;
  Size := ASize;
  CD_Mask := ACD_Mask;
  F := nil;
  Entries := nil;
end;

destructor TChitinBIFF.Destroy;
begin
  if F <> nil then F.Free;
  inherited Destroy;
end;

procedure TChitinBIFF.Open (const Path: string);
var
  Hdr: TBIFFHeaderRec;
  EntryRec: TBIFFEntryRec;
  MapEntryRec: TBIFFMapEntryRec;
  i: integer;
begin
  if F <> nil then Exit;
  F := TFileStream.Create (MkPath (FName, Path), fmOpenRead or fmShareDenyNone);
  F.Read (Hdr, SizeOf (Hdr));
  if StrLComp (Hdr.Signature, 'BIFFV1  ', 8) <> 0 then begin
    F.Free;
    F := nil;
    raise Exception.CreateFmt ('%s is not a BIFF file', [FName]);
  end;
  SetLength (Entries, Hdr.ElemCount);
  SetLength (MapEntries, Hdr.MapCount);
  F.Position := Hdr.DirOffset;
  for i := 0 to Hdr.ElemCount-1 do begin
    F.Read (EntryRec, SizeOf (EntryRec));
    with Entries [i] do begin
      Offset := EntryRec.Offset;
      Size := EntryRec.Size;
    end;
  end;
  for i := 0 to Hdr.MapCount-1 do begin
    F.Read (MapEntryRec, SizeOf (MapEntryRec));
    with MapEntries [i] do begin
      Offset := MapEntryRec.Offset;
      BlockCount := MapEntryRec.BlockCount;
      BlockSize := MapEntryRec.BlockSize;
    end;
  end;
end;

procedure TChitinBIFF.Close;
begin
  F.Free;
  F := nil;
  SetLength (Entries, 0);
  SetLength (MapEntries, 0);
end;

{ TBIFFStream }

type
  TBIFFStream = class (TStream)
  private
    FBaseStream: TStream;
    FBaseOffset, FSize: integer;
    FOwnsStream: boolean;
  public
    constructor Create (BaseStream: TStream; BaseOffset, Size: integer); overload;
    constructor Create (const FName: string); overload; virtual;
    destructor Destroy; override;
    procedure SetBase (BaseOffset, Size: integer);
    function Read (var Buffer; Count: LongInt): LongInt; override;
    function Write (const Buffer; Count: Longint): Longint; override;
    function Seek (Offset: Longint; Origin: Word): Longint; override;
  end;

constructor TBIFFStream.Create (BaseStream: TStream; BaseOffset, Size: integer);
begin
  FBaseStream := BaseStream;
  SetBase (BaseOffset, Size);
  FOwnsStream := false;
end;

procedure TBIFFStream.SetBase (BaseOffset, Size: integer);
begin
  FBaseOffset := BaseOffset;
  FSize := Size;
  FBaseStream.Position := BaseOffset;
end;

constructor TBIFFStream.Create (const FName: string);
begin
  FBaseStream := TFileStream.Create (FName, fmOpenRead or fmShareDenyNone);
  FBaseOffset := 0;
  FSize := FBaseStream.Size;
  FOwnsStream := true;
end;

destructor TBIFFStream.Destroy;
begin
  if FOwnsStream then FBaseStream.Free;
  inherited Destroy;
end;

function TBIFFStream.Read (var Buffer; Count: Integer): LongInt;
begin
  if FBaseStream.Position - FBaseOffset + Count > FSize then
    raise EStreamError.Create ('Read past end of file');
  Result := FBaseStream.Read (Buffer, Count);
end;

function TBIFFStream.Seek (Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning:
      Result := FBaseStream.Seek (FBaseOffset+Offset, soFromBeginning);
    soFromCurrent:
      Result := FBaseStream.Seek (Offset, soFromCurrent);
    soFromEnd:
      Result := FBaseStream.Seek (FBaseOffset+FSize+Offset, soFromBeginning);
    else
      raise EStreamError.Create ('Invalid stream operation');
  end;
  Dec (Result, FBaseOffset);
end;

function TBIFFStream.Write (const Buffer; Count: Integer): Longint;
begin
  raise EStreamError.Create ('Invalid stream operation');
end;

{ TBIFFDecryptStream }

type
  TBIFFDecryptStream = class (TBIFFStream)
  private
    FDecryptKey: array of byte;
  public
    constructor Create (const FName: string); override;
    procedure SetDecryptKey (ADecryptKey: array of byte);
    function Read (var Buffer; Count: LongInt): LongInt; override;
  end;

constructor TBIFFDecryptStream.Create (const FName: string);
begin
  inherited Create (FName);
  FBaseOffset := 2;
  FSize := FBaseStream.Size - 2;
  FBaseStream.Position := 2;
end;

procedure TBIFFDecryptStream.SetDecryptKey (ADecryptKey: array of byte);
var
  i: integer;
begin
  SetLength (FDecryptKey, Length (ADecryptKey));
  for i := 0 to High (ADecryptKey) do
    FDecryptKey [i] := ADecryptKey [i];
end;

function TBIFFDecryptStream.Read (var Buffer; Count: Integer): LongInt;
type
  PByte = ^Byte;
var
  P: PByte;
  KeyLen, StartPos, i: integer;
begin
  KeyLen := Length (FDecryptKey);
  if KeyLen = 0 then begin
    Result := inherited Read (Buffer, Count);
    Exit;
  end;
  StartPos := Position mod KeyLen;
  Result := inherited Read (Buffer, Count);
  P := PByte (@Buffer);
  for i := 0 to Count-1 do begin
    P^ := P^ xor FDecryptKey [(StartPos + i) mod KeyLen];
    Inc (P);
  end;
end;

const
  BaldurDecryptKey: array [0..63] of byte = (
   $88, $A8, $8F, $BA, $8A, $D3, $B9, $F5, $ED, $B1,
   $CF, $EA, $AA, $E4, $B5, $FB, $EB, $82, $F9, $90,
   $CA, $C9, $B5, $E7, $DC, $8E, $B7, $AC, $EE, $F7,
   $E0, $CA, $8E, $EA, $CA, $80, $CE, $C5, $AD, $B7,
   $C4, $D0, $84, $93, $D5, $F0, $EB, $C8, $B4, $9D,
   $CC, $AF, $A5, $95, $BA, $99, $87, $D2, $9D, $E3,
   $91, $BA, $90, $CA);

function CreateFileStream (const FName: string): TStream;
var
  FS: TFileStream;
  W: word;
begin
  // check if decryption needed
  FS := TFileStream.Create (FName, fmOpenRead or fmShareDenyNone);
  FS.Read (W, 2);
  FS.Free;
  if W = $FFFF then begin
    Result := TBIFFDecryptStream.Create (FName);
    TBIFFDecryptStream (Result).SetDecryptKey (BaldurDecryptKey);
  end
  else
    Result := TBIFFStream.Create (FName);
end;

{ TChitinKey }

type
  TCachedFile = class
    FName: string;
    Size: integer;
    Date: TDateTime;
    constructor Create (const AFName: string; ASize: integer; ADate: TDateTime = 0);
  end;

constructor TCachedFile.Create(const AFName: string; ASize: integer;
  ADate: TDateTime);
begin
  FName := AFName;
  Size := ASize;
  if ADate <> 0 then
    Date := ADate
  else
    Date := Now;
end;

function CachedFileCompareDate (P1, P2: pointer): integer;
var
  CF1, CF2: TCachedFile;
begin
  CF1 := TCachedFile (P1);
  CF2 := TCachedFile (P2);
  if CF1.Date > CF2.Date then Result := -1
  else if CF1.Date < CF2.Date then Result := 1
  else Result := 0;
end;

constructor TChitinKey.Create (FName: string);
var
  F: TFileStream;
  Hdr: TChitinKeyHdr;
  i: integer;
  OldPos: LongInt;
  BIFFRec: TChitinBIFFRec;
  FileRec: TChitinFileRec;
  NameBuf: array [0..255] of char;
  FType: TFileType;

  ovrrSearch : TSearchRec;
  xFileExt: string;
  xFileLen: integer;
  xFileName: string;
  c: integer;

  dlgFiles: array of string;
  dlgCount: integer;

  itmFiles: array of string;
  itmCount: integer;

  creFiles: array of string;
  creCount: integer;

  bcsFiles: array of string;
  bcsCount: integer;

  areFiles: array of string;
  areCount: integer;

  wedFiles: array of string;
  wedCount: integer;

  tisFiles: array of string;
  tisCount: integer;

begin
  OnNeedCD := nil;
  if (Length (FName) > 2) and (FName [2] = ':') then
    FGameDrive := Ord (UpCase (FName [1])) - Ord ('A') + 1
  else
    FGameDrive := 0;
  FOverridePath := ExtractFilePath (FName) + 'override\';
  FCachePath := ExtractFilePath (FName) + 'cache\';
  for i := 0 to 7 do
    FCDPath [i] := TStringList.Create;
  F := TFileStream.Create (FName, fmOpenRead or fmShareDenyNone);
  try
    F.Read (Hdr, SizeOf (Hdr));
    if StrLComp (Hdr.Signature, 'KEY V1  ', 8) <> 0 then
      raise Exception.CreateFmt ('%s is not a valid CHITIN.KEY file', [FName]);
    // load BIFFs
    F.Position := Hdr.BIFF_Offset;
    SetLength (BIFFs, Hdr.BIFF_Count);
    for i := 0 to Hdr.BIFF_Count-1 do begin
      F.Read (BIFFRec, SizeOf (BIFFRec));
      OldPos := F.Position;
      F.Position := BIFFRec.Name_Offset;
      F.Read (NameBuf, BIFFRec.Name_Length);
      F.Position := OldPos;
      with BIFFRec do
        BIFFs [i] := TChitinBIFF.Create (NameBuf, BIFF_Length, CD_Mask);
    end;
    // load files
    F.Position := Hdr.File_Offset;
    SetLength (Files, Hdr.File_Count);
    for i := 0 to Hdr.File_Count-1 do begin
      F.Read (FileRec, SizeOf (FileRec));
      Files [i] := TChitinFile.Create;
      with Files [i] do begin
        FName := PChar8ToStr (FileRec.Name);
        for FType := Low (TFileType) to High (TFileType) do
          if FileTypeCodes [FType] = FileRec.FileType then begin
            FileType := FType;
            break;
          end;
        Index := FileRec.Index and $3FFF;
        MapIndex := (FileRec.Index shr 14) or ((FileRec.BIFF and $0F) shl 2);
        BIFF := FileRec.BIFF shr 4;
      end;
    end;

    dlgCount := 0;
	  creCount := 0;
    itmCount := 0;
    bcsCount := 0;
    areCount := 0;
    wedCount := 0;
    tisCount := 0;
    
  	// find dialog files in override path
    if FindFirst(FOverridePath + '*.*', faAnyFile, ovrrSearch) = 0 then
      try
        repeat
          if ovrrSearch.Size > 52 then
          begin
            xFileLen := Length(ovrrSearch.Name);
            xFileExt := UpperCase(ExtractFileExt(ovrrSearch.Name));
            xFileName:= Copy(ovrrSearch.Name, 0, xFileLen-4);

            // string switch statement doesn't work for Pascal

            if xFileExt = '.DLG' then
              begin
                SetLength(dlgFiles, dlgCount + 1);
                dlgFiles[dlgCount] := xFileName;
                dlgCount := dlgCount + 1;
              end
            else if xFileExt = '.CRE' then
              begin
                SetLength(creFiles, creCount + 1);
                creFiles[creCount] := xFileName;
                creCount := creCount + 1;
              end
            else if xFileExt = '.ITM' then
              begin
                SetLength(itmFiles, itmCount + 1);
                itmFiles[itmCount] := xFileName;
                itmCount := itmCount + 1;
              end
            else if xFileExt = '.BCS' then
              begin
                SetLength(bcsFiles, bcsCount + 1);
                bcsFiles[bcsCount] := xFileName;
                bcsCount := bcsCount + 1;
              end
            else if xFileExt = '.ARE' then
              begin
                SetLength(areFiles, areCount + 1);
                areFiles[areCount] := xFileName;
                areCount := areCount + 1;
              end
            else if xFileExt = '.WED' then
              begin
                SetLength(wedFiles, wedCount + 1);
                wedFiles[wedCount] := xFileName;
                wedCount := wedCount + 1;
              end
            else if xFileExt = '.TIS' then
              begin
                SetLength(tisFiles, tisCount + 1);
                tisFiles[tisCount] := xFileName;
                tisCount := tisCount + 1;
              end;
          end;

        until FindNext(ovrrSearch) <> 0;

      finally
        // Must free up resources used by these successful finds
        SysUtils.FindClose(ovrrSearch);
    end;
    
    SetLength (Files, Hdr.File_Count+ dlgCount + creCount + itmCount + bcsCount + areCount + wedCount + tisCount);
    
    c := Hdr.File_Count;

    for i := 0 to dlgCount - 1 do begin
      Files [c] := TChitinFile.Create;
      Files [c].FileType := ftDLG;
      Files [c].FName := dlgFiles[i];
      c := c + 1;
		end;

    for i := 0 to itmCount - 1 do begin
      Files [c] := TChitinFile.Create;
      Files [c].FileType := ftITM;
      Files [c].FName := itmFiles[i];
      c := c + 1;
	end;

    for i := 0 to creCount - 1 do begin
      Files [c] := TChitinFile.Create;
      Files [c].FileType := ftCRE;
      Files [c].FName := creFiles[i];
	  c := c + 1;
	end;

    for i := 0 to bcsCount - 1 do begin
      Files [c] := TChitinFile.Create;
      Files [c].FileType := ftScript;
      Files [c].FName := bcsFiles[i];
      Files [c].MapIndex := bcsCount-c-1;
      Files [c].BIFF := 0;
      c := c + 1;
	end;

    for i := 0 to areCount - 1 do begin
      Files [c] := TChitinFile.Create;
      Files [c].FileType := ftArea;
      Files [c].FName := areFiles[i];
      c := c + 1;
	end;

    for i := 0 to wedCount - 1 do begin
      Files [c] := TChitinFile.Create;
      Files [c].FileType := ftWED;
      Files [c].FName := wedFiles[i];
      c := c + 1;
	end;

    for i := 0 to tisCount - 1 do begin
      Files [c] := TChitinFile.Create;
      Files [c].FileType := ftMAP;
      Files [c].FName := tisFiles[i];
      c := c + 1;
	end;

  finally
    F.Free;
  end;
  FCachedFiles := TList.Create;
  FCurCacheSize := 0;
  ScanCacheDir (FCachePath);
  FCachedFiles.Sort (CachedFileCompareDate);
end;

destructor TChitinKey.Destroy;
var
  i: integer;
begin
  for i := 0 to Length (BIFFs)-1 do
    BIFFs [i].Free;
  for i := 0 to Length (Files)-1 do
    Files [i].Free;
  for i := FCachedFiles.Count-1 downto 0 do
    TCachedFile (FCachedFiles [i]).Free;
  FCachedFiles.Free;
  for i := 0 to 7 do
    FCDPath [i].Free;
  inherited Destroy;
end;

procedure TChitinKey.ReadIniFile (const FName: string);
var
  i, W: integer;
  Ini: TIniFile;
  S: string;
begin
  if not FileExists (FName) then
    raise Exception.CreateFmt ('Game .INI file %s not found', [FName]);
  Ini := TIniFile.Create (FName);
  try
    for i := 0 to 7 do begin
      S := Ini.ReadString ('Alias', Format ('CD%d:', [i]), '');
      FCDPath [i].Clear;
      for W := 1 to WordCount (S, [';']) do
        FCDPath [i].Add (ExtractWord (W, S, [';']));
    end;
    FCacheSize := Ini.ReadInteger ('Config', 'CacheSize', 40) * 1024 * 1024;
  finally
    Ini.Free;
  end;
end;

function TChitinKey.CreateStream (FileIndex: integer): TStream;
var
  ChFile: TChitinFile;
  OverridePath: string;
  i, CDNumber: integer;
  BIFFPath: string;
  W: word;
begin
  Assert ((FileIndex >= 0) and (FileIndex < Length (Files)));
  ChFile := Files [FileIndex];
  OverridePath := FOverridePath + ChFile.FName + FileTypeExts [ChFile.FileType];
  if not IgnoreOverrides and FileExists (OverridePath) then
    Result := CreateFileStream (OverridePath)
  else
    with BIFFs [ChFile.BIFF] do begin
      if FileExists (MkPath (FName, FCachePath)) then
        BIFFPath := FCachePath
      else if FileExists (MkPath (FName, Game.Path)) then begin
        if not CheckBIFC (FName, Game.Path, Size) then
          BIFFPath := Game.Path
        else
          BIFFPath := FCachePath;
      end
      else begin
        BIFFPath := '?';
        CDNumber := 0;
        for i := 0 to 7 do
          if ((CD_Mask and (1 shl (i+1))) <> 0) then begin
            CDNumber := i;
            if CheckBiffOnCD (ChFile.BIFF, i, BIFFPath) then
              Break;
          end;
        if BIFFPath = '?' then begin
          if not Assigned (OnNeedCD) then
            raise Exception.CreateFmt ('Game CD %d not available', [CDNumber]);
          for i := 0 to 7 do
            if (CD_Mask and (1 shl (i+1))) <> 0 then begin
              while not CheckBiffOnCD (ChFile.BIFF, i, BIFFPath) do
                OnNeedCD (i);
              Break;
            end;
        end;
      end;
      Open (BIFFPath);
      if ChFile.FileType = ftMAP then
        with MapEntries [ChFile.MapIndex-1] do
          Result := TBIFFStream.Create (F, Offset, BlockCount * BlockSize)
      else begin
        // check if decryption needed
        F.Position :=  Entries [ChFile.Index].Offset;
        F.Read (W, 2);
        if W = $FFFF then begin
          Result := TBIFFDecryptStream.Create (F, Entries [ChFile.Index].Offset+2,
              Entries [ChFile.Index].Size-2);
          TBIFFDecryptStream (Result).SetDecryptKey (BaldurDecryptKey);
        end
        else
          Result := TBIFFStream.Create (F, Entries [ChFile.Index].Offset,
              Entries [ChFile.Index].Size);
      end;
    end;
end;

function TChitinKey.CheckBiffOnCD (BIFFIndex, CD: integer;
    var BIFFPath: string): boolean;
var
  CFName, FPath: string;
  j: integer;
begin
  Result := false;
  with BIFFs [BIFFIndex] do begin
    CFName := ChangeFileExt (FName, '.cbf');
    for j := 0 to FCDPath [CD].Count-1 do begin
      if FileExists (FCDPath [CD][j]+FName) then begin
        Result := true;
        if CheckBIFC (FName, FCDPath [CD][j], Size) then
          BIFFPath := FCachePath
        else
          BIFFPath := FCDPath [CD][j];
        Break;
      end
      else if FileExists (FCDPath [CD][j]+CFName) then begin
        CacheNeedSize (Size);
        FPath := ExtractFilePath (FName);
        Game.UnpackFile (FCDPath [CD][j]+CFName, MkPath (FPath, FCachePath));
        AddCachedFile (MkPath (FName, FCachePath), Size);
        BIFFPath := FCachePath;
        Result := true;
        Break;
      end;
    end;
  end;
end;

function TChitinKey.CheckBIFC (const FName, DirName: string; Size: integer): boolean;
var
  FS: TFileStream;
  Signature: array [0..7] of char;
  OutPath: string;
begin
  FS := TFileStream.Create (MkPath (FName, DirName), fmOpenRead or fmShareDenyNone);
  try
    FS.Read (Signature, 8);
    if StrLComp (Signature, 'BIFCV1.0', 8) = 0 then begin
      CacheNeedSize (Size);
      OutPath := MkPath (FName, FCachePath);
      CreateDirs (ExtractFilePath (OutPath));
      UnpackBIFC (FS, OutPath);
      AddCachedFile (OutPath, Size);
      Result := true;
    end
    else
      Result := false;
  finally
    FS.Free;
  end;
end;

procedure TChitinKey.UnpackBIFC (Src: TStream; const DestPath: string);
var
  TotalUnpSize: integer;
  Unp, Pack: PChar;
  UnpSize, PackSize: integer;
  Dest: TFileStream;
  UnpBlockSize, PackBlockSize: LongInt;
begin
  Src.Position := 8;
  Src.Read (TotalUnpSize, 4);
  Dest := TFileStream.Create (DestPath, fmCreate);
  Unp := nil;
  Pack := nil;
  UnpSize := 0;
  PackSize := 0;
  try
    while Src.Position < Src.Size do begin
      Src.Read (UnpBlockSize, 4);
      Src.Read (PackBlockSize, 4);
      if UnpSize < UnpBlockSize then begin
        if Unp <> nil then FreeMem (Unp);
        GetMem (Unp, UnpBlockSize);
        UnpSize := UnpBlockSize;
      end;
      if PackSize < PackBlockSize then begin
        if Pack <> nil then FreeMem (Pack);
        GetMem (Pack, PackBlockSize);
        PackSize := PackBlockSize;
      end;
      Src.Read (Pack^, PackBlockSize);
      DecompressToUserBuf (Pack, PackBlockSize, Unp, UnpBlockSize);
      Dest.Write (Unp^, UnpBlockSize); 
    end;
  finally
    Dest.Free;
    if Unp <> nil then
      FreeMem (Unp);
    if Pack <> nil then
      FreeMem (Pack);
  end;
end;

procedure TChitinKey.CacheNeedSize (Size: integer);
var
  MaxSize, SizeToFree, SizeFreed: Int64;
  i, j: integer;
  CFName: string;
begin
  MaxSize := FCacheSize;
  if DiskFree (FGameDrive) < Size then
    MaxSize := DiskFree (FGameDrive);
  SizeToFree  := FCurCacheSize + Size - MaxSize;
  if SizeToFree < 0 then Exit;
  SizeFreed := 0;
  for i := FCachedFiles.Count-1 downto 0 do begin
    with TCachedFile (FCachedFiles [i]) do begin
      CFName := ExtractFileName (FName);
      for j := 0 to Length (BIFFs)-1 do
        if SameText (ExtractFileName (BIFFs [j].FName), CFName) then
          BIFFs [j].Close;
      if not SysUtils.DeleteFile (FName) then
        raise Exception.CreateFmt ('Failed to delete %s when freeing cache space', [FName]);
      Inc (SizeFreed, Size);
      Dec (FCurCacheSize, Size);
      Free;
    end;
    FCachedFiles.Delete (i);
    if SizeFreed > SizeToFree then Break;
  end;
  if DiskFree (FGameDrive) < Size then
    raise Exception.Create ('Not enough space on game drive');
end;

procedure TChitinKey.ScanCacheDir (const Dir: string);
var
  SR: TSearchRec;
  FindResult: integer;
  CachedFile: TCachedFile;
begin
  FindResult := FindFirst (Dir + '*.*', faAnyFile, SR);
  try
    while FindResult = 0 do begin
      if SR.Attr and faDirectory <> 0 then begin
        if (Length (SR.Name) > 1) and (SR.Name [1] <> '.') then
          ScanCacheDir (Dir + SR.Name + '\')
      end
      else begin
        CachedFile := TCachedFile.Create (Dir + SR.Name, SR.Size, FileDateToDateTime (SR.Time));
        FCachedFiles.Add (CachedFile);
        Inc (FCurCacheSize, SR.Size);
      end;
      FindResult := FindNext (SR);
    end;
  finally
    SysUtils.FindClose (SR);
  end;
end;

procedure TChitinKey.AddCachedFile (const FName: string; Size: integer);
begin
  FCachedFiles.Insert (0, TCachedFile.Create (FName, Size));
  Inc (FCurCacheSize, Size);
end;

function TChitinKey.GetCDMask (const Name: string; FileType: TFileType): word;
var
  i: integer;
begin
  for i := 0 to Length (Files)-1 do
    if SameText (Files [i].FName, Name) and (Files [i].FileType = FileType)
    then begin
      Result := BIFFs [Files [i].BIFF].CD_Mask;
      Exit;
    end;
  Result := 0;
end;

{ TTLKFile }

constructor TTLKFile.Create (const Fsrc, FName: string);
var
  Hdr: TTLKHeaderRec;
  i: integer;
  xFName : string;
begin

    // FileCopy(Fsrc, FName) creates a copy of dialog.tlk
	// and allows the user to use NI / DLTCEP for editing IE files.
	FileCopy(Fsrc, FName);
	xFName := Fname;

  F := TFileStream.Create (xFName, fmOpenRead or fmShareDenyNone);
  F.Read (Hdr, SizeOf (Hdr));
  if StrLComp (Hdr.Signature, 'TLK V1  ', 8) <> 0 then
    raise Exception.CreateFmt ('%s is not a TLK file', [xFName]);
  FTextOffset := Hdr.TextOffset;
  SetLength (FEntries, Hdr.RecordCount);
  for i := 0 to Hdr.RecordCount-1 do
    FEntries [i] := nil;
end;

destructor TTLKFile.Destroy;
var
  i: integer;
begin
  for i := 0 to Length (FEntries)-1 do
    FEntries [i].Free;
  FEntries := nil;
  inherited Destroy;
end;

procedure TTLKFile.LoadEntry (i: integer);
var
  Rec: TTLKEntryRec;
  Entry: TTLKEntry;
begin
  F.Position := SizeOf (TTLKHeaderRec) + i * SizeOf (TTLKEntryRec);
  F.Read (Rec, SizeOf (Rec));
  Entry := TTLKEntry.Create;
  Entry.Flag := Rec.Flag;
  Entry.Sound := Rec.Sound;
  F.Position := FTextOffset+Rec.Offset;
  SetLength (Entry.Text, Rec.Length);
  F.Read (PChar (Entry.Text)^, Rec.Length);
  FEntries [i] := Entry;
end;

function TTLKFile.GetText (i: integer): string;
begin
  if (i < 0) or (i >= Length (FEntries)) then
    raise Exception.CreateFmt ('Invalid TLK index %d', [i]);
  if FEntries [i] = nil then LoadEntry (i);
  Result := FEntries [i].Text;
end;

function TTLKFile.GetSound (i: integer): string;
begin
  if (i < 0) or (i >= Length (FEntries)) then
    raise Exception.CreateFmt ('Invalid TLK index %d', [i]);
  if FEntries [i] = nil then LoadEntry (i);
  Result := FEntries [i].Sound;
end;

function TTLKFile.ValidID (i: integer): boolean;
begin
  Result := (i >= 0) and (i < Length (FEntries));
end;

procedure TTLKFile.FileCopy(const FSrc, FDst: string);
var
  sStream,
  dStream: TFileStream;
begin
  sStream := TFileStream.Create(FSrc, fmOpenRead or fmShareDenyNone);
  try
    dStream := TFileStream.Create(FDst, fmCreate);
    try
      {Forget about block reads and writes, just copy the whole darn thing.}
      dStream.CopyFrom(sStream, 0);
    finally
      dStream.Free;
    end;
  finally
    sStream.Free;
  end;
end;


{ TDlg }

procedure TDlg.Load (F: TStream);
var
  Header: TDlgHeaderRec;
  PhraseRec: TDlgPhraseRec;
  Phrase: TDlgPhrase;
  ResponceRec: TDlgResponceRec;
  Responce: TDlgResponce;
  LstCond, LstRespCond, LstActions: TStringList;
  i: integer;
begin
  F.Read (Header, SizeOf (Header));
  if StrLComp (Header.Signature, 'DLG V1.0', 8) <> 0 then
    raise Exception.Create ('Not a DLG file');
  LstCond := LoadStrings (F, Header.CondOffset, Header.CondCount);
  LstRespCond := LoadStrings (F, Header.RespCondOffset, Header.RespCondCount);
  LstActions := LoadStrings (F, Header.ActionOffset, Header.ActionCount);
  // phrases
  SetLength (Phrases, Header.PhraseCount);
  F.Position := Header.PhraseOffset;
  for i := 0 to Header.PhraseCount-1 do begin
    F.Read (PhraseRec, SizeOf (PhraseRec));
    Phrase := TDlgPhrase.Create;
    with Phrase do begin
      TextIndex := PhraseRec.TlkIndex;
      FirstResponce := PhraseRec.FirstResponce;
      ResponceCount := PhraseRec.ResponceCount;
      CondIndex := PhraseRec.Cond;
      if PhraseRec.Cond <> -1 then begin
        if (PhraseRec.Cond >= 0) and (PhraseRec.Cond < LstCond.Count) then
          Cond := Trim (LstCond [PhraseRec.Cond])
        else
          Cond := Format ('Invalid COND index %d', [PhraseRec.Cond]);
      end
      else Cond := '';
    end;
    Phrases [i] := Phrase;
  end;
  // responces
  SetLength (Responces, Header.ResponceCount);
  F.Position := Header.ResponceOffset;
  for i := 0 to Header.ResponceCount-1 do begin
    F.Read (ResponceRec, SizeOf (ResponceRec));
    Responce := TDlgResponce.Create;
    with Responce do begin
      Flags := [];
      if ResponceRec.Flags and RESP_REPLY <> 0 then Include (Flags, rfReply);
      if ResponceRec.Flags and RESP_COND <> 0 then Include (Flags, rfCond);
      if ResponceRec.Flags and RESP_ACTION <> 0 then Include (Flags, rfAction);
      if ResponceRec.Flags and RESP_END <> 0 then Include (Flags, rfEnd);
      if ResponceRec.Flags and RESP_JOURNAL <> 0 then Include (Flags, rfJournal);
      TextIndex := ResponceRec.TlkIndex;
      JournalTextIndex := ResponceRec.JournalIndex;
      if rfCond in Flags then Cond := Trim (LstRespCond [ResponceRec.Cond]);
      if rfAction in Flags then Action := Trim (LstActions [ResponceRec.Action]);
      Dlg := PChar8ToStr (ResponceRec.Dlg);
      DlgPhrase := ResponceRec.DlgPhrase;
    end;
    Responces [i] := Responce;
  end;
  LstCond.Free;
  LstRespCond.Free;
  LstActions.Free;
end;

destructor TDlg.Destroy;
var
  i: integer;
begin
  for i := 0 to Length (Phrases)-1 do
    Phrases [i].Free;
  for i := 0 to Length (Responces)-1 do
    Responces [i].Free;
  inherited Destroy;
end;

function TDlg.LoadStrings (F: TStream; Offset, Count: integer): TStringList;
var
  S: string;
  OldPos: integer;
  i: integer;
  StrOffset, StrLength: LongInt;
begin
  Result := TStringList.Create;
  F.Position := Offset;
  for i := 1 to Count do begin
    F.Read (StrOffset, SizeOf (StrOffset));
    F.Read (StrLength, SizeOf (StrLength));
    OldPos := F.Position;
    F.Position := StrOffset;
    SetLength (S, StrLength);
    F.Read (PChar (S)^, StrLength);
    Result.Add (S);
    F.Position := OldPos;
  end;
end;

{ TImageBlock }

constructor TImageBlock.Create (AWidth, AHeight: integer);
begin
  Width := AWidth;
  Height := AHeight;
  GetMem (ImageData, Width * Height);
end;

constructor TImageBlock.CreateEmpty;
begin
  Width := 0;
  Height := 0;
  ImageData := nil;
end;

procedure TImageBlock.SetSize (AWidth, AHeight: integer);
begin
  if (Width <> AWidth) or (Height <> AHeight) then begin
    if ImageData <> nil then
      FreeMem (ImageData);
    Width := AWidth;
    Height := AHeight;
    GetMem (ImageData, Width * Height);
  end;
end;

destructor TImageBlock.Destroy;
begin
  if ImageData <> nil then
    FreeMem (ImageData);
  inherited Destroy;
end;

procedure TImageBlock.LoadPalette (F: TStream);
begin
  F.Read (Palette, 4*256);
end;

procedure TImageBlock.LoadImage (F: TStream);
begin
  F.Read (ImageData^, Width * Height);
end;

{ TMOSImage }

procedure TMOSImage.Load (F: TStream);
var
  LoadF: TStream;
  Signature: array [0..7] of char;
begin
  F.Read (Signature, 8);
  if StrLComp (Signature, 'MOSCV1  ', 8) = 0 then begin
    LoadF := Game.UnpackStream (F);
    try
      LoadUnpacked (LoadF);
    finally
      LoadF.Free;
    end;
  end
  else
    LoadUnpacked (F);
end;

procedure TMOSImage.LoadUnpacked (F: TStream);
var
  LastBlockWidth, LastBlockHeight: integer;
  Row, Col: integer;
  CurWidth: integer;
  BlockOffsets: array of array of integer;
  BlocksStart: integer;
begin
  F.Position := 0;
  F.Read (Header, SizeOf (Header));
  if StrLComp (Header.Signature, 'MOS V1  ', 8) <> 0 then
    raise Exception.Create ('Not a MOS image');
  // allocate blocks
  SetLength (Blocks, Header.Rows, Header.Cols);
  LastBlockWidth := Header.Width - (Header.Cols-1) * Header.BlkSize;
  LastBlockHeight := Header.Height - (Header.Rows-1) * Header.BlkSize;
  for Col := 0 to Header.Cols-1 do begin
    for Row := 0 to Header.Rows-2 do begin
      if Col = Header.Cols-1 then CurWidth := LastBlockWidth
      else CurWidth := Header.BlkSize;
      Blocks [Row, Col] := TImageBlock.Create (CurWidth, Header.BlkSize);
    end;
    if Col = Header.Cols-1 then CurWidth := LastBlockWidth
    else CurWidth := Header.BlkSize;
    Blocks [Header.Rows-1, Col] := TImageBlock.Create (CurWidth, LastBlockHeight);
  end;
  // read palettes
  for Row := 0 to Header.Rows-1 do
    for Col := 0 to Header.Cols-1 do
      Blocks [Row, Col].LoadPalette (F);
  // read block offsets
  SetLength (BlockOffsets, Header.Rows, Header.Cols);
  for Row := 0 to Header.Rows-1 do
    for Col := 0 to Header.Cols-1 do
      F.Read (BlockOffsets [Row, Col], 4);
  // read blocks
  BlocksStart := F.Position;
  for Row := 0 to Header.Rows-1 do
    for Col := 0 to Header.Cols-1 do begin
      F.Position := BlocksStart + BlockOffsets [Row, Col];
      Blocks [Row, Col].LoadImage (F);
    end;
end;

destructor TMOSImage.Destroy;
var
  Col, Row: integer;
begin
  for Col := 0 to Header.Cols-1 do
    for Row := 0 to Header.Rows-1 do
      Blocks [Row, Col].Free;
  inherited Destroy;
end;

{ TBAMImage }

procedure TBAMImage.Load (F: TStream);
var
  LoadF: TStream;
  Signature: array [0..7] of char;
begin
  F.Read (Signature, 8);
  if StrLComp (Signature, 'BAMCV1  ', 8) = 0 then begin
    LoadF := Game.UnpackStream (F);
    try
      LoadUnpacked (LoadF);
    finally
      LoadF.Free;
    end;
  end
  else
    LoadUnpacked (F);
end;

procedure TBAMImage.LoadUnpacked (F: TStream);
var
  Hdr: TBAMHeaderRec;
  FrameHdr: TBAMFrameHeaderRec;
  AnimHdr: TBAMAnimHeaderRec;
  i, j, FirstFrameOffset: integer;
  AnimStart: array of word;
  AnimArraySize: integer;
  AnimArray: array of word;
begin
  F.Position := 0;
  F.Read (Hdr, SizeOf (Hdr));
  if StrLComp (Hdr.Signature, 'BAM V1  ', 8) <> 0 then
    raise Exception.Create ('Not a BAM image');
  SetLength (Frames, Hdr.FrameCnt);
  SetLength (Animations, Hdr.AnimCnt);
  TransparentColor := Hdr.TransparentColor;
  // read palette
  F.Position := Hdr.PalettePtr;
  F.Read (Palette, SizeOf (Palette));
  // read frame headers
  FirstFrameOffset := -1;  // shutdown compiler warning
  F.Position := Hdr.FrameHeaderPtr;
  for i := 0 to Hdr.FrameCnt-1 do begin
    F.Read (FrameHdr, SizeOf (FrameHdr));
    if i = 0 then begin
      // first image - allocate main data block
      FirstFrameOffset := FrameHdr.GraphicPtr and $7FFFFFFF;
      GetMem (ImageData, F.Size-FirstFrameOffset);
    end;
    with Frames [i] do begin
      Width := FrameHdr.Width;
      Height := FrameHdr.Height;
      XPos := FrameHdr.XPos;
      YPos := FrameHdr.YPos;
      Data := ImageData + (FrameHdr.GraphicPtr and $7FFFFFFF) - FirstFrameOffset;
      NoRLE := (FrameHdr.GraphicPtr and $80000000 <> 0);
    end;
  end;
  // read animation headers
  SetLength (AnimStart, Hdr.AnimCnt);
  AnimArraySize := 0;
  for i := 0 to Hdr.AnimCnt-1 do begin
    F.Read (AnimHdr, SizeOf (AnimHdr));
    SetLength (Animations [i], AnimHdr.Frames);
    if AnimArraySize < AnimHdr.Frames + AnimHdr.Start then
      AnimArraySize := AnimHdr.Frames + AnimHdr.Start;
    AnimStart [i] := AnimHdr.Start;
  end;
  // read animation array
  SetLength (AnimArray, AnimArraySize);
  F.Position := Hdr.AnimArrayPtr;
  for i := 0 to AnimArraySize-1 do
    F.Read (AnimArray [i], 2);
  for i := 0 to Hdr.AnimCnt-1 do
    for j := 0 to Length (Animations [i])-1 do
      Animations [i, j] := AnimArray [AnimStart [i] + j];
  // read image data
  F.Position := FirstFrameOffset;
  F.Read (ImageData^, F.Size-FirstFrameOffset);
end;

destructor TBAMImage.Destroy;
begin
  FreeMem (ImageData);
  inherited Destroy;
end;

procedure TBAMImage.CalcAnimationSize (AnimIndex: integer; var W, H, RefX,
  RefY: integer);
var
  LeftFromRef, UpFromRef, RightFromRef, DownFromRef: integer;
  i: integer;
begin
  LeftFromRef := 0; UpFromRef := 0;
  RightFromRef := 0; DownFromRef := 0;
  for i := 0 to Length (Animations [AnimIndex])-1 do
    if Animations [AnimIndex, i] <> $FFFF then
      with Frames [Animations [AnimIndex, i]] do begin
        if XPos > LeftFromRef then LeftFromRef := XPos;
        if YPos > UpFromRef then UpFromRef := YPos;
        if Width - XPos > RightFromRef then RightFromRef := Width - XPos;
        if Height - YPos > DownFromRef then DownFromRef := Height - YPos;
      end;
  W := LeftFromRef + RightFromRef; H := UpFromRef + DownFromRef;
  RefX := LeftFromRef; RefY := UpFromRef;
end;

{ TBMPImage }

procedure TBMPImage.Load (F: TStream);
begin
  Bitmap := TBitmap.Create;
  Bitmap.LoadFromStream (F);
  Bitmap.TransparentColor := $00FF00;
end;

destructor TBMPImage.Destroy;
begin
  Bitmap.Free;
  inherited Destroy;
end;

{ TAreaMap }

procedure TAreaMap.Load (F: TStream);
begin
  FStream := F;
end;

destructor TAreaMap.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

procedure TAreaMap.GetBlock (Index: integer; Block: TImageBlock);
begin
  if (Index < 0) or ((Index+1) * (SizeOf (TImagePalette) + 64*64) > FStream.Size)
  then
    raise Exception.CreateFmt ('Invalid map block index %d', [Index]);
  FStream.Position := Index * (SizeOf (TImagePalette) + 64*64);
  Block.SetSize (64, 64);
  Block.LoadPalette (FStream);
  Block.LoadImage (FStream);
end;

{ TAreaWED }

procedure TAreaWED.Load (F: TStream);
var
  Hdr: TWEDHeaderRec;
  Offsets: TWEDOffsetsRec;
  EnvRec: TWEDEnvRec;
  i: integer;
  X: integer;
  {
  DoorRec: TWEDDoorRec;
  i, j: integer;
  SavedPos: integer;
  }

  procedure ReadPoly (var Poly: TWEDPoly);
  var
    PolyRec: TWEDPolyRec;
    i, SavedPos: integer;
    X, Y: word;
  begin
    F.Read (PolyRec, SizeOf (PolyRec));
    with PolyRec do begin
      Poly.Bounds := Rect (XMin, YMin, XMax, YMax);
      SetLength (Poly.Points, PointCount);
      Poly.Passable := (Passable and 1 = 0);
    end;
    SavedPos := F.Position;
    F.Position := Offsets.PointOffset + 4 * PolyRec.FirstPoint;
    for i := 0 to PolyRec.PointCount-1 do begin
      F.Read (X, 2);
      F.Read (Y, 2);
      Poly.Points [i] := Point (X, Y);
    end;
    F.Position := SavedPos;
  end;

  procedure ReadTilemap (var Overlay: TWEDOverlay; TileMapOffset, TileIndexLookupOffset: integer);
  var
    OldPos, OldPos2: integer;
    X, Y: integer;
    TileRec: TWEDTileRec;
  begin
    OldPos := F.Position;
    F.Position := TileMapOffset;
    for Y := 0 to Overlay.YBlocks-1 do
      for X := 0 to Overlay.XBlocks-1 do begin
        F.Read (TileRec, SizeOf (TWEDTileRec));
        with Overlay.TileMap [X, Y] do begin
          SetLength (PrimaryTile, TileRec.PrimaryTileCount);
          OldPos2 := F.Position;
          F.Position := TileIndexLookupOffset + 2*TileRec.PrimaryTileIndex;
          F.Read (PrimaryTile [0], 2*TileRec.PrimaryTileCount);
          if TileRec.SecondaryTileIndex = $FFFF then
            SecondaryTile := $FFFF
          else begin
            F.Position := TileIndexLookupOffset + 2*TileRec.SecondaryTileIndex;
            F.Read (SecondaryTile, 2);
          end;
          OverlayMask := TileRec.OverlayMask;
          F.Position := OldPos2;
        end;
      end;
    F.Position := OldPos;
  end;

begin
  F.Read (Hdr, SizeOf (Hdr));
  if StrLComp (Hdr.Signature, 'WED V1.3', 8) <> 0 then
    raise Exception.Create ('Not a WED file or unsupported version');
  SetLength (Overlays, Hdr.EnvCount);
  F.Position := Hdr.EnvOffset;
  for i := 0 to Hdr.EnvCount-1 do begin
    F.Read (EnvRec, SizeOf (EnvRec));
    with Overlays [i] do begin
      XBlocks := EnvRec.XBlocks;
      YBlocks := EnvRec.YBlocks;
      SetLength (TileMap, XBlocks);
      for X := 0 to XBlocks-1 do
        SetLength (TileMap [X], YBlocks);
    end;
    ReadTilemap (Overlays [i], EnvRec.TileMapOffset, EnvRec.TileIndexLookupOffset);
  end;
  F.Position := Hdr.OffsetsOffset;
  F.Read (Offsets, SizeOf (Offsets));
  {
  // read doors
  SetLength (Doors, Hdr.DoorCount);
  F.Position := Hdr.DoorOffset;
  for i := 0 to Hdr.DoorCount-1 do begin
    F.Read (DoorRec, SizeOf (DoorRec));
    Doors [i].Id := PChar8ToStr (DoorRec.Id);
    SetLength (Doors [i].Polys, DoorRec.PolyCount+1);
    SavedPos := F.Position;
    F.Position := DoorRec.PolyOffset1;
    ReadPoly (Doors [i].Polys [0]);
    F.Position := DoorRec.PolyOffset2;
    for j := 1 to DoorRec.PolyCount do
      ReadPoly (Doors [i].Polys [j]);
    F.Position := SavedPos;
  end;
  }
  // read wall polys
  SetLength (WallPolys, Offsets.WallPolyCount);
  F.Position := Offsets.WallPolyOffset;
  for i := 0 to Offsets.WallPolyCount-1 do
    ReadPoly (WallPolys [i]);
end;

{ TAreaFile }

procedure TAreaFile.Load (F: TStream);
var
  i: integer;
  SavedPos: integer;
  CREStream: TBIFFStream;
  AreaVersion: TGameType;

  procedure LoadPoints (var Poly: TWEDPoly; PointCount, FirstPoint: integer);
  var
    SavedPos: integer;
    PX, PY: word;
    j: integer;
  begin
    SavedPos := F.Position;
    F.Position := AreaOffsets.PointOffset + 4 * FirstPoint;
    SetLength (Poly.Points, PointCount);
    for j := 0 to PointCount-1 do begin
      F.Read (PX, 2);
      F.Read (PY, 2);
      Poly.Points [j] := Point (PX, PY);
    end;
    F.Position := SavedPos;
  end;

begin
  F.Read (AreaHdr, SizeOf (AreaHdr));
  if StrLComp (AreaHdr.Signature, 'AREAV1.0', 8) = 0 then
    AreaVersion := gtBaldur
  else if StrLComp (AreaHdr.Signature, 'AREAV9.1', 8) = 0 then
    AreaVersion := gtIcewind2
  else
    raise Exception.Create ('Not an AREA file');
  if AreaVersion = gtIcewind2 then   // skip 16 unknown bytes
    F.Position := F.Position + 16;
  F.Read (AreaOffsets, SizeOf (AreaOffsets));
  // load NPCs
  CREStream := nil;   // created on first use
  try
    SetLength (NPC, AreaOffsets.NPCCount);
    if AreaOffsets.NPCCount > 0 then begin
      F.Position := AreaOffsets.NPCOffset;
      for i := 0 to AreaOffsets.NPCCount-1 do
        with NPC [i] do begin
          F.Read (Hdr, SizeOf (Hdr));
          if Hdr.CREsize <= 0 then CREFile := nil
          else begin
            SavedPos := F.Position;
            if CREStream = nil then
              CREStream := TBIFFStream.Create (F, Hdr.CREoffset, Hdr.CREsize)
            else
              CREStream.SetBase (Hdr.CREoffset, Hdr.CREsize);
            try
              CREfile := Game.LoadFileFromStream (CREStream, -1, Hdr.Name,
                  ftCRE) as TCREFile;
            except
              CREfile := nil;
            end;
            F.Position := SavedPos;
          end;
        end;
    end;
  finally
    CREStream.Free;
  end;
  // load infos
  SetLength (Info, AreaOffsets.InfoCount);
  if AreaOffsets.InfoCount > 0 then begin
    F.Position := AreaOffsets.InfoOffset;
    for i := 0 to AreaOffsets.InfoCount-1 do begin
      F.Read (Info [i].Hdr, SizeOf (Info [i].Hdr));
      with Info [i] do begin
        with Hdr do
          Poly.Bounds := Rect (X1, Y1, X2, Y2);
        LoadPoints (Poly, Hdr.PointCount, Hdr.FirstPoint);
      end;
    end;
  end;
  // load entry points
  SetLength (Entries, AreaOffsets.EntryCount);
  if AreaOffsets.EntryCount > 0 then begin
    F.Position := AreaOffsets.EntryOffset;
    F.Read (Entries [0], AreaOffsets.EntryCount * SizeOf (Entries [0]));
  end;
  // load containers
  SetLength (Containers, AreaOffsets.ContainerCount);
  if AreaOffsets.ContainerCount > 0 then begin
    F.Position := AreaOffsets.ContainerOffset;
    for i := 0 to AreaOffsets.ContainerCount-1 do begin
      F.Read (Containers [i].Hdr, SizeOf (Containers [i].Hdr));
      with Containers [i] do begin
        Poly.Bounds := Rect (Hdr.X1, Hdr.Y1, Hdr.X2, Hdr.Y2);
        LoadPoints (Poly, Hdr.PointCount, Hdr.FirstPoint);
        SavedPos := F.Position;
        F.Position := AreaOffsets.ItemOffset + Hdr.StartItem * SizeOf (TCREItemRec);
        SetLength (Items, Hdr.ItemCount);
        F.Read (Items [0], Hdr.ItemCount * SizeOf (Items [0]));
        F.Position := SavedPos;
      end;
    end;
  end;
  // load doors
  SetLength (Doors, AreaOffsets.DoorCount);
  if AreaOffsets.DoorCount > 0 then begin
    F.Position := AreaOffsets.DoorOffset;
    for i := 0 to AreaOffsets.DoorCount-1 do begin
      F.Read (Doors [i].Hdr, SizeOf (Doors [i].Hdr));
      with Doors [i] do begin
        ClosedPoly.Bounds := Rect (Hdr.ClosedX1, Hdr.ClosedY1, Hdr.ClosedX2, Hdr.ClosedY2);
        LoadPoints (ClosedPoly, Hdr.ClosedPointCount, Hdr.ClosedFirstPoint);
        OpenPoly.Bounds := Rect (Hdr.OpenX1, Hdr.OpenY1, Hdr.OpenX2, Hdr.OpenY2);
        LoadPoints (OpenPoly, Hdr.OpenPointCount, Hdr.OpenFirstPoint);
      end;
    end;
  end;
  // load tiled objects
  SetLength (TiledObjects, AreaOffsets.TiledObjectCount);
  if AreaOffsets.TiledObjectCount > 0 then begin
    F.Position := AreaOffsets.TiledObjectOffset;
    F.Read (TiledObjects [0], AreaOffsets.TiledObjectCount * SizeOf (TiledObjects [0]));
  end;
  // load anims
  SetLength (Anims, AreaOffsets.AnimCount);
  if AreaOffsets.AnimCount > 0 then begin
    F.Position := AreaOffsets.AnimOffset;
    F.Read (Anims [0], AreaOffsets.AnimCount * SizeOf (Anims [0]));
  end;
  // load variables
  SetLength (Vars, AreaOffsets.VarCount);
  if AreaOffsets.VarCount > 0 then begin
    F.Position := AreaOffsets.VarOffset;
    F.Read (Vars [0], AreaOffsets.VarCount * SizeOf (Vars [0]));
  end;
  // load spawn points
  SetLength (SpawnPoints, AreaOffsets.SpawnPointCount);
  if AreaOffsets.SpawnPointCount > 0 then begin
    F.Position := AreaOffsets.SpawnPointOffset;
    F.Read (SpawnPoints [0], AreaOffsets.SpawnPointCount * SizeOf (SpawnPoints [0]));
  end;
end;

{ TGameTextFile }

procedure TGameTextFile.Load (F: TStream);
begin
  Strings := TStringList.Create;
  Strings.LoadFromStream (F);
end;

destructor TGameTextFile.Destroy;
begin
  Strings.Free;
  inherited Destroy;
end;

{ TWAVFile }

procedure TWAVFile.Load (F: TStream);
begin
  GetMem (FWave, F.Size);
  F.Read (FWave^, F.Size);
end;

destructor TWAVFile.Destroy;
begin
  FreeMem (FWave);
  inherited Destroy;
end;

{ TIDSFile }

destructor TIDSFile.Destroy;
begin
  Strings.Free;
  OrigStrings.Free;
  inherited Destroy;
end;

procedure TIDSFile.Load (F: TStream);
var
  S, IndexStr: string;
  i, P, Index: integer;
begin
  Strings := TStringList.Create;
  OrigStrings := TStringList.Create;
  SetLength (S, F.Size);
  F.Read (PChar (S)^, F.Size);
  Strings.Text := S;
  OrigStrings.Text := S;
  // delete first string (count of lines)
  Strings.Delete (0);
  // delete empty strings
  for i := Strings.Count-1 downto 0 do
    if IsEmptyStr (Strings [i], [' ']) then
      Strings.Delete (i);
  for i := Strings.Count-1 downto 0 do
    try
      S := Strings [i];
      P := WordPosition (2, S, [' ']);
      IndexStr := Trim (Copy (S, 1, P-1));
      if SameText (Copy (IndexStr, 1, 2), '0x') then begin
        Delete (IndexStr, 1, 2);
        Index := Hex2Dec (IndexStr);
      end
      else
        Index := StrToIntDef (IndexStr, 0);
      Delete (S, 1, P-1);
      Strings [i] := Trim (S);
      Strings.Objects [i] := TObject (Index);
    except
      Strings.Delete (i);
    end;
end;

function TIDSFile.HasIndex (Index: integer): boolean;
begin
  Result := (Strings.IndexOfObject (TObject (Index)) <> -1);
end;

function TIDSFile.LookupString (Index: integer): string;
var
  i: integer;
begin
  i := Strings.IndexOfObject (TObject (Index));
  if i = -1 then Result := IntToStr (Index)
  else Result := Strings [i];
end;

function TIDSFile.LookupText (Index: integer): string;
begin
  Result := LookupString (Index);
  IDSToText (Result);
end;

{ TScriptBuffer }

const
  LexemTypeNames: array [TLexemType] of string =
      ('ID', 'number', 'string', 'point', 'rect');

constructor TScriptBuffer.Create (F: TStream);
begin
  GetMem (Buf, F.Size);
  F.Read (Buf^, F.Size);
  P := Buf;
  BufEnd := Buf + F.Size;
end;

destructor TScriptBuffer.Destroy;
begin
  FreeMem (Buf);
  inherited Destroy;
end;

function TScriptBuffer.GetChar: char;
begin
  if P = BufEnd^ then raise Exception.Create ('Unexpected EOF');
  Result := P^;
  Inc (P);
end;

procedure TScriptBuffer.UngetChar;
begin
  Dec (P);
end;

procedure TScriptBuffer.ReadLexem (var Lexem: TScriptLexem);
var
  C: char;
  S: string;
  i: integer;

  function ReadNumber: integer;
  var
    C: char;
    S: string;
  begin
    C := GetChar;
    S := C;
    C := GetChar;
    while C in ['0'..'9'] do begin
      S := S + C;
      C := GetChar;
    end;
    UngetChar;
    Result := StrToInt (S);
  end;

begin
  repeat
    C := GetChar;
  until not (C in [' ', #10, #13, #9]);
  case C of
    'A'..'Z': begin
      Lexem.LexemType := ltID;
      SetLength (Lexem.ID, 2);
      Lexem.ID [1] := C;
      C := GetChar;
      Lexem.ID [2] := C;
    end;
    '-', '0'..'9': begin
      Lexem.LexemType := ltNumber;
      UngetChar;
      Lexem.Number := ReadNumber;
    end;
    '"': begin
      Lexem.LexemType := ltString;
      S := '';
      C := GetChar;
      while C <> '"' do begin
        S := S + C;
        C := GetChar;
      end;
      Lexem.Str := S;
    end;
    '[': begin
      i := ReadNumber;
      C := GetChar;
      if C = ',' then begin
        Lexem.LexemType := ltPoint;
        Lexem.Point.X := i;
        Lexem.Point.Y := ReadNumber;
      end
      else if C = '.' then begin
        Lexem.LexemType := ltRect;
        Lexem.Rect.X1 := i;
        Lexem.Rect.Y1 := ReadNumber;
        if GetChar <> '.' then raise Exception.Create ('Invalid rectangle format');
        Lexem.Rect.X2 := ReadNumber;
        if GetChar <> '.' then raise Exception.Create ('Invalid rectangle format');
        Lexem.Rect.Y2 := ReadNumber;
      end
      else
        raise Exception.Create ('Invalid character after [');
      if GetChar <> ']' then
        raise Exception.Create ('Missing closing ]');
    end
    else
      raise Exception.CreateFmt ('Invalid character %c', [C]);
  end;
end;

procedure TScriptBuffer.ReadLexemExpect (var Lexem: TScriptLexem;
  LexemType: TLexemType);
begin
  ReadLexem (Lexem);
  if Lexem.LexemType <> LexemType then
    raise Exception.CreateFmt ('Expected lexem type <%s>, found <%s> at offset 0x%X',
        [LexemTypeNames [LexemType], LexemTypeNames [Lexem.LexemType], P-Buf]);
end;

procedure TScriptBuffer.ReadLexemExpectID (var Lexem: TScriptLexem;
  const IDs: array of string);
var
  i: integer;
begin
  ReadLexemExpect (Lexem, ltID);
  for i := Low (IDs) to High (IDs) do
    if Lexem.ID = IDs [i] then Exit;
  raise Exception.CreateFmt ('Unexpected lexem ID <%s>', [Lexem.ID]);
end;

function TScriptBuffer.ReadLexemExpectNumber: integer;
var
  Lexem: TScriptLexem;
begin
  ReadLexemExpect (Lexem, ltNumber);
  Result := Lexem.Number;
end;

function TScriptBuffer.ReadLexemExpectString: string;
var
  Lexem: TScriptLexem;
begin
  ReadLexemExpect (Lexem, ltString);
  Result := Lexem.Str;
end;

{ TScriptFile }

procedure TScriptFile.Load (F: TStream);
var
  Lexem: TScriptLexem;
begin
  ScriptVersion := 0;
  if F.Size = 0 then Exit;
  Buf := TScriptBuffer.Create (F);
  try
    Buf.ReadLexemExpectID (Lexem, ['SC']);
    while true do begin
      Buf.ReadLexemExpectID (Lexem, ['SC', 'CR']);
      if Lexem.ID = 'SC' then Break
      else if Lexem.ID = 'CR' then ReadCondResponce;
    end;
  finally
    Buf.Free;
  end;
end;

procedure TScriptFile.ReadCondResponce;
var
  CR: TScriptCondResponce;
  Lexem: TScriptLexem;
begin
  Buf.ReadLexemExpectID (Lexem, ['CO']);
  while true do begin
    Buf.ReadLexemExpectID (Lexem, ['TR', 'CO']);
    if Lexem.ID = 'CO' then Break
    else if Lexem.ID = 'TR' then ReadTrigger (CR);
  end;
  Buf.ReadLexemExpectID (Lexem, ['RS']);
  while true do begin
    Buf.ReadLexemExpectID (Lexem, ['RS', 'RE']);
    if Lexem.ID = 'RS' then Break
    else if Lexem.ID = 'RE' then ReadResponce (CR);
  end;
  Buf.ReadLexemExpectID (Lexem, ['CR']);
  SetLength (CondResponces, Length (CondResponces)+1);
  CondResponces [Length (CondResponces)-1] := CR;
end;

procedure TScriptFile.ReadObject (var Obj: TScriptObject; StartSignature: boolean);
var
  Lexem, Lexem2: TScriptLexem;
  i: integer;  
begin
  if StartSignature then Buf.ReadLexemExpectID (Lexem, ['OB']);
  for i := 1 to 7 do
    Obj.IntArg [i] := Buf.ReadLexemExpectNumber;
  for i := 1 to 5 do
    Obj.Ident [i] := Buf.ReadLexemExpectNumber;
  for i := 1 to 2 do
    Obj.IntArg [i+7] := 0;
  with Obj.RectArg do begin
    X1 := -1; Y1 := -1; X2 := -1; Y2 := -1;
  end;
  Buf.ReadLexem (Lexem);
  case Lexem.LexemType of
    ltString: begin
      Obj.StrArg := Lexem.Str;
    end;
    ltNumber: begin
      Buf.ReadLexem (Lexem2);
      if Lexem2.LexemType = ltNumber then begin
        // rearrange numbers
        Obj.IntArg [8] := Obj.IntArg [2];
        Obj.IntArg [9] := Obj.IntArg [3];
        for i := 2 to 5 do
          Obj.IntArg [i] := Obj.IntArg [i+2];
        Obj.IntArg [6] := Obj.Ident [1];
        Obj.IntArg [7] := Obj.Ident [2];
        for i := 1 to 3 do
          Obj.Ident [i] := Obj.Ident [i+2];
        Obj.Ident [4] := Lexem.Number;
        Obj.Ident [5] := Buf.ReadLexemExpectNumber;
        Buf.ReadLexemExpect (Lexem, ltRect);
        Obj.RectArg := Lexem.Rect;
        Obj.StrArg := Buf.ReadLexemExpectString;
      end
      else if Lexem2.LexemType = ltRect then begin
        // Icewind Dale 2 format
        Obj.IntArg [8] := Obj.Ident [1];
        for i := 1 to 4 do
          Obj.Ident [i] := Obj.Ident [i+1];
        Obj.Ident [5] := Lexem.Number;
        Obj.RectArg := Lexem2.Rect;
        Obj.StrArg := Buf.ReadLexemExpectString;
        // we don't know what the remaining two numbers mean
        Buf.ReadLexemExpectNumber;
        Buf.ReadLexemExpectNumber;
      end
      else
        raise Exception.Create ('Unexpected lexem');
    end;
    ltRect: begin
      Obj.RectArg := Lexem.Rect;
      Obj.StrArg := Buf.ReadLexemExpectString;
    end;
    else
      raise Exception.Create ('Unexpected lexem');
  end;
  Buf.ReadLexemExpectID (Lexem, ['OB']);
end;

procedure TScriptFile.ReadTrigger (var CR: TScriptCondResponce);
var
  TR: TScriptTrigger;
  Lexem: TScriptLexem;
  i: integer;
  FirstStr: integer;
label
  TriggerDone;
begin
  with TR do begin
    TriggerID := Buf.ReadLexemExpectNumber;
    for i := 1 to 4 do IntArg [i] := 0;
    for i := 1 to 4 do begin
      Buf.ReadLexem (Lexem);
      if Lexem.LexemType = ltNumber then
        IntArg [i] := Lexem.Number
      else if (Lexem.LexemType = ltID) and (Lexem.ID = 'OB') then begin
        ReadObject (TR.ObjArg, false);
        goto TriggerDone;
      end
      else
        raise Exception.Create ('Unexpected lexem type');
    end;
    FirstStr := 1;
    if ScriptVersion = 0 then begin
      Buf.ReadLexem (Lexem);
      if Lexem.LexemType = ltPoint then begin
        ScriptVersion := 2;
        PointArg := Lexem.Point;
      end
      else if Lexem.LexemType = ltString then begin
        ScriptVersion := 1;
        FirstStr := 2;
        StrArg [1] := Lexem.Str
      end
      else
        raise Exception.Create ('Unexpected lexem type');
    end
    else if ScriptVersion = 2 then begin
      Buf.ReadLexemExpect (Lexem, ltPoint);
      PointArg := Lexem.Point;
    end;
    for i := FirstStr to 2 do
      StrArg [i] := Buf.ReadLexemExpectString;
    ReadObject (TR.ObjArg);
  end;
TriggerDone:
  Buf.ReadLexemExpectID (Lexem, ['TR']);
  SetLength (CR.Condition, Length (CR.Condition)+1);
  CR.Condition [Length (CR.Condition)-1] := TR;
end;

procedure TScriptFile.ReadResponce (var CR: TScriptCondResponce);
var
  RS: TScriptResponce;
  Lexem: TScriptLexem;
begin
  RS.Probability := Buf.ReadLexemExpectNumber;
  while true do begin
    Buf.ReadLexemExpectID (Lexem, ['AC', 'RE']);
    if Lexem.ID = 'RE' then Break
    else if Lexem.ID = 'AC' then ReadAction (RS);
  end;
  SetLength (CR.Responce, Length (CR.Responce)+1);
  CR.Responce [Length (CR.Responce)-1] := RS;
end;

procedure TScriptFile.ReadAction (var RS: TScriptResponce);
var
  AC: TScriptAction;
  i: integer;
  Lexem: TScriptLexem;
label
  ActionDone;
begin
  with AC do begin
    ActionID := Buf.ReadLexemExpectNumber;
    for i := 1 to 3 do
      ReadObject (ObjArg [i]);
    IntArg := Buf.ReadLexemExpectNumber;
    PointArg.X := Buf.ReadLexemExpectNumber;
    PointArg.Y := Buf.ReadLexemExpectNumber;
    for i := 2 to 3 do
      IntArg2 [i] := Buf.ReadLexemExpectNumber;
    for i := 1 to 2 do StrArg [i] := '';
    for i := 1 to 2 do begin
      Buf.ReadLexem (Lexem);
      if Lexem.LexemType = ltString then StrArg [i] := Lexem.Str
      else if (Lexem.LexemType = ltID) and (Lexem.ID = 'AC') then goto ActionDone
      else raise Exception.Create ('Unexpected lexem type');
    end;
  end;
  Buf.ReadLexemExpectID (Lexem, ['AC']);
ActionDone:
  SetLength (RS.Actions, Length (RS.Actions)+1);
  RS.Actions [Length (RS.Actions)-1] := AC;
end;

{ TCREFile }

procedure ConvertToOldEffect (const Rec20: TEffect20Rec; var Rec: TEffectRec);
begin
  Rec.EffectType := Rec20.EffectType;
  Rec.TargetType := Rec20.TargetType;
  Rec.Unknown    := Rec20.Unknown;
  Rec.NP1        := Rec20.NP1;
  Rec.NP2        := Rec20.NP2;
  Rec.Flags      := Rec20.Flags;
  if Rec20.Flags2 and 1 <> 0 then Rec.Flags := Rec.Flags and $100;
  if Rec20.Flags2 and 2 <> 0 then Rec.Flags := Rec.Flags and $200;
  Rec.Time       := Rec20.Time;
  Rec.Prob1      := Rec20.Prob1;
  Rec.Prob2      := Rec20.Prob2;
  StrLCopy (Rec.Resource, Rec20.Resource, 8);
  Rec.DiceCount  := Rec20.DiceCount;
  Rec.DiceValue  := Rec20.DiceValue;
  Rec.SaveType   := Rec20.SaveType;
  Rec.SaveBonus  := Rec20.SaveBonus;
end;

procedure TCREFile.Load (F: TStream);
var
  Rec0: TCRECommon0Rec;
  Rec: TCRECommon1Rec;
  RecExt12: TCRE12ExtRec;
  RecExt90: TCRE90ExtRec;
  AIRec: TCREAIRec;
  Offsets1: TCREOffsets1Rec;
  Offsets2: TCREOffsets2Rec;
  i: integer;
  EffRec: TEffect20Rec;
  OldPos: integer;
begin
  F.Read (Rec0, SizeOf (Rec0));
  // Torment has several v1.1 creatures, and on first sight, I have found
  // no differences in file format between v1.1 and v1.2
  if (StrLComp (Rec0.Signature, 'CRE V1.2', 8) = 0) or
     (StrLComp (Rec0.Signature, 'CRE V1.1', 8) = 0)
  then
    Version := 12
  else if StrLComp (Rec0.Signature, 'CRE V1.0', 8) = 0 then
    Version := 10
  else if StrLComp (Rec0.Signature, 'CRE V9.0', 8) = 0 then
    Version := 90
  else if StrLComp (Rec0.Signature, 'CRE V2.2', 8) = 0 then
    Version := 22
  else
    raise Exception.Create ('Unsupported CRE version or invalid file');
  if Version <> 22 then
    F.Read (Rec, SizeOf (Rec));
  AI_TeamName := '';
  Faction := '';
  LoadCommon0 (Rec0);
  if Version = 22 then begin
    F.Position := F.Position + 504;
    LoadAbilities22 (F);
    F.Position := F.Position + 8;
    LoadScripts22 (F);
    F.Position := F.Position + 232;
  end
  else begin
    LoadCommon1 (Rec);
    if Version = 12 then begin
      F.Read (RecExt12, SizeOf (RecExt12));
      LoadExt12 (RecExt12);
    end
    else if Version = 90 then
      F.Read (RecExt90, SizeOf (RecExt90));
  end;
  F.Read (AIRec, SizeOf (AIRec));
  LoadAIRec (AIRec);
  if Version = 22 then
    F.Position := F.Position + 606
  else begin
    F.Read (Offsets1, SizeOf (Offsets1));
    OldPos := F.Position;
    try
      // load known spells
      SetLength (KnownSpells, Offsets1.KnownSpellCount);
      F.Position := Offsets1.KnownSpellOffset;
      F.Read (KnownSpells [0], SizeOf (TCREKnownSpellRec) * Offsets1.KnownSpellCount);
      // load memorized spells
      LoadMemorizedSpells (F, Offsets1.MemorizedSpellOffset, Offsets1.MemorizedSpellCount);
    finally
      F.Position := OldPos;
    end;
  end;
  F.Read (Offsets2, SizeOf (Offsets2));
  // load items
  SetLength (Items, Offsets2.ItemCount);
  F.Position := Offsets2.ItemOffset;
  F.Read (Items [0], Offsets2.ItemCount * SizeOf (Items [0]));
  // load effects
  SetLength (Effects, Offsets2.EffectCount);
  F.Position := Offsets2.EffectOffset;
  if Rec0.EffectFormat = 0 then
    F.Read (Effects [0], SizeOf (TEffectRec) * Offsets2.EffectCount)
  else
    for i := 0 to Offsets2.EffectCount-1 do begin
      F.Read (EffRec, SizeOf (EffRec));
      ConvertToOldEffect (EffRec, Effects [i]);
    end;
  Dialog := PChar8ToStr (Offsets2.Dialog);
end;

procedure TCREFile.LoadCommon0 (const Hdr: TCRECommon0Rec);
begin
  Common0 := Hdr;
  if Hdr.NameTLK = -1 then TLKName := '?'
  else TLKName := Game.TLK.Text [Hdr.NameTLK];
  if Hdr.TooltipTLK = -1 then TLKTooltip := '?'
  else TLKTooltip := Game.TLK.Text [Hdr.TooltipTLK];
  if Version = 10 then begin
    MaxHP := Hdr.CurHP;
    CurHP := Hdr.MaxHP;
  end else begin
    MaxHP := Hdr.MaxHP;
    CurHP := Hdr.CurHP;
  end;
  DualClass := (Hdr.Flags and CRE_DUAL_ALL <> 0);
end;

procedure TCREFile.LoadCommon1 (const Hdr: TCRECommon1Rec);
var
  IDS: TIDSFile;

  function GetMageSpecName (MageSpec: integer): string;
  const
    MageSpecNames: array [1..9] of string =
      ('Abjurationist', 'Conjurer', 'Divination', 'Enchanter', 'Illusionist',
       'Invoker', 'Necromancer', 'Transmuter', 'Generalist');
  var
    i: integer;
  begin
    Result := 'Generalist';
    for i := 1 to 9 do
      if MageSpec and (1 shl (i+6)) <> 0 then begin
        Result := MageSpecNames [i];
        Exit;
      end;
  end;

begin
  Common1 := Hdr;
  IDS := Game.GetFileByName ('MageSpec', ftIDS) as TIDSFile;
  if IDS <> nil then
    MageSpec := IDS.LookupText (Hdr.SpecialistMage)
  else
    MageSpec := GetMageSpecName (Hdr.SpecialistMage);
  RacialEnemy := '';
  if Hdr.RacialEnemy <> 0 then begin
    IDS := Game.GetFileByName ('Race', ftIDS) as TIDSFile;
    if IDS <> nil then
      RacialEnemy := IDS.LookupText (Hdr.RacialEnemy);
  end;
end;

procedure TCREFile.LoadExt12 (const Hdr: TCRE12ExtRec);
var
  IDS: TIDSFile;
begin
  Race := Hdr.RaceName;
  IDS := Game.GetFileByName ('Team', ftIDS) as TIDSFile;
  AI_TeamName := IDS.LookupText (Hdr.AI_Team);
  IDS := Game.GetFileByName ('Faction', ftIDS) as TIDSFile;
  Faction := IDS.LookupText (Hdr.AI_Faction);
end;

procedure TCREFile.LoadAIRec (const Hdr: TCREAIRec);
var
  IDS: TIDSFile;
  S: string;
  i: integer;

  procedure SwapClasses;
  var
    S: string;
    i: integer;
  begin
    S := CharClass [1];
    i := Level [1];
    CharClass [1] := CharClass [2];
    Level [1] := Level [2];
    CharClass [2] := S;
    Level [2] := i;
  end;

begin
  AI_Race := Hdr.AI_Race;
  if Version = 10 then begin
    IDS := Game.GetFileByName ('Race', ftIDS) as TIDSFile;
    Race := IDS.LookupText (AI_Race);
  end;
  AI_Class := Hdr.AI_Class;
  IDS := Game.GetFileByName ('Class', ftIDS) as TIDSFile;
  if Hdr.AI_Class = 255 then begin
    CharClass [1] := 'No Class';
    CharClass [2] := '';
    CharClass [3] := '';
  end
  else if Hdr.AI_Class < 100 then begin   // all PC multi-classes are < 100
    S := IDS.LookupText (Hdr.AI_Class);
    for i := 1 to 3 do begin
      CharClass [i] := ExtractWord (i, S, [' ']);
      Level [i] := Common1.Level [i];
    end;
    if DualClass then    // ensure correct order for dual-classing (active class goes last)
      case Hdr.AI_Class of
        7 { FIGHTER_MAGE }, 8 { FIGHTER_CLERIC }, 9 { FIGHTER_THIEF },
            16 { FIGHTER_DRUID }:
          if Common0.Flags and CRE_DUAL_FIGHTER = 0 then SwapClasses;
        13 { MAGE_THIEF }:
          if Common0.Flags and CRE_DUAL_MAGE = 0 then SwapClasses;
        14 { CLERIC_MAGE }, 15 { CLERIC_THIEF }, 18 { CLERIC_RANGER }:
          if Common0.Flags and CRE_DUAL_CLERIC = 0 then SwapClasses;
      end;
  end
  else begin
    CharClass [1] := IDS.LookupText (Hdr.AI_Class);
    Level [1] := Common1.Level [1];
    CharClass [2] := '';
    CharClass [3] := '';
  end;
  IDS := Game.GetFileByName ('Gender', ftIDS) as TIDSFile;
  Gender := IDS.LookupText (Hdr.Gender);
  if Version = 22 then
    IDS := Game.GetFileByName ('Alignmnt', ftIDS) as TIDSFile
  else
    IDS := Game.GetFileByName ('Alignmen', ftIDS) as TIDSFile;
  Alignment := IDS.LookupText (Hdr.Alignment);
  IDS := Game.GetFileByName ('EA', ftIDS) as TIDSFile;
  AI_EAName := IDS.LookupString (Hdr.AI_EA);
  IDS := Game.GetFileByName ('General', ftIDS) as TIDSFile;
  AI_GeneralName := IDS.LookupString (Hdr.AI_General);
  IDS := Game.GetFileByName ('Specific', ftIDS) as TIDSFile;
  AI_SpecificName := IDS.LookupString (Hdr.AI_Specific);
  DeathVar := Hdr.DeathVar;
end;

procedure TCREFile.LoadMemorizedSpells (F: TStream; Offset, Count: integer);
var
  Rec: TCREMemorizedSpellRec;
  i: integer;
begin
  SetLength (MemorizedSpells, Count);
  F.Position := Offset;
  for i := 0 to Count-1 do begin
    F.Read (Rec, SizeOf (Rec));
    with MemorizedSpells [i] do begin
      SpellID := PChar8ToStr (Rec.SpellID);
      Available := Boolean (Rec.Available);
    end;
  end;
end;

procedure TCREFile.LoadAbilities22 (F: TStream);
begin
  with F, Common1 do begin
    Read (Str, 1);
    Read (Int, 1);
    Read (Wis, 1);
    Read (Dex, 1);
    Read (Con, 1);
    Read (Cha, 1);
  end;
end;

procedure TCREFile.LoadScripts22 (F: TStream);
begin
  with F, Common1 do begin
    Read (ScriptOverride [0], 8);
    Read (ScriptClass [0], 8);
    Read (ScriptRace [0], 8);
    Read (ScriptGeneral [0], 8);
    Read (ScriptDefault [0], 8);
  end;
end;

{ TITMFile }

procedure TITMFile.Load (F: TStream);
var
  Hdr11: TItem11ExHeaderRec;
  Wpn: TItemAbilityRec;
  i: integer;
  Flag: TItemFlag;
  OldPos: LongInt;
begin
  F.Read (Hdr10, SizeOf (Hdr10));
  if StrLComp (Hdr10.Signature, 'ITM V1  ', 8) = 0 then
    Version := 10
  else if StrLComp (Hdr10.Signature, 'ITM V1.1', 8) = 0 then
    Version := 11
  else if StrLComp (Hdr10.Signature, 'ITM V2.0', 8) = 0 then
    Version := 20
  else
    raise Exception.Create ('Unsupported ITM version or invalid file');
  if not Game.TLK.ValidID (Hdr10.NameIdent)  then NameIdent := ''
  else NameIdent := Game.TLK.Text [Hdr10.NameIdent];
  if not Game.TLK.ValidID (Hdr10.NameUnident) then NameUnident := ''
  else NameUnident := Game.TLK.Text [Hdr10.NameUnident];
  if not Game.TLK.ValidID (Hdr10.DescIdent) then DescIdent := '?'
  else DescIdent := Game.TLK.Text [Hdr10.DescIdent];
  if not Game.TLK.ValidID (Hdr10.DescUnident) then DescUnident := '?'
  else DescUnident := Game.TLK.Text [Hdr10.DescUnident];
  if Version = 11 then
    Hdr10.BAMIdCarried [0] := #0;
  Flags := [];
  for Flag := Low (TItemFlag) to High (TItemFlag) do
    if Hdr10.Attr and (1 shl Ord (Flag)) <> 0 then
      Include (Flags, Flag);
  if Version = 10 then
    Dialog := ''
  else begin
    F.Read (Hdr11, SizeOf (Hdr11));
    Dialog := PChar8ToStr (Hdr11.Dialog);
  end;
  SetLength (GlobalEffects, Hdr10.GlobalEffectCount);
  F.Position := Hdr10.EffectTablePtr + Hdr10.FirstGlobalEffect * SizeOf (TEffectRec);
  F.Read (GlobalEffects [0], Hdr10.GlobalEffectCount * SizeOf (TEffectRec));
  SetLength (Abilities, Hdr10.AbilityCount);
  F.Position := Hdr10.AbilityPtr;
  for i := 0 to Hdr10.AbilityCount-1 do begin
    F.Read (Wpn, SizeOf (Wpn));
    Abilities [i].Hdr := Wpn.Base;
    Abilities [i].IsSpell := false;
    Abilities [i].ProjectileType := Wpn.ProjectileType;
    SetLength (Abilities [i].Effects, Wpn.Base.EffectCount);
    if Wpn.Base.EffectCount > 0 then begin
      OldPos := F.Position;
      F.Position := Hdr10.EffectTablePtr + Wpn.Base.FirstEffect * SizeOf (TEffectRec);
      F.Read (Abilities [i].Effects [0], Wpn.Base.EffectCount * SizeOf (TEffectRec));
      F.Position := OldPos;
    end;
  end;
end;

function TITMFile.GetName: string;
begin
  if NameIdent <> '' then Result := NameIdent
  else if NameUnident <> '' then Result := NameUnident
  else Result := Name + ' <?>';
end;

{ TSPLFile }

procedure TSPLFile.Load (F: TStream);
var
  Abil: TAbilityRec;
  i: integer;
  OldPos: LongInt;
begin
  F.Read (Hdr, SizeOf (Hdr));
  if StrLComp (Hdr.Signature, 'SPL V1  ', 8) = 0 then
    Version := 10
  else if StrLComp (Hdr.Signature, 'SPL V2.0', 8) = 0 then
    Version := 20
  else
    raise Exception.CreateFmt ('%s: Unsupported SPL version or invalid file', [Name]);
  if Hdr.TLKName = -1 then
    SpellName := Name + ' <?>'
  else
    SpellName := Game.TLK.Text [Hdr.TLKName];
  if not Game.TLK.ValidID (Hdr.TLKDesc) then SpellDesc := '?'
  else SpellDesc := Game.TLK.Text [Hdr.TLKDesc];
  SetLength (Abilities, Hdr.AbilityCount);
  F.Position := Hdr.AbilityOffset;
  for i := 0 to Hdr.AbilityCount-1 do begin
    F.Read (Abil, SizeOf (Abil));
    Abilities [i].Hdr := Abil;
    Abilities [i].IsSpell := true;
    Abilities [i].ProjectileType := TSpellAbilityRec (Abil).ProjectileType;
    SetLength (Abilities [i].Effects, Abil.EffectCount);
    if Abil.EffectCount > 0 then begin
      OldPos := F.Position;
      F.Position := Hdr.EffectOffset + Abil.FirstEffect * SizeOf (TEffectRec);
      F.Read (Abilities [i].Effects [0], Abil.EffectCount * SizeOf (TEffectRec));
      F.Position := OldPos;
    end;
  end;
end;

{ TChUIFile }

procedure TChUIFile.Load (F: TStream);
var
  ChUIHdr: TChUIHeaderRec;
  i, j: integer;
  ControlIndex: array of TChUIControlIndexRec;
  OldPos: integer;
  ScreenSize: integer;
  PanelName: array [0..7] of char;
begin
  F.Read (ChUIHdr, SizeOf (ChUIHdr));
  if StrLComp (ChUIHdr.Signature, 'CHUIV1  ', 8) <> 0 then
    raise Exception.CreateFmt ('%s: Unsupported CHUI version or invalid file', [Name]);
  with ChUIHdr do
    ScreenSize := (ControlIndexOffset - PanelOffset) div PanelCount;
  if (ScreenSize <> 28) and (ScreenSize <> 36) then
    raise Exception.CreateFmt ('%s: Unknown CHUI panel record size %d', [Name, ScreenSize]);
  SetLength (Panels, ChUIHdr.PanelCount);
  F.Position := ChUIHdr.PanelOffset;
  for i := 0 to ChUIHdr.PanelCount-1 do begin
    if ScreenSize = 36 then begin
      F.Read (PanelName, 8);
      Panels [i].Name := 'Panel ' + IntToStr (i) + ': ' + PChar8ToStr (PanelName);
    end
    else
      Panels [i].Name := 'Panel ' + IntToStr (i);
    F.Read (Panels [i].Hdr, SizeOf (Panels [i].Hdr));
    with Panels [i] do begin
      SetLength (Controls, Hdr.ControlCount);
      SetLength (ControlIndex, Hdr.ControlCount);
      OldPos := F.Position;
      F.Position := ChUIHdr.ControlIndexOffset + Hdr.FirstControl * SizeOf (TChUIControlIndexRec);
      F.Read (ControlIndex [0], Hdr.ControlCount * SizeOf (TChUIControlIndexRec));
      for j := 0 to Hdr.ControlCount-1 do begin
        F.Position := ControlIndex [j].Offset;
        F.Read (Controls [j], $0E);  // $0E - size of common part for all control types
        case Controls [j].ControlType of
          ctButton: F.Read (Controls [j].Btn, SizeOf (TChUIButtonRec));
          ctSlider: F.Read (Controls [j].Slider, SizeOf (TChUISliderRec));
          ctEdit: F.Read (Controls [j].TextEdit, SizeOf (TChUITextEditRec));
          ctTextArea: F.Read (Controls [j].TextArea, SizeOf (TChUITextAreaRec));
          ctStatic: F.Read (Controls [j].Text, SizeOf (TChUITextRec));
          ctScrollBar: F.Read (Controls [j].ScrollBar, SizeOf (TChUIScrollBarRec));
          else
            raise Exception.CreateFmt ('Unsupported control type %d', [integer (Controls [j].ControlType)]);
        end;
      end;
      F.Position := OldPos;
    end;
  end;
end;

{ TWMapFile }

procedure TWMapFile.Load (F: TStream);
var
  WMapHdr: TWorldMapHeaderRec;
  i, OldPos: integer;
begin
  F.Read (WMapHdr, SizeOf (WMapHdr));
  if StrLComp (WMapHdr.Signature, 'WMAPV1.0', 8) <> 0 then
    raise Exception.CreateFmt ('%s: Unsupported WMAP version or invalid file', [Name]);
  SetLength (Maps, WMapHdr.WorldMapCount);
  F.Position := WMapHdr.WorldMapOffset;
  for i := 0 to WMapHdr.WorldMapCount-1 do
    with Maps [i] do begin
      F.Read (Hdr, SizeOf (Hdr));
      SetLength (Areas, Hdr.AreaCount);
      SetLength (Links, Hdr.LinkCount);
      OldPos := F.Position;
      F.Position := Hdr.AreaOffset;
      F.Read (Areas [0], Hdr.AreaCount * SizeOf (Areas [0]));
      F.Position := Hdr.LinkOffset;
      F.Read (Links [0], Hdr.LinkCount * SizeOf (Links [0]));
      F.Position := OldPos;
    end;
end;

{ TStoreFile }

procedure TStoreFile.Load (F: TStream);
var
  i: integer;
begin
  F.Read (Hdr, SizeOf (Hdr));
  if StrLComp (Hdr.Signature, 'STORV1.0', 8) = 0 then
    Version := 10
  else if StrLComp (Hdr.Signature, 'STORV1.1', 8) = 0 then
    Version := 11
  else
    raise Exception.CreateFmt ('%s: Unsupported STOR version or invalid file', [Name]);
  SetLength (Items, Hdr.SoldItemsCount);
  if Hdr.SoldItemsCount > 0 then begin
    F.Position := Hdr.SoldItemsOffset;
    if Version = 10 then
      F.Read (Items [0], Hdr.SoldItemsCount * SizeOf (Items [0]))
    else
      for i := 0 to Hdr.SoldItemsCount-1 do begin
        F.Read (Items [i], SizeOf (Items [i]));
        F.Seek (SizeOf (TStore11ExItemRec), soFromCurrent);
      end;
  end;
  SetLength (BoughtItems, Hdr.PurchasedItemsCount);
  if Hdr.PurchasedItemsCount > 0 then begin
    F.Position := Hdr.PurchasedItemsOffset;
    F.Read (BoughtItems [0], Hdr.PurchasedItemsCount * SizeOf (BoughtItems [0]));
  end;
  SetLength (Drinks, Hdr.DrinksCount);
  if Hdr.DrinksCount > 0 then begin
    F.Position := Hdr.DrinksOffset;
    F.Read (Drinks [0], Hdr.DrinksCount * SizeOf (Drinks [0]));
  end;
  SetLength (Spells, Hdr.SpellsCount);
  if Hdr.SpellsCount > 0 then begin
    F.Position := Hdr.SpellsOffset;
    F.Read (Spells [0], Hdr.SpellsCount * SizeOf (Spells [0]));
  end;
end;

{ TQuestsIni }

constructor TQuestsIni.Create (const FName: string);
var
  Ini: TIniFile;
  i, j, QuestCount, PossibleEndings: integer;
  Section: string;

  function ReadElem (var Elem: TQuestElem; const Name, CName, Prefix, Postfix: string): string;
  var
    CheckVar, Value, Condition, StrIndex: string;
    i, CheckCount, DescIndex: integer;
  begin
    DescIndex := Ini.ReadInteger (Section, 'desc'+Name+Postfix, -1);
    if DescIndex = -1 then begin
      if Postfix <> '' then
        DescIndex := Ini.ReadInteger (Section, 'desc'+Name, -1)
      else
        raise Exception.Create ('Quest description not found');
    end;
    Elem.DescIndex := DescIndex;
    CheckCount := Ini.ReadInteger (Section, CName + 'Checks' + Postfix, 0);
    SetLength (Elem.Checks, CheckCount);
    for i := 0 to CheckCount-1 do begin
      StrIndex := IntToStr (i+1);
      CheckVar := Ini.ReadString (Section, Prefix + 'Var' + Postfix + StrIndex, '');
      Value := Ini.ReadString (Section, Prefix + 'Value' + Postfix + StrIndex, '');
      Condition := Ini.ReadString (Section, Prefix + 'Condition' + Postfix + StrIndex, '');
      if Condition = 'EQ' then Condition := '='
      else if Condition = 'GT' then Condition := '>'
      else if Condition = 'LT' then Condition := '<'
      else if Condition = 'NE' then Condition := '<>'
      else Condition := ' ' + Condition + ' '; // do not abort on unknown conditions
      Elem.Checks [i] := CheckVar + Condition + Value;
    end;
  end;

begin
  Ini := TIniFile.Create (FName);
  QuestCount := Ini.ReadInteger ('init', 'questcount', 0);
  SetLength (Quests, QuestCount);
  for i := 0 to QuestCount-1 do begin
    Section := IntToStr (i);
    with Quests [i] do begin
      TitleIndex := Ini.ReadInteger (Section, 'title', -1);
      ReadElem (Assigned, 'Assigned', 'assigned', 'a', '');
      PossibleEndings := Ini.ReadInteger (Section, 'possibleEndings', 1);
      SetLength (Complete, PossibleEndings);
      ReadElem (Complete [0], 'Completed', 'complete', 'c', '');
      for j := 1 to PossibleEndings-1 do
        ReadElem (Complete [j], 'Completed', 'complete', 'c', Char (Ord ('A')+j));
    end;
  end;
  Ini.Free;
end;

{ TSaveGame }

constructor TSaveGame.Create (const ASavePath: string);
var
  S: string;
begin
  FSavePath := ASavePath;
  FSavFiles := TStringList.Create;
  S := ExtractFileName (ASavePath);
  Index := StrToInt (Copy (S, 1, 9));
  Name := Copy (S, 11, 255);
  Loaded := false;
end;

destructor TSaveGame.Destroy;
begin
  Unload;
  FSavFiles.Free;
  inherited Destroy;
end;

const
  SaveFileName: array [TGameType] of string = ('baldur', 'torment', 'icewind', 'icewind2');

procedure TSaveGame.Load;
var
  BaseName: string;
begin
  if Loaded then Exit;
  BaseName := MkPath (SaveFileName [Game.GameType], FSavePath);
  LoadGameFile (BaseName + '.gam');
  FUnpPath := MkPath ('InfExp.tmp', FSavePath);
  CreateDir (FUnpPath);
  Game.UnpackFile (BaseName + '.sav', FUnpPath, FSavFiles);
  Loaded := true;
end;

procedure TSaveGame.Unload;
var
  i: integer;
  FileNames: TStringList;
begin
  if not Loaded then Exit;
  for i := 0 to Length (Party)-1 do
    Party [i].CRE.Free;
  SetLength (Party, 0);
  for i := 0 to Length (NPC)-1 do
    NPC [i].CRE.Free;
  SetLength (NPC, 0);
  FileNames := TStringList.Create;
  try
    FindAllFiles (FUnpPath, '*.*', FileNames);
    for i := 0 to FileNames.Count-1 do
      SysUtils.DeleteFile (FileNames [i]);
  finally
    FileNames.Free;
  end;
  RemoveDir (FUnpPath);
  Loaded := false;
end;

procedure TSaveGame.LoadGameFile (const FName: string);
var
  Hdr: TGameHeaderRec;
  HdrTorment: TGameHeaderTormentRec;
  F: TFileStream;
  i: integer;
begin
  F := TFileStream.Create (FName, fmOpenRead or fmShareDenyNone);
  try
    if Game.GameType <> gtTorment then begin
      F.Read (Hdr, SizeOf (Hdr));
      HdrCommon := Hdr.HdrCommon;
      SetLength (KillVars, 0);
    end
    else begin
      F.Read (HdrTorment, SizeOf (HdrTorment));
      HdrCommon := HdrTorment.HdrCommon;
      SetLength (KillVars, HdrTorment.KillVarCount);
      F.Position := HdrTorment.KillVarOffset;
      F.Read (KillVars [0], HdrTorment.KillVarCount * SizeOf (TGameVarRec));
    end;
    with HdrCommon do begin
      SetLength (Party, PartyCount);
      F.Position := PartyOffset;
      for i := 0 to PartyCount-1 do
        LoadGameCharacter (F, Party [i]);
      SetLength (NPC, NPCCount);
      if NPCCount > 0 then begin
        F.Position := NPCOffset;
        for i := 0 to NPCCount-1 do
          LoadGameCharacter (F, NPC [i]);
      end;
      SetLength (Vars, VarCount);
      F.Position := VarOffset;
      F.Read (Vars [0], VarCount * SizeOf (TGameVarRec));
      SetLength (Journal, JournalCount);
      if JournalCount > 0 then begin
        F.Position := JournalOffset;
        F.Read (Journal [0], JournalCount * SizeOf (Journal [0])); 
      end;
    end;
  finally
    F.Free;
  end;
end;

procedure TSaveGame.LoadGameCharacter (F: TStream;
  var Char: TSaveGameCharacter);
var
  CharRec: TGameCharacterRec;
  CharTormentRec: TGameCharacterTormentRec;
  CharBaldurRec: TGameCharacterBaldurRec;
  CharIcewind2Rec: TGameCharacterIcewind2Rec;
  OldPos: integer;
  Stream: TBIFFStream;
begin
  if Game.GameType = gtIcewind then begin
    F.Read (CharRec, SizeOf (CharRec));
    with CharRec do begin
      Char.PartyCommon := Common;
      Char.Name := Name;
      Char.Stats := Stats;
    end;
  end
  else if Game.GameType = gtIcewind2 then begin
    F.Read (CharIcewind2Rec, SizeOf (CharIcewind2Rec));
    with CharIcewind2Rec do begin
      Char.PartyCommon := Common;
      Char.Name := Name;
      Char.Stats := Stats;
    end;
  end
  else if Game.GameType = gtBaldur then begin
    F.Read (CharBaldurRec, SizeOf (CharBaldurRec));
    with CharBaldurRec do begin
      Char.PartyCommon := Common;
      Char.Name := Name;
      Char.Stats := Stats;
    end;
  end
  else begin
    F.Read (CharTormentRec, SizeOf (CharTormentRec));
    Char.Name := '';
    with CharTormentRec do begin
      Char.PartyCommon := Common;
      Char.Stats := Stats;
    end;
  end;
  OldPos := F.Position;
  Stream := TBIFFStream.Create (F, Char.PartyCommon.CREOffset, Char.PartyCommon.CRESize);
  try
    SetLength (Char.CREData, Char.PartyCommon.CRESize);
    Stream.Read (Char.CREData [0], Char.PartyCommon.CRESize);
    Stream.Position := 0;
    try
      Char.CRE := TCharCREFile.Create (-1, '', ftCRE);
      Char.CRE.Load (Stream);
    except
      Char.CRE := nil;
    end;
  finally
    Stream.Free;
    F.Position := OldPos;
  end;
end;

{ TSaveGameList }

function SaveGameCompare (Item1, Item2: pointer): integer;
begin
  Result := TSaveGame (Item1).Index - TSaveGame (Item2).Index;
end;

constructor TSaveGameList.Create (const SavePath: string);
var
  SR: TSearchRec;
  FindResult: integer;
begin
  FSaveGames := TList.Create;
  FindResult := FindFirst (SavePath + '\*.*', faDirectory, SR);
  while FindResult = 0 do begin
    if (SR.Attr and faDirectory <> 0) and (Length (SR.Name) >= 10) and
        (SR.Name [10] = '-')
    then
      FSaveGames.Add (TSaveGame.Create (MkPath (SR.Name, SavePath)));
    FindResult := FindNext (SR);
  end;
  SysUtils.FindClose (SR);
  FSaveGames.Sort (SaveGameCompare);
end;

destructor TSaveGameList.Destroy;
var
  i: integer;
begin
  for i := FSaveGames.Count-1 downto 0 do
    TSaveGame (FSaveGames [i]).Free;
  FSaveGames.Free;
  inherited;
end;

function TSaveGameList.Count: integer;
begin
  Result := FSaveGames.Count;
end;

function TSaveGameList.GetItems (i: integer): TSaveGame;
begin
  Result := TSaveGame (FSaveGames [i]);
end;

{ TInfinityGame }

constructor TInfinityGame.Create (const Directory: string);
var
  FName: string;
begin
  Game := Self;
  Path := Directory;
  FName := MkPath ('chitin.key', Directory);
  if not FileExists (FName) then begin
    Game := nil;
    raise Exception.Create ('This directory does not contain an Infinity Engine game');
  end;
  Key := TChitinKey.Create (FName);
  FName := MkPath ('baldur.ini', Directory);
  if FileExists (FName) then begin
    Key.ReadIniFile (FName);
    GameType := gtBaldur;
  end
  else begin
    FName := MkPath ('torment.ini', Directory);
    if FileExists (FName) then begin
      Key.ReadIniFile (FName);
      GameType := gtTorment;
    end
    else begin
      FName := MkPath ('icewind.ini', Directory);
      if FileExists (FName) then begin
        Key.ReadIniFile (FName);
        GameType := gtIcewind;
      end
      else begin
        FName := MkPath ('icewind2.ini', Directory);
        if FileExists (FName) then begin
          Key.ReadIniFile (FName);
          Game.GameType := gtIcewind2;
        end
        else
          raise Exception.Create ('No .INI file for any of the known games found in this directory');
      end;
    end;
  end;

  TLK := TTLKFile.Create (MkPath ('dialog.tlk', Directory), MkPath ('dialog.ie.tlk', Directory));
  SaveGames := TSaveGameList.Create (MkPath ('save', Directory));
  MPSaveGames := TSaveGameList.Create (MkPath ('mpsave', Directory));
  FFiles := TList.Create;
  FixCategoryNames;
end;

destructor TInfinityGame.Destroy;
begin
  DestroyList (FFiles);
  Key.Free;
  TLK.Free;
  SaveGames.Free;
  MPSaveGames.Free;
  Game := nil;
  inherited Destroy;
end;

function TInfinityGame.LoadFile (AIndex: integer): TGameFile;
var
  F: TStream;
begin
  F := Key.CreateStream (AIndex);
  Result := LoadFileFromStream (F, AIndex, Key.Files [AIndex].FName, Key.Files [AIndex].FileType);
  // the area map is the only file type which is loaded dynamically
  // (i.e. not all at once)
  if Key.Files [AIndex].FileType <> ftMAP then
    F.Free;
end;

function TInfinityGame.LoadFileFromStream (F: TStream; AIndex: integer;
    const AFName: string; AFileType: TFileType): TGameFile;
var
  C: TGameFileClass;
begin
  Result := nil;
  case AFileType of
    ftMOS:    C := TMOSImage;
    ftBAM:    C := TBAMImage;
    ftBMP:    C := TBMPImage;
    ftDLG:    C := TDlg;
    ftWAV:    C := TWAVFile;
    ftIDS:    C := TIDSFile;
    ftScript: C := TScriptFile;
    ftMAP:    C := TAreaMap;
    ftWED:    C := TAreaWED;
    ftArea:   C := TAreaFile;
    ftINI:    C := TGameIniFile;
    ft2DA:    C := TGame2DAFile;
    ftCRE:    C := TCREFile;
    ftITM:    C := TITMFile;
    ftSPL:    C := TSPLFile;
    ftCHU:    C := TChUIFile;
    ftWMAP:   C := TWMapFile;
    ftSTOR:   C := TStoreFile;
    else C := nil;
  end;
  if C = nil then Exit;
  Result := C.Create (AIndex, AFName, AFileType);
  Result.Load (F);
  FFiles.Add (Result);
end;

function TInfinityGame.LoadExternalFile (const AFilePath, AName: string;
  AFileType: TFileType): TGameFile;
var
  F: TStream;
begin
  F := CreateFileStream (AFilePath);
  try
    Result := LoadFileFromStream (F, -1, AName, AFileType);
  finally
    F.Free;
  end;
end;

function TInfinityGame.GetFile (AIndex: integer): TGameFile;
var
  i: integer;
begin
  Assert (AIndex >= 0);
  for i := 0 to FFiles.Count-1 do
    if TGameFile (FFiles [i]).Index = AIndex then begin
      Result := TGameFile (FFiles [i]);
      Exit;
    end;
  Result := LoadFile (AIndex);
end;

function TInfinityGame.GetFileByName (const Name: string;
  FileType: TFileType): TGameFile;
var
  i: integer;
  GF: TGameFile;
  OverrideFName: string;
begin
  Result := nil;
  for i := 0 to FFiles.Count-1 do begin
    GF := TGameFile (FFiles [i]);
    if SameText (GF.Name, Name) and (GF.FileType = FileType) then begin
      Result := GF;
      Exit;
    end;
  end;
  for i := 0 to Length (Key.Files)-1 do
    if SameText (Key.Files [i].FName, Name) and (Key.Files [i].FileType = FileType) then begin
      Result := LoadFile (i);
      Exit;
    end;
  // check if a file exists in the override dialog but is not listed
  // in the key (MODs use this extensively)
  OverrideFName := MkPath (Name + FileTypeExts [FileType], Key.OverridePath);
  if FileExists (OverrideFName) then
    Result := LoadExternalFile (OverrideFName, Name, FileType);
end;

function TInfinityGame.GetFileByName (const Name: TResRef;
  FileType: TFileType): TGameFile;
begin
  Result := GetFileByName (PChar8ToStr (Name), FileType);
end;

procedure TInfinityGame.FreeFile (AFile: TGameFile);
begin
  if AFile.LockCount <= 0 then begin
    FFiles.Remove (AFile);
    AFile.Free;
  end;
end;

procedure TInfinityGame.FreeFiles;
var
  i: integer;
begin
  for i := FFiles.Count-1 downto 0 do
    if TGameFile (FFiles [i]).LockCount <= 0 then FreeFile (FFiles [i]);
end;

function TInfinityGame.FilesLoaded: integer;
begin
  Result := FFiles.Count;
end;

procedure TInfinityGame.UnpackFile (const PackFName, DestDir: string;
    OutFiles: TStrings = nil);
var
  F, OutF: TFileStream;
  FNameLen: integer;
  FName: string;
  UnpackedLen, PackedLen: integer;
  PackedBuf, UnpackedBuf: PChar;
  PackedBufSize, UnpackedBufSize: integer;
begin
  PackedBufSize := 0;
  PackedBuf := nil;
  UnpackedBufSize := 0;
  UnpackedBuf := nil;
  F := TFileStream.Create (PackFName, fmOpenRead or fmShareDenyNone);
  try
    F.Position := 8;   // skip signature
    while F.Position < F.Size do begin
      F.Read (FNameLen, 4);
      SetLength (FName, FNameLen);
      F.Read (FName [1], FNameLen);
      SetLength (FName, FNameLen-1);  // remove trailing #0
      // Heart of Winter BIFFs have filenames beginning with \
      if FName [1] = '\' then Delete (FName, 1, 1);
      F.Read (UnpackedLen, 4);
      F.Read (PackedLen, 4);
      if PackedLen > PackedBufSize then begin
        if PackedBuf <> nil then FreeMem (PackedBuf);
        GetMem (PackedBuf, PackedLen);
        PackedBufSize := PackedLen;
      end;
      if UnpackedLen > UnpackedBufSize then begin
        if UnpackedBuf <> nil then FreeMem (UnpackedBuf);
        GetMem (UnpackedBuf, UnpackedLen);
        UnpackedBufSize := UnpackedLen;
      end;
      F.Read (PackedBuf [0], PackedLen);
      DecompressToUserBuf (PackedBuf, PackedLen, UnpackedBuf, UnpackedLen);
      OutF := TFileStream.Create (MkPath (FName, DestDir), fmCreate);
      try
        OutF.Write (UnpackedBuf [0], UnpackedLen);
      finally
        OutF.Free;
      end;
      if OutFiles <> nil then
        OutFiles.Add (MkPath (FName, DestDir));
    end;
  finally
    F.Free;
    if PackedBuf <> nil then FreeMem (PackedBuf);
    if UnpackedBuf <> nil then FreeMem (UnpackedBuf);
  end;
end;

function TInfinityGame.UnpackStream (F: TStream): TMemoryStream;
var
  PackSize, UnpackSize: integer;
  PackBuf: PChar;
begin
  F.Position := 8;
  F.Read (UnpackSize, 4);
  Result := TMemoryStream.Create;
  Result.Size := UnpackSize;
  PackSize := F.Size-8-4;
  GetMem (PackBuf, PackSize);
  try
    F.Read (PackBuf^, PackSize);
    DecompressToUserBuf (PackBuf, PackSize, Result.Memory, UnpackSize);
  finally
    FreeMem (PackBuf);
  end;
end;

procedure TInfinityGame.FixCategoryNames;
const
  OrigCategoryNames: array [0..$39] of string =
    ('Books/Misc', 'Amulets/Necklaces', 'Armor', 'Belts', 'Boots', 'Arrows',
     'Bracers/Gauntlets', 'Headgear', 'Keys', 'Potions', 'Rings',
     'Scrolls', 'Shields', 'Unknown (0D)', 'Bullets', 'Bows', 'Daggers',
     'Maces', 'Slings', 'Short swords', 'Long swords', 'Hammers',
     'Morning stars', 'Flails', 'Darts', 'Axes', 'Quarterstaff',
     'Crossbows', 'Hand-to-hand weapons', 'Spears', 'Halberds', 'Bolts',
     'Cloaks/Robes', 'Gold pieces', 'Gems', 'Wands', 'Ancient Armor',
     'Broken Shield', 'Broken Swords', 'Unknown (27)', 'Unknown (28)',
     'Lyres', 'Candles', 'Unknown (2B)', 'Clubs', 'Unknown (2D)',
     'Unknown (2E)', 'Large shields', 'Unknown (30)', 'Medium shields',
     'Unknown (32)', 'Unknown (33)', 'Unknown (34)', 'Small shields',
     'Unknown (36)', 'Telescope', 'Bottles', 'Great swords');
var
  i: integer;
begin
  for i := Low (OrigCategoryNames) to High (OrigCategoryNames) do
    CategoryNames [i] := OrigCategoryNames [i];
  if GameType = gtTorment then begin
    CategoryNames [$24] := 'Eyeballs';
    CategoryNames [$25] := 'Bracelets';
    CategoryNames [$26] := 'Earrings';
    CategoryNames [$27] := 'Tattoos';
    CategoryNames [$28] := 'Lenses';
    CategoryNames [$29] := 'Teeth';
  end;
end;

end.
