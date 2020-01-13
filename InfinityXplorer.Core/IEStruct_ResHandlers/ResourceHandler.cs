using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core
{
    internal static class ResourceHandler
    {
        private static ResourceClass.ResourceCollection cache = 
            new ResourceClass.ResourceCollection();

        public static ResourceClass.IResource LoadResourceFile(ChitinKey ckey,
            ResourceStruct.DelegateResourceFileReader resourceFileReader)
        {
            return LoadResourceFile(false, false, ckey, resourceFileReader);
        }

        // In cases when you want to do the link thing. Then this becomes important
        // as you only have the name and the resourceType to find that ckey and load it
        public static ResourceClass.IResource LoadResourceFile(string ckeyName,
            ResourceStruct.ResourceType resourceType)
        {
            // used for wed/tis files when loading ARE file
            return LoadResourceFile(false, false, ckeyName, resourceType);
        }

        public static ResourceClass.IResource LoadResourceHeader(string ckeyName,
            ResourceStruct.ResourceType resourceType)
        {
            // used for itm header loads when loading containers in ARE files. 
            return LoadResourceFile(false, true, ckeyName, resourceType);
        }

        private static ResourceClass.IResource LoadResourceFile(bool refresh, bool headerOnly,
            string ckeyName, ResourceStruct.ResourceType resourceType)
        {
            ChitinKey ckey =
                (ApplicationRuntime.ChitinIndex.CkeyDictionary[resourceType])[ckeyName];

            if (ckey == null) return null;

            ResourceStruct.ResInfo rInfo =
                ResourceStruct.OrderedListNames[ckey.resourceType];

            return LoadResourceFile(refresh, headerOnly, ckey, rInfo.resourceFileReader);
        }

        private static ResourceClass.IResource LoadResourceFile(bool refresh, bool headerOnly, 
            ChitinKey ckey, ResourceStruct.DelegateResourceFileReader resourceFileReader)
        {
            ResourceClass.IResource irFile;

            if (refresh)
            {
                // clear the cache copy if it exists, especially during edits.
                cache.RemoveFromCache(ckey.name, ckey.resourceType);
            }
            else
            {
                // check if in cache, then retrieve the cache version
                irFile = cache.IsCached(ckey.name, ckey.resourceType);
                if (irFile != null) return irFile;
            }

            irFile = FileReader.ReadIResourceFile(headerOnly, ckey, resourceFileReader);
            if (irFile != null)
            {
                if ((irFile.ResourceType() != ResourceStruct.ResourceType.RTypeGTIS)
                    && (irFile.ResourceType() != ResourceStruct.ResourceType.RTypeGWED))
                {
                    if (!headerOnly) cache.PushInCache(irFile);
                }

                return irFile;
            }
            else
            {
                return null;            
            }
        }

    }
}
