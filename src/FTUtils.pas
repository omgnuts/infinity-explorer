{ $Header: /cvsroot/InfExp/InfExp/src/FTUtils.pas,v 1.1 2000/01/24 15:49:07 yole Exp $
  FidoTools utility functions
  Written by Yoletir / FaerieFire AKA Dmitry Jemerov, 2:5030/654

  To do:
}

unit FTUtils;

interface

{$I FTDefine.inc}

uses Windows, Classes, SysUtils;

type
  TMonthNames = array [1..12] of string [3];
  // TAlignment is defined in Forms, and we do not want to use it
  TFTAlignment = (ftaLeftJustify, ftaRightJustify, ftaCenter);

{--- String handling and conversion routines ---}

function Bytes2Str (Bytes: LongInt): string;
  { converts bytes to string (M, K)
    Values of K and M less than 10 are shown with 1 digit after the comma }
function KBytes2Str (KBytes: LongInt): string;
  { converts a size in Kbytes to a string (K, M, G) }
function CutBS (const S: string): string;
  { removes ending \ from string }
function MkPath (FName, DirName: string): string;
  { if FName contains no path, sets it to DirName }
function CutPath (S: string): string;
function StrCToInt (const S: string): LongInt;
  { converts numeric string with comma separators, like 1,234,567, to integer }
function Copy2SymbDelX (var S: string; Symb: char) : string;
  { similar to Copy2SymbDel, also deletes the delimiter symbol }
function RPos (C: char; const S: string): integer;
  { returns position of rightmost character C in string S, or
    0 if the character is not present }
function LoCase (C: char): char;
  { converts a single character to lower case }
function ReplaceStrI (const S, Srch, Replace : string) : string;
  { A case-insensitive version of the ReplaceStr function from RX Lib's
    StrUtils }

// Aligns a string padding it to required length
function StrAlign (const S: string; Alignment: TFTAlignment;
    MaxWidth: integer; PadChar: char; Truncate: boolean): string;

// Converts numeric string S to USA-format, separating three-digit groups
// with DigitSep char

function SeparateDigits (const S: string; DigitSep: char): string;

{$IFNDEF DELPHI_5UP}

{ SameText compares S1 to S2, without case-sensitivity. Returns true if
  S1 and S2 are the equal, that is, if CompareText would return 0. SameText
  has the same 8-bit limitations as CompareText }

function SameText(const S1, S2: string): Boolean;

{$ENDIF}

{--- Time related functions ---}

{ Converts time (in seconds) to a string (h:mm:ss). If HH=true, hours
  will be written with at least two digits }
function Time2Str (Secs : LongInt; HH : boolean) : string;
{ Converts time (in seconds) to a string (hh:mm or 123h) }
function Time2Minutes (Secs : LongInt) : string;
{ Converts a UnixTime to standard Delphi date format }
function UnixTime2DateTime (UnixTime : LongInt) : TDateTime;
{ Converts a TDateTime to UnixTime }
function DateTime2UnixTime (ADateTime : TDateTime) : LongInt;
{ Converts an MS-DOS timestamp to TDateTime. Returns 0 if either DosDate
  or DosTime is equal to 0. }
function DosDateToDateTime (DosDate, DosTime : word) : TDateTime;
{ Returns the date part of TDateTime converted to MS-DOS timestamp }
function DateTimeToDosDate (ADateTime : TDateTime) : word;
{ Returns the time part of TDateTime converted to MS-DOS timestamp }
function DateTimeToDosTime (ADateTime : TDateTime) : word;
{ Returns the day of the week for the specified date. Monday is day 1,
  Sunday is day 7. }
function DayOfWeekRus (ADateTime: TDateTime): integer;
{ Returns the latest of two dates }
function MaxDate (Date1, Date2: TDateTime): TDateTime;
{ Returns the earliest of two dates }
function MinDate (Date1, Date2: TDateTime): TDateTime;
{ Converts a two-digit year to integer (Y2K-friendly) }
function Str2Year (Year: string): word;

{ defined in WINNT.H but missing in WINDOWS.PAS }

const
  TIME_ZONE_ID_UNKNOWN  = 0;
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;

function GetTimeBias : integer;
  { Returns the difference in minutes between local time (including daylight savings)
    and UTC }
