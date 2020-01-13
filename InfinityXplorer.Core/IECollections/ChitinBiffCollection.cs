using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;

namespace InfinityXplorer.Core
{
    internal class ChitinBiffCollection : CollectionBase
    {
        public ChitinBiff this[int index]
        {
            get { return ((ChitinBiff)InnerList[index]); }
            set { InnerList[index] = value; }
        }

        public void SetCapacity(int capacity)
        {
            InnerList.Clear();
            InnerList.Capacity = capacity;
        }

        public int Add(ChitinBiff value)
        {
            return (InnerList.Add(value));
        }

        public int IndexOf(ChitinBiff value)
        {
            return (InnerList.IndexOf(value));
        }

        public void Insert(int index, ChitinBiff value)
        {
            InnerList.Insert(index, value);
        }

        public void Remove(ChitinBiff value)
        {
            InnerList.Remove(value);
        }

        public bool Contains(ChitinBiff value)
        {
            // If value is not of type Int16, this will return false.
            return (InnerList.Contains(value));
        }

    }
}
