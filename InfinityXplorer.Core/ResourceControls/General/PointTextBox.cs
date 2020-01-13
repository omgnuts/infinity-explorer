using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace InfinityXplorer.Core.ResourceControls
{
    internal class PointTextBox : TextBox
    {
        public Point ValPoint
        {
            get
            {
                string[] coord = this.Text.Split(',');
                return new Point(Convert.ToInt32(coord[0]), Convert.ToInt32(coord[1]));
            }
            set
            {
                this.Text = value.X + ", " + value.Y;
            }
        }

        public String ValText
        {
            get
            {
                return this.Text;
            }
            set
            {
                string[] coord = value.Split(',');
                this.ValPoint = new Point(Convert.ToInt32(coord[0]), Convert.ToInt32(coord[1]));
            }
        }

        public XPoint ValXPoint
        {
            set
            {
                this.Text = value.X + ", " + value.Y;
            }
        }
    }
}
