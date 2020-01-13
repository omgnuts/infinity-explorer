using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI.Docking;

namespace InfinityXplorer.Core.ResourceControls
{
    internal class QARETreeView : TreeView
    {
        private ResourceClass.QAREFile areFile;
        private TreeNode[] areaNodes;
        private QAREViewer areViewer;

        // NodeCode = Elements Types in the Area Map file
        public enum NodeCode
        {
            NodeBasic       = 0,
            NodeActor       = 1,
            NodeInfoPt      = 2,
            NodeEntrance    = 3,
            NodeContainer   = 4,
            NodeDoor        = 5,
            NodeSpawn       = 6,

            NodeAmbient     = 7,
            NodeProjectile  = 8,
            NodeAnim        = 9,

            NodeVariable    = 10,
            NodeMapnote     = 11
        }

        // Add the main level of nodes when the control is instantiated.
        public QARETreeView()
        {
            areaNodes = new TreeNode[12];

            areaNodes[(int)NodeCode.NodeBasic] = new QARETreeNode("Basic Area Info", 0, 0, NodeCode.NodeBasic);

            areaNodes[(int)NodeCode.NodeActor] = new QARETreeNode("NPC Actors", 1, 2, NodeCode.NodeActor);
            areaNodes[(int)NodeCode.NodeInfoPt] = new QARETreeNode("Info Points", 1, 2, NodeCode.NodeInfoPt);
            areaNodes[(int)NodeCode.NodeEntrance] = new QARETreeNode("Entrances/Exits", 1, 2, NodeCode.NodeEntrance);
            areaNodes[(int)NodeCode.NodeContainer] = new QARETreeNode("Containers", 1, 2, NodeCode.NodeContainer);
            areaNodes[(int)NodeCode.NodeDoor] = new QARETreeNode("Doors", 1, 2, NodeCode.NodeDoor);
            areaNodes[(int)NodeCode.NodeSpawn] = new QARETreeNode("Mob Spawns", 1, 2, NodeCode.NodeSpawn);

            // Store references the area stuff 
            areaNodes[(int)NodeCode.NodeAmbient] = new QARETreeNode("Ambient", 1, 2, NodeCode.NodeAmbient);
            areaNodes[(int)NodeCode.NodeProjectile] = new QARETreeNode("Projectiles", 1, 2, NodeCode.NodeProjectile);
            areaNodes[(int)NodeCode.NodeAnim] = new QARETreeNode("Animations", 1, 2, NodeCode.NodeAnim);

            areaNodes[(int)NodeCode.NodeVariable] = new QARETreeNode("Variables", 3, 4, NodeCode.NodeVariable);
            areaNodes[(int)NodeCode.NodeMapnote] = new QARETreeNode("Map Notes", 3, 4, NodeCode.NodeMapnote);

        }
        
        public void Initialize(QAREViewer areViewer)
        {
            this.areViewer = areViewer; 
        }

        public void Load(ResourceClass.QAREFile areFile)
        {
            this.areFile = areFile;
            this.PopulateTreeView();
        }

        private void PopulateTreeView()
        {
            base.Nodes.Clear();

            base.Nodes.Add(areaNodes[0]); // Basic Area Info

            for (int c = 1; c < areaNodes.Length; c++)
            {
                areaNodes[c].Nodes.Clear();
                this.PopulateTreeNode((QARETreeNode)areaNodes[c]);
                if (areaNodes[c].Nodes.Count > 0) base.Nodes.Add(areaNodes[c]);
            }
        }

