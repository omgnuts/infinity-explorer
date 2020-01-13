using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;

namespace InfinityXplorer.Core
{
    /// Simple readonly super dictionary for chitinkey dictionary

    internal class ChitinKeySuperDictionary : DictionaryBase
    {
        public ChitinKeySuperDictionary(int keyLength)
        {
            foreach (ResourceStruct.ResourceType rt in 
                Enum.GetValues(typeof(ResourceStruct.ResourceType)))
            {
                this.Build(rt, keyLength);
            }

        }

        public ChitinKeyDictionary this[ResourceStruct.ResourceType key]
        {
            get { return (ChitinKeyDictionary)Dictionary[key]; }
        }

        public ICollection Keys 
        {
            get { return (Dictionary.Keys); }
        }

        public ICollection Values
        {
            get { return (Dictionary.Values); }
        }

        public new void Clear()
        {
            foreach (ChitinKeyDictionary c in Values)
            {
                ((ChitinKeyDictionary)c).Clear();
            }
        }

        public void Add(string key, ChitinKey chitinKey, ResourceStruct.ResourceType resourceType)
        {
            ChitinKeyDictionary ck = (ChitinKeyDictionary)Dictionary[resourceType];
            
            // Build the tree node here
            ck.Add(key, chitinKey);
        }
        
        private void Build(ResourceStruct.ResourceType key, int keyLength)
        {
            Dictionary.Add(key, new ChitinKeyDictionary(keyLength));
        }

        protected override void OnValidate(Object key, Object value)
        {
            if (key.GetType() != typeof(ResourceStruct.ResourceType))
            {
                throw new ArgumentException("key must be of type ResourceStruct.ResourceType.", "key");
            }

            if (value.GetType() != typeof(ChitinKeyDictionary))
            {
                throw new ArgumentException("value must be of type ChitinKeyDictionary.", "value");
            }
        }


    }
}