function UTCtoLocalTime (UTCTime : TDateTime) : TDateTime;
  { converts an UTC TDateTime to local time, based on W32 time zone
    information }
function LocalTimeToUTC (LocalTime : TDateTime) : TDateTime;
  { converts a local TDateTime to UTC time, based on W32 time zone
    information }

function Str2Month (const MonthStr : string) : integer;
  { converts a month name to corresponding month number using English
     month names}
function Str2MonthEx (const MonthStr : string; MNames : TMonthNames) : integer;
  { converts a month name to corresponding month number using provided
    month names table }
procedure SetMonthNames (MNames : TMonthNames);
  { sets ShortMonthNames from MNames }

{--- File and directory handling routines ---}

function FReadStr (var F : file; Buf : PChar; MaxLength : integer) : integer;
  { reads a null-terminated string from file, returns length of string }
function FSReadStr (F: TStream; Buf: PChar; MaxLength: integer) : integer;
  { reads a null-terminated string from a stream, returns length of string }

function CreateDirs (const Path : string) : boolean;
  { creates a directory tree. Returns true on success }
function CreateFlag (const FlagName : string) : boolean;
  { creates a flag file. Returns true on success, false if flag already
    exists. }

function IsDirEmpty (const Path : string) : boolean;
  { returns true if specified directory exists and is empty }

{--- Semaphore handling functions ---}

const
  SEMAPHORE_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or 3;
    { it is defined in winnt.h but missing in windows.pas }

function SemExists (const SemName : string) : boolean;
  { tests for the existence of specified semaphore }

{--- Debugging functions ---}

{$IFNDEF DELPHI_3OR4}

type
  EAssertionFailed = class (Exception);
  EWin32Error = class(Exception)
  public
    ErrorCode: DWORD;
  end;

{ a stub for a procedure in Delphi 3 RTL }
procedure Assert (Cond: boolean);

procedure RaiseLastWin32Error;
function Win32Check(RetVal: BOOL): BOOL;

{$ENDIF}

{ Outputs a debug string }
procedure Trace (const S: string);
{ Formats and outputs a debug string }
procedure TraceFmt (const Fmt: string; Args: array of const);
{ Asserts that Obj is a valid object }
procedure AssertValid (Obj: TObject);

{--- Miscellaneous functions ---}

{$IFDEF DELPHI_3OR4}
function ResStr(const Ident: string): string;  { from VCLUtils of RX Lib }
{$ELSE}
function ResStr (Ident: Cardinal): string;
{$ENDIF}

// -- List helper functions --------------------------------------------------

// Frees memory occupied by objects in the list and the list itself
procedure DestroyList (Lst: TList);
// the same for string list
procedure DestroyStringList (Lst: TStrings);

// Searches for an item in a sorted list, returns index or -1 if not found
function SearchList (AList: TList; AItem: Pointer;
    Compare: TListSortCompare): integer;

