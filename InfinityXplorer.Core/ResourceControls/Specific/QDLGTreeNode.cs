using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal class QDLGTreeNode : TreeNode
    {
        protected ResourceClass.QDLGFile dlgFile;
        protected bool isStateNode;
        protected ResourceClass.QDLGFile.StateStruct state;
        protected ResourceClass.QDLGFile.TransStruct trans;

        protected bool hasLoaded = false;

        public QDLGTreeNode(ResourceClass.QDLGFile dlgFile,
            ResourceClass.QDLGFile.StateStruct state, bool isExt) 
        {
            this.isStateNode = true;

            this.dlgFile = dlgFile;
            this.state = state;

            if (state.transCount > 0)
            {
                // add dummy node
                this.Nodes.Add(new TreeNode("..."));
            }
            else
            {
                this.hasLoaded = true;
            }
            
            this.InitTreeNode(state.srStateIndex);
        }

        public QDLGTreeNode(ResourceClass.QDLGFile dlgFile, 
            ResourceClass.QDLGFile.TransStruct trans)
        {
            this.isStateNode = false;

            this.dlgFile = dlgFile;
            this.trans = trans;

            if ((trans.nxDLG != "") && (trans.nxStateIndex > -1))
            {
                // add dummy nodes
                this.Nodes.Add(new TreeNode("..."));
            }
            else
            {
                this.hasLoaded = true;
            }

            InitTreeNode(trans.srTransIndex);
        }

        private void InitTreeNode(int srIndex)
        {

            this.Text = ApplicationRuntime.TalkIndex.TrefCollection.GetStringRef(srIndex);

            
            //this.ImageIndex = (int)FormSolutionExplorer.ImageIndex.ProjectOn;
            //this.SelectedImageIndex = (int)FormSolutionExplorer.ImageIndex.ProjectOff;


        }

        public void LoadNextTreeNode()
        {
            if (!this.hasLoaded)
            {
                this.Nodes.Clear();

                if (isStateNode)
                {
                    QDLGTreeNode[] nodes =
                        QDLGViewer.BuildDialogNodes(this.dlgFile, this.state);

                    if (nodes != null) 
                        this.Nodes.AddRange(nodes);
                }
                else
                {
                    QDLGTreeNode node = QDLGViewer.BuildDialogNodes(this.trans);
                    if (node != null)
                        this.Nodes.Add(node);
                }
            }

            this.hasLoaded = true;
        }

        public void DisplayNodeInformation(QDLGViewer dlgTV)
        {
            if (isStateNode)
            {
                dlgTV.InfoStateRef = "[RESFILE: " + dlgFile.GetName() + "]     [STRREF: " + state.srStateIndex.ToString() + "]     [STATE: " + state.id.ToString() + "]";
                dlgTV.InfoState = this.Text;
                dlgTV.InfoTrans = GetString(dlgFile.sTrigList, state.sTrigIndex);
                dlgTV.InfoAction = null;
                dlgTV.InfoJournal = null;
            }
            else
            {
                dlgTV.InfoStateRef = "[RESFILE: " + dlgFile.GetName() + "]     [STRREF: " + trans.srTransIndex.ToString() + "]     [TRIGGER: " + trans.id.ToString() + "]";
                dlgTV.InfoState = this.Text;
                dlgTV.InfoTrans = GetString(dlgFile.tTrigList, trans.tTrigIndex);
                dlgTV.InfoAction = GetString(dlgFile.actionList, trans.actionIndex);
                dlgTV.InfoJournal = ApplicationRuntime.TalkIndex.
                    TrefCollection.GetStringRef(trans.srJournIndex);

            }
        }

        private string GetString(string[] slist, int index)
        {
            if ((index < 0) || (index >= slist.Length))
            {
                return null;
            }
            else
            {
                return slist[index];
            }
        }

    }
}
