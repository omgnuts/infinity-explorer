using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace InfinityXplorer.Core
{
    internal class FlagsBit
    {
        [Flags]
        public enum AreaBasic
        {
            Allow_Saves     = 0x01,
            Tutorial_Area   = 0x02,
            Dead_Magic_Zone = 0x04,
            Dream_Area      = 0x08
        }

        [Flags]
        public enum AreaBasicType
        {
            Outdoor_Area    = 0x01,
            Has_Day_Night   = 0x02,
            Has_Weather     = 0x04,
            City_Area       = 0x08,
            Forest_Area     = 0x10,
            Dungeon_Area    = 0x20,
            Extended_Night  = 0x40,
            Rest_Indoors    = 0x80,
        }

        [Flags]
        public enum TimeBlock
        {
            T0030_T0129 = 0x000001,
            T0130_T0229 = 0x000002,
            T0230_T0329 = 0x000004,
            T0330_T0429 = 0x000008,
            T0430_T0529 = 0x000010,
            T0530_T0629 = 0x000020,
            T0630_T0729 = 0x000040,
            T0730_T0829 = 0x000080,
            T0830_T0929 = 0x000100,
            T0930_T1029 = 0x000200,
            T1030_T1129 = 0x000400,
            T1130_T1229 = 0x000800,
            T1230_T1329 = 0x001000,
            T1330_T1429 = 0x002000,
            T1430_T1529 = 0x004000,
            T1530_T1629 = 0x008000,
            T1630_T1729 = 0x010000,
            T1730_T1829 = 0x020000,
            T1830_T1929 = 0x040000,
            T1930_T2029 = 0x080000,
            T2030_T2129 = 0x100000,
            T2130_T2229 = 0x200000,
            T2230_T2329 = 0x400000,
            T2330_T0029 = 0x800000
        }

        [Flags]
        public enum AreaActor
        {
            Has_CRE_File     = 0x01,
            Name_As_DeathVar = 0x08
        }
        
        [Flags]
        public enum AreaInfopt
        {
            Invisible_Trap   = 0x0001,
            Reset_Trap       = 0x0002,
            Party_Required   = 0x0004,
            Detectable_Trap  = 0x0008,
            //_Unknown5       = 0x0010,
            //_Unknown6       = 0x0020,
            NPC_Trigger      = 0x0040,
            //_Unknown8       = 0x0080,
            Is_Deactivated   = 0x0100,
            Not_Passable     = 0x0200,
            Alt_Point        = 0x0400,
            Used_By_Door     = 0x0800
            //_Unknown13-_Unknown16
        }
        
        [Flags]
        public enum AreaContainer
        {
            Locked      = 0x0001,
            //_Unknown2 = 0x0002,
            //_Unknown3 = 0x0004,
            Reset_Trap  = 0x0008,
            //_Unknown5 = 0x0010,
            Disabled    = 0x0020

        }

        [Flags]
        public enum AreaItem
        {
            IsIdentified = 0x0001,
            Unstealable  = 0x0002,
            IsStolen     = 0x0004,
            Undroppable  = 0x0008
        }   
    }
}
