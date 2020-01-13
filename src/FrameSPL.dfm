object SPLFrame: TSPLFrame
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
      Caption = 'Description'
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 37
        Height = 16
        Caption = 'Name'
      end
      object Label12: TLabel
        Left = 8
        Top = 48
        Width = 41
        Height = 16
        Caption = 'Picture'
      end
      object Image1: TBAMIcon
        Left = 344
        Top = 8
        Width = 105
        Height = 65
        Transparent = True
      end
      object Label2: TLabel
        Left = 8
        Top = 80
        Width = 85
        Height = 16
        Caption = 'Casting sound'
      end
      object Label3: TLabel
        Left = 8
        Top = 112
        Width = 33
        Height = 16
        Caption = 'Level'
      end
      object Label4: TLabel
        Left = 8
        Top = 144
        Width = 32
        Height = 16
        Caption = 'Type'
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
        TabOrder = 4
        object MemDesc: TMemo
          Left = 8
          Top = 24
          Width = 420
          Height = 49
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = clBtnFace
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object EdtPicture: THyperlinkEdit
        Left = 112
        Top = 40
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 1
        HyperlinkJumper = MainForm.Jumper
        FileType = ftBAM
      end
      object EdtSound: THyperlinkEdit
        Left = 112
        Top = 72
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        IsHyperlink = False
        FileType = ftNone
      end
      object EdtLevel: TEdit
        Left = 112
        Top = 104
        Width = 41
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object EdtSpellType: TEdit
        Left = 112
        Top = 136
        Width = 121
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Ability'
      ImageIndex = 1
      inline AbilityFrame1: TAbilityFrame
        Width = 435
        Height = 245
        inherited AbilityCombo: TComboBox
          Left = 312
          OnChange = AbilityFrame1AbilityComboChange
        end
      end
    end
  end
end
