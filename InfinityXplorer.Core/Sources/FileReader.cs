using System;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Runtime.InteropServices;

namespace InfinityXplorer.Core
{
    // This file reader is a decoder for the IE file types

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
    internal static class FileReader
    {
        //private static byte[] nameBuff;
        private static byte[] buff;

        public static string ReadOffsetStringHeader(FileStream fileStream, int buffSize)
        {
            return ReadOffsetStringBuffer(fileStream, 0, buffSize);
        }

        public static TSPalette ReadPaletteBuffer(FileStream fileStream, byte[] buff, int buffSize)
        {
            return (TSPalette)ReadBuffer<TSPalette>(fileStream, buff, buffSize);
        }
        
        private static object ReadBuffer<BuffType>(FileStream fileStream, byte[] buff, int buffSize)
        {
            //Read byte array
            fileStream.Read(buff, 0, buffSize); 

            //Make sure that the Garbage Collector doesn't move our buffer 
            GCHandle handle = GCHandle.Alloc(buff, GCHandleType.Pinned);
            //Marshal the bytes
            object o = (object)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(BuffType));
            //Give control of the buffer back to the GC 
            
            handle.Free();

            return o;
        }

        private static string ReadOffsetStringBuffer(FileStream fileStream, long offsetPos, int buffSize)
        {
            byte[] buff = new byte[buffSize];
            long fPos = fileStream.Position;

            fileStream.Position = offsetPos;
            fileStream.Read(buff, 0, buffSize);
            fileStream.Position = fPos;

            // Note that for multi-language, the encoding below would be better
            // Encoding.GetEncoding(1251).GetString(str); (1251 is English)
            return Utils.CharsToString(ASCIIEncoding.ASCII.GetChars(buff));
            //return ASCIIEncoding.ASCII.GetString(buff); //, 0, buffSize);
        }

        public static string[] ReadIniFileCDPaths(string fileName)
        {
            StringBuilder sb = Utils.ReadFromStream(fileName);

            if (sb == null) return null;

            string pat = "CD[0-9].*\\.*"; //string pat = "^[HC]D[0-9].+\\.+$";

            MatchCollection matches = Regex.Matches(sb.ToString(), pat);

            string[] words = new string[matches.Count];

            for (int i = 0; i < matches.Count; i++)
            {
                words[i] = matches[i].Value.Remove(0,5).TrimEnd('\r');
            }

            return words;            
        }

        public static bool ReadChitinKeyFile(ChitinIndex chitinIndex, string fileName)
        {
            FileStream fileStream = Utils.ReadFileStream(fileName);

            if (fileStream == null) return false;

            buff = new byte[FileStruct.TSChitinHeaderSize];
            fileStream.Position = 0;

            FileStruct.TSChitinHeader chitinHead =
                (FileStruct.TSChitinHeader)ReadBuffer<FileStruct.TSChitinHeader>
                (fileStream, buff, FileStruct.TSChitinHeaderSize);

            if (GlobalDefs.CHITINKEY_SIGNATURE != Utils.CharsToString(chitinHead.signature))
            {
                throw new ArgumentException("Warning: Invalid signature in *.key file.");
            }

            // Load up all the biffs into a collection
            buff = new byte[FileStruct.TSChitinBiffSize];
            fileStream.Position = chitinHead.biffOffset;

            chitinIndex.CbiffCollection.SetCapacity(chitinHead.biffCount + 30);

            for (int c = 0; c < chitinHead.biffCount; c++)
            {
                FileStruct.TSChitinBiff tsBiff =
                    (FileStruct.TSChitinBiff)ReadBuffer<FileStruct.TSChitinBiff>
                    (fileStream, buff, FileStruct.TSChitinBiffSize);

                string biffName = ReadOffsetStringBuffer(fileStream, tsBiff.biffNameOffset, tsBiff.biffNameSize);
                chitinIndex.AddChitinBiff(ref tsBiff, ref biffName);
            }

            // Load up the chitinkeys into the super dictionary
            buff = new byte[FileStruct.TSChitinKeySize];
            fileStream.Position = chitinHead.ckeyOffset;

            for (int c = 0; c < chitinHead.ckeyCount; c++)
            {
                FileStruct.TSChitinKey tsCkey =
                    (FileStruct.TSChitinKey)ReadBuffer<FileStruct.TSChitinKey>
                    (fileStream, buff, FileStruct.TSChitinKeySize);
                
                chitinIndex.AddChitinKey(ref tsCkey);
            }

            fileStream.Close();

            return true;
        }

