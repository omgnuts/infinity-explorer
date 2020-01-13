using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal class DataGridList : DataGridView
    {
        public enum DataGridType
        {
            AreaItemGrid
        }

        private DataGridType dgType;
        public DataGridType DGType
        {
            get { return dgType; }
            set 
            { 
                dgType = value;
                switch (dgType)
                {
                    case DataGridType.AreaItemGrid:
                        this.MakeAreaItemColumns(); break;
                    default: break;
                }
            }
        }

        public DataGridList()
        {
            this.AllowUserToAddRows = false;
            this.AutoGenerateColumns = false;

            this.ColumnHeadersHeightSizeMode = System.Windows.Forms
                .DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.MultiSelect = false;
            this.ReadOnly = true;

            this.RowHeadersVisible = false;

        }
        
        private void MakeAreaItemColumns()
        {
            this.Columns.Clear();
            this.Columns.Add(MakeTextBoxColumn("ResRef", "ResItem", 70, true));
            this.Columns.Add(MakeTextBoxColumn("Expiry", "ItemExpiry", 40, true));
            this.Columns.Add(MakeTextBoxColumn("Val1", "PriCount", 40, true));
            this.Columns.Add(MakeTextBoxColumn("Val2", "SecCount", 40, true));
            this.Columns.Add(MakeTextBoxColumn("Val3", "TerCount", 40, true));
            this.Columns.Add(MakeCheckBoxColumn("NoID", "IsIdentified", 40, true));
            this.Columns.Add(MakeCheckBoxColumn("NoPik", "Unstealable", 40, true));
            this.Columns.Add(MakeCheckBoxColumn("NoDrp", "Undroppable", 40, true));
            this.Columns.Add(MakeCheckBoxColumn("Stolen", "IsStolen", 40, true));
        }

        private static DataGridViewColumn MakeTextBoxColumn(string name,
            string property, int width, bool visible)
        {
            return MakeColumn(new DataGridViewTextBoxColumn(),
                name, property, width, visible);
        }

        private static DataGridViewColumn MakeCheckBoxColumn(string name, 
            string property, int width, bool visible)
        {
            return MakeColumn(new DataGridViewCheckBoxColumn(), 
                name, property, width, visible); 
        }

        private static DataGridViewColumn MakeColumn(DataGridViewColumn col,
            string name, string property, int width, bool visible)
        {
            col.HeaderText = name;
            col.DataPropertyName = property;
            col.Width = width;
            col.Visible = visible;
            return col;
        }

    }
}
