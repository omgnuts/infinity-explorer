using System;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using System.Text;

namespace InfinityXplorer.Core
{
    /// The consolidated index of Chitin.key + Pseudo indexes outside of chitin.key 
    /// Eg. files in override directory
    /// 
    /// There should be only a single instance of this object during the entire scope
    /// Can consider making it static eventually, unless you want to do file compares.

    // not using struct here because may need to set null
    internal class ChitinBiff
    {
        public struct BiffFileStruct
        {
            // ushort ckeyIndex - Resource locator
            public int offset;
            public int size;
            // ResourceStruct.ResourceType resourceType
            // Unknown
        }
        public struct BiffTileStruct
        {
            // ushort tileIndex - Resource locator
            public int tileOffset;
            public int tileCount;
            public int tileSize;
            // ResourceStruct.ResourceType resourceType
            // Unknown
        }

        public string name;
        public int size;
        public ushort cdMask; // biff cd mask - basically to find which cd you're in

        public BiffFileStruct[] fileList;
        public BiffTileStruct[] tileList;

        public static BiffFileStruct CreateBiffFileStruct(FileStruct.TSBiffFileset tsBiffFileset)
        {
            BiffFileStruct bfs = new BiffFileStruct();
            bfs.offset = tsBiffFileset.fileOffset;
            bfs.size = tsBiffFileset.fileSize;
            return bfs;
        }
        public static BiffTileStruct CreateBiffTileStruct(FileStruct.TSBiffTileset tsBiffTileset)
        {
            BiffTileStruct bts = new BiffTileStruct();
            bts.tileOffset = tsBiffTileset.tileOffset;
            bts.tileSize = tsBiffTileset.tileSize;
            bts.tileCount = tsBiffTileset.tileCount;
            return bts;
        }

    }

    // not using struct here because may need to set null
    internal class ChitinKey
    {
        public string name;
        public ResourceStruct.ResourceType resourceType;
        public ushort biffIndex;// biff index
        public ushort ckeyIndex;// ckey index for normal files
        public ushort tileIndex; // map index for Tile files
        public bool isBiffed;   // To check if inBiff or override
        public IXTreeNode node; // To access the treenode directly
    }

    // using this to handle chitinkey queries. made up of real ck & fake override ck
    internal class ChitinIndex
    {
        private string chitinFile;
        private readonly static int keyLength = 8;
        
        private ChitinKeySuperDictionary ckeyDictionary;
        public ChitinKeySuperDictionary CkeyDictionary
        {
            get { return this.ckeyDictionary; }
        }

        private ChitinBiffCollection cbiffCollection;
        public ChitinBiffCollection CbiffCollection
        {
            get { return this.cbiffCollection; }
        }

        public static ChitinBiff CreateChitinBiff(ref FileStruct.TSChitinBiff tsChitinBiff, ref string name)
        {
            ChitinBiff cbiff = new ChitinBiff();
            cbiff.name = name.ToUpper();
            cbiff.size = tsChitinBiff.biffSize;
            cbiff.cdMask = tsChitinBiff.biffCdMask;

            return cbiff;
        }
        private static ChitinKey CreateChitinKey(ref FileStruct.TSChitinKey tsChitinKey)
        {
            ChitinKey ckey = new ChitinKey();
            ckey.name = Utils.CharsToString(tsChitinKey.ckeyName).ToUpper();

            if (ckey.name == "") return null;

            ckey.resourceType = ResourceStruct.ResourceFromCode(tsChitinKey.ckeyType);
            ckey.ckeyIndex = (ushort)(tsChitinKey.ckeyIndex & 0x3FFF);
            ckey.tileIndex = (ushort)(((tsChitinKey.ckeyIndex >> 14) | ((tsChitinKey.biffIndex & 0x0F) << 2)) - 1);
            ckey.biffIndex = (ushort)(tsChitinKey.biffIndex >> 4);
            ckey.isBiffed = true;

            return ckey;
        } // false for override

        private static ChitinKey CreateChitinKey(string name, 
            ResourceStruct.ResourceType resourceType)
        {
            ChitinKey ckey = new ChitinKey();
            ckey.name = name.ToUpper();

            ckey.resourceType = resourceType;
            ckey.ckeyIndex = 0;
            ckey.tileIndex = 0;
            ckey.biffIndex = 0;
            ckey.isBiffed = false;

            return ckey;
        }

        public void AddChitinKey(ref FileStruct.TSChitinKey tsChitinKey)
        {
            ChitinKey ckey = CreateChitinKey(ref tsChitinKey);
            if (ckey != null)
            {
                this.ckeyDictionary.Add(ckey.name, ckey, ckey.resourceType);
            }
        }

        public void AddChitinBiff(ref FileStruct.TSChitinBiff tsChitinBiff, ref string name)
        {
            ChitinBiff cbiff = CreateChitinBiff(ref tsChitinBiff, ref name);
            cbiffCollection.Add(cbiff);
        }

        public ChitinIndex(string chitinFile)
        {
            this.chitinFile = chitinFile;

            this.ckeyDictionary = new ChitinKeySuperDictionary(keyLength);
            this.cbiffCollection = new ChitinBiffCollection();

            this.RefreshChitinIndex(this.chitinFile);
        }

        private void RefreshChitinIndex(string chitinFile)
        {
            this.chitinFile = chitinFile;
            this.LoadChitinIndex(this.chitinFile);
        }

        private void LoadChitinIndex(string fileName)
        {
            this.ckeyDictionary.Clear();
            this.cbiffCollection.Clear();

            // Read the chitinkey file.
            FileReader.ReadChitinKeyFile(this, fileName);

            // Parse the override directory.
            this.ParseOverrideDirectory(ApplicationRuntime.AppPaths.OverrideDirectory);
        }

        private void ParseOverrideDirectory(string overrideDirectory)
        {
            DirectoryInfo dir = new DirectoryInfo(overrideDirectory);

            foreach (KeyValuePair<string, ResourceStruct.ResourceType> kvp 
                in ResourceStruct.FileExtensions)
            {
                ChitinKeyDictionary ckdict = ckeyDictionary[kvp.Value];
                FileInfo[] files = dir.GetFiles("*." + kvp.Key);
                foreach (FileInfo file in files)
                {
                    string s = file.Name.Split('.')[0];
                    ChitinKey ckey = CreateChitinKey(s, kvp.Value);
                    ckdict.AddCheckContain(ckey.name, ckey);
                }
            }

        }

    }
}