        public static bool ReadTalkRefFile(TalkIndex talkIndex, string fileName)
        {
            FileStream fileStream = Utils.ReadFileStream(fileName);

            if (fileStream == null) return false;

            buff = new byte[FileStruct.TSTalkHeaderSize];
            fileStream.Position = 0;

            FileStruct.TSTalkHeader talkHead =
                 (FileStruct.TSTalkHeader)ReadBuffer<FileStruct.TSTalkHeader>
                 (fileStream, buff, FileStruct.TSTalkHeaderSize);

            if (GlobalDefs.DIALOGTLK_SIGNATURE != Utils.CharsToString(talkHead.signature))
            {
                throw new ArgumentException("Warning: Invalid signature in *.tlk file.");
            }

            // Load up all the talkRef into a collection
            buff = new byte[FileStruct.TSTalkRefSize];
            talkIndex.TrefCollection.SetCapacity(talkHead.tlkCount);

            for (int c = 0; c < talkHead.tlkCount; c++)
            {
                FileStruct.TSTalkRef tsTalkRef =
                    (FileStruct.TSTalkRef)ReadBuffer<FileStruct.TSTalkRef>
                    (fileStream, buff, FileStruct.TSTalkRefSize);

                string strText = ReadOffsetStringBuffer(fileStream, talkHead.tlkOffset + tsTalkRef.strOffset, tsTalkRef.strSize);
                talkIndex.AddTalkRef(ref tsTalkRef, ref strText);
            }

            fileStream.Close();

            return true;
        }

        public static FileStream ReadChitinBiffFile(ChitinBiff cbiff)
        {
            FileStream fileStream = ApplicationService.FindBiffFile(cbiff);
            
            if (fileStream == null) return null;

            if ((cbiff.fileList == null) && (cbiff.tileList == null))
            {
                // since this cbiff hasn't been accessed yet. lets load up its 
                // file entries
                buff = new byte[FileStruct.TSBiffHeaderSize];
                fileStream.Position = 0;

                FileStruct.TSBiffHeader biffHead =
                     (FileStruct.TSBiffHeader)ReadBuffer<FileStruct.TSBiffHeader>
                     (fileStream, buff, FileStruct.TSBiffHeaderSize);

                if (GlobalDefs.CHITINBIFF_SIGNATURE != Utils.CharsToString(biffHead.signature))
                {
                    throw new ArgumentException("Warning: Invalid signature in *.bif file.");
                }
                
                // Load up all the chitin into a collection
                buff = new byte[FileStruct.TSBiffFilesetSize];
                fileStream.Position = biffHead.fileOffset;

                cbiff.fileList = new ChitinBiff.BiffFileStruct[biffHead.fileCount];
                for (int c = 0; c < biffHead.fileCount; c++)
                {
                    FileStruct.TSBiffFileset tsBiffFile =
                        (FileStruct.TSBiffFileset)ReadBuffer<FileStruct.TSBiffFileset>
                        (fileStream, buff, FileStruct.TSBiffFilesetSize);

                    cbiff.fileList[c] = ChitinBiff.CreateBiffFileStruct(tsBiffFile);
                }

                buff = new byte[FileStruct.TSBiffTilesetSize];
                cbiff.tileList = new ChitinBiff.BiffTileStruct[biffHead.tileCount];

                for (int c = 0; c < biffHead.tileCount; c++)
                {
                    FileStruct.TSBiffTileset tsBiffTile =
                        (FileStruct.TSBiffTileset)ReadBuffer<FileStruct.TSBiffTileset>
                        (fileStream, buff, FileStruct.TSBiffTilesetSize);

                    cbiff.tileList[c] = ChitinBiff.CreateBiffTileStruct(tsBiffTile);
                }

            }

            // fileStream.Close() don't close this filestream as we want to send it back
            return fileStream;
        }

        // ---------- From here onwards, we shall read the unique resource files ---------- //

        public static ResourceClass.IResource ReadIResourceFile(bool headerOnly, 
            ChitinKey ckey, ResourceStruct.DelegateResourceFileReader resourceFileReader)
        {
            string overrideFile =
                ApplicationService.FindOverrideFile(ckey.name, ckey.resourceType);

            FileStream fileStream;
            int fileOffset;
            int fileSize;
                        
            if (overrideFile != null) // Found it in override, so just use it
            {
                fileStream = Utils.ReadFileStream(overrideFile);
                fileOffset = 0;
                fileSize = 0;
            }
            else if (ckey.isBiffed) // Load from biff file
            {
                ChitinBiff cbiff = ApplicationRuntime.ChitinIndex.CbiffCollection[ckey.biffIndex];

                if ((fileStream = ReadChitinBiffFile(cbiff)) == null) return null;

                if (ckey.resourceType != ResourceStruct.ResourceType.RTypeGTIS)
                {
                    fileOffset = cbiff.fileList[ckey.ckeyIndex].offset;
                    fileSize = cbiff.fileList[ckey.ckeyIndex].size;
                }
                else
                {
                    fileOffset = cbiff.tileList[ckey.tileIndex].tileOffset;
                    fileSize = cbiff.tileList[ckey.tileIndex].tileSize;
                }
            }
            else
            {
                return null;
            }

            try
            {
                // apply the delegate here
                return resourceFileReader(headerOnly, ckey, fileStream, fileOffset, fileSize);
            }
            catch (Exception e)
            {
                throw new ArgumentException(e.Message);
                //return null;
            }
        }

