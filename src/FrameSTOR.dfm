object StoreFrame: TStoreFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  object TLabel
    Left = 8
    Top = 24
    Width = 23
    Height = 16
    Caption = 'Buy'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 443
    Height = 276
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 37
        Height = 16
        Caption = 'Name'
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 32
        Height = 16
        Caption = 'Type'
      end
      object Label11: TLabel
        Left = 8
        Top = 240
        Width = 81
        Height = 16
        Caption = 'Steal difficulty'
      end
      object Label12: TLabel
        Left = 200
        Top = 240
        Width = 68
        Height = 16
        Caption = 'Identify lore'
      end
      object EdtStoreName: TEdit
        Left = 64
        Top = 8
        Width = 217
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object EdtStoreType: TEdit
        Left = 64
        Top = 40
        Width = 73
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 176
        Width = 345
        Height = 49
        Caption = 'Prices'
        TabOrder = 3
        object Label3: TLabel
          Left = 120
          Top = 24
          Width = 23
          Height = 16
          Caption = 'Buy'
        end
        object Label4: TLabel
          Left = 16
          Top = 24
          Width = 23
          Height = 16
          Caption = 'Sell'
        end
        object Label10: TLabel
          Left = 224
          Top = 24
          Width = 61
          Height = 16
          Caption = 'Reduction'
        end
        object EdtBuyPrice: TEdit
          Left = 160
          Top = 16
          Width = 41
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtSellPrice: TEdit
          Left = 56
          Top = 16
          Width = 41
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtBuyPriceReduction: TEdit
          Left = 296
          Top = 16
          Width = 41
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 328
        Width = 345
        Height = 81
        Caption = 'Rooms'
        TabOrder = 7
        object Label6: TLabel
          Left = 40
          Top = 24
          Width = 50
          Height = 16
          Caption = 'Peasant'
        end
        object Label7: TLabel
          Left = 40
          Top = 56
          Width = 55
          Height = 16
          Caption = 'Merchant'
        end
        object Label8: TLabel
          Left = 224
          Top = 24
          Width = 37
          Height = 16
          Caption = 'Noble'
        end
        object Label9: TLabel
          Left = 224
          Top = 56
          Width = 36
          Height = 16
          Caption = 'Royal'
        end
        object chkRoom0: TCheckBox
          Left = 16
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 0
        end
        object EdtRoom0: TEdit
          Left = 112
          Top = 16
          Width = 41
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object chkRoom1: TCheckBox
          Left = 16
          Top = 56
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 2
        end
        object EdtRoom1: TEdit
          Left = 112
          Top = 48
          Width = 41
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
        object chkRoom2: TCheckBox
          Left = 200
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 4
        end
        object EdtRoom2: TEdit
          Left = 296
          Top = 16
          Width = 41
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 5
        end
        object chkRoom3: TCheckBox
          Left = 200
          Top = 56
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 6
        end
        object EdtRoom3: TEdit
          Left = 296
          Top = 48
          Width = 41
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 7
        end
      end
      object EdtStealDifficulty: TEdit
        Left = 120
        Top = 232
        Width = 41
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
      end
      object EdtIdentifyLore: TEdit
        Left = 304
        Top = 232
        Width = 41
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 5
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 264
        Width = 345
        Height = 57
        Caption = 'Rumor dialogs'
        TabOrder = 6
        object Label13: TLabel
          Left = 8
          Top = 32
          Width = 31
          Height = 16
          Caption = 'Drink'
        end
        object Label14: TLabel
          Left = 176
          Top = 32
          Width = 44
          Height = 16
          Caption = 'Donate'
        end
        object EdtRumorDlg: THyperlinkEdit
          Left = 56
          Top = 25
          Width = 97
          Height = 24
          TabOrder = 0
          HyperlinkJumper = MainForm.Jumper
          FileType = ftDLG
        end
        object EdtDonateRumorDlg: THyperlinkEdit
          Left = 240
          Top = 25
          Width = 97
          Height = 24
          TabOrder = 1
          HyperlinkJumper = MainForm.Jumper
          FileType = ftDLG
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 72
        Width = 345
        Height = 97
        Caption = 'Flags'
        TabOrder = 2
        object Label5: TLabel
          Left = 40
          Top = 24
          Width = 49
          Height = 16
          Caption = 'Can buy'
        end
        object Label15: TLabel
          Left = 40
          Top = 48
          Width = 48
          Height = 16
          Caption = 'Can sell'
        end
        object Label16: TLabel
          Left = 40
          Top = 72
          Width = 69
          Height = 16
          Caption = 'Can identify'
        end
        object Label17: TLabel
          Left = 152
          Top = 24
          Width = 56
          Height = 16
          Caption = 'Can steal'
        end
        object Label18: TLabel
          Left = 152
          Top = 48
          Width = 88
          Height = 16
          Caption = 'Can buy spells'
        end
        object Label19: TLabel
          Left = 152
          Top = 72
          Width = 69
          Height = 16
          Caption = 'Can donate'
        end
        object Label20: TLabel
          Left = 272
          Top = 24
          Width = 56
          Height = 16
          Caption = 'Can drink'
        end
        object chkFlag0: TCheckBox
          Left = 16
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 0
        end
        object chkFlag1: TCheckBox
          Left = 16
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 1
        end
        object chkFlag2: TCheckBox
          Left = 16
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 2
        end
        object chkFlag3: TCheckBox
          Left = 128
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 3
        end
        object chkFlag4: TCheckBox
          Left = 128
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 4
        end
        object chkFlag5: TCheckBox
          Left = 128
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 5
        end
        object chkFlag6: TCheckBox
          Left = 248
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 6
        end
      end
    end
    object ItemsTab: TTabSheet
      Caption = 'Items'
      ImageIndex = 3
      object ItemGrid: THyperlinkGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 245
        Align = alClient
        DefaultRowHeight = 18
        FixedCols = 0
        TabOrder = 0
        OnCanJump = ItemGridCanJump
        OnJump = ItemGridJump
        ColWidths = (
          164
          64
          69
          68
          64)
      end
    end
    object BoughtItemsTab: TTabSheet
      Caption = 'Bought items'
      ImageIndex = 4
      object GroupBox5: TGroupBox
        Left = 0
        Top = 0
        Width = 435
        Height = 245
        Align = alClient
        Caption = 'Categories'
        TabOrder = 0
        object lbxBoughtItems: TListBox
          Left = 2
          Top = 18
          Width = 431
          Height = 225
          Align = alClient
          ItemHeight = 16
          TabOrder = 0
        end
      end
    end
    object DrinksTab: TTabSheet
      Caption = 'Drinks'
      ImageIndex = 1
      object DrinkGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 245
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 18
        FixedCols = 0
        TabOrder = 0
        ColWidths = (
          225
          64
          92)
      end
    end
    object SpellsTab: TTabSheet
      Caption = 'Spells'
      ImageIndex = 2
      object SpellGrid: THyperlinkGrid
        Left = 0
        Top = 0
        Width = 435
        Height = 245
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        TabOrder = 0
        OnCanJump = SpellGridCanJump
        OnJump = SpellGridJump
        ColWidths = (
          192
          64)
      end
    end
  end
end
