using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace TestCS
{
    internal class MyBitFlags : CheckedListBox
    {
        private bool clickChecked = true;
        private bool isReadOnly = true;
        public bool IsReadOnly
        {
            get { return isReadOnly; }
            set { isReadOnly = value; }
        }

        private Type myEnum;
        public Type MyEnum
        {
            get { return this.myEnum; }
            set 
            {
                this.myEnum = value;

                this.Items.Clear();

                if (myEnum != null)
                {
                    // METHOD 2
                    foreach (string s in Enum.GetNames(myEnum))
                    {
                        int val = (int)Enum.Parse(myEnum, s);
                        MyListItem li = new MyListItem(s, val);
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

                foreach (MyListItem li in this.CheckedItems)
                {
                    eval += li.value;
                }
                
                return eval; 
            }
            set
            {
                for (int c = 0; c < this.Items.Count; c++)
                {
                    int eval = ((MyListItem)this.Items[c]).value;
                    this.SetItemChecked(c, (eval & value) != 0);
                }
            }
        }

        protected override void OnItemCheck(ItemCheckEventArgs e)
        {
            if (isReadOnly && clickChecked) e.NewValue = e.CurrentValue;
            clickChecked = true;
        }

        public new void SetItemChecked(int index, bool value)
        {
            clickChecked = false;
            base.SetItemChecked(index, value);
        }

        public MyBitFlags()
        {
            
        }

    }

    public struct MyListItem
    {
        public string text;
        public int value;
        public override string ToString()
        {
            return this.text;
        }
        public MyListItem(string text, int value)
        {
            this.text = text;
            this.value = value;
        }
    }

    internal class MyFlags
    {

        public enum InfoType
        {
            Proximity = 0,
            Information = 1,
            Traveling = 20
        }

        public enum InfoxType
        {
            Boy = 1,
            Girl = 2,
            MadCow = 4,
            MadPig = 8
        }
    }

}
