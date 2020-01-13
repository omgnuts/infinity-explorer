namespace InfinityXplorer.Core.ResourceControls
{
    partial class QAREToolWin
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(QAREToolWin));
            this.imageTV = new System.Windows.Forms.ImageList(this.components);
            this.sliderBrightness = new System.Windows.Forms.TrackBar();
            this.areaTV = new InfinityXplorer.Core.ResourceControls.QARETreeView();
            this.bnHideInfo = new System.Windows.Forms.Button();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            ((System.ComponentModel.ISupportInitialize)(this.sliderBrightness)).BeginInit();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // imageTV
            // 
            this.imageTV.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageTV.ImageStream")));
            this.imageTV.TransparentColor = System.Drawing.Color.Transparent;
            this.imageTV.Images.SetKeyName(0, "");
            this.imageTV.Images.SetKeyName(1, "");
            this.imageTV.Images.SetKeyName(2, "");
            this.imageTV.Images.SetKeyName(3, "");
            this.imageTV.Images.SetKeyName(4, "");
            this.imageTV.Images.SetKeyName(5, "");
            // 
            // sliderBrightness
            // 
            this.sliderBrightness.Cursor = System.Windows.Forms.Cursors.Hand;
            this.sliderBrightness.Dock = System.Windows.Forms.DockStyle.Fill;
            this.sliderBrightness.LargeChange = 20;
            this.sliderBrightness.Location = new System.Drawing.Point(69, 3);
            this.sliderBrightness.Maximum = 100;
            this.sliderBrightness.Name = "sliderBrightness";
            this.sliderBrightness.Size = new System.Drawing.Size(118, 35);
            this.sliderBrightness.SmallChange = 10;
            this.sliderBrightness.TabIndex = 3;
            this.sliderBrightness.TickFrequency = 10;
            this.sliderBrightness.TickStyle = System.Windows.Forms.TickStyle.TopLeft;
            this.sliderBrightness.Scroll += new System.EventHandler(this.sliderBrightness_Scroll);
            // 
            // areaTV
            // 
            this.tableLayoutPanel1.SetColumnSpan(this.areaTV, 2);
            this.areaTV.Dock = System.Windows.Forms.DockStyle.Fill;
            this.areaTV.ImageIndex = 5;
            this.areaTV.ImageList = this.imageTV;
            this.areaTV.Location = new System.Drawing.Point(3, 44);
            this.areaTV.Name = "areaTV";
            this.areaTV.SelectedImageIndex = 5;
            this.areaTV.ShowRootLines = false;
            this.areaTV.Size = new System.Drawing.Size(184, 255);
            this.areaTV.TabIndex = 0;
            // 
            // bnHideInfo
            // 
            this.bnHideInfo.Location = new System.Drawing.Point(3, 3);
            this.bnHideInfo.Name = "bnHideInfo";
            this.bnHideInfo.Size = new System.Drawing.Size(60, 35);
            this.bnHideInfo.TabIndex = 4;
            this.bnHideInfo.Text = "Full Map";
            this.bnHideInfo.UseVisualStyleBackColor = true;
            this.bnHideInfo.Click += new System.EventHandler(this.bnHideInfo_Click);
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 66F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.areaTV, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.sliderBrightness, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.bnHideInfo, 0, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(1, 1);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 41F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(190, 302);
            this.tableLayoutPanel1.TabIndex = 5;
            // 
            // QAREToolWin
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.ClientSize = new System.Drawing.Size(192, 304);
            this.Controls.Add(this.tableLayoutPanel1);
            this.DockAreas = ((WeifenLuo.WinFormsUI.Docking.DockAreas)(((WeifenLuo.WinFormsUI.Docking.DockAreas.Float | WeifenLuo.WinFormsUI.Docking.DockAreas.DockLeft)
                        | WeifenLuo.WinFormsUI.Docking.DockAreas.DockRight)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.HideOnClose = true;
            this.Name = "QAREToolWin";
            this.Padding = new System.Windows.Forms.Padding(1);
            this.TabText = "AreaTool";
            this.Text = "ARETool";
            this.TopMost = true;
            ((System.ComponentModel.ISupportInitialize)(this.sliderBrightness)).EndInit();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private QARETreeView areaTV;
        private System.Windows.Forms.TrackBar sliderBrightness;
        private System.Windows.Forms.ImageList imageTV;
        private System.Windows.Forms.Button bnHideInfo;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
    }
}