using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

namespace InfinityXplorer.Core
{
    internal static class ResourceClass
    {
        public static readonly int cacheCapacity = 1;
        
        public class ResourceCollection : CollectionBase
        {
            public IResource this[int index]
            {
                get { return ((IResource)InnerList[index]); }
                set { InnerList[index] = value; }
            }

            public ResourceCollection() 
                : base()
            {
                InnerList.Capacity = ResourceClass.cacheCapacity;
            }

            public IResource IsCached(string ckeyName, ResourceStruct.ResourceType rType)
            {
                for (int c = 0; c < InnerList.Count; c++)
                {
                    IResource ires = (IResource)InnerList[c];
                    if ((ires.GetName() == ckeyName) &&
                        (ires.ResourceType() == rType))
                    {
                        // if its already at the top of the stack, what 
                        // for recache it at index 0;
                        if (c > 0)
                            return PushInCache(ires, c);
                        else
                            return ires;

                    }
                }

                return null; // not cached
            }

            public IResource PushInCache(IResource ires)
            {
                return PushInCache(ires, -1);
            }

            public IResource PushInCache(IResource ires, int c)
            {
                if (c > -1)
                {
                    InnerList.RemoveAt(c); // you found in cache;
                }
                // else if (c <= -1) we already know its not in the cache

                if (InnerList.Count == InnerList.Capacity) // Full
                {
                    InnerList.RemoveAt(InnerList.Count - 1); // remove last
                }

                InnerList.Insert(0, ires);

                return ires;
            }

            public void RemoveFromCache(string ckeyName, ResourceStruct.ResourceType rType)
            {
                foreach (IResource ires in InnerList)
                {
                    if ((ires.GetName() == ckeyName) &&
                        (ires.ResourceType() == rType))
                    {
                        InnerList.Remove(ires);
                    }
                }
            }
        }

        public interface IResource
        {
            string GetName();
            ResourceStruct.ResourceType ResourceType();
        }

        public abstract class AbstractIResource : IResource
        {
            private string name;
            public string GetName()
            {
                return this.name;
            }

            private ResourceStruct.ResourceType resourceType;
            public ResourceStruct.ResourceType ResourceType()
            {
                return resourceType;
            }

            public AbstractIResource(string name, 
                ResourceStruct.ResourceType resourceType)
            {
                this.name = name;
                this.resourceType = resourceType;
            }

        }
        
        public class QDLGFile : AbstractIResource
        {
            public struct StateStruct
            {
                public int id;
                public int srStateIndex;    // String Ref index from dialog.tlk
                public int sTrigIndex;      // Trigger for this statement
                public int transIndex;      // first transition index
                public int transCount;      // count transition index.
            }
            public struct TransStruct
            {
                public int id;
                public int flags;           // bit 0: 1=associated text, 0=no associated text 
                                            // bit 1: 1=trigger, 0=no trigger 
                                            // bit 2: 1=action, 0=no action 
                                            // bit 3: 1=terminates dialog, 0=has "next node" information 
                                            // bit 4: 1=journal entry, 0=no journal entry
                                            // bit 5: Unknown
                                            // bit 6: 1=Add Quest Journal entry
                                            // bit 7: 1=Remove Quest Journal entry
                                            // bit 8: 1=Add Done Quest Journal entry
                public int srTransIndex;    // If flags bit 0 was set, this is the text associated with the transition (i.e. what the player character says)
                public int tTrigIndex;      // If flags bit 1 was set, this is the index of this transition's trigger within the transition trigger table.
                public int actionIndex;     // If flags bit 2 was set, this is the index of this transition's action within the action table.
                public string nxDLG;        // If flags bit 3 was not set, this is the resource name of the DLG resource which contains the next state in the conversation.
                public int nxStateIndex;    // If flags bit 3 was not set, this is the index of the next state within the DLG resource specified by the previous field. Control transfers to that state after the party has followed this transition.
                public int srJournIndex;    // If flags bit 4 was set, this is the text that goes into your journal after you have spoken.
            }

            public StateStruct[] stateList;
            public TransStruct[] transList;
            public string[] sTrigList;
            public string[] tTrigList;
            public string[] actionList;

            public QDLGFile(string name) :
                base(name, ResourceStruct.ResourceType.RTypeQDLG)
            {

            }

