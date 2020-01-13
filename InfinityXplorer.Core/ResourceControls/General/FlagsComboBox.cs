using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using InfinityXplorer.Core.ResourceControls.General;


namespace InfinityXplorer.Core.ResourceControls
{
    internal class FlagsComboBox : ComboBox
    {
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
                if (this.SelectedItem != null)
                {
                    return ((FlagListItem)this.SelectedItem).ToEnumValue();
                }
                else
                {
                    return -1;
                }
            }
            set
            {
                foreach (FlagListItem li in this.Items)
                {
                    if (li.ToEnumValue() == value)
                    {
                        this.SelectedItem = li;
                        break;
                    }
                }
            }
        }

        public FlagsComboBox()
            : base()
        {
            this.DropDownStyle = ComboBoxStyle.DropDownList;
        }

    }

}
