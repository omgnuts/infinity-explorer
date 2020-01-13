using System;
using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using InfinityXplorer.Core;

namespace InfinityXplorer.Core.ResourceControls
{
    internal partial class QDLGViewer : IUserControl
    {
        public string InfoState
        {
            set 
            {
                if ((value == "") || (value == null))
                {
                    gboxState.Hide();
                }
                else
                {
                    rtboxState.Text = value;
                    gboxState.Show();
                }
            }
        }

        public string InfoStateRef
        {
            set
            {
                gboxState.Text = value;
            }
        }

        public string InfoTrans
        {
            set
            {
                if ((value == "") || (value == null))
                {
                    gboxTrigger.Hide();
                }
                else
                {
                    rtboxTrigger.LinkText = value;
                    gboxTrigger.Show();
                }
            }
        }

        public string InfoAction
        {
            set
            {
                if ((value == "") || (value == null))
                {
                    gboxAction.Hide();
                }
                else
                {
                    rtboxAction.LinkText = value;
                    gboxAction.Show();
                }
            }
        }

        public string InfoJournal
        {
            set
            {
                if ((value == "") || (value == null))
                {
                    
                    gboxJournal.Hide();
                }
                else
                {
                    rtboxJournal.Text = value;
                    gboxJournal.Show();
                }
            }
        }
        
        protected static ResourceClass.QDLGFile dlgFile;

        protected static ArrayList extDialogFileCache;

        protected static ResourceClass.QDLGFile GetDialogFile(string ckeyName)
        {
            if (ckeyName == dlgFile.GetName()) return dlgFile;

            foreach (ResourceClass.QDLGFile dfile in extDialogFileCache)
            {
                if (ckeyName == dfile.GetName())
                {
                    return dfile;
                }
            }

            ResourceClass.QDLGFile ddfile = (ResourceClass.QDLGFile)
                ResourceHandler.LoadResourceFile(ckeyName, ResourceStruct.ResourceType.RTypeQDLG);

            extDialogFileCache.Add(ddfile);

            return ddfile;
        }

        public QDLGViewer()
        {            
            InitializeComponent();
            extDialogFileCache = new ArrayList();
        }

        public override int SetResourceParams(ChitinKey ckey, 
            ResourceClass.IResource irFile)
        {
            if ((dlgFile == null) || (!dlgFile.Equals(irFile)))
            {
                extDialogFileCache.Clear();
                dlgFile = (ResourceClass.QDLGFile)irFile;

                this.dialogTreeView.Nodes.Clear();
                InfoState = null;
                InfoTrans = null;
                InfoAction = null;
                InfoJournal = null;

                if (dlgFile.stateList.Length > 0)
                {
                    QDLGTreeNode[] nodes = BuildParentDialogNodes(dlgFile);

                    if (nodes == null) return 0;

                    this.dialogTreeView.Nodes.AddRange(nodes);

                    ((QDLGTreeNode)dialogTreeView.Nodes[0]).
                        DisplayNodeInformation(this);
                }

            }

            return 1;
        }

        private static QDLGTreeNode[] BuildParentDialogNodes(
            ResourceClass.QDLGFile dlgFile)
        {
            ArrayList nodes = new ArrayList();

            for (int c = 0; c < dlgFile.stateList.Length; c++)
            {
                if (dlgFile.stateList[c].sTrigIndex > -1)
                {
                    nodes.Add(new QDLGTreeNode(dlgFile, dlgFile.stateList[c], false));
                }
            }

            if (nodes.Count > 0)
            {
                return (QDLGTreeNode[])nodes.ToArray(typeof(QDLGTreeNode));
            }
            else
            {
                return null;
            }
        }

        public static QDLGTreeNode BuildDialogNodes(
            ResourceClass.QDLGFile.TransStruct trans)
        {
            if ((trans.nxDLG != "") && (trans.nxStateIndex > -1))
            {
                ResourceClass.QDLGFile dfile = GetDialogFile(trans.nxDLG);
                return new QDLGTreeNode(dfile, dfile.stateList[trans.nxStateIndex],
                    trans.nxDLG == dlgFile.GetName());
            }

            return null;
        }

        public static QDLGTreeNode[] BuildDialogNodes(
            ResourceClass.QDLGFile dfile, 
            ResourceClass.QDLGFile.StateStruct state)
        {
            if (state.transCount > 0)
            {
                QDLGTreeNode[] nodes = new QDLGTreeNode[state.transCount];

                int ptr = state.transIndex;

                for (int c = 0; c < state.transCount; c++)
                {
                    ResourceClass.QDLGFile.TransStruct trans = 
                        dfile.transList[ptr + c];

                    nodes[c] = new QDLGTreeNode(dfile, trans);
                }

                return nodes;
            }

            return null;
        }

        private void dialogTreeView_BeforeExpand(object sender, TreeViewCancelEventArgs e)
        {
            QDLGTreeNode node = (QDLGTreeNode)e.Node;
            node.LoadNextTreeNode();
            node.DisplayNodeInformation(this);
            
        }

        private void dialogTreeView_AfterSelect(object sender, TreeViewEventArgs e)
        {
            QDLGTreeNode node = (QDLGTreeNode)e.Node;
            node.DisplayNodeInformation(this);
        }

    }
}