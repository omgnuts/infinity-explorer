{ $Header: /cvsroot/InfExp/InfExp/src/FrameWAV.pas,v 1.2 2000/01/26 21:39:00 yole Exp $
  Infinity Engine WAV viewer frame
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit FrameWAV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MMSystem, Infinity, InfMain;

type
  TWAVFrame = class (TFrame, IGameFileFrame)
  private
    FWAVFile: TWAVFile;
  public
    // IGameFileFrame
    procedure IGameFileFrame.FreeFrame = Free;
    procedure IGameFileFrame.SetFrameParent = SetParent;
    procedure ViewFile (AFile: TGameFile);
    procedure CloseFile;
  end;

implementation

{$R *.DFM}

// -- TWAVFrame --------------------------------------------------------------

procedure TWAVFrame.ViewFile (AFile: TGameFile);
begin
  FWAVFile := AFile as TWAVFile;
end;

procedure TWAVFrame.CloseFile;
begin
  // do nothing
end;

end.
