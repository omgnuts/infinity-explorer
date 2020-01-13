object AreaAnimFrame: TAreaAnimFrame
  Left = 0
  Top = 0
  Width = 413
  Height = 40
  Align = alBottom
  TabOrder = 0
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 49
    Height = 16
    Caption = 'BAM file'
  end
  object Label2: TLabel
    Left = 208
    Top = 16
    Width = 59
    Height = 16
    Caption = 'Animation'
  end
  object EdtBAM: THyperlinkEdit
    Left = 72
    Top = 8
    Width = 121
    Height = 24
    TabOrder = 0
    HyperlinkJumper = MainForm.Jumper
    FileType = ftBAM
    OnJump = EdtBAMJump
  end
  object EdtAnim: TEdit
    Left = 280
    Top = 8
    Width = 41
    Height = 24
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
end
