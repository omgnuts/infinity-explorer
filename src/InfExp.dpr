program InfExp;

uses
  Forms,
  InfMain in 'InfMain.pas' {MainForm},
  Infinity in 'Infinity.pas',
  FrameMOS in 'FrameMOS.pas' {MOSFrame: TFrame},
  FrameDLG in 'FrameDLG.pas' {DlgFrame: TFrame},
  SCDecomp in 'SCDecomp.pas',
  InfStruc in 'InfStruc.pas',
  FrameSCR in 'FrameSCR.pas' {TextFrame: TFrame},
  DlgOpenG in 'DlgOpenG.pas' {OpenGameDialog},
  FrameBAM in 'FrameBAM.pas' {BAMFrame: TFrame},
  DlgAbout in 'DlgAbout.pas' {AboutDialog},
  FrameARE in 'FrameARE.pas' {AreaFrame: TFrame},
  FrameBMP in 'FrameBMP.pas' {BMPFrame: TFrame},
  FrameCRE in 'FrameCRE.pas' {CREFrame: TFrame},
  FrameITM in 'FrameITM.pas' {ITMFrame: TFrame},
  FrameQuest in 'FrameQuest.pas' {QuestFrame: TFrame},
  FrameAreaNPC in 'FrameAreaNPC.pas' {AreaNPCFrame: TFrame},
  FrameAreaInfo in 'FrameAreaInfo.pas' {AreaInfoFrame: TFrame},
  FrameAreaDoor in 'FrameAreaDoor.pas' {AreaDoorFrame: TFrame},
  FrameAreaCntr in 'FrameAreaCntr.pas' {AreaCntrFrame: TFrame},
  DlgSearchCode in 'DlgSearchCode.pas' {SearchCodeDlg},
  FrameAreaGeneral in 'FrameAreaGeneral.pas' {AreaGeneralFrame: TFrame},
  FrameSPL in 'FrameSPL.pas' {SPLFrame: TFrame},
  FrameAbility in 'FrameAbility.pas' {AbilityFrame: TFrame},
  FrameChUIPanel in 'FrameChUIPanel.pas' {ChUIPanelFrame: TFrame},
  FrameWMapArea in 'FrameWMapArea.pas' {WMapAreaFrame: TFrame},
  InfGraphics in 'InfGraphics.pas',
  FrameAreaAnim in 'FrameAreaAnim.pas' {AreaAnimFrame: TFrame},
  DlgStrref in 'DlgStrref.pas' {StrrefForm},
  FrameSTOR in 'FrameSTOR.pas' {StoreFrame: TFrame},
  FrameSaveGame in 'FrameSaveGame.pas' {SaveGameFrame: TFrame},
  FrameAreaVars in 'FrameAreaVars.pas' {AreaVarsFrame: TFrame},
  FTUtils in 'FTUtils.pas',
  FrameAreaSpawn in 'FrameAreaSpawn.pas' {AreaSpawnFrame: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Infinity Explorer';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
