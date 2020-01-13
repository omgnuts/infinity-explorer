object SearchCodeDlg: TSearchCodeDlg
  Left = 267
  Top = 120
  BorderStyle = bsDialog
  Caption = 'Search for code'
  ClientHeight = 173
  ClientWidth = 246
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
    Left = 16
    Top = 16
    Width = 106
    Height = 16
    Caption = 'Code string to find'
  end
  object EdtCodeString: TEdit
    Left = 16
    Top = 40
    Width = 209
    Height = 24
    TabOrder = 0
  end
  object ChkSearchDialogs: TCheckBox
    Left = 16
    Top = 72
    Width = 137
    Height = 17
    Caption = 'Search dialogs'
    TabOrder = 1
  end
  object ChkSearchScripts: TCheckBox
    Left = 16
    Top = 96
    Width = 137
    Height = 17
    Caption = 'Search AI scripts'
    TabOrder = 2
  end
  object BtnOK: TButton
    Left = 32
    Top = 128
    Width = 81
    Height = 33
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object BtnCancel: TButton
    Left = 136
    Top = 128
    Width = 81
    Height = 33
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