        public static ResourceClass.IResource ReadQDLGResourceFile(bool headerOnly, 
            ChitinKey ckey, FileStream fileStream, int fileOffset, int fileSize)
        {
            ResourceClass.QDLGFile dlgFile = new ResourceClass.QDLGFile(ckey.name);

            #region Check file header

            buff = new byte[FileStruct.TSDialogHeaderSize];
            fileStream.Position = fileOffset;

            FileStruct.TSDialogHeader dlgHead =
                 (FileStruct.TSDialogHeader)ReadBuffer<FileStruct.TSDialogHeader>
                 (fileStream, buff, FileStruct.TSDialogHeaderSize);

            if (GlobalDefs.RES_QDLG_SIGNATURE != Utils.CharsToString(dlgHead.signature))
            {
                throw new ArgumentException("Warning: Invalid signature in *.dlg file.");
            }

            #endregion Check file header

            #region Load up the supporting sTrigger / tTrigger / Action lists

            // sTrigger
            buff = new byte[FileStruct.TSDialogSTriggerSize];
            fileStream.Position = dlgHead.sTrigOffset + fileOffset;

            dlgFile.sTrigList = new string[dlgHead.sTrigCount];
            for (int c = 0; c < dlgHead.sTrigCount; c++)
            {
                FileStruct.TSDialogSTrigger sTrigger =
                     (FileStruct.TSDialogSTrigger)ReadBuffer<FileStruct.TSDialogSTrigger>
                     (fileStream, buff, FileStruct.TSDialogSTriggerSize);

                dlgFile.sTrigList[c] = ReadOffsetStringBuffer(fileStream, sTrigger.sTrigOffset + fileOffset, sTrigger.sTrigSize);
            }

            // tTrigger
            buff = new byte[FileStruct.TSDialogTTriggerSize];
            fileStream.Position = dlgHead.tTrigOffset + fileOffset;

            dlgFile.tTrigList = new string[dlgHead.tTrigCount];
            for (int c = 0; c < dlgHead.tTrigCount; c++)
            {
                FileStruct.TSDialogTTrigger tTrigger =
                     (FileStruct.TSDialogTTrigger)ReadBuffer<FileStruct.TSDialogTTrigger>
                     (fileStream, buff, FileStruct.TSDialogTTriggerSize);
                                
                dlgFile.tTrigList[c] = ReadOffsetStringBuffer(fileStream, tTrigger.tTrigOffset + fileOffset, tTrigger.tTrigSize);
            }

            // aTrigger
            buff = new byte[FileStruct.TSDialogActionSize];
            fileStream.Position = dlgHead.actionOffset + fileOffset;

            dlgFile.actionList = new string[dlgHead.actionCount];
            for (int c = 0; c < dlgHead.actionCount; c++)
            {
                FileStruct.TSDialogAction action =
                     (FileStruct.TSDialogAction)ReadBuffer<FileStruct.TSDialogAction>
                     (fileStream, buff, FileStruct.TSDialogActionSize);

                dlgFile.actionList[c] = ReadOffsetStringBuffer(fileStream, action.actionOffset + fileOffset, action.actionSize);
            }

            #endregion Load up the supporting sTrigger / tTrigger / Action lists

            #region Load important file stuff

            // Load up dialog states / statement
            buff = new byte[FileStruct.TSDialogStateSize];
            fileStream.Position = dlgHead.stateOffset + fileOffset;

            dlgFile.stateList = new ResourceClass.QDLGFile.StateStruct[dlgHead.stateCount];
            for (int c = 0; c < dlgHead.stateCount; c++)
            {
                FileStruct.TSDialogState tsDlgState =
                    (FileStruct.TSDialogState)ReadBuffer<FileStruct.TSDialogState>
                    (fileStream, buff, FileStruct.TSDialogStateSize);

                dlgFile.stateList[c] = ResourceClass.QDLGFile.CreateStateStruct(c, ref tsDlgState);
            }

            // Load up dialog trans / responses
            buff = new byte[FileStruct.TSDialogTransSize];
            fileStream.Position = dlgHead.transOffset + fileOffset;

            dlgFile.transList = new ResourceClass.QDLGFile.TransStruct[dlgHead.transCount];
            for (int c = 0; c < dlgHead.transCount; c++)
            {
                FileStruct.TSDialogTrans tsDlgTrans =
                    (FileStruct.TSDialogTrans)ReadBuffer<FileStruct.TSDialogTrans>
                    (fileStream, buff, FileStruct.TSDialogTransSize);

                dlgFile.transList[c] = ResourceClass.QDLGFile.CreateTransStruct(c, ref tsDlgTrans);
            }

            #endregion Load important file stuff

            fileStream.Close();

            return dlgFile;
        }

