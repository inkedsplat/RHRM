require("editor")
require("game")
require("minigames")
require("animHandler")
require("pieceAnimHander")
require("SaveLoad")
require("menu")
require("soundDatabase")
require("init")
require("library")
json = require("json")

function love.load()
  
  font = love.graphics.newFont("/resources/rodin.otf",17)
  fontBig = love.graphics.newFont("/resources/rodin.otf",35)
  
  userImg = {}
  
  love.filesystem.setIdentity("RhythmHeavenRemixMaker")
  if not love.filesystem.exists("/remixes") then
    love.filesystem.createDirectory("/remixes")
  end
  if not love.filesystem.exists("/library") then
    love.filesystem.createDirectory("/library")
  end
  
  version = "0.8.0-SNAPSHOT-1"
  love.window.setTitle("RHRM - "..version)
  initializeData()
  initializeCues()
  
  
  --[[
  MINGAME LIST:
    0 = MISC
    1 = KARATE MAN (GBA)
    2 = RHYTHM EPILATION (GBA)
    3 = BLUE BIRDS
    4 = FORK LIFTER
    5 = CLAPPY TRIO (WII)
    6 = LOCK STEP
    7 = SCREW BOTS
  ]]
  imgUnknownMinigame = love.graphics.newImage("/resources/gfx/editor/icons/unknown.png")
  minigames = {
    [0] = {
      name = "misc",
      group = "misc",
      img = love.graphics.newImage("/resources/gfx/editor/icons/misc.png"),
      blocks = {
        {
          name = "END REMIX",
          length = 64,
          cues = {{name = "end remix",x = 0,cueId = "silence"}},
        },
        {
          name = "count in 4",
          length = 256,
          cues = {
            {name = "count1",x = 0,cueId = "countIn1"},
            {name = "count2",x = 64,cueId = "countIn2"},
            {name = "count3",x = 128,cueId = "countIn3"},
            {name = "count4",x = 128+64,cueId = "countIn4"}
          },
        },
        {
          name = "count in 8",
          length = 256*2,
          cues = {
            {name = "count1",x = 0,cueId = "countIn1"},
            {name = "count2",x = 128,cueId = "countIn2"},
            {name = "count1",x = 256+0,cueId = "countIn1"},
            {name = "count2",x = 256+64,cueId = "countIn2"},
            {name = "count3",x = 256+128,cueId = "countIn3"},
            {name = "count4",x = 256+128+64,cueId = "countIn4"},
          },
        },
        {
          name = "cowbell",
          length = 32,
          cues = {{name = "cowbell",x = 0,cueId = "cowbell"}},
        },
        {
          name = "1",
          length = 32,
          cues = {{name = "count1",x = 0,cueId = "countIn1"}},
        },
        {
          name = "2",
          length = 32,
          cues = {{name = "count2",x = 0,cueId = "countIn2"}},
        },
        {
          name = "3",
          length = 32,
          cues = {{name = "count3",x = 0,cueId = "countIn3"}},
        },
        {
          name = "4",
          length = 32,
          cues = {{name = "count4",x = 0,cueId = "countIn4"}},
        },
        {
          name = "vertical flip",
          length = 64,
          cues = {{name = "vflip",x = 0,cueId = "silence"}},
        },
        {
          name = "horizontal flip",
          length = 64,
          cues = {{name = "hflip",x = 0,cueId = "silence"}},
        },
        {
          name = "reset flip",
          length = 64,
          cues = {{name = "rflip",x = 0,cueId = "silence"}},
        },
        {
          name = "screenshake mag1",
          length = 64,
          cues = {{name = "screenshake",x = 0,cueId = "silence"}},
        },
        {
          name = "screenshake mag2",
          length = 64,
          cues = {{name = "screenshake1",x = 0,cueId = "silence"}},
        },
        {
          name = "screenshake mag3",
          length = 64,
          cues = {{name = "screenshake2",x = 0,cueId = "silence"}},
        },
      }
    },
    [1] = {
      name = "karateka (GBA)",
      group = "gba",
      img = love.graphics.newImage("/resources/gfx/editor/icons/karateman.png"),
      blocks = {
        {
          name = "pot",
          length = 128,
          cues = {{name = "pot throw",x = 0,cueId = "karatekaPotThrow"}},
          hits = {{name = "punch",x = 64,cueId = "karatekaPotHit",input = "pressA"}}
        },
        {
          name = "rock",
          length = 128,
          cues = {{name = "rock throw",x = 0,cueId = "karatekaPotThrow"}},
          hits = {{name = "punch",x = 64,cueId = "karatekaRockHit",input = "pressA"}}
        },
        {
          name = "hit 3",
          length = 96,
          cues = {{name = "mi",x = 0,cueId = "karatekaMi"},{name = "tsu",x = 32,cueId = "karatekaTsu"}},
        }
      }
    },
    [2] = {
      name = "rhythm tweezers",
      group = "gba",
      img = love.graphics.newImage("/resources/gfx/editor/icons/rhythmepilation.png"),
      blocks = {
        {
          name = "start call",
          length = 64,
          cues = {{name = "call",x = 0,cueId = "silence"}}
        },
        --[[{
          name = "hair appear pluck",
          length = 64,
          hideConnection = true,
          cues = {{name = "appear",x = 0,sound = newSource("/resources/sfx/rhythm tweezers (GBA)/hairAppear.ogg")}},
          hits = {{name = "pluck",x = 64*4,sound = newSource("/resources/sfx/rhythm tweezers (GBA)/hairPluck.ogg"),input = "pressANY"}}
        },]]
        {
          name = "hair appear",
          length = 32,
          cues = {{name = "appear",x = 0,cueId = "tweezersRootAppear"}}
        },
        {
          name = "hair pluck",
          length = 32,
          hits = {{name = "pluck",x = 0,cueId = "tweezersRootPluck",input = "pressANY"}}
        },
        {
          name = "hair appear long",
          length = 32,
          cues = {{name = "appear long",x = 0,cueId = "tweezersRootAppearLong"}}
        },
        {
          name = "hair pluck long",
          length = 64,
          hits = {
            {name = "pluck long",x = 0,cueId = "tweezersRootPluckLong1",input = "pressANY"},
            {name = "pluckE",x = 32,cueId = "tweezersRootPluckLong2",input = "holdANY"}
          }
        },
      }
    },
    [3] = {
      name = "Blue birds",
      group = "3ds",
      img = love.graphics.newImage("/resources/gfx/editor/icons/bluebirds.png"),
      blocks = {
        {
          name = "peck your beak",
          length = 256,
          cues = {
            {name = "speak",x = 0,cueId = "BlueBirdsPeck"},
            {name = "speak",x = 32,cueId = "BlueBirdsYour"},
            {name = "speak",x = 64,cueId = "BlueBirdsBeak"}
          },
          hits = {
            {name = "peck",x = 128,cueId = "BlueBirdsPeckPlayer",input = "pressA"},
            {name = "peck",x = 128+32,cueId = "BlueBirdsPeckPlayer",input = "pressA"},
            {name = "peck",x = 128+64,cueId = "BlueBirdsPeckPlayer",input = "pressA"},
          }
        },
        {
          name = "stretch out your neck",
          length = 256+64,
          cues = {
            {name = "speak",x = 0,cueId = "BlueBirdsStretch"},
            {name = "speak",x = 48,cueId = "BlueBirdsOut"},
            {name = "speak",x = 96,cueId = "BlueBirdsYour2"},
            {name = "speak",x = 128,cueId = "BlueBirdsNeck"}
          },
          hits = {
            {name = "stretch1",x = 3*64,cueId = "BlueBirdsStretchPlayer1",input = "pressA"},
            {name = "stretch2",x = 4*64,cueId = "BlueBirdsStretchPlayer2",input = "releaseA"},
          }
        },
      }
    },
    [4] = {
      name = "Fork lifter",
      group = "wii",
      img = love.graphics.newImage("/resources/gfx/editor/icons/forklifter.png"),
      blocks = {
        {
          name = "orange",
          length = 128+32,
          cues = {
            {name = "flick",x = 0,cueId = "ForkLifterFlick" },
            {name = "zoom",x = 128-32,cueId = "ForkLifterZoom",pitchToBpm = true}
          },
          hits = {{name = "stab",x = 128,cueId = "ForkLifterStab",input = "pressA"}}
        },
        {
          name = "eat",
          length = 64,
          cues = {
            {name = "eatS",x = 0,cueId = "silence",},
            {name = "eat",x = 32,cueId = "ForkLifterEat"},
          },
        },
      }
    },
    [5] = {
      name = "Clappy Trio",
      group = "wii",
      img = love.graphics.newImage("/resources/gfx/editor/icons/clappytrio.png"),
      blocks = {
        {
          name = "prepare",
          length = 32,
          cues = {
            {name = "prepare",x = 0,cueId = "ClappyTrioPrep"},
          }
        },
        {
          name = "four on floor",
          length = 64,
          cues = {
            {name = "4otf",x = 0,cueId = "silence"},
          }
        },
        {
          name = "clap",
          length = 32,
          cues = {
            {name = "clap",x = 0,cueId = "ClappyTrioClap"},
          }
        },
        {
          name = "silent clap",
          length = 32,
          cues = {
            {name = "clap",x = 0,cueId = "silence"},
          }
        },
        {
          name = "clap player",
          length = 32,
          hits = {
            {name = "clapp",x = 0,cueId = "ClappyTrioClap",input = "pressA"},
          }
        },
      }
    },
    [6] = {
      name = "Lock step",
      group = "ds",
      img = love.graphics.newImage("/resources/gfx/editor/icons/lockstep.png"),
      blocks = {
        {
          name = "march on",
          length = 256,
          hits = {
            {name = "step on",x = 0,cueId = "LockStepOn",input = "pressA"},
            {name = "step on",x = 64,cueId = "LockStepOn",input = "pressA"},
            {name = "step on",x = 128,cueId = "LockStepOn",input = "pressA"},
            {name = "step on",x = 126+64,cueId = "LockStepOn",input = "pressA"},
          }
        },
        {
          name = "step on",
          length = 64,
          hits = {
            {name = "step on",x = 0,cueId = "LockStepOn",input = "pressA"}
          }
        },
        {
          name = "march off",
          length = 256,
          hits = {
            {name = "step off",x = 32,cueId = "LockStepOff",input = "pressA"},
            {name = "step off",x = 32+64,cueId = "LockStepOff",input = "pressA"},
            {name = "step off",x = 32+128,cueId = "LockStepOff",input = "pressA"},
            {name = "step off",x = 32+126+64,cueId = "LockStepOff",input = "pressA"},
          }
        },
        {
          name = "step off",
          length = 64,
          hits = {
            {name = "step off",x = 32,cueId = "LockStepOff",input = "pressA"},
          }
        },
        {
          name = "on to off",
          length = 256+128,
          cues = {
            {name = "hai",x = 0,cueId = "LockStepHai"},
            {name = "hai",x = 64,cueId = "LockStepHai"},
            {name = "hai",x = 128,cueId = "LockStepHai"},
            {name = "switch",x = 128+64,cueId = "LockStepHa"},
            {name = " ",x = 128+96,cueId = "LockStepHaiOff"},
            {name = "ouf",x = 128+96+64,cueId = "LockStepOuf"},
            {name = "ouf",x = 128+96+128,cueId = "LockStepOuf"},
          }
        },
        {
          name = "off to on",
          length = 128+32,
          cues = {
            {name = "hm",x = 0,cueId = "LockStepHm"},
            {name = "ha",x = 32,cueId = "LockStepHaOff"},
            {name = "hm",x = 64,cueId = "LockStepHm"},
            {name = "ha",x = 96,cueId = "LockStepHaOff"},
            {name = "switch",x = 128,cueId = "LockStepHai"},
          }
        },
        {
          name = "hai",
          length = 64,
          cues = {
            {name = "hai",x = 0,cueId = "LockStepHai"},
          }
        },
        {
          name = "countIn",
          length = 64,
          cues = {
            {name = "countIn",x = 0,cueId = "silence"},
          }
        },
        {
          name = "set zoom 2",
          length = 64,
          cues = {
            {name = "zoom2",x = 0,cueId = "silence"},
          }
        },
        {
          name = "add 1 zoom",
          length = 64,
          cues = {
            {name = "zoom+",x = 0,cueId = "silence"},
          }
        },
        {
          name = "sub 1 zoom",
          length = 64,
          cues = {
            {name = "zoom-",x = 0,cueId = "silence"},
          }
        },
      },
    },
    [7] = {
      name = "screw bots",
      group = "wii",
      img = love.graphics.newImage("/resources/gfx/editor/icons/screwbot.png"),
      blocks = {
        {
          name = "black bot",
          length = 256*2,
          cues = {
            {name = "cBlack1",x = 0,cueId = "ScrewBotsCrane1"},
            {name = "c1.5",x = 16,cueId = "silence"},
            {name = "cBlack2",x = 32,cueId = "ScrewBotsCrane2"},
            {name = "dBlack",x = 128,cueId = "ScrewBotsBlackDrop"},
          },
          hits = {
            {name = "sBlack",x = 128+64,cueId = "ScrewBotsBlackScrew",input = "pressAB",pitchToBpm = true},
            {name = "compBlack",x = 256+64,cueId = "ScrewBotsComplete",input = "releaseAB"},
          }
        },
        {
          name = "white bot",
          length = 256*2-64,
          cues = {
            {name = "cWhite1",x = 0,cueId = "ScrewBotsCrane1"},
            {name = "c1.5",x = 16,cueId = "silence"},
            {name = "cWhite2",x = 32,cueId = "ScrewBotsCrane2"},
            {name = "",x = 0,cueId = "ScrewBotsCraneWhite"},
            {name = "",x = 32,cueId = "ScrewBotsCraneWhite"},
            {name = "dWhite",x = 128,cueId = "ScrewBotsWhiteDrop"},
          },
          hits = {
            {name = "sWhite",x = 128+64,cueId = "ScrewBotsWhiteScrew",input = "pressAB",pitchToBpm = true},
            {name = "compWhite",x = 256,cueId = "ScrewBotsComplete",input = "releaseAB"},
          }
        },
        {
          name = "black bot quick",
          length = 256*2-64,
          cues = {
            {name = "cBlack1",x = 0,cueId = "ScrewBotsCrane1"},
            {name = "c1.5",x = 16,cueId = "silence"},
            {name = "cBlack2",x = 32,cueId = "ScrewBotsCrane2"},
            {name = "dBlack",x = 128-64,cueId = "ScrewBotsBlackDrop"},
          },
          hits = {
            {name = "sBlack",x = 128,cueId = "ScrewBotsBlackScrew",input = "pressAB",pitchToBpm = true},
            {name = "compBlack",x = 256,cueId = "ScrewBotsComplete",input = "releaseAB"},
          }
        },
        {
          name = "white bot quick",
          length = 256*2-128,
          cues = {
            {name = "cWhite1",x = 0,cueId = "ScrewBotsCrane1"},
            {name = "c1.5",x = 16,cueId = "silence"},
            {name = "cWhite2",x = 32,cueId = "ScrewBotsCrane2"},
            {name = "",x = 0,cueId = "ScrewBotsCraneWhite"},
            {name = "",x = 32,cueId = "ScrewBotsCraneWhite"},
            {name = "dWhite",x = 128-64,cueId = "ScrewBotsWhiteDrop"},
          },
          hits = {
            {name = "sWhite",x = 128+64-64,cueId = "ScrewBotsWhiteScrew",input = "pressAB",pitchToBpm = true},
            {name = "compWhite",x = 256-64,cueId = "ScrewBotsComplete",input = "releaseAB"},
          }
        },
      },
    },
    [8] = {
      name = "moai doo-wop",
      group = "ds",
      img = love.graphics.newImage("/resources/gfx/editor/icons/moaiDooWop.png"),
      blocks = {
        {
          name = "left doo",
          length = 64,
          resizable = true,
          cues = {
            {name = "dooLStart",x = 0,cueId = "MoaiDooLStart"},
            {name = "dooL",x = 0,cueId = "MoaiDooL",loop = true},
          }
        },
        {
          name = "left wop",
          length = 32,
          cues = {
            {name = "wopL",x = 0,cueId = "MoaiWopL"},
          }
        },
        {
          name = "left pah",
          length = 32,
          cues = {
            {name = "pahL",x = 0,cueId = "MoaiPahL"},
          }
        },
        {
          name = "switch",
          length = 64,
          cues = {
            {name = "switch",x = 0,cueId = "MoaiSwitch"},
          }
        },
        {
          name = "right doo",
          length = 64,
          resizable = true,
          cues = {
            {name = "dooR",x = 0,cueId = "MoaiDooR",loop = true,silent = true},
          },
          hits = {
            {name = "dooRStart",x = 0,cueId = "MoaiDooRStart",input = "pressA",silent = true},
          }
        },
        {
          name = "right wop",
          length = 32,
          hits = {
            {name = "wopR",x = 0,cueId = "MoaiWopR",input = "releaseA",silent = true},
          }
        },
        {
          name = "right pah",
          length = 32,
          hits = {
            {name = "pahR",x = 0,cueId = "MoaiPahR",input = "pressB",silent = true},
          }
        },
      }
    },
    [9] = {
      name = "cheer readers",
      group = "wii",
      img = love.graphics.newImage("/resources/gfx/editor/icons/cheerReaders.png"),
      blocks = {
        {
          name = "1 2 3",
          length = 128+64,
          cues = {
            {name = "onec",x = 0,cueId = "cheerReadersOneSolo"},
            {name = "twoc",x = 64,cueId = "cheerReadersTwoSolo"},

            {name = "onec",x = 0,cueId = "cheerReadersOneGirls"},
            {name = "twoc",x = 64,cueId = "cheerReadersTwoGirls"},
            {name = "threec",x = 128,cueId = "cheerReadersThreeGirls"}
          },
          hits = {
            {name = "threec",x = 128,cueId = "cheerReadersThreeSolo",input = "pressA"},
          },
        },
        {
          name = "it's up to you",
          length = 128+64,
          cues = {
            {name = "its",x = 0,cueId = "cheerReadersItsSolo"},
            {name = "up",x = (64/4)*3,cueId = "cheerReadersUpSolo"},
            {name = "to",x = 64+32,cueId = "cheerReadersToSolo"},
          
            {name = "its",x = 0,cueId = "cheerReadersItsGirls"},
            {name = "up",x = (64/4)*3,cueId = "cheerReadersUpGirls"},
            {name = "to",x = 64+32,cueId = "cheerReadersToGirls"},
            {name = "you",x = 128,cueId = "cheerReadersYouGirls"}
          },
          hits = {
            {name = "you",x = 128,cueId = "cheerReadersYouSolo",input = "pressA"},
          },
        },
        {
          name = "ra ra sis boom ba BOOM",
          length = 128+64,
          cues = {
            {name = "ra",x = 0,cueId = "cheerReadersRaSolo"},
            {name = "ra2",x = 32,cueId = "cheerReadersRaSolo2"},
            {name = "sis",x = 64,cueId = "cheerReadersSisSolo"},
            {name = "boom",x = 64+32,cueId = "cheerReadersBoomSolo"},
            {name = "ba",x = 128,cueId = "cheerReadersBaSolo"},
            
            {name = "ra",x = 0,cueId = "cheerReadersRaGirls"},
            {name = "ra2",x = 32,cueId = "cheerReadersRaGirls2"},
            {name = "sis",x = 64,cueId = "cheerReadersSisGirls"},
            {name = "boom",x = 64+32,cueId = "cheerReadersBoomGirls"},
            {name = "ba",x = 128,cueId = "cheerReadersBaGirls"},
            {name = "BOOM",x = 128+32,cueId = "cheerReadersBoomGirls2"},
          },
          hits = {
            {name = "BOOM",x = 128+32,cueId = "cheerReadersBoomSolo2",input = "pressA"},
          },
        },
        {
          name = "let's go read a buncha books",
          length = 128+64,
          cues = {
            {name = "lets",x = 0,cueId = "cheerReadersLetsSolo"},
            {name = "go",x = 64-16,cueId = "cheerReadersGoSolo"},
            {name = "read",x = 64,cueId = "cheerReadersReadSolo"},
            {name = "a",x = 64+16,cueId = "cheerReadersASolo"},
            {name = "bunch",x = 64+32,cueId = "cheerReadersBunchSolo"},
            {name = "of",x = 64+48,cueId = "cheerReadersOfSolo"},
            
            {name = "lets",x = 0,cueId = "cheerReadersLetsGirls"},
            {name = "go",x = 64-16,cueId = "cheerReadersGoGirls"},
            {name = "read",x = 64,cueId = "cheerReadersReadGirls"},
            {name = "a",x = 64+16,cueId = "cheerReadersAGirls"},
            {name = "bunch",x = 64+32,cueId = "cheerReadersBunchGirls"},
            {name = "of",x = 64+48,cueId = "cheerReadersOfGirls"},
            {name = "books",x = 128,cueId = "cheerReadersBooksGirls"},
          },
          hits = {
            {name = "books",x = 128,cueId = "cheerReadersBooksSolo",input = "pressA"},
          },
        },
        {
          name = "okay it's on!",
          length = 128+128,
          cues = {
            {name = "o",x = 0,cueId = "cheerReadersOSolo"},
            {name = "kay",x = 64,cueId = "cheerReadersKaySolo"},
            
            {name = "o",x = 0,cueId = "cheerReadersOGirls"},
            {name = "kay",x = 64,cueId = "cheerReadersKayGirls"},
            {name = "its2",x = 128,cueId = "cheerReadersItsGirls2"},
            {name = "on",x = 128+64,cueId = "cheerReadersOnGirls"},
            
            {name = "zoomReset",x = 128+64+32,cueId = "silence"},
          },
          hits = {
            {name = "its2",x = 128,cueId = "cheerReadersItsSolo2",input = "pressAB"},
            {name = "on",x = 128+64,cueId = "cheerReadersOnSolo",input = "releaseAB"},
          },
        }
      }
    },
    [10] = {
      hidden = true,
      name = "glee club",
      group = "ds",
      --img = love.graphics.newImage("/resources/gfx/editor/icons/gleeClub.png"),
      blocks = {
        {
          name = "sing",
          length = 64,
          resizable = true,
          pitchShift = true,
          cues = {
            {name = "sing",x = 0,cueId = "gleeClubSing",loop = true,pitch = 1},
          }
        },
        {
          name = "stop",
          length = 32,
          cues = {
            {name = "stop",x = 0,cueId = "gleeClubStop"},
          }
        },
        {
          name = "sing player",
          length = 64,
          resizable = true,
          pitchShift = true,
          pitch = 1,
          hits = {
            {name = "singp",x = 0,cueId = "gleeClubSing",loop = true,input = "releaseA"},
          }
        },
        {
          name = "stop player",
          length = 32,
          hits = {
            {name = "stopp",x = 0,cueId = "gleeClubStop",input = "pressA"},
          }
        }
      }
    },
    [11] = {
      hidden = true,
      name = "manzai birds",
      group = "wii",
      img = love.graphics.newImage("/resources/gfx/editor/icons/manzaiBirds.png"),
      --ORIGINAL BPM = 95
      blocks = {
        {
          name = "aichini aichinna",
          length = 256-32,
          cues = {
            {name = "talk",x = 0,cueId = "manzaiAichini_aichinna",pitchToBpm = true,originalBpm = 95}
          },
          hits = {
            {name = "hai1",x = 64+64+32,cueId = "manzaiHai",input = "pressA",pitchToBpm = true,originalBpm = 95},
            {name = "hai2",x = 64+64+64,cueId = "manzaiHai2",input = "pressA",pitchToBpm = true,originalBpm = 95}
          }
        },
        {
          name = "aichini aichinna BOING",
          length = 256-32,
          cues = {
            {name = "talk",x = 0,cueId = "manzaiAichini_aichinna",pitchToBpm = true,originalBpm = 95},
            {name = "boing",x = 64+32,cueId = "manzaiBoing",pitchToBpm = true,originalBpm = 95}
          },
          hits = {
            {name = "hit",x = 128+32,cueId = "manzaiDonaiyanen",pitchToBpm = true,originalBpm = 95,input = "pressA"}
          }
        },
      }
    },
    [12] = {
      name = "mr. upbeat",
      group = "gba",
      img = love.graphics.newImage("/resources/gfx/editor/icons/mrupbeat.png"),
      blocks = {
        {
          name = "4 steps",
          length = 256,
          cues = {
            {name = "metroR",x = 0,cueId = "MrUpbeatRight"},
            {name = "metroL",x = 64,cueId = "MrUpbeatLeft"},
            {name = "metroR",x = 128,cueId = "MrUpbeatRight"},
            {name = "metroL",x = 128+64,cueId = "MrUpbeatLeft"},
          },
          hits = {
            {name = "step",x = 32,cueId = "MrUpbeatStep",input = "pressA"},
            {name = "step",x = 64+32,cueId = "MrUpbeatStep",input = "pressA"},
            {name = "step",x = 128+32,cueId = "MrUpbeatStep",input = "pressA"},
            {name = "step",x = 128+64+32,cueId = "MrUpbeatStep",input = "pressA"},
          }
        },
        {
          name = "2 steps",
          length = 128,
          cues = {
            {name = "metroR",x = 0,cueId = "MrUpbeatRight"},
            {name = "metroL",x = 64,cueId = "MrUpbeatLeft"},
          },
          hits = {
            {name = "step",x = 32,cueId = "MrUpbeatStep",input = "pressA"},
            {name = "step",x = 64+32,cueId = "MrUpbeatStep",input = "pressA"},
          }
        },
        {
          name = "step right",
          length = 64,
          cues = {
            {name = "metroR",x = 0,cueId = "MrUpbeatRight"},
          },
          hits = {
            {name = "step",x = 32,cueId = "MrUpbeatStep",input = "pressA"},
          }
        },
        {
          name = "step left",
          length = 64,
          cues = {
            {name = "metroL",x = 0,cueId = "MrUpbeatLeft"},
          },
          hits = {
            {name = "step",x = 32,cueId = "MrUpbeatStep",input = "pressA"},
          }
        },
        {
          name = "count in",
          length = 256*2,
          cues = {
            {name = "one",x = 0,cueId = "MrUpbeatOne"},
            
            {name = "two",x = 128,cueId = "MrUpbeatTwo"},
            
            {name = "one",x = 256,cueId = "MrUpbeatOne"},
            {name = "two",x = 256+64,cueId = "MrUpbeatTwo"},
            {name = "three",x = 256+128,cueId = "MrUpbeatThree"},
            {name = "four",x = 256+128+64,cueId = "MrUpbeatFour"},
            
            {name = "beep",x = 32,cueId = "MrUpbeatBeep"},
            {name = "beep",x = 64+32,cueId = "MrUpbeatBeep"},
            {name = "beep",x = 128+32,cueId = "MrUpbeatBeep"},
            {name = "beep",x = 128+64+32,cueId = "MrUpbeatBeep"},
            {name = "beep",x = 256+32,cueId = "MrUpbeatBeep"},
            {name = "beep",x = 256+64+32,cueId = "MrUpbeatBeep"},
            {name = "beep",x = 256+128+32,cueId = "MrUpbeatBeep"},
            {name = "beep",x = 256+128+64+32,cueId = "MrUpbeatBeep"},
          }
        },
        {
          name = "ding",
          length = 64,
          pitchShift = true,
          cues = {
            {name = "ding",x = 0,cueId = "MrUpbeatDing",pitch = 1},
          }
        }
      }
    },
    [13] = {
      name = "wario de mambo",
      group = "gba",
      hidden = true,
      blocks = {
        {
          name = "memorize!",
          length = 64,
          cues = {
            {name = "memorize",x = 0,cueId = "warioDeMamboMemorize"},
          }
        },
        {
          name = "lean left",
          length = 64,
          cues = {
            {name = "lean left",x = 0,cueId = "warioDeMamboLeanLeft"},
          }
        },
        {
          name = "lean right",
          length = 64,
          cues = {
            {name = "lean right",x = 0,cueId = "warioDeMamboLeanRight"},
          }
        },
        {
          name = "jump",
          length = 64,
          cues = {
            {name = "jump",x = 0,cueId = "warioDeMamboJump"},
          }
        },
        {
          name = "count in",
          length = 256,
          cues = {
            {name = "four",x = 0,cueId = "warioDeMamboFour"},
            {name = "three",x = 64,cueId = "warioDeMamboThree"},
            {name = "two",x = 128,cueId = "warioDeMamboTwo"},
            {name = "one",x = 128+64,cueId = "warioDeMamboOne"},
          }
        },
        {
          name = "lean left player",
          length = 64,
          hits = {
            {name = "lean left",x = 0,cueId = "warioDeMamboLeanLeft",input = "pressLEFT"},
          }
        },
        {
          name = "lean right player",
          length = 64,
          hits = {
            {name = "lean right",x = 0,cueId = "warioDeMamboLeanRight",input = "pressRIGHT"},
          }
        },
        {
          name = "jump player",
          length = 64,
          hits = {
            {name = "jump",x = 0,cueId = "warioDeMamboJump",input = "pressA"},
          }
        },        
      },
    },  
    [14] = {
      name = "tap trial (GBA)",
      group = "gba",
      img = love.graphics.newImage("/resources/gfx/editor/icons/tapTrial.png"),
      blocks = {
        {
          name = "tap",
          length = 128,
          cues = {
            {name = "ook",x = 0,cueId = "tapTrialOok"}
          },
          hits = {
            {name = "tap",x = 64,cueId = "tapTrialTap",input = "pressA"}
          }
        },
        {
          name = "tap tap",
          length = 128,
          cues = {
            {name = "ook1",x = 0,cueId = "tapTrialOokook1"},
            {name = "ook2",x = 32,cueId = "tapTrialOokook2"},
          },
          hits = {
            {name = "tap",x = 64,cueId = "tapTrialTap",input = "pressA"},
            {name = "tap",x = 96,cueId = "tapTrialTap",input = "pressA"},
          }
        },
        {
          name = "tap tap tap",
          length = 256,
          cues = {
            {name = "ookee1",x = 0,cueId = "tapTrialOokee1"},
            {name = "ookee2",x = 32,cueId = "tapTrialOokee2"},
          },
          hits = {
            {name = "tap1",x = 128,cueId = "tapTrialTap",input = "pressA"},
            {name = "tap2",x = 128+32,cueId = "tapTrialTap",input = "pressA"},
            {name = "tap3",x = 128+64,cueId = "tapTrialTap",input = "pressA"},
          }
        },
      }
    },
    [15] = {
      name = "crop stomp",
      group = "ds",
      img = love.graphics.newImage("/resources/gfx/editor/icons/cropStomp.png"),
      hidden = true,
      blocks = {
        
      }
    },
    [16] = {
      name = "tap troupe",
      group = "wii",
      img = love.graphics.newImage("/resources/gfx/editor/icons/taptroupe.png"),
      blocks = {
        {
          name = "countIn",
          length = 64,
          cues = {
            {name = "countIn",x = 0,cueId = "silence"},
          },
        },
        {
          name = "4 taps",
          length = 256,
          cues = {
            {name = "tap1",x = 0,cueId = "tapTroupeTap1"},
            {name = "tap2",x = 64,cueId = "tapTroupeTap2"},
            {name = "tap1",x = 128,cueId = "tapTroupeTap1"},
            {name = "tap2",x = 128+64,cueId = "tapTroupeTap2"},
          },
          hits = {
            {name = "tap1p",x = 0,cueId = "silence",input = "pressA"},
            {name = "tap2p",x = 64,cueId = "silence",input = "pressA"},
            {name = "tap1p",x = 128,cueId = "silence",input = "pressA"},
            {name = "tap2p",x = 128+64,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "tap 1",
          length = 64,
          cues = {
            {name = "tap1",x = 0,cueId = "tapTroupeTap1"},
          },
          hits = {
            {name = "tap1p",x = 0,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "tap 2",
          length = 64,
          cues = {
            {name = "tap2",x = 0,cueId = "tapTroupeTap2"},
          },
          hits = {
            {name = "tap2p",x = 0,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "ready",
          length = 128,
          cues = {
            {name = "tap1",x = 0,cueId = "tapTroupeReady1"},
            {name = "tapReady",x = 64,cueId = "tapTroupeReady2"},
            {name = "ready",x = 64+48,cueId = "silence"},
          },
          hits = {
            {name = "tap1p",x = 0,cueId = "silence",input = "pressA"},
            {name = "tap2p",x = 64,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "and",
          length = 32,
          cues = {
            {name = "and",x = 0,cueId = "tapTroupeAnd"},
          },
        },
        {
          name = "tap tap",
          length = 128-32,
          cues = {
            {name = "tapb",x = 0,cueId = "tapTroupeTapVoice1"},
            {name = "tapb",x = 64+16-32,cueId = "tapTroupeTapVoice2"},
            {name = "tap3bpre",x = 128-16-32,cueId = "silence"},
          },
          hits = {
            {name = "tap1p",x = 32-32,cueId = "silence",input = "pressA"},
            {name = "tap1p",x = 64+16-32,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "TAP",
          length = 64,
          cues = {
            {name = "tap3b",x = 0,cueId = "tapTroupeTapVoice3"},
          },
          hits = {
            {name = "tap1p",x = 0,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "2 boms",
          length = 16*6,
          cues = {
            {name = "bom1",x = 0,cueId = "tapTroupeBom1"},
            {name = "bom2",x = 16*3,cueId = "tapTroupeBom2"},
          },
          hits = {
            {name = "bom1p",x = 0,cueId = "silence",input = "pressA"},
            {name = "bom1p",x = 16*3,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "bom 1",
          length = 16*3,
          cues = {
            {name = "bom1",x = 0,cueId = "tapTroupeBom1"},
          },
          hits = {
            {name = "bom1p",x = 0,cueId = "silence",input = "pressA"},
          },
        },
        {
          name = "bom 2",
          length = 16*3,
          cues = {
            {name = "bom2",x = 0,cueId = "tapTroupeBom2"},
          },
          hits = {
            {name = "bom1p",x = 0,cueId = "silence",input = "pressA"},
          },
        },
      }
    },
    [17] = {
      name = "fan club",
      group = "3ds",
      img = love.graphics.newImage("/resources/gfx/editor/icons/fanclub.png"),
      blocks = {
        {
          name = "hai hai hai",
          length = 8*64,
          cues = {
            {name = "hai",x = 0,cueId = "fanClubSingerHai1"},
            {name = "hai",x = 64,cueId = "fanClubSingerHai2"},
            {name = "hai",x = 128,cueId = "fanClubSingerHai3"},
          },
          hits = {
            {name = "haiA",x = 256,cueId = "fanClubAudienceHai",input = "pressA"},
            {name = "haiA",x = 256+64,cueId = "fanClubAudienceHai",input = "pressA"},
            {name = "haiA",x = 256+64*2,cueId = "fanClubAudienceHai",input = "pressA"},
            {name = "haiA",x = 256+64*3,cueId = "fanClubAudienceHai",input = "pressA"},
          }
        },
        {
          name = "kamone",
          length = 8*64,
          cues = {
            {name = "ka",x = 0,cueId = "fanClubSingerKamone1"},
            {name = "mo",x = 32,cueId = "fanClubSingerKamone2"},
            {name = "ne",x = 64,cueId = "fanClubSingerKamone3"},
          },
          hits = {
            {name = "kaA",x = 128,cueId = "fanClubAudienceKamone1",input = "pressA"},
            {name = "moA",x = 128+96,cueId = "fanClubAudienceKamone2",input = "pressA"},
            {name = "neA",x = 256,cueId = "fanClubAudienceKamone3",input = "pressA"},
            {name = "jump",x = 256+64,cueId = "fanClubAudienceKamone4",input = "releaseA"},
          }
        },
        {
          name = "OOH",
          length = 4*64,
          cues = {
            {name = "ooh",x = 0,cueId = "fanClubOoh1"},
          },
          hits = {
            {name = "oohClap",x = 128+32,cueId = "fanClubOoh2",input = "pressA"},
            {name = "oohClap",x = 128+64,cueId = "fanClubOoh3",input = "pressA"},
          }
        }
      }
    },
    [18] = {
      name = "shoot 'em up",
      group = "ds",
      hidden = true,
      img = love.graphics.newImage("/resources/gfx/editor/icons/shootemup.png"),
      blocks = {
        
      }
    },
  }
  
  for _,i in pairs(minigames) do
    print(i.name)
    if i.blocks then
      for _,j in pairs(i.blocks) do
        if j.cues then
          for _,h in pairs(j.cues) do
            if not h.sound then
              h.sound = cue[h.cueId]()
            end
          end
        end
        if j.hits then
          for _,h in pairs(j.hits) do
            if not h.sound then
              h.sound = cue[h.cueId]()
            end
          end
        end
      end
    end
  end
  
  local w,h = love.graphics.getDimensions()
  view = {
    canvas = love.graphics.newCanvas(w,h),
    width = 1920/2,
    height = 1080/2,
    flipH = 1,
    flipV = 1,
    shake = 0,
  }
  
  minigame = 0
  if love.filesystem.exists("preferences.sav") then
    if love.filesystem.isFused() then
      screen = "credits"
      loadCredits()
    else 
      screen = "editor" --dev start screen
    end
    loadMenu()
    
    local file = love.filesystem.newFile("preferences.sav")
    if file:open('r') then
      pref = json.decode(file:read())
    end
  else
    screen = "init"
    loadInit()
  end
  
  loadEditor()
  
  mouse = {
    button = {
      pressed = {},
      released = {}
    }
  }
end

function initializeData()
  data = {
    bpm = 125,
    time = 0,
    beat = 0,
    beatCount = 0,
    musicStart = 2.75,
    music = newSource("/resources/music/practice.ogg"),
    blocks = {},
    tempoChanges = {},
    version = version,
    endless = false,
    lives = 3,
    speedUp = 0.1,
    options = {
      name = "REMIX",
      header = "Rhythm League Notes",
      rating = {
        ["tryAgain"] = "That...could have been better.",
        ["ok"] = "Eh. Good enough.",
        ["superb"] = "That was great! Really great!",
      },
      okRating = 3,
      tryAgainRating = 10,
      endFadeOutTime = 100,
      minigameFadeTime = 7,
      karateka = {
        flow = true,
        persistent = true,
        startFlow = 0
      },
      lockStep = {
        colors = {
          ["bg"] = "f83888",
          ["marcher0"] = "982860",
          ["marcher1"] = "707070",
          ["marcher2"] = "f8d8e8"
        },
        paletteSwap = "yes"
      },
      clappyTrio = {
        headBeat = false,
      }
    }
  }
  data.music:setVolume(0.25)
end

function love.mousepressed(x,y,btn)
  mouse.button.pressed[btn] = true
end
function love.mousereleased(x,y,btn)
  mouse.button.released[btn] = true
end

function love.filedropped(file)
  if screen == "editor" then
  local filename = file:getFilename()
    if string.lower(string.sub(filename,filename:len()-3)) == ".thm" then
      if file:open("r") then
        local d = file:read()
        pref.theme = json.decode(d)
        loadEditor()
      end
    elseif string.lower(string.sub(filename,filename:len()-3)) == ".ogg" or string.lower(string.sub(filename,filename:len()-3)) == ".wav" or string.lower(string.sub(filename,filename:len()-3)) == ".mp3" then
      editorLoadMusic(file)
    elseif string.lower(string.sub(filename,filename:len()-4)) == ".rhrm" then
      editorLoadBeatmap(file)
    elseif string.lower(string.sub(filename,filename:len()-3)) == ".gfx" then
      if file:open("r") then
        local d = file:read()
        if not love.filesystem.exists("temp") then
          love.filesystem.createDirectory("temp")
        end
        success, message = love.filesystem.write("temp/assets.gfx",d)
        file:close()
        if success then
          file = love.filesystem.newFile("temp/assets.gfx")
          editorLoadAssets(file)
        end
      end
    elseif string.lower(string.sub(filename,filename:len()-5)) == ".brhrm" then
      if file:open("r") then
        local d = file:read()
        if not love.filesystem.exists("temp") then
          love.filesystem.createDirectory("temp")
        end
        success, message = love.filesystem.write("temp/remix.brhrm",d)

        if success then
          love.filesystem.mount("temp/remix.brhrm","temp",true)
          
          local nFile
          local nd
          --[[for _,i in pairs(love.filesystem.getDirectoryItems("temp")) do
            nFile = love.filesystem.newFile("temp/"..i)
            
            if nFile:open("r") then
              nd = nFile:read()
              love.filesystem.write("temp/"..i,nd)
            end
          end]]
          
          --love.filesystem.unmount("temp/remix.brhrm")
          
          for _,i in pairs(love.filesystem.getDirectoryItems("temp")) do
            print(i)
            nFile = love.filesystem.newFile("temp/"..i)
            if string.lower(string.sub(i,i:len()-3)) == ".ogg" or string.lower(string.sub(i,i:len()-3)) == ".wav" or string.lower(string.sub(i,i:len()-3)) == ".mp3" then
              editorLoadMusic(nFile)
              print("loaded music")
            elseif string.lower(string.sub(i,i:len()-4)) == ".rhrm" then
              editorLoadBeatmap(nFile)
              print("loaded beatmap")
            elseif string.lower(string.sub(i,i:len()-3)) == ".gfx" then
              editorLoadAssets(nFile)
              print("loaded assets")
            end
          end
          love.window.setTitle("RHRM - "..version.." - "..filename)
        else
          print("THERE WAS AN ERROR WHILE LOADING:")
          print(message)
        end
      end
    end
  elseif screen == "menu" then
    filedroppedMenu(file)
  end
end

function editorLoadMusic(file)
  local filename = file:getFilename()
  if file:open("r") then
    if not love.filesystem.exists("temp") then
      love.filesystem.createDirectory("temp")
    end
    local d = file:read()
    local nFilename = "temp/music"..string.lower(string.sub(filename,filename:len()-3))
    love.filesystem.write(nFilename,d)
    local file = love.filesystem.newFile(nFilename)
    data.music = love.audio.newSource(file)
    data.music:setVolume(0.25)
    print("MUSIC LOADED !")
  end
end
function editorLoadBeatmap(file)
  --load data
  if file:open("r") then
    --READ DATA
    local d = file:read()
    if not love.filesystem.exists("temp") then
      love.filesystem.createDirectory("temp")
    end
    local nFilename = "temp/beatmap.rhrm"
    love.filesystem.write(nFilename,d)
    local file = love.filesystem.newFile(nFilename)
    
    d = file:read()
    --print(d)
    data = json.decode(d)
    for _,i in pairs(data.blocks) do
      if i.cues then
        for _,j in pairs(i.cues) do
          j.sound = cue[j.cueId]()
        end
      end
      if i.hits then
        for _,j in pairs(i.hits) do
          j.sound = cue[j.cueId]()
        end
      end
    end
    data.beat = 0
    data.beatCount = 0
    data.time = 0
    
    if not data.musicStart then
      data.musicStart = 0
    end
    
    print("BEATMAP LOADED !")
  end
end
function editorLoadAssets(file)
  if file:open("r") then
    if not love.filesystem.exists("tempAssets") then
      love.filesystem.createDirectory("tempAssets")
    end
    
    local d = file:read()
    local filename = file:getFilename()
    local success, message = love.filesystem.write(filename,d)
    
    if success then
      local unmountSuccess = love.filesystem.unmount(filename)
      local mountSuccess = love.filesystem.mount(filename,"tempAssets",true)
      if not mountSuccess then
        print("ERROR WHILE LOADING ASSETS")
      else
        print("ASSETS LOADED !")
      end
    else
      print("ERROR WHILE LOADING ASSETS:")
      print(message)
    end
    file:close()
  end
end

function love.update(dt)
  if screen == "menu" then
    updateMenu(dt)
  elseif screen == "editor" then
    updateEditor(dt)
  elseif screen == "game" then
    updateGameInputs(dt)
  elseif screen == "save" then
    updateSavescreen(dt)
  elseif screen == "remixOptions" then
    updateRemixOptions(dt)
  elseif screen == "init" then
    updateInit(dt)
  elseif screen == "credits" then
    updateCredits(dt)
  elseif screen == "library" then
    updateLibrary(dt)
  end
  
  mouse.button.pressed[1] = false
  mouse.button.released[1] = false
  mouse.button.pressed[2] = false
  mouse.button.released[2] = false
  mouse.button.pressed[3] = false
  mouse.button.released[3] = false

  if view.shake > 0 then
    view.shake = view.shake/1.02
    if view.shake < 0.5 then
      view.shake = 0
    end
  end
end

function love.draw()
  --set canvas
  love.graphics.setCanvas(view.canvas)
  --love.graphics.clear()
  --draw the stuff
  love.graphics.setFont(font)
  if screen == "menu" then
    drawMenu()
  elseif screen == "editor" then
    drawEditor()
  elseif screen == "game" then
    drawGameInputs()
  elseif screen == "save" then
    drawSavescreen()
  elseif screen == "remixOptions" then
    drawRemixOptions()
  elseif screen == "init" then
    drawInit()
  elseif screen == "credits" then
    drawCredits()
  elseif screen == "library" then
    drawLibrary()
  end
  --draw the canvas
  love.graphics.reset()
  love.graphics.setDefaultFilter("nearest","nearest")
  
  local w,h = love.graphics.getDimensions()
  local x = 0
  if view.flipH == -1 then
    x = w
  end
  local y = 0
  if view.flipV == -1 then
    y = h
  end
  love.graphics.draw(view.canvas,x+math.random(-view.shake,view.shake)*2,y+math.random(-view.shake,view.shake)*2,0,(w/view.width)*view.flipH,(h/view.height)*view.flipV)
end

function love.quit()
  local d = json.encode(pref)
  love.filesystem.write("preferences.sav",d)
  deleteTempFiles()
end

function deleteTempFiles()
    love.filesystem.unmount("temp/assets.gfx")
  
    local function recursivelyDelete(item, depth)
        if love.filesystem.isDirectory(item) then
            for _, child in pairs(love.filesystem.getDirectoryItems(item)) do
                recursivelyDelete(item .. '/' .. child, depth + 1);
                love.filesystem.remove(item .. '/' .. child);
            end
        elseif love.filesystem.isFile(item) then
            print(item)
            love.filesystem.remove(item);
        end
         print(item)
        love.filesystem.remove(item)
    end
 
    recursivelyDelete('temp', 0);
    recursivelyDelete('tempAssets', 0);
end

function hex2rgb(hex,returnTable)
    local returnTable = returnTable
    hex = hex:gsub("#","")
    
    if returnTable then
      return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)), 255}
    else
      return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    end
end

function setColorHex(hex,alpha)
  local r,g,b = hex2rgb(hex)
  love.graphics.setColor(r,g,b,alpha or 255)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function pointTowards(x1,y1,x2,y2)
  return math.atan2((y2 - y1), (x2 - x1))
end

function tableEmpty(t)
  for _,i in pairs(t) do
    return false
  end
  return true
end

function tableFirstEntry(t)
  for _,i in pairs(t) do
    return i
  end
end


function tableLength(t)
  local n = 0
  for _,i in pairs(t) do
    n = n+1
  end
  return n
end

function distance( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function loadLuaFile(name)
  local ok, chunk, result
  ok, chunk = pcall( love.filesystem.load, name ) -- load the chunk safely
  if not ok then
    print('The following error happend: ' .. tostring(chunk))
  else
    ok, result = pcall(chunk) -- execute the chunk safely
   
    if not ok then -- will be false if there is an error
      print('The following error happened: ' .. tostring(result))
    else
      print('The result of loading is: ' .. tostring(result))
    end
  end
  return result
end

sourceFilenames = {}
--source
function newSource(filename)
  local s = love.audio.newSource(filename)
  --print(s)
  sourceFilenames[tostring(s)] = filename
  --print(sourceFilenames[tostring(s)])
  return s
end

function cycleTable(t)
  local t = t
  local entry = tableFirstEntry(t)
  print(entry)
  table.insert(t,entry)
  for k,i in pairs(t) do
    if k > 1 then
      t[k] = t[k-1]
      print(i.." from "..k.." to "..k-1)
    end
    if k == tableLength(t)-1 then
      table.remove(t,k)
      print(i.." was removed")
    end
  end
  return t
end

function printNew(str,x,y,r,sx,sy,ox,oy,kx,ky)
  local fnt = love.graphics.getFont()
  local y = y or 0
  love.graphics.print(str,x,y-(fnt:getHeight()/2),r,sx,sy,ox,oy,kx,ky)
end

function getRemixTime()
  return data.time
end

function sign(n)
  if n > 0 then
    return 1
  elseif n < 0 then
    return -1
  end
  return 0
end

function executePowershell(str)
  -- You can generate PowerShell script at run-time
  local script = str
  -- Now create powershell process and feed your script to its stdin
  local pipe = io.popen("powershell -command -", "w")
  pipe:write(script)
  pipe:close()
end

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

function newVertGradient(w, h, c1, c2)
  local data = love.image.newImageData(1, h)
  for j=0, h-1 do
    local percent = j/h
    local r = c1[1] + (c2[1] - c1[1]) * percent
    local g = c1[2] + (c2[2] - c1[2]) * percent
    local b = c1[3] + (c2[3] - c1[3]) * percent
    local a = c1[4] + (c2[4] - c1[4]) * percent
    data:setPixel(0, j, r, g, b, a)
  end

  local img = love.graphics.newImage(data)
  img:setWrap('repeat', 'clamp')

  local quad = love.graphics.newQuad(0, 0, w, h, 1, h)

  return img, quad
end