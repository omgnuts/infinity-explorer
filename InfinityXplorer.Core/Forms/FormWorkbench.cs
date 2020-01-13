using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI.Docking;

namespace InfinityXplorer.Core
{
    internal partial class FormWorkbench : Form
    {
        // Only to be used to change the status buffer for a short period of time
        // eg 0.1 seconds. else access statusTSSL.Text directly 
        private string statusBuffer = "";
        public string StatusBuffer 
        {
            set
            {
                switch (value)
                {
                    case null:
                        this.statusTSSL.Text = statusBuffer;
                        this.statusBuffer = "";
                        break;
                    default:
                        this.statusBuffer = this.statusTSSL.Text;
                        this.statusTSSL.Text = value;
                        this.statusStrip.Refresh();
                        break;
                }
            }
        }

        public ToolStripStatusLabel StatusTSSL
        {
            get { return this.statusTSSL; }
        }

        public FormWorkbench(DockPanel dockPanel)
        {
            InitializeComponent();
            ReloadDockPanel(dockPanel);

            IXExplorerDictionary explorers = ApplicationRuntime.Explorers;

            foreach (KeyValuePair<ResourceStruct.ResourceType, ResourceStruct.ResInfo> kvp
                in ResourceStruct.OrderedListNames)
            {
                IXExplorer explorer = explorers[kvp.Key];
                ToolStripMenuItem tsmi = explorer.NewToolStripMenuItem();
                tsmi.Click += new System.EventHandler(this.ToolStripMenuItem_Click);

                if (kvp.Value.isCommon)
                    this.explorersMenu.DropDownItems.Add(tsmi);
                else
                    this.infrequentTSMI.DropDownItems.Add(tsmi);

                this.explorersMenu.DropDownItems.Add(this.infrequentTSMI);
            }
            
        }

        // Method to reload dock panel if necessary
        public void ReloadDockPanel(DockPanel dockPanel)
        {
            if (this.dockPanel != null)
            {
                this.Controls.Remove(this.dockPanel);
            }

            this.dockPanel = dockPanel;
            this.Controls.Add(this.dockPanel);
            this.dockPanel.BringToFront();
        }

    }
}