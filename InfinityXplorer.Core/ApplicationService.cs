using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using ComponentAce.Compression.Libs.zlib;

namespace InfinityXplorer.Core
{
    // Application specific utility functions - try not to put into Utils.cs
    internal static class ApplicationService
    {
        public static void InitApplicationConfiguration(ApplicationPaths appPaths, ApplicationParameters appParams)
        {
            // Class to initialize XML file if necessary
        }

        public static string FindOverrideFile(string keyName, ResourceStruct.ResourceType resourceType)
        {
            // First try the override File
            string overrideFile = Path.Combine(ApplicationRuntime.AppPaths.OverrideDirectory, 
                keyName + "." + ResourceStruct.ResourceFileExt(resourceType));

            if (File.Exists(overrideFile))
            {
                return overrideFile.ToUpper();
            }
            else
            {
                return null;
            }
        }
        
        public static FileStream FindBiffFile(ChitinBiff cbiff)
        {
            // First try BG2\Cache - if found it will be generally uncompressed, but just CheckBIFC anyway 
            string biffFile = Path.Combine(ApplicationRuntime.AppPaths.CacheDirectory, cbiff.name);
            if (File.Exists(biffFile)) return CheckBIFC(biffFile, cbiff.name);

            // Next try BG2\Data
            biffFile = Path.Combine(ApplicationRuntime.AppPaths.GameDirectory, cbiff.name);
            if (File.Exists(biffFile)) return CheckBIFC(biffFile, cbiff.name);

            // Next try the cds
            string[] cdPaths = ApplicationRuntime.AppPaths.CdPaths;
            
            for (int c = 0; c < cdPaths.Length; c++)
            {
                if ((cbiff.cdMask & (1 << (c + 2))) != 0)
                {
                    biffFile = Path.Combine(cdPaths[c], cbiff.name);
                    if (File.Exists(biffFile)) return CheckBIFC(biffFile, cbiff.name);
                }
            }

            return null;
        }
        
        private static FileStream CheckBIFC(string biffFile, string outFile)
        {
            FileStream fileStream = Utils.ReadFileStream(biffFile);

            if (fileStream == null) return null;

            string str = FileReader.ReadOffsetStringHeader(fileStream, 8);
            if (GlobalDefs.CHITINBIFC_SIGNATURE != str)
            {
                // no decompression required
                return fileStream;
            }

            // decompression required.
            outFile = Path.Combine(ApplicationRuntime.AppPaths.CacheDirectory, outFile);
            return DecompressBIFC(fileStream, outFile);
        }

        #region ZLib Utilities
        
        private static FileStream DecompressBIFC(FileStream inStream, string outFile)
        {
            ApplicationRuntime.Workbench.StatusBuffer = "Extracting " + outFile + " for the first time...";

            FileStream outFileStream = Utils.MakeFileStream(outFile);
            ZOutputStream outZStream = new ZOutputStream(outFileStream);

            try
            {
                inStream.Position = FileStruct.TSBifcHeaderSize;

                byte[] bint = new byte[8];
                byte[] buff;

                while (inStream.Position < inStream.Length)
                {
                    inStream.Read(bint, 0, 8);
                    int compSize = BitConverter.ToInt32(bint, 4);

                    buff = new byte[compSize];
                    inStream.Read(buff, 0, compSize);

                    outZStream.Write(buff, 0, compSize);
                }

                outZStream.Flush();
            }
            catch (Exception)
            {
                return null;
            }
            finally
            {
                inStream.Close();
                outZStream.Close();
                outFileStream.Close();
            }

            ApplicationRuntime.Workbench.StatusBuffer = null;

            return Utils.ReadFileStream(outFile);
        }

        //private static void compressFile(string inFile, string outFile)
        //{
        //    System.IO.FileStream outFileStream = new System.IO.FileStream(outFile, System.IO.FileMode.Create);
        //    zlib.ZOutputStream outZStream = new zlib.ZOutputStream(outFileStream, zlib.zlibConst.Z_DEFAULT_COMPRESSION);
        //    System.IO.FileStream inFileStream = new System.IO.FileStream(inFile, System.IO.FileMode.Open);
        //    try
        //    {
        //        CopyStream(inFileStream, outZStream);
        //    }
        //    finally
        //    {
        //        outZStream.Close();
        //        outFileStream.Close();
        //        inFileStream.Close();
        //    }
        //}

        #endregion ZLib Utilities
    }

}
