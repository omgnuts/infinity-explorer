object TextFrame: TTextFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 275
  Align = alClient
  TabOrder = 0
  OnResize = FrameResize
  object reScript: TRxRichEdit
    Left = 0
    Top = 0
    Width = 443
    Height = 275
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnMouseDown = reScriptMouseDown
    OnMouseUp = reScriptMouseUp
    OnURLClick = reScriptURLClick
  end
end
