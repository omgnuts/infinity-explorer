object AboutDialog: TAboutDialog
  Left = 296
  Top = 116
  BorderStyle = bsDialog
  Caption = 'About Infinity Explorer'
  ClientHeight = 232
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 96
    Top = 16
    Width = 150
    Height = 24
    Caption = 'Infinity Explorer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 25
    Top = 72
    Width = 294
    Height = 16
    Caption = 'Written by Dmitry Jemerov <yole@spb.cityline.ru>'
  end
  object Label3: TLabel
    Left = 89
    Top = 96
    Width = 164
    Height = 16
    Cursor = crHandPoint
    Caption = 'http://InfExp.sourceforge.net'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
  end
  object Label4: TLabel
    Left = 28
    Top = 120
    Width = 288
    Height = 32
    Alignment = taCenter
    Caption = 
      'Partly based on research by'#13#10'Eddy L O Jansson, Petr Zahradnik an' +
      'd Jed Wing'
  end
  object Label5: TLabel
    Left = 31
    Top = 160
    Width = 283
    Height = 16
    Cursor = crHandPoint
    Caption = 'http://www.ugcs.caltech.edu/~jedwin/baldur.html'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
  end
  object Label6: TLabel
    Left = 139
    Top = 48
    Width = 73
    Height = 16
    Caption = 'Version 0.75'
  end
  object Panel1: TPanel
    Left = 0
    Top = 185
    Width = 344
    Height = 47
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object BtnOK: TButton
      Left = 119
      Top = 8
      Width = 105
      Height = 33
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
end
