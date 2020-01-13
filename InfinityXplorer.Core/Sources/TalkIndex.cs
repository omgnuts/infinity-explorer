using System;
using System.Collections.Generic;
using System.Text;

namespace InfinityXplorer.Core
{
    // not using struct here because may need to set null
    internal class TalkRef
    {
        public ushort tag;
        public string soundResource;
        public int volume;
        public int pitch;
        public string strText;
    }

    internal class TalkIndex
    {
        private string talkFile;

        private TalkRefCollection trefCollection;
        public TalkRefCollection TrefCollection
        {
            get { return this.trefCollection; }
        }

        private static TalkRef CreateTalkRef(ref FileStruct.TSTalkRef tsTalkRef, ref string strText)
        {
            TalkRef tref = new TalkRef();
            tref.tag = tsTalkRef.tag;
            tref.soundResource = Utils.CharsToString(tsTalkRef.soundResource).ToUpper();
            tref.volume = tsTalkRef.volume;
            tref.pitch = tsTalkRef.pitch;
            tref.strText = strText;

            return tref;
        }

        public void AddTalkRef(ref FileStruct.TSTalkRef tsTalkRef, ref string strText)
        {
            TalkRef tref = CreateTalkRef(ref tsTalkRef, ref strText);
            this.trefCollection.Add(tref);
        }

        public TalkIndex(string talkFile)
        {
            this.talkFile = talkFile;
            this.trefCollection = new TalkRefCollection();

            this.RefreshTalkIndex(this.talkFile);
        }

        private void RefreshTalkIndex(string talkFile)
        {
            this.talkFile = talkFile;
            this.LoadTalkIndex(this.talkFile);
        }

        private void LoadTalkIndex(string fileName)
        {
            // Read the talkref file.
            FileReader.ReadTalkRefFile(this, fileName);

        }


    }
}
