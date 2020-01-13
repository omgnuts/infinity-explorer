object BMPFrame: TBMPFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 443
    Height = 276
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 257
      Height = 209
      BevelOuter = bvLowered
      TabOrder = 0
      object PaintBox1: TPaintBox
        Left = 1
        Top = 1
        Width = 255
        Height = 207
        Align = alClient
        OnPaint = PaintBox1Paint
      end
    end
  end
end
