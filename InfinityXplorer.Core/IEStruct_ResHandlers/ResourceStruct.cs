using System;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using System.Text;
using System.Windows.Forms;
using InfinityXplorer.Core.ResourceControls;

namespace InfinityXplorer.Core
{
    internal static class Delegates // temp only - need to throw this away later
    {
        public static ResourceClass.IResource ReadResourceFile(bool headerOnly, 
            ChitinKey ckey, FileStream fileStream, int fileOffset, int fileSize)
        {
            System.Windows.Forms.MessageBox.Show(ckey.name);
            return null;
        }

    }

    internal static class ResourceStruct
    {
        // Use an enumeration to represent the three types of nodes.
        // Specific numbers correspond to the database field code.
        public enum ResourceType
        {
            // Quests / Game Scripts
            RTypeQARE = 0x3F2,  // Area Files
            RTypeQCRE = 0x3F1,  // Creature Files
            RTypeQDLG = 0x3F3,  // Dialog Files
            RTypeQITM = 0x3ED,  // Item Files
            RTypeQBCS = 0x3EF,  // BCS Scripts
            RTypeQBSX = 0x3F9,  // BS Scripts
            RTypeQSTO = 0x3F6,  // Shopkeeper files
            RTypeQWMP = 0x3F7,  // Worldmap files
            RTypeQINI = 0x802,  // focused on storing things like quest information and respawn information
            RTypeQSRC = 0x803,  // Text that appears over people's heads

            // Graphics
            RTypeGBAM = 0x3E8,  // BAM Graphics
            RTypeGBMP = 0x001,  // BMP Graphics
            RTypeGMOS = 0x3EC,  // MOS Graphics
            RTypeGEFF = 0x3F8,  // Spell Effects
            RTypeGPLT = 0x006,  // Paper dolls
            RTypeGPRO = 0x3FD,  // Description of 'projectile' types
            RTypeGTIS = 0x3EB,  // Map Tiles
            RTypeGWED = 0x3E9,  // Polygons
            RTypeGVVC = 0x3FB,  // Visual 'spell casting' effects 
            RTypeGVEF = 0x3FC,  // Visual effects (possibly OpenGL effects?)

            // Rules
            RTypeR2DA = 0x3F4,  // Rule Files
            RTypeRIDS = 0x3F0,  // IDS Index
            RTypeRSPL = 0x3EE,  // Spells
            RTypeRCHU = 0x3EA,  // Graphical User Interface

            // Music / Movies
            RTypeMMVE = 0x002,  // Movies
            RTypeMWAV = 0x004,  // Wave format
            RTypeMWFX = 0x005,  // ## Unknown sound format
            RTypeMACM = 0x901,  // ## ACM Music (no resource code?)
            RTypeMMUS = 0x902,  // ## MUS Music (no resource code?)

            // Play            
            RTypePCHR = 0x3FA,  // Saved Character
            RTypePGAM = 0x3F5,  // Saved Games
            RTypePBIO = 0x3FE,  // Stores the edited biography of characters.

            // Unknown type
            RTypeNBAX = 0x44C,  // ## Unknown ?? 
            RTypeNULL = 0x000   // ## Null (no resource code)
                     
        }

        public delegate ResourceClass.IResource
            DelegateResourceFileReader(bool headerOnly, 
            ChitinKey ckey, FileStream fileStream, int fileOffset, int fileSize);

        public class ResInfo
        {
            public string name;
            public bool isCommon;

            protected Type viewUserControlType;
            private IUserControl viewUserControl;
            public IUserControl ViewUserControl
            {
                get
                {
                    if (viewUserControl == null)
                    {
                        viewUserControl
                            = (IUserControl)Activator.CreateInstance(viewUserControlType);
                    }
                    return viewUserControl;
                }
            }

            protected Type editUserControlType;
            private IUserControl editUserControl;
            public IUserControl EditUserControl
            {
                get
                {
                    if (editUserControl == null)
                    {
                        editUserControl
                            = (IUserControl)Activator.CreateInstance(editUserControlType);
                    }
                    return editUserControl;
                }
            }

            public DelegateResourceFileReader resourceFileReader;

            public ResInfo(string name, bool isCommon,
                Type viewUserControl, Type editUserControl,
                DelegateResourceFileReader resourceFileReader)
            {
                this.name = name;
                this.isCommon = isCommon;
                this.viewUserControlType = viewUserControl;
                this.editUserControlType = editUserControl;
                this.resourceFileReader = new DelegateResourceFileReader(resourceFileReader);
            }
        }

