using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI.Docking;
using InfinityXplorer.Core.ResourceControls;

namespace InfinityXplorer.Core
{
    internal static class ApplicationRuntime
    {
        private static ApplicationPaths appPaths;
        public static ApplicationPaths AppPaths
        {
            get { return appPaths; }
        }

        private static ApplicationParameters appParams;
        public static ApplicationParameters AppParams
        {
            get { return appParams; }
        }

        private static DockPanel dockPanel;
        public static DockPanel DockPanel
        {
            get { return dockPanel; }
        }

        private static FormWorkbench workbench;
        public static FormWorkbench Workbench
        {
            get { return workbench; }
        }

        private static IXExplorerDictionary explorers;
        public static IXExplorerDictionary Explorers
        {
            get { return explorers; }
        }

        private static ChitinIndex chitinIndex;
        public static ChitinIndex ChitinIndex
        {
            get { return chitinIndex; }
        }

        private static TalkIndex talkIndex;
        public static TalkIndex TalkIndex
        {
            get { return talkIndex; }
        }

        static ApplicationRuntime()
        {
            appPaths = new ApplicationPaths();
            appParams = new ApplicationParameters();

            ApplicationService.
                InitApplicationConfiguration(appPaths, appParams);

            InitializeInfinityFiles();
            InitializeCriticalControls();

            RichTextBoxLink.InitializeStaticPatterns();

        }

        private static void InitializeInfinityFiles()
        {
            chitinIndex = new ChitinIndex(appPaths.ChitinKeyFile);
            talkIndex = new TalkIndex(appPaths.TalkRefFile);
            
            explorers = new IXExplorerDictionary(chitinIndex.CkeyDictionary);
        }

        private static void InitializeCriticalControls()
        {
            dockPanel = CreateDockPanel(new DockPanel());
            workbench = new FormWorkbench(dockPanel);
            LoadDockPanel(dockPanel);
        }

        private static DockPanel CreateDockPanel(DockPanel dockPanel)
        {
            dockPanel.ActiveAutoHideContent = null;
            dockPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            dockPanel.Location = new System.Drawing.Point(0, 49);
            dockPanel.DocumentStyle = DocumentStyle.DockingMdi; 
            dockPanel.Name = "InfinityXplorerDockPanel";
            dockPanel.Size = new System.Drawing.Size(571, 245);
            dockPanel.TabIndex = 10;

            return dockPanel;
        }

        private static void LoadDockPanel(DockPanel dockPanel)
        {
            try
            {
                dockPanel.LoadFromXml(appPaths.DockingConfigFile,
                    new DeserializeDockContent(
                    ApplicationRuntime.GetContentFromPersistString));
            }
            catch (Exception)
            {
                // Sometimes docky config file craps up, so delete it and 
                // try to load a second time. if it fails then its due 
                // to something else.
                if (Utils.DeleteFile(appPaths.DockingConfigFile))
                {
                    dockPanel = CreateDockPanel(new DockPanel());
                    workbench.ReloadDockPanel(dockPanel);
                    dockPanel.LoadFromXml(appPaths.DockingConfigFile,
                        new DeserializeDockContent(
                        ApplicationRuntime.GetContentFromPersistString));
                }
            }
        }

        private static IDockContent GetContentFromPersistString(string persistString)
        {
            if (persistString == "")
            {
                return null; 
                // return new FormResource();
            }
            else
            {
                ResourceStruct.ResourceType rType =
                    ResourceStruct.ResourceFromCode(Convert.ToInt32(persistString));
                return explorers[rType].Form;
            }
        }

        public static void RunWorkbench()
        {
            Application.Run(workbench);
        }

    }
}
