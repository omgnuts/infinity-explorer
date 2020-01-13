using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Services.Protocols;


namespace TestCS
{
    public class MyHyperlink : HyperLink
    {
        public MyHyperlink()
        {
        
            this.ToolTip = "Ctrl Click to Open";

            this.NavigateUrl += new NavigateEventHandler(MyHyperlink_RequestNavigate);

        }

        void MyHyperlink_RequestNavigate(object sender, NavigateEventArgs e)
        {            
            MessageBox.Show("hello");
        }

    }
}