            public static StateStruct CreateStateStruct(int id, ref FileStruct.TSDialogState tsDialogState)
            {
                StateStruct ss = new StateStruct();
                ss.id = id;
                ss.srStateIndex = tsDialogState.srStateIndex;
                ss.sTrigIndex = tsDialogState.sTrigIndex;
                ss.transIndex = tsDialogState.transIndex;
                ss.transCount = tsDialogState.transCount;
                return ss;
            }
            public static TransStruct CreateTransStruct(int id, ref FileStruct.TSDialogTrans tsDialogTrans)
            {
                TransStruct ss = new TransStruct();
                ss.id = id;
                ss.flags = tsDialogTrans.flags;
                ss.srTransIndex = tsDialogTrans.srTransIndex;
                ss.tTrigIndex = tsDialogTrans.tTrigIndex;
                ss.actionIndex = tsDialogTrans.actionIndex;
                ss.nxDLG = Utils.CharsToString(tsDialogTrans.nxDLG).ToUpper();
                ss.nxStateIndex = tsDialogTrans.nxStateIndex;
                ss.srJournIndex = tsDialogTrans.srJournIndex;
                return ss;
                
            }
        }
    
        public class QAREFile : AbstractIResource
        {
            public struct ItemStruct
            {
                private string resItem;
                public string ResItem
                {
                    get { return resItem; }
                    set { resItem = value; }
                }

                private ushort itemExpiry;
                public ushort ItemExpiry
                {
                    get { return itemExpiry; }
                    set { itemExpiry = value; }
                }

                private ushort priCount;
                public ushort PriCount
                {
                    get { return priCount; }
                    set { priCount = value; }
                }

                private ushort secCount;
                public ushort SecCount
                {
                    get { return secCount; }
                    set { secCount = value; }
                }

                private ushort terCount;
                public ushort TerCount
                {
                    get { return terCount; }
                    set { terCount = value; }
                }

                private int flags;
                public bool IsIdentified 
                {
                    get { return (bool)((flags & (int)FlagsBit.AreaItem.IsIdentified) != 0); }
                    set 
                    {
                        if (value)    
                            flags = (Convert.ToInt32(value) | (int)FlagsBit.AreaItem.IsIdentified); 
                        else
                            flags = (Convert.ToInt32(value) & ~(int)FlagsBit.AreaItem.IsIdentified); 
                    }
                } 
                public bool Unstealable 
                {
                    get { return (bool)((flags & (int)FlagsBit.AreaItem.Unstealable) != 0); }
                    set
                    {
                        if (value)
                            flags = (Convert.ToInt32(value) | (int)FlagsBit.AreaItem.Unstealable);
                        else
                            flags = (Convert.ToInt32(value) & ~(int)FlagsBit.AreaItem.Unstealable);
                    }
                }
                public bool IsStolen 
                {
                    get { return (bool)((flags & (int)FlagsBit.AreaItem.IsStolen) != 0); }
                    set
                    {
                        if (value)
                            flags = (Convert.ToInt32(value) | (int)FlagsBit.AreaItem.IsStolen);
                        else
                            flags = (Convert.ToInt32(value) & ~(int)FlagsBit.AreaItem.IsStolen);
                    }
                }
                public bool Undroppable 
                {
                    get { return (bool)((flags & (int)FlagsBit.AreaItem.Undroppable) != 0); }
                    set
                    {
                        if (value)
                            flags = (Convert.ToInt32(value) | (int)FlagsBit.AreaItem.Undroppable);
                        else
                            flags = (Convert.ToInt32(value) & ~(int)FlagsBit.AreaItem.Undroppable);
                    }
                }

                public ItemStruct(ref FileStruct.TSAreaItem tsAreaItem)
                {
                    this.resItem = Utils.CharsToString(tsAreaItem.resItem).ToUpper();
                    this.itemExpiry = tsAreaItem.itemExpiry;
                    this.priCount = tsAreaItem.priCount;
                    this.secCount = tsAreaItem.secCount;
                    this.terCount = tsAreaItem.terCount;
                    this.flags = tsAreaItem.flags;
                }
            }

