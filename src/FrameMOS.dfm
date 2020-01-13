object MOSFrame: TMOSFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  OnMouseMove = FrameMouseMove
  object LblSize: TLabel
    Left = 8
    Top = 8
    Width = 26
    Height = 16
    Caption = 'Size'
  end
  object lblCursorAt: TLabel
    Left = 112
    Top = 8
    Width = 53
    Height = 16
    Caption = 'Cursor at'
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 31
    Width = 443
    Height = 245
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    TabOrder = 0
    OnMouseMove = FrameMouseMove
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 97
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      object PaintBox1: TPaintBox
        Left = 1
        Top = 1
        Width = 183
        Height = 95
        Align = alClient
        OnMouseMove = PaintBox1MouseMove
        OnPaint = PaintBox1Paint
      end
    end
  end
end
