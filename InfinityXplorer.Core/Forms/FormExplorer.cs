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
    internal partial class FormExplorer : DockContent
    {
        public IXTreeView TreeViewer
        {
            get { return this.ExplorerTreeView; }
        }

        public FormExplorer(string explorerName, string contentId)
        {
            InitializeComponent();

            this.contentId = contentId;
            this.TabText = explorerName;
           
        }



    }
}