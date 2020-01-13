object ITMFrame: TITMFrame
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
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Description'
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 37
        Height = 16
        Caption = 'Name'
      end
      object Image1: TBAMIcon
        Left = 344
        Top = 8
        Width = 105
        Height = 65
        Transparent = True
      end
      object Label12: TLabel
        Left = 8
        Top = 80
        Width = 41
        Height = 16
        Caption = 'Picture'
      end
      object lblPictureCarried: TLabel
        Left = 256
        Top = 112
        Width = 86
        Height = 16
        Caption = 'Picture carried'
      end
      object Label14: TLabel
        Left = 8
        Top = 112
        Width = 86
        Height = 16
        Caption = 'Picture ground'
      end
      object Label28: TLabel
        Left = 8
        Top = 144
        Width = 79
        Height = 16
        Caption = 'Used up item'
      end
      object Label30: TLabel
        Left = 256
        Top = 144
        Width = 70
        Height = 16
        Caption = 'Inventory ID'
      end
      object Label32: TLabel
        Left = 8
        Top = 48
        Width = 55
        Height = 16
        Caption = 'Category'
      end
      object EdtName: TEdit
        Left = 112
        Top = 8
        Width = 209
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object grpDescription: TGroupBox
        Left = 0
        Top = 168
        Width = 435
        Height = 77
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Description'
        TabOrder = 7
        object MemDesc: TMemo
          Left = 8
          Top = 24
          Width = 417
          Height = 42
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = clBtnFace
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object EdtPicture: THyperlinkEdit
        Left = 112
        Top = 72
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 2
        HyperlinkJumper = MainForm.Jumper
        FileType = ftBAM
      end
      object EdtPictureCarried: THyperlinkEdit
        Left = 360
        Top = 104
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 5
        HyperlinkJumper = MainForm.Jumper
        FileType = ftBAM
      end
      object EdtPictureGround: THyperlinkEdit
        Left = 112
        Top = 104
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 3
        HyperlinkJumper = MainForm.Jumper
        FileType = ftBAM
      end
      object EdtUsedUp: THyperlinkEdit
        Left = 112
        Top = 136
        Width = 121
        Height = 24
        TabOrder = 4
        HyperlinkJumper = MainForm.Jumper
        FileType = ftITM
      end
      object EdtInventoryID: TEdit
        Left = 360
        Top = 136
        Width = 41
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 6
      end
      object EdtCategory: TEdit
        Left = 112
        Top = 40
        Width = 209
        Height = 24
        Color = clBtnFace
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Statistics'
      ImageIndex = 1
      object Label2: TLabel
        Left = 8
        Top = 16
        Width = 31
        Height = 16
        Caption = 'Price'
      end
      object Label3: TLabel
        Left = 8
        Top = 48
        Width = 42
        Height = 16
        Caption = 'Weight'
      end
      object Label4: TLabel
        Left = 8
        Top = 80
        Width = 73
        Height = 16
        Caption = 'Max in stack'
      end
      object Label5: TLabel
        Left = 8
        Top = 112
        Width = 86
        Height = 16
        Caption = 'Lore to identify'
      end
      object Label6: TLabel
        Left = 8
        Top = 144
        Width = 64
        Height = 16
        Caption = 'Enchanted'
      end
      object lblDialog: TLabel
        Left = 8
        Top = 176
        Width = 40
        Height = 16
        Caption = 'Dialog'
      end
      object Label13: TLabel
        Left = 296
        Top = 56
        Width = 65
        Height = 16
        Caption = 'Droppable'
      end
      object Label15: TLabel
        Left = 296
        Top = 80
        Width = 73
        Height = 16
        Caption = 'Displayable'
      end
      object Label16: TLabel
        Left = 296
        Top = 32
        Width = 76
        Height = 16
        Caption = 'Two-handed'
      end
      object Label17: TLabel
        Left = 296
        Top = 8
        Width = 79
        Height = 16
        Caption = 'Indestructible'
      end
      object Label18: TLabel
        Left = 296
        Top = 104
        Width = 43
        Height = 16
        Caption = 'Cursed'
      end
      object Label19: TLabel
        Left = 296
        Top = 128
        Width = 59
        Height = 16
        Caption = 'Copyable'
      end
      object Label20: TLabel
        Left = 296
        Top = 152
        Width = 48
        Height = 16
        Caption = 'Magical'
      end
      object Label21: TLabel
        Left = 296
        Top = 176
        Width = 38
        Height = 16
        Caption = 'Is bow'
      end
      object Label22: TLabel
        Left = 296
        Top = 200
        Width = 34
        Height = 16
        Caption = 'Silver'
      end
      object Label23: TLabel
        Left = 296
        Top = 224
        Width = 53
        Height = 16
        Caption = 'Cold iron'
      end
      object Label24: TLabel
        Left = 296
        Top = 248
        Width = 97
        Height = 16
        Caption = 'Unknown flag 10'
      end
      object lblFlag11: TLabel
        Left = 296
        Top = 272
        Width = 62
        Height = 16
        Caption = 'Never buy'
      end
      object Label26: TLabel
        Left = 296
        Top = 296
        Width = 97
        Height = 16
        Caption = 'Unknown flag 12'
      end
      object EdtPrice: TEdit
        Left = 112
        Top = 8
        Width = 57
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object EdtWeight: TEdit
        Left = 112
        Top = 40
        Width = 57
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object EdtMaxInStack: TEdit
        Left = 112
        Top = 72
        Width = 57
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
      object EdtLoreToIdentify: TEdit
        Left = 112
        Top = 104
        Width = 57
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object EdtEnchanted: TEdit
        Left = 112
        Top = 136
        Width = 57
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
      end
      object EdtDialog: THyperlinkEdit
        Left = 112
        Top = 168
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 5
        HyperlinkJumper = MainForm.Jumper
        FileType = ftDLG
      end
      object chkFlag0: TCheckBox
        Left = 272
        Top = 8
        Width = 17
        Height = 17
        Enabled = False
        TabOrder = 6
      end
      object chkFlag1: TCheckBox
        Left = 272
        Top = 32
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 7
      end
      object chkFlag2: TCheckBox
        Left = 272
        Top = 56
        Width = 17
        Height = 17
        Enabled = False
        TabOrder = 8
      end
      object chkFlag3: TCheckBox
        Left = 272
        Top = 80
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 9
      end
      object chkFlag4: TCheckBox
        Left = 272
        Top = 104
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 10
      end
      object chkFlag5: TCheckBox
        Left = 272
        Top = 128
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 11
      end
      object chkFlag6: TCheckBox
        Left = 272
        Top = 152
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 12
      end
      object chkFlag7: TCheckBox
        Left = 272
        Top = 176
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 13
      end
      object chkFlag8: TCheckBox
        Left = 272
        Top = 200
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 14
      end
      object chkFlag9: TCheckBox
        Left = 272
        Top = 224
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 15
      end
      object chkFlag10: TCheckBox
        Left = 272
        Top = 248
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 16
      end
      object chkFlag11: TCheckBox
        Left = 272
        Top = 272
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 17
      end
      object chkFlag12: TCheckBox
        Left = 272
        Top = 296
        Width = 25
        Height = 17
        Enabled = False
        TabOrder = 18
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Usability'
      ImageIndex = 4
      object GroupBox1: TGroupBox
        Left = 8
        Top = 104
        Width = 457
        Height = 265
        Caption = 'Unusable by'
        TabOrder = 0
        object Label7: TLabel
          Left = 40
          Top = 24
          Width = 45
          Height = 16
          Caption = 'Chaotic'
        end
        object Label8: TLabel
          Left = 40
          Top = 48
          Width = 22
          Height = 16
          Caption = 'Evil'
        end
        object Label9: TLabel
          Left = 40
          Top = 72
          Width = 34
          Height = 16
          Caption = 'Good'
        end
        object Label10: TLabel
          Left = 40
          Top = 96
          Width = 69
          Height = 16
          Caption = 'G/E Neutral'
        end
        object Label11: TLabel
          Left = 40
          Top = 120
          Width = 37
          Height = 16
          Caption = 'Lawful'
        end
        object Label27: TLabel
          Left = 40
          Top = 144
          Width = 66
          Height = 16
          Caption = 'L/C Neutral'
        end
        object lblUse6: TLabel
          Left = 40
          Top = 168
          Width = 29
          Height = 16
          Caption = 'Bard'
        end
        object Label29: TLabel
          Left = 40
          Top = 192
          Width = 34
          Height = 16
          Caption = 'Cleric'
        end
        object lblUse8: TLabel
          Left = 40
          Top = 216
          Width = 73
          Height = 16
          Caption = 'Cleric/Mage'
        end
        object Label31: TLabel
          Left = 40
          Top = 240
          Width = 68
          Height = 16
          Caption = 'Cleric/Thief'
        end
        object lblUse10: TLabel
          Left = 176
          Top = 24
          Width = 83
          Height = 16
          Caption = 'Cleric/Ranger'
        end
        object Label33: TLabel
          Left = 176
          Top = 48
          Width = 41
          Height = 16
          Caption = 'Fighter'
        end
        object Label34: TLabel
          Left = 176
          Top = 72
          Width = 77
          Height = 16
          Caption = 'Fighter/Druid'
        end
        object Label35: TLabel
          Left = 176
          Top = 96
          Width = 80
          Height = 16
          Caption = 'Fighter/Mage'
        end
        object lblUse14: TLabel
          Left = 176
          Top = 120
          Width = 79
          Height = 16
          Caption = 'Fighter/Cleric'
        end
        object Label37: TLabel
          Left = 176
          Top = 144
          Width = 121
          Height = 16
          AutoSize = False
          Caption = 'Fighter/Mage/Cleric'
        end
        object lblUse16: TLabel
          Left = 176
          Top = 168
          Width = 114
          Height = 16
          Caption = 'Fighter/Mage/Thief'
        end
        object Label39: TLabel
          Left = 176
          Top = 192
          Width = 75
          Height = 16
          Caption = 'Fighter/Thief'
        end
        object Label40: TLabel
          Left = 176
          Top = 216
          Width = 35
          Height = 16
          Caption = 'Mage'
        end
        object Label41: TLabel
          Left = 176
          Top = 240
          Width = 69
          Height = 16
          Caption = 'Thief/Mage'
        end
        object lblUse20: TLabel
          Left = 336
          Top = 24
          Width = 46
          Height = 16
          Caption = 'Paladin'
        end
        object lblUse21: TLabel
          Left = 336
          Top = 48
          Width = 45
          Height = 16
          Caption = 'Ranger'
        end
        object Label44: TLabel
          Left = 336
          Top = 72
          Width = 30
          Height = 16
          Caption = 'Thief'
        end
        object lblUse23: TLabel
          Left = 336
          Top = 96
          Width = 15
          Height = 16
          Caption = 'Elf'
        end
        object lblUse24: TLabel
          Left = 336
          Top = 120
          Width = 34
          Height = 16
          Caption = 'Dwarf'
        end
        object lblUse25: TLabel
          Left = 336
          Top = 144
          Width = 42
          Height = 16
          Caption = 'Half-elf'
        end
        object lblUse26: TLabel
          Left = 336
          Top = 168
          Width = 45
          Height = 16
          Caption = 'Halfling'
        end
        object Label49: TLabel
          Left = 336
          Top = 192
          Width = 43
          Height = 16
          Caption = 'Human'
        end
        object lblUse28: TLabel
          Left = 336
          Top = 216
          Width = 44
          Height = 16
          Caption = 'Gnome'
        end
        object lblUse30: TLabel
          Left = 336
          Top = 240
          Width = 32
          Height = 16
          Caption = 'Druid'
        end
        object chkUse0: TCheckBox
          Left = 16
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 0
        end
        object chkUse1: TCheckBox
          Left = 16
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 1
        end
        object chkUse2: TCheckBox
          Left = 16
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 2
        end
        object chkUse3: TCheckBox
          Left = 16
          Top = 96
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 3
        end
        object chkUse4: TCheckBox
          Left = 16
          Top = 120
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 4
        end
        object chkUse5: TCheckBox
          Left = 16
          Top = 144
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 5
        end
        object chkUse6: TCheckBox
          Left = 16
          Top = 168
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 6
        end
        object chkUse7: TCheckBox
          Left = 17
          Top = 192
          Width = 15
          Height = 17
          Enabled = False
          TabOrder = 7
        end
        object chkUse8: TCheckBox
          Left = 17
          Top = 216
          Width = 15
          Height = 17
          Enabled = False
          TabOrder = 8
        end
        object chkUse9: TCheckBox
          Left = 17
          Top = 240
          Width = 15
          Height = 17
          Enabled = False
          TabOrder = 9
        end
        object chkUse10: TCheckBox
          Left = 152
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 10
        end
        object chkUse11: TCheckBox
          Left = 152
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 11
        end
        object chkUse12: TCheckBox
          Left = 152
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 12
        end
        object chkUse13: TCheckBox
          Left = 152
          Top = 96
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 13
        end
        object chkUse14: TCheckBox
          Left = 152
          Top = 120
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 14
        end
        object chkUse15: TCheckBox
          Left = 152
          Top = 144
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 15
        end
        object chkUse16: TCheckBox
          Left = 152
          Top = 168
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 16
        end
        object chkUse17: TCheckBox
          Left = 152
          Top = 192
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 17
        end
        object chkUse18: TCheckBox
          Left = 152
          Top = 216
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 18
        end
        object chkUse19: TCheckBox
          Left = 152
          Top = 240
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 19
        end
        object chkUse20: TCheckBox
          Left = 312
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 20
        end
        object chkUse21: TCheckBox
          Left = 312
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 21
        end
        object chkUse22: TCheckBox
          Left = 312
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 22
        end
        object chkUse23: TCheckBox
          Left = 312
          Top = 96
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 23
        end
        object chkUse24: TCheckBox
          Left = 312
          Top = 120
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 24
        end
        object chkUse25: TCheckBox
          Left = 312
          Top = 144
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 25
        end
        object chkUse26: TCheckBox
          Left = 312
          Top = 168
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 26
        end
        object chkUse27: TCheckBox
          Left = 312
          Top = 192
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 27
        end
        object chkUse28: TCheckBox
          Left = 312
          Top = 216
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 28
        end
        object chkUse30: TCheckBox
          Left = 312
          Top = 240
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 29
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 457
        Height = 89
        Caption = 'Minimum abilities'
        TabOrder = 1
        object Label36: TLabel
          Left = 16
          Top = 32
          Width = 16
          Height = 16
          Caption = 'Str'
        end
        object Label38: TLabel
          Left = 16
          Top = 64
          Width = 13
          Height = 16
          Caption = 'Int'
        end
        object Label42: TLabel
          Left = 152
          Top = 32
          Width = 24
          Height = 16
          Caption = 'Dex'
        end
        object Label43: TLabel
          Left = 312
          Top = 32
          Width = 24
          Height = 16
          Caption = 'Con'
        end
        object Label45: TLabel
          Left = 88
          Top = 32
          Width = 4
          Height = 16
          Caption = '/'
        end
        object Label46: TLabel
          Left = 152
          Top = 64
          Width = 23
          Height = 16
          Caption = 'Wis'
        end
        object Label47: TLabel
          Left = 312
          Top = 64
          Width = 24
          Height = 16
          Caption = 'Cha'
        end
        object EdtMinStr: TEdit
          Left = 48
          Top = 24
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtMinInt: TEdit
          Left = 48
          Top = 56
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
        object EdtMinDex: TEdit
          Left = 192
          Top = 24
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtMinCon: TEdit
          Left = 352
          Top = 24
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
        object EdtMinStrBonus: TEdit
          Left = 96
          Top = 24
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtMinWis: TEdit
          Left = 192
          Top = 56
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 5
        end
        object EdtMinCha: TEdit
          Left = 352
          Top = 56
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 6
        end
      end
    end
    object GlobalEffectTab: TTabSheet
      Caption = 'Global effects'
      ImageIndex = 3
      object GlobalEffectGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 245
        Align = alClient
        ColCount = 11
        DefaultRowHeight = 18
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          99
          64
          64
          64
          64
          64
          64
          64
          64
          64
          64)
      end
    end
    object AbilityTab: TTabSheet
      Caption = 'Ability'
      ImageIndex = 2
      inline AbilityFrame1: TAbilityFrame
        Width = 435
        Height = 245
        inherited AbilityCombo: TComboBox
          Left = 312
          OnChange = AbilityFrame1AbilityComboChange
        end
        inherited EffectGrid: TStringGrid
          Height = 153
        end
        inherited EdtProjectile: THyperlinkEdit
          Font.Color = clWindowText
          Font.Style = []
          IsHyperlink = False
        end
      end
    end
  end
end