            public struct ActorStruct
            {
                public string fullName;
                public XPoint location;          // Current position of this actor within the area.
                public XPoint destination;       // Destination position of this actor within the area.
                public int flags;               // Flags: 
                public int isSpawned;           // Spawned flag (0=no, 1=yes). Used in memory.
                public int animation;           // animation
                public int facing;              // Actor orientation. 0-15, starting south and incrementing clockwise.
                public int timeAppear;          // Actor appearence info. Bits 0-23 each represent an hour of game time. Setting a bit to 1 means the actor will appear in the area for the corresponding hour. 
                public int numTalk;             // Number times the actor has been spoken to (in SAV files).
                public string resDLGFile;        // Dialog (overrides dialog assigned in cre file).
                public string resScriptBCS;     // Script (Override).
                public string resClassBCS;      // Script (Class).
                public string resRaceBCS;       // Script (Race).
                public string resMiscBCS;       // Script (General).
                public string resDefaultBCS;    // Script (Default).
                public string resSpecificBCS;   // Script (Specific).
                public string resCREFile;       // CRE file.
                public int resCREOffset;        // Offset to CRE structure (stored if the status of this creature is changed from its original status in the CRE file)
                public int resCRESize;          // Size of stored CRE structure
            }
            public struct InfoptStruct
            {
                public string fullName;
                public ushort type;
                public int srInfoptIndex;
                public int flags;
                public int cursorIcon;
                public XRect boundBox;
                public int vertStart;
                public ushort vertCount;
                public string destName;
                public string destFullName;
                public ushort trapDetect;
                public ushort trapRemove;
                public ushort isTrapped;
                public ushort isDetected;
                public XPoint trapLocation;
                public string resITMKey;
                public string resBCS;
                public XPoint altPoint;
                public string resDialog;
            }
            public struct SpawnStruct
            {
                public string fullName;
                public XPoint location;
                public string[] resSpawn;   // 10 array
                public ushort creTypes;
                public ushort creBase;
                public ushort timeToSpawn;
                public ushort spawnEvent;
                public ushort maxSpawn;
                public ushort flags;
                public int timeAppear;
            }
            public struct EntranceStruct
            {
                public string fullName;
                public XPoint location;
                public ushort direction;
            }
            public struct ContainerStruct
            {
                public string fullName;
                public XPoint location;
                public ushort type;
                public int flags;
                public ushort lockDiff;
                public ushort detectDiff;
                public ushort removeDiff;
                public ushort isTrapped;
                public ushort isDetected;
                public int launchTarget;
                public XRect boundBox;
                public string resBCS;
                public int vertStart;
                public int vertCount;
                public string resKeyItem;
                public int srBlocked;

                public ItemStruct[] itemList;
            }
            public struct AmbientStruct
            {
                public string fullName;
                public XPoint location;
                public ushort radius;
                public ushort height;
                public ushort volume;
                public string[] resAmbient; // 10 array
                public ushort soundCount;
                public int soundTimeInterval;
                public int soundTimeDeviation;
                public int timeAppear;
                public int flags;
            }
            public struct VariableStruct
            {
                public string varName;
                public int varValue;
            }
            public struct DoorStruct
            {
                public string fullName;
                public string refName;
                public int flags;
                public int cursorIndex;

                public ushort detectDiff;
                public ushort removeDiff;
                public int lockDiff; 
                public ushort isTrapped;
                public ushort isDetected;
                public int secretDetect;
                public XPoint trapLaunch;
                public XRect toggleLoc;
                public byte[] regionLink; //?? 32 bytes
                public int srBlocked;
                public int srDoorName;
                public string resKeyItem;
                public string resBCS;
                public string resDialog;

                public int openVertStart;
                public ushort openVertCount;
                public XRect openBoundBox; 
                public int openCellPt;
                public ushort openCellPtCount;
                public string resOpenSound;

                public int closeVertStart;
                public int closeVertCount;
                public XRect closeBoundBox;
                public int closeCellPt;
                public ushort closeCellPtCount;
                public string resCloseSound;
            }
            public struct AnimStruct
            {
                public string fullName;
                public XPoint location;
                public int timeAppear;
                public string resBAM;
                public ushort seqIndex;
                public ushort seqCount;
                public int flags;
                public ushort height;
                public ushort transparency;
                public ushort frameStart;
                public byte loopChance;
                public byte skipCycles;
                public string resPalette;
            }
            public struct MapNoteStruct
            {
                public int srNote;
                public ushort srLoc;
                public XPoint location;
                public ushort color;
                public int noteCount;
            }
            public struct TileStruct
            {
                public string fullName;
                public int priSqStart;
                public int priSqCount;
                public int secSqStart;
                public int secSqCount;
            }
            public struct ProjectileStruct
            {
                public string resProjectile;
                public int blockOffset;
                public int blockSize;
                public XPoint location;
            }
            public struct SongStruct
            {
                public int daySong;
                public int nightSong;
                public int winSong;
                public int battleSong;
                public int loseSong;
                public string resDayAmbient1;
                public string resDayAmbient2;
                public int dayAmbientVol;
                public string resNightAmbient1;
                public string resNightAmbient2;
                public int nightAmbientVol;
            }
            public struct AwakenStruct
            {
                public string fullName;
                public int[] srSleepText;       // 10 array
                public string[] resCreature;    // 10 array
                public ushort maxSpawn;
            }

            public ActorStruct[] actorList;
            public InfoptStruct[] infoptList;
            public SpawnStruct[] spawnList;
            public EntranceStruct[] entranceList;
            public ContainerStruct[] containerList;
            public AmbientStruct[] ambientList;
            public VariableStruct[] varList;
            public DoorStruct[] doorList;
            public AnimStruct[] animList;
            public MapNoteStruct[] mapNoteList;
            public TileStruct[] tileList;
            public ProjectileStruct[] projectileList;

            public XPoint[] vertices;
            public SongStruct song;
            public AwakenStruct awaken;

            #region Header members

