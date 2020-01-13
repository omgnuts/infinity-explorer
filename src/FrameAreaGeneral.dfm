object AreaGeneralFrame: TAreaGeneralFrame
  Left = 0
  Top = 0
  Width = 482
  Height = 220
  Align = alBottom
  TabOrder = 0
  object Label5: TLabel
    Left = 8
    Top = 172
    Width = 38
    Height = 13
    Caption = 'AI script'
  end
  object Label10: TLabel
    Left = 400
    Top = 24
    Width = 38
    Height = 13
    Caption = 'Outdoor'
  end
  object Label11: TLabel
    Left = 400
    Top = 56
    Width = 49
    Height = 13
    Caption = 'Day/Night'
  end
  object Label12: TLabel
    Left = 400
    Top = 88
    Width = 41
    Height = 13
    Caption = 'Weather'
  end
  object Label13: TLabel
    Left = 400
    Top = 120
    Width = 73
    Height = 13
    Caption = 'Extended Night'
  end
  object Label14: TLabel
    Left = 216
    Top = 172
    Width = 45
    Height = 13
    Caption = 'Area type'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 193
    Height = 145
    Caption = 'Exits'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 26
      Height = 13
      Caption = 'North'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 25
      Height = 13
      Caption = 'West'
    end
    object Label3: TLabel
      Left = 8
      Top = 88
      Width = 28
      Height = 13
      Caption = 'South'
    end
    object Label4: TLabel
      Left = 8
      Top = 120
      Width = 21
      Height = 13
      Caption = 'East'
    end
    object EdtExitN: TEdit
      Left = 64
      Top = 16
      Width = 121
      Height = 24
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnMouseUp = EdtExitNMouseUp
    end
    object EdtExitW: TEdit
      Left = 64
      Top = 48
      Width = 121
      Height = 24
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      OnMouseUp = EdtExitNMouseUp
    end
    object EdtExitS: TEdit
      Left = 64
      Top = 80
      Width = 121
      Height = 24
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      OnMouseUp = EdtExitNMouseUp
    end
    object EdtExitE: TEdit
      Left = 64
      Top = 112
      Width = 121
      Height = 24
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      OnMouseUp = EdtExitNMouseUp
    end
  end
  object EdtAIScript: TEdit
    Left = 72
    Top = 164
    Width = 121
    Height = 24
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    OnMouseUp = EdtAIScriptMouseUp
  end
  object GroupBox2: TGroupBox
    Left = 208
    Top = 8
    Width = 161
    Height = 145
    Caption = 'Weather probabilities'
    TabOrder = 2
    object Label6: TLabel
      Left = 8
      Top = 24
      Width = 22
      Height = 13
      Caption = 'Rain'
    end
    object Label7: TLabel
      Left = 8
      Top = 56
      Width = 27
      Height = 13
      Caption = 'Snow'
    end
    object Label8: TLabel
      Left = 8
      Top = 88
      Width = 18
      Height = 13
      Caption = 'Fog'
    end
    object Label9: TLabel
      Left = 8
      Top = 120
      Width = 43
      Height = 13
      Caption = 'Lightning'
    end
    object EdtRainProbability: TEdit
      Left = 88
      Top = 16
      Width = 57
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object EdtSnowProbability: TEdit
      Left = 88
      Top = 48
      Width = 57
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object EdtFogProbability: TEdit
      Left = 88
      Top = 80
      Width = 57
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object EdtLightningProbability: TEdit
      Left = 88
      Top = 112
      Width = 57
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
  end
  object chkFlag0: TCheckBox
    Left = 376
    Top = 24
    Width = 17
    Height = 17
    Enabled = False
    TabOrder = 3
  end
  object chkFlag1: TCheckBox
    Left = 376
    Top = 56
    Width = 17
    Height = 17
    Enabled = False
    TabOrder = 4
  end
  object chkFlag2: TCheckBox
    Left = 376
    Top = 88
    Width = 17
    Height = 17
    Enabled = False
    TabOrder = 5
  end
  object chkFlag6: TCheckBox
    Left = 376
    Top = 120
    Width = 17
    Height = 17
    Enabled = False
    TabOrder = 6
  end
  object EdtAreaType: TEdit
    Left = 296
    Top = 164
    Width = 121
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 7
  end
end
