using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal partial class QAREViewer : IUserControl
    {
        private ResourceClass.QAREFile areFile;
        private ResourceClass.GWEDFile wedFile;
        private ResourceClass.GTISFile tisFile;

        private QAREToolWin areToolWin;
        
        public QAREViewer()
        {
            InitializeComponent();
            this.picAreaMap.SetParent(this);
            this.areToolWin = new QAREToolWin(this, currBright);
            this.InitializeTabs();
            splitter.Panel2Collapsed = true;
        }

        public override int SetResourceParams(ChitinKey ckey, ResourceClass.IResource irFile)
        {
            if ((areFile == null) || (!areFile.Equals(irFile)) || (wedFile == null) || (tisFile == null))
            {
                if (baseImage != null) baseImage.Dispose();
                baseImage = null;

                areFile = (ResourceClass.QAREFile)irFile;

                // load wed 
                wedFile = (ResourceClass.GWEDFile)
                ResourceHandler.LoadResourceFile(areFile.wedFile, ResourceStruct.ResourceType.RTypeGWED);

                if (wedFile == null)
                {
                    return -1;
                }

                // At the start, lets just load layer 0 overlay & TIS
                tisFile = (ResourceClass.GTISFile)
                ResourceHandler.LoadResourceFile(wedFile.overlayList[0].resTIS, ResourceStruct.ResourceType.RTypeGTIS);

                if (tisFile == null)
                {
                    return -1;
                }                

                // Loadup the AreaTV for the AREToolWin
                areToolWin.LoadAreaTV(areFile);

                // Just to hide tabpages that aren't used
                areTabs.TabPages.Clear();
                if (!splitter.Panel2Collapsed) LoadAreaElement(QARETreeView.NodeCode.NodeBasic, -1);

                // Since we need to reload the base map;
                refreshMap = true;
                
            }

            // refreshmap if "edited" or new "are file"
            if (refreshMap) this.DrawAreaMapRectangle();

            ActivateControl();

            return 1;
        }

        public override void ActivateControl()
        {
            if (!areToolWin.Visible)
            {
                ApplicationRuntime.DockPanel.DefaultFloatWindowSize = new Size(areToolWin.Width, areToolWin.Height);
                areToolWin.Show(ApplicationRuntime.DockPanel);
            }
        }

        public override void DeactivateControl()
        {
            areToolWin.Hide();
        }

        private void picAreaMap_ClientSizeChanged(object sender, EventArgs e)
        {
            this.ReDrawAreaMapRectangle();
        }

        private void picAreaMap_Scroll(object sender, ScrollEventArgs e)
        {
            this.ReDrawAreaMapRectangle();
        }

        private void picAreaMap_MouseWheel(object sender, MouseEventArgs e)
        {
            if (e.Delta != 0)
                this.ReDrawAreaMapRectangle();
        }

        public void HidePanelSplitter()
        {
            this.splitter.Panel2Collapsed = true;
        }

        private void checkBox4_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {

        }

    }
}