            public string wedFile;
            public int timeCounter;
            public int areaFlag;
            public ushort areaTypeFlag;
            public ushort probRain;
            public ushort probSnow;
            public ushort probFog;
            public ushort probLightning;
            public string resNorth;
            public int northVal;
            public string resSouth;
            public int southVal;
            public string resEast;
            public int eastVal;
            public string resWest;
            public int westVal;
            
            #endregion Header members

            public QAREFile(string name)
                : base(name, ResourceStruct.ResourceType.RTypeQARE)
            {
            }

            public void SetHeader(ref FileStruct.TSAreaHeader tsAreaHeader)
            {
                this.wedFile = Utils.CharsToString(tsAreaHeader.wedFile).ToUpper();
                this.timeCounter = tsAreaHeader.timeCounter;
                this.areaFlag = tsAreaHeader.areaFlag;
                this.areaTypeFlag = tsAreaHeader.areaTypeFlag;

                this.resNorth = Utils.CharsToString(tsAreaHeader.resNorth).ToUpper();
                this.northVal = tsAreaHeader.northVal;
                this.resSouth = Utils.CharsToString(tsAreaHeader.resSouth).ToUpper();
                this.southVal = tsAreaHeader.southVal;
                this.resEast = Utils.CharsToString(tsAreaHeader.resEast).ToUpper();
                this.eastVal = tsAreaHeader.eastVal;
                this.resWest = Utils.CharsToString(tsAreaHeader.resWest).ToUpper();
                this.westVal = tsAreaHeader.westVal;

                this.probRain = tsAreaHeader.probRain;
                this.probSnow = tsAreaHeader.probSnow;
                this.probFog = tsAreaHeader.probFog;
                this.probLightning = tsAreaHeader.probLightning;
            }

