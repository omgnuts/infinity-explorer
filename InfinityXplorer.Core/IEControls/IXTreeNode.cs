using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core
{
    internal class IXTreeNode : TreeNode
    {
        private ChitinKey ckey;
        public ChitinKey Ckey
        {
            get { return this.ckey; }
        }

        public IXTreeNode(string name, ChitinKey ckey)
            : base (name)
        {
            this.ckey = ckey;
            this.InitTreeNode();
        }

        private void InitTreeNode()
        {            
            //this.ImageIndex = (int)FormSolutionExplorer.ImageIndex.ProjectOn;
            //this.SelectedImageIndex = (int)FormSolutionExplorer.ImageIndex.ProjectOff;

        }

        public static void LoadResource(ChitinKey ckey, bool closeResourceOnError)
        {
            ResourceStruct.ResInfo rInfo = 
                ResourceStruct.OrderedListNames[ckey.resourceType];
            ResourceClass.IResource irFile = 
                ResourceHandler.LoadResourceFile(ckey, rInfo.resourceFileReader);

            if (irFile != null)
            {
                // send the irFile into explorer
                IXExplorer explorer = ApplicationRuntime.Explorers[ckey.resourceType];
                if (!explorer.ShowViewer(rInfo.ViewUserControl, ckey, irFile, closeResourceOnError))
                {
                    MessageBox.Show("Error: Unable to load resource '" + ckey.name + "'!");
                }

            }
        }

        public static void SelectNode(ChitinKey ckey)
        {
            string overrideFile =
                ApplicationService.FindOverrideFile(ckey.name, ckey.resourceType);

            if (overrideFile != null)
            {
                ApplicationRuntime.Workbench.StatusTSSL.Text = overrideFile;
            }
            else
            {
                ApplicationRuntime.Workbench.StatusTSSL.Text = 
                    Path.Combine(ApplicationRuntime.AppPaths.GameDirectory,                    
                    ApplicationRuntime.ChitinIndex.CbiffCollection[ckey.biffIndex].name);
            }
        }

    }
}
