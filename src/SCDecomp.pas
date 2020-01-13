{ $Header: /cvsroot/InfExp/InfExp/src/SCDecomp.pas,v 1.10 2000/11/01 19:00:14 yole Exp $
  Infinity Engine AI script decompiler
  Copyright (C) 2000-02 Dmitry Jemerov <yole@yole.ru>
  See the file COPYING for license information
}

unit SCDecomp;

interface

uses Classes, SysUtils, Infinity, InfStruc;

type
  // a function is either a trigger or an action

  TScriptParameter = record
    ParamType: char;
    ParamIndex: integer;   // 1-based index in parameters of the same type
    Name: string;
    IDSFile: string;
  end;

  TScriptFunction = record
    Index: integer;
    Name: string;
    Parameters: array of TScriptParameter;
    GlobalHack: boolean;
  end;

  TScriptFunctionList = class
  public
    Functions: array of TScriptFunction;
    constructor Create (IDS: TIDSFile);
    function ParseIDSString (S: string; Index: integer): TScriptFunction;
    function FindFunction (Index: integer; var Func: TScriptFunction): boolean;
  end;

  TScriptDecompiler = class
  private
    FResult: TStrings;
    Triggers, Actions: TScriptFunctionList;
    Objects: TIDSFile;
    Specifics: array [1..9] of TIDSFile;
    FForFile: boolean;
    FOrCount: integer;
    procedure DecompileCondResponce (const CR: TScriptCondResponce);
    procedure DecompileTrigger (const TR: TScriptTrigger);
    procedure DecompileResponce (const RS: TScriptResponce);
    procedure DecompileAction (const AC: TScriptAction);
    function IntArgToStr (const Param: TScriptParameter; IntArg: integer): string;
    function ObjectToStr (const OB: TScriptObject): string;
    function PointToStr (const Point: TScriptPoint): string;
    function StrArgToStr (const Func: TScriptFunction; Index: integer;
        const StrArgs: array of string): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Decompile (Scr: TScriptFile; Result: TStrings; ForFile: boolean = false);
  end;

implementation

uses FTUtils, Dialogs;

{ TScriptFunctionList }

constructor TScriptFunctionList.Create (IDS: TIDSFile);
var
  i: integer;
begin
  SetLength (Functions, IDS.Strings.Count);
  for i := 0 to IDS.Strings.Count-1 do
    Functions [i] := ParseIDSString (IDS.Strings [i], Integer (IDS.Strings.Objects [i]));
end;

function TScriptFunctionList.FindFunction (Index: integer;
  var Func: TScriptFunction): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to Length (Functions)-1 do
    if Functions [i].Index = Index then begin
      Func := Functions [i];
      Result := true;
      Exit;
    end;
end;

function TScriptFunctionList.ParseIDSString (S: string;
  Index: integer): TScriptFunction;
var
  P: integer;
  Param: TScriptParameter;
  i: integer;

  function PosOneOf (const S: string; const Chars: string): integer;
  var
    i: integer;
  begin
    Result := 0;
    for i := 1 to Length (S) do
      if Pos (S [i], Chars) <> 0 then begin
        Result := i;
        Exit;
      end;
  end;

begin
  SetLength (Result.Parameters, 0);
  Result.Index := Index;
  P := Pos ('(', S);
  Assert (P <> 0);
  Result.Name := Copy (S, 1, P-1);
  Result.GlobalHack := (Pos ('Global', Result.Name) <> 0) or
      (Pos ('Bit', Result.Name) <> 0) or
      (Result.Name = 'CreateCreatureAtLocation');
  if Result.GlobalHack and (Result.Name = 'MoveGlobal') then
    Result.GlobalHack := false;
  Delete (S, 1, P);
  while S [1] <> ')' do begin
    S := Trim (S);
    Param.ParamType := S [1];
    Param.ParamIndex := 1;
    for i := 0 to Length (Result.Parameters)-1 do
      if Result.Parameters [i].ParamType = Param.ParamType then
        Inc (Param.ParamIndex);
    Assert (S [2] = ':');
    Delete (S, 1, 2);
    P := PosOneOf (S, '*,)');
    Param.Name := Copy (S, 1, P-1);
    Delete (S, 1, P-1);
    if S [1] = '*' then begin
      Delete (S, 1, 1);
      if not (S [1] in [',', ')']) then begin
        P := Pos (',', S);
        if P = 0 then P := Pos (')', S);
        Param.IDSFile := Copy (S, 1, P-1);
        Delete (S, 1, P-1);
      end;
    end;
    SetLength (Result.Parameters, Length (Result.Parameters)+1);
    Result.Parameters [Length (Result.Parameters)-1] := Param;
    if S [1] = ',' then Delete (S, 1, 1);
  end;
