namespace InfinityXplorer.Core
{
    partial class FormExplorer
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormExplorer));
            this.imgList = new System.Windows.Forms.ImageList(this.components);
            this.ExplorerTreeView = new InfinityXplorer.Core.IXTreeView();
            this.SuspendLayout();
            // 
            // imgList
            // 
            this.imgList.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imgList.ImageStream")));
            this.imgList.TransparentColor = System.Drawing.Color.Fuchsia;
            this.imgList.Images.SetKeyName(0, "Solution.png");
            this.imgList.Images.SetKeyName(1, "Project.png");
            // 
            // ExplorerTreeView
            // 
            this.ExplorerTreeView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ExplorerTreeView.Location = new System.Drawing.Point(1, 1);
            this.ExplorerTreeView.Name = "ExplorerTreeView";
            this.ExplorerTreeView.Size = new System.Drawing.Size(267, 373);
            this.ExplorerTreeView.TabIndex = 0;
            // 
            // FormExplorer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(269, 375);
            this.Controls.Add(this.ExplorerTreeView);
            this.DockAreas = ((WeifenLuo.WinFormsUI.Docking.DockAreas)(((((WeifenLuo.WinFormsUI.Docking.DockAreas.Float | WeifenLuo.WinFormsUI.Docking.DockAreas.DockLeft)
                        | WeifenLuo.WinFormsUI.Docking.DockAreas.DockRight)
                        | WeifenLuo.WinFormsUI.Docking.DockAreas.DockTop)
                        | WeifenLuo.WinFormsUI.Docking.DockAreas.DockBottom)));
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.HideOnClose = true;
            this.Name = "FormExplorer";
            this.Padding = new System.Windows.Forms.Padding(1);
            this.TabText = "IE Browser";
            this.Text = "IE Browser";
            this.ResumeLayout(false);

        }

        #endregion

        private InfinityXplorer.Core.IXTreeView ExplorerTreeView;
        private System.Windows.Forms.ImageList imgList;
    }
}