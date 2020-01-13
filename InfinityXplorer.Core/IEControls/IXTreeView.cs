using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core
{
    /// Class IXTreeView
    /// Controls the presentation of the tree structure in IXplorer

    internal class IXTreeView : TreeView
    {
        public IXTreeView()
            : base()
        {
            base.Nodes.Clear();
        }

        protected override void OnNodeMouseDoubleClick(TreeNodeMouseClickEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                IXTreeNode.LoadResource(((IXTreeNode)e.Node).Ckey, true);
            }

            base.OnNodeMouseDoubleClick(e);
        }

        protected override void OnNodeMouseClick(TreeNodeMouseClickEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.SelectedNode = e.Node;
                IXTreeNode.SelectNode(((IXTreeNode)e.Node).Ckey);
            }

            base.OnNodeMouseClick(e);
        }

    }
}
