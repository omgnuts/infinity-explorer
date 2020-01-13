using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal partial class ScrollPictureBox : UserControl
    {
        private IUserControl parent;

        private Image image = null;
        public Image Image
        {
            get { return this.image; }
            set 
            { 
                this.image = value;
                if (image != null)
                {
                    this.AutoScrollMinSize = new Size(image.Width, image.Height);
                }
                else
                {
                    this.AutoScrollMinSize = new Size(10, 10);
                }
                this.AutoScrollOffset = new System.Drawing.Point(0, 0);
                this.Refresh();
            }
        }

        public ScrollPictureBox()
        {
            // this empty constructor to work around a VStudio bug that
            // removes your control if it doesn't find a empty constructor!!!
            // Fix ; 842706 for vs2003

            InitializeComponent();
            this.Image = null;
            this.AutoScroll = true;
            this.Dock = DockStyle.Fill;
            this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.OptimizedDoubleBuffer, true);
        }

        public void SetParent(IUserControl parent)
        {
            this.parent = parent;
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
            if (image != null)
            {
                e.Graphics.DrawImage(image, new RectangleF(this.AutoScrollPosition.X, 
                    this.AutoScrollPosition.Y, image.Width, image.Height));
            }
        }

        private int MinimumOf(int a, int b)
        {
            if (a < b) return a;
            return b;
        }

        private void ScrollPictureBox_MouseMove(object sender, MouseEventArgs e)
        {
            if (this.image != null)
            {
                int x = MinimumOf(image.Width, e.Location.X - this.AutoScrollPosition.X);
                int y = MinimumOf(image.Height, e.Location.Y - this.AutoScrollPosition.Y);
                ApplicationRuntime.Workbench.StatusTSSL.Text = "Map Location ( " + x + " . " + y + " )";
                //if (this.parent != null)
                //    this.parent.ReturnParent(new System.Drawing.Point(x, y));
            }
        }

    }
}
