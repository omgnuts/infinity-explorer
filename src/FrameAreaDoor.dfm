object AreaDoorFrame: TAreaDoorFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 167
  Align = alBottom
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 167
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 37
      Height = 16
      Caption = 'Name'
    end
    object Label2: TLabel
      Left = 136
      Top = 48
      Width = 79
      Height = 16
      Caption = 'Lock difficulty'
    end
    object Label3: TLabel
      Left = 136
      Top = 80
      Width = 131
      Height = 16
      Caption = 'Trap removal difficulty'
    end
    object Label4: TLabel
      Left = 136
      Top = 112
      Width = 141
      Height = 16
      Caption = 'Trap detection diffuculty'
    end
    object Label5: TLabel
      Left = 8
      Top = 144
      Width = 64
      Height = 16
      Caption = 'Trap script'
    end
    object Label6: TLabel
      Left = 232
      Top = 144
      Width = 52
      Height = 16
      Caption = 'Key type'
    end
    object Label7: TLabel
      Left = 32
      Top = 48
      Width = 45
      Height = 16
      Caption = 'Locked'
    end
    object Label8: TLabel
      Left = 32
      Top = 80
      Width = 53
      Height = 16
      Caption = 'Trapped'
    end
    object Label9: TLabel
      Left = 32
      Top = 112
      Width = 85
      Height = 16
      Caption = 'Trap detected'
    end
    object EdtName: TEdit
      Left = 80
      Top = 8
      Width = 161
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ChkLocked: TCheckBox
      Left = 8
      Top = 48
      Width = 17
      Height = 17
      Enabled = False
      TabOrder = 1
    end
    object EdtLockDifficulty: TEdit
      Left = 288
      Top = 40
      Width = 33
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ChkTrapped: TCheckBox
      Left = 8
      Top = 80
      Width = 25
      Height = 17
      Enabled = False
      TabOrder = 3
    end
    object EdtTrapRemovalDifficulty: TEdit
      Left = 288
      Top = 72
      Width = 33
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ChkTrapDetected: TCheckBox
      Left = 8
      Top = 112
      Width = 25
      Height = 17
      Enabled = False
      TabOrder = 5
    end
    object EdtTrapDetectionDifficulty: TEdit
      Left = 288
      Top = 104
      Width = 33
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object EdtTrapScript: THyperlinkEdit
      Left = 88
      Top = 136
      Width = 121
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      TabOrder = 7
      HyperlinkJumper = MainForm.Jumper
      FileType = ftSCRIPT
    end
    object EdtKeyType: THyperlinkEdit
      Left = 312
      Top = 136
      Width = 121
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      TabOrder = 8
      HyperlinkJumper = MainForm.Jumper
      FileType = ftITM
    end
  end
end
