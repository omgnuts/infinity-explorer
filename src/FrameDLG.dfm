object DlgFrame: TDlgFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 275
  Align = alClient
  TabOrder = 0
  OnResize = FrameResize
  object Splitter1: TSplitter
    Left = 0
    Top = 105
    Width = 443
    Height = 3
    Cursor = crVSplit
    Align = alTop
    AutoSnap = False
  end
  object tvDialog: TTreeView
    Left = 0
    Top = 0
    Width = 443
    Height = 105
    Align = alTop
    HideSelection = False
    Indent = 19
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 0
    OnChange = tvDialogChange
    OnExpanding = tvDialogExpanding
    OnKeyDown = tvDialogKeyDown
  end
  object ScrollBox1: TScrollBox
    Left = 10
    Top = 108
    Width = 423
    Height = 167
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    object grpCond: TGroupBox
      Left = 0
      Top = 33
      Width = 423
      Height = 32
      Align = alTop
      Caption = 'Condition'
      TabOrder = 0
      Visible = False
      DesignSize = (
        423
        32)
      object reCond: TRxRichEdit
        Left = 2
        Top = 16
        Width = 405
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        OnMouseDown = reCondMouseDown
        OnMouseUp = reCondMouseUp
        OnURLClick = reCondURLClick
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 65
      Width = 423
      Height = 97
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object grpAction: TGroupBox
        Left = 0
        Top = 0
        Width = 423
        Height = 49
        Align = alTop
        Caption = 'Action'
        TabOrder = 0
        Visible = False
        DesignSize = (
          423
          49)
        object reAction: TRxRichEdit
          Left = 2
          Top = 18
          Width = 405
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          OnMouseDown = reCondMouseDown
          OnMouseUp = reCondMouseUp
          OnURLClick = reCondURLClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 49
        Width = 423
        Height = 48
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 1
        object grpJournal: TGroupBox
          Left = 0
          Top = 0
          Width = 423
          Height = 48
          Align = alTop
          Caption = 'Journal'
          TabOrder = 0
          Visible = False
          DesignSize = (
            423
            48)
          object JournalLeftMarginPanel: TPanel
            Left = 2
            Top = 15
            Width = 10
            Height = 31
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
          end
          object JournalRightMarginPanel: TPanel
            Left = 411
            Top = 15
            Width = 10
            Height = 31
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 1
          end
          object memJournal: TMemo
            Left = 8
            Top = 18
            Width = 405
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            BorderStyle = bsNone
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
          end
        end
      end
    end
    object grpText: TGroupBox
      Left = 0
      Top = 0
      Width = 423
      Height = 33
      Align = alTop
      Caption = 'Text'
      TabOrder = 2
      Visible = False
      DesignSize = (
        423
        33)
      object MemText: TMemo
        Left = 8
        Top = 18
        Width = 405
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object LeftMarginPanel: TPanel
    Left = 0
    Top = 108
    Width = 10
    Height = 167
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
  end
  object RightMarginPanel: TPanel
    Left = 433
    Top = 108
    Width = 10
    Height = 167
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
  end
end
