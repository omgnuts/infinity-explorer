using System;
using System.Collections.Generic;
using System.Text;

namespace InfinityXplorer.Core
{
    internal static class Flags
    {
        public enum DirectionType
        {
            South       = 0,
            South_SW    = 1,
            South_West  = 2,
            West_SW     = 3,
            West        = 4,
            West_NW     = 5,
            North_West  = 6,
            North_NW    = 7,
            North       = 8,
            North_NE    = 9,
            North_East  = 10,
            East_NE     = 11,
            East        = 12,
            East_SE     = 13,
            South_East  = 14,
            South_SE    = 15
        }
        
        public enum AreaInfoptType
        {
            Proximity   = 0,
            Information = 1,
            Travel      = 2
        }

        public enum AreaContainerType
        {
            General     = 0,
            Bag         = 1,
            Chest       = 2,
            Drawer      = 3,
            Pile        = 4,
            Table       = 5,
            Shelf       = 6,
            Altar       = 7,
            Nonvisible  = 8,
            Spellbook   = 9,
            Body        = 10,
            Barrel      = 11,
            Crate       = 12
        }

    }
}
