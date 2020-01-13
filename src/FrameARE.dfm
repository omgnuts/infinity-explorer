object AreaFrame: TAreaFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 270
  Align = alClient
  TabOrder = 0
  OnMouseMove = FrameMouseMove
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 443
    Height = 270
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 121
      BevelOuter = bvLowered
      TabOrder = 0
      DesignSize = (
        185
        121)
      object PaintBox1: TPaintBox
        Left = 1
        Top = 1
        Width = 183
        Height = 119
        Align = alClient
        OnMouseMove = PaintBox1MouseMove
        OnPaint = PaintBox1Paint
      end
      object lblCursorAt: TLabel
        Left = 5
        Top = 5
        Width = 6
        Height = 13
        Anchors = []
        Caption = '()'
        DragMode = dmAutomatic
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
    end
  end
end