        public static ResourceClass.IResource ReadQAREResourceFile(bool headerOnly, 
            ChitinKey ckey, FileStream fileStream, int fileOffset, int fileSize)
        {
            ResourceClass.QAREFile areFile = new ResourceClass.QAREFile(ckey.name);

            #region Check file header

            buff = new byte[FileStruct.TSAreaHeaderSize];
            fileStream.Position = fileOffset;

            FileStruct.TSAreaHeader areHead =
                 (FileStruct.TSAreaHeader)ReadBuffer<FileStruct.TSAreaHeader>
                 (fileStream, buff, FileStruct.TSAreaHeaderSize);

            if (GlobalDefs.RES_QARE_SIGNATURE != Utils.CharsToString(areHead.signature))
            {
                throw new ArgumentException("Warning: Invalid signature in *.are file.");
            }

            areFile.SetHeader(ref areHead);

            #endregion Check file header

            #region Load base area stuff 

            // looks neat enough, but can consider writing subroutines for each arraylist

            // --- actor list --- //

            buff = new byte[FileStruct.TSAreaActorSize];
            fileStream.Position = areHead.actorsOffset + fileOffset;

            areFile.actorList = new ResourceClass.QAREFile.ActorStruct[areHead.actorsCount];
            for (int c = 0; c < areHead.actorsCount; c++)
            {
                FileStruct.TSAreaActor tsAreaActor =
                    (FileStruct.TSAreaActor)ReadBuffer<FileStruct.TSAreaActor>
                    (fileStream, buff, FileStruct.TSAreaActorSize);

                areFile.actorList[c] = ResourceClass.QAREFile.CreateActorStruct(ref tsAreaActor);
            }

            // --- infopt list --- //

            buff = new byte[FileStruct.TSAreaInfoptSize];
            fileStream.Position = areHead.infoptsOffset + fileOffset;

            areFile.infoptList = new ResourceClass.QAREFile.InfoptStruct[areHead.infoptsCount];
            for (int c = 0; c < areHead.infoptsCount; c++)
            {
                FileStruct.TSAreaInfopt tsAreaInfopt =
                    (FileStruct.TSAreaInfopt)ReadBuffer<FileStruct.TSAreaInfopt>
                    (fileStream, buff, FileStruct.TSAreaInfoptSize);

                areFile.infoptList[c] = ResourceClass.QAREFile.CreateInfoptStruct(ref tsAreaInfopt);
            }

            // --- spawn list --- //

            buff = new byte[FileStruct.TSAreaSpawnSize];
            fileStream.Position = areHead.spawnsOffset + fileOffset;

            areFile.spawnList = new ResourceClass.QAREFile.SpawnStruct[areHead.spawnsCount];
            for (int c = 0; c < areHead.spawnsCount; c++)
            {
                FileStruct.TSAreaSpawn tsAreaSpawn =
                    (FileStruct.TSAreaSpawn)ReadBuffer<FileStruct.TSAreaSpawn>
                    (fileStream, buff, FileStruct.TSAreaSpawnSize);

                areFile.spawnList[c] = ResourceClass.QAREFile.CreateSpawnStruct(ref tsAreaSpawn);
            }

            // --- entrance list --- //

            buff = new byte[FileStruct.TSAreaEntranceSize];
            fileStream.Position = areHead.entrancesOffset + fileOffset;

            areFile.entranceList = new ResourceClass.QAREFile.EntranceStruct[areHead.entrancesCount];
            for (int c = 0; c < areHead.entrancesCount; c++)
            {
                FileStruct.TSAreaEntrance tsAreaEntrance =
                    (FileStruct.TSAreaEntrance)ReadBuffer<FileStruct.TSAreaEntrance>
                    (fileStream, buff, FileStruct.TSAreaEntranceSize);

                areFile.entranceList[c] = ResourceClass.QAREFile.CreateEntranceStruct(ref tsAreaEntrance);
            }
            
            // --- item list --- //

            buff = new byte[FileStruct.TSAreaItemSize];
            fileStream.Position = areHead.itemsOffset + fileOffset;

            ResourceClass.QAREFile.ItemStruct[] itemList = 
                new ResourceClass.QAREFile.ItemStruct[areHead.itemsCount];
            for (int c = 0; c < areHead.itemsCount; c++)
            {
                FileStruct.TSAreaItem tsAreaItem =
                    (FileStruct.TSAreaItem)ReadBuffer<FileStruct.TSAreaItem>
                    (fileStream, buff, FileStruct.TSAreaItemSize);

                itemList[c] = new ResourceClass.QAREFile.ItemStruct(ref tsAreaItem);
            }

            // --- container list --- //

            buff = new byte[FileStruct.TSAreaContainerSize];
            fileStream.Position = areHead.containersOffset + fileOffset;

            areFile.containerList = new ResourceClass.QAREFile.ContainerStruct[areHead.containersCount];
            for (int c = 0; c < areHead.containersCount; c++)
            {
                FileStruct.TSAreaContainer tsAreaContainer =
                    (FileStruct.TSAreaContainer)ReadBuffer<FileStruct.TSAreaContainer>
                    (fileStream, buff, FileStruct.TSAreaContainerSize);

                areFile.containerList[c] = ResourceClass.QAREFile.
                    CreateContainerStruct(ref tsAreaContainer, ref itemList);
            }

            // --- vertex list --- //

            buff = new byte[FileStruct.TSAreaVerticeSize];
            fileStream.Position = areHead.verticesOffset + fileOffset;

            areFile.vertices = new XPoint[areHead.verticesCount];
            for (int c = 0; c < areHead.verticesCount; c++)
            {
                FileStruct.TSAreaVertice tsAreaVertice =
                    (FileStruct.TSAreaVertice)ReadBuffer<FileStruct.TSAreaVertice>
                    (fileStream, buff, FileStruct.TSAreaVerticeSize);

                areFile.vertices[c] = tsAreaVertice.vertex;
            }

            // --- ambient list --- //

            buff = new byte[FileStruct.TSAreaAmbientSize];
            fileStream.Position = areHead.ambientsOffset + fileOffset;

            areFile.ambientList = new ResourceClass.QAREFile.AmbientStruct[areHead.ambientsCount];
            for (int c = 0; c < areHead.ambientsCount; c++)
            {
                FileStruct.TSAreaAmbient tsAreaAmbient =
                    (FileStruct.TSAreaAmbient)ReadBuffer<FileStruct.TSAreaAmbient>
                    (fileStream, buff, FileStruct.TSAreaAmbientSize);

                areFile.ambientList[c] = ResourceClass.QAREFile.CreateAmbientStruct(ref tsAreaAmbient);
            }

            // --- variables list --- //

            buff = new byte[FileStruct.TSAreaVariableSize];
            fileStream.Position = areHead.variablesOffset + fileOffset;

            areFile.varList = new ResourceClass.QAREFile.VariableStruct[areHead.variablesCount];
            for (int c = 0; c < areHead.variablesCount; c++)
            {
                FileStruct.TSAreaVariable tsAreaVariable =
                    (FileStruct.TSAreaVariable)ReadBuffer<FileStruct.TSAreaVariable>
                    (fileStream, buff, FileStruct.TSAreaVariableSize);

                areFile.varList[c] = ResourceClass.QAREFile.CreateVariableStruct(ref tsAreaVariable);
            }

            // --- door list --- //

            buff = new byte[FileStruct.TSAreaDoorSize];
            fileStream.Position = areHead.doorsOffset + fileOffset;

            areFile.doorList = new ResourceClass.QAREFile.DoorStruct[areHead.doorsCount];
            for (int c = 0; c < areHead.doorsCount; c++)
            {
                FileStruct.TSAreaDoor tsAreaDoor =
                    (FileStruct.TSAreaDoor)ReadBuffer<FileStruct.TSAreaDoor>
                    (fileStream, buff, FileStruct.TSAreaDoorSize);

                areFile.doorList[c] = ResourceClass.QAREFile.CreateDoorStruct(ref tsAreaDoor);
            }

            // --- animation list --- //

            buff = new byte[FileStruct.TSAreaAnimationSize];
            fileStream.Position = areHead.animOffset + fileOffset;

            areFile.animList = new ResourceClass.QAREFile.AnimStruct[areHead.animCount];
            for (int c = 0; c < areHead.animCount; c++)
            {
                FileStruct.TSAreaAnimation tsAreaAnimation =
                    (FileStruct.TSAreaAnimation)ReadBuffer<FileStruct.TSAreaAnimation>
                    (fileStream, buff, FileStruct.TSAreaAnimationSize);

                areFile.animList[c] = ResourceClass.QAREFile.CreateAnimStruct(ref tsAreaAnimation);
            }

            // --- automap list --- //

            buff = new byte[FileStruct.TSAreaMapNoteSize];
            fileStream.Position = areHead.amapNotesOffset + fileOffset;

            areFile.mapNoteList = new ResourceClass.QAREFile.MapNoteStruct[areHead.amapNotesCount];
            for (int c = 0; c < areHead.amapNotesCount; c++)
            {
                FileStruct.TSAreaMapNote tsAreaMapNote =
                    (FileStruct.TSAreaMapNote)ReadBuffer<FileStruct.TSAreaMapNote>
                    (fileStream, buff, FileStruct.TSAreaMapNoteSize);

                areFile.mapNoteList[c] = ResourceClass.QAREFile.CreateMapNoteStruct(ref tsAreaMapNote);
            }

            // --- tiled list --- //

            buff = new byte[FileStruct.TSAreaTileSize];
            fileStream.Position = areHead.tileObjOffset + fileOffset;

            areFile.tileList = new ResourceClass.QAREFile.TileStruct[areHead.tileObjCount];
            for (int c = 0; c < areHead.tileObjCount; c++)
            {
                FileStruct.TSAreaTile tsAreaTile =
                    (FileStruct.TSAreaTile)ReadBuffer<FileStruct.TSAreaTile>
                    (fileStream, buff, FileStruct.TSAreaTileSize);

                areFile.tileList[c] = ResourceClass.QAREFile.CreateTileStruct(ref tsAreaTile);
            }

            // --- projectiles list --- //

            buff = new byte[FileStruct.TSAreaProjectileSize];
            fileStream.Position = areHead.projectilesOffset + fileOffset;

            areFile.projectileList = new ResourceClass.QAREFile.ProjectileStruct[areHead.projectilesCount];
            for (int c = 0; c < areHead.projectilesCount; c++)
            {
                FileStruct.TSAreaProjectile tsAreaProjectile =
                    (FileStruct.TSAreaProjectile)ReadBuffer<FileStruct.TSAreaProjectile>
                    (fileStream, buff, FileStruct.TSAreaProjectileSize);

                areFile.projectileList[c] = ResourceClass.QAREFile.CreateProjectileStruct(ref tsAreaProjectile);
            }

            #endregion Load single sections

            #region Load single sections
            
            buff = new byte[FileStruct.TSAreaSongSize];
            fileStream.Position = areHead.songOffset + fileOffset;

            FileStruct.TSAreaSong tsAreaSong =
                (FileStruct.TSAreaSong)ReadBuffer<FileStruct.TSAreaSong>
                (fileStream, buff, FileStruct.TSAreaSongSize);

            areFile.song = ResourceClass.QAREFile.CreateSongStruct(ref tsAreaSong);

            buff = new byte[FileStruct.TSAreaAwakenSize];
            fileStream.Position = areHead.awakenOffset + fileOffset;

            FileStruct.TSAreaAwaken tsAreaAwaken =
                (FileStruct.TSAreaAwaken)ReadBuffer<FileStruct.TSAreaAwaken>
                (fileStream, buff, FileStruct.TSAreaAwakenSize);

            areFile.awaken = ResourceClass.QAREFile.CreateAwakenStruct(ref tsAreaAwaken);

            #endregion

            fileStream.Close();

            return areFile;
        }

