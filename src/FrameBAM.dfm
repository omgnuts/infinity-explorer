object BAMFrame: TBAMFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 66
    Height = 16
    Caption = 'Animations'
  end
  object lblAnims: TLabel
    Left = 112
    Top = 8
    Width = 46
    Height = 16
    Caption = '255/255'
  end
  object Label3: TLabel
    Left = 8
    Top = 32
    Width = 46
    Height = 16
    Caption = 'Frames'
  end
  object lblFrames: TLabel
    Left = 112
    Top = 32
    Width = 46
    Height = 16
    Caption = '255/255'
  end
  object Panel1: TPanel
    Left = 8
    Top = 56
    Width = 185
    Height = 41
    BevelOuter = bvLowered
    TabOrder = 0
    object PaintBox1: TPaintBox
      Left = 1
      Top = 1
      Width = 183
      Height = 39
      Align = alClient
      OnPaint = PaintBox1Paint
    end
  end
  object BtnPrevAnim: TButton
    Left = 88
    Top = 8
    Width = 17
    Height = 17
    Caption = '<'
    TabOrder = 1
    OnClick = BtnPrevAnimClick
  end
  object BtnPrevFrame: TButton
    Left = 88
    Top = 32
    Width = 17
    Height = 17
    Caption = '<'
    TabOrder = 2
    OnClick = BtnPrevFrameClick
  end
  object BtnNextAnim: TButton
    Left = 168
    Top = 8
    Width = 17
    Height = 17
    Caption = '>'
    TabOrder = 3
    OnClick = BtnNextAnimClick
  end
  object BtnNextFrame: TButton
    Left = 168
    Top = 32
    Width = 17
    Height = 17
    Caption = '>'
    TabOrder = 4
    OnClick = BtnNextFrameClick
  end
  object BtnPlay: TButton
    Left = 208
    Top = 8
    Width = 89
    Height = 41
    Caption = 'Play'
    TabOrder = 5
    OnClick = BtnPlayClick
  end
end
