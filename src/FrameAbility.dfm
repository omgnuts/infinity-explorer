object AbilityFrame: TAbilityFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  object Label7: TLabel
    Left = 8
    Top = 48
    Width = 41
    Height = 16
    Caption = 'Range'
  end
  object Label8: TLabel
    Left = 8
    Top = 80
    Width = 41
    Height = 16
    Caption = 'Speed'
  end
  object Label9: TLabel
    Left = 8
    Top = 112
    Width = 44
    Height = 16
    Caption = 'THAC0'
  end
  object Label10: TLabel
    Left = 8
    Top = 144
    Width = 53
    Height = 16
    Caption = 'Damage'
  end
  object Label11: TLabel
    Left = 8
    Top = 176
    Width = 51
    Height = 16
    Caption = 'Charges'
  end
  object Label1: TLabel
    Left = 200
    Top = 16
    Width = 25
    Height = 16
    Caption = 'Icon'
  end
  object BAMIcon1: TBAMIcon
    Left = 360
    Top = 8
    Width = 34
    Height = 34
    Transparent = True
  end
  object lblLauncherLevel: TLabel
    Left = 200
    Top = 144
    Width = 84
    Height = 16
    Caption = 'Launcher type'
  end
  object Label2: TLabel
    Left = 8
    Top = 16
    Width = 32
    Height = 16
    Caption = 'Type'
  end
  object lblUseOnlyIdentified: TLabel
    Left = 224
    Top = 48
    Width = 110
    Height = 16
    Caption = 'Use only identified'
  end
  object Label4: TLabel
    Left = 200
    Top = 80
    Width = 69
    Height = 16
    Caption = 'Target type'
  end
  object Label5: TLabel
    Left = 200
    Top = 112
    Width = 82
    Height = 16
    Caption = 'Damage type'
  end
  object Label3: TLabel
    Left = 200
    Top = 176
    Width = 85
    Height = 16
    Caption = 'Projectile type'
  end
  object EdtRange: TEdit
    Left = 88
    Top = 40
    Width = 33
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object AbilityCombo: TComboBox
    Left = 320
    Top = 8
    Width = 116
    Height = 24
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 16
    TabOrder = 11
  end
  object EdtSpeed: TEdit
    Left = 88
    Top = 72
    Width = 33
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object EdtTHAC0: TEdit
    Left = 88
    Top = 104
    Width = 33
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
  end
  object EdtDamage: TEdit
    Left = 88
    Top = 136
    Width = 49
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
  end
  object EdtChargeCount: TEdit
    Left = 88
    Top = 168
    Width = 33
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 5
  end
  object EffectGrid: TStringGrid
    Left = 8
    Top = 200
    Width = 425
    Height = 118
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 11
    DefaultRowHeight = 18
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 12
    ColWidths = (
      142
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
  object EdtIcon: THyperlinkEdit
    Left = 256
    Top = 8
    Width = 89
    Height = 24
    TabOrder = 6
    HyperlinkJumper = MainForm.Jumper
    FileType = ftBAM
  end
  object EdtLauncherLevel: TEdit
    Left = 304
    Top = 136
    Width = 89
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 10
  end
  object EdtType: TEdit
    Left = 88
    Top = 8
    Width = 89
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object chkUseOnlyIdentified: TCheckBox
    Left = 200
    Top = 48
    Width = 17
    Height = 17
    Enabled = False
    TabOrder = 7
  end
  object EdtTargetType: TEdit
    Left = 304
    Top = 72
    Width = 89
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 8
  end
  object EdtDamageType: TEdit
    Left = 304
    Top = 104
    Width = 89
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 9
  end
  object EdtProjectile: THyperlinkEdit
    Left = 304
    Top = 168
    Width = 89
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 13
    HyperlinkJumper = MainForm.Jumper
    FileType = ftPRO
  end
end
