using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI;

namespace InfinityXplorer.Core
{
    // light-weight wrapper class for FormExplorer, so that we don't need to load 
    // all the 30+ forms at the start. Load only when necessary & have to 
    // populate into TreeViewer. 

    internal class IXExplorer
    {
        private string name;
        public string Name
        {
            get { return name; }
        }

        private ChitinKeyDictionary ckeyDictionary;
        private ResourceStruct.ResourceType resourceType;

        private FormExplorer form;
        public FormExplorer Form
        {
            get
            {
                if (form == null)
                {
                    form = new FormExplorer(name, (ResourceStruct.ResourceToCode(resourceType)).ToString());
                    this.PopulateTreeViewer(form.TreeViewer);

                }

                return form;
            }
        }

        private static FormResource commonResourceForm;
        private FormResource resourceForm;
        private FormResource ResourceForm
        { 
            get 
            {   // Only create new documents for common resources
                // the infrequent documents get to share a common formdocument
                // just have to replace the usercontrols.
                // that way it would be neater. 

                if (ResourceStruct.OrderedListNames[resourceType].isCommon)
                {
                    if (resourceForm == null)
                    {
                        resourceForm = new FormResource(true);
                    }
                    return resourceForm;
                }
                else
                {
                    if (commonResourceForm == null)
                    {
                        commonResourceForm = new FormResource(false);
                    }

                    return commonResourceForm;
                }
            }
        }
        
        public bool ShowViewer(IUserControl uc, ChitinKey ckey, ResourceClass.IResource irFile, bool closeResourceOnError)
        {
            if (!this.ResourceForm.ShowViewer(uc, ckey, irFile))
            {
                if (closeResourceOnError) this.ResourceForm.Hide();
                return false;
            }

            return true;
        }

        public IXTreeView TreeViewer
        {
            get { return form.TreeViewer; }
        }

        public IXExplorer(string name, ResourceStruct.ResourceType resourceType,
             ChitinKeyDictionary ckeyDictionary)
        {
            this.name = name + " (" + ckeyDictionary.Count.ToString() + ")";
            this.resourceType = resourceType;
            this.ckeyDictionary = ckeyDictionary;
        }

        private void PopulateTreeViewer(IXTreeView treeViewer)
        {
            foreach (ChitinKey ckey in ckeyDictionary.Values)
            {
                ckey.node = new IXTreeNode(ckey.name, ckey);
                treeViewer.Nodes.Add(ckey.node);
            }
        }

        public ToolStripMenuItem NewToolStripMenuItem()
        {
            ToolStripMenuItem tsmi = new ToolStripMenuItem();
            tsmi.Name = resourceType.ToString();
            tsmi.Size = new System.Drawing.Size(174, 22);
            tsmi.Text = this.name;
            tsmi.Tag = this;
            return tsmi;
        }

    }
}
