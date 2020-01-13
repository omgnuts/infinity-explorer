using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core
{
    internal class IXExplorerDictionary : DictionaryBase
    {
        public IXExplorer this[ResourceStruct.ResourceType key]
        {
            get { return (IXExplorer)Dictionary[key]; }
        }

        public ICollection Keys
        {
            get { return (Dictionary.Keys); }
        }

        public ICollection Values
        {
            get { return (Dictionary.Values); }
        }

        private void Build(string name, ResourceStruct.ResourceType resourceType, 
            ChitinKeyDictionary ckeyDictionary)
        {
            IXExplorer explorer = new IXExplorer(name, resourceType, ckeyDictionary);
            Dictionary.Add(resourceType, explorer);
        }

        protected override void OnValidate(Object key, Object value)
        {
            if (key.GetType() != typeof(ResourceStruct.ResourceType))
            {
                throw new ArgumentException("key must be of type ResourceStruct.ResourceType.", "key");
            }

            if (value.GetType() != typeof(IXExplorer))
            {
                throw new ArgumentException("value must be of type IXExplorer.", "value");
            }
        }

        public IXExplorerDictionary(ChitinKeySuperDictionary ckeyDict)
        {
            foreach (KeyValuePair<ResourceStruct.ResourceType, ResourceStruct.ResInfo> kvp 
                in ResourceStruct.OrderedListNames)
            {
                this.Build(kvp.Value.name, kvp.Key, ckeyDict[kvp.Key]);
            }

        }
    }
}
