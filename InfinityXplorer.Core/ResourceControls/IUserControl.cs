using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Text;
using System.Drawing;

namespace InfinityXplorer.Core
{
    //internal interface IIUserControl
    //{
    //    void SetResourceParams(ChitinKey ckey, ResourceClass.IResource irFile);
    //    void ActivateControl();
    //    void DeactivateControl();
    //}

    internal class IUserControl : UserControl
    {
        public IUserControl()
        {
            this.Dock = DockStyle.Fill;
        }

        public virtual int SetResourceParams(ChitinKey ckey, ResourceClass.IResource irFile)
        {
            return 0;
        }

        public virtual void ActivateControl()
        {

        }

        public virtual void DeactivateControl()
        {
            
        }

    }
}