end;

{ TScriptDecompiler }

constructor TScriptDecompiler.Create;
var
  IDS: TIDSFile;
  i: integer;
begin
  IDS := Game.GetFileByName ('Action', ftIDS) as TIDSFile;
  Actions := TScriptFunctionList.Create (IDS);
  IDS := Game.GetFileByName ('Trigger', ftIDS) as TIDSFile;
  Triggers := TScriptFunctionList.Create (IDS);
  Objects := Game.GetFileByName ('Object', ftIDS) as TIDSFile;
  Objects.Lock;
  Specifics [1] := Game.GetFileByName ('EA', ftIDS) as TIDSFile;
  Specifics [2] := Game.GetFileByName ('General', ftIDS) as TIDSFile;
  Specifics [3] := Game.GetFileByName ('Race', ftIDS) as TIDSFile;
  Specifics [4] := Game.GetFileByName ('Class', ftIDS) as TIDSFile;
  Specifics [5] := Game.GetFileByName ('Specific', ftIDS) as TIDSFile;
  Specifics [6] := Game.GetFileByName ('Gender', ftIDS) as TIDSFile;
  Specifics [7] := Game.GetFileByName ('Align', ftIDS) as TIDSFile;
  // two following IDS files are available only in Torment
  Specifics [8] := Game.GetFileByName ('Faction', ftIDS) as TIDSFile;
  Specifics [9] := Game.GetFileByName ('Team', ftIDS) as TIDSFile;
  for i := 1 to 9 do
    if Specifics [i] <> nil then Specifics [i].Lock;
end;

destructor TScriptDecompiler.Destroy;
begin
  Actions.Free;
  Triggers.Free;
  inherited Destroy;
end;

function TScriptDecompiler.IntArgToStr (const Param: TScriptParameter;
  IntArg: integer): string;
var
  IDS: TIDSFile;
begin
  if Param.IDSFile = '' then begin
    if not FForFile and SameText (Param.Name, 'StrRef') and
        Game.TLK.ValidID (IntArg)
    then
      Result := '''' + Game.TLK.Text [IntArg] + ''''
    else
      Result := IntToStr (IntArg);
    Exit;
  end;
  IDS := Game.GetFileByName (Param.IDSFile, ftIDS) as TIDSFile;
  if IDS = nil then
    Result := IntToStr (IntArg)
  else
    Result := IDS.LookupString (IntArg); 
end;

function IsRectEmpty (R: TScriptRect): boolean;
begin
  Result := (R.X1 = -1) and (R.Y1 = -1) and (R.X2 = -1) and (R.Y2 = -1);
end;

function IsObjectEmpty (const OB: TScriptObject): boolean;
var
  i: integer;
begin
  if (OB.StrArg <> '') or not IsRectEmpty (OB.RectArg) or (OB.Ident [1] <> 0) then
    Result := false
  else begin
    Result := true;
    for i := 1 to 9 do
      if OB.IntArg [i] <> 0 then begin
        Result := false;
        Break;
      end;
  end;
end;

function TScriptDecompiler.ObjectToStr (const OB: TScriptObject): string;
var
  i, LastSpecific: integer;
  S: string;
