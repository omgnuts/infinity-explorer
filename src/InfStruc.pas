{ $Header: /cvsroot/InfExp/InfExp/src/InfStruc.pas,v 1.13 2000/11/01 19:00:14 yole Exp $
  Infinity Engine data structures
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit InfStruc;

interface

{$ALIGN OFF}

type
  TFileType = (ftNone, ftBMP, ftMVE, ftWAV, ftWFX, ftPLT, ftBAM, ftWED,
       ftCHU, ftMAP, ftMOS, ftITM, ftSPL, ftSCRIPT, ftIDS, ftCRE, ftAREA,
       ftDLG, ft2DA, ftGAME, ftSTOR, ftWMAP, ftEFF, ftVVC, ftPRO, ftINI,
       ftSRC);
  TFileTypes = set of TFileType;

  TResRef = array [0..7] of char;

  TGameType = (gtBaldur, gtTorment, gtIcewind, gtIcewind2);

// -- CHITIN.KEY and BIFFs ---------------------------------------------------

  TChitinKeyHdr = record
    Signature: array [0..7] of char;
    BIFF_Count: LongInt;
    File_Count: LongInt;
    BIFF_Offset: LongInt;
    File_Offset: LongInt;
  end;

  TChitinBIFFRec = record
    BIFF_Length: LongInt;
    Name_Offset: LongInt;
    Name_Length: word;
    CD_Mask: word;
  end;

  TChitinFileRec = record
    Name: array [0..7] of char;
    FileType: word;
    Index: word;
    BIFF: word;
  end;

  TBIFFHeaderRec = record
    Signature: array [0..7] of char;
    ElemCount, MapCount: integer;
    DirOffset: integer;
  end;

  TBIFFEntryRec = record
    ElemIndex, BIFFIndex: word;
    Offset, Size, FileType: integer;
  end;

  TBIFFMapEntryRec = record
    MapIndex: LongInt;
    Offset: integer;
    BlockCount, BlockSize: integer;
    FileType: integer;
  end;

// -- TLK --------------------------------------------------------------------

  TTLKHeaderRec = record
    Signature: array [0..7] of char;
    Unknown: word;
    RecordCount, TextOffset: LongInt;
  end;

  TTLKEntryRec = record
    Flag: word;
    Sound: array [0..15] of char;
    Offset, Length: LongInt;
  end;

// -- DLG --------------------------------------------------------------------

  TDlgHeaderRec = record
    Signature: array [0..7] of char;
    PhraseCount, PhraseOffset: LongInt;
    ResponceCount, ResponceOffset: LongInt;
    CondOffset, CondCount: LongInt;
    RespCondOffset, RespCondCount: LongInt;
    ActionOffset, ActionCount: LongInt;
  end;

  TDlgPhraseRec = record
    TlkIndex: LongInt;
    FirstResponce, ResponceCount: LongInt;
    Cond: LongInt;
  end;

  TDlgResponceRec = record
    Flags: LongInt;
    TlkIndex: LongInt;
    JournalIndex: LongInt;
    Cond, Action: LongInt;
    Dlg: TResRef;
    DlgPhrase: LongInt;
  end;

// -- MOS --------------------------------------------------------------------

  TMOSHeaderRec = record
    Signature: array [0..7] of char;
    Width, Height: word;
    Cols, Rows: word;
    BlkSize, BlkBPP: LongInt;
  end;

  TPaletteEntry = record
    R, G, B, A: byte;
  end;

  TImagePalette = array [0..255] of TPaletteEntry;

// -- BAM --------------------------------------------------------------------

  TBAMHeaderRec = record
    Signature: array [0..7] of char;
    FrameCnt: word;
    AnimCnt: byte;
    TransparentColor: byte;
    FrameHeaderPtr: LongInt;
    PalettePtr: LongInt;
    AnimArrayPtr: LongInt;
  end;

  TBAMFrameHeaderRec = record
    Width, Height: word;
    XPos, YPos: SmallInt;
    GraphicPtr: LongWord;
  end;

  TBAMAnimHeaderRec = record
    Frames, Start: word;
  end;

// -- WED --------------------------------------------------------------------

  TWEDHeaderRec = record
    Signature: array [0..7] of char;
    EnvCount: LongInt;
    DoorCount: LongInt;
    EnvOffset: LongInt;
    OffsetsOffset: LongInt;
    DoorOffset: LongInt;
    DoorTileCellOffset: LongInt;
  end;

  TWEDEnvRec = record
    XBlocks, YBlocks: word;
    ResourceID: TResRef;
    Unknown: LongInt;
    TileMapOffset: LongInt;
    TileIndexLookupOffset: LongInt;
  end;

  TWEDOffsetsRec = record
    WallPolyCount: LongInt;
    WallPolyOffset: LongInt;
    PointOffset: LongInt;
    WallGroupOffset: LongInt;
    IndexOffset: LongInt;
  end;

  TWEDDoorRec = record
    Id: array [0..7] of char;
    Unknown: array [1..4] of word;
    PolyCount: word;
    PolyOffset1, PolyOffset2: LongInt;
  end;

  TWEDPolyRec = record
    FirstPoint, PointCount: LongInt;
    Passable: byte;
    Unknown: byte;
    XMin, XMax, YMin, YMax: word;
  end;

  TWEDTileRec = record
    PrimaryTileIndex: word;
    PrimaryTileCount: word;
    SecondaryTileIndex: word;
    OverlayMask: byte;
    Unknown: array [1..3] of byte;
  end;

// -- ARE --------------------------------------------------------------------

  TAreaHeaderRec = record
    Signature: array [0..7] of char;
    AreaID: TResRef;
    Unknown1: array [1..8] of byte;
    ExitN: TResRef;
    Unknown2: LongInt;
    ExitW: TResRef;
    Unknown3: LongInt;
    ExitS: TResRef;
    Unknown4: LongInt;
    ExitE: TResRef;
    Unknown5: LongInt;
    Flags: word;
    RainProbability, SnowProbability: word;
    FogProbability, LightningProbability: word;
    Unknown6: word;
  end;

  TAreaOffsetsRec = record
    NPCOffset: LongInt;
    NPCCount: word;
    InfoCount: word;
    InfoOffset: LongInt;
    SpawnPointOffset, SpawnPointCount: LongInt;
    EntryOffset: LongInt;
    EntryCount: LongInt;
    ContainerOffset: LongInt;
    ContainerCount: word;
    ItemCount: word;
    ItemOffset: LongInt;
    PointOffset: LongInt;
    PointCount: word;
    SoundCount: word;
    SoundOffset: LongInt;
    VarOffset: LongInt;
    VarCount: LongInt;
    Unknown7: LongInt;
    AIScript: array [0..7] of char;
    Unknown8: array [1..8] of byte;
    DoorCount, DoorOffset: LongInt;
    AnimCount, AnimOffset: LongInt;
    TiledObjectCount, TiledObjectOffset: LongInt;
  end;

  TAreaNPCRec = record
    Name: array [0..31] of char;
    CurX, CurY: word;
    DestX, DestY: word;
    Visible: LongInt;
    Unknown1: array [1..28] of byte;
    Dialog: TResRef;
    ScriptOverride: TResRef;
    ScriptClass: TResRef;
    ScriptRace: TResRef;  
    ScriptGeneral: TResRef;
    ScriptDefault: TResRef;
    ScriptSpecifics: TResRef;
    CREfile: TResRef;
    CREoffset, CREsize: LongInt;
    Unknown: array [1..128] of byte;
  end;

  TAreaInfoRec = record
    Id: array [0..31] of char;
    TriggerType: word;
    X1, Y1, X2, Y2: word;
    PointCount: word;
    FirstPoint: LongInt;
    Unknown1: LongInt;
    CursorIndex: LongInt;
    DestArea: TResRef;
    DestEntrance: array [0..31] of char;
    Flags: LongInt;
    DescTLKIndex: LongInt;
    TrapDetectionDifficulty: word;
    TrapRemovalDifficulty: word;
    Trapped, TrapDetected: word;
    TrapLaunchX, TrapLaunchY: word;
    KeyType: TResRef;
    Script: TResRef;
    Unknown2: array [1..28] of word;
    Dialog: TResRef;
  end;

  TAreaTriggerType = (attProximity, attInfo, attTravel);

const
  atfResetTrap = 2;
  atfPartyRequired = 4;

type
  TAreaEntryRec = record
    Name: array [0..31] of char;
    X, Y: word;
    Unknown: array [1..68] of byte;
  end;

  TAreaContainerRec = record
    Name: array [0..31] of char;
    X, Y: word;
    ContainerType: word;
    LockDifficulty: word;
    Locked: word;
    Unknown: word;
    TrapDetectionDifficulty: word;
    TrapRemovalDifficulty: word;
    Trapped, TrapDetected: word;
    TrapLaunchX, TrapLaunchY: word;
    X1, Y1, X2, Y2: word;
    StartItem, ItemCount: LongInt;
    TrapScript: TResRef;
    FirstPoint, PointCount: LongInt;
    Unknown2: array [1..32] of char;
    KeyType: TResRef;
    Unknown3: array [1..64] of byte;
  end;

  TAreaDoorRec = record
    Name: array [0..31] of char;
    Id: array [0..7] of char;
    Flags: LongInt;
    ClosedFirstPoint: LongInt;
    ClosedPointCount, OpenPointCount: word;
    OpenFirstPoint: LongInt;
    ClosedX1, ClosedY1, ClosedX2, ClosedY2: word;
    OpenX1, OpenY1, OpenX2, OpenY2: word;
    Unknown2: array [1..36] of byte;
    TrapDetectionDifficulty: word;
    TrapRemovalDifficulty: word;
    Trapped, TrapDetected: word;
    TrapLaunchX, TrapLaunchY: word;
    KeyType: TResRef;
    TrapScript: TResRef;
    Unknown4: LongInt;
    LockDifficulty: LongInt;
    X1, Y1, X2, Y2: word;   // unknown
    Unknown5: array [1..48] of byte;
  end;

  TAreaTiledObjectRec = record
    Name: array [0..31] of char;
    Id: array [0..7] of char;
    Unknown: LongInt;
    PrimarySearchSquaresStart, PrimarySearchSquaresCount: integer;
    SecondarySearchSquaresStart, SecondarySearchSquaresCount: integer;
    Unknown2: array [1..48] of byte;
  end;

  TAreaAnimRec = record
    Name: array [0..31] of char;
    X, Y: word;
    Unknown: LongInt;
    BAMId: TResRef;
    BAMCycle: word;
    Unknown2: array [1..26] of byte;
  end;

  TAreaSpawnRec = record
    Name: array [0..31] of char;
    X, Y: word;
    Creatures: array [0..9] of TResRef;
    CreatureCount: word;
    Unknown: array [1..2] of byte;
    field_78: word;
    Flags: word;
    Unknown2: array [1..8] of byte;
    field_84: word;
    field_86: word;
    field_88: LongInt;
    Probability1: word;
    Probability2: word;
    Unknown3: array [1..56] of byte;
  end;

// -- ITM --------------------------------------------------------------------

  TItem10HeaderRec = record
    Signature: array [0..7] of char;
    NameUnident, NameIdent: LongInt;
    Destroyed: TResRef;
    Attr: LongInt;
    ItemType: word;
    ItemUsability: LongInt;
    WeaponID: array [0..1] of char;
    MinLevel: word;
    MinStr: byte;
    Unknown1: byte;
    MinStrBonus: byte;
    Unknown2: byte;
    MinInt: byte;
    Unknown3: byte;
    MinDex: byte;
    Unknown4: byte;
    MinWis: byte;
    Unknown5: byte;
    MinCon: byte;
    Unknown6: byte;
    MinCha: byte;
    Unknown7: byte;
    Price: LongInt;
    MaxInStack: word;
    BAMIdInv: TResRef;
    LoreToIdentify: word;
    BAMIdGround: TResRef;
    Weight: LongInt;
    DescUnident, DescIdent: LongInt;
    BAMIdCarried: TResRef;
    Enchanted: LongInt;
    AbilityPtr: LongInt;
    AbilityCount: word;
    EffectTablePtr: LongInt;
    FirstGlobalEffect: word;
    GlobalEffectCount: word;
  end;

  // in V1.1 items, goes after 1.0 header
  TItem11ExHeaderRec = record
    Dialog: TResRef;
    UnknownTLK: LongInt;
    Unknown4: array [1..14] of SmallInt;
  end;

  TItem11HeaderRec = record
    Hdr10: TItem10HeaderRec;
    HdrEx: TItem11ExHeaderRec;
  end;

  TAbilityRec = record
    AbilityType: byte;
    UseOnlyIdentified: byte;
    Unknown1: word;
    BAMIcon: TResRef;
    TargetType: word;
    Range: word;
    LauncherType: word;
    Speed: word;
    Bonus: SmallInt;
    DiceValue: word;
    DiceCount: word;
    DmgBonus: SmallInt;
    DamageType: word;
    EffectCount: word;
    FirstEffect: word;
    ChargeCount: word;
    Unknown6: array [1..2] of word;
  end;

  TSpellAbilityRec = record
    AbilityType: byte;
    UseOnlyIdentified: byte;
    Unknown1: word;
    BAMIcon: TResRef;
    TargetType: word;
    Range: word;
    MinLevel: word;
    Speed: word;
    Bonus: SmallInt;
    DiceValue: word;
    DiceCount: word;
    DmgBonus: SmallInt;
    DamageType: word;
    EffectCount: word;
    FirstEffect: word;
    Unknown6: array [1..2] of word;
    ProjectileType: word;
  end;

  TItemAbilityRec = record
    Base: TAbilityRec;
    Unknown: word;
    ProjectileType: word;
    Unknown2: array [1..3] of word;
    IsArrow, IsBolt, IsMissile: word;
  end;

  TEffectRec = record
    EffectType: word;
    TargetType: byte;
    Unknown: byte;
    NP1, NP2: LongInt;              // number parameters
    Flags: word;
    Time: LongInt;
    Prob1: byte;                     // probability
    Prob2: byte;
    Resource: TResRef;
    DiceCount: LongInt;
    DiceValue: LongInt;
    SaveType: LongInt;
    SaveBonus: LongInt;
    Unknown2: LongInt;
  end;
  PEffectRec = ^TEffectRec;

  TEffect20Rec = record
    Signature: array [0..7] of char;
    EffectType: LongInt;
    TargetType: LongInt;
    Unknown: LongInt;
    NP1, NP2: LongInt;
    Flags: LongInt;
    Time: LongInt;
    Prob1: word;
    Prob2: word;
    Resource: TResRef;
    DiceValue: LongInt;
    DiceCount: LongInt;
    SaveType: LongInt;
    SaveBonus: LongInt;
    Unknown2: array [1..3] of LongInt;
    DiceValue2: LongInt;
    DiceCount2: LongInt;
    Flags2: LongInt;
    Unknown3: array [1..4] of LongInt;
    UnknownResRef: array [1..2] of TResRef;
    Unknown4: array [1..5] of LongInt;
    UnknownResRef2: TResRef;
    Unknown5: array [1..116] of byte;
  end;

// -- CRE --------------------------------------------------------------------

  TSpellType = (stInvalid, stWizard, stPriest, stInnate);

  TCRECommon0Rec = record
    Signature: array [0..7] of char;
    NameTLK, TooltipTLK: integer;
    Flags: integer;
    KillXP, CurXP: integer;
    Gold: integer;
    Status: integer;
    MaxHP, CurHP: word;
    AnimID: word;
    Unknown2: word;
    ColorMetal: byte;
    ColorMinor, ColorMajor, ColorSkin: byte;
    ColorLeather, ColorArmor: byte;
    ColorHair: byte;
    EffectFormat: byte;
    ImageS, ImageL: TResRef;
    Reputation: byte;
    Unknown6: byte;
    BaseAC: SmallInt;
    AC: SmallInt;
    ACCrushing: SmallInt;
    ACMissile: SmallInt;
    ACPiercing: SmallInt;
    ACSlashing: SmallInt;
    THAC0: ShortInt;
    NumberOfAttacks: byte;
    ST_PPDM, ST_RSW, ST_PP, ST_BW, ST_Spells: ShortInt;
    ResistFire, ResistCold, ResistElec, ResistAcid: ShortInt;
    ResistMagic, ResistMagFire, ResistMagCold: ShortInt;
    ResistSlashing, ResistPiercing, ResistCrushing, ResistMissile: ShortInt;
    Unknown7: array [1..2] of byte;
    Lore: byte;
    OpenLocks, Stealth, DetectTraps, PickPockets: byte;
    Fatigue, Intoxication: byte;
    Luck: ShortInt;
  end;

  TCRECommon1Rec = record
    WeaponProf: array [1..15] of byte;
    Unknown1: array [1..6] of byte;
    Tracking: byte;
    Unknown8a: array [1..32] of byte;
    TLKIndex: array [1..100] of LongInt;
    Level: array [1..3] of ShortInt;
    Unknown9: byte;
    Str, StrPercent, Int, Wis, Dex, Con, Cha: byte;
    Morale, MoraleBreak: byte;
    RacialEnemy: byte;
    MoraleRecoveryTime: byte;
    Unknown10: array [1..3] of byte;
    SpecialistMage: word;
    ScriptOverride, ScriptClass, ScriptRace: TResRef;
    ScriptGeneral, ScriptDefault: TResRef;
  end;

const
  CRE_DUAL_MAGE    = 8;
  CRE_DUAL_FIGHTER = $10;
  CRE_DUAL_CLERIC  = $20;
  CRE_DUAL_THIEF   = $40;
  CRE_DUAL_DRUID   = $80;
  CRE_DUAL_RANGER  = $100;
  CRE_DUAL_ALL     = $1F8;

type
  TCREAIRec = record
    AI_EA, AI_General: byte;
    AI_Race, AI_Class, AI_Specific: byte;
    Gender: byte;
    Unknown13: array [1..5] of byte;
    Alignment: byte;
    Unknown14: array [1..4] of byte;
    DeathVar: array [0..31] of char;
  end;

  TCREOffsets1Rec = record
    KnownSpellOffset, KnownSpellCount: LongInt;
    MemorizeOffset, MemorizeCount: LongInt;
    MemorizedSpellOffset, MemorizedSpellCount: LongInt;
  end;

  TCREOffsets2Rec = record
    ItemSlotOffset: LongInt;
    ItemOffset, ItemCount: LongInt;
    EffectOffset, EffectCount: LongInt;
    Dialog: TResRef;
  end;

  // between TCRECommon1Rec and TCRECommon2Rec
  TCRE12ExtRec = record
    Unknown11: array [1..76] of byte;
    RaceName: array [0..31] of char;
    Unknown12: array [1..54] of byte;
    AI_Team, AI_Faction: byte;
  end;

  TCRE90ExtRec = record
    Unknown1: array [1..14] of byte;
    Var1, Var2: array [0..31] of char;
    Unknown2: array [1..26] of byte;
  end;

  TCREItemRec = record   // also used in ARE files
    ItemID: TResRef;
    Unknown1: word;
    Count: SmallInt;
    Count2: SmallInt;
    Count3: SmallInt;
    Flags: LongInt;
  end;

  TCREKnownSpellRec = record
    SpellID: TResRef;
    Level: word;
    SpellType: word;
  end;

  TCREMemorizedSpellRec = record
    SpellID: TResRef;
    Available: word;
    Unknown: word;
  end;

// -- SPL --------------------------------------------------------------------

  TSpellHeaderRec = record
    Signature: array [0..7] of char;
    TLKName: LongInt;
    Unknown1: LongInt;
    SoundID: TResRef;
    Unknown7: LongInt;
    SpellType: word;
    Unknown2: array [1..22] of byte;
    Level: integer;
    Unknown3: word;
    SpellIcon: TResRef;
    Unknown4: array [1..14] of byte;
    TLKDesc: LongInt;
    Unknown5: LongInt;
    SoundID2: TResRef;
    Unknown6: LongInt;
    AbilityOffset: LongInt;
    AbilityCount: word;
    EffectOffset: LongInt;
    EffectCount: LongInt;
  end;

// -- WMAP -------------------------------------------------------------------

  TWorldMapHeaderRec = record
    Signature: array [0..7] of char;
    WorldMapCount: integer;
    WorldMapOffset: LongInt;
  end;

  TWorldMapRec = record
    MapResName: TResRef;
    XSize, YSize: integer;
    Unknown: array [1..4] of integer;
    AreaCount, AreaOffset: integer;
    LinkOffset, LinkCount: integer;
    MapIconResName: TResRef;
    Unknown2: array [1..32] of integer;
  end;

  TWorldMapLinkPtrRec = record
    FirstLink: integer;
    LinkCount: integer;
  end;

  TWorldMapAreaRec = record
    AreaId1, AreaId2: TResRef;
    AreaName: array [0..31] of char;
    Flags: LongInt;
    BAMFrame: integer;
    X, Y: integer;
    TLKIndex1, TLKIndex2: integer;
    LoadScreen: TResRef;
    Links: array [1..4] of TWorldMapLinkPtrRec;
    Unknown2: array [1..32] of integer;
  end;

  TWorldMapLinkRec = record
    ToAreaIndex: integer;
    EntryPoint: array [0..31] of char;
    TravelHours: integer;
    Unknown: array [1..44] of integer;
  end;

const
  wmaVisible  = 1;
  wmaCanVisit = 4;
  wmaVisited  = 8;

// -- CHUI -------------------------------------------------------------------

type
  TChUIHeaderRec = record
    Signature: array [0..7] of char;
    PanelCount: integer;
    ControlIndexOffset: integer;
    PanelOffset: integer;
  end;

  TChUIControlIndexRec = record
    Offset: integer;
    Size: integer;
  end;

  TChUIPanelRec = record
    PanelID: integer;
    X, Y: word;
    Width, Height: word;
    HasBackground: word;
    ControlCount: word;
    BackgroundMOS: TResRef;
    FirstControl: word;
    Unknown: word;
  end;

  TChUIButtonRec = record
    BAMName: TResRef;
    BAMSeq: word;
    UpFrame, DownFrame: word;
    SelectedFrame, DisabledFrame: word;
  end;

  TChUISliderRec = record
    MOSBackground: TResRef;
    BAMKnob: TResRef;
    BAMKnobSeq: word;
    UngrabbedFrame, GrabbedFrame: word;
    Unknown: array [1..8] of word;
  end;

  TChUITextEditRec = record
    MOSFile1, MOSFile2, MOSFile3: TResRef;
    BAMCursor: TResRef;
    Unknown: array [1..12] of byte;
    BAMFont: TResRef;
    Unknown2: array [1..40] of byte;
  end;

  TChUITextAreaRec = record
    BAMFont1, BAMFont2: TResRef;
    Color1, Color2, Color3: integer;
    ScrollBarControlID: word;
  end;

  TChUITextRec = record
    TextStrref: integer;
    BAMFont: TResRef;
    Color1, Color2: integer;
    Unknown: word;
  end;

  TChUIScrollBarRec = record
    BAMFile: TResRef;
    BAMSeq: word;
    BAMUpUnpressedFrame, BAMUpPressedFrame: word;
    BAMDownUnpressedFrame, BAMDownPressedFrame: word;
    BAMTroughFrame, BAMSliderFrame: word;
    TextAreaControlID: word;
  end;

  TChUIControlType = (ctButton, ctUnknown1, ctSlider, ctEdit, ctUnknown4, ctTextArea,
      ctStatic, ctScrollBar);

  TChUIControlRec = record
    ControlID: integer;
    X, Y: word;
    Width, Height: word;
    ControlType: TChUIControlType;
    Unknown: byte;
    case TChUIControlType of
      ctButton: (Btn: TChUIButtonRec);
      ctSlider: (Slider: TChUISliderRec);
      ctEdit: (TextEdit: TChUITextEditRec);
      ctTextArea: (TextArea: TChUITextAreaRec);
      ctStatic: (Text: TChUITextRec);
      ctScrollBar: (ScrollBar: TChUIScrollBarRec);
  end;

// -- STOR -------------------------------------------------------------------

  TStoreHeaderRec = record
    Signature: array [0..7] of char;
    StoreType: LongInt;
    NameStrref: LongInt;
    Flags: LongInt;
    SellPrice, BuyPrice: LongInt;
    BuyPriceReduction: LongInt;
    StealDifficulty: LongInt;
    Unknown: array [1..8] of byte;
    PurchasedItemsOffset, PurchasedItemsCount: LongInt;
    SoldItemsOffset, SoldItemsCount: LongInt;
    IdentifyLore: LongInt;
    Unknown2: LongInt;
    RumorDlg: TResRef;
    DrinksOffset, DrinksCount: LongInt;
    DonateRumorDlg: TResRef;
    RoomTypes: LongInt;
    RoomPrices: array [1..4] of LongInt;  // Peasant, Merchant, Noble, Royal
    SpellsOffset, SpellsCount: LongInt;
    Unknown4: array [1..36] of byte;
  end;

  TStore10ItemRec = record
    Base: TCREItemRec;
    NumberInStock: integer;
    Flags: LongInt;
  end;

  TStore11ExItemRec = record
    Unknown: array [1..60] of byte;
  end;

  TStoreDrinkRec = record
    Unknown: array [0..7] of byte;
    NameStrref: LongInt;
    Price: LongInt;
    RumorChance: LongInt;
  end;

  TStoreSpellRec = record
    SpellID: TResRef;
    SpellPrice: LongInt;
  end;

// -- GAME -------------------------------------------------------------------

type
  TGameHeaderCommonRec = record
    Signature: array [0..7] of char;
    GameTime: LongInt;
    Unknown: array [1..6] of word;
    Gold: LongInt;
    Unknown2: LongInt;
    PartyOffset, PartyCount: LongInt;
    Unknown3: array [1..2] of LongInt;
    NPCOffset, NPCCount: LongInt;
    VarOffset, VarCount: LongInt;
    AreaResRef: TResRef;
    Unknown4: LongInt;
    JournalCount, JournalOffset: LongInt;
  end;

  TGameHeaderRec = record
    HdrCommon: TGameHeaderCommonRec;
    Unknown5: LongInt;
    AreaResRef2: TResRef;
    Unknown6: array [1..21] of LongInt;
  end;

  TGameHeaderTormentRec = record
    HdrCommon: TGameHeaderCommonRec;
    Unknown5: LongInt;
    Unknown6: LongInt;
    AreaResRef2: TResRef;
    KillVarOffset, KillVarCount: LongInt;
    Unknown7: LongInt;
    AreaResRef3: TResRef;
    Unknown8: array [1..16] of LongInt;
  end;

  TGameCharacterCommonRec = record
    Unknown: word;
    PartyPosition: SmallInt;
    CREOffset, CRESize: LongInt;
    Unknown2: array [1..2] of LongInt;
    Facing: LongInt;
    CurArea: TResRef;
    XCoord, YCoord: word;
    ViewRectX, ViewRectY: word;
    Unknown3: word;
    Happiness: word;
    Unknown4: array [1..37] of LongInt;
  end;

  TGameCharacterStatsRec = record
    MostPowerfulStrref: LongInt;
    MostPowerfulXP: LongInt;
    Unknown: array [1..3] of LongInt;
    KillXPChapter, KillCountChapter: LongInt;
    KillXPGame, KillCountGame: LongInt;
    FavSpells: array [1..4] of TResRef;
    FavSpellCount: array [1..4] of word;
    FavWeapons: array [1..4] of TResRef;
    FavWeaponCount: array [1..4] of word;
  end;

  TGameCharacterRec = record
    Common: TGameCharacterCommonRec;
    Name: array [0..31] of char;
    Unknown: LongInt;
    Stats: TGameCharacterStatsRec;
    Unknown2: array [0..7] of char;
    SoundSet: array [0..31] of char;
  end;

  TGameCharacterBaldurRec = record
    Common: TGameCharacterCommonRec;
    Name: array [0..31] of char;
    Unknown: LongInt;
    Stats: TGameCharacterStatsRec;
    SoundSet: array [0..7] of char;
  end;

  TGameCharacterTormentRec = record
    Common: TGameCharacterCommonRec;
    Unknown: array [1..11] of LongInt;
    Stats: TGameCharacterStatsRec;
    Unknown2: array [1..2] of LongInt;
  end;

  TGameCharacterIcewind2Rec = record
    Common: TGameCharacterCommonRec;
    Unknown: array [1..63] of LongInt;
    Unknown2: word;
    Name: array [0..31] of char;
    Unknown3: LongInt;
    Stats: TGameCharacterStatsRec;
    Unknown4: array [0..7] of char;
    SoundSet: array [0..31] of char;
    Unknown5: array [1..48] of integer;
    Unknown6: word;
  end;

  TGameVarRec = record
    Name: array [0..31] of char;
    Unknown1, Unknown2: LongInt;
    Value: LongInt;
    Unknown3: array [1..10] of LongInt;
  end;

  TGameJournalRec = record
    TextStrref: integer;
    Time: integer;
    Chapter: word;
    Unknown: word;
  end;

function Effect2Name (E: Integer; GameType: TGameType): string;   // from Petr Zahradnik's Expl

implementation

uses SysUtils;

function Effect2Name (E: Integer; GameType: TGameType): string;   // from Petr Zahradnik's Expl
begin
   case E of
        $0: Result:='[0] Stat: AC vs. Damage Type Modifier';
        $1: Result:='[1] Stat: Attacks Per Round Modifier';
        $2: Result:='[2] Cure: Sleep';
        $3: Result:='[3] State: Berserking';
        $4: Result:='[4] Cure: Berserking';
        $5: Result:='[5] Charm: Charm Specific Creature';
        $6: Result:='[6] Stat: Charisma Modifier';
        $7: Result:='[7] colour: Set Character colours by Palette';
        $8: Result:='[8] colour: Change by RGB';
        $9: Result:='[9] colour: Glow Pulse';
        $A: Result:='[10] Stat: Constitution Modifier';
        $B: Result:='[11] Cure: Poison';
        $C: Result:='[12] HP: Damage';
        $D: Result:='[13] Death: Instant Death';
        $E: Result:='[14] Graphics: Defrost';
        $F: Result:='[15] Stat: Dexterity Modifier';
        $10: Result:='[16] State: Haste';
        $11: Result:='[17] HP: Current HP Modifier';
        $12: Result:='[18] HP: Maximum HP Modifier';
        $13: Result:='[19] Stat: Intelligence Modifier';
        $14: Result:='[20] State: Invisibility';
        $15: Result:='[21] Stat: Lore Modifier';
        $16: Result:='[22] Stat: Cumulative Luck Bonus';
        $17: Result:='[23] Stat: Morale Modifier';
        $18: Result:='[24] State: Horror';
        $19: Result:='[25] State: Poison';
        $1A: Result:='[26] Item: Remove Curse';
        $1B: Result:='[27] Stat: Acid Resistance Modifier';
        $1C: Result:='[28] Stat: Cold Resistance Modifier';
        $1D: Result:='[29] Stat: Electricity Resistance Modifier';
        $1E: Result:='[30] Stat: Fire Resistance Modifier';
        $1F: Result:='[31] Stat: Magic Damage Resistance Modifier';
        $20: Result:='[32] Cure: Death (Raise Dead)';
        $21: Result:='[33] Stat: Save vs. Death Modifier';
        $22: Result:='[34] Stat: Save vs. Wands Modifier';
        $23: Result:='[35] Stat: Save vs. Petrification/Polymorph Modifier';
        $24: Result:='[36] Stat: Save vs. Breath Weapons Modifier';
        $25: Result:='[37] Stat: Save vs. Spells Modifier';
        $26: Result:='[38] State: Silence';
        $27: Result:='[39] State: Unconsciousness';
        $28: Result:='[40] State: Slow';
        $29: Result:='[41] Graphics: Sparkle';
        $2A: Result:='[42] Spell: Wizard Spell Slots Modifier';
        $2B: Result:='[43] Cure: Stone to Flesh';
        $2C: Result:='[44] Stat: Strength Modifier';
        $2D: Result:='[45] State: Stun';
        $2E: Result:='[46] Cure: Stun (Unstun)';
        $2F: Result:='[47] Cure: Invisibility';
        $30: Result:='[48] Cure: Silence (Vocalize)';
        $31: Result:='[49] Stat: Wisdom Modifier';
        $32: Result:='[50] colour: Glow by RGB (Brief)';
        $33: Result:='[51] colour: Strong/Dark by RGB';
        $34: Result:='[52] colour: Very Bright by RGB';
        $35: Result:='[53] Graphics: Animation Change';
        $36: Result:='[54] Stat: THAC0 Modifier';
        $37: Result:='[55] Death: Kill Creature Type';
        $38: Result:='[56] Alignment: Invert';
        $39: Result:='[57] Alignment: Change';
        $3A: Result:='[58] Cure: Dispellable Effects (Dispel Magic)';
        $3B: Result:='[59] Stat: Stealth Modifier';
        $3C: Result:='[60] Stat: Miscast Magic';
        $3D: Result:='[61] Crash';
        $3E: Result:='[62] Spell: Priest Spell Slots Modifier';
        $3F: Result:='[63] State: Infravision';
        $40: Result:='[64] State: Remove Infravision';
        $41: Result:='[65] Overlay: Blur';
        $42: Result:='[66] Graphics: Transparency Fade';
        $43: Result:='[67] Summon: Creature Summoning';
        $44: Result:='[68] Summon: Unsummon Creature';
        $45: Result:='[69] Protection: From Detection (Non-Detection)';
        $46: Result:='[70] Cure: Non-Detection';
        $47: Result:='[71] IDS: Sex Change';
        $48: Result:='[72] IDS: Set IDS State';
        $49: Result:='[73] Stat: Extra Damage Modifier';
        $4A: Result:='[74] State: Blindness';
        $4B: Result:='[75] Cure: Blindness';
        $4C: Result:='[76] State: Feeblemindedness';
        $4D: Result:='[77] Cure: Feeblemindedness';
        $4E: Result:='[78] State: Disease';
        $4F: Result:='[79] Cure: Disease';
        $50: Result:='[80] State: Deafness';
        $51: Result:='[81] Cure: Deafness';
        $52: Result:='[82] Set AI Script';
        $53: Result:='[83] Protection: From Projectile';
        $54: Result:='[84] Stat: Magical Fire Resistance Modifier';
        $55: Result:='[85] Stat: Magical Cold Resistance Modifier';
        $56: Result:='[86] Stat: Slashing Resistance Modifier';
        $57: Result:='[87] Stat: Crushing Resistance Modifier';
        $58: Result:='[88] Stat: Piercing Resistance Modifier';
        $59: Result:='[89] Stat: Missiles Resistance Modifier';
        $5A: Result:='[90] Stat: Open Locks Modifier';
        $5B: Result:='[91] Stat: Find Traps Modifier';
        $5C: Result:='[92] Stat: Pick Pockets Modifier';
        $5D: Result:='[93] Stat: Fatigue Modifier';
        $5E: Result:='[94] Stat: Drunkenness Modifier';
        $5F: Result:='[95] Stat: Tracking Skill Modifier';
        $60: Result:='[96] Stat: Level Change';
        $61: Result:='[97] Stat: Strength-Bonus Modifier';
        $62: Result:='[98] HP: Regeneration';
        $63: Result:='[99] Spell Effect: Duration Modifier';
        $64: Result:='[100] Protection: from Creature Type';
        $65: Result:='[101] Protection: from Opcode';
        $66: Result:='[102] Protection: from Spell Levels';
        $67: Result:='[103] Text: Change Name';
        $68: Result:='[104] Stat: Experience Points';
        $69: Result:='[105] Stat: Gold';
        $6A: Result:='[23] Stat: Morale Break Modifier';
        $6B: Result:='[107] Portrait Change';
        $6C: Result:='[108] Stat: Reputation';
        $6D: Result:='[109] State: Hold';
        $6E: Result:='[110] (Retreat From)';
        $6F: Result:='[111] Item: Create Magical Weapon';
        $70: Result:='[112] Item: Remove Item';
        $71: Result:='[113] Item: (Equip Weapon)';
        $72: Result:='[114] Graphics: Dither';
        $73: Result:='[115] Detect: Alignment';
        $74: Result:='[116] State: Cure Invisibility';
        $75: Result:='[117] Spell Effect: Reveal Area';
        $76: Result:='[118] Detect: (Show Creatures)';
        $77: Result:='[119] Spell Effect: Mirror Image';
        $78: Result:='[120] Protection: from Melee Weapons';
        $79: Result:='[121] Graphics: (Visual Animation Effect)';
        $7A: Result:='[122] Item: Create Inventory Item';
        $7B: Result:='[123] Item: Remove Inventory Item';
        $7C: Result:='[124] Spell Effect: Teleport (Dimension Door)';
        $7D: Result:='[125] Spell Effect: Unlock (Knock)';
        $7E: Result:='[126] Stat: Movement Modifier';
        $7F: Result:='[127] Summon: Monster Summoning';
        $80: Result:='[128] State: Confusion';
        $81: Result:='[129] State: Aid';
        $82: Result:='[130] State: Bless';
        $83: Result:='[131] State: Positive Chant';
        $84: Result:='[132] State: Raise Strength, Constitution, & Dexterity Non-Cumulative';
        $85: Result:='[133] Spell Effect: Luck Non-Cumulative';
        $86: Result:='[134] State: Petrification';
        $87: Result:='[135] Graphics: Polymorph into Specific';
        $88: Result:='[136] State: Force Visible';
        $89: Result:='[137] State: Negative Chant';
        $8A: Result:='[138] Graphics: Character Animation Change';
        $8B: Result:='[139] Text: Display String';
        $8C: Result:='[140] Graphics: Casting Glow';
        $8D: Result:='[141] Graphics: Lighting Effects';
        $8E: Result:='[142] Graphics: Display Special Effect Icon';
        $8F: Result:='[143] Item: Create Item in Slot';
        $90: Result:='[144] Button: Disable Button';
        $91: Result:='[145] Spell: Disable Spell Casting Abilities';
        $92: Result:='[146] Spell: Cast Spell (at Creature)';
        $93: Result:='[147] Spell: Learn Spell';
        $94: Result:='[148] Spell: Cast Spell (at Point)';
        $95: Result:='[149] (Identify)';
        $96: Result:='[150] Spell Effect: Find Traps';
        $97: Result:='[151] Summon: Replace Creature';
        $98: Result:='[152] Spell Effect: Play Movie';
        $99: Result:='[153] Overlay: Sanctuary';
        $9A: Result:='[154] Overlay: Entangle';
        $9B: Result:='[155] Overlay: Minor Globe';
        $9C: Result:='[156] Overlay: Protection from Normal Missiles Cylinder';
        $9D: Result:='[157] State: Web Effect';
        $9E: Result:='[158] Overlay: Grease';
        $9F: Result:='[159] Spell Effect: Mirror Image (Exact Number)';
        $A0: Result:='[160] Remove Sanctuary';
        $A1: Result:='[161] Cure: Horror';
        $A2: Result:='[162] Cure: Hold';
        $A3: Result:='[163] Protection: Free Action';
        $A4: Result:='[164] Cure: Drunkeness';
        $A5: Result:='[165] Spell Effect: Pause Target';
        $A6: Result:='[166] Stat: Magic Resistance Modifier';
        $A7: Result:='[167] Stat: THAC0 Modifier with Missile Weapons';
        $A8: Result:='[168] Summon: Remove Creature';
        $A9: Result:='[169] Graphics: Prevent Special Effect Icon';
        $AA: Result:='[170] Graphics: Play Damage Animation';
        $AB: Result:='[171] Spell: Give Ability';
        $AC: Result:='[172] Spell: Remove Spell';
        $AD: Result:='[173] Stat: Set Poison Resistance';
        $AE: Result:='[174] Spell Effect: Play Sound Effect';
        $AF: Result:='[175] State: Hold';
        $B0: Result:='[176] Stat: Movement Modifier (II)';
        $B1: Result:='[177] Use EFF File';
        $B2: Result:='[178] Spell Effect: THAC0 vs. Creature Type Modifier';
        $B3: Result:='[179] Spell Effect: Damage vs. Creature Type Modifier';
        $B4: Result:='[180] Item: Cant Use Item';
        $B5: Result:='[181] Item: Cant Use Itemtype';
        $B6: Result:='[182] Item: Unknown';
        $B7: Result:='[183] Item: Apply Effect Itemtype';
        $B8: Result:='[184] Graphics: Passwall (Dont Jump)';
        $B9: Result:='[185] State: Hold';
        $BA: Result:='[186] Script: MoveToArea';
        $BB: Result:='[187] Script: Store Local Variable';
        $BC: Result:='[188] Spell Effect: Aura Cleansing';
        $BD: Result:='[189] Stat: Casting Time Modifier';
        $BE: Result:='[190] Stat: Attack Speed Factor';
        $BF: Result:='[191] Spell: Casting Level Modifier';
        $C0: Result:='[192] Spell Effect: Find Familiar';
        $C1: Result:='[193] Spell Effect: Invisible Detection by Script';
        $C2: Result:='[194] Ignore Dialog Pause';
        $C3: Result:='[195] Spell Effect: Death Dependent Constitution Loss';
        $C4: Result:='[196] Spell Effect: Familiar Block';
        $C5: Result:='[197] Spell: Bounce Projectile';
        $C6: Result:='[198] Spell: Bounce Opcode';
        $C7: Result:='[199] Spell: Bounce Spell Level';
        $C8: Result:='[200] Spell: Decrementing Bounce Spells';
        $C9: Result:='[201] Spell: Decrementing Spell Immunity';
        $CA: Result:='[202] Spell: Bounce Spell School';
        $CB: Result:='[203] Spell: Bounce Secondary Type';
        $CC: Result:='[204] Spell: Protection from Spell (School)';
        $CD: Result:='[205] Spell: Protection from Spell (Secondary Type)';
        $CE: Result:='[206] Spell: Protection from Spell';
        $CF: Result:='[207] Spell: Bounce Specified Spell';
        $D0: Result:='[208] HP: Minimum Limit';
        $D1: Result:='[209] Death: Kill 60HP';
        $D2: Result:='[210] Spell Effect: Stun 90HP';
        $D3: Result:='[211] Spell Effect: Imprisonment';
        $D4: Result:='[212] Protection: Freedom';
        $D5: Result:='[213] Spell Effect: Maze';
        $D6: Result:='[214] Spell Effect: Select Spell';
        $D7: Result:='[215] Graphics: Play 3D Effect';
        $D8: Result:='[216] Spell Effect: Level Drain';
        $D9: Result:='[217] Spell Effect: Unconsciousness 20HP';
        $DA: Result:='[218] Protection: Stoneskin';
        $DB: Result:='[219] Stat: AC vs. Creature Type Modifier';
        $DC: Result:='[220] Removal: Remove School';
        $DD: Result:='[221] Removal: Remove Secondary Type';
        $DE: Result:='[222] Spell Effect: Teleport Field';
        $DF: Result:='[223] Spell Effect: Immunity School Decrement';
        $E0: Result:='[224] Cure: Level Drain (Restoration)';
        $E1: Result:='[225] Spell: Reveal Magic';
        $E2: Result:='[226] Spell: Immunity Secondary Type Decrement';
        $E3: Result:='[227] Spell: Bounce School Decrement';
        $E4: Result:='[228] Spell: Bounce Secondary Type Decrement';
        $E5: Result:='[229] Removal: Remove One School';
        $E6: Result:='[230] Removal: Remove One Secondary Type';
        $E7: Result:='[231] Spell Effect: Time Stop';
        $E8: Result:='[232] Spell Effect: Cast Spell on Condition';
        $E9: Result:='[233] Stat: Proficiency Modifier';
        $EA: Result:='[234] Spell Effect: Contingency Creation';
        $EB: Result:='[235] Spell Effect: Wing Buffet';
        $EC: Result:='[236] Spell Effect: Image Projection (Simulacrum)';
        $ED: Result:='[237] Spell Effect: Puppet ID';
        $EE: Result:='[238] Death: Disintegrate';
        $EF: Result:='[239] Spell Effect: Farsight';
        $F0: Result:='[240] Graphics: Remove Special Effect Icon';
        $F1: Result:='[241] Charm: Control Creature';
        $F2: Result:='[242] Cure: Confusion';
        $F3: Result:='[243] Item: Drain Item Charges';
        $F4: Result:='[244] Spell: Drain Wizard Spell';
        $F5: Result:='[245] Check For Berserk';
        $F6: Result:='[246] Spell Effect: Berserking';
        $F7: Result:='[247] Spell Effect: Attack Nearest Creature';
        $F8: Result:='[248] Item: Set Melee Effect';
        $F9: Result:='[249] Item: Set Ranged Effect';
        $FA: Result:='[250] Spell Effect: Damage Modifier';
        $FB: Result:='[251] Spell Effect: Change Bard Song Effect';
        $FC: Result:='[252] Spell Effect: Set Trap';
        $FD: Result:='[253] Spell Effect: Add Map Marker';
        $FE: Result:='[254] Spell Effect: Remove Map Marker';
        $FF: Result:='[255] Item: Create Inventory Item (days)';
        $100: Result:='[256] Spell: Spell Sequencer Active';
        $101: Result:='[257] Spell: Spell Sequencer Creation';
        $102: Result:='[258] Spell: Spell Sequencer Activation';
        $103: Result:='[259] Protection: Spell Trap';
        $104: Result:='[260] Crash';
        $105: Result:='[261] Spell: Restore Lost Spells';
        $106: Result:='[262] Stat: Visual Range';
        $107: Result:='[263] Stat: Backstab';
        $108: Result:='[264] Spell Effect: Drop Weapons in Panic';
        $109: Result:='[265] Script: Modify Global Variable';
        $10A: Result:='[266] Spell: Remove Protection from Spell';
        $10B: Result:='[267] Text: Protection from Display Specific String';
        $10C: Result:='[268] Spell Effect: Clear Fog of War (Wizard Eye)';
        $10D: Result:='[269] Spell Effect: Shake Window';
        $10E: Result:='[270] Cure: Unpause Target';
        $10F: Result:='[271] Graphics: Avatar Removal';
        $110: Result:='[272] Spell: Apply Repeating EFF';
        $111: Result:='[273] Remove: Specific Area Effect(Zone of Sweet Air)';
        $112: Result:='[274] Spell Effect: Teleport to Target';
        $113: Result:='[275] Stat: Hide in Shadows Modifier';
        $114: Result:='[276] Stat: Detect Illusion Modifier';
        $115: Result:='[277] Stat: Set Traps Modifier';
        $116: Result:='[278] Stat: To Hit Modifier';
        $117: Result:='[279] Button: Enable Button';
        $118: Result:='[280] Spell Effect: Wild Magic';
        $119: Result:='[281] Stat: Wild Magic';
        $11A: Result:='[282] Script: Scripting State Modifier';
        $11B: Result:='[283] Use EFF File (Cursed)';
        $11C: Result:='[284] Stat: Melee THAC0 Modifier';
        $11D: Result:='[285] Stat: Melee Weapon Damage Modifier';
        $11E: Result:='[286] Stat: Missile Weapon Damage Modifier';
        $11F: Result:='[287] Graphics: Selection Circle Removal';
        $120: Result:='[288] Stat: Fist THAC0 Modifier';
        $121: Result:='[289] Stat: Fist Damage Modifier';
        $122: Result:='[290] Text: Change Title';
        $123: Result:='[291] Graphics: Disable Visual Effect';
        $124: Result:='[292] Protection: Backstab';
        $125: Result:='[293] Script: Enable Offscreen AI';
        $126: Result:='[294] Spell Effect: Existance Delay Override';
        $127: Result:='[295] Graphics: Disable Permanent Death';
        $128: Result:='[296] Graphics: Protection from Specific Animation';
        $129: Result:='[297] Spell Effect: Immunity to Turn Undead';
        $12A: Result:='[298] Spell Effect: Area Switch';
        $12B: Result:='[299] Spell Effect: Chaos Shield';
        $12C: Result:='[300] Spell Effect: NPCBump';
        $12D: Result:='[301] Stat: Critical Hit Modifier';
        $12E: Result:='[302] Item: Can Use Any Item';
        $12F: Result:='[303] Spell Effect: Backstab Every Hit';
        $130: Result:='[304] Mass Raise Dead';
        $131: Result:='[305] Stat: THAC0 Modifier (Off-Hand)';
        $132: Result:='[306] Stat: THAC0 Modifier (On-Hand)';
        $133: Result:='[307] Ranger Tracking Ability';
        $134: Result:='[308] Protection: From Tracking';
        $135: Result:='[309] Script: Set/Modify Variable';
        $136: Result:='[310] Protection: from Timestop';
        $137: Result:='[311] Spell: Random Wish Spell';
        $138: Result:='[312] Crash';
        $139: Result:='[313] High-Level Ability Denotation';
        $13A: Result:='[314] Spell: Golem Stoneskin';
        $13B: Result:='[315] Graphics: Animation Removal';
        $13C: Result:='[316] Spell: Magical Rest';
        $13D: Result:='[317] State: Haste 2';

     else begin
       if GameType = gtIcewind then begin
         case E of
           $E9: Result := 'Effect Animation';
           $105: Result := 'Immunity to Effect';
           else
             Result:=Format('Effect: 0x%x',[E]);
         end;
       end
       else
         Result:=Format('Effect: 0x%x',[E]);
     end;
   end;
end;

end.