            public static ActorStruct CreateActorStruct(ref FileStruct.TSAreaActor tsAreaActor)
            {
                ActorStruct ss = new ActorStruct();
                ss.fullName = Utils.CharsToString(tsAreaActor.actorName);
                ss.location = tsAreaActor.actorLoc;
                ss.destination = tsAreaActor.actorDes;
                ss.flags = tsAreaActor.flags;
                ss.isSpawned = tsAreaActor.isSpawned;
                ss.animation = tsAreaActor.animation;
                ss.facing = tsAreaActor.facing;
                ss.timeAppear = tsAreaActor.timeAppear;
                ss.numTalk = tsAreaActor.numTalk;
                ss.resDLGFile = Utils.CharsToString(tsAreaActor.resDLGFile).ToUpper();
                ss.resScriptBCS = Utils.CharsToString(tsAreaActor.resScriptBCS).ToUpper();
                ss.resClassBCS = Utils.CharsToString(tsAreaActor.resClassBCS).ToUpper();
                ss.resRaceBCS = Utils.CharsToString(tsAreaActor.resRaceBCS).ToUpper();
                ss.resMiscBCS = Utils.CharsToString(tsAreaActor.resMiscBCS).ToUpper();
                ss.resDefaultBCS = Utils.CharsToString(tsAreaActor.resDefaultBCS).ToUpper();
                ss.resSpecificBCS = Utils.CharsToString(tsAreaActor.resSpecificBCS).ToUpper();
                ss.resCREFile = Utils.CharsToString(tsAreaActor.resCREFile).ToUpper();
                ss.resCREOffset = tsAreaActor.resCREOffset;
                ss.resCRESize = tsAreaActor.resCRESize;
                return ss;
            }
            public static InfoptStruct CreateInfoptStruct(ref FileStruct.TSAreaInfopt tsAreaInfopt)
            {
                InfoptStruct ss = new InfoptStruct();
                ss.fullName = Utils.CharsToString(tsAreaInfopt.infoptName);
                ss.type = tsAreaInfopt.infoptType;
                ss.srInfoptIndex = tsAreaInfopt.srInfoptIndex;
                ss.flags = tsAreaInfopt.flags;
                ss.cursorIcon = tsAreaInfopt.cursorIcon;
                ss.boundBox = tsAreaInfopt.boundBox;
                ss.vertStart = tsAreaInfopt.vertStart;
                ss.vertCount = tsAreaInfopt.vertCount;
                ss.destName = Utils.CharsToString(tsAreaInfopt.destName).ToUpper();
                ss.destFullName = Utils.CharsToString(tsAreaInfopt.destEntName);
                ss.trapDetect = tsAreaInfopt.trapDetect;
                ss.trapRemove = tsAreaInfopt.trapRemove;
                ss.isTrapped = tsAreaInfopt.isTrapped;
                ss.isDetected = tsAreaInfopt.isDetected;
                ss.trapLocation = tsAreaInfopt.trapLocation;
                ss.resITMKey = Utils.CharsToString(tsAreaInfopt.resITMKey).ToUpper();
                ss.resBCS = Utils.CharsToString(tsAreaInfopt.resBCS).ToUpper();
                ss.altPoint = tsAreaInfopt.altPoint;
                ss.resDialog = Utils.CharsToString(tsAreaInfopt.resDialog).ToUpper();
                return ss;
            }
            public static SpawnStruct CreateSpawnStruct(ref FileStruct.TSAreaSpawn tsAreaSpawn)
            {
                SpawnStruct ss = new SpawnStruct();
                ss.fullName = Utils.CharsToString(tsAreaSpawn.spawnName);
                ss.location = tsAreaSpawn.spawnLoc;
                
                ss.resSpawn = new string[10];
                char[] buff = new char[8];
                for (int c = 0; c < 10; c++)
                {
                    Array.Copy(tsAreaSpawn.resSpawn, c * buff.Length, buff, 0, buff.Length);
                    ss.resSpawn[c] = Utils.CharsToString(buff).ToUpper();
                }

                ss.creTypes = tsAreaSpawn.creTypes;
                ss.creBase = tsAreaSpawn.creBase;
                ss.timeToSpawn = tsAreaSpawn.timeToSpawn;
                ss.spawnEvent = tsAreaSpawn.spawnEvent;
                ss.maxSpawn = tsAreaSpawn.maxSpawn;
                ss.flags = tsAreaSpawn.flags;
                ss.timeAppear = tsAreaSpawn.timeAppear;
                return ss;
            }
            public static EntranceStruct CreateEntranceStruct(ref FileStruct.TSAreaEntrance tsAreaEntrance)
            {
                EntranceStruct ss = new EntranceStruct();
                ss.fullName = Utils.CharsToString(tsAreaEntrance.entranceName);
                ss.location = tsAreaEntrance.entranceLoc;
                ss.direction = tsAreaEntrance.direction;
                return ss;
            }
            public static ContainerStruct CreateContainerStruct(
                ref FileStruct.TSAreaContainer tsAreaContainer,
                ref ItemStruct[] itemList)
            {
                ContainerStruct ss = new ContainerStruct();
                ss.fullName = Utils.CharsToString(tsAreaContainer.containerName);
                ss.location = tsAreaContainer.containerLoc;
                ss.type = tsAreaContainer.containerType;
                ss.flags = tsAreaContainer.flags;
                ss.lockDiff = tsAreaContainer.lockDifficulty;
                ss.detectDiff = tsAreaContainer.detectDifficulty;
                ss.removeDiff = tsAreaContainer.removeDifficulty;
                ss.isTrapped = tsAreaContainer.isTrapped;
                ss.isDetected = tsAreaContainer.isDetected;
                ss.launchTarget = tsAreaContainer.launchTarget;
                ss.boundBox = tsAreaContainer.boundBox;
                ss.resBCS = Utils.CharsToString(tsAreaContainer.resBCS).ToUpper();
                ss.vertStart = tsAreaContainer.vertStart;
                ss.vertCount = tsAreaContainer.vertCount;
                ss.resKeyItem = Utils.CharsToString(tsAreaContainer.resKeyItem).ToUpper();
                ss.srBlocked = tsAreaContainer.srBlocked;

                ss.itemList = new ItemStruct[tsAreaContainer.itemCount];
                Array.Copy(itemList, tsAreaContainer.itemStart, ss.itemList, 0, tsAreaContainer.itemCount);
                return ss;
            }
            public static AmbientStruct CreateAmbientStruct(ref FileStruct.TSAreaAmbient tsAreaAmbient)
            {
                AmbientStruct ss = new AmbientStruct();
                ss.fullName = Utils.CharsToString(tsAreaAmbient.ambientName);
                ss.location = tsAreaAmbient.ambientLoc;
                ss.radius = tsAreaAmbient.ambientRadius;
                ss.height = tsAreaAmbient.ambientHeight;
                ss.volume = tsAreaAmbient.ambientVol;

                ss.resAmbient = new string[10];
                char[] buff = new char[8];
                for (int c = 0; c < 10; c++)
                {
                    Array.Copy(tsAreaAmbient.resAmbient, c * buff.Length, buff, 0, buff.Length);
                    ss.resAmbient[c] = Utils.CharsToString(buff).ToUpper();
                }

                ss.soundCount = tsAreaAmbient.soundCount;
                ss.soundTimeInterval = tsAreaAmbient.soundTimeInterval;
                ss.soundTimeDeviation = tsAreaAmbient.soundTimeDeviation;
                ss.timeAppear = tsAreaAmbient.timeAppear;
                ss.flags = tsAreaAmbient.flags;
                return ss;
            }
            public static VariableStruct CreateVariableStruct(ref FileStruct.TSAreaVariable tsAreaVariable)
            {
                VariableStruct ss = new VariableStruct();
                ss.varName = Utils.CharsToString(tsAreaVariable.varName);
                ss.varValue = tsAreaVariable.varValue;
                return ss;
            }
            public static DoorStruct CreateDoorStruct(ref FileStruct.TSAreaDoor tsAreaDoor)
            {
                DoorStruct ss = new DoorStruct();
                ss.fullName = Utils.CharsToString(tsAreaDoor.doorName);
                ss.refName = Utils.CharsToString(tsAreaDoor.doorRef).ToUpper();
                ss.flags = tsAreaDoor.flags;

                ss.cursorIndex = tsAreaDoor.cursorIndex;

                ss.detectDiff = tsAreaDoor.detectDifficulty;
                ss.removeDiff = tsAreaDoor.removeDifficulty;
                ss.lockDiff = tsAreaDoor.lockDifficulty; 
                ss.isTrapped = tsAreaDoor.isTrapped;
                ss.isDetected = tsAreaDoor.isDetected;
                ss.secretDetect = tsAreaDoor.secretDetect;
                ss.trapLaunch = tsAreaDoor.trapLaunch;
                ss.toggleLoc = tsAreaDoor.toggleLoc;
                ss.regionLink = tsAreaDoor.regionLink; //?? 32 bytes
                ss.srBlocked = tsAreaDoor.srBlocked;
                ss.srDoorName = tsAreaDoor.srDoorName;

                ss.resKeyItem = Utils.CharsToString(tsAreaDoor.resKeyItem).ToUpper();
                ss.resBCS = Utils.CharsToString(tsAreaDoor.resBCS).ToUpper();
                ss.resDialog = Utils.CharsToString(tsAreaDoor.resDialog).ToUpper();

                ss.openVertStart = tsAreaDoor.openVertStart;
                ss.openVertCount = tsAreaDoor.openVertCount;
                ss.openBoundBox = tsAreaDoor.openBoundBox; 
                ss.openCellPt = tsAreaDoor.openCellPt;
                ss.openCellPtCount = tsAreaDoor.openCellPtCount;
                ss.resOpenSound = Utils.CharsToString(tsAreaDoor.resOpenSound).ToUpper();

                ss.closeVertStart = tsAreaDoor.closeVertStart;
                ss.closeVertCount = tsAreaDoor.closeVertCount;
                ss.closeBoundBox = tsAreaDoor.closeBoundBox;
                ss.closeCellPt = tsAreaDoor.closeCellPt;
                ss.closeCellPtCount = tsAreaDoor.closeCellPtCount;
                ss.resCloseSound = Utils.CharsToString(tsAreaDoor.resCloseSound).ToUpper();
                return ss;
            }
            public static AnimStruct CreateAnimStruct(ref FileStruct.TSAreaAnimation tsAreaAnimation)
            {
                AnimStruct ss = new AnimStruct();
                ss.fullName = Utils.CharsToString(tsAreaAnimation.animName);
                ss.location = tsAreaAnimation.animLoc;
                ss.timeAppear = tsAreaAnimation.timeAppear;
                ss.resBAM = Utils.CharsToString(tsAreaAnimation.resBAM).ToUpper();
                ss.seqIndex = tsAreaAnimation.seqIndex;
                ss.seqCount = tsAreaAnimation.seqCount;
                ss.flags = tsAreaAnimation.flags;
                ss.height = tsAreaAnimation.height;
                ss.transparency = tsAreaAnimation.transparency;
                ss.frameStart = tsAreaAnimation.frameStart;
                ss.loopChance = tsAreaAnimation.loopChance;
                ss.skipCycles = tsAreaAnimation.skipCycles;
                ss.resPalette = Utils.CharsToString(tsAreaAnimation.resPalette).ToUpper();;
                return ss;
            }
            public static MapNoteStruct CreateMapNoteStruct(ref FileStruct.TSAreaMapNote tsAreaMapNote)
            {
                MapNoteStruct ss = new MapNoteStruct();
                ss.srNote = tsAreaMapNote.srNote;
                ss.srLoc = tsAreaMapNote.srLoc;
                ss.location = tsAreaMapNote.noteLoc;
                ss.color = tsAreaMapNote.color;
                ss.noteCount = tsAreaMapNote.noteCount;
                return ss;
            }
            public static TileStruct CreateTileStruct(ref FileStruct.TSAreaTile tsAreaTile)
            {
                TileStruct ss = new TileStruct();
                ss.fullName = Utils.CharsToString(tsAreaTile.tileName);
                ss.priSqStart = tsAreaTile.priSqStart;
                ss.priSqCount = tsAreaTile.priSqCount;
                ss.secSqStart = tsAreaTile.secSqStart;
                ss.secSqCount = tsAreaTile.secSqCount;
                return ss;
            }
            public static ProjectileStruct CreateProjectileStruct(ref FileStruct.TSAreaProjectile tsAreaProjectile)
            {
                ProjectileStruct ss = new ProjectileStruct();
                ss.resProjectile = Utils.CharsToString(tsAreaProjectile.resProjectile).ToUpper();
                ss.blockOffset = tsAreaProjectile.blockOffset;
                ss.blockSize = tsAreaProjectile.blockSize;
                ss.location = tsAreaProjectile.projLoc;
                return ss;
            }
            public static SongStruct CreateSongStruct(ref FileStruct.TSAreaSong tsAreaSong)
            {
                SongStruct ss = new SongStruct();
                ss.daySong = tsAreaSong.daySong;
                ss.nightSong = tsAreaSong.nightSong;
                ss.winSong = tsAreaSong.winSong;
                ss.battleSong = tsAreaSong.battleSong;
                ss.loseSong = tsAreaSong.loseSong;
                ss.resDayAmbient1 = Utils.CharsToString(tsAreaSong.resDayAmbient1).ToUpper();
                ss.resDayAmbient2 = Utils.CharsToString(tsAreaSong.resDayAmbient2).ToUpper();;
                ss.dayAmbientVol = tsAreaSong.dayAmbientVol;
                ss.resNightAmbient1 = Utils.CharsToString(tsAreaSong.resNightAmbient1).ToUpper();
                ss.resNightAmbient2 = Utils.CharsToString(tsAreaSong.resNightAmbient2).ToUpper();
                ss.nightAmbientVol = tsAreaSong.nightAmbientVol;
                return ss;
            }
            public static AwakenStruct CreateAwakenStruct(ref FileStruct.TSAreaAwaken tsAreaAwaken)
            {
                AwakenStruct ss = new AwakenStruct();

                ss.fullName = Utils.CharsToString(tsAreaAwaken.awakenName);
                ss.srSleepText = tsAreaAwaken.srSleepText;       // 10 array

                ss.resCreature = new string[10]; // 10 array
                char[] buff = new char[8];
                for (int c = 0; c < 10; c++)
                {
                    Array.Copy(tsAreaAwaken.resCreature, c * buff.Length, buff, 0, buff.Length);
                    ss.resCreature[c] = Utils.CharsToString(buff).ToUpper();
                }

                ss.maxSpawn = tsAreaAwaken.maxSpawn;

                return ss;
            }

        }

