object ChUIPanelFrame: TChUIPanelFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 276
  Align = alClient
  TabOrder = 0
  object Label5: TLabel
    Left = 8
    Top = 104
    Width = 73
    Height = 16
    Caption = 'Background'
  end
  object Label6: TLabel
    Left = 8
    Top = 128
    Width = 49
    Height = 16
    Caption = 'Controls'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 249
    Height = 81
    Caption = 'Position'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 21
      Height = 16
      Caption = 'Left'
    end
    object Label2: TLabel
      Left = 128
      Top = 24
      Width = 25
      Height = 16
      Caption = 'Top'
    end
    object Label3: TLabel
      Left = 8
      Top = 56
      Width = 34
      Height = 16
      Caption = 'Width'
    end
    object Label4: TLabel
      Left = 128
      Top = 56
      Width = 39
      Height = 16
      Caption = 'Height'
    end
    object edtLeft: TEdit
      Left = 64
      Top = 16
      Width = 49
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object edtTop: TEdit
      Left = 184
      Top = 16
      Width = 49
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtWidth: TEdit
      Left = 64
      Top = 48
      Width = 49
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object edtHeight: TEdit
      Left = 184
      Top = 48
      Width = 49
      Height = 24
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
  end
  object edtBackground: THyperlinkEdit
    Left = 120
    Top = 96
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
    FileType = ftMOS
  end
  object ControlGrid: THyperlinkGrid
    Left = 8
    Top = 152
    Width = 433
    Height = 120
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 8
    DefaultRowHeight = 18
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 2
    OnCanJump = ControlGridCanJump
    OnJump = ControlGridJump
    ColWidths = (
      75
      64
      64
      64
      64
      64
      114
      64)
  end
end
