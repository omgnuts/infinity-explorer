using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI;

namespace InfinityXplorer.Core
{
    partial class FormWorkbench
    {
        private void FormWorkbench_FormClosing(object sender, FormClosingEventArgs e)
        {
            dockPanel.SaveAsXml(ApplicationRuntime.AppPaths.DockingConfigFile);
        }

        private void showCommonTSMI_Click(object sender, EventArgs e)
        {
            IXExplorerDictionary explorers = ApplicationRuntime.Explorers;
            foreach (KeyValuePair<ResourceStruct.ResourceType, ResourceStruct.ResInfo> kvp
                in ResourceStruct.OrderedListNames)
            {
                if (kvp.Value.isCommon)
                {
                    explorers[kvp.Key].Form.Show(dockPanel);
                }
            }
        }

        private void ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            IXExplorer explorer = (IXExplorer)((ToolStripMenuItem)sender).Tag;

            this.StatusBuffer = "Loading " + explorer.Name + " ...";
            explorer.Form.Show(dockPanel);
            this.StatusBuffer = null;

        }


    }
}