        public class GWEDFile : AbstractIResource
        {
            public struct OverlayStruct
            {
                public ushort xtile;        // Width (in tiles)
                public ushort ytile;        // Height (in tiles)
                public string resTIS;       // Name of Tileset (resource type 0x3eb)
                public TileMapStruct[,] tileMaps;
            }
            public struct DoorStruct
            {
                public string refDoor;          // Name of door (matched on in AREA file?)
                public ushort state;            // Unknown... Open/closed? (1==closed)
                public PolygonStruct[] openPoly;
                public PolygonStruct[] closePoly;
                public TileMapStruct[] tileMaps;
            }
            public struct WallStruct
            {
                public PolygonStruct[] wallPoly;
            }
            public struct TileMapStruct
            {
                public ushort[] tileRef;        // Start index in tile index lookup table of primary (default) tile
                public ushort altTileRef;       // Index from TIS file of secondary (alternate) tile (i.e. tile for 
                                                // closed state, if tile has an open/closed state) and also for 
                                                // overlays indication (tiles with marked overlay area, by "green" color)
                public byte layerMask;          // The upper 7 bits of this byte are a bitmap indicating which of the 
            }
            public struct PolygonStruct
            {
                public byte flag;               // Indicates whether this polygon is a polygon or a hole (i.e. whether it is a section of impassability, or one of passability.) The default is that wall shades animations from both sides - it is modified by flag.
                                                //bit 0 : Shade wall
                                                //bit 1 : Hovering.
                                                //bit 2 : Cover animations
                                                //bit 3 : Cover animations
                                                //bit 4 : unknown, unused ? 
                                                //bit 5 : unknown, unused ? 
                                                //bit 6 : unknown, unused ? 
                                                //bit 7 : Door?
                public XRect boundBox;           // minX minY maxX maxY
                public XPoint[] vertices;        
            }
            
