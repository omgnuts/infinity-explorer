object CREFrame: TCREFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 275
  Align = alClient
  TabOrder = 0
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 443
    Height = 275
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Combat'
      object Label1: TLabel
        Left = 8
        Top = 48
        Width = 44
        Height = 13
        Caption = 'Hit points'
      end
      object Label2: TLabel
        Left = 144
        Top = 44
        Width = 5
        Height = 13
        Alignment = taCenter
        Caption = '/'
      end
      object Label4: TLabel
        Left = 16
        Top = 232
        Width = 35
        Height = 13
        Caption = 'THAC0'
      end
      object Label5: TLabel
        Left = 8
        Top = 16
        Width = 28
        Height = 13
        Caption = 'Name'
      end
      object Label6: TLabel
        Left = 256
        Top = 48
        Width = 43
        Height = 13
        Caption = 'XP value'
      end
      object Label23: TLabel
        Left = 16
        Top = 264
        Width = 87
        Height = 13
        Caption = 'Number of attacks'
      end
      object EdtCurHP: TEdit
        Left = 88
        Top = 40
        Width = 49
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object EdtMaxHP: TEdit
        Left = 160
        Top = 40
        Width = 49
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
      object EdtTHAC0: TEdit
        Left = 192
        Top = 224
        Width = 33
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 5
      end
      object EdtName: TEdit
        Left = 88
        Top = 8
        Width = 193
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object EdtKillXP: TEdit
        Left = 376
        Top = 40
        Width = 65
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object GroupBox1: TGroupBox
        Left = 248
        Top = 72
        Width = 281
        Height = 225
        Caption = 'Resistances'
        TabOrder = 7
        object Label7: TLabel
          Left = 8
          Top = 32
          Width = 17
          Height = 13
          Caption = 'Fire'
        end
        object Label8: TLabel
          Left = 136
          Top = 32
          Width = 21
          Height = 13
          Caption = 'Cold'
        end
        object Label9: TLabel
          Left = 8
          Top = 64
          Width = 45
          Height = 13
          Caption = 'Electricity'
        end
        object Label10: TLabel
          Left = 136
          Top = 64
          Width = 21
          Height = 13
          Caption = 'Acid'
        end
        object Label11: TLabel
          Left = 8
          Top = 96
          Width = 29
          Height = 13
          Caption = 'Magic'
        end
        object Label12: TLabel
          Left = 8
          Top = 128
          Width = 54
          Height = 13
          Caption = 'Magical fire'
        end
        object Label13: TLabel
          Left = 136
          Top = 128
          Width = 60
          Height = 13
          Caption = 'Magical cold'
        end
        object Label14: TLabel
          Left = 8
          Top = 160
          Width = 40
          Height = 13
          Caption = 'Slashing'
        end
        object Label15: TLabel
          Left = 136
          Top = 160
          Width = 38
          Height = 13
          Caption = 'Piercing'
        end
        object Label16: TLabel
          Left = 8
          Top = 192
          Width = 41
          Height = 13
          Caption = 'Crushing'
        end
        object Label17: TLabel
          Left = 136
          Top = 192
          Width = 31
          Height = 13
          Caption = 'Missile'
        end
        object EdtResistFire: TEdit
          Left = 88
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtResistCold: TEdit
          Left = 232
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtResistElec: TEdit
          Left = 88
          Top = 56
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtResistAcid: TEdit
          Left = 232
          Top = 56
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
        object EdtResistMagic: TEdit
          Left = 88
          Top = 88
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
        object EdtResistMagFire: TEdit
          Left = 88
          Top = 120
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 5
        end
        object EdtResistMagCold: TEdit
          Left = 232
          Top = 120
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 6
        end
        object EdtResistSlashing: TEdit
          Left = 88
          Top = 152
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 7
        end
        object EdtResistPiercing: TEdit
          Left = 232
          Top = 152
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 8
        end
        object EdtResistCrushing: TEdit
          Left = 88
          Top = 184
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 9
        end
        object EdtResistMissile: TEdit
          Left = 232
          Top = 184
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 10
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 304
        Width = 521
        Height = 57
        Caption = 'Saving throws'
        TabOrder = 8
        object Label18: TLabel
          Left = 8
          Top = 32
          Width = 29
          Height = 13
          Caption = 'Death'
        end
        object Label19: TLabel
          Left = 112
          Top = 32
          Width = 34
          Height = 13
          Caption = 'Wands'
        end
        object Label20: TLabel
          Left = 312
          Top = 32
          Width = 31
          Height = 13
          Caption = 'Breath'
        end
        object Label21: TLabel
          Left = 216
          Top = 32
          Width = 20
          Height = 13
          Caption = 'Poly'
        end
        object Label22: TLabel
          Left = 416
          Top = 32
          Width = 28
          Height = 13
          Caption = 'Spells'
        end
        object EdtST_PPDM: TEdit
          Left = 64
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtST_RSW: TEdit
          Left = 168
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtST_BW: TEdit
          Left = 360
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
        object EdtST_PP: TEdit
          Left = 256
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtST_Spells: TEdit
          Left = 472
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
      end
      object EdtNumberOfAttacks: TEdit
        Left = 192
        Top = 256
        Width = 33
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 6
      end
      object GroupBox9: TGroupBox
        Left = 8
        Top = 72
        Width = 233
        Height = 129
        Caption = 'Armor class'
        TabOrder = 4
        object Label55: TLabel
          Left = 8
          Top = 32
          Width = 24
          Height = 13
          Caption = 'Base'
        end
        object Label56: TLabel
          Left = 8
          Top = 64
          Width = 41
          Height = 13
          Caption = 'Crushing'
        end
        object Label57: TLabel
          Left = 8
          Top = 96
          Width = 38
          Height = 13
          Caption = 'Piercing'
        end
        object Label58: TLabel
          Left = 120
          Top = 96
          Width = 40
          Height = 13
          Caption = 'Slashing'
        end
        object Label59: TLabel
          Left = 120
          Top = 64
          Width = 31
          Height = 13
          Caption = 'Missile'
        end
        object EdtAC: TEdit
          Left = 72
          Top = 24
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtACCrushing: TEdit
          Left = 72
          Top = 56
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtACPiercing: TEdit
          Left = 72
          Top = 88
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
        object EdtACMissile: TEdit
          Left = 184
          Top = 56
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtACSlashing: TEdit
          Left = 184
          Top = 88
          Width = 33
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Character'
      ImageIndex = 1
      object Label24: TLabel
        Left = 8
        Top = 16
        Width = 26
        Height = 13
        Caption = 'Race'
      end
      object grpClass: TGroupBox
        Left = 8
        Top = 40
        Width = 257
        Height = 121
        Caption = 'Class'
        TabOrder = 1
        object Label25: TLabel
          Left = 160
          Top = 32
          Width = 22
          Height = 13
          Caption = 'level'
        end
        object LblLevel2: TLabel
          Left = 160
          Top = 64
          Width = 22
          Height = 13
          Caption = 'level'
        end
        object LblLevel3: TLabel
          Left = 160
          Top = 96
          Width = 22
          Height = 13
          Caption = 'level'
        end
        object lblDualClass: TLabel
          Left = 8
          Top = 88
          Width = 49
          Height = 13
          Caption = 'Dual-class'
        end
        object EdtClass1: TEdit
          Left = 8
          Top = 24
          Width = 137
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtLevel1: TEdit
          Left = 208
          Top = 24
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtClass2: TEdit
          Left = 8
          Top = 56
          Width = 137
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtLevel2: TEdit
          Left = 208
          Top = 56
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
        object EdtClass3: TEdit
          Left = 8
          Top = 88
          Width = 137
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
        end
        object EdtLevel3: TEdit
          Left = 208
          Top = 88
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 5
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = -23
        Width = 435
        Height = 281
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 2
        object Label33: TLabel
          Left = 8
          Top = 16
          Width = 35
          Height = 13
          Caption = 'Gender'
        end
        object Label34: TLabel
          Left = 8
          Top = 48
          Width = 46
          Height = 13
          Caption = 'Alignment'
        end
        object lblFaction: TLabel
          Left = 8
          Top = 80
          Width = 35
          Height = 13
          Caption = 'Faction'
        end
        object grpAbilities: TGroupBox
          Left = 8
          Top = 104
          Width = 257
          Height = 153
          Caption = 'Abilities'
          TabOrder = 3
          object Label26: TLabel
            Left = 8
            Top = 32
            Width = 13
            Height = 13
            Caption = 'Str'
          end
          object Label28: TLabel
            Left = 8
            Top = 64
            Width = 19
            Height = 13
            Caption = 'Dex'
          end
          object Label29: TLabel
            Left = 8
            Top = 96
            Width = 19
            Height = 13
            Caption = 'Con'
          end
          object Label27: TLabel
            Left = 88
            Top = 32
            Width = 5
            Height = 13
            Caption = '/'
          end
          object Label30: TLabel
            Left = 160
            Top = 32
            Width = 12
            Height = 13
            Caption = 'Int'
          end
          object Label31: TLabel
            Left = 160
            Top = 64
            Width = 18
            Height = 13
            Caption = 'Wis'
          end
          object Label32: TLabel
            Left = 160
            Top = 96
            Width = 19
            Height = 13
            Caption = 'Cha'
          end
          object Label46: TLabel
            Left = 8
            Top = 128
            Width = 24
            Height = 13
            Caption = 'Luck'
          end
          object EdtCon: TEdit
            Left = 48
            Top = 88
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
          end
          object EdtDex: TEdit
            Left = 48
            Top = 56
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
          object EdtStrPercent: TEdit
            Left = 104
            Top = 24
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
          end
          object EdtCha: TEdit
            Left = 200
            Top = 88
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 5
          end
          object EdtWis: TEdit
            Left = 200
            Top = 56
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 4
          end
          object EdtInt: TEdit
            Left = 200
            Top = 24
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
          end
          object EdtLuck: TEdit
            Left = 48
            Top = 120
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 6
          end
          object EdtStr: TEdit
            Left = 48
            Top = 24
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 7
          end
        end
        object EdtGender: TEdit
          Left = 80
          Top = 8
          Width = 145
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtAlignment: TEdit
          Left = 80
          Top = 40
          Width = 145
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtFaction: TEdit
          Left = 80
          Top = 72
          Width = 145
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
      end
      object EdtRace: TEdit
        Left = 80
        Top = 8
        Width = 145
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 280
        Top = 0
        Width = 273
        Height = 233
        BevelOuter = bvNone
        TabOrder = 3
        object Label54: TLabel
          Left = 16
          Top = 176
          Width = 52
          Height = 13
          Caption = 'Reputation'
        end
        object Label3: TLabel
          Left = 8
          Top = 16
          Width = 14
          Height = 13
          Caption = 'XP'
        end
        object Label61: TLabel
          Left = 16
          Top = 208
          Width = 64
          Height = 13
          Caption = 'Racial enemy'
        end
        object GroupBox8: TGroupBox
          Left = 8
          Top = 40
          Width = 161
          Height = 121
          Caption = 'Morale'
          TabOrder = 1
          object Label51: TLabel
            Left = 8
            Top = 24
            Width = 32
            Height = 13
            Caption = 'Morale'
          end
          object Label52: TLabel
            Left = 8
            Top = 56
            Width = 68
            Height = 13
            Caption = 'Breaking point'
          end
          object Label53: TLabel
            Left = 8
            Top = 88
            Width = 68
            Height = 13
            Caption = 'Recovery time'
          end
          object EdtMorale: TEdit
            Left = 112
            Top = 16
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
          end
          object EdtMoraleBreakingPoint: TEdit
            Left = 112
            Top = 48
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
          object EdtMoraleRecoveryTime: TEdit
            Left = 112
            Top = 80
            Width = 33
            Height = 24
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
          end
        end
        object EdtReputation: TEdit
          Left = 120
          Top = 168
          Width = 33
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtXP: TEdit
          Left = 48
          Top = 8
          Width = 105
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtRacialEnemy: TEdit
          Left = 120
          Top = 200
          Width = 145
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Skills'
      ImageIndex = 9
      object Label45: TLabel
        Left = 8
        Top = 80
        Width = 21
        Height = 13
        Caption = 'Lore'
      end
      object Label74: TLabel
        Left = 8
        Top = 16
        Width = 54
        Height = 13
        Caption = 'Open locks'
      end
      object Label78: TLabel
        Left = 152
        Top = 16
        Width = 33
        Height = 13
        Caption = 'Stealth'
      end
      object Label85: TLabel
        Left = 8
        Top = 48
        Width = 58
        Height = 13
        Caption = 'Detect traps'
      end
      object Label86: TLabel
        Left = 152
        Top = 48
        Width = 62
        Height = 13
        Caption = 'Pick pockets'
      end
      object Label92: TLabel
        Left = 152
        Top = 80
        Width = 42
        Height = 13
        Caption = 'Tracking'
      end
      object EdtLore: TEdit
        Left = 96
        Top = 72
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object EdtOpenLocks: TEdit
        Left = 96
        Top = 8
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object EdtStealth: TEdit
        Left = 240
        Top = 8
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
      object EdtDetectTraps: TEdit
        Left = 96
        Top = 40
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object EdtPickPockets: TEdit
        Left = 240
        Top = 40
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
      end
      object EdtTracking: TEdit
        Left = 240
        Top = 72
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 5
      end
      object GroupBox12: TGroupBox
        Left = 8
        Top = 104
        Width = 337
        Height = 153
        Caption = 'Weapon proficiencies'
        TabOrder = 6
        object WpnProfGrid: TStringGrid
          Left = 8
          Top = 24
          Width = 320
          Height = 121
          ColCount = 3
          DefaultRowHeight = 18
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
          TabOrder = 0
          ColWidths = (
            154
            64
            64)
        end
      end
    end
    object TabStatus: TTabSheet
      Caption = 'Status'
      ImageIndex = 8
      object Label68: TLabel
        Left = 8
        Top = 16
        Width = 35
        Height = 13
        Caption = 'Fatigue'
      end
      object Label69: TLabel
        Left = 144
        Top = 16
        Width = 54
        Height = 13
        Caption = 'Intoxication'
      end
      object EdtFatigue: TEdit
        Left = 64
        Top = 8
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object EdtIntoxication: TEdit
        Left = 240
        Top = 8
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object GroupBox11: TGroupBox
        Left = 8
        Top = 40
        Width = 601
        Height = 217
        Caption = 'State'
        TabOrder = 2
        object Label70: TLabel
          Left = 40
          Top = 24
          Width = 41
          Height = 13
          Caption = 'Sleeping'
        end
        object Label71: TLabel
          Left = 40
          Top = 48
          Width = 36
          Height = 13
          Caption = 'Berserk'
        end
        object Label72: TLabel
          Left = 40
          Top = 72
          Width = 27
          Height = 13
          Caption = 'Panic'
        end
        object Label73: TLabel
          Left = 40
          Top = 96
          Width = 40
          Height = 13
          Caption = 'Stunned'
        end
        object lblState4: TLabel
          Left = 40
          Top = 120
          Width = 38
          Height = 13
          Caption = 'Invisible'
        end
        object Label75: TLabel
          Left = 40
          Top = 144
          Width = 40
          Height = 13
          Caption = 'Helpless'
        end
        object Label76: TLabel
          Left = 40
          Top = 168
          Width = 64
          Height = 13
          Caption = 'Frozen Death'
        end
        object Label77: TLabel
          Left = 40
          Top = 192
          Width = 60
          Height = 13
          Caption = 'Stone Death'
        end
        object lblState8: TLabel
          Left = 160
          Top = 24
          Width = 78
          Height = 13
          Caption = 'Exploding Death'
        end
        object Label79: TLabel
          Left = 160
          Top = 48
          Width = 60
          Height = 13
          Caption = 'Flame Death'
        end
        object Label80: TLabel
          Left = 160
          Top = 72
          Width = 53
          Height = 13
          Caption = 'Acid Death'
        end
        object Label81: TLabel
          Left = 160
          Top = 96
          Width = 26
          Height = 13
          Caption = 'Dead'
        end
        object Label82: TLabel
          Left = 160
          Top = 120
          Width = 41
          Height = 13
          Caption = 'Silenced'
        end
        object Label83: TLabel
          Left = 160
          Top = 144
          Width = 42
          Height = 13
          Caption = 'Charmed'
        end
        object Label84: TLabel
          Left = 160
          Top = 168
          Width = 44
          Height = 13
          Caption = 'Poisoned'
        end
        object lblState15: TLabel
          Left = 160
          Top = 192
          Width = 34
          Height = 13
          Caption = 'Hasted'
        end
        object lblState16: TLabel
          Left = 296
          Top = 24
          Width = 35
          Height = 13
          Caption = 'Slowed'
        end
        object Label87: TLabel
          Left = 296
          Top = 48
          Width = 48
          Height = 13
          Caption = 'Infravision'
        end
        object Label88: TLabel
          Left = 296
          Top = 72
          Width = 23
          Height = 13
          Caption = 'Blind'
        end
        object Label89: TLabel
          Left = 296
          Top = 96
          Width = 44
          Height = 13
          Caption = 'Diseased'
        end
        object Label90: TLabel
          Left = 296
          Top = 120
          Width = 66
          Height = 13
          Caption = 'Feebleminded'
        end
        object Label91: TLabel
          Left = 296
          Top = 144
          Width = 64
          Height = 13
          Caption = 'Nondetection'
        end
        object lblState22: TLabel
          Left = 296
          Top = 168
          Width = 91
          Height = 13
          Caption = 'Improved Invisibility'
        end
        object Label93: TLabel
          Left = 296
          Top = 192
          Width = 25
          Height = 13
          Caption = 'Bless'
        end
        object lblState24: TLabel
          Left = 456
          Top = 24
          Width = 28
          Height = 13
          Caption = 'Chant'
        end
        object lblState25: TLabel
          Left = 456
          Top = 48
          Width = 107
          Height = 13
          Caption = 'Draw Upon Holy Might'
        end
        object Label96: TLabel
          Left = 456
          Top = 72
          Width = 24
          Height = 13
          Caption = 'Luck'
        end
        object Label97: TLabel
          Left = 456
          Top = 96
          Width = 15
          Height = 13
          Caption = 'Aid'
        end
        object lblState28: TLabel
          Left = 456
          Top = 120
          Width = 55
          Height = 13
          Caption = 'Chant (bad)'
        end
        object Label99: TLabel
          Left = 456
          Top = 144
          Width = 18
          Height = 13
          Caption = 'Blur'
        end
        object lblState30: TLabel
          Left = 456
          Top = 168
          Width = 58
          Height = 13
          Caption = 'Mirror Image'
        end
        object Label101: TLabel
          Left = 456
          Top = 192
          Width = 45
          Height = 13
          Caption = 'Confused'
        end
        object chkState0: TCheckBox
          Left = 16
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 0
        end
        object chkState1: TCheckBox
          Left = 16
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 1
        end
        object chkState2: TCheckBox
          Left = 16
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 2
        end
        object chkState3: TCheckBox
          Left = 16
          Top = 96
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 3
        end
        object chkState4: TCheckBox
          Left = 16
          Top = 120
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 4
        end
        object chkState5: TCheckBox
          Left = 16
          Top = 144
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 5
        end
        object chkState6: TCheckBox
          Left = 16
          Top = 168
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 6
        end
        object chkState7: TCheckBox
          Left = 16
          Top = 192
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 7
        end
        object chkState8: TCheckBox
          Left = 136
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 8
        end
        object chkState9: TCheckBox
          Left = 136
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 9
        end
        object chkState10: TCheckBox
          Left = 136
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 10
        end
        object chkState11: TCheckBox
          Left = 136
          Top = 96
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 11
        end
        object chkState12: TCheckBox
          Left = 136
          Top = 120
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 12
        end
        object chkState13: TCheckBox
          Left = 136
          Top = 144
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 13
        end
        object chkState14: TCheckBox
          Left = 136
          Top = 168
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 14
        end
        object chkState15: TCheckBox
          Left = 136
          Top = 192
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 15
        end
        object chkState16: TCheckBox
          Left = 272
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 16
        end
        object chkState17: TCheckBox
          Left = 272
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 17
        end
        object chkState18: TCheckBox
          Left = 272
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 18
        end
        object chkState19: TCheckBox
          Left = 272
          Top = 96
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 19
        end
        object chkState20: TCheckBox
          Left = 272
          Top = 120
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 20
        end
        object chkState21: TCheckBox
          Left = 272
          Top = 144
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 21
        end
        object chkState22: TCheckBox
          Left = 272
          Top = 168
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 22
        end
        object chkState23: TCheckBox
          Left = 272
          Top = 192
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 23
        end
        object chkState24: TCheckBox
          Left = 432
          Top = 24
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 24
        end
        object chkState25: TCheckBox
          Left = 432
          Top = 48
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 25
        end
        object chkState26: TCheckBox
          Left = 432
          Top = 72
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 26
        end
        object chkState27: TCheckBox
          Left = 432
          Top = 96
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 27
        end
        object chkState28: TCheckBox
          Left = 432
          Top = 120
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 28
        end
        object chkState29: TCheckBox
          Left = 432
          Top = 144
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 29
        end
        object chkState30: TCheckBox
          Left = 432
          Top = 168
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 30
        end
        object chkState31: TCheckBox
          Left = 432
          Top = 192
          Width = 17
          Height = 17
          Enabled = False
          TabOrder = 31
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'AI'
      ImageIndex = 4
      object Label40: TLabel
        Left = 16
        Top = 200
        Width = 30
        Height = 13
        Caption = 'Dialog'
      end
      object Label60: TLabel
        Left = 16
        Top = 232
        Width = 69
        Height = 13
        Caption = 'Death variable'
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 8
        Width = 225
        Height = 177
        Caption = 'AI scripts'
        TabOrder = 0
        object Label35: TLabel
          Left = 8
          Top = 24
          Width = 40
          Height = 13
          Caption = 'Override'
        end
        object Label36: TLabel
          Left = 8
          Top = 56
          Width = 25
          Height = 13
          Caption = 'Class'
        end
        object Label37: TLabel
          Left = 8
          Top = 88
          Width = 26
          Height = 13
          Caption = 'Race'
        end
        object Label38: TLabel
          Left = 8
          Top = 120
          Width = 37
          Height = 13
          Caption = 'General'
        end
        object Label39: TLabel
          Left = 8
          Top = 152
          Width = 34
          Height = 13
          Caption = 'Default'
        end
        object EdtScriptOverride: THyperlinkEdit
          Left = 88
          Top = 16
          Width = 121
          Height = 24
          TabOrder = 0
          HyperlinkJumper = MainForm.Jumper
          FileType = ftSCRIPT
        end
        object EdtScriptClass: THyperlinkEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 24
          TabOrder = 1
          HyperlinkJumper = MainForm.Jumper
          FileType = ftSCRIPT
        end
        object EdtScriptRace: THyperlinkEdit
          Left = 88
          Top = 80
          Width = 121
          Height = 24
          TabOrder = 2
          HyperlinkJumper = MainForm.Jumper
          FileType = ftSCRIPT
        end
        object EdtScriptGeneral: THyperlinkEdit
          Left = 88
          Top = 112
          Width = 121
          Height = 24
          TabOrder = 3
          HyperlinkJumper = MainForm.Jumper
          FileType = ftSCRIPT
        end
        object EdtScriptDefault: THyperlinkEdit
          Left = 88
          Top = 144
          Width = 121
          Height = 24
          TabOrder = 4
          HyperlinkJumper = MainForm.Jumper
          FileType = ftSCRIPT
        end
      end
      object EdtDialog: THyperlinkEdit
        Left = 120
        Top = 192
        Width = 97
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 1
        HyperlinkJumper = MainForm.Jumper
        FileType = ftDLG
      end
      object grpAI: TGroupBox
        Left = 248
        Top = 8
        Width = 225
        Height = 153
        Caption = 'AI parameters'
        TabOrder = 3
        object Label41: TLabel
          Left = 8
          Top = 24
          Width = 52
          Height = 13
          Caption = 'Enemy/ally'
        end
        object Label42: TLabel
          Left = 8
          Top = 56
          Width = 37
          Height = 13
          Caption = 'General'
        end
        object Label43: TLabel
          Left = 8
          Top = 88
          Width = 38
          Height = 13
          Caption = 'Specific'
        end
        object Label44: TLabel
          Left = 8
          Top = 120
          Width = 27
          Height = 13
          Caption = 'Team'
        end
        object EdtAI_EA: TEdit
          Left = 88
          Top = 16
          Width = 121
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtAI_General: TEdit
          Left = 88
          Top = 48
          Width = 121
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtAI_Specific: TEdit
          Left = 88
          Top = 80
          Width = 121
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtAI_Team: TEdit
          Left = 88
          Top = 112
          Width = 121
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
      end
      object EdtDeathVar: TEdit
        Left = 120
        Top = 224
        Width = 145
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
    end
    object TabItems: TTabSheet
      Caption = 'Items'
      ImageIndex = 2
      object Label50: TLabel
        Left = 8
        Top = 16
        Width = 22
        Height = 13
        Caption = 'Gold'
      end
      object ItemGrid: THyperlinkGrid
        Left = 0
        Top = 41
        Width = 435
        Height = 205
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 8
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnCanJump = ItemGridCanJump
        OnJump = ItemGridJump
        ColWidths = (
          189
          64
          64
          64
          64
          64
          64
          64)
      end
      object EdtGold: TEdit
        Left = 80
        Top = 8
        Width = 65
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
    end
    object TabSpells: TTabSheet
      Caption = 'Spells'
      ImageIndex = 3
      object KnownSpellGrid: THyperlinkGrid
        Left = 0
        Top = 0
        Width = 612
        Height = 258
        Align = alClient
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnCanJump = KnownSpellGridCanJump
        OnJump = KnownSpellGridJump
        ColWidths = (
          198
          52
          64
          70
          74)
      end
    end
    object TabEffects: TTabSheet
      Caption = 'Effects'
      ImageIndex = 6
      object EffectGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 612
        Height = 258
        Align = alClient
        ColCount = 11
        DefaultRowHeight = 18
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          142
          64
          64
          64
          64
          64
          64
          64
          64
          64
          64)
      end
    end
    object TabParty: TTabSheet
      Caption = 'Party'
      ImageIndex = 7
      object Label62: TLabel
        Left = 8
        Top = 16
        Width = 63
        Height = 13
        Caption = 'Party position'
      end
      object Label67: TLabel
        Left = 8
        Top = 176
        Width = 50
        Height = 13
        Caption = 'Happiness'
      end
      object GroupBox10: TGroupBox
        Left = 8
        Top = 40
        Width = 281
        Height = 121
        Caption = 'Location'
        TabOrder = 0
        object Label63: TLabel
          Left = 8
          Top = 32
          Width = 22
          Height = 13
          Caption = 'Area'
        end
        object Label64: TLabel
          Left = 8
          Top = 64
          Width = 7
          Height = 13
          Caption = 'X'
        end
        object Label65: TLabel
          Left = 184
          Top = 64
          Width = 7
          Height = 13
          Caption = 'Y'
        end
        object Label66: TLabel
          Left = 8
          Top = 96
          Width = 32
          Height = 13
          Caption = 'Facing'
        end
        object EdtCurArea: THyperlinkEdit
          Left = 104
          Top = 24
          Width = 97
          Height = 24
          TabOrder = 0
          HyperlinkJumper = MainForm.Jumper
          FileType = ftAREA
        end
        object EdtX: TEdit
          Left = 104
          Top = 56
          Width = 49
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtY: TEdit
          Left = 216
          Top = 56
          Width = 49
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object EdtFacing: TEdit
          Left = 104
          Top = 88
          Width = 49
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 3
        end
      end
      object EdtPartyPosition: TEdit
        Left = 112
        Top = 8
        Width = 33
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object EdtHappiness: TEdit
        Left = 104
        Top = 168
        Width = 49
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
    end
    object TabStatistics: TTabSheet
      Caption = 'Statistics'
      ImageIndex = 5
      object Label47: TLabel
        Left = 8
        Top = 16
        Width = 124
        Height = 13
        Caption = 'Most powerful vanquished'
      end
      object Label48: TLabel
        Left = 8
        Top = 68
        Width = 69
        Height = 13
        Caption = 'Number of kills'
      end
      object Label49: TLabel
        Left = 8
        Top = 102
        Width = 114
        Height = 13
        Caption = 'Experience value of kills'
      end
      object EdtMostPowerful: TEdit
        Left = 192
        Top = 8
        Width = 193
        Height = 24
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object GroupBox3: TGroupBox
        Left = 192
        Top = 40
        Width = 89
        Height = 89
        Caption = 'Chapter'
        TabOrder = 1
        object EdtKillCountChapter: TEdit
          Left = 8
          Top = 24
          Width = 73
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
        object EdtKillXPChapter: TEdit
          Left = 8
          Top = 56
          Width = 73
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
      end
      object GroupBox5: TGroupBox
        Left = 296
        Top = 40
        Width = 89
        Height = 89
        Caption = 'Game'
        TabOrder = 2
        object EdtKillXPGame: TEdit
          Left = 8
          Top = 56
          Width = 73
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EdtKillCountGame: TEdit
          Left = 8
          Top = 24
          Width = 73
          Height = 24
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 136
        Width = 321
        Height = 129
        Caption = 'Favourite spells'
        TabOrder = 3
        object FavSpellGrid: THyperlinkGrid
          Left = 8
          Top = 16
          Width = 305
          Height = 105
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          TabOrder = 0
          OnCanJump = FavSpellGridCanJmp
          OnJump = FavSpellGridJump
          ColWidths = (
            202
            92)
        end
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 272
        Width = 321
        Height = 129
        Caption = 'Favourite weapons'
        TabOrder = 4
        object FavWeaponGrid: THyperlinkGrid
          Left = 8
          Top = 16
          Width = 305
          Height = 105
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          TabOrder = 0
          OnCanJump = FavWeaponGridCanJump
          OnJump = FavWeaponGridJump
          ColWidths = (
            202
            92)
        end
      end
    end
  end
end