begin
  if OB.StrArg <> '' then
    S := '"'+OB.StrArg+'"'
  else if not IsRectEmpty (OB.RectArg) then
    with OB.RectArg do
      S := Format ('[%d.%d.%d.%d]', [X1, Y1, X2, Y2])
  else begin
    LastSpecific := 0;
    for i := 9 downto 1 do
      if OB.IntArg [i] <> 0 then begin
        LastSpecific := i;
        Break;
      end;
    if LastSpecific = 0 then
      S := '[]'
    else begin
      S := '[';
      for i := 1 to LastSpecific do begin
        if i > 1 then S := S + '.';
        if OB.IntArg [i] <> 0 then begin
          if Specifics [i] = nil then begin
            MessageDlg (Format ('unknown IntArg %d <> 0', [i]), mtError, [mbOk], 0);
            S := S + Format ('IA%d=%d', [i, OB.IntArg [i]]);
          end
          else S := S + Specifics [i].LookupString (OB.IntArg [i]);
        end
        else
          S := S + '0';
      end;
      S := S + ']';
    end;
  end;
  if OB.Ident [1] <> 0 then begin
    for i := 1 to 5 do begin
      if OB.Ident [i] = 0 then Break;
      if S = '[]' then
        S := Objects.LookupString (OB.Ident [i])
      else
        S := Objects.LookupString (OB.Ident [i])+'('+S+')';
    end;
  end;
  if S = '[]' then
    Result := '[ANYONE]'
  else
    Result := S;
end;

function TScriptDecompiler.PointToStr (const Point: TScriptPoint): string;
begin
  Result := '['+IntToStr (Point.X)+'.'+IntToStr (Point.Y)+']';
end;

function TScriptDecompiler.StrArgToStr (const Func: TScriptFunction;
  Index: integer; const StrArgs: array of string): string;
var
  Param: TScriptParameter;
  i, StrParamCount: integer;
begin
  // GLOBAL hack
  StrParamCount := 0;
  for i := Length (Func.Parameters)-1 downto 0 do
    if Func.Parameters [i].ParamType = 'S' then begin
       StrParamCount := Func.Parameters [i].ParamIndex;
       Break;
    end;
  Param := Func.Parameters [Index];
  // in Baldur's Gate, GlobalTimerExpired is written like this:
  // 16448 0 0 0 0 "Revenant" "GLOBAL"
  // so we need to autodetect this and disable the GLOBAL hack if there
  // are two non-empty string arguments
  if Func.GlobalHack and ((StrParamCount > 2) or (StrArgs [1] = ''))
  then begin
    if Param.ParamIndex > 4 then
      raise Exception.CreateFmt ('Too many Global S: params for function %s', [Func.Name]);
    if Param.ParamIndex mod 2 = 0 then
      Result := Copy (StrArgs [(Param.ParamIndex+1) div 2-1], 1, 6)
    else begin
      Result := Copy (StrArgs [(Param.ParamIndex+1) div 2-1], 7, 255);
      if (Length (Result) > 0) and (Result [1] = ':') then
        Delete (Result, 1, 1);
    end;
  end
  else begin
    if Param.ParamIndex > 2 then
      raise Exception.CreateFmt ('Too many S: params for function %s', [Func.Name]);
    Result := StrArgs [Param.ParamIndex-1];
  end;
end;

procedure TScriptDecompiler.Decompile (Scr: TScriptFile; Result: TStrings; ForFile: boolean);
var
  i: integer;
begin
  FResult := Result;
  FForFile := ForFile;
  FOrCount := 0;
  Result.BeginUpdate;
  try
    Result.Clear;
    for i := 0 to Length (Scr.CondResponces)-1 do
      DecompileCondResponce (Scr.CondResponces [i]);
  finally
    Result.EndUpdate;
    FResult := nil;
  end;
end;

procedure TScriptDecompiler.DecompileCondResponce (const CR: TScriptCondResponce);
var
  i: integer;
begin
  FResult.Add ('IF');
  for i := 0 to Length (CR.Condition)-1 do
    DecompileTrigger (CR.Condition [i]);
  FResult.Add ('THEN');
  for i := 0 to Length (CR.Responce)-1 do
    DecompileResponce (CR.Responce [i]);
  FResult.Add ('END');
  FResult.Add ('');
end;

procedure TScriptDecompiler.DecompileTrigger (const TR: TScriptTrigger);
var
  Func: TScriptFunction;
  S: string;
  i: integer;
  comments: string;
