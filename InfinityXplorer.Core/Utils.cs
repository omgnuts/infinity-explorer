using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;

namespace InfinityXplorer.Core
{
    internal static class Utils
    {
        private readonly static char[] trimClean = { '\0', '|' };
        private readonly static char[] separators = { Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar, Path.VolumeSeparatorChar };

        public readonly static Encoding Encodi = Encoding.ASCII;

        // EnUnicode only for XML writing. Never use it elsewhere. Weidu cannot read Unicode
        private readonly static Encoding EnUnicode = Encoding.Unicode;

        #region Conversion Utilities
        public static string CharsToString(char[] chars)
        {
            return new string(chars).TrimEnd(trimClean);
        }

        #endregion

        #region File Utilities

        public static bool CreateDirectory(string fileDirectory)
        {
            try
            {
                if (!Directory.Exists(fileDirectory))
                {
                    Directory.CreateDirectory(fileDirectory);
                }
            }
            catch (Exception)
            {
                return false;
            }

            return true;

        }

        public static bool DeleteFile(string fileName)
        {
            if (File.Exists(fileName))
            {
                try 
                {
                    File.Delete(fileName);
                }
                catch (Exception)
                {
                    return false;
                }
            }

            return true;

        }

        public static bool WriteToStream(StringBuilder sb, string fileName)
        {
            return WriteToStream(sb, fileName, Encoding.ASCII);
        }

        public static bool WriteToStream(StringBuilder sb, string fileName, Encoding encode)
        {
            try
            {
                string fileDirectory = Path.GetDirectoryName(fileName);
                if (!Directory.Exists(fileDirectory))
                {
                    Directory.CreateDirectory(fileDirectory);
                }

                using (StreamWriter sw = new StreamWriter(fileName, false, encode))
                {
                    sw.Write(sb.ToString());
                    sw.Close();
                    return true;
                }

            }
            catch (Exception)
            {
                return false;
            }

        }

        public static StringBuilder ReadFromStream(string fileName)
        {
            return ReadFromStream(fileName, Utils.Encodi);
        }

        public static StringBuilder ReadFromStream(string fileName, Encoding encode)
        {
            try
            {
                //string fileDirectory = Path.GetDirectoryName(fileName);
                if (!File.Exists(fileName))
                {
                    return null;
                }

                using (StreamReader sr = new StreamReader(fileName, encode))
                {
                    StringBuilder sb = new StringBuilder(sr.ReadToEnd());
                    sr.Close();
                    return sb;
                }
            }
            catch (Exception)
            {
                return null;
            }

        }

        public static FileStream ReadFileStream(string fileName)
        {
            try
            {
                //string fileDirectory = Path.GetDirectoryName(fileName);
                if (!File.Exists(fileName))
                {
                    return null;
                }

                return new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

            }
            catch (Exception)
            {
                return null;
            }

        }

        public static FileStream MakeFileStream(string fileName)
        {
            try
            {
                return new FileStream(fileName, FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite);
            }
            catch (Exception)
            {
                return null;
            }

        }

        // Just to get the relative filename without the filepath
        public static string GetRelativeFileName(string absFile, string basePath)
        {
            try
            {
                basePath = Path.GetFullPath(basePath.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));
                absFile = Path.GetFullPath(absFile);
            }
            catch (Exception e)
            {
                throw new ArgumentException("GetRelativePath error '" + basePath + "' -> '" + absFile + "'", e);
            }

            string[] bPath = basePath.Split(separators);
            string[] aPath = absFile.Split(separators);

            int c = 0;
            for (; c < Math.Min(bPath.Length, aPath.Length); ++c)
            {
                if (!bPath[c].Equals(aPath[c], StringComparison.OrdinalIgnoreCase))
                    break;
            }

            if (c == 0)
            {
                return absFile;
            }

            StringBuilder erg = new StringBuilder();

            if (c == bPath.Length)
            {
                //				erg.Append('.');
                //				erg.Append(Path.DirectorySeparatorChar);
            }
            else
            {
                for (int i = c; i < bPath.Length; ++i)
                {
                    erg.Append("..");
                    erg.Append(Path.DirectorySeparatorChar);
                }
            }

            erg.Append(String.Join(Path.DirectorySeparatorChar.ToString(), aPath, c, aPath.Length - c));

            return erg.ToString();

        }

        #endregion File Utilities

        #region Graphic Utilities

        public static Bitmap BrightenLayer24bpp(Bitmap b, int brightChange)
        {
            // GDI+ return format is BGR, NOT RGB. 
            BitmapData data = b.LockBits(new Rectangle(0, 0, b.Width, b.Height),
                ImageLockMode.ReadWrite, b.PixelFormat);

            int height = b.Height;
            int width = b.Width * 3;
            int offset = data.Stride - b.Width * 3;

            unsafe
            {
                int val;
                byte* ptr = (byte*)(data.Scan0);

                for (int row = 0; row < height; row++)
                {
                    for (int col = 0; col < width; col++)
                    {
                        val = (int)(*ptr + brightChange);
                        if (val < 0) { val = 0; }
                        else if (val > 255) { val = 255; }
                        *ptr = (byte)val; ptr++;
                    }

                    ptr += offset;
                }
            }

            b.UnlockBits(data);
            return b;
        }

        #endregion Graphic Utilities

    }
    
    //public class FileSearch {
    //    ArrayList _extensions;
    //    bool _recursive;
    //    public ArrayList SearchExtensions {
    //        get { return _extensions; }
    //    }
    //    public bool Recursive {
    //        get{return _recursive;}
    //        set{_recursive = value;}
    //    }
    //    public FileSearch(){
    //        _extensions = ArrayList.Synchronized(new ArrayList());
    //        _recursive = true;
    //    }
    //    public FileInfo[] Search(string path) {   
    //        DirectoryInfo root = new DirectoryInfo(path);
    //        ArrayList subFiles = new ArrayList();
    //        foreach(FileInfo file in root.GetFiles()) {
    //            if(_extensions.Contains( file.Extension )) {
    //                subFiles.Add(file);
    //            }
    //        }
    //        if(_recursive) {
    //            foreach(DirectoryInfo directory in root.GetDirectories()) {
    //                subFiles.AddRange( Search(directory.FullName) );
    //            }
    //        }
    //        return (FileInfo[])subFiles.ToArray(typeof(FileInfo));
    //    }
    //}

    //FileSearch searcher = new FileSearch();
    //searcher.SearchExtensions.Add(".dll");
    //searcher.SearchExtensions.AddRange( new string[] {".txt", ".asp", ".exe"} );

    //FileInfo[] files = searcher.Search("C:\\");

}

