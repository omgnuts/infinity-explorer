using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal partial class QBCSViewer : IUserControl
    {
        public QBCSViewer()
        {
            InitializeComponent();
        }

        public override int SetResourceParams(ChitinKey ckey, ResourceClass.IResource irFile)
        {
            return 0;
        }

    }
}
