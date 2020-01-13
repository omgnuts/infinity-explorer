using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using InfinityXplorer.Core.ResourceControls.General;

namespace InfinityXplorer.Core.ResourceControls
{
    internal class FlagsBitListBox : CheckedListBox
    {        
        private bool clickChecked = true;
        private bool isReadOnly = true;
        public bool IsReadOnly
        {
            get { return isReadOnly; }
            set { isReadOnly = value; }
        }

        private Type enumList;
        public Type EnumList
        {
            get { return this.enumList; }
            set 
            {
                this.enumList = value;
                this.Items.Clear();

                if (enumList != null)
                {
                    foreach (string s in Enum.GetNames(enumList))
                    {
                        int eval = (int)Enum.Parse(enumList, s);
                        FlagListItem li = new FlagListItem(s, eval);
                        this.Items.Add(li);
                    }

                }
            }
        }

        public int EnumValue
        {
            get 
            {
                int eval = 0;

                foreach (FlagListItem li in this.CheckedItems)
                {
                    eval += li.ToEnumValue();
                }
                
                return eval; 
            }
            set
            {
                clickChecked = false;
                for (int c = 0; c < this.Items.Count; c++)
                {
                    int eval = ((FlagListItem)this.Items[c]).ToEnumValue();
                    this.SetItemChecked(c, (eval & value) != 0);
                }
                clickChecked = true;
            }
        }

        protected override void OnItemCheck(ItemCheckEventArgs e)
        {
            if (isReadOnly && clickChecked) e.NewValue = e.CurrentValue;
        }

        public FlagsBitListBox()
        {
            
        }

    }
}
