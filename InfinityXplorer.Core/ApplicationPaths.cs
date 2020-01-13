using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core
{
    /// <summary>
    /// This class contains properties you can use to control how IE is launched
    /// </summary>
    [Serializable]
    internal sealed class ApplicationPaths
    {
        private string applicationRootPath;
        public string ApplicationRootPath
        {
            get { return applicationRootPath; }
        }

        private string dockingConfigFile = "DockPanel.config";
        public string DockingConfigFile
        {
            get { return dockingConfigFile; }
        }

        private string chitinKeyFile = "";
        public string ChitinKeyFile
        {
            get { return chitinKeyFile; }
        }

        private string talkRefFile = "";
        public string TalkRefFile
        {
            get { return talkRefFile; }
        }

        private string gameDirectory = "";
        public string GameDirectory
        {
            get { return gameDirectory; }
        }

        private string overrideDirectory = "";
        public string OverrideDirectory
        {
            get { return overrideDirectory; }
        }

        private string cacheDirectory = "";
        public string CacheDirectory
        {
            get { return cacheDirectory; }
        }

        private string[] cdPaths;
        public string[] CdPaths
        {
            get { return this.cdPaths; }
        }

        public ApplicationPaths()
        {
            applicationRootPath = Path.GetDirectoryName(Application.ExecutablePath);
            dockingConfigFile = Path.Combine(applicationRootPath, dockingConfigFile);

            gameDirectory = @"F:\Games.Mods\Program Files (x86)\Black Isle\BGII - SoA";
            gameDirectory = gameDirectory.ToUpper();

            chitinKeyFile = Path.Combine(gameDirectory, "chitin.key");
            talkRefFile = Path.Combine(gameDirectory, "dialog.tlk");

            overrideDirectory = Path.Combine(gameDirectory, "override");
            cacheDirectory = Path.Combine(gameDirectory, "cache");

            cdPaths = FileReader.ReadIniFileCDPaths(Path.Combine(gameDirectory, "baldur.ini"));
        }

    }
}
