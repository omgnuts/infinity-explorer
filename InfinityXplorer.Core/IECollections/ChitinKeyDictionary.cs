using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;

namespace InfinityXplorer.Core
{
    internal class ChitinKeyDictionary
    {
        private int keyLength;
        private SortedDictionary<string, ChitinKey> Dictionary;

        public ChitinKeyDictionary(int keyLength)
        {
            this.keyLength = keyLength;
            Dictionary = new SortedDictionary<string, ChitinKey>();
        }

        public ChitinKey this[string key]
        {
            get 
            {
                if (Dictionary.ContainsKey(key))
                {
                    return ((ChitinKey)Dictionary[key]);
                }
                else
                {
                    return null;
                }
            }
            set { Dictionary[key] = value; }
        }

        public ICollection Keys
        {
            get { return (Dictionary.Keys); }
        }

        public ICollection Values
        {
            get { return (Dictionary.Values); }
        }

        public int Count
        {
            get { return Dictionary.Count; }
        }

        public void Add(string key, ChitinKey value)
        {
            if (OnValidate(key, value))
            {
                Dictionary.Add(key, value);
            }
        }

        public void AddCheckContain(string key, ChitinKey value)
        {
            // no validation here. cos this is used by Chitin ParseDirectory
            if (!Contains(key))
            {
                Dictionary.Add(key, value);
            }
        }

        public bool Contains(string key)
        {
            return (Dictionary.ContainsKey(key));
        }

        public void Remove(string key)
        {
            Dictionary.Remove(key);
        }

        public void Clear()
        {
            Dictionary.Clear();
        }

        private bool OnValidate(string key, ChitinKey value)
        {
            if (key.Length > keyLength)
            {
                throw new ArgumentException("key must be no more than " + keyLength.ToString() + " characters in length.", "key");
            }

            return true;

        }


    }
}
