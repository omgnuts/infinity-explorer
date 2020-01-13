object SaveGameFrame: TSaveGameFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  Align = alClient
  TabOrder = 0
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 443
    Height = 277
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 8
        Top = 48
        Width = 61
        Height = 16
        Caption = 'Party gold'
      end
      object Label2: TLabel
        Left = 8
        Top = 80
        Width = 73
        Height = 16
        Caption = 'Current area'
      end
      object Label3: TLabel
        Left = 8
        Top = 16
        Width = 65
        Height = 16
        Caption = 'Game time'
      end
      object EdtPartyGold: TEdit
        Left = 104
        Top = 40
        Width = 81
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object EdtArea: THyperlinkEdit
        Left = 104
        Top = 72
        Width = 121
        Height = 24
        TabOrder = 1
        HyperlinkJumper = MainForm.Jumper
        FileType = ftAREA
      end
      object EdtGameTime: TEdit
        Left = 104
        Top = 8
        Width = 121
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Variables'
      ImageIndex = 1
      object VarGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 246
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          277
          64)
      end
    end
    object KillVarsPage: TTabSheet
      Caption = 'Kill vars'
      ImageIndex = 2
      object KillVarGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 246
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          277
          64)
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Journal'
      ImageIndex = 3
      object JournalGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 246
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 18
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          74
          60
          275)
      end
    end
  end
end
