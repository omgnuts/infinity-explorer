object AreaInfoFrame: TAreaInfoFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 214
  Align = alBottom
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 214
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
    object Label10: TLabel
      Left = 8
      Top = 48
      Width = 34
      Height = 16
      Caption = 'Script'
    end
    object Label13: TLabel
      Left = 248
      Top = 16
      Width = 39
      Height = 16
      Caption = 'Cursor'
    end
    object BAMCursor: TBAMIcon
      Left = 360
      Top = 8
      Width = 57
      Height = 49
      Transparent = True
    end
    object EdtName: TEdit
      Left = 80
      Top = 8
      Width = 153
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 2
      Top = 72
      Width = 439
      Height = 140
      ActivePage = InfoTab
      Align = alBottom
      TabOrder = 2
      TabPosition = tpBottom
      object ProximityTab: TTabSheet
        Caption = 'Proximity'
        object Label3: TLabel
          Left = 224
          Top = 80
          Width = 40
          Height = 16
          Caption = 'Dialog'
        end
        object Label8: TLabel
          Left = 32
          Top = 16
          Width = 53
          Height = 16
          Caption = 'Trapped'
        end
        object Label2: TLabel
          Left = 136
          Top = 16
          Width = 131
          Height = 16
          Caption = 'Trap removal difficulty'
        end
        object Label9: TLabel
          Left = 32
          Top = 48
          Width = 85
          Height = 16
          Caption = 'Trap detected'
        end
        object Label7: TLabel
          Left = 136
          Top = 48
          Width = 141
          Height = 16
          Caption = 'Trap detection diffuculty'
        end
        object Label11: TLabel
          Left = 8
          Top = 80
          Width = 52
          Height = 16
          Caption = 'Key type'
        end
        object Label6: TLabel
          Left = 32
          Top = 112
          Width = 62
          Height = 16
          Caption = 'Reset trap'
        end
        object EdtDialog: THyperlinkEdit
          Left = 304
          Top = 72
          Width = 121
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
          TabOrder = 0
          HyperlinkJumper = MainForm.Jumper
          FileType = ftDLG
        end
        object ChkTrapped: TCheckBox
          Left = 8
          Top = 16
          Width = 25
          Height = 17
          Enabled = False
          TabOrder = 1
        end
        object EdtTrapRemovalDifficulty: TEdit
          Left = 288
          Top = 8
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object ChkTrapDetected: TCheckBox
          Left = 8
          Top = 48
          Width = 25
          Height = 17
          Enabled = False
          TabOrder = 3
        end
        object EdtTrapDetectionDifficulty: TEdit
          Left = 288
          Top = 40
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
        object EdtKeyType: THyperlinkEdit
          Left = 88
          Top = 72
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
          FileType = ftITM
        end
        object chkResetTrap: TCheckBox
          Left = 8
          Top = 112
          Width = 25
          Height = 17
          Enabled = False
          TabOrder = 6
        end
      end
      object InfoTab: TTabSheet
        Caption = 'Info'
        ImageIndex = 1
        object lblDescription: TLabel
          Left = 8
          Top = 0
          Width = 68
          Height = 16
          Caption = 'Description'
        end
        object MemDesc: TMemo
          Left = 0
          Top = 24
          Width = 431
          Height = 85
          Align = alBottom
          Color = clBtnFace
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TravelTab: TTabSheet
        Caption = 'Travel'
        ImageIndex = 2
        object Label4: TLabel
          Left = 8
          Top = 8
          Width = 48
          Height = 16
          Caption = 'To area'
        end
        object Label5: TLabel
          Left = 8
          Top = 40
          Width = 62
          Height = 16
          Caption = 'Entry point'
        end
        object Label12: TLabel
          Left = 32
          Top = 72
          Width = 84
          Height = 16
          Caption = 'Party required'
        end
        object EdtDestArea: THyperlinkEdit
          Left = 80
          Top = 0
          Width = 121
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
          TabOrder = 0
          HyperlinkJumper = MainForm.Jumper
          FileType = ftAREA
        end
        object EdtDestEntrance: TEdit
          Left = 80
          Top = 32
          Width = 121
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object chkPartyRequired: TCheckBox
          Left = 8
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 2
        end
      end
    end
    object EdtScript: THyperlinkEdit
      Left = 80
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
      FileType = ftSCRIPT
    end
    object EdtCursor: TEdit
      Left = 296
      Top = 8
      Width = 33
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
  end
end