            public OverlayStruct[] overlayList;
            public DoorStruct[] doorList;
            public WallStruct[] wallList;
            
            public GWEDFile(string name)
                : base(name, ResourceStruct.ResourceType.RTypeGWED)
            {

            }

            public static OverlayStruct CreateOverlayStruct(ref FileStruct.TSWedOverlay tsWedOverlay)
            {
                OverlayStruct ss = new OverlayStruct();
                ss.xtile = tsWedOverlay.xtile;
                ss.ytile = tsWedOverlay.ytile;
                ss.resTIS = Utils.CharsToString(tsWedOverlay.resTIS).ToUpper();
                ss.tileMaps = new TileMapStruct[ss.xtile, ss.ytile];
                return ss;
            }
            public static DoorStruct CreateDoorStruct(ref FileStruct.TSWedDoor tsWedDoor)
            {
                DoorStruct ss = new DoorStruct();
                ss.refDoor = Utils.CharsToString(tsWedDoor.refDoor).ToUpper();  
                ss.state = tsWedDoor.state;
                ss.openPoly = new PolygonStruct[tsWedDoor.openPolyCount];
                ss.closePoly = new PolygonStruct[tsWedDoor.closePolyCount];
                ss.tileMaps = new TileMapStruct[tsWedDoor.doorTileCount];
                return ss;
            }
            public static WallStruct CreateWallStruct(ref FileStruct.TSWedWall tsWedWall)
            {
                WallStruct ss = new WallStruct();
                ss.wallPoly = new PolygonStruct[tsWedWall.wallPolyRefCount];
                return ss;
            }
            public static TileMapStruct CreateTileMapStruct(ref FileStruct.TSWedTileMap tsWedTileMap)
            {
                TileMapStruct ss = new TileMapStruct();
                ss.tileRef = new ushort[tsWedTileMap.tileRefCount];
                ss.altTileRef = 0xFFFF;
                ss.layerMask = tsWedTileMap.layerMask;
                return ss;
            }
            public static PolygonStruct CreatePolygonStruct(ref FileStruct.TSWedPolygon tsWedPolygon)
            {
                PolygonStruct ss = new PolygonStruct();
                ss.flag = tsWedPolygon.flag;
                ss.boundBox.left = tsWedPolygon.minX;
                ss.boundBox.top = tsWedPolygon.minY;
                ss.boundBox.right = tsWedPolygon.maxX;
                ss.boundBox.bottom = tsWedPolygon.maxY;
                ss.vertices = new XPoint[tsWedPolygon.vertexCount];
                return ss;
            }
        }

