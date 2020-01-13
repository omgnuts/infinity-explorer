using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace TestCS
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            //myListBox1.MyEnum = typeof(MyFlags.InfoType);
            myBitFlags1.MyEnum = typeof(MyFlags.InfoxType);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FileStream f = new FileStream(textBox1.Text, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

            StringBuilder sb = new StringBuilder();

            int size = 1024;
            byte[] buff = new byte[1024];

            int sum = 0;

            while (sum < f.Length)
            {
                sb.Append(ReadBuff(f, 0, size));
                sum += size;
            }

            using (StreamWriter sw = new StreamWriter("bugger.txt", false, Encoding.ASCII))
            {
                sw.Write(sb.ToString());
                sw.Close();
            }
        }

        private static char[] ReadBuff(FileStream fileStream, 
            long offsetPos, int buffSize)
        {
            byte[] buff = new byte[buffSize];
            long fPos = fileStream.Position;

            fileStream.Position = offsetPos;
            fileStream.Read(buff, 0, buffSize);
            fileStream.Position = fPos;

            // Note that for multi-language, the encoding below would be better
            // Encoding.GetEncoding(1251).GetString(str); (1251 is English)
            return ASCIIEncoding.ASCII.GetChars(buff);
            //return CharsToString(ASCIIEncoding.ASCII.GetChars(buff));
            //return ASCIIEncoding.ASCII.GetString(buff); //, 0, buffSize);
        }

        private static string CharsToString(char[] chars)
        {
            return new string(chars).TrimEnd('\0');
        }

        private void button2_Click(object sender, EventArgs e)
        {
            int flag = 1;
            byte val = 2;
            
            bool result = (val & flag) != 0;

            Console.WriteLine(result);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            MessageBox.Show(myListBox1.EnumValue.ToString());
        }

        private void button4_Click(object sender, EventArgs e)
        {
            myListBox1.EnumValue = 20;
        }

        private void myBitFlags1_Click(object sender, EventArgs e)
        {
           
        }

        private void myBitFlags1_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            
        }

        private void button6_Click(object sender, EventArgs e)
        {
            myBitFlags1.EnumValue = 12;
        }

        private void button5_Click(object sender, EventArgs e)
        {
            MessageBox.Show(myBitFlags1.EnumValue.ToString());
        }

    }
}