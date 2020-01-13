using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI.Docking;

namespace InfinityXplorer.Core.ResourceControls
{
    internal partial class QAREToolWin : DockContent
    {
        private QAREViewer areViewer;

        public int MapBrightness
        {
            get { return sliderBrightness.Value; }
        }

        public QAREToolWin(QAREViewer areViewer, ushort currBright)
        {
            InitializeComponent();
            
            this.areViewer = areViewer;
            areaTV.Initialize(areViewer);

            sliderBrightness.Value = currBright;
        }

        public void LoadAreaTV(ResourceClass.QAREFile areFile)
        {
            areaTV.Load(areFile);
        }

        private void sliderBrightness_Scroll(object sender, EventArgs e)
        {
            this.areViewer.BrightenAreaMap(sliderBrightness.Value);
        }

        //private void QAREToolWin_Activated(object sender, EventArgs e)
        //{
        //    this.Width = 140;
        //    this.Height = 250;
        //}

        public void LoadAreaElement(QARETreeView.NodeCode nodeCode, int id)
        {
            this.areViewer.LoadAreaElement(nodeCode, id);
        }

        private void bnHideInfo_Click(object sender, EventArgs e)
        {
            this.areViewer.HidePanelSplitter();
        }

    }
}