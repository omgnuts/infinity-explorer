object WMapAreaFrame: TWMapAreaFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 443
    Height = 276
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Area'
      object Label3: TLabel
        Left = 8
        Top = 96
        Width = 45
        Height = 16
        Caption = 'Area ID'
      end
      object Label4: TLabel
        Left = 8
        Top = 128
        Width = 66
        Height = 16
        Caption = 'Area name'
      end
      object Label5: TLabel
        Left = 8
        Top = 64
        Width = 88
        Height = 16
        Caption = 'Location name'
      end
      object Label6: TLabel
        Left = 8
        Top = 160
        Width = 93
        Height = 16
        Caption = 'Loading screen'
      end
      object Label7: TLabel
        Left = 280
        Top = 96
        Width = 60
        Height = 16
        Caption = 'Icon index'
      end
      object Label8: TLabel
        Left = 280
        Top = 128
        Width = 36
        Height = 16
        Caption = 'Icon X'
      end
      object Label9: TLabel
        Left = 280
        Top = 160
        Width = 37
        Height = 16
        Caption = 'Icon Y'
      end
      object BAMIcon1: TBAMIcon
        Left = 424
        Top = 56
        Width = 105
        Height = 105
        Transparent = True
      end
      object Label10: TLabel
        Left = 32
        Top = 184
        Width = 41
        Height = 16
        Caption = 'Visible'
      end
      object Label11: TLabel
        Left = 136
        Top = 184
        Width = 50
        Height = 16
        Caption = 'Can visit'
      end
      object Label12: TLabel
        Left = 240
        Top = 184
        Width = 41
        Height = 16
        Caption = 'Visited'
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 409
        Height = 49
        Caption = 'World map'
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 24
          Width = 73
          Height = 16
          Caption = 'Background'
        end
        object Label2: TLabel
          Left = 216
          Top = 24
          Width = 32
          Height = 16
          Caption = 'Icons'
        end
        object EdtMapBackground: THyperlinkEdit
          Left = 112
          Top = 16
          Width = 89
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
          TabOrder = 0
          HyperlinkJumper = MainForm.Jumper
          FileType = ftMOS
        end
        object EdtMapIcons: THyperlinkEdit
          Left = 304
          Top = 16
          Width = 89
          Height = 24
          TabOrder = 1
          HyperlinkJumper = MainForm.Jumper
          FileType = ftBAM
        end
      end
      object EdtAreaID: THyperlinkEdit
        Left = 112
        Top = 88
        Width = 89
        Height = 24
        TabOrder = 2
        HyperlinkJumper = MainForm.Jumper
        FileType = ftAREA
      end
      object EdtAreaName: TEdit
        Left = 112
        Top = 120
        Width = 145
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object EdtLocationName: TEdit
        Left = 112
        Top = 56
        Width = 281
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object EdtLoadScreen: THyperlinkEdit
        Left = 112
        Top = 152
        Width = 89
        Height = 24
        TabOrder = 4
        HyperlinkJumper = MainForm.Jumper
        FileType = ftMOS
      end
      object EdtIconIndex: TEdit
        Left = 352
        Top = 88
        Width = 41
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 5
      end
      object EdtIconX: TEdit
        Left = 352
        Top = 120
        Width = 41
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 6
      end
      object EdtIconY: TEdit
        Left = 352
        Top = 152
        Width = 41
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 7
      end
      object chkVisible: TCheckBox
        Left = 8
        Top = 184
        Width = 17
        Height = 17
        Enabled = False
        TabOrder = 8
      end
      object chkCanVisit: TCheckBox
        Left = 112
        Top = 184
        Width = 17
        Height = 17
        Enabled = False
        TabOrder = 9
      end
      object chkVisited: TCheckBox
        Left = 216
        Top = 184
        Width = 17
        Height = 17
        Enabled = False
        TabOrder = 10
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Links'
      ImageIndex = 1
      object LinkGrid: THyperlinkGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 245
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 18
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnCanJump = LinkGridCanJump
        OnJump = LinkGridJump
        ColWidths = (
          90
          169
          109)
      end
    end
  end
end