{--- Some functions from RX Lib's FileUtil ---}

function GetFileSize (const FileName : string) : Longint;
function DirExists (Name : string) : boolean;
function NormalDir (const DirName : string) : string;
function HasAttr (const FileName : string; Attr : Integer) : boolean;

procedure rxCopyFile (const FileName, DestName : string);
function MoveFile (const FileName, DestName : string) : boolean;

const
  EShortMonthNames : TMonthNames =
  ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

  { Useful constants }
  KByte=1024;
  MByte=1024*1024;
  HourSec=60*60;
  DaySec=60*60*24;

implementation

uses Consts, RTLConsts, RxStrUtils;

var UnixDate : TDateTime;

{--- String handling and conversion routines ---}

function Bytes2Str (Bytes: LongInt): string;
var
  Int, Fract : integer; {до и после зап€той}
begin
  if Bytes > 10*MByte then
    Result := IntToStr (Bytes div MByte) + 'M'
  else if Bytes >= MByte then begin
    Int := Bytes div MByte;
    Fract := (Bytes mod MByte) div (100*KByte); {остаток в килобайтах, 1 знак}
    Result := IntToStr (Int) + '.' + IntToStr (Fract) + 'M';
  end
  else if Bytes > 10*KByte then
    Result := IntToStr (Bytes div KByte) + 'K'
  else if Bytes >= KByte then begin
    Int := Bytes div KByte;
    Fract := (Bytes mod KByte) div 100;
    Result := IntToStr (Int) + '.' + IntToStr (Fract) + 'K';
  end
  else
    Result := IntToStr (Bytes);
end;

function KBytes2Str (KBytes: LongInt): string;
var Int, Fract : integer; {до и после зап€той}
begin
  if KBytes = 0 then Result := '0' {не добавл€ем K}
  else if KBytes >= 10*MByte then
    Result := IntToStr (KBytes div MByte) + 'G'
  else if KBytes >= 10*KByte then
    Result := IntToStr (KBytes div KByte) + 'M'
  else if KBytes >= KByte then begin
    Int := KBytes div KByte;
    Fract := (KBytes mod KByte) div 100;
    Result := IntToStr (Int) + '.' + IntToStr (Fract) + 'M';
  end
  else
    Result := IntToStr (KBytes) + 'K';
end;

function CutBS (const S: string): string;
begin
  Result := S;
  if Length (S) = 0 then Exit;
  if Result [Length (Result)] = '\' then
    Result := Copy (Result, 1, Length (Result)-1);
end;

function MkPath (FName, DirName: string): string;
begin
  if FName = '' then begin
    Result := '';
    Exit;
  end;
  if DirName = '' then Result := FName
  else if FName [2] = ':' then Result := FName {FName содержит им€ диска}
  else if FName [1] = '\' then begin
    {FName - полный путь. ƒобавим им€ диска.}
    if (Length (DirName) > 2) and (DirName [2] = ':') then
      Result := Copy (DirName, 1, 2) + FName;
  end else begin
    {FName - либо только им€ файла, либо частичный путь}
    if Copy (FName, 1, 2) = '.\' then Delete (FName, 1, 2);
    if DirName [Length (DirName)] = '\' then Result := DirName + FName
    else Result := DirName + '\' + FName;
  end;
end;

function CutPath (S: string): string;
var p : byte;
begin
  p := Length (S);
  if p = 0 then begin
    Result := '';
    Exit;
  end;
  repeat
    Dec (P);
  until (S [P] = '\') or (P = 1);
  if S [P] = '\' then Delete (S, 1, P);
  Result := S;
end;

function StrCToInt (const S: string): LongInt;
var
  S1 : string;
begin
  S1 := DelChars (S, ',');
  Result := StrToInt (S1);
end;

function RPos (C: char; const S: string): integer;
var i : integer;
begin
  {FIXME: optimize}
  Result := 0;
  for i := Length (S) downto 1 do
    if S [i] = C then begin
      Result := i;
      Break;
    end;
end;

function LoCase (C: char): char; assembler;
asm
{ ->    AL      Character       }
{ <-    AL      Result          }

        CMP     AL,'A'
        JB      @@exit
        CMP     AL,'Z'
        JA      @@exit
        ADD     AL,'a' - 'A'
@@exit:
end;

function ReplaceStrI (const S, Srch, Replace: string): string;
var
  I : integer;
  Source, SrchU : string;
begin
  Source := S;
  SrchU := UpperCase (Srch);
  Result := '';
  repeat
    I := Pos (SrchU, UpperCase (Source));
    if I > 0 then begin
      Result := Result + Copy (Source, 1, I - 1) + Replace;
      Source := Copy (Source, I + Length (Srch), MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;

function Copy2SymbDelX (var S: string; Symb: char): string;
begin
  Result := Copy2SymbDel (S, Symb);
  Delete (S, 1, 1);
end;

function StrAlign (const S: string; Alignment: TFTAlignment;
    MaxWidth: integer; PadChar: char; Truncate: boolean): string;
begin
  if Truncate and (Length (S) >= MaxWidth) then begin
    Result := Copy (S, 1, MaxWidth);
    Exit;
  end;
  case Alignment of
    ftaLeftJustify : Result := AddCharR (PadChar, S, MaxWidth);
    ftaRightJustify : Result := AddChar (PadChar, S, MaxWidth);
    ftaCenter :
      if Length (S) < MaxWidth then begin
        Result := MakeStr (PadChar, (MaxWidth div 2) - (Length(S) div 2)) + S;
        Result := Result + MakeStr (PadChar, MaxWidth - Length(Result));
      end;
  end;
end;

// based on Numb2USA function from RX Lib
function SeparateDigits (const S: string; DigitSep: char): string;
var
  I, NA: Integer;
begin
  I := Length(S);
  Result := S;
  NA := 0;
  while (I > 0) do begin
    if ((Length(Result) - I + 1 - NA) mod 3 = 0) and (I <> 1) then
    begin
      Insert(DigitSep, Result, I);
      Inc(NA);
    end;
    Dec(I);
  end;
end;

function SameText(const S1, S2: string): Boolean; assembler;
asm
        CMP     EAX,EDX
        JZ      @1
        OR      EAX,EAX
        JZ      @2
        OR      EDX,EDX
        JZ      @3
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JNE     @3
        CALL    CompareText
        TEST    EAX,EAX
        JNZ     @3
@1:     MOV     AL,1
@2:     RET
@3:     XOR     EAX,EAX
end;

{--- Time related functions ---}

function Time2Str (Secs: LongInt; HH: boolean): string;
begin
  if HH then Result := AddChar ('0', IntToStr (Secs div HourSec), 2)
  else Result := IntToStr (Secs div HourSec);
  Result := Result + ':' + AddChar ('0', IntToStr ((Secs div 60) mod 60), 2);
  Result := Result + ':' + AddChar ('0', IntToStr (Secs mod 60), 2);
end;

function Time2Minutes (Secs: LongInt): string;
var Min : string;
begin
  if Secs >= 100*HourSec then
    Result := IntToStr (Secs div HourSec) + 'h'
  else begin
    Min := IntToStr ((Secs div 60) mod 60);
    if Length (Min) = 1 {только 1 цифра} then
      Min := '0' + Min;
    Result := IntToStr (Secs div HourSec) + ':' + Min;
  end;
end;

function UnixTime2DateTime (UnixTime: LongInt): TDateTime;
begin
  if UnixTime = 0 then Result := 0
  else Result := UnixDate + UnixTime/DaySec;
end;

function DateTime2UnixTime (ADateTime: TDateTime): LongInt;
begin
  if ADateTime = 0 then Result := 0
  else Result := Trunc ((ADateTime-UnixDate) * DaySec);
end;

function DosDateToDateTime (DosDate, DosTime: word): TDateTime;
var
  da, mo, yr, ss, mm, hh : word;
begin
  if (DosDate = 0) or (DosTime = 0) then Result := 0
  else begin
    da := DosDate and $1F;
    mo := (DosDate shr 5) and $0F;
    yr := 1980 + (DosDate shr 9) and $7F;
    ss := (DosTime and $1F) * 2;
    mm := (DosTime shr 5) and $3F;
    hh := (DosTime shr 11) and $1F;
    try
      Result := EncodeDate (yr, mo, da) + EncodeTime (hh, mm, ss, 0);
    except
      Result := 0;
    end;
  end;
end;

function DateTimeToDosDate (ADateTime: TDateTime): word;
var
  yr, mo, da : word;
begin
  if ADateTime = 0 then Result := 0
  else begin
    DecodeDate (ADateTime, yr, mo, da);
    Result := (((yr - 1980) and $7F) shl 9) or
        ((mo and $0F) shl 5) or (da and $1F);
  end;
end;

function DateTimeToDosTime (ADateTime: TDateTime): word;
var
  hh, mm, ss, ms : word;
begin
  if ADateTime = 0 then Result := 0
  else begin
    DecodeTime (ADateTime, hh, mm, ss, ms);
    Result := ((hh and $1F) shl 11) or ((mm and $3F) shl 5) or
        ((ss div 2) and $1F);
  end;
end;

function GetTimeBias: integer;
var
  TZInfo : TTimeZoneInformation;
  TZID   : LongInt;
begin
  TZID := GetTimeZoneInformation (TZInfo);
  Result := TZInfo.Bias;   { bias is in minutes }
  if TZID = TIME_ZONE_ID_DAYLIGHT then
    Result := Result + TZInfo.DaylightBias;
end;

function UTCtoLocalTime (UTCTime: TDateTime) : TDateTime;
begin
  Result := UTCTime - GetTimeBias / (24*60);
end;

function LocalTimeToUTC (LocalTime: TDateTime) : TDateTime;
begin
  Result := LocalTime + GetTimeBias / (24*60);
end;

function Str2Month (const MonthStr: string) : integer;
begin
  Result := Str2MonthEx (MonthStr, EShortMonthNames);
end;

function Str2MonthEx (const MonthStr: string; MNames: TMonthNames) : integer;
var i : integer;
begin
  for i := 1 to 12 do
    if MNames [i] = MonthStr then begin
      Result := i;
      Exit;
    end;
  raise EConvertError.Create ('Invalid month ' + MonthStr);
end;

procedure SetMonthNames (MNames: TMonthNames);
var i : integer;
begin
  for i := 1 to 12 do
    ShortMonthNames [i] := MNames [i];
end;

function DayOfWeekRus (ADateTime: TDateTime): integer;
begin
  Result := DayOfWeek (ADateTime)-1;
  if Result = 0 then Result := 7;
end;

function MaxDate (Date1, Date2: TDateTime): TDateTime;
begin
  if Date1 > Date2 then Result := Date1
  else Result := Date2;
end;

function MinDate (Date1, Date2: TDateTime): TDateTime;
begin
  if Date1 < Date2 then Result := Date1
  else Result := Date2;
end;

function Str2Year (Year: string): word;
var
  Y: word;
  CurYear, M, D, CenturyBase: word;
begin
  Y := StrToInt (Year);
  DecodeDate (Now, CurYear, M, D);
  CenturyBase := CurYear - 80;
  Inc (Y, (CenturyBase div 100) * 100);
  if Y < CenturyBase then Inc (Y, 100);
  Result := Y;       
end;

{--- File and directory handling routines ---}

function FReadStr (var F: file; Buf: PChar; MaxLength: integer) : integer;
var
  i : integer;
  c : char;
begin
  Assert (Buf <> nil);
  i := 0;
  repeat
    BlockRead (F, c, 1);
    Buf [i] := c; Inc (i);
    if c=#0 then Break;
  until i=MaxLength;
  Buf [MaxLength-1] := #0;
  Result := i;
end;

function FSReadStr (F: TStream; Buf: PChar; MaxLength: integer): integer;
var
  i : integer;
  c : char;
begin
  Assert (F <> nil);
  Assert (Buf <> nil);
  i := 0;
  repeat
    F.Read (c, 1);
    Buf [i] := c; Inc (i);
    if c=#0 then Break;
  until i=MaxLength;
  Buf [MaxLength-1] := #0;
  Result := i;
end;

function CreateDirs (const Path: string): boolean;
var
  i : integer;
  FullPath, CurPath : string;
begin
  Result := false;
  FullPath := ExpandFileName (Path);
  CurPath := '';
  for i := 1 to WordCount (FullPath, ['\']) do begin
    CurPath := CurPath + ExtractWord (i, FullPath, ['\']) + '\';
    if not DirExists (CurPath) then begin
      if CreateDir (CurPath) = false then Exit;
    end;
  end;
  Result := true;
end;

function CreateFlag (const FlagName: string): boolean;
var
  HFlag : THandle;
  FlagPath : string;
begin
  Result := false;
  FlagPath := ExtractFilePath (FlagName);
  if (not DirExists (FlagPath)) and (not CreateDirs (FlagPath)) then Exit;
  HFlag := CreateFile (PChar (FlagName),
                       GENERIC_WRITE,
                       FILE_SHARE_READ,
                       nil,
                       CREATE_NEW,
                       FILE_ATTRIBUTE_NORMAL,
                       0);
  if HFlag = INVALID_HANDLE_VALUE then Exit;
  CloseHandle (HFlag);
  Result := true;
end;

function IsDirEmpty (const Path: string): boolean;
var SR : TSearchRec;
begin
  Result := false;
  if not DirExists (Path) then Exit;
  if FindFirst (NormalDir (Path) + '*',
      faReadOnly + faHidden + faSysFile + faArchive, SR) <> 0 then
    Result := true
  else
    FindClose (SR);
end;

{--- Semaphore handling functions ---}

function SemExists (const SemName: string): boolean;
var
  HSem : THandle;
begin
  Result := false;
  HSem := OpenSemaphore (SEMAPHORE_ALL_ACCESS, false, PChar (SemName));
  if HSem <> 0 then begin
    CloseHandle (HSem);
    Result := true;
  end;
end;

{--- Debugging functions ---}

{$IFNDEF DELPHI_3OR4}
procedure Assert (Cond: boolean);
begin
  if not Cond then raise EAssertionFailed.Create ('Assertion failed');
end;
{$ENDIF}

procedure Trace (const S: string);
begin
  {$IFDEF FTDEBUG}
  OutputDebugString (PChar (FormatDateTime ('hh:nn:ss ', Now)  + S));
  {$ENDIF}
end;

procedure TraceFmt (const Fmt: string; Args: array of const);
begin
  Trace (Format (Fmt, Args));
end;

procedure AssertValid (Obj: TObject);
type
  PPChar = ^PChar;
  TIsValidProc = procedure of object;
  PIsValidProc = ^TIsValidProc;
{$IFDEF FTOBJCHECK}
var
  PVMT : PChar;
  IsValidProc: PIsValidProc;
{$ENDIF}
begin
  {$IFDEF FTDEBUG}
  if Obj = nil then
    raise EAssertionFailed.Create ('AssertValid fails with nil pointer');
  {$IFDEF FTOBJCHECK}
  PVMT := (PPChar (Obj))^;
  if IsBadReadPtr (PVMT+vmtSelfPtr, -vmtSelfPtr) then
    raise EAssertionFailed.Create ('AssertValid fails with bad VMT pointer');
  if IsBadReadPtr (Obj, Obj.ClassType.InstanceSize) then
    raise EAssertionFailed.Create ('Assertvalid fails with bad object pointer');
  IsValidProc := PIsValidProc (Obj.ClassType.MethodAddress ('IsValid'));
  if IsValidProc <> nil then IsValidProc^;
  {$ENDIF}
  {$ENDIF}
end;

// -- Miscellaneous functions ------------------------------------------------

{$IFNDEF DELPHI_3OR4}

function ResStr (Ident: Cardinal) : string;
begin
  Result := LoadStr (Ident);
end;

{ RaiseLastWin32Error }

procedure RaiseLastWin32Error;
var
  LastError: DWORD;
  Error: EWin32Error;
begin
  LastError := GetLastError;
  if LastError <> ERROR_SUCCESS then
    Error := EWin32Error.CreateFmt('Win32 error %d (%s)', [LastError,
      SysErrorMessage(LastError)])
  else
    Error := EWin32Error.Create('Unknown Win32 error');
  Error.ErrorCode := LastError;
  raise Error;
end;

{ Win32Check }

function Win32Check(RetVal: BOOL): BOOL;
begin
  if not RetVal then RaiseLastWin32Error;
  Result := RetVal;
end;

{$ELSE}
function ResStr (const Ident: string) : string;
begin
  Result := Ident;
end;
{$ENDIF}

// -- List helper functions --------------------------------------------------

procedure DestroyList (Lst : TList);
var i : integer;
begin
  if Lst = nil then Exit;
  for i := Lst.Count-1 downto 0 do
    TObject (Lst [i]).Free;
  Lst.Free;
end;

procedure DestroyStringList (Lst : TStrings);
var i : integer;
begin
  if Lst = nil then Exit;
  for i := Lst.Count-1 downto 0 do
    if Lst.Objects [i] <> nil then
      Lst.Objects [i].Free;
  Lst.Free;
end;

function SearchList (AList: TList; AItem: Pointer;
    Compare: TListSortCompare): integer;
var
  Found: boolean;
  i    : integer;
  MinElem, NElem, Probe, t: integer;
begin
  Assert (AList <> nil);
  Assert (AItem <> nil);
  Found := false;
  MinElem := 0;
  NElem := AList.Count;
  repeat
    t := NElem shr 1;
    Probe := MinElem + t;
    i := Compare (AItem, AList [Probe]);
    if i = 0 then Found := true
    else if i = -1 then begin
      MinElem := Probe + 1;
      NElem := NElem - t - 1;
    end
    else NElem := t;
  until Found or (NElem = 0);
  if Found then Result := Probe
  else Result := -1;
end;

{--- Some functions from RX Lib's FileUtil ---}

function GetFileSize (const FileName: string): Longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
  FindClose(SearchRec);
end;

function DirExists (Name: string): boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function NormalDir (const DirName: string) : string;
begin
  Result := DirName;
  if (Result <> '') and not (Result[Length(Result)] in [':', '\']) then
  begin
    if (Length(Result) = 1) and (UpCase(Result[1]) in ['A'..'Z']) then
      Result := Result + ':\'
    else Result := Result + '\';
  end;
end;

function HasAttr (const FileName: string; Attr: Integer): Boolean;
var
  FileAttr: Integer;
begin
  FileAttr := FileGetAttr(FileName);
  Result := (FileAttr >= 0) and (FileAttr and Attr = Attr);
end;

procedure rxCopyFile (const FileName, DestName: string);
var
  CopyBuffer: Pointer;
  Source, Dest: Integer;
  Destination: TFileName;
  BytesCopied : Longint;
const
  ChunkSize: Longint = 8192;
begin
  Destination := DestName;
  if HasAttr(Destination, faDirectory) then
    Destination := NormalDir(Destination) + ExtractFileName(FileName);
  GetMem(CopyBuffer, ChunkSize);
  try
    Source := FileOpen(FileName, fmShareDenyNone);
    if Source < 0 then
      raise EFOpenError.CreateFmt(ResStr(SFOpenError), [FileName]);
    try
      Dest := FileCreate(Destination);
      if Dest < 0 then
        raise EFCreateError.CreateFmt(ResStr(SFCreateError), [Destination]);
      try
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize);
          if BytesCopied = -1 then
            raise EReadError.Create(ResStr(SReadError));
          if BytesCopied > 0 then begin
            if FileWrite(Dest, CopyBuffer^, BytesCopied) = -1 then
              raise EWriteError.Create(ResStr(SWriteError));
          end;
        until BytesCopied < ChunkSize;
        FileSetDate(Dest, FileGetDate(Source));
      finally
        FileClose(Dest);
      end;
    finally
      FileClose(Source);
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize);
  end;
end;

function MoveFile (const FileName, DestName: string): boolean;
var
  Destination : string;
  Attr : integer;
begin
  Result := true;
  Destination := ExpandFileName (DestName);
  if not RenameFile (FileName, Destination) then begin
    Attr := FileGetAttr (FileName);
    if Attr < 0 then Exit;
    if (Attr and faReadOnly) <> 0 then
      FileSetAttr(FileName, Attr and not faReadOnly);
    rxCopyFile (FileName, Destination);
    DeleteFile (FileName);
  end;
end;

initialization
  UnixDate := EncodeDate (1970, 1, 1);

{
  $Log: FTUtils.pas,v $
  Revision 1.1  2000/01/24 15:49:07  yole
  Added FidoTools units used by InfExp.

  
  7     12.09.99 21:49 Yole
  ported to Virtual Pascal/W32; fixed another FText bug in MsgBase

  6     16.08.99 12:46 Yole
  DestroyList and DestroyStringList moved here from LogUtils

  5     18.06.99 15:46 Yole
  now compiles without hints with FTOBJCHECK not defined

  4     14.11.98 23:22 Yole
  dropped 16-bit compatibility; added SeparateDigits

  3     12.11.98 14:59 Yole
  added StrAlign function

  2     6.11.98 13:53 Yole
  added date processing and debugging functions
  Revision 1.16  1998-07-03 13:14:59+04  yole
  Delphi 4 support

  Revision 1.15  1998-06-29 14:40:21+04  yole
  added FSReadStr

  Revision 1.14  1998-05-20 22:45:13+04  yole
  added IsDirEmpty

  Revision 1.13  1998-05-07 10:21:57+04  yole
  added ReplaceStrI

  Revision 1.12  1998-04-28 11:24:50+04  yole
  rewritten Time2Str

  Revision 1.11  1998-04-25 13:30:40+04  yole
  added Win16 stub for FindClose

  Revision 1.10  1998-04-25 11:48:32+04  yole
  added SetMonthNames

  Revision 1.9  1998-04-02 22:52:42+03  yole
  added more functions from RX Lib; added Win16 version of MoveFile

  Revision 1.8  1998-03-31 23:40:44+03  yole
  Win16 compatibility, translated comments in interface

  Revision 1.7  1998-03-31 20:19:57+03  yole
  added Str2MonthEx

  Revision 1.6  1998-03-29 09:54:12+03  yole
  added MoveFile

  Revision 1.5  1998-03-26 19:24:24+03  yole
  added const where applicable

  Revision 1.4  1998-03-20 20:20:52+03  yole
  Added NormalDir and SemExists

  Revision 1.3  1998-03-19 14:27:10+03  yole
  added CreateDirs

  Revision 1.2  1998-02-11 11:07:19+03  yole
  added some functions from FileUtil

  Revision 1.1  1998-02-11 11:03:29+03  yole
  Initial revision
}

end.
