using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace InfinityXplorer.Core
{
    internal class XORStream
    {
        private static readonly byte[] XORKeys = new byte[] {
            0x88,0xA8,0x8F,0xBA,0x8A,0xD3,0xB9,0xF5,0xED,0xB1,0xCF,0xEA,0xAA,
            0xE4,0xB5,0xFB,0xEB,0x82,0xF9,0x90,0xCA,0xC9,0xB5,0xE7,0xDC,0x8E,
            0xB7,0xAC,0xEE,0xF7,0xE0,0xCA,0x8E,0xEA,0xCA,0x80,0xCE,0xC5,0xAD,
            0xB7,0xC4,0xD0,0x84,0x93,0xD5,0xF0,0xEB,0xC8,0xB4,0x9D,0xCC,0xAF,
            0xA5,0x95,0xBA,0x99,0x87,0xD2,0x9D,0xE3,0x91,0xBA,0x90,0xCA
        };

        private static readonly int XORSize = XORKeys.Length;

        public int Read(byte[] array, int offset, int count)
        {
            // return base.Read(array, offset, count);
            return 0;
            
              //StartPos := Position mod KeyLen;
              //Result := inherited Read (Buffer, Count);
              //P := PByte (@Buffer);
              //for i := 0 to Count-1 do begin
              //  P^ := P^ xor FDecryptKey [(StartPos + i) mod KeyLen];
              //  Inc (P);
              //end;

        }

    }
}
