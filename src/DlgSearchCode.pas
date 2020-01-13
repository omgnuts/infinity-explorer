{ $Header: /cvsroot/InfExp/InfExp/src/DlgSearchCode.pas,v 1.1 2000/02/23 18:45:10 yole Exp $
  Infinity Explorer code search dialog 
  Copyright (C) 2000 Dmitry Jemerov <yole@nnz.ru>
  See the file COPYING for license information
}

unit DlgSearchCode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TSearchCodeDlg = class (TForm)
    Label1: TLabel;
    EdtCodeString: TEdit;
    ChkSearchDialogs: TCheckBox;
    ChkSearchScripts: TCheckBox;
    BtnOK: TButton;
    BtnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
