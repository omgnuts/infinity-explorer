using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Windows.Forms;

namespace InfinityXplorer.Core.ResourceControls
{
    internal partial class QAREViewer
    {
        private Image baseImage = null;
        private bool refreshMap = false;
        private ushort currBright = 50;

        private void ReDrawAreaMapRectangle()
        {
            if ((baseImage != null) && (!ApplicationRuntime.AppParams.HighMemoryUsage))
            {
                this.DrawAreaMapRectangle();
                this.DrawGraphicLayer();
            }
        }

        private void DrawAreaMapRectangle()
        {
            this.DrawVisibleMapRectangle(wedFile.overlayList[0], 0);
            refreshMap = false;
        }

        // baselayer index = 0
        private void DrawVisibleMapRectangle(ResourceClass.GWEDFile.OverlayStruct baseLayer, int tileRefIndex) 
        {
            ushort tilePixel = 64;

            if (baseImage == null)
            {
                baseImage = new Bitmap(baseLayer.xtile * tilePixel, baseLayer.ytile * tilePixel, 
                    PixelFormat.Format24bppRgb);
            }

            baseImage = (Image)tisFile.CreateTileLayerImage((Bitmap)baseImage, baseLayer.tileMaps,
                tileRefIndex, CalculateTileRect(baseLayer, tilePixel), tilePixel, currBright);

            this.picAreaMap.Image = baseImage;
        }

        private TileRect CalculateTileRect(ResourceClass.GWEDFile.OverlayStruct baseLayer, ushort tilePixel)
        {
            TileRect tileRect = new TileRect();

            if (ApplicationRuntime.AppParams.HighMemoryUsage)
            {
                tileRect.minX = 0;
                tileRect.maxX = baseLayer.xtile;
                tileRect.minY = 0;
                tileRect.maxY = baseLayer.ytile;
            }
            else
            {
                double minX = Math.Abs(this.picAreaMap.DisplayRectangle.Left);
                double maxX = minX + this.picAreaMap.ClientSize.Width;
                double minY = Math.Abs(this.picAreaMap.DisplayRectangle.Top);
                double maxY = minY + this.picAreaMap.ClientSize.Height;

                tileRect.minX = (ushort)Math.Floor(minX / tilePixel);
                tileRect.maxX = (ushort)Math.Ceiling(maxX / tilePixel);
                tileRect.minY = (ushort)Math.Floor(minY / tilePixel);
                tileRect.maxY = (ushort)Math.Ceiling(maxY / tilePixel);

                int diff = tileRect.maxX - baseLayer.xtile;
                if (diff > 0)
                {
                    tileRect.minX = (ushort)(tileRect.minX - diff < 0 ? 0 : tileRect.minX - diff);
                    tileRect.maxX = baseLayer.xtile;
                }

                diff = tileRect.maxY - baseLayer.ytile;
                if (diff > 0)
                {
                    tileRect.minY = (ushort)(tileRect.minY - diff < 0 ? 0 : tileRect.minY - diff);
                    tileRect.maxY = baseLayer.ytile;
                }
            }

            return tileRect;
        }

        private int MinimumOf(int a, int b)
        {
            if (a < b) return a;
            return b;
        }

        public void BrightenAreaMap(int brightVal)
        {
            int brightChange = brightVal - currBright;

            if (brightChange != 0)
            {
                currBright = (ushort)brightVal;

                if (ApplicationRuntime.AppParams.HighMemoryUsage)
                {
                    this.picAreaMap.Image = (Image)Utils.BrightenLayer24bpp((Bitmap)baseImage, brightChange);
                }
                else
                {
                    this.ReDrawAreaMapRectangle();
                }
            }
        }

        private void DrawGraphicLayer()
        {

            refreshMap = true;
        }

        private Image DrawOnBaseLayer()
        {
            Image editImage = (Image)baseImage.Clone();
            Graphics editor = Graphics.FromImage(editImage);

            System.Drawing.Pen myPen = new System.Drawing.Pen(System.Drawing.Color.Red);
            editor.DrawEllipse(myPen, new Rectangle(0, 0, 200, 300));

            myPen.Dispose();
            editor.Dispose();

            return editImage;
        }

    }
}
