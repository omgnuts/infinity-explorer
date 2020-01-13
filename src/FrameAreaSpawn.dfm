object AreaSpawnFrame: TAreaSpawnFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 123
  Align = alBottom
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 113
    Caption = 'Creatures'
    TabOrder = 0
    object CreGrid: THyperlinkGrid
      Left = 8
      Top = 24
      Width = 169
      Height = 81
      ColCount = 1
      DefaultRowHeight = 18
      FixedCols = 0
      FixedRows = 0
      TabOrder = 0
      OnCanJump = CreGridCanJump
      OnJump = CreGridJump
      ColWidths = (
        145)
    end
  end
end
