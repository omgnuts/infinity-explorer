using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal sealed class QARETreeNode : TreeNode
    {
        private int id;
        public int Id
        {
            get { return id; }
        }

        private QARETreeView.NodeCode nodeCode;
        public QARETreeView.NodeCode NodeCode
        {
            get { return nodeCode; }
        }

        public QARETreeNode(string text, QARETreeView.NodeCode nodeCode, int id)
            : base(text)
        {
            this.nodeCode = nodeCode;
            this.id = id;
        }

        public QARETreeNode(string text, int imageIndex, int selectedImageIndex, 
            QARETreeView.NodeCode nodeCode) : base(text, imageIndex, selectedImageIndex)
        {
            this.nodeCode = nodeCode;
            this.id = -1;
        }

    }
}
