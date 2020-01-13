object AreaNPCFrame: TAreaNPCFrame
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
      Left = 8
      Top = 48
      Width = 48
      Height = 16
      Caption = 'CRE file'
    end
    object Label3: TLabel
      Left = 224
      Top = 48
      Width = 40
      Height = 16
      Caption = 'Dialog'
    end
    object Label10: TLabel
      Left = 312
      Top = 16
      Width = 41
      Height = 16
      Caption = 'Visible'
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
    object GroupBox1: TGroupBox
      Left = 8
      Top = 72
      Width = 609
      Height = 89
      Caption = 'Scripts'
      TabOrder = 4
      object Label4: TLabel
        Left = 8
        Top = 32
        Width = 52
        Height = 16
        Caption = 'Override'
      end
      object Label5: TLabel
        Left = 208
        Top = 32
        Width = 34
        Height = 16
        Caption = 'Class'
      end
      object Label6: TLabel
        Left = 408
        Top = 32
        Width = 33
        Height = 16
        Caption = 'Race'
      end
      object Label7: TLabel
        Left = 8
        Top = 64
        Width = 48
        Height = 16
        Caption = 'General'
      end
      object Label8: TLabel
        Left = 208
        Top = 64
        Width = 42
        Height = 16
        Caption = 'Default'
      end
      object Label9: TLabel
        Left = 408
        Top = 64
        Width = 55
        Height = 16
        Caption = 'Specifics'
      end
      object EdtScriptOverride: THyperlinkEdit
        Left = 72
        Top = 24
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
        FileType = ftSCRIPT
      end
      object EdtScriptClass: THyperlinkEdit
        Left = 272
        Top = 24
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
      object EdtScriptRace: THyperlinkEdit
        Left = 472
        Top = 24
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
        FileType = ftSCRIPT
      end
      object EdtScriptGeneral: THyperlinkEdit
        Left = 72
        Top = 56
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
        FileType = ftSCRIPT
      end
      object EdtScriptDefault: THyperlinkEdit
        Left = 272
        Top = 56
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 4
        HyperlinkJumper = MainForm.Jumper
        FileType = ftSCRIPT
      end
      object EdtScriptSpecifics: THyperlinkEdit
        Left = 472
        Top = 56
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
        FileType = ftSCRIPT
      end
    end
    object EdtCREFile: THyperlinkEdit
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
      FileType = ftCRE
    end
    object EdtDialog: THyperlinkEdit
      Left = 288
      Top = 40
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
      FileType = ftDLG
    end
    object chkVisible: TCheckBox
      Left = 288
      Top = 16
      Width = 17
      Height = 17
      Enabled = False
      TabOrder = 2
    end
  end
end
