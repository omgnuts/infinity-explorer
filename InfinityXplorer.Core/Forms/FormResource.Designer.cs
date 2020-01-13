namespace InfinityXplorer.Core
{
    partial class FormResource
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
            this.docTab = new System.Windows.Forms.TabControl();
            this.tabViewer = new System.Windows.Forms.TabPage();
            this.tabEditor = new System.Windows.Forms.TabPage();
            this.docTab.SuspendLayout();
            this.SuspendLayout();
            // 
            // docTab
            // 
            this.docTab.Controls.Add(this.tabViewer);
            this.docTab.Controls.Add(this.tabEditor);
            this.docTab.Dock = System.Windows.Forms.DockStyle.Fill;
            this.docTab.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.docTab.Location = new System.Drawing.Point(0, 0);
            this.docTab.Multiline = true;
            this.docTab.Name = "docTab";
            this.docTab.SelectedIndex = 0;
            this.docTab.Size = new System.Drawing.Size(400, 383);
            this.docTab.TabIndex = 0;
            // 
            // tabViewer
            // 
            this.tabViewer.BackColor = System.Drawing.SystemColors.Control;
            this.tabViewer.Location = new System.Drawing.Point(4, 22);
            this.tabViewer.Name = "tabViewer";
            this.tabViewer.Padding = new System.Windows.Forms.Padding(3);
            this.tabViewer.Size = new System.Drawing.Size(392, 357);
            this.tabViewer.TabIndex = 0;
            this.tabViewer.Text = "Viewer";
            // 
            // tabEditor
            // 
            this.tabEditor.Location = new System.Drawing.Point(4, 22);
            this.tabEditor.Name = "tabEditor";
            this.tabEditor.Padding = new System.Windows.Forms.Padding(3);
            this.tabEditor.Size = new System.Drawing.Size(392, 357);
            this.tabEditor.TabIndex = 1;
            this.tabEditor.Text = "Editor";
            this.tabEditor.UseVisualStyleBackColor = true;
            // 
            // FormResource
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(400, 383);
            this.Controls.Add(this.docTab);
            this.HideOnClose = true;
            this.Name = "FormResource";
            this.TabText = "FormDocument";
            this.Text = "FormDocument";
            this.Deactivate += new System.EventHandler(this.FormResource_Deactivate);
            this.Activated += new System.EventHandler(this.FormResource_Activated);
            this.docTab.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private InfinityXplorer.Core.IUserControl viewUControl;
        private InfinityXplorer.Core.IUserControl editUControl;
        private System.Windows.Forms.TabControl docTab;
        private System.Windows.Forms.TabPage tabViewer;
        private System.Windows.Forms.TabPage tabEditor;

    }
}