        private static ResInfo BuildRes(string name, bool isCommon)
        {
            return new ResInfo(name, isCommon, typeof(QBCSViewer), typeof(QBCSViewer), Delegates.ReadResourceFile);
        }

        private static ResInfo BuildRes(string name, bool isCommon,
            DelegateResourceFileReader resourceFileReader) // temp
        {
            return new ResInfo(name, isCommon, typeof(QBCSViewer), typeof(QBCSViewer), resourceFileReader);
        }
        
        private static ResInfo BuildRes(string name, bool isCommon,
            Type viewUserControl, Type editUserControl,
            DelegateResourceFileReader resourceFileReader)
        {
            return new ResInfo(name, isCommon, viewUserControl, editUserControl, resourceFileReader);
        }

        // OrderedList gives more flexibility in displaying the resource types
        // Rather than just sort alphabetically etc. It is really only used 
        // for display purposes, and is independent of Enum ordering
        private static Dictionary<ResourceType, ResInfo> olist;
        public static Dictionary<ResourceType, ResInfo> OrderedListNames
        {
            get
            {
                #region build olist
                if (olist == null)
                {
                    olist = new Dictionary<ResourceType, ResInfo>();

                    olist.Add(ResourceType.RTypeQARE, BuildRes("[Q] ARE Files", true, typeof(QAREViewer), typeof(QAREViewer), FileReader.ReadQAREResourceFile)); // Area Maps
                    olist.Add(ResourceType.RTypeQBCS, BuildRes("[Q] BCS Files", true)); // BCS Scripts
                    olist.Add(ResourceType.RTypeQBSX, BuildRes("[Q] BS  Files", true)); // BS Scripts
                    olist.Add(ResourceType.RTypeQCRE, BuildRes("[Q] CRE Files", true)); // Creatures
                    olist.Add(ResourceType.RTypeQDLG, BuildRes("[Q] DLG Files", true, typeof(QDLGViewer), typeof(QDLGViewer), FileReader.ReadQDLGResourceFile)); // Dialogues
                    olist.Add(ResourceType.RTypeQITM, BuildRes("[Q] ITM Files", true)); // Item Files
                    olist.Add(ResourceType.RTypeQINI, BuildRes("[Q] INI Files", false)); // Ini Files
                    olist.Add(ResourceType.RTypeQSRC, BuildRes("[Q] SRC Files", false)); // Src Files
                    olist.Add(ResourceType.RTypeQSTO, BuildRes("[Q] STO Files", false)); // GameStores
                    olist.Add(ResourceType.RTypeQWMP, BuildRes("[Q] WMP Files", false)); // Worldmaps

                    olist.Add(ResourceType.RTypeGBAM, BuildRes("[G] BAM Files", false)); // Animation Files
                    olist.Add(ResourceType.RTypeGBMP, BuildRes("[G] BMP Files", false)); // Bitmap Files
                    olist.Add(ResourceType.RTypeGEFF, BuildRes("[G] EFF Files", false)); // Eff Files
                    olist.Add(ResourceType.RTypeGMOS, BuildRes("[G] MOS Files", false)); // Mos Files
                    olist.Add(ResourceType.RTypeGPLT, BuildRes("[G] PLT Files", false)); // Paper Dolls
                    olist.Add(ResourceType.RTypeGPRO, BuildRes("[G] PRO Files", false)); // ?? files
                    olist.Add(ResourceType.RTypeGTIS, BuildRes("[G] TIS Files", false, FileReader.ReadGTISResourceFile)); // Map Tiles
                    olist.Add(ResourceType.RTypeGVEF, BuildRes("[G] VEF Files", false)); // ?? files
                    olist.Add(ResourceType.RTypeGVVC, BuildRes("[G] VVC Files", false)); // ?? files
                    olist.Add(ResourceType.RTypeGWED, BuildRes("[G] WED Files", false, FileReader.ReadGWEDResourceFile)); // Polygons

                    olist.Add(ResourceType.RTypeR2DA, BuildRes("[R] 2DA Files", true)); // 2da Files
                    olist.Add(ResourceType.RTypeRCHU, BuildRes("[R] CHU Files", false)); // Game GUI
                    olist.Add(ResourceType.RTypeRIDS, BuildRes("[R] IDS Files", true)); // Ids Files
                    olist.Add(ResourceType.RTypeRSPL, BuildRes("[R] SPL Files", false)); // Spl Files

                    olist.Add(ResourceType.RTypeMACM, BuildRes("[M] ACM Files", false)); // Acm Files
                    olist.Add(ResourceType.RTypeMMUS, BuildRes("[M] MUS Files", false)); // Mus Files
                    olist.Add(ResourceType.RTypeMMVE, BuildRes("[M] MVE Files", false)); // Mve Files
                    olist.Add(ResourceType.RTypeMWAV, BuildRes("[M] WAV Files", false)); // Wav Files
                    olist.Add(ResourceType.RTypeMWFX, BuildRes("[M] WFX Files", false)); // Wfx Files

                    olist.Add(ResourceType.RTypePBIO, BuildRes("[P] BIO Files", false)); // Bio Files
                    olist.Add(ResourceType.RTypePCHR, BuildRes("[P] CHR Files", false)); // Chr Files
                    olist.Add(ResourceType.RTypePGAM, BuildRes("[P] GAM Files", false)); // Gam Files

                    olist.Add(ResourceType.RTypeNBAX, BuildRes("[O] BAX Files", false)); // ?? Bax Files
                    olist.Add(ResourceType.RTypeNULL, BuildRes("[O] UNKNOWN FORMATS", false)); // Null files
                }
                #endregion build olist
                return olist;
            }
        }