        private static ResourceClass.GWEDFile.PolygonStruct GetGWEDPolygon(
            FileStream fileStream, byte[] polyBuff, byte[] vtBuff, int offset)
        {
            // (1) get the polygon 
            FileStruct.TSWedPolygon tsWedPolygon =
                (FileStruct.TSWedPolygon)ReadBuffer<FileStruct.TSWedPolygon>
                (fileStream, polyBuff, FileStruct.TSWedPolygonSize);

            ResourceClass.GWEDFile.PolygonStruct poly = 
                ResourceClass.GWEDFile.CreatePolygonStruct(ref tsWedPolygon);

            // (2) get the set of points for each polygon
            long polypos = fileStream.Position;
            fileStream.Position = (tsWedPolygon.vertexStart * 4) + offset;

            for (int v = 0; v < tsWedPolygon.vertexCount; v++)
            {
                poly.vertices[v] = (XPoint)ReadBuffer<XPoint>(fileStream, vtBuff, 4);
            }

            fileStream.Position = polypos;

            return poly;
        }

        private static ResourceClass.GWEDFile.TileMapStruct GetGWEDTileMap(
            FileStream fileStream, byte[] tmBuff, int offset)
        {
            // (1) get the tilemap from the filestream
            FileStruct.TSWedTileMap tsWedTileMap =
                (FileStruct.TSWedTileMap)ReadBuffer<FileStruct.TSWedTileMap>
                (fileStream, tmBuff, FileStruct.TSWedTileMapSize);

            ResourceClass.GWEDFile.TileMapStruct tileMap = 
                ResourceClass.GWEDFile.CreateTileMapStruct(ref tsWedTileMap);
            
            // (2) get the tileref[] for each tilemap
            long tmpos = fileStream.Position;
            fileStream.Position = (tsWedTileMap.tileRefStart * 2) + offset;

            byte[] usBuff = new byte[tsWedTileMap.tileRefCount * 2];
            fileStream.Read(usBuff, 0, usBuff.Length);
            Buffer.BlockCopy(usBuff, 0, tileMap.tileRef, 0, usBuff.Length);

            // (3) get the alttile for each tilemap
            if (tsWedTileMap.altTileRefStart < 0xFFFF)
            {
                fileStream.Position = (tsWedTileMap.altTileRefStart * 2) + offset;
                usBuff = new byte[2];
                fileStream.Read(usBuff, 0, usBuff.Length);
                tileMap.altTileRef = BitConverter.ToUInt16(usBuff, 0);
            }

            fileStream.Position = tmpos;

            return tileMap;
        }

