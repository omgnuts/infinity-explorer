object OpenGameDialog: TOpenGameDialog
  Left = 303
  Top = 116
  BorderStyle = bsDialog
  Caption = 'Open game'
  ClientHeight = 260
  ClientWidth = 397
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
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 218
    Height = 13
    Caption = 'Path where an Infinity Engine game is installed'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 72
    Height = 13
    Caption = 'Recent games:'
  end
  object EdtGamePath: TDirectoryEdit
    Left = 7
    Top = 26
    Width = 382
    Height = 18
    DialogKind = dkWin32
    NumGlyphs = 1
    ButtonWidth = 17
    TabOrder = 0
  end
  object BtnOK: TButton
    Left = 93
    Top = 222
    Width = 85
    Height = 27
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 219
    Top = 222
    Width = 85
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object chkIgnoreOverrides: TCheckBox
    Left = 7
    Top = 200
    Width = 111
    Height = 14
    Caption = 'Ignore overrides'
    TabOrder = 3
  end
  object lvRecentGames: TListView
    Left = 8
    Top = 64
    Width = 381
    Height = 125
    Columns = <
      item
        Caption = 'Path'
        Width = 270
      end
      item
        Caption = 'Game'
        Width = 100
      end>
    TabOrder = 4
    ViewStyle = vsReport
    OnClick = lvRecentGamesClick
  end
end
