object StrrefForm: TStrrefForm
  Left = 263
  Top = 117
  BorderStyle = bsDialog
  Caption = 'Lookup StrRef'
  ClientHeight = 254
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 7
    Top = 234
    Width = 31
    Height = 13
    Caption = 'Sound'
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 7
    Width = 130
    Height = 65
    Caption = 'Index'
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 20
      Width = 38
      Height = 13
      Caption = 'Decimal'
    end
    object Label2: TLabel
      Left = 7
      Top = 46
      Width = 19
      Height = 13
      Caption = 'Hex'
    end
    object EdtDecimal: TEdit
      Left = 65
      Top = 13
      Width = 53
      Height = 21
      TabOrder = 0
      OnChange = EdtDecimalChange
      OnKeyPress = EdtDecimalKeyPress
    end
    object EdtHex: TEdit
      Left = 65
      Top = 39
      Width = 53
      Height = 21
      TabOrder = 1
      OnChange = EdtHexChange
      OnKeyPress = EdtHexKeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 78
    Width = 293
    Height = 144
    Caption = 'Text'
    TabOrder = 1
    object MemText: TMemo
      Left = 7
      Top = 13
      Width = 280
      Height = 124
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      OnKeyDown = MemTextKeyDown
    end
  end
  object BtnLookup: TButton
    Left = 215
    Top = 13
    Width = 85
    Height = 27
    Caption = 'Lookup'
    Default = True
    TabOrder = 2
    OnClick = BtnLookupClick
  end
  object BtnCancel: TButton
    Left = 215
    Top = 46
    Width = 85
    Height = 26
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object EdtSound: THyperlinkEdit
    Left = 59
    Top = 228
    Width = 78
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    IsHyperlink = False
    FileType = ftNone
  end
end
