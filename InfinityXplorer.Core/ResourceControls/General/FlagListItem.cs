using System;
using System.Collections.Generic;
using System.Text;

namespace InfinityXplorer.Core.ResourceControls.General
{
    internal class FlagListItem
    {
        private string text;
        private int enumValue;
        public int ToEnumValue()
        {
            return this.enumValue;
        }
        public override string ToString()
        {
            return this.text;
        }
        public FlagListItem(string text, int enumValue)
        {
            this.text = text;
            this.enumValue = enumValue;
        }
    }
}
