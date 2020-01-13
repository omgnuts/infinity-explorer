{ $Header: /cvsroot/InfExp/InfExp/src/DlgAbout.pas,v 1.3 2000/02/07 15:15:58 yole Exp $
  Infinity Explorer: About box
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit DlgAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellAPI;

type
  TAboutDialog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    BtnOK: TButton;
    Label6: TLabel;
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses InfMain;

procedure TAboutDialog.Label3Click (Sender: TObject);
begin
  ShellExecute (MainForm.Handle, 'open', PChar ((Sender as TLabel).Caption), nil, nil, 0);
end;

end.
