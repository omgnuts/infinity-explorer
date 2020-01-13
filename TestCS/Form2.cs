using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace TestCS
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();


            richTextBox1.ParseLinkMatch();
            //richTextBox1.ParseLinks(richTextBox1.Text, matches);
            //richTextBox1.SelectedText = "your own arbitrary links in the text: ";
            //richTextBox1.InsertLink("Link with arbitrary textcece");
            //richTextBox1.SelectedText = ".\nYou are not limited to the standard protocols any more,\n";
            //richTextBox1.SelectedText = "but you can still use them, of course: ";
            //richTextBox1.InsertLink("http://www.codeproject.com");
            //richTextBox1.SelectedText = "\n\nThe new links fire the LinkClicked event, just like the standard\n";
            //richTextBox1.SelectedText = "links do when AutoDetectUrls is set.\n\n";
            //richTextBox1.SelectedText = "Managing hyperlinks independent of link text is possible as well: ";
            //richTextBox1.InsertLink("Link text");
            //richTextBox1.SelectedText = "\n\nManaging hyperlinks";
            
        }
        
        private void richTextBox1_LinkClicked(object sender, System.Windows.Forms.LinkClickedEventArgs e)
        {
            MessageBox.Show("A link has been clicked.\nThe link text is '" + e.LinkText + "'");
            
        }
    }
}