        public class GTISFile : AbstractIResource
        {
            private static int TSPaletteSize = Marshal.SizeOf(typeof(TSPalette));
            private static byte[] tisBuff = new byte[TSPaletteSize];

            private FileStream tisStream;
            private int tisOrigin;

            public GTISFile(string name)
                : base(name, ResourceStruct.ResourceType.RTypeGTIS)
            {

            }

            public void SetTisStream(FileStream stream, int offset)
            {
                this.tisStream = stream;
                this.tisOrigin = offset;                
            }

            public Bitmap CreateTileLayerImage(Bitmap canvas, ResourceClass.GWEDFile.TileMapStruct[,] tileMaps,
                int tileRefIndex, TileRect tileRect, ushort tilePixel, ushort bright)
            {
                byte[] buff = new byte[tilePixel * tilePixel]; // 64 x 64 
                Rectangle rect;
                ushort tileRef;

                for (ushort r = tileRect.minY; r < tileRect.maxY; r++)
                {
                    for (ushort c = tileRect.minX; c < tileRect.maxX; c++)
                    {
                        tileRef = tileMaps[c, r].tileRef[tileRefIndex];
                        rect = new Rectangle(c * tilePixel, r * tilePixel, tilePixel, tilePixel);
                        this.GetTileBitmap(canvas, buff, ref tileRef, rect, ref bright);
                    }
                }

                return canvas;
            }

            private Bitmap GetTileBitmap(Bitmap bmpBuffer, byte[] buff, 
                ref ushort tileRef, Rectangle rect, ref ushort bright)
            {
                int blockSize = TSPaletteSize + (rect.Width * rect.Width); // 1024 + 64x64 = 5120
                tisStream.Position = tisOrigin + (tileRef * blockSize);
                
                TSPalette palette = FileReader.ReadPaletteBuffer(tisStream, tisBuff, TSPaletteSize);
                tisStream.Read(buff, 0, buff.Length);

                BitmapData data = bmpBuffer.LockBits(rect, ImageLockMode.ReadWrite, bmpBuffer.PixelFormat);

                int height = data.Height;
                int width = data.Width;
                int offset = data.Stride - data.Width * 3;
                
                int c = 0;

                unsafe
                {
                    byte* ptr = (byte*)(data.Scan0);

                    for (int row = 0; row < height; row++)
                    {
                        for (int col = 0; col < width; col++)
                        {
                            *ptr = GetVal((ushort)(palette.palette[buff[c]].red + bright)); ptr++;
                            *ptr = GetVal((ushort)(palette.palette[buff[c]].green + bright)); ptr++;
                            *ptr = GetVal((ushort)(palette.palette[buff[c]].blue + bright)); ptr++;
                            c++;
                        }

                        ptr += offset;
                    }
                }

                bmpBuffer.UnlockBits(data);

                return bmpBuffer;
            }

            private byte GetVal(ushort val)
            {
                if (val < 0) return 0;
                if (val > 255) return 255;
                return (byte)val;
            }

        }
    }

}