        // extension conversions from override directory
        private static Dictionary<string, ResourceType> fext;
        public static Dictionary<string, ResourceType> FileExtensions
        {
            get
            {
                #region build fileExtensions
                if (fext == null)
                {
                    fext = new Dictionary<string, ResourceType>();

                    fext.Add("ARE", ResourceType.RTypeQARE);
                    fext.Add("CRE", ResourceType.RTypeQCRE);
                    fext.Add("DLG", ResourceType.RTypeQDLG);
                    fext.Add("ITM", ResourceType.RTypeQITM);
                    fext.Add("BCS", ResourceType.RTypeQBCS);
                    fext.Add("BS",  ResourceType.RTypeQBSX);
                    fext.Add("WMP", ResourceType.RTypeQWMP);
                    fext.Add("STO", ResourceType.RTypeQSTO);
                    fext.Add("INI", ResourceType.RTypeQINI);
                    fext.Add("SRC", ResourceType.RTypeQSRC);

                    fext.Add("BAM", ResourceType.RTypeGBAM);
                    fext.Add("BMP", ResourceType.RTypeGBMP);
                    fext.Add("MOS", ResourceType.RTypeGMOS);
                    fext.Add("EFF", ResourceType.RTypeGEFF);
                    fext.Add("PLT", ResourceType.RTypeGPLT);
                    fext.Add("PRO", ResourceType.RTypeGPRO);
                    fext.Add("TIS", ResourceType.RTypeGTIS);
                    fext.Add("WED", ResourceType.RTypeGWED);
                    fext.Add("VVC", ResourceType.RTypeGVVC);
                    fext.Add("VEF", ResourceType.RTypeGVEF);

                    fext.Add("BAMC", ResourceType.RTypeGBAM); // compressed BAM files
                    fext.Add("MOSC", ResourceType.RTypeGMOS); // compressed MOS files

                    fext.Add("2DA", ResourceType.RTypeR2DA);
                    fext.Add("IDS", ResourceType.RTypeRIDS);
                    fext.Add("SPL", ResourceType.RTypeRSPL);
                    fext.Add("CHU", ResourceType.RTypeRCHU);

                    fext.Add("MVE", ResourceType.RTypeMMVE);
                    fext.Add("WAV", ResourceType.RTypeMWAV);
                    fext.Add("WFX", ResourceType.RTypeMWFX);
                    fext.Add("ACM", ResourceType.RTypeMACM);
                    fext.Add("MUS", ResourceType.RTypeMMUS);

                    fext.Add("WAC", ResourceType.RTypeRSPL); // compressed WAV files

                    fext.Add("CHR", ResourceType.RTypePCHR);
                    fext.Add("GAM", ResourceType.RTypePGAM);
                    fext.Add("BIO", ResourceType.RTypePBIO);

                    fext.Add("BA", ResourceType.RTypeNBAX);

                }
                #endregion build fileExtensions
                return fext;
            }
        }

        public static ResourceType ResourceFromCode(int code)
        {
            return (ResourceType)code;
        }

        public static int ResourceToCode(ResourceType resourceType)
        {
            // Cannot do a simple (int) cast for this case since resourceType is a bit diff
            // from the usual enum
            return resourceType.GetHashCode();
        }

        public static string ResourceFileExt(ResourceType resourceType)
        {
            // using a foreach here is ok & not too slow, because this function is only
            // called when a resource tree node is set focused.
            foreach (KeyValuePair<string, ResourceType>kvp in FileExtensions)
            {
                if (kvp.Value == resourceType) return kvp.Key;
            }

            return "";
        }

        

    }
}