        private void PopulateTreeNode(QARETreeNode node)
        {
            NodeCode code = node.NodeCode;

            switch (code)
            {
                case NodeCode.NodeActor:
                    ResourceClass.QAREFile.ActorStruct[] actors = areFile.actorList;
                    for (int c = 0; c < actors.Length; c++)
                        node.Nodes.Add(new QARETreeNode(actors[c].fullName, code, c));
                    break;
                case NodeCode.NodeAmbient:
                    ResourceClass.QAREFile.AmbientStruct[] ambients = areFile.ambientList;
                    for (int c = 0; c < ambients.Length; c++)
                        node.Nodes.Add(new QARETreeNode(ambients[c].fullName, code, c));
                    break;
                case NodeCode.NodeAnim:
                    ResourceClass.QAREFile.AnimStruct[] anims = areFile.animList;
                    for (int c = 0; c < anims.Length; c++)
                        node.Nodes.Add(new QARETreeNode(anims[c].fullName, code, c));
                    break;
                case NodeCode.NodeContainer:
                    ResourceClass.QAREFile.ContainerStruct[] containers = areFile.containerList;
                    for (int c = 0; c < containers.Length; c++)
                        node.Nodes.Add(new QARETreeNode(containers[c].fullName, code, c));
                    break;
                case NodeCode.NodeDoor:
                    ResourceClass.QAREFile.DoorStruct[] doors = areFile.doorList;
                    for (int c = 0; c < doors.Length; c++)
                        node.Nodes.Add(new QARETreeNode(doors[c].fullName, code, c));
                    break;
                case NodeCode.NodeEntrance:
                    ResourceClass.QAREFile.EntranceStruct[] entrances = areFile.entranceList;
                    for (int c = 0; c < entrances.Length; c++)
                        node.Nodes.Add(new QARETreeNode(entrances[c].fullName, code, c));
                    break;
                case NodeCode.NodeInfoPt:
                    ResourceClass.QAREFile.InfoptStruct[] infopts = areFile.infoptList;
                    for (int c = 0; c < infopts.Length; c++)
                        node.Nodes.Add(new QARETreeNode(infopts[c].fullName, code, c));
                    break;
                case NodeCode.NodeMapnote:
                    ResourceClass.QAREFile.MapNoteStruct[] mapNotes = areFile.mapNoteList;
                    for (int c = 0; c < mapNotes.Length; c++)
                        node.Nodes.Add(new QARETreeNode("Note", code, c));
                    break;
                case NodeCode.NodeProjectile:
                    ResourceClass.QAREFile.ProjectileStruct[] projectiles = areFile.projectileList;
                    for (int c = 0; c < projectiles.Length; c++)
                        node.Nodes.Add(new QARETreeNode(projectiles[c].resProjectile, code, c));
                    break;
                case NodeCode.NodeSpawn:
                    ResourceClass.QAREFile.SpawnStruct[] spawns = areFile.spawnList;
                    for (int c = 0; c < spawns.Length; c++)
                        node.Nodes.Add(new QARETreeNode(spawns[c].fullName, code, c));
                    break;
                case NodeCode.NodeVariable:
                    ResourceClass.QAREFile.VariableStruct[] variables = areFile.varList;
                    for (int c = 0; c < variables.Length; c++)
                        node.Nodes.Add(new QARETreeNode(variables[c].varName, code, c));
                    break;
                default:
                    MessageBox.Show("Error: Unknown Area Element");
                    break;
            }
        }

        protected override void OnNodeMouseDoubleClick(TreeNodeMouseClickEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                // ... 
            }

            base.OnNodeMouseDoubleClick(e);
        }

        protected override void OnNodeMouseClick(TreeNodeMouseClickEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                //QARETreeNode node = (QARETreeNode)e.Node;
                //if ((node.Id > -1) || (node.NodeCode == NodeCode.NodeBasic)) // not base nodes
                //{
                //    areViewer.LoadAreaElement(node.NodeCode, node.Id);
                //}
            }

            base.OnNodeMouseClick(e);
        }


        protected override void OnAfterSelect(TreeViewEventArgs e)
        {
            QARETreeNode node = (QARETreeNode)e.Node;
            if ((node.Id > -1) || (node.NodeCode == NodeCode.NodeBasic)) // not base nodes
            {
                areViewer.LoadAreaElement(node.NodeCode, node.Id);
            }

            base.OnAfterSelect(e);
        }


    }
}
