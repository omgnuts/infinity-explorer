namespace InfinityXplorer.Core.ResourceControls
{
    partial class QDLGViewer
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

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.gboxAction = new System.Windows.Forms.GroupBox();
            this.rtAction = new System.Windows.Forms.RichTextBox();
            this.gboxState = new System.Windows.Forms.GroupBox();
            this.rtboxStatement = new System.Windows.Forms.RichTextBox();
            this.dialogTreeView = new System.Windows.Forms.TreeView();
            this.gboxTrigger = new System.Windows.Forms.GroupBox();
            this.rtboxTrigger = new System.Windows.Forms.RichTextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.rtboxJournal = new System.Windows.Forms.RichTextBox();
            this.gboxAction.SuspendLayout();
            this.gboxState.SuspendLayout();
            this.gboxTrigger.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // gboxAction
            // 
            this.gboxAction.AutoSize = true;
            this.gboxAction.Controls.Add(this.rtAction);
            this.gboxAction.Location = new System.Drawing.Point(332, 384);
            this.gboxAction.Name = "gboxAction";
            this.gboxAction.Size = new System.Drawing.Size(304, 104);
            this.gboxAction.TabIndex = 7;
            this.gboxAction.TabStop = false;
            this.gboxAction.Text = "Action Trigger";
            // 
            // rtAction
            // 
            this.rtAction.BackColor = System.Drawing.SystemColors.Control;
            this.rtAction.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.rtAction.Location = new System.Drawing.Point(12, 20);
            this.rtAction.Margin = new System.Windows.Forms.Padding(0);
            this.rtAction.Name = "rtAction";
            this.rtAction.ReadOnly = true;
            this.rtAction.Size = new System.Drawing.Size(280, 68);
            this.rtAction.TabIndex = 0;
            this.rtAction.Text = "";
            // 
            // gboxState
            // 
            this.gboxState.AutoSize = true;
            this.gboxState.Controls.Add(this.rtboxStatement);
            this.gboxState.Location = new System.Drawing.Point(12, 272);
            this.gboxState.Name = "gboxState";
            this.gboxState.Padding = new System.Windows.Forms.Padding(0);
            this.gboxState.Size = new System.Drawing.Size(624, 109);
            this.gboxState.TabIndex = 5;
            this.gboxState.TabStop = false;
            this.gboxState.Text = "Dialog Statement";
            // 
            // rtboxStatement
            // 
            this.rtboxStatement.BackColor = System.Drawing.SystemColors.Control;
            this.rtboxStatement.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.rtboxStatement.Location = new System.Drawing.Point(12, 20);
            this.rtboxStatement.Margin = new System.Windows.Forms.Padding(0);
            this.rtboxStatement.Name = "rtboxStatement";
            this.rtboxStatement.ReadOnly = true;
            this.rtboxStatement.Size = new System.Drawing.Size(600, 76);
            this.rtboxStatement.TabIndex = 0;
            this.rtboxStatement.Text = "";
            // 
            // dialogTreeView
            // 
            this.dialogTreeView.Dock = System.Windows.Forms.DockStyle.Top;
            this.dialogTreeView.Location = new System.Drawing.Point(10, 10);
            this.dialogTreeView.Margin = new System.Windows.Forms.Padding(10);
            this.dialogTreeView.Name = "dialogTreeView";
            this.dialogTreeView.Size = new System.Drawing.Size(629, 258);
            this.dialogTreeView.TabIndex = 4;
            this.dialogTreeView.NodeMouseDoubleClick += new System.Windows.Forms.TreeNodeMouseClickEventHandler(this.dialogTreeView_NodeMouseDoubleClick);
            // 
            // gboxTrigger
            // 
            this.gboxTrigger.AutoSize = true;
            this.gboxTrigger.Controls.Add(this.rtboxTrigger);
            this.gboxTrigger.Location = new System.Drawing.Point(12, 384);
            this.gboxTrigger.Name = "gboxTrigger";
            this.gboxTrigger.Size = new System.Drawing.Size(310, 100);
            this.gboxTrigger.TabIndex = 7;
            this.gboxTrigger.TabStop = false;
            this.gboxTrigger.Text = "Dialog Trigger";
            // 
            // rtboxTrigger
            // 
            this.rtboxTrigger.BackColor = System.Drawing.SystemColors.Control;
            this.rtboxTrigger.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.rtboxTrigger.Location = new System.Drawing.Point(12, 20);
            this.rtboxTrigger.Margin = new System.Windows.Forms.Padding(0);
            this.rtboxTrigger.Name = "rtboxTrigger";
            this.rtboxTrigger.ReadOnly = true;
            this.rtboxTrigger.Size = new System.Drawing.Size(284, 64);
            this.rtboxTrigger.TabIndex = 0;
            this.rtboxTrigger.Text = "";
            // 
            // groupBox1
            // 
            this.groupBox1.AutoSize = true;
            this.groupBox1.Controls.Add(this.rtboxJournal);
            this.groupBox1.Location = new System.Drawing.Point(12, 488);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(0);
            this.groupBox1.Size = new System.Drawing.Size(624, 101);
            this.groupBox1.TabIndex = 8;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Journal Entry (if any)";
            // 
            // rtboxJournal
            // 
            this.rtboxJournal.BackColor = System.Drawing.SystemColors.Control;
            this.rtboxJournal.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.rtboxJournal.Location = new System.Drawing.Point(12, 20);
            this.rtboxJournal.Margin = new System.Windows.Forms.Padding(0);
            this.rtboxJournal.Name = "rtboxJournal";
            this.rtboxJournal.ReadOnly = true;
            this.rtboxJournal.Size = new System.Drawing.Size(596, 68);
            this.rtboxJournal.TabIndex = 0;
            this.rtboxJournal.Text = "";
            // 
            // QDLGViewer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.gboxAction);
            this.Controls.Add(this.gboxTrigger);
            this.Controls.Add(this.gboxState);
            this.Controls.Add(this.dialogTreeView);
            this.Margin = new System.Windows.Forms.Padding(10);
            this.Name = "QDLGViewer";
            this.Padding = new System.Windows.Forms.Padding(10);
            this.Size = new System.Drawing.Size(649, 602);
            this.gboxAction.ResumeLayout(false);
            this.gboxState.ResumeLayout(false);
            this.gboxTrigger.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox gboxAction;
        private System.Windows.Forms.GroupBox gboxState;
        private System.Windows.Forms.TreeView dialogTreeView;
        private System.Windows.Forms.GroupBox gboxTrigger;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RichTextBox rtboxStatement;
        private System.Windows.Forms.RichTextBox rtAction;
        private System.Windows.Forms.RichTextBox rtboxTrigger;
        private System.Windows.Forms.RichTextBox rtboxJournal;
    }
}
