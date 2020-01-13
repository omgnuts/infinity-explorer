using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal class LabelLink : LinkLabel
    {
        private ResourceStruct.ResourceType resourceType;
        public ResourceStruct.ResourceType ResourceType
        {
            get { return this.resourceType; }
            set { this.resourceType = value; }
        }

        public LabelLink()
        {
            this.AutoEllipsis = true;
            this.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.Padding = new System.Windows.Forms.Padding(2);
            this.Size = new System.Drawing.Size(75, 20);
            this.resourceType = ResourceStruct.ResourceType.RTypeNULL;
            this.UseMnemonic = false;
        }

        public string LinkText
        {
            get { return this.Text; }
            set
            {
                if ((value != "") && ApplicationRuntime.ChitinIndex.CkeyDictionary[this.resourceType].Contains(value))
                {
                    this.Text = value;
                    this.LinkArea = new System.Windows.Forms.LinkArea(0, Text.Length);
                }
                else
                {
                    this.Text = "";
                }
            }

        }

        protected override void OnLinkClicked(LinkLabelLinkClickedEventArgs e)
        {
            base.OnLinkClicked(e);

            if (this.Text != "")
            {
                ChitinKey ckey =
                    (ApplicationRuntime.ChitinIndex.CkeyDictionary[this.resourceType])[this.Text];

                if (ckey != null) IXTreeNode.LoadResource(ckey, false);
            }
            
        }


    }
}
