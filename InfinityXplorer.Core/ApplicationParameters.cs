using System;
using System.Collections.Generic;
using System.Text;

namespace InfinityXplorer.Core
{
    internal sealed class ApplicationParameters
    {
        private string stringParam = "defaultString";
        public string StringParam
        {
            get { return stringParam; }
            set { stringParam = value; }
        }

        private bool highMemoryUsage = false;
        public bool HighMemoryUsage
        {
            get { return highMemoryUsage; }
        }

        public ApplicationParameters()
        {
            ParamInitialization();
        }

        private void ParamInitialization()
        {
            //m_ClusterPlugins.Add(new IPluginKey("KMeans", "KMeans", "NuconNET.Plugins.Clusters.KMeans", "NuconNET.Plugins.Clusters.KMeans"));
            //m_ClusterPlugins.Add(new IPluginKey("Kohonen", "Kohonen", "NuconNET.Plugins.Clusters.Kohonen", "NuconNET.Plugins.Clusters.Kohonen"));

            //m_MemberPlugins.Add(new IPluginKey("Triangular", "Triangular", "NuconNET.Plugins.Members.Triangular", "NuconNET.Plugins.Members.Triangular"));
            //m_MemberPlugins.Add(new IPluginKey("Trapezoidal", "Trapezoidal", "NuconNET.Plugins.Members.Trapezoidal", "NuconNET.Plugins.Members.Trapezoidal"));
            //m_MemberPlugins.Add(new IPluginKey("Gaussian", "Gaussian", "NuconNET.Plugins.Members.Gaussian", "NuconNET.Plugins.Members.Gaussian"));

            //m_NeuroPlugins.Add(new IPluginKey("NuconNET", "NuconNET", "NuconNET.Plugins.Neuro.NuconNET", "NuconNET.Plugins.Neuro.NuconNET"));
            //m_NeuroPlugins.Add(new IPluginKey("StefCon", "StefCon", "NuconNET.Plugins.Neuro.StefCon", "NuconNET.Plugins.Neuro.StefCon"));

        }

    }
}
