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
    internal partial class FormResource : DockContent
    {
        private bool isCommon;
        private IUserControl uc;

        public FormResource(bool isCommon)
        {
            InitializeComponent();
            this.isCommon = isCommon;
        }

        public bool ShowViewer(IUserControl uc, ChitinKey ckey, ResourceClass.IResource irFile)
        {
            this.uc = uc;

            // -1 == bad load so close formresource
            //  0 == bad load but keep formresource open
            //  1 == good load
            if (uc.SetResourceParams(ckey, irFile) < 0) return false;
            
            this.TabText = ResourceStruct.ResourceFileExt(ckey.resourceType) + ":" + ckey.name;
            this.Text = this.TabText;

            if ((!isCommon) || ((this.viewUControl == null) && (this.editUControl == null)))
            {
                ReloadViewer(uc);
                //ReloadEditor(uc);
            }

            this.Show(ApplicationRuntime.DockPanel);

            return true;           
        }

        private void ReloadViewer(IUserControl uc)
        {
            if (this.viewUControl == null)
            {
                this.viewUControl = uc;
                this.tabViewer.Controls.Add(this.viewUControl);
            }
            else
            {
                this.tabViewer.Controls.Remove(this.viewUControl);
                this.viewUControl = uc;
                this.tabViewer.Controls.Add(this.viewUControl);
            }
            
        }

        public void ReloadEditor(IUserControl uc)
        {
            if (this.editUControl == null)
            {
                this.editUControl = uc;
                this.tabEditor.Controls.Add(this.editUControl);
            }
            else
            {
                this.tabEditor.Controls.Remove(this.editUControl);
                this.editUControl = uc;
                this.tabEditor.Controls.Add(this.editUControl);
            }

        }

        private void FormResource_Activated(object sender, EventArgs e)
        {
            this.uc.ActivateControl();
        }

        private void FormResource_Deactivate(object sender, EventArgs e)
        {
            this.uc.DeactivateControl();
        }
        
    }
}