begin
	
  comments:='';
  if not Triggers.FindFunction (TR.TriggerID, Func) then begin
    //raise Exception.CreateFmt ('Invalid trigger index %d', [TR.TriggerID]);
    
	FResult.Add (Format ('  Invalid trigger index %d', [TR.TriggerID]));
    Exit;
  end;
  if FOrCount > 0 then begin
    Dec (FOrCount);
    S := '    ';
  end
  else
    S := '  '; 	
  
  if not FForFile and SameText (Func.Name, 'OR') then
    FOrCount := TR.IntArg [1];
  if TR.IntArg [2] <> 0 then S := S + '!';
  S := S + Func.Name + '(';
  for i := 0 to Length (Func.Parameters)-1 do begin
    if i > 0 then S := S + ',';
    with Func.Parameters [i] do
      case ParamType of
        'O': begin
          if ParamIndex > 1 then raise Exception.Create ('Too many O: params for trigger');
          S := S + ObjectToStr (TR.ObjArg);
        end;
        'I': begin
          if ParamIndex > 3 then
            raise Exception.Create ('Too many I: params for trigger ' + Func.Name);
          if ParamIndex = 1 then

          	begin
          	  if Func.Parameters [i].Name = 'StrRef' then
              begin
	            S := S + IntToStr(TR.IntArg [1]);
              	comments := ' // ' + IntArgToStr (Func.Parameters [i], TR.IntArg [1]);
              end
              else
               	S := S + IntArgToStr (Func.Parameters [i], TR.IntArg [1]); 
            end
            
          else
          	begin
              S := S + IntArgToStr (Func.Parameters [i], TR.IntArg [ParamIndex+1]);
            end;
        end;
        'S': S := S + '"' + StrArgToStr (Func, i, TR.StrArg) + '"';
        'P': S := S + PointToStr (TR.PointArg);
        else raise Exception.CreateFmt ('Unknown parameter type %s', [ParamType]);
      end;
  end;
  
  S := S + ')' ;
  
  FResult.Add (S + comments); 
end;

procedure TScriptDecompiler.DecompileResponce (const RS: TScriptResponce);
var
  i: integer;
begin
  FResult.Add (Format ('  RESPONSE #%d', [RS.Probability]));
  for i := 0 to Length (RS.Actions)-1 do
    DecompileAction (RS.Actions [i]);
end;

procedure TScriptDecompiler.DecompileAction (const AC: TScriptAction);
var
  Func: TScriptFunction;
  S: string;
  i: integer;
  comments: string;
begin
 
  comments:=''; 
  
  if not Actions.FindFunction (AC.ActionID, Func) then
    raise Exception.CreateFmt ('Invalid action index %d', [AC.ActionID]);
  S := Func.Name + '(';
  for i := 0 to Length (Func.Parameters)-1 do begin
    if i > 0 then S := S + ',';
    with Func.Parameters [i] do
      case ParamType of
        'O': begin
          if ParamIndex > 2 then raise Exception.Create ('Too many O: params for action');
          S := S + ObjectToStr (AC.ObjArg [ParamIndex+1])
        end;
        'I': begin
          if ParamIndex > 3 then raise Exception.Create ('Too many I: params for action');
          if ParamIndex = 1 then
        		begin
              if Func.Parameters [i].Name = 'StrRef' then
                begin
                	S := S + IntToStr (AC.IntArg);
                  comments:= ' // ' + IntArgToStr (Func.Parameters [i], AC.IntArg);
                end
              else
              		S := S + IntArgToStr (Func.Parameters [i], AC.IntArg);
            end
          else
              begin
                S := S + IntArgToStr (Func.Parameters [i], AC.IntArg2 [ParamIndex]);
              end;
						end;
        'S': S := S + '"' + StrArgToStr (Func, i, AC.StrArg) + '"';
        'P': S := S + PointToStr (AC.PointArg);
        else raise Exception.CreateFmt ('Unknown parameter type %s', [ParamType]);
      end;
  end;
  S := S + ')';
  if not IsObjectEmpty (AC.ObjArg [1]) then
    S := 'ActionOverride(' + ObjectToStr (AC.ObjArg [1]) + ',' + S + ')';
  FResult.Add ('    ' + S + comments);
end;

end.
