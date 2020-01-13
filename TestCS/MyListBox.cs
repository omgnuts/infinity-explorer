using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;

namespace TestCS
{

    internal class MyListBox : ComboBox
    {        
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
                    // METHOD 1
                    //Array arr = System.Enum.GetValues(myEnum);
                    //for (int i = arr.GetLowerBound(0); i <= arr.GetUpperBound(0); i++)
                    //{
                    //    string txt = Enum.GetName(myEnum, arr.GetValue(i));
                    //    int nval = (int)arr.GetValue(i);

                    //    MyListItem li = new MyListItem(txt, nval);

                    //    this.Items.Add(li);
                    //}

                    // METHOD 2
                    foreach (string s in Enum.GetNames(myEnum))
                    {
                        int val = (int)Enum.Parse(myEnum, s);
                        MyListItem li = new MyListItem(s, val);
                        this.Items.Add(li);
                    }

                    // METHOD 3

                    //ArrayList arr = new ArrayList();
                    //foreach (string s in Enum.GetNames(myEnum))
                    //{
                    //    int val = (int)Enum.Parse(myEnum, s);
                    //    arr.Add(new MyListItem(s, val));
                    //}
                    //requires arr to use IList interface
                    //this.DataSource = arr;
                    //this.DisplayMember = "Text";
                    //this.ValueMember = "Value";

                }
            }
        }

        public int EnumValue
        {
            get
            {
                if (this.SelectedItem != null)
                    return ((MyListItem)this.SelectedItem).value;
                else
                    return -1;
            }
            set
            {
                foreach (MyListItem li in this.Items)
                {
                    if (li.value == value)
                    {
                        this.SelectedItem = li;
                        break;
                    }
                }
            }
        }

        public MyListBox()
        {

        }
    }

}