        public static ResourceClass.IResource ReadGWEDResourceFile(bool headerOnly, 
            ChitinKey ckey, FileStream fileStream, int fileOffset, int fileSize)
        {
            ResourceClass.GWEDFile wedFile = new ResourceClass.GWEDFile(ckey.name);
            
            #region Check file header
            
            buff = new byte[FileStruct.TSWedHeaderSize];
            fileStream.Position = fileOffset;

            FileStruct.TSWedHeader wedHead =
                 (FileStruct.TSWedHeader)ReadBuffer<FileStruct.TSWedHeader>
                 (fileStream, buff, FileStruct.TSWedHeaderSize);

            if (GlobalDefs.RES_GWED_SIGNATURE != Utils.CharsToString(wedHead.signature))
            {
                throw new ArgumentException("Warning: Invalid signature in *.wed file.");
            }

            buff = new byte[FileStruct.TSWedSecHeadSize];
            fileStream.Position = wedHead.secHeadOffset + fileOffset;

            FileStruct.TSWedSecHead wedSecHead =
                 (FileStruct.TSWedSecHead)ReadBuffer<FileStruct.TSWedSecHead>
                 (fileStream, buff, FileStruct.TSWedSecHeadSize);
            
            #endregion Check file header

            int tileMapOffset = -1;
            int tileRefOffset = -1;

            byte[] tmBuff = new byte[FileStruct.TSWedTileMapSize];
            byte[] polyBuff = new byte[FileStruct.TSWedPolygonSize];
            byte[] vtBuff = new byte[4];        // Point
            int vertOffset = wedSecHead.verticeOffset + fileOffset;
            
            #region Load overlays

            // --- overlay list --- //
            buff = new byte[FileStruct.TSWedOverlaySize];

            fileStream.Position = wedHead.overlayOffset + fileOffset;

            wedFile.overlayList = new ResourceClass.GWEDFile.OverlayStruct[wedHead.overlayCount];
            for (int c = 0; c < wedHead.overlayCount; c++)
            {
                FileStruct.TSWedOverlay tsWedOverlay =
                    (FileStruct.TSWedOverlay)ReadBuffer<FileStruct.TSWedOverlay>
                    (fileStream, buff, FileStruct.TSWedOverlaySize);

                ResourceClass.GWEDFile.OverlayStruct olay = 
                    ResourceClass.GWEDFile.CreateOverlayStruct(ref tsWedOverlay);

                wedFile.overlayList[c] = olay;

                if (tileMapOffset < 0) // get the offsets for overlay[0]
                {
                    tileMapOffset = tsWedOverlay.tileMapOffset;
                    tileRefOffset = tsWedOverlay.tileRefOffset;
                }

                long fpos = fileStream.Position;

                fileStream.Position = tsWedOverlay.tileMapOffset + fileOffset;
                // for each (x,y) tile in the overlay
                for (int y = 0; y < olay.ytile; y++)
                {
                    for (int x = 0; x < olay.xtile; x++)
                    {
                        olay.tileMaps[x, y] = GetGWEDTileMap(fileStream, tmBuff,
                            tsWedOverlay.tileRefOffset + fileOffset);
                    }
                }

                fileStream.Position = fpos;
            }

            #endregion Load overlays

            #region Load doors

            // --- door list --- //

            buff = new byte[FileStruct.TSWedDoorSize];
            fileStream.Position = wedHead.doorOffset + fileOffset;

            wedFile.doorList = new ResourceClass.GWEDFile.DoorStruct[wedHead.doorCount];
            for (int c = 0; c < wedHead.doorCount; c++)
            {
                FileStruct.TSWedDoor tsWedDoor =
                    (FileStruct.TSWedDoor)ReadBuffer<FileStruct.TSWedDoor>
                    (fileStream, buff, FileStruct.TSWedDoorSize);
                
                ResourceClass.GWEDFile.DoorStruct door = 
                    ResourceClass.GWEDFile.CreateDoorStruct(ref tsWedDoor);

                wedFile.doorList[c] = door;

                long fpos = fileStream.Position;
                fileStream.Position = wedHead.doorTileOffset + (tsWedDoor.doorTileStart * 2) + fileOffset;

                ushort[] doorTiles = new ushort[tsWedDoor.doorTileCount];
                byte[] doorTileBuff = new byte[tsWedDoor.doorTileCount * 2];
                fileStream.Read(doorTileBuff, 0, doorTileBuff.Length);
                Buffer.BlockCopy(doorTileBuff, 0, doorTiles, 0, doorTileBuff.Length);

                for (int d = 0; d < tsWedDoor.doorTileCount; d++)
                {
                    fileStream.Position = tileMapOffset +
                        (doorTiles[d] * FileStruct.TSWedTileMapSize) + fileOffset;

                    door.tileMaps[d] = GetGWEDTileMap(fileStream, tmBuff, tileRefOffset + fileOffset);
                }

                fileStream.Position = tsWedDoor.openPolyOffset + fileOffset;
                // for each open polygon
                for (int p = 0; p < tsWedDoor.openPolyCount; p++)
                {
                    door.openPoly[p] = GetGWEDPolygon(fileStream, polyBuff, vtBuff, vertOffset);
                }

                fileStream.Position = tsWedDoor.openPolyOffset + fileOffset;
                // for each closed polygon
                for (int p = 0; p < tsWedDoor.closePolyCount; p++)
                {
                    door.closePoly[p] = GetGWEDPolygon(fileStream, polyBuff, vtBuff, vertOffset);
                }

                fileStream.Position = fpos;
            }

            #endregion Load doors
 
            #region Load walls

            // --- wall list --- //

            buff = new byte[FileStruct.TSWedWallSize];
            fileStream.Position = wedSecHead.wallOffset + fileOffset;

            ArrayList walls = new ArrayList();
            int sumPolyRef = 0;
            int totalPolyRef = (wedSecHead.verticeOffset - wedSecHead.wallPolyRefOffset) / 2;
            // totalpolyref = sum of each wall { wall[i].wallPolyRefCount }

            // since we don't know how many walls there are at the start, we use 
            // (sumPolyRef < totalPolyRef) as the stopping point
            while (sumPolyRef < totalPolyRef) 
            {
                FileStruct.TSWedWall tsWedWall =
                    (FileStruct.TSWedWall)ReadBuffer<FileStruct.TSWedWall>
                    (fileStream, buff, FileStruct.TSWedWallSize);

                ResourceClass.GWEDFile.WallStruct wall =
                    ResourceClass.GWEDFile.CreateWallStruct(ref tsWedWall);

                walls.Add(wall);

                long fpos = fileStream.Position;
                fileStream.Position = wedSecHead.wallPolyRefOffset +
                    (tsWedWall.wallPolyRefStart * 2) + fileOffset;
                                
                ushort[] polyRefs = new ushort[tsWedWall.wallPolyRefCount];
                byte[] polyRefBuff = new byte[tsWedWall.wallPolyRefCount * 2];
                fileStream.Read(polyRefBuff, 0, polyRefBuff.Length);
                Buffer.BlockCopy(polyRefBuff, 0, polyRefs, 0, polyRefBuff.Length);

                // for each wall 
                for (int p = 0; p < tsWedWall.wallPolyRefCount; p++)
                {
                    fileStream.Position = wedSecHead.wallPolyOffset +
                        (polyRefs[p] * FileStruct.TSWedPolygonSize) + fileOffset;
                    
                    wall.wallPoly[p] = GetGWEDPolygon(fileStream, polyBuff, vtBuff, vertOffset);
                }

                sumPolyRef += tsWedWall.wallPolyRefCount;

                fileStream.Position = fpos;
            }

            wedFile.wallList = (ResourceClass.GWEDFile.WallStruct[])
                walls.ToArray(typeof(ResourceClass.GWEDFile.WallStruct));

            #endregion Load walls

            fileStream.Close();

            return wedFile;
        }

        public static ResourceClass.IResource ReadGTISResourceFile(bool headerOnly, 
            ChitinKey ckey, FileStream fileStream, int fileOffset, int fileSize)
        {
            ResourceClass.GTISFile tisFile = new ResourceClass.GTISFile(ckey.name);

            #region Check file header

            buff = new byte[FileStruct.TSTisHeaderSize];
            fileStream.Position = fileOffset;

            FileStruct.TSTisHeader tisHead =
                 (FileStruct.TSTisHeader)ReadBuffer<FileStruct.TSTisHeader>
                 (fileStream, buff, FileStruct.TSTisHeaderSize);

            if (GlobalDefs.RES_GTIS_SIGNATURE == Utils.CharsToString(tisHead.signature))
            {
                tisFile.SetTisStream(fileStream, fileOffset + FileStruct.TSTisHeaderSize);
            }
            else
            {
                tisFile.SetTisStream(fileStream, fileOffset);
            }

            #endregion Check file header
            
            // Don't close filestream; fileStream.Close();
            return tisFile;
        }

    }
}
