using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;

namespace InfinityXplorer.Core
{
    internal class TalkRefCollection : CollectionBase
    {
        public TalkRef this[int index]
        {
            get { return ((TalkRef)InnerList[index]); }
            set { InnerList[index] = value; }
        }

        public void SetCapacity(int capacity)
        {
            InnerList.Clear();
            InnerList.Capacity = capacity;
        }

        public int Add(TalkRef value)
        {
            return (InnerList.Add(value));
        }

        private int IndexOf(TalkRef value)
        {
            return (InnerList.IndexOf(value));
        }

        private void Insert(int index, TalkRef value)
        {
            InnerList.Insert(index, value);
        }

        private void Remove(TalkRef value)
        {
            InnerList.Remove(value);
        }

        private bool Contains(TalkRef value)
        {
            return (InnerList.Contains(value));
        }

        public string GetStringRef(int index)
        {
            if (index > 0)
            {
                return this[index].strText;
            }
            else
            {
                return "<NO TEXT>";
            }
        }
    }
}
