{ $Header: /cvsroot/InfExp/InfExp/src/FTDefine.inc,v 1.1 2000/01/24 15:49:07 yole Exp $
  FidoTools: miscellaneous defines shared by all units
  Written by Yoletir / FaerieFire AKA Dmitry Jemerov, 2:5030/654
}

{ Defines for specific projects }
{.$DEFINE WINLOG}
{.$DEFINE FTTEST}
{$DEFINE LITE}
{.$DEFINE TWINED}
{.$DEFINE UUESTAT}
{.$DEFINE FTOINFO}
{.$DEFINE OEXPLORER}

{ Define this to enable multi-threaded support in FidoTools.
  Currently multithreading support has been roughly implemented in Outbound.
  All the other units are NOT thread-safe. This will be fixed in future. }
{.$DEFINE MT}

{ Define this to enable FidoTools units to get message strings from a .LNG
  file (using Lng unit). The following strings are used by different units:

  FidoAddr:
  ---------
  FidoAddr.InvAddr: Invalid address %s
  FidoAddr.NoMask: %s: Wildcards not allowed here

  QParser:
  --------
  QParser.DupKeyword, QParser.Unmatch, QParser.CantOpen, QParser.CantChdir,
  QParser.BadDefine, QParser.BadInclude, QParser.BadBool, QParser.Missing,
  QParser.NoFile, QParser.NoDir

  TNdx:
  -----
  TNdx.NoFilesIndex, TNdx.BadVersion
}
{.$DEFINE USE_LNG}

{ Define this to remove all GUI-specific FidoTools code (to reduce code size) }
{$DEFINE CONSOLE}

{ Define this to include support for .PKT messagebase format in MsgBase }
{$DEFINE USE_PKT}

{ Define this to include support for Squish message base format in MsgBase }
{$DEFINE USE_SQUISH}

{ Define this to include support for JAM message base format in MsgBase }
{$DEFINE USE_JAM}

{ Define this to make TFTIniFile equal to TRegIniFile }
{.$DEFINE USE_REG}

{ Define this to make TFTIniFile equal to TRxIniFile }
{.$DEFINE USE_RXINI}

{ Define this to add TRxIniFile-compatible methods to TFTIniFile }
{.$DEFINE RXREGINI}

{ Define this to enable all kinds of debug code and paranoia in FidoTools }
{$DEFINE FTDEBUG}
{ Define this to enable valid pointer and object state checks in AssertValid }
{.$DEFINE FTOBJCHECK}

{ Define this to enable assembler optimizations in FidoTools }
{.$DEFINE USE_ASM}

{---------------------------------------------------------------------------
   All the code below is NOT for user customization
 ---------------------------------------------------------------------------}

{$IFDEF VER100}
  {$DEFINE DELPHI_3OR4}
  {$UNDEF DELPHI_4UP}
  {$UNDEF DELPHI_5UP}
  {$DEFINE CONSOLE}
{$ENDIF}

{$IFDEF VER120}
  {$DEFINE DELPHI_3OR4}
  {$DEFINE DELPHI_4UP}
  {$UNDEF DELPHI_5UP}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE DELPHI_3OR4}
  {$DEFINE DELPHI_4UP}
  {$DEFINE DELPHI_5UP}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE DELPHI_3OR4}
  {$DEFINE DELPHI_4UP}
  {$DEFINE DELPHI_5UP}
{$ENDIF}

{$IFDEF WINLOG}
  {$DEFINE USE_LNG}
  {$DEFINE USE_REG}
  {$UNDEF USE_RXINI}
  {$DEFINE RXREGINI}
  {$UNDEF CONSOLE}
{$ENDIF}

{$IFDEF FTTEST}
  {$UNDEF USE_LNG}
  {$DEFINE USE_PKT}
  {$DEFINE USE_SQUISH}
  {$DEFINE USE_JAM}
  {$DEFINE FTDEBUG}
  {$UNDEF CONSOLE}
{$ENDIF}

{$IFDEF UUESTAT}
  {$DEFINE LITE}
{$ENDIF}

{$IFDEF LITE}
  {$UNDEF USE_LNG}
  {$UNDEF USE_PKT}
  {$UNDEF USE_SQUISH}
  {$UNDEF USE_JAM}
  {$DEFINE CONSOLE}
{$ENDIF}

{$IFDEF UUESTAT}
  {$DEFINE USE_PKT}
{$ENDIF}

{$IFDEF FTOINFO}
  {$UNDEF USE_LNG}
  {$DEFINE USE_PKT}
  {$DEFINE USE_SQUISH}
  {$DEFINE USE_JAM}
  {$DEFINE CONSOLE}
  {$UNDEF USE_RXINI}
  {$UNDEF RXREGINI}
{$ENDIF}

{$IFDEF TWINED}
  {$UNDEF USE_LNG}
  {$UNDEF USE_PKT}
  {$DEFINE USE_SQUISH}
  {$DEFINE USE_JAM}
  {$UNDEF CONSOLE}
  {$DEFINE RXREGINI}
{$ENDIF}

{$IFDEF OEXPLORER}
  {$DEFINE USE_LNG}
  {$DEFINE USE_PKT}
  {$UNDEF USE_SQUISH}
  {$UNDEF USE_HUDSON}
  {$UNDEF CONSOLE}
  {$DEFINE RXREGINI}
{$ENDIF}

{$IFDEF RXREGINI}
  {$DEFINE USE_REG}
{$ENDIF}

{$IFNDEF WIN32}
  {$UNDEF USE_REG}
{$ENDIF}

{$IFDEF WIN32}
  {$UNDEF USE_RXINI}
{$ENDIF}

{$IFNDEF WIN32}
  {$UNDEF RXREGINI}
  {$UNDEF FTOBJCHECK}
{$ENDIF}

{$IFNDEF VIRTUALPASCAL}
  {$DEFINE USE_INI}
{$ELSE}
  {$UNDEF USE_RXINI}
  {$UNDEF RXREGINI}
{$ENDIF}

{$IFDEF VIRTUALPASCAL}
  {$UNDEF USE_ASM}
{$ENDIF}

{$IFDEF DELPHI_3OR4}
  {$IFDEF FTDEBUG}
  {$ASSERTIONS ON}
{$ELSE}
  {$ASSERTIONS OFF}
  {$ENDIF}
{$ENDIF}

{
  $Log: FTDefine.inc,v $
  Revision 1.1  2000/01/24 15:49:07  yole
  Added FidoTools units used by InfExp.

 *
 * 3     12.09.99 21:49 Yole
 * ported to Virtual Pascal/W32; fixed another FText bug in MsgBase
 *
 * 2     18.06.99 16:03 Yole
 * added defines for Outbound Explorer
 *
 * 1     14.11.98 23:18 Yole
 * FidoTools: miscellaneous defines shared by all units
  Revision 1.2  1998-07-03 13:14:39+04  yole
  many changes; Delphi 4 support

  Revision 1.1  1998-04-07 20:59:49+04  yole
  Initial revision

}
