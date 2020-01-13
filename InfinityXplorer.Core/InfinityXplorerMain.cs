using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace InfinityXplorer.Core
{
    static class InfinityXplorerMain
    {
        private static bool debugMode = true;

        private static string[] commandLineArgs = null;
        public static string[] CommandLineArgs
        {
            get { return commandLineArgs; }
        }

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            try
            {
                Run(args);
            }
            catch (Exception ex1)
            {
                throwStupidErrors(ex1.ToString());

                try
                {
                    HandleMainException(ex1);
                }
                catch (Exception ex2)
                {
                    throwStupidErrors(ex2.ToString());
                }
            }
            finally
            {
                Application.Exit();
            }
        }

        static void HandleMainException(Exception ex1)
        {
            try
            {
                // Do somethings and try to run the application again. 
                // Application.Run(new ExceptionBox(ex, "Unhandled exception terminated NuconNET", true));
            }
            catch (Exception ex2)
            {
                throwStupidErrors(ex2.ToString());
            }
        }

        static void Run(string[] args)
        {
            commandLineArgs = args;

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            try
            {
                RunApplication();
            }
            finally
            {
                // Dispose of any objects if need be
            }
        }

        static void RunApplication()
        {
            try
            {
                // Initialize directories/startup files

                ApplicationRuntime.RunWorkbench();

            }
            finally
            {
                // Leaving RunApplication();
                // Dispose of any objects if need be
            }
        }

        static void throwStupidErrors(string s)
        {
            if (debugMode)
            {
                Console.WriteLine(Environment.NewLine);
                Console.WriteLine(Environment.NewLine);
                Console.WriteLine(Environment.NewLine);
                Console.WriteLine(s);
                MessageBox.Show("Error: See console box!");
            }
            else
            {
                MessageBox.Show(s);
            }
        }

    }
}