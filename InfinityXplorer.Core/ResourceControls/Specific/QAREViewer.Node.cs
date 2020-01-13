using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    /// <summary>
    /// QAREViewer.Node.cs is the partial class to handle events when 
    /// the nodes in QAREToolWin are double-clicked.
    /// </summary>
    internal partial class QAREViewer
    {
        private TabPage[] tabSet;

        private void InitializeTabs()
        {
            tabSet = new TabPage[areTabs.TabPages.Count];
            for (int c = 0; c < areTabs.TabPages.Count; c++)
            {
                tabSet[c] = areTabs.TabPages[c];
            }

        }
        
        public void LoadAreaElement(QARETreeView.NodeCode nodeCode, int id)
        {
            this.splitter.SuspendLayout();

            switch (nodeCode)
            {
                case QARETreeView.NodeCode.NodeBasic:
                    this.DisplayNodeBasic();
                    break;
                case QARETreeView.NodeCode.NodeActor:
                    this.DisplayNodeActor(id);
                    break;
                case QARETreeView.NodeCode.NodeAmbient:
                    this.DisplayNodeAmbient(id);
                    break;
                case QARETreeView.NodeCode.NodeAnim:
                    this.DisplayNodeAnim(id);
                    break;
                case QARETreeView.NodeCode.NodeContainer:
                    this.DisplayNodeContainer(id);
                    break;
                case QARETreeView.NodeCode.NodeDoor:
                    this.DisplayNodeDoor(id);
                    break;
                case QARETreeView.NodeCode.NodeEntrance:
                    this.DisplayNodeEntrance(id);
                    break;
                case QARETreeView.NodeCode.NodeInfoPt:
                    this.DisplayNodeInfoPt(id);
                    break;
                case QARETreeView.NodeCode.NodeMapnote:
                    this.DisplayNodeMapnote(id);
                    break;
                case QARETreeView.NodeCode.NodeProjectile:
                    this.DisplayNodeProjectile(id);
                    break;
                case QARETreeView.NodeCode.NodeSpawn:
                    this.DisplayNodeSpawn(id);
                    break;
                case QARETreeView.NodeCode.NodeVariable:
                    this.DisplayNodeVariable(id);
                    break;
                default:
                    MessageBox.Show("Error: Unknown Area Element");
                    break;
            }

            if ((int)nodeCode < tabSet.Length)
            {
                if (!areTabs.TabPages.Contains(tabSet[(int)nodeCode]))
                {
                    areTabs.TabPages.Add(tabSet[(int)nodeCode]);
                    
                }

                if (this.Height - splitter.SplitterDistance < 100)
                {
                    if (this.Height > 310)
                        splitter.SplitterDistance = this.Height - 310;
                    else
                        splitter.SplitterDistance = this.Height / 2;
                    splitter.Refresh();
                }
                
                areTabs.SelectedTab = tabSet[(int)nodeCode];

                splitter.Panel2Collapsed = false;
            }

            this.splitter.ResumeLayout(true);
        }

        private void DisplayNodeBasic()
        {
            nBasicLinkScript.LinkText = areFile.GetName();
            nBasicLinkNorth.LinkText = areFile.resNorth;
            nBasicLinkWest.LinkText = areFile.resWest;
            nBasicLinkEast.LinkText = areFile.resEast;
            nBasicLinkSouth.LinkText = areFile.resSouth;

            nBasicTxtRain.Text = areFile.probRain.ToString();
            nBasicTxtSnow.Text = areFile.probSnow.ToString();
            nBasicTxtFog.Text = areFile.probFog.ToString();
            nBasicTxtLightning.Text = areFile.probLightning.ToString();

            nBasicFbitFlags.EnumValue = areFile.areaFlag;
            nBasicFbitType.EnumValue = areFile.areaTypeFlag;
        }

        private void DisplayNodeActor(int id)
        {
            ResourceClass.QAREFile.ActorStruct actor = areFile.actorList[id];
            nActorTxtFullName.Text = actor.fullName;
            nActorFboxFacing.EnumValue = actor.facing;
            nActorTxtAnimation.Text = actor.animation.ToString();
            nActorCkboxIsSpawned.Checked = Convert.ToBoolean(actor.isSpawned);
            
            nActorXYPos.ValXPoint = actor.location;
            nActorXYDest.ValXPoint = actor.destination;
            nActorLinkCreFile.LinkText = actor.resCREFile;
            nActorLinkDialog.LinkText = actor.resDLGFile;
            nActorLinkScript.LinkText = actor.resScriptBCS;
            nActorLinkGeneral.LinkText = actor.resMiscBCS;
            nActorLinkClass.LinkText = actor.resClassBCS;
            nActorLinkRace.LinkText = actor.resRaceBCS;
            nActorLinkDefault.LinkText = actor.resDefaultBCS;
            nActorLinkSpecific.LinkText = actor.resSpecificBCS;

            nActorFbitFlags.EnumValue = actor.flags;
            nActorFbitAppearTime.EnumValue = actor.timeAppear;

        }

        private void DisplayNodeAmbient(int id)
        {

        }

        private void DisplayNodeAnim(int id)
        {

        }

        private void DisplayNodeContainer(int id)
        {
            ResourceClass.QAREFile.ContainerStruct conr = areFile.containerList[id];

            nConrTxtFullName.Text = conr.fullName;
            nConrFboxType.EnumValue = conr.type;
            nConrFbitFlags.EnumValue = conr.flags;

            if (conr.itemList.Length > 0)
            {
                nConrDgridItems.DataSource = conr.itemList;
            }
            else
            {
                nConrDgridItems.DataSource = null;
            }
            //textBox1.Text = "";
            //
            //foreach (ResourceClass.QAREFile.ItemStruct item in conr.itemList)
            //{
            //    textBox1.Text = textBox1.Text + item.resItem + Environment.NewLine;
            //}
        }

        private void DisplayNodeDoor(int id)
        {

        }

        private void DisplayNodeEntrance(int id)
        {
            ResourceClass.QAREFile.EntranceStruct entrance = areFile.entranceList[id];
            nEntranceTxtFullName.Text = entrance.fullName;
            nEntranceFboxFacing.EnumValue = entrance.direction;
            nEntranceXYLoc.ValXPoint = entrance.location;
        }

        private void DisplayNodeInfoPt(int id)
        {
            ResourceClass.QAREFile.InfoptStruct infopt = areFile.infoptList[id];
            nInfoptTxtFullName.Text = infopt.fullName;
            nInfoptTxtCursor.Text = infopt.cursorIcon.ToString();
            nInfoptFboxType.EnumValue = infopt.type; 

            nInfoptTxtDesc.Text = ApplicationRuntime.TalkIndex.TrefCollection.GetStringRef(infopt.srInfoptIndex);
            nInfoptLinkNextArea.LinkText = infopt.destName;
            nInfoptXYEntry.ValXPoint = infopt.altPoint; //??
            
            nInfoptLinkScript.LinkText = infopt.resBCS;
            nInfoptLinkDialog.LinkText = infopt.resDialog;
            nInfoptLinkKey.LinkText = infopt.resITMKey;
            nInfoptCkboxIsTrapped.Checked = Convert.ToBoolean(infopt.isTrapped);
            nInfoptCkboxIsDetected.Checked = Convert.ToBoolean(infopt.isDetected);
            nInfoptTxtDetectDiff.Text = infopt.trapDetect.ToString();
            nInfoptTxtRemoveDiff.Text = infopt.trapRemove.ToString();

            nInfoptFbitFlags.EnumValue = infopt.flags;
        }

        private void DisplayNodeMapnote(int id)
        {

        }

        private void DisplayNodeProjectile(int id)
        {

        }

        private void DisplayNodeSpawn(int id)
        {

        }

        private void DisplayNodeVariable(int id)
        {

        }

    }
}
