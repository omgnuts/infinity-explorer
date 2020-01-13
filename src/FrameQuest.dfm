object QuestFrame: TQuestFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 443
    Height = 276
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      'Assigned'
      'Completed')
    TabIndex = 0
    OnChange = TabControl1Change
    object GroupBox1: TGroupBox
      Left = 4
      Top = 27
      Width = 435
      Height = 105
      Align = alTop
      Caption = 'Condition'
      TabOrder = 0
      object MemCond: TMemo
        Left = 8
        Top = 24
        Width = 419
        Height = 73
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
    end
    object grpDesc: TGroupBox
      Left = 4
      Top = 132
      Width = 435
      Height = 140
      Align = alClient
      Caption = 'Description'
      TabOrder = 1
      object MemDesc: TMemo
        Left = 8
        Top = 24
        Width = 419
        Height = 105
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end
