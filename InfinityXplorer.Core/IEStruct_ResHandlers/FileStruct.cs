using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace InfinityXplorer.Core
{
    internal struct XPoint
    {
        public ushort X;
        public ushort Y;
    }
    internal struct XRect
    {
        public ushort left;
        public ushort top;
        public ushort right;
        public ushort bottom;
    }
    internal struct TileRect
    {
        public ushort minX;
        public ushort maxX;
        public ushort minY;
        public ushort maxY;
    }
    internal struct Palette
    {
        public byte red;
        public byte green;
        public byte blue;
        public byte _unknown;
    }
   
    [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
    internal struct TSPalette
    {
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 256)]
        public Palette[] palette;
    }

    internal static class FileStruct
    {        
        #region File Formats for Engine Design
        
        public static int TSTalkHeaderSize      = Marshal.SizeOf(typeof(TSTalkHeader));
        public static int TSTalkRefSize         = Marshal.SizeOf(typeof(TSTalkRef));
        public static int TSChitinHeaderSize    = Marshal.SizeOf(typeof(TSChitinHeader));
        public static int TSChitinBiffSize      = Marshal.SizeOf(typeof(TSChitinBiff));
        public static int TSChitinKeySize       = Marshal.SizeOf(typeof(TSChitinKey));
        public static int TSBiffHeaderSize      = Marshal.SizeOf(typeof(TSBiffHeader));
        public static int TSBiffFilesetSize     = Marshal.SizeOf(typeof(TSBiffFileset));
        public static int TSBiffTilesetSize     = Marshal.SizeOf(typeof(TSBiffTileset));
        public static int TSBifcHeaderSize      = Marshal.SizeOf(typeof(TSBifcHeader));
        public static int TSBifcBlockSize       = Marshal.SizeOf(typeof(TSBifcBlock));

        #region File Format for Dialog.Tlk File

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSTalkHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;    // Signature ('TLK ') + Version ('V1 ')
            public ushort localeId;     // Language Id (word = ushort)
            public int tlkCount;        // Number of strref entries (dword = int)
            public int tlkOffset;       // Offset to string data
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSTalkRef
        {
            public ushort tag;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] soundResource;// Resource name of the associated sound, if any
            public int volume;          // Volume variance.
            public int pitch;           // Pitch variance.
            public int strOffset;       // Offset of this string relative to the strings section
            public int strSize;         // Length of this string
        }

        #endregion File Format for Dialog.Tlk File
        
        #region File Format for Chitin.Key File

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSChitinHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;    // Signature ('KEY ') + Version ('V1 ')
            public int biffCount;       // Number of BIF entries
            public int ckeyCount;       // Number of resource entries
            public int biffOffset;      // Offset of BIF entries from start of file
            public int ckeyOffset;      // Offset of resource entries from start of file
        }

        public struct TSChitinBiff
        {
            public int biffSize;        // Length of BIF file
            public int biffNameOffset;  // Offset from start of file to ASCIIZ BIF filename
            public ushort biffNameSize; // Length, including terminating NUL, of ASCIIZ BIF filename
            public ushort biffCdMask;   // Mark the location of the relevant file.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSChitinKey
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] ckeyName;     // Resource name. 
            public ushort ckeyType;     // Resource type
            public ushort ckeyIndex;    // Resource locator.        
            public ushort biffIndex;    // Bif index
        }

        #endregion // Chitin.Key File

        #region File Format for Biff File

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSBiffHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature; // Signature ('BIFF') + Version ('V1 ')
            public int fileCount;    // Number of file entries, ie. elements
            public int tileCount;    // Number of tileset entries
            public int fileOffset;   // Offset of file entries (from start of file).
            // Tileset entries, if any, immediately follow the file entries.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSBiffFileset
        {
            public int fileIndex;       // Resource file locator
            public int fileOffset;      // Offset to resource data from start of file
            public int fileSize;        // Size (bytes) of this resource (file).
            public ushort resourceType; // Type of this resource.
            public ushort _unknownX;    // Unknown. 
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSBiffTileset
        {
            public int tileIndex;       // Tile resource locator
            public int tileOffset;      // Offset to resource data from star
            public int tileCount;       // Number of tiles in this resource (file).
            public int tileSize;        // Size (bytes) of each tile in this resource (file).
            public ushort tileType;     // Type of this resource, always 0x3eb (TIS files)
            public ushort _unknownX;    // Unknown
        }

        #endregion // Biff File

        #region File Format for BIFC File // Compressed BIFF

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSBifcHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;    // Signature ('BIFC') + Version ('V1.0')
            public int fullSize;        // Uncompressed BIF size
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSBifcBlock
        {
            public int fullBlockSize;   // Decompressed block size
            public int compBlockSize;   // Compressed block size
        }        
        
        #endregion File Format for BIFC File

        #endregion File Formats for Engine Design

        #region File Formats for Quest Resource Files

        #region File Format for *.DLG File

        public static int TSDialogHeaderSize = Marshal.SizeOf(typeof(TSDialogHeader));
        public static int TSDialogStateSize = Marshal.SizeOf(typeof(TSDialogState));
        public static int TSDialogTransSize = Marshal.SizeOf(typeof(TSDialogTrans));
        public static int TSDialogSTriggerSize = Marshal.SizeOf(typeof(TSDialogSTrigger));
        public static int TSDialogTTriggerSize = Marshal.SizeOf(typeof(TSDialogTTrigger));
        public static int TSDialogActionSize = Marshal.SizeOf(typeof(TSDialogAction));

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSDialogHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;    // Signature
            public int stateCount;      // State Count aka Statement
            public int stateOffset;     // State Offset aka Statement
            public int transCount;      // Transition Count aka Response
            public int transOffset;     // Transition Offset aka Response
            public int sTrigOffset;     // StateTrigger Offset aka Statement Condition
            public int sTrigCount;      // StateTrigger Count aka Statement Condition
            public int tTrigOffset;     // TransitionTrigger Offset; aka Response Condition
            public int tTrigCount;      // TransitionTrigger Count; aka Response Condition
            public int actionOffset;    // Action Offset
            public int actionCount;     // Action Count
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSDialogState // (actor responses)
        {
            public int srStateIndex;// Reference index to strText in *.tlk
            public int transIndex;  // Index of the first transition corresponding to this state only.
            public int transCount;  // Number of transitions corresponding to this state only.
            public int sTrigIndex;  // Trigger for this state // 0xFFFFFFFF if no trigger is used for this state.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSDialogTrans // (player dialog options)
        {
            public int flags;       // bit 0: 1=associated text, 0=no associated text 
                                    // bit 1: 1=trigger, 0=no trigger 
                                    // bit 2: 1=action, 0=no action 
                                    // bit 3: 1=terminates dialog, 0=has "next node" information 
                                    // bit 4: 1=journal entry, 0=no journal entry
                                    // bit 5: Unknown
                                    // bit 6: 1=Add Quest Journal entry
                                    // bit 7: 1=Remove Quest Journal entry
                                    // bit 8: 1=Add Done Quest Journal entry
            public int srTransIndex;  // Index of the first transition corresponding to this state only.
            public int srJournIndex;// If flags bit 4 was set, this is the text that goes into your journal after you have spoken.
            public int tTrigIndex;  // If flags bit 1 was set, this is the index of this transition's trigger within the transition trigger table.
            public int actionIndex; // If flags bit 2 was set, this is the index of this transition's action within the action table.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] nxDLG;    // If flags bit 3 was not set, this is the resource name of the DLG resource which contains the next state in the conversation.
            public int nxStateIndex;// If flags bit 3 was not set, this is the index of the next state within the DLG resource specified by the previous field. Control transfers to that state after the party has followed this transition.
 
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSDialogSTrigger // (actor response conditions)
        {
            public int sTrigOffset; // offset from start of file to state trigger string.
            public int sTrigSize;   // length in bytes of the state trigger string.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSDialogTTrigger // (player dialog option conditions)
        {
            public int tTrigOffset; // offset from start of file to state trigger string.
            public int tTrigSize;   // length in bytes of the state trigger string.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSDialogAction // (player dialog option conditions)
        {
            public int actionOffset; // offset from start of file to the action string.
            public int actionSize;   //     length in bytes of the action string.
        }
        
        #endregion File Format for *.DLG File

        #region File Format for *.ARE File

        public static int TSAreaHeaderSize      = Marshal.SizeOf(typeof(TSAreaHeader));
        public static int TSAreaActorSize       = Marshal.SizeOf(typeof(TSAreaActor));
        public static int TSAreaInfoptSize      = Marshal.SizeOf(typeof(TSAreaInfopt));
        public static int TSAreaSpawnSize       = Marshal.SizeOf(typeof(TSAreaSpawn));
        public static int TSAreaEntranceSize    = Marshal.SizeOf(typeof(TSAreaEntrance));
        public static int TSAreaContainerSize   = Marshal.SizeOf(typeof(TSAreaContainer));
        public static int TSAreaItemSize        = Marshal.SizeOf(typeof(TSAreaItem));
        public static int TSAreaVerticeSize     = Marshal.SizeOf(typeof(TSAreaVertice));
        public static int TSAreaAmbientSize     = Marshal.SizeOf(typeof(TSAreaAmbient));
        //// ---- structs below are mainly for area maps that have been explored ---- //
        public static int TSAreaVariableSize    = Marshal.SizeOf(typeof(TSAreaVariable));
        //public static int TSAreaExploreSize     = Marshal.SizeOf(typeof(TSAreaExplore));
        public static int TSAreaDoorSize        = Marshal.SizeOf(typeof(TSAreaDoor));
        public static int TSAreaAnimationSize   = Marshal.SizeOf(typeof(TSAreaAnimation));
        public static int TSAreaMapNoteSize     = Marshal.SizeOf(typeof(TSAreaMapNote));
        public static int TSAreaTileSize        = Marshal.SizeOf(typeof(TSAreaTile));
        public static int TSAreaProjectileSize  = Marshal.SizeOf(typeof(TSAreaProjectile));
        public static int TSAreaSongSize        = Marshal.SizeOf(typeof(TSAreaSong));
        public static int TSAreaAwakenSize      = Marshal.SizeOf(typeof(TSAreaAwaken));

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;    // Signature
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] wedFile;      // Resref of the WED file corresponding to this file.
            public int timeCounter;     // Counter of the time when the area was saved in seconds of real time.
            public int areaFlag;        // Area flag (see AREAFLAG.IDS).
                                        // BG1:TotS, IWD:ToTL, BG2:ToB:
                                        // bit 0: Save allowed
                                        // bit 1: Tutorial area (not BG1)
                                        // bit 2: Dead magic zone
                                        // bit 3: Dream

            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resNorth;     // Resref of the area to the North of this area. Unused used in BG2/IWD
            public int northVal;        // (usually 3, sometimes 1) and in BG2/IWD usually 0
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resEast;      // Resref of the area to the East of this area. Unused used in BG2/IWD
            public int eastVal;         // (usually 3, sometimes 1) and in BG2/IWD usually 0
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resSouth;     // Resref of the area to the South of this area. Unused used in BG2/IWD
            public int southVal;        // (usually 3, sometimes 1) and in BG2/IWD usually 0
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resWest;      // Resref of the area to the West of this area. Unused used in BG2/IWD
            public int westVal;         // (usually 3, sometimes 1) and in BG2/IWD usually 0

            public ushort areaTypeFlag; // Flags: according to the IDSAREATYPE.IDS in ToB 
                                        // bit 0: Outdoor
                                        // bit 1: Day/night
                                        // bit 2: Weather
                                        // bit 3: City
                                        // bit 4: Forest
                                        // bit 5: Dungeon
                                        // bit 6: Extended night
                                        // bit 7: Can rest indoors
                                        // PST areaflags are unknown.

            public ushort probRain;     // Rain probability
            public ushort probSnow;     // Snow probability
            public ushort probFog;      // Fog probability
            public ushort probLightning; // Lightning probability
            public ushort _unknown01;    // Unknown. Always zero, except in BG1/ToTSC outdoor areas

            public int actorsOffset;        // Offset of actors (i.e. creatures and NPCs).
            public ushort actorsCount;      // Count of actors in this area (i.e. creatures and NPCs).
            public ushort infoptsCount;     // Count of info points, trigger points, and exits in this area.
            public int infoptsOffset;       // Offset of info points, trigger points, and exits.
            public int spawnsOffset;        // Offset of spawn points.
            public int spawnsCount;         // Count of spawn points.
            public int entrancesOffset;     // Offset of entrances
            public int entrancesCount;      // Count of entrances
            public int containersOffset;    // Offset of containers
            public ushort containersCount;  // Count of containers
            public ushort itemsCount;       // Count of items
            public int itemsOffset;         // Offset of items.
            public int verticesOffset;      // Offset of vertices..
            public ushort verticesCount;    // Count of vertices
            public ushort ambientsCount;    // Count of ambients (i.e. ambient sounds).
            public int ambientsOffset;      // Offset of ambients.
            public int variablesOffset;     // Offset of variables.
            public int variablesCount;      // Count of variables

            public int _unknown02;          // Unknown, unused ? Set to zero in BG1/ToTSC/BG2/IWD/PST
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] areaBCS;          // Area Script reference
            public int exploredMaskSize;    // "Explored" bitmask size
            public int exploredMaskOffset;  // Offset to "explored" bitmask
            public int doorsCount;          // Count of doors in this area.
            public int doorsOffset;         // Offset to doors structures.
            public int animCount;           // Count of animations in this area.
            public int animOffset;          // Offset to animation structures.
            public int tileObjCount;        // Tiled object count
            public int tileObjOffset;       // Tiled objects offset
            public int songOffset;          // Offset to Songs entries of the area
            public int awakenOffset;        // Offset to interruption of rest party option section 
            public int amapNotesOffset;     // Offset of the automap note section, if any
            public int amapNotesCount;      // Number of entries in the automap note section
            public int projectilesOffset;   // Offset to the projectile traps section, if any
            public int projectilesCount;    // Number of entries in the projectile traps section, if any

            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 72)]
            public byte[] _unknownX;          // Unknown,unused
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaActor
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] actorName;        // Name of this actor (for editors)
            public XPoint actorLoc;          // Current position of this actor within the area.
            public XPoint actorDes;          // Destination position of this actor within the area.
            public int flags;               // Flags: 
                                            // bit 0: CRE attached (0=yes,1=no)
                                            // bit 1: Unknown
                                            // bit 2: Unknown
                                            // bit 3: Actor Name as Death Variable
            public int isSpawned;           // Spawned flag (0=no, 1=yes). Used in memory.
            public int animation;           // animation
            public int facing;              // Actor orientation. 0-15, starting south and incrementing clockwise.
            public int _unknown01;          // Unknown. Usually FFFF FFFF, small values prevent actor appearance?
            public int _unknown02;          // Unknown (usually 0), unused (no effects in game) ?
            public int timeAppear;          // Actor appearence info. Bits 0-23 each represent an hour of game time. Setting a bit to 1 means the actor will appear in the area for the corresponding hour. 
                                            //Hours appear to be offset by 30 minutes as follows:
                                            //bit 23 = 23:30 to 00:29
                                            //bit 22 = 22:30 to 23:29
                                            //bit 21 = 21:30 to 22:29 (Night)
                                            //bit 20 = 20:30 to 21:29 (Dusk)
                                            //bit 19 = 19:30 to 20:29
                                            //bit 18 = 18:30 to 19:29
                                            //bit 17 = 17:30 to 18:29
                                            //bit 16 = 16:30 to 17:29
                                            //bit 15 = 15:30 to 16:29
                                            //bit 14 = 14:30 to 15:29
                                            //bit 13 = 13:30 to 14:29
                                            //bit 12 = 12:30 to 13:29
                                            //bit 11 = 11:30 to 12:29
                                            //bit 10 = 10:30 to 11:29
                                            //bit 9 = 09:30 to 10:29
                                            //bit 8 = 08:30 to 09:29
                                            //bit 7 = 07:30 to 08:29
                                            //bit 6 = 06:30 to 07:29 (Day)
                                            //bit 5 = 05:30 to 06:29 (Dawn)
                                            //bit 4 = 04:30 to 05:29
                                            //bit 3 = 03:30 to 04:29
                                            //bit 2 = 02:30 to 03:29
                                            //bit 1 = 01:30 to 02:29
                                            //bit 0 = 00:30 to 01:29
            public int numTalk;             // Number times the actor has been spoken to (in SAV files).
            
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDLGFile;        // Dialog (overrides dialog assigned in cre file).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resScriptBCS;     // Script (Override).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resClassBCS;      // Script (Class).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resRaceBCS;       // Script (Race).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resMiscBCS;       // Script (General).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDefaultBCS;    // Script (Default).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resSpecificBCS;   // Script (Specific).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resCREFile;       // CRE file.
            public int resCREOffset;        // Offset to CRE structure (stored if the status of this creature is changed from its original status in the CRE file)
            public int resCRESize;          // Size of stored CRE structure

            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 128)]
            public byte[] _unknownX;        // Unknown. Unused? Memory placeholders?
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaInfopt
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] infoptName;   // Name of this info point (for editors)
            public ushort infoptType;   // Type of this "trigger point": 
                                        // 0: Proximity trigger
                                        // 1: Info trigger (sign, point of notice, etc)
                                        // 2: Travel trigger
            public XRect boundBox;       // Minimum bounding box of this point.
            public ushort vertCount;    // Count of vertices composing the perimeter of this info point.
            public int vertStart;       // Index of first vertex for this info point.
            public int _unknown01;      // Unknown. (usually 0)
            public int cursorIcon;      // Index of cursor to use for this region 
                                        // (i.e. usually '22' for info point, 
                                        // '28' for inside exits, '30' for outside exits). 
                                        // This resource taken from cursors.bam  that is 
                                        // the part of GUIbam.bif  file. The frame number 
                                        // to use for the cursor.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] destName;     // Resref of the destination area, if this is an 
                                        // exit. Unused for other object types.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] destEntName;  // Name of the entrance within the destination area 
                                        // where we will appear if we pass through this door. 
                                        // Only used for "exit" objects.
            public int flags;           //Flags: 
                                        //bit 0: Invisible trap
                                        //bit 1: Reset trap (for proximity triggers)
                                        //bit 2: Party Required flag (for travel triggers)
                                        //bit 3: Detectable
                                        //bit 4: Unknown 
                                        //bit 5: Unknown 
                                        //bit 6: NPC can trigger
                                        //bit 7: Unknown 
                                        //bit 8: Deactivated (for proximity triggers)
                                        //bit 9: NPC cant pass (for travel triggers)
                                        //bit 10: Alternative Point
                                        //bit 11: Used by door? 
                                        //bit 12: Unknown 
                                        //bit 13: Unknown 
                                        //bit 14: Unknown 
                                        //bit 15: Unknown                                                
            public int srInfoptIndex;   // The text associated with this "info point", if 
                                        // this is actually an "info point" (i.e. if type==01).
            public ushort trapDetect;   // Trap detection difficulty (%)
            public ushort trapRemove;   // Trap removal difficulty (%)
            public ushort isTrapped;    // bit 0: Whether there is a trap (value 1) or not (value 0)
            public ushort isDetected;   // Trap detected flag
            public XPoint trapLocation;  // "trap launch" location.

            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resITMKey;   // Key type (usage unknown)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resBCS;       // The script associated with this region, if it 
                                        // is a "trigger point". This script is activated when 
                                        // a member of your party passes over one of the edges 
                                        // of the polygon defining this region.
            public XPoint altPoint;      // Alternative use point
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 52)]
            public byte[] _unknownY;    // usage unknown
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDialog;   // dialog (PST only?)

        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaSpawn
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] spawnName;    // Name of this spawn point (this is the full name)
            public XPoint spawnLoc;      // The "location" of this spawn point
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
            public char[] resSpawn;     // Resref of up to 10 creature types that could be put in the area
            public ushort creTypes;     // Number of creature types in this spawn point section.
            public ushort creBase;      // Base creature number to spawn. The actual number to spawn is given by:
                                        // (Frequency * Player Level) / Creature Power. (rounded down)
            public ushort timeToSpawn;  // Time intervals (in seconds) between creatures spawn.
            public ushort spawnEvent;   // Spawn method. (1=Rest,2=Revealed)
            public int _unknown01;      // 0  value disables spawn point.
            public ushort _unknown02;   // Usu. same as 0x0082.
            public ushort _unknown03;   // Usu. same as 0x0080.

            public ushort maxSpawn;     // The maximum number of spawned creatures.
            public ushort flags;        // Active flag. (0=Inactive, 1=Active)

            public int timeAppear;      //Spawn point appearence info. Bits 0-23 each represent an hour of game time. Setting a bit to 1 means the spawn point will be active in the area for the corresponding hour. 
                                        //Hours appear to be offset by 30 minutes as follows:
                                        //bit 23 = 23:30 to 00:29
                                        //bit 22 = 22:30 to 23:29
                                        //bit 21 = 21:30 to 22:29 (Night)
                                        //bit 20 = 20:30 to 21:29 (dusk)
                                        //bit 19 = 19:30 to 20:29
                                        //bit 18 = 18:30 to 19:29
                                        //bit 17 = 17:30 to 18:29
                                        //bit 16 = 16:30 to 17:29
                                        //bit 15 = 15:30 to 16:29
                                        //bit 14 = 14:30 to 15:29
                                        //bit 13 = 13:30 to 14:29
                                        //bit 12 = 12:30 to 13:29
                                        //bit 11 = 11:30 to 12:29
                                        //bit 10 = 10:30 to 11:29
                                        //bit 9 = 09:30 to 10:29
                                        //bit 8 = 08:30 to 09:29
                                        //bit 7 = 07:30 to 08:29
                                        //bit 6 = 06:30 to 07:29 (Day)
                                        //bit 5 = 05:30 to 06:29 (Dawn)
                                        //bit 4 = 04:30 to 05:29
                                        //bit 3 = 03:30 to 04:29
                                        //bit 2 = 02:30 to 03:29
                                        //bit 1 = 01:30 to 02:29
                                        //bit 0 = 00:30 to 01:29 
            public ushort _unknown04;   // Day chance? Usu. value 64h (100)
            public ushort _unknown05;   // Night chance? Usu. value 64h (100)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
            public byte[] _unknownX;    // Unknown. Unused.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaEntrance
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] entranceName; // Name of this entrance -- as referenced by exits which lead to this entrance 
            public XPoint entranceLoc;   // Location of the entrance
            public ushort direction;    // Direction of the entrance
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 66)]
            public byte[] _unknownX; // Unknown, unused
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaContainer
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] containerName;    // Name of this container
            public XPoint containerLoc;      // Location of the container
            public ushort containerType;    // Container type: 
                                            //00: <n/a> 
                                            //01: BAG 
                                            //02: CHEST 
                                            //03: DRAWER 
                                            //04: PILE 
                                            //05: TABLE 
                                            //06: SHELF 
                                            //07: ALTAR 
                                            //08: NONVISIBLE 
                                            //09: SPELLBOOK 
                                            //0a: BODY 
                                            //0b: BARREL 
                                            //0c: CRATE
            public ushort lockDifficulty;   //  Lock difficulty
            public int flags;               // Flags: 
                                            //bit 0: Locked
                                            //bit 1: Unknown
                                            //bit 2: Unknown
                                            //bit 3: Reset Trap
                                            //bit 4: Unknown
                                            //bit 5: Disabled
            public ushort detectDifficulty; // Trap detection difficulty
            public ushort removeDifficulty; // Trap removal difficulty
            public ushort isTrapped;        // Container is trapped (0 if not , 1 otherwise)
            public ushort isDetected;       // Trap has been detected (trap is visible 1, 0 otherwise)
            public int launchTarget;        // Trap launch target
            public XRect boundBox;           // Minimum bounding box of container polygon
            public int itemStart;           // Index of first item in this container
            public int itemCount;           // Count of items in this container.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resBCS;        // Resref of script to trigger if container trap is set off.
            public int vertStart;           // Index of first vertex making up the outline of this container.
            public int vertCount;           // Count of vertices making up the outline of this container.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public byte[] _unknown01;       // Unknown, probably name of trap trigger that could be used 
                                            // in scripts? In IWD, there are some containers that have a 
                                            // resref to a cre file.Take a look at AR1008.ARE for example 
                                            // but i haven't find yet any function for this. Maybe a 
                                            // "awaken" function linking a container to a particular NPC 
                                            // that was never use because of scripting?
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resKeyItem;       // Resref of a "key" item, which, if possessed allows this 
                                            // chest to be opened.
            public int _unknown02;          // Unknown, unused.
            public int srBlocked;           // TLK ref that is displayed when a lockpicking is attempted 
                                            // upon a container that couldn't be unlock (lock strength 
                                            // set to 100 or item needed). Only tested in BG II
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
            public byte[] _unknownX;        // Unknown, unused.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaItem
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resItem;      // Item resource ref
            public ushort itemExpiry;   // Item expiration time (replace with drained item)
            public ushort priCount;     // Usage 1 (typically the number of stacked items or the number of uses of the primary facility of a magical item)
            public ushort secCount;     // Usage 2 (typically the number of uses of the secondary facility of a magical item)
            public ushort terCount;     // Usage 3 (typically the number of uses of the tertiary facility of a magical item)
            public int flags;           //Flags: 
                                        //bit 0: Identified
                                        //bit 1: Unstealable
                                        //bit 2: Stolen
                                        //bit 3: Undroppable
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaVertice
        {
            public XPoint vertex;  // This is an array of points which are used to create the 
                                  // outlines of trigger/info/exit regions and for containers. 
                                  // Not much else to say. Lots of 16-bit words stored x0, y0, x1, y1...
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaAmbient
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] ambientName;      // Name of ambient entry.
            public XPoint ambientLoc;        // Origin point of this sound
            public ushort ambientRadius;    // The radius of this sound.
            public ushort ambientHeight;    //  Height of this sound.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 6)]
            public byte[] _unknown01;       //  Unknown, usually zero.
            public ushort ambientVol;       // Volume of this sound (i.e. as a percentage of the maximum)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
            public char[] resAmbient;       // Resref of up to 10 creature types that could be put in the area
            public ushort soundCount;       // Number of sounds in the array of sound resource at 0x30
            public ushort _unknown02;       // Number of sounds in the array of sound resource at 0x30 
                                            // or zero, exact purpose unknown.
            public int soundTimeInterval;   // Base time (seconds) between sounds from this ambient list
            public int soundTimeDeviation;  // Base time deviation. Time between the start of consecutive sounds 
                                            // uses a uniform distribution over the range (0x0084 - 0x0088) 
                                            // and (0x0084 + 0x0088).
            public int timeAppear;          //Ambience appearence info. Bits 0-23 each represent an hour
                                            //Hours appear to be offset by 30 minutes as follows:
                                            //bit 23 = 23:30 to 00:29
                                            //bit 22 = 22:30 to 23:29
                                            //bit 21 = 21:30 to 22:29 (Night)
                                            //bit 20 = 20:30 to 21:29 (dusk)
                                            //bit 19 = 19:30 to 20:29
                                            //bit 18 = 18:30 to 19:29
                                            //bit 17 = 17:30 to 18:29
                                            //bit 16 = 16:30 to 17:29
                                            //bit 15 = 15:30 to 16:29
                                            //bit 14 = 14:30 to 15:29
                                            //bit 13 = 13:30 to 14:29
                                            //bit 12 = 12:30 to 13:29
                                            //bit 11 = 11:30 to 12:29
                                            //bit 10 = 10:30 to 11:29
                                            //bit 9 = 09:30 to 10:29
                                            //bit 8 = 08:30 to 09:29
                                            //bit 7 = 07:30 to 08:29
                                            //bit 6 = 06:30 to 07:29 (Day)
                                            //bit 5 = 05:30 to 06:29 (Dawn)
                                            //bit 4 = 04:30 to 05:29
                                            //bit 3 = 03:30 to 04:29
                                            //bit 2 = 02:30 to 03:29
                                            //bit 1 = 01:30 to 02:29
                                            //bit 0 = 00:30 to 01:29
            public int flags;               // Flags 
                                            //bit 0: (0) Ambient disabled / (1) Ambient enabled
                                            //bit 1: Reverb
                                            //bit 2: (0) Local (uses radius) / (1) Global (ignores radius)
                                            //bit 3: (0) Sequential ambient selection / (1) Random ambient selection
                                            //bit 4: Unknown
                                            //bit 5: Unknown
                                            //bit 6: Unknown
                                            //bit 7: Unknown
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 64)]
            public byte[] _unknownX;       // Unknown, unused.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaVariable
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] varName;      // Name of this variable.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public byte[] _unknown01;   // Unknown
            public int varValue;        // Variable value
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
            public byte[] _unknownX;    // Unknown 
        }

        // no struct for ExploreredBitmask -- seriously not sure if its useful

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaDoor
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] doorName;     // A long name for this door. Could be used by scripts.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] doorRef;      // A short identifier for this door. Probably used to 
                                        // establish a mapping between doors in the AREA file 
                                        // and doors in the WED file.
            public int flags;           // Flags related to this door. It probably controlls if door is open or closed (since the value is changed in case of opened door) But also :
                                        //bit 0: Door open
                                        //bit 1: Door locked
                                        //bit 2: Reset trap
                                        //bit 3: Trap detectable
                                        //bit 4: Broken
                                        //bit 5: Can't close
                                        //bit 6: Linked
                                        //bit 7: Door Hidden
                                        //bit 8: Door Found (if hidden)
                                        //bit 9: Dont block line of sight
                                        //bit 10: Remove Key
                                        //bit 11: Slide
                                        //Usually values 40, 4a, 42, 4001, 4a01, 4201 for normal doors are used.
            public int openVertStart;       // Index of first vertex comprising the outline of this door while the door is open.
            public ushort openVertCount;    // Count of vertices comprising the outline of this door while the door is open.
            public ushort closeVertCount;   // Count of vertices comprising the outline of this door while the door is close.
            public int closeVertStart;      // Count of vertices comprising the outline of this door while the door is closed.
            public XRect openBoundBox;       // Minimum bounding box of the door polygon when it is open.
            public XRect closeBoundBox;      // Minimum bounding box of the door polygon when it is close
            public int openCellPt;          // Index of first "vertex" in "impeded cell block" for "door open" state. 
                                            // These vertices are not actually vertices, but instead, cell coordinates 
                                            // (each cell corresponding to one tile in the WED file's Tilemap structures. 
                                            // When the door is closed, these cells cannot be entered by any object.
            public ushort openCellPtCount;  // Count of "vertices" in "impeded cell block" for "door open" state.
            public ushort closeCellPtCount; // Count of "vertices" in "impeded cell block" for "door close" state;
            public int closeCellPt;         // Index of first "vertex" in "impeded cell block" for "door close" state. 
                                            // These vertices are not actually vertices, but instead, cell coordinates 
                                            // (each cell corresponding to one tile in the WED file's Tilemap structures. 
                                            // When the door is closed, these cells cannot be entered by any object.
            public ushort _unknown01;       // Unknown
            public ushort _unknown02;       // Unknown
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resOpenSound;     // Two resref to sound files. 1st sound plays on door open. 2nd sound plays on door close.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resCloseSound;    // Two resref to sound files. 1st sound plays on door open. 2nd sound plays on door close.
            public int cursorIndex;         // Index into cursors.bam frame - control the cursor shown when hovering over the door.
            public ushort detectDifficulty; // Trap detection difficulty
            public ushort removeDifficulty; // Trap removal difficulty
            public ushort isTrapped;        // Trapped flag
            public ushort isDetected;       // Trap detected flag
            public XPoint trapLaunch;        // Trap launch target point
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resKeyItem;       // Resref of key item needed to unlock door.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resBCS;           // Resref of script for this item. 
                                            // (Script is activated when "open" attempt is made on item.)
            public int secretDetect;        // Detection difficulty (secret doors)
            public int lockDifficulty;      // Lock difficulty (0-100)
            public XRect toggleLoc;          // Two points. The player will move to the closest of these to toggle the door state.
            public int srBlocked;           // Strref - used when picklock attempted on unpickable door.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public byte[] regionLink;       // Region link. ???
            public int srDoorName;          // Name of this door, if it has one. Name is used if the door initiates dialog with the user.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDialog;        // Resref of the dialog resource associated with this door, if any. This dialog will 
                                            // be used if the door initiates dialog with the user in its associated script.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaAnimation
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] animName;         // Name of animation entry
            public XPoint animLoc;           // Centre point of animation
            public int timeAppear;          // Animation appearence info. Bits 0-23 each represent an hour of game time. Setting a bit to 1 means the actor will appear in the area for the corresponding hour. 
                                            //Hours appear to be offset by 30 minutes as follows:
                                            //bit 23 = 23:30 to 00:29
                                            //bit 22 = 22:30 to 23:29
                                            //bit 21 = 21:30 to 22:29 (Night)
                                            //bit 20 = 20:30 to 21:29 (dusk)
                                            //bit 19 = 19:30 to 20:29
                                            //bit 18 = 18:30 to 19:29
                                            //bit 17 = 17:30 to 18:29
                                            //bit 16 = 16:30 to 17:29
                                            //bit 15 = 15:30 to 16:29
                                            //bit 14 = 14:30 to 15:29
                                            //bit 13 = 13:30 to 14:29
                                            //bit 12 = 12:30 to 13:29
                                            //bit 11 = 11:30 to 12:29
                                            //bit 10 = 10:30 to 11:29
                                            //bit 9 = 09:30 to 10:29
                                            //bit 8 = 08:30 to 09:29
                                            //bit 7 = 07:30 to 08:29
                                            //bit 6 = 06:30 to 07:29 (Day)
                                            //bit 5 = 05:30 to 06:29 (Dawn)
                                            //bit 4 = 04:30 to 05:29
                                            //bit 3 = 03:30 to 04:29
                                            //bit 2 = 02:30 to 03:29
                                            //bit 1 = 01:30 to 02:29
                                            //bit 0 = 00:30 to 01:29
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resBAM;           // The resref of the BAM file to be played for this animation.
            public ushort seqIndex;         // Sequence number (number of animation) within the BAM resource
            public ushort seqCount;         // Number of frame within current animation/sequence in the BAM resource
            public int flags;               // Flags: 
                                            //bit 0: (0) Animation disabled / (1) Animation enabled
                                            //bit 1: (0) Render black as black / (1) Render black as transparent
                                            //bit 2: (0) Self illumination / (1) Non-self illumination
                                            //bit 3: (0) Full animation / (1) Partial animation (stops at frame specified at 0x0032)
                                            //bit 4: (0) Non-synchronized draw / (1) Synchronized draw
                                            //bit 5: Unknown
                                            //bit 6: (0) Wall hides animation / (1) Wall doesn't hide animation 
                                            //bit 7: (0) Visible in dark / (1) Invisible in dark
                                            //bit 8: (0) Cover / (1) Not cover
                                            //bit 9: (0) Don't play all frames / (1) Play all frames
                                            //bit 10: (0) Don't use palette bitmap / (1) Use palatte bitmap
                                            //bit 11: (0) Not mirrored / (1) Mirrored
                                            //bit 12: (0) Hide in combat / (1) Show in combat
                                            //bit 13: Unknown
                                            //bit 14: Unknown
                                            //bit 15: Unknown
            public ushort height;           // Height
            public ushort transparency;     // Transparency (255 is invisible)
            public ushort frameStart;       // Starting frame (0 indicates random frame. Synchronized will clear this)
            public byte loopChance;         // Chance of looping (0 defaults to 100)
            public byte skipCycles;         // Skip cycles
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resPalette;       // Palette resource;
            public int _unknownX;           // Unknown, unused
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaMapNote
        {
            public XPoint noteLoc;   // x, y coordinate of the note
            public int srNote;      // strref to dialog.tlk or TOH/TOT files
            public ushort srLoc;    // Strref location (0=extenal (tot/toh), 1=internal (tlk)
            public ushort color;    // For Baldur's Gate 2 this field specify the color of 
                                    // internal side of mark on worldmap : 
                                    //0 - Gray (default value)
                                    //1 - Violet
                                    //2 - Green
                                    //3 - Orange
                                    //4 - Red
                                    //5 - Blue
                                    //6 - Dark Blue
                                    //7 - Light Gray
            public int noteCount;   // Note count + 10
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 36)]
            public byte[] _unknownX;    // Unused
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaTile
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] tileName;     // Name
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] _unknown01;   // Unknown
            public int _unknown02;      // Unknown
            public int priSqStart;      // Primary search squares start. The primary search squares are 
                                        // the squares which are impeded when the object is in one state 
                                        // (i.e. the search squares through which a creature cannot travel).
            public int priSqCount;      // Primary search squares count
            public int secSqStart;      // Secondary search squares start. The secondary search squares are 
                                        // like the primary search squares, except for when the object is 
                                        // in an alternate state of some sort.
            public int secSqCount;      // Secondary search squares count
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 48)]
            public byte[] _unknownX;    // Unknown (unused?)
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaProjectile
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resProjectile;// Projectile resref
            public int blockOffset;     // Effect block offset
            public int blockSize;       // Effect block size
            public int _unknown01;      // Unknown
            public XPoint projLoc;       // x, y location
            public ushort _unknown02;   // Unknown
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaSong
        {
            public int daySong;             // Day song reference number
            public int nightSong;           // Night song reference number
            public int winSong;             // Win song reference number
            public int battleSong;          // Battle song reference number
            public int loseSong;            // Lose song reference numbers
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
            public byte[] _unknown01;       // Unknown. Usually -1.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDayAmbient1;   // Main day ambient 1 (WAV)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDayAmbient2;   // Main day ambient 2 (WAV)
            public int dayAmbientVol;       // Main day ambient volume %
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resNightAmbient1; // Main night ambient 1 (WAV)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resNightAmbient2; // Main night ambient 2 (WAV)
            public int nightAmbientVol;     // Main night ambient volume %
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 64)]
            public byte[] _unknownX;        // Unknown
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSAreaAwaken
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] awakenName;   // Name of this section (for editors).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
            public int[] srSleepText;   // Ten strrefs, corresponding to the resrefs in next parts 
                                        // that appears when sleep is interrupted (i.e. 9627 0000 
                                        // stands for "You are awakened from your rest." )
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
            public char[] resCreature;  // The 10 resref table that contains of the references to the a cre files.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
            public byte[] _unknown01;   // Unknown.
            public ushort maxSpawn;     // Maximum number of spawned creatures.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 62)]
            public byte[] _unknown02;   // Unknown.

        }
        
        #endregion File Format for *.ARE File

        #region File Format for *.CRE File

        public static int TSCreHeaderSize       = Marshal.SizeOf(typeof(TSCreHeader));
        public static int TSCreKnownSpellSize   = Marshal.SizeOf(typeof(TSCreKnownSpell));
        public static int TSCreSpellMemSize     = Marshal.SizeOf(typeof(TSCreSpellMem));
        public static int TSCreSpellMemRefSize  = Marshal.SizeOf(typeof(TSCreSpellMemRef));
        public static int TSCreItemRefSize      = Marshal.SizeOf(typeof(TSCreItemRef));
        public static int TSCreItemSlotSize     = Marshal.SizeOf(typeof(TSCreItemSlot));

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSCreHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;	// Signature
            public int srFullName;		// Long Creature name
            public int srShortName;		// Short Creature name (used for tooltips)
            public int creFlags;		// Creature flags 
                                        //bit 0 Damage don't stop casting 
                                        //bit 1 No corpse 
                                        //bit 2 Keep corpse 
                                        //bit 3 Original class was Fighter 
                                        //bit 4 Original class was Mage 
                                        //bit 5 Original class was Cleric 
                                        //bit 6 Original class was Thief 
                                        //bit 7 Original class was Druid 
                                        //bit 8 Original class was Ranger 
                                        //bit 9 Fallen Paladin 
                                        //bit 10 Fallen Ranger 
                                        //bit 11 Exportable 
                                        //bit 12 unused ? 
                                        //bit 13 unused ? 
                                        //bit 14 Can activate "Can not be used by NPC" triggers? 
                                        //bit 15 Been in Party 
                                        //The way a multiclass char is indicated is by the absence of any of the "original class" flags being set.
            public int expKill;			// XP (gained for killing this creature)
            public int powerLevel;		// Creature Power Level (for summoning spells) / XP of the creature (for party members)
            public int gold;			// Gold carried
            public int statusFlags;		// Permanent status flags, as per STATE.IDS
            public ushort currHP;		// Current Hit Points
            public ushort maxHP;		// Maximum Hit Points
            public ushort animFlags;	// Animation ID, as per ANIMATE.IDS.
                                        // There is some structure to the ordering of these entries, however, 
                                        // it is mostly hard-coded into the .exe, and uneditable. 
            public ushort _unknown01;   // unknown
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 7)]
            public byte[] colorIndex;   // Colour Index
                                        // 0 Metal Colour Index
                                        // 1 Minor Colour Index
                                        // 2 Major Color Index
                                        // 3 Skin Colour Index
                                        // 4 Leather Colour Index
                                        // 5 Armor Colour Index
                                        // 6 Hair Colour Index
            public byte effectVersion;  // 0 - version 1 // 1 - version 2
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resPortraitS; // Small Portrait resource
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resPortraitL; // Large Portrait resource
            public sbyte reputation;    // Reputation (minimum value: 0)
            public byte hideInShadow;   // Hide In Shadows (base)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 6)]
            public short[] armorClass;  // Armor Class
                                        // 0 Armor Class (Natural)
                                        // 1 Armor Class (Effective)
                                        // 2 Armor Class (Crushing Attacks Modifier)
                                        // 3 Armor Class (Missile Attacks Modifier)
                                        // 4 Armor Class (Piercing Attacks Modifier)
                                        // 5 Armor Class (Slashing Attacks Modifier)
            public byte thaco;          // THAC0 (1-25)
            public byte attacks;        // Number of attacks (0-10)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
            public byte[] saves;        // Saves
                                        // 0 Save versus death (0-20)
                                        // 1 Save versus wands (0-20)
                                        // 2 Save versus polymorph (0-20)
                                        // 3 Save versus breath attacks (0-20)
                                        // 4 Save versus spells (0-20)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 11)]
            public byte[] resists;      // Resistances
                                        // 0 Resist fire (0-100)
                                        // 1 Resist cold (0-100)
                                        // 2 Resist electricity (0-100)
                                        // 3 Resist acid (0-100)
                                        // 4 Resist magic (0-100)
                                        // 5 Resist magic fire (0-100)
                                        // 6 Resist magic cold (0-100)
                                        // 7 Resist slashing (0-100)
                                        // 8 Resist crushing (0-100)
                                        // 9 Resist piercing (0-100)
                                        // 10 Resist missile (0-100)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 7)]
            public byte[] skillThief;   // Thieving skills & lore
                                        // 0 Detect illusion (minimum value : 0)
                                        // 1 Set traps 
                                        // 2 Lore (0-100)* NB. Lore is calculated as ((level * rate) + int_bonus + wis_bonus). 
                                        // 3 Lockpicking (minimum value: 0)
                                        // 4 Stealth (minimum value: 0)
                                        // 5 Find/disarm traps (minimum value: 0)
                                        // 6 Pick pockets (minimum value: 0)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
            public byte[] miscStates;   // Miscellaneous states
                                        // 0 Fatigue (0-100)
                                        // 1 Intoxification (0-100)
                                        // 2 Luck
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public byte[] proficiencies;// Weapon proficiencies
                                        // 0 Large swords proficiency 
                                        // 1 Small swords proficiency
                                        // 2 Bows proficiency 
                                        // 3 Spears proficiency
                                        // 4 Blunt proficiency 
                                        // 5 Spiked proficiency
                                        // 6 Axe proficiency
                                        // 7 Missile proficiency 
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 13)]
            public byte[] _unknown02;   // unknown
            public byte skillTrack;     // Tracking skill (0-100)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public byte[] _unknown03;   // unknown
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 100)]
            public int[] srStrings;     // Strrefs pertaining to the character. 
                                        // Most are connected with the sound-set (see SOUNDOFF.IDS (for BG1) and SNDSLOT.IDS for (BG2)).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
            public byte[] classLevels;  // 0 Highest attained level in primary class (0-100). If dual-classed, 
                                        //   this value is put in the next field, and this field is set to 1.
                                        // 1 Highest attained level in secondary class (0-100)
                                        // 2 Highest attained level in tertiary class (0-100)
                                        //   0 is Dual Classed cre (if 0x0235 is non-zero, >0 is multi-classed)
            public byte gender;         // Sex (from gender.ids) - checkable via the sex stat
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 7)]
            public byte[] stats;        // 0 Strength (1-25)
                                        // 1 Strength % Bonus (0-100)
                                        // 2 Intelligence (1-25)
                                        // 3 Wisdom (1-25)
                                        // 4 Dexterity (1-25)
                                        // 5 Constitution (1-25)
                                        // 6 Charisma (1-25)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
            public byte[] morale;       // 0 Morale
                                        // 1 Morale break
                                        // 2 Racial enemy (RACE.IDS)
                                        // 3 Morale Recovery Time
            public byte _unknown04;     // Unknown
            public int creKit;          // Kit information
                                        //0x00000000 NONE
                                        //0x00004000 KIT_BARBARIAN
                                        //0x40000000 KIT_TRUECLASS
                                        //0x40010000 KIT_BERSERKER
                                        //0x40020000 KIT_WIZARDSLAYER
                                        //0x40030000 KIT_KENSAI
                                        //0x40040000 KIT_CAVALIER
                                        //0x40050000 KIT_INQUISITOR
                                        //0x40060000 KIT_UNDEADHUNTER
                                        //0x40070000 KIT_ARCHER
                                        //0x40080000 KIT_STALKER
                                        //0x40090000 KIT_BEASTMASTER
                                        //0x400A0000 KIT_ASSASSIN
                                        //0x400B0000 KIT_BOUNTYHUNTER
                                        //0x400C0000 KIT_SWASHBUCKLER
                                        //0x400D0000 KIT_BLADE
                                        //0x400E0000 KIT_JESTER
                                        //0x400F0000 KIT_SKALD
                                        //0x40100000 KIT_TOTEMIC
                                        //0x40110000 KIT_SHAPESHIFTER
                                        //0x40120000 KIT_AVENGER
                                        //0x40130000 KIT_GODTALOS
                                        //0x40140000 KIT_GODHELM
                                        //0x40150000 KIT_GODLATHANDER
                                        //0x00400000 ABJURER
                                        //0x00800000 CONJURER
                                        //0x01000000 DIVINER
                                        //0x02000000 ENCHANTER
                                        //0x04000000 ILLUSIONIST
                                        //0x08000000 INVOKER
                                        //0x10000000 NECROMANCER
                                        //0x20000000 TRANSMUTER
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resScriptBCS; // Script (Override).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resClassBCS;  // Script (Class).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resRaceBCS;   // Script (Race).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resMiscBCS;   // Script (General).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDefaultBCS;// Script (Default).
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
            public byte[] objectIds;    // Object Identifiers
                                        // 0 Enemy-Ally (EA.IDS).
                                        // 1 General (GENERAL.IDS)
                                        // 2 Race (RACE.IDS)
                                        // 3 Class (CLASS.IDS)
                                        // 4 Specific (SPECIFIC.IDS)
                                        // 5 Gender (GENDER.IDS). 
                                        // 6-10 Unknown possibly OBJECT.IDS reference
                                        // 11 Alignment (ALIGNMEN.IDS)
            public ushort globalEnum;   // Global actor enumeration value.
            public ushort localEnum;    // Local (area) actor enumeration value.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
            public char[] deathVar;     // Death variable
            public int spellOffset;     // Known spells offset
            public int spellCount;      // Known spells count
            public int spellMemOffset;  // Spell memorization info offset
            public int spellMemCount;   // Spell memorization info entries count
            public int spellMemRefOffset;  // Memorized spells table offset
            public int spellMemRefcount;   // Memorized spells table count
            public int itemSlotOffset;  // Offset to Item slots
            public int itemRefOffset;   // Offset to Items
            public int itemRefCount;    // Count of Items
            public int effectOffset;    // Offset to effects
            public int effectCount;     // Count of effects.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resDLGFile;   // Dialog file. 
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSCreKnownSpell
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resSPLFile;   // Spl file. 
            public ushort spellLevel;   // Spell level
            public ushort spellType;    // Type of the spell: 0 priest, 1 wizard, 2 innate
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSCreSpellMem
        {
            public ushort spellLevel;       // Spell level (less 1)
            public ushort spellMaxMem;      // Number of spells memorizable 
            public ushort spellMaxMemAdj;   // Number of spells memorizable adjusted (after effects)
            public ushort spellType;        // Type of the spell: 0 priest, 1 wizard, 2 innate
            public int spellMemRef;         // Index into memorized spells refarray of first memorized spell of this type in this level.
            public int spellMemRefCount;    // Count of memorized spell entries in memorized spells array of memorized spells of this type in this level.
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSCreSpellMemRef
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resSPLFile;   // Resource name of the SPL file holding the particular memorized spell
            public int isMemorized;     // Memorised: 0 = no, 1 = yes
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSCreItemRef
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resITMFile;   // Resource name of the ITM file holding the particular item
            public ushort expiryTime;   // Item expiration time (replace with drained item)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
            public ushort[] usages;     // Usage1 - often the count of the item (stack), or the number of uses remaining.
            public int itemFlags;       // Item flags
                                        //bit 0: Identified
                                        //bit 1: Unstealable
                                        //bit 2: Stolen
                                        //bit 3: Undroppable
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSCreItemSlot
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 38)]
            public ushort[] slotItemRef;    // Each entry in here will either be 0xffff, 
                                            // meaning "empty", or it will be an index into the Items table
            public int selectedWeapon;      // Selected is a dword indicating which weapon slot us currently selected.
                                            // 0 (Weapon 1)
                                            // 1 (Weapon 2)
                                            // 2 (Weapon 3)
                                            // 3 (Weapon 4)
                                            // 1000 (No slot)
                                            // 65512-Quiver 1
                                            // 65513-Quiver 2
                                            // 65514-Quiver 3
        }

        #endregion File Format for *.CRE File

        #endregion File Formats for Quest Resource Files

        #region File Formats for Graphic Resource Files

        #region File Format for *.WED File

        public static int TSWedHeaderSize   = Marshal.SizeOf(typeof(TSWedHeader));
        public static int TSWedSecHeadSize  = Marshal.SizeOf(typeof(TSWedSecHead));
        public static int TSWedOverlaySize  = Marshal.SizeOf(typeof(TSWedOverlay));
        public static int TSWedDoorSize     = Marshal.SizeOf(typeof(TSWedDoor));
        //public static int TSWedDoorTileSize = Marshal.SizeOf(typeof(TSWedDoorTile));
        public static int TSWedTileMapSize  = Marshal.SizeOf(typeof(TSWedTileMap));
        //public static int TSWedTileRefSize  = Marshal.SizeOf(typeof(TSWedTileRef));
        public static int TSWedWallSize     = Marshal.SizeOf(typeof(TSWedWall));
        //public static int TSWedWallTileSize = Marshal.SizeOf(typeof(TSWedWallTile));
        public static int TSWedPolygonSize  = Marshal.SizeOf(typeof(TSWedPolygon));
        //public static int TSWedVerticeSize  = Marshal.SizeOf(typeof(TSWedVertice));

        // Members of TSWedHeader & TSWedSecHead should be viewed in totally
        // as the merged header for the WED file.
        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSWedHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;    // Signature
            public int overlayCount;    // Number of overlays (including the base layer)
            public int doorCount;       // Number of doors
            public int overlayOffset;   // Transition Count aka Response
            public int secHeadOffset;   // Transition Offset aka Response
            public int doorOffset;      // StateTrigger Offset aka Statement Condition
            public int doorTileOffset;  // StateTrigger Count aka Statement Condition
            public int _aaa;
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSWedSecHead
        {
            public int _wallPolyCount;      // Total Number of wall polygons
            public int wallPolyOffset;      // Offset to wall polygons
            public int verticeOffset;       // Offset to Vertices
            public int wallOffset;          // Offset to Wall groups
            public int wallPolyRefOffset;   // Offset to Polygon indices lookup table
        }
        
        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSWedOverlay
        {
            public ushort xtile;        // Width (in tiles)
            public ushort ytile;       // Height (in tiles)
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] resTIS;       // Name of Tileset (resource type 0x3eb)
            public int _unknown01;      // Unknown
            public int tileMapOffset;   // tilemap offset for this overlay
            public int tileRefOffset;   // tileref offset for this overlay
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSWedDoor
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] refDoor;          // Name of door (matched on in AREA file?)
            public ushort state;            // Unknown... Open/closed? (1==closed)
            public ushort doorTileStart;    // First door tile cell index - not an offset
            public ushort doorTileCount;    // Count of door tile cells for this door
            public ushort openPolyCount;    // Count of polygons used to represent door in "door open" state
            public ushort closePolyCount;   // Count of polygons used to represent door in "door closed" state
            public int openPolyOffset;      // Offset from start of file to polygons used to represent door in "door open" state
            public int closePolyOffset;     // Offset from start of file to polygons used to represent door in "door closed" state
        }

        //[StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        //public struct TSWedDoorTile
        //{
        //    public ushort doorTileMap;      // Size of array of doortileindex = total doors x tiles per door
        //                                    // the value of the index.
        //                                    // The references back to TSWedTileMap.
        //}

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSWedTileMap
        {
            public ushort tileRefStart;     // Start index in tile index lookup table of primary (default) tile
            public ushort tileRefCount;     // Count of tiles in tile index lookup table for primary (default) tile
            public ushort altTileRefStart;  // Index from TIS file of secondary (alternate) tile (i.e. tile for 
                                            // closed state, if tile has an open/closed state) and also for 
                                            // overlays indication (tiles with marked overlay area, by "green" color)
            public byte layerMask;          // The upper 7 bits of this byte are a bitmap indicating which of the 
                                            // overlays are to be drawn. The 0th overlay (the base layer) is always drawn.
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
            public byte[] _unknownX;        // Unknown
        }

        //[StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        //public struct TSWedTileRef
        //{
        //    public ushort tileRef;          // The 'tile map' structures reference indices into this table. 
        //                                    // The 'tile counts' in the tilemap table are counts of indices 
        //                                    // in this table. These tile indices point from the WED tile indices 
        //                                    // into the appropriate tile indices for the particular TIS file which 
        //                                    // the overlay in question references. 
        //}

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSWedWall
        {
            public ushort wallPolyRefStart;    // Start polygon index
            public ushort wallPolyRefCount;    // Polygon index count
        }

        //[StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        //public struct TSWedWallTile
        //{
        //    public ushort wallPolygon;      // Like all the lookup tables in these files, this maps a (start,count) pair (in this case, from the wall group table) into a set of polygon indices (from the polygon table). This is essentially a table of little-endian 16-bit integers which are indices into the polygon table.
        //}

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSWedPolygon
        {
            public int vertexStart;         // Starting vertex index
            public int vertexCount;         // Count of vertices
            public byte flag;               // Indicates whether this polygon is a polygon or a hole (i.e. whether it is a section of impassability, or one of passability.) The default is that wall shades animations from both sides - it is modified by flag.
                                            //bit 0 : Shade wall
                                            //bit 1 : Hovering.
                                            //bit 2 : Cover animations
                                            //bit 3 : Cover animations
                                            //bit 4 : unknown, unused ? 
                                            //bit 5 : unknown, unused ? 
                                            //bit 6 : unknown, unused ? 
                                            //bit 7 : Door?
            public byte _unknown01;         // Unknown... usually value FF
            public ushort minX;             // Min X coord of bounding box
            public ushort maxX;             // Max X coord of bounding box
            public ushort minY;             // Min Y coord of bounding box
            public ushort maxY;             // Max Y coord of bounding box
        }

        //[StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        //public struct TSWedVertice
        //{
        //    Point vertex;                   // This is a table of (x,y) pairs of vertices. 
        //}

        #endregion File Format for *.WED File
        
        #region File Format for *.TIS File

        public static int TSTisHeaderSize = Marshal.SizeOf(typeof(TSTisHeader));

        [StructLayout(LayoutKind.Sequential, Pack = 1, CharSet = CharSet.Ansi)]
        public struct TSTisHeader
        {
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] signature;    // Signature
            public int tileCount;       // Count of tiles within this tileset
            public int tileSize;        // Length of Tiles section
            public int tileOffset;      // offset to tiles
            public int tileDim;         // Dimension of 1 tile in pixels (64x64).
        }

        #endregion File Format for *.TIS File

        #endregion File Formats for Graphic Resource Files

    }

}

// [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
//The sbyte data type is an 8-bit signed integer. 
//The byte data type is an 8-bit unsigned integer. 
//The short data type is a 16-bit signed integer. 
//The ushort is a 16-bit unsigned integer. 
//The int data type is a 32-bit signed integer. 
//The uint is a 32-bit unsigned integer. 
//The long data type is a 64-bit signed integer. 
//The ulong is a 64-bit unsigned integer. 
//The char data type is a Unicode character (16 bits). 
//The float data type is a single-precision floating point. 
//The double data type is a double-precision floating point. 
//The bool data type is a Boolean (true or false). 
//The decimal data type is a decimal type with 28 significant digits (typically used for financial purposes).

