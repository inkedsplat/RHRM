function initializeCues()
  cue = {}
  cue["countIn1"] = function() return newSource("/resources/sfx/game/countIn1.ogg")end
  cue["countIn2"] = function() return newSource("/resources/sfx/game/countIn2.ogg")end
  cue["countIn3"] = function() return newSource("/resources/sfx/game/countIn3.ogg")end
  cue["countIn4"] = function() return newSource("/resources/sfx/game/countIn4.ogg")end
  
  cue["countIn1Sp"] = function() return newSource("/resources/sfx/editor/oneH.ogg")end
  cue["countIn2Sp"] = function() return newSource("/resources/sfx/editor/twoH.ogg")end
  cue["countIn3Sp"] = function() return newSource("/resources/sfx/editor/threeH.ogg")end
  cue["countIn4Sp"] = function() return newSource("/resources/sfx/editor/fourH.ogg")end
  
  cue["cowbell"] = function() return newSource("/resources/sfx/game/cowbell.ogg")end
  
  cue["silence"] = function() return newSource("/resources/sfx/silence.ogg")end
  
  cue["karatekaPotThrow"] = function() return newSource("/resources/sfx/karate man (GBA)/potThrow.ogg")end
  cue["karatekaPotHit"] = function() return newSource("/resources/sfx/karate man (GBA)/potHit.ogg")end
  cue["karatekaRockHit"] = function() return newSource("/resources/sfx/karate man (GBA)/rockHit.ogg")end
  cue["karatekaMi"] = function() return newSource("/resources/sfx/karate man (GBA)/mi.ogg")end
  cue["karatekaTsu"] = function() return newSource("/resources/sfx/karate man (GBA)/tsu.ogg")end
  
  cue["tweezersRootAppear"] = function() return newSource("/resources/sfx/rhythm tweezers (GBA)/hairAppear.ogg")end
  cue["tweezersRootPluck"] = function() return newSource("/resources/sfx/rhythm tweezers (GBA)/hairPluck.ogg")end
  cue["tweezersRootAppearLong"] = function() return newSource("/resources/sfx/rhythm tweezers (GBA)/hairAppearLong.ogg")end
  cue["tweezersRootPluckLong1"] = function() return newSource("/resources/sfx/rhythm tweezers (GBA)/hairPluckLong1.ogg")end
  cue["tweezersRootPluckLong2"] = function() return newSource("/resources/sfx/rhythm tweezers (GBA)/hairPluckLong2.ogg")end
  
  cue["BlueBirdsPeck"] = function() return newSource("/resources/sfx/Blue birds/peck.ogg")end
  cue["BlueBirdsYour"] = function() return newSource("/resources/sfx/Blue birds/your.ogg")end
  cue["BlueBirdsBeak"] = function() return newSource("/resources/sfx/Blue birds/beak.ogg")end
  cue["BlueBirdsPeckPlayer"] = function() return newSource("/resources/sfx/Blue birds/peckPlayer.ogg")end
  cue["BlueBirdsStretch"] = function() return newSource("/resources/sfx/Blue birds/stretch.ogg")end
  cue["BlueBirdsOut"] = function() return newSource("/resources/sfx/Blue birds/out.ogg")end
  cue["BlueBirdsYour2"] = function() return newSource("/resources/sfx/Blue birds/your2.ogg")end
  cue["BlueBirdsNeck"] = function() return newSource("/resources/sfx/Blue birds/neck.ogg")end
  cue["BlueBirdsStretchPlayer1"] = function() return newSource("/resources/sfx/Blue birds/stretchPlayer1.ogg")end
  cue["BlueBirdsStretchPlayer2"] = function() return newSource("/resources/sfx/Blue birds/stretchPlayer2.ogg")end
  
  cue["ForkLifterFlick"] = function() return newSource("/resources/sfx/Fork Lifter/flick.ogg")end
  cue["ForkLifterZoom"] = function() return newSource("/resources/sfx/Fork Lifter/zoom.ogg")end
  cue["ForkLifterStab"] = function() return newSource("/resources/sfx/Fork Lifter/stab.ogg")end
  cue["ForkLifterEat"] = function() return newSource("/resources/sfx/Fork Lifter/eat.ogg")end
  
  cue["ClappyTrioPrep"] = function() return newSource("/resources/sfx/Clappy Trio (Wii)/prepare.ogg")end
  cue["ClappyTrioClap"] = function() return newSource("/resources/sfx/Clappy Trio (Wii)/clap.ogg")end
  
  cue["LockStepOn"] = function() return newSource("/resources/sfx/Lock step/stepOn.ogg")end
  cue["LockStepOff"] = function() return newSource("/resources/sfx/Lock step/stepOff.ogg")end
  cue["LockStepHai"] = function() return newSource("/resources/sfx/Lock step/hai.ogg")end
  cue["LockStepHa"] = function() return newSource("/resources/sfx/Lock step/ha.ogg")end
  cue["LockStepHaOff"] = function() return newSource("/resources/sfx/Lock step/haOff.ogg")end
  cue["LockStepHaiOff"] = function() return newSource("/resources/sfx/Lock step/haiOff.ogg")end
  cue["LockStepOuf"] = function() return newSource("/resources/sfx/Lock step/ouf.ogg")end
  cue["LockStepHm"] = function() return newSource("/resources/sfx/Lock step/hm.ogg")end
  
  cue["ScrewBotsCrane1"] = function() return newSource("/resources/sfx/screw bots/crane1.ogg")end
  cue["ScrewBotsCrane2"] = function() return newSource("/resources/sfx/screw bots/crane2.ogg")end
  cue["ScrewBotsCraneWhite"] = function() return newSource("/resources/sfx/screw bots/craneWhite.ogg")end
  cue["ScrewBotsBlackDrop"] = function() return newSource("/resources/sfx/screw bots/blackDrop.ogg")end
  cue["ScrewBotsBlackScrew"] = function() return newSource("/resources/sfx/screw bots/blackScrew.ogg")end
  cue["ScrewBotsWhiteDrop"] = function() return newSource("/resources/sfx/screw bots/whiteDrop.ogg")end
  cue["ScrewBotsWhiteScrew"] = function() return newSource("/resources/sfx/screw bots/whiteScrew.ogg")end
  cue["ScrewBotsComplete"] = function() return newSource("/resources/sfx/screw bots/complete.ogg")end
  
  cue["MoaiDooLStart"] = function() return newSource("/resources/sfx/moai doo woop/dooLStart.ogg")end
  cue["MoaiDooL"] = function() return newSource("/resources/sfx/moai doo woop/dooL.ogg")end
  cue["MoaiWopL"] = function() return newSource("/resources/sfx/moai doo woop/woopL.ogg")end
  cue["MoaiPahL"] = function() return newSource("/resources/sfx/moai doo woop/pahL.ogg")end
  cue["MoaiSwitch"] = function() return newSource("/resources/sfx/moai doo woop/switch.ogg")end
  cue["MoaiDooRStart"] = function() return newSource("/resources/sfx/moai doo woop/dooRStart.ogg")end
  cue["MoaiDooR"] = function() return newSource("/resources/sfx/moai doo woop/dooR.ogg")end
  cue["MoaiWopR"] = function() return newSource("/resources/sfx/moai doo woop/woopR.ogg")end
  cue["MoaiPahR"] = function() return newSource("/resources/sfx/moai doo woop/pahR.ogg")end
  
  cue["cheerReadersOneSolo"] = function() return newSource("/resources/sfx/cheer readers/oneSolo.ogg")end
  cue["cheerReadersTwoSolo"] = function() return newSource("/resources/sfx/cheer readers/twoSolo.ogg")end
  cue["cheerReadersThreeSolo"] = function() return newSource("/resources/sfx/cheer readers/threeSolo.ogg")end
  cue["cheerReadersItsSolo"] = function() return newSource("/resources/sfx/cheer readers/itsSolo.ogg")end
  cue["cheerReadersUpSolo"] = function() return newSource("/resources/sfx/cheer readers/upSolo.ogg")end
  cue["cheerReadersToSolo"] = function() return newSource("/resources/sfx/cheer readers/toSolo.ogg")end
  cue["cheerReadersYouSolo"] = function() return newSource("/resources/sfx/cheer readers/youSolo.ogg")end
  cue["cheerReadersOSolo"] = function() return newSource("/resources/sfx/cheer readers/oSolo.ogg")end
  cue["cheerReadersKaySolo"] = function() return newSource("/resources/sfx/cheer readers/kaySolo.ogg")end
  cue["cheerReadersItsSolo2"] = function() return newSource("/resources/sfx/cheer readers/itsSolo2.ogg")end
  cue["cheerReadersOnSolo"] = function() return newSource("/resources/sfx/cheer readers/onSolo.ogg")end
  
  cue["cheerReadersOneGirls"] = function() return newSource("/resources/sfx/cheer readers/oneGirls.ogg")end
  cue["cheerReadersTwoGirls"] = function() return newSource("/resources/sfx/cheer readers/twoGirls.ogg")end
  cue["cheerReadersThreeGirls"] = function() return newSource("/resources/sfx/cheer readers/threeGirls.ogg")end
  cue["cheerReadersItsGirls"] = function() return newSource("/resources/sfx/cheer readers/itsGirls.ogg")end
  cue["cheerReadersUpGirls"] = function() return newSource("/resources/sfx/cheer readers/upGirls.ogg")end
  cue["cheerReadersToGirls"] = function() return newSource("/resources/sfx/cheer readers/toGirls.ogg")end
  cue["cheerReadersYouGirls"] = function() return newSource("/resources/sfx/cheer readers/youGirls.ogg")end
  cue["cheerReadersOGirls"] = function() return newSource("/resources/sfx/cheer readers/oGirls.ogg")end
  cue["cheerReadersKayGirls"] = function() return newSource("/resources/sfx/cheer readers/kayGirls.ogg")end
  cue["cheerReadersItsGirls2"] = function() return newSource("/resources/sfx/cheer readers/itsGirls2.ogg")end
  cue["cheerReadersOnGirls"] = function() return newSource("/resources/sfx/cheer readers/onGirls.ogg")end
  
  cue["cheerReadersRaSolo"] = function() return newSource("/resources/sfx/cheer readers/raSolo.ogg")end
  cue["cheerReadersRaSolo2"] = function() return newSource("/resources/sfx/cheer readers/raSolo2.ogg")end
  cue["cheerReadersSisSolo"] = function() return newSource("/resources/sfx/cheer readers/sisSolo.ogg")end
  cue["cheerReadersBoomSolo"] = function() return newSource("/resources/sfx/cheer readers/boomSolo.ogg")end
  cue["cheerReadersBaSolo"] = function() return newSource("/resources/sfx/cheer readers/baSolo.ogg")end
  cue["cheerReadersBoomSolo2"] = function() return newSource("/resources/sfx/cheer readers/boomSolo2.ogg")end
  
  cue["cheerReadersRaGirls"] = function() return newSource("/resources/sfx/cheer readers/raGirls.ogg")end
  cue["cheerReadersRaGirls2"] = function() return newSource("/resources/sfx/cheer readers/raGirls2.ogg")end
  cue["cheerReadersSisGirls"] = function() return newSource("/resources/sfx/cheer readers/sisGirls.ogg")end
  cue["cheerReadersBoomGirls"] = function() return newSource("/resources/sfx/cheer readers/boomGirls.ogg")end
  cue["cheerReadersBaGirls"] = function() return newSource("/resources/sfx/cheer readers/baGirls.ogg")end
  cue["cheerReadersBoomGirls2"] = function() return newSource("/resources/sfx/cheer readers/boomGirls2.ogg")end
  
  cue["cheerReadersLetsSolo"] = function() return newSource("/resources/sfx/cheer readers/letsSolo.ogg")end
  cue["cheerReadersGoSolo"] = function() return newSource("/resources/sfx/cheer readers/goSolo.ogg")end
  cue["cheerReadersReadSolo"] = function() return newSource("/resources/sfx/cheer readers/readSolo.ogg")end
  cue["cheerReadersASolo"] = function() return newSource("/resources/sfx/cheer readers/aSolo.ogg")end
  cue["cheerReadersBunchSolo"] = function() return newSource("/resources/sfx/cheer readers/bunchSolo.ogg")end
  cue["cheerReadersOfSolo"] = function() return newSource("/resources/sfx/cheer readers/ofSolo.ogg")end
  cue["cheerReadersBooksSolo"] = function() return newSource("/resources/sfx/cheer readers/booksSolo.ogg")end
  
  cue["cheerReadersLetsGirls"] = function() return newSource("/resources/sfx/cheer readers/letsGirls.ogg")end
  cue["cheerReadersGoGirls"] = function() return newSource("/resources/sfx/cheer readers/goGirls.ogg")end
  cue["cheerReadersReadGirls"] = function() return newSource("/resources/sfx/cheer readers/readGirls.ogg")end
  cue["cheerReadersAGirls"] = function() return newSource("/resources/sfx/cheer readers/aGirls.ogg")end
  cue["cheerReadersBunchGirls"] = function() return newSource("/resources/sfx/cheer readers/bunchGirls.ogg")end
  cue["cheerReadersOfGirls"] = function() return newSource("/resources/sfx/cheer readers/ofGirls.ogg")end
  cue["cheerReadersBooksGirls"] = function() return newSource("/resources/sfx/cheer readers/booksGirls.ogg")end
  
  cue["gleeClubSing"] = function() return newSource("/resources/sfx/glee club/sing.ogg") end
  cue["gleeClubStop"] = function() return newSource("/resources/sfx/glee club/closeMouth.ogg") end
  
  
  cue["manzaiBoing"] = function() return newSource("/resources/sfx/manzai birds/boing.ogg") end
  cue["manzaiHai"] = function() return newSource("/resources/sfx/manzai birds/haihai1.ogg") end
  cue["manzaiHai2"] = function() return newSource("/resources/sfx/manzai birds/haihai2.ogg") end
  cue["manzaiHai2"] = function() return newSource("/resources/sfx/manzai birds/haihai2.ogg") end
  cue["manzaiDonaiyanen"] = function() return newSource("/resources/sfx/manzai birds/donaiyanen.ogg") end
  
  cue["manzaiAichini_aichinna"] = function() return newSource("/resources/sfx/manzai birds/aichini_aichinna.ogg") end
  
  
  cue["MrUpbeatLeft"] = function() return newSource("/resources/sfx/mrUpbeat/metronomeLeft.ogg") end
  cue["MrUpbeatRight"] = function() return newSource("/resources/sfx/mrUpbeat/metronomeRight.ogg") end
  cue["MrUpbeatStep"] = function() return newSource("/resources/sfx/mrUpbeat/step.ogg") end
  cue["MrUpbeatDing"] = function() return newSource("/resources/sfx/mrUpbeat/ding.ogg") end
  cue["MrUpbeatBeep"] = function() return newSource("/resources/sfx/mrUpbeat/beep.ogg") end
  cue["MrUpbeatOne"] = function() return newSource("/resources/sfx/mrUpbeat/one.ogg") end
  cue["MrUpbeatTwo"] = function() return newSource("/resources/sfx/mrUpbeat/two.ogg") end
  cue["MrUpbeatThree"] = function() return newSource("/resources/sfx/mrUpbeat/three.ogg") end
  cue["MrUpbeatFour"] = function() return newSource("/resources/sfx/mrUpbeat/four.ogg") end
  
  cue["warioDeMamboOne"] = function() return newSource("/resources/sfx/wario de mambo/one.ogg") end
  cue["warioDeMamboTwo"] = function() return newSource("/resources/sfx/wario de mambo/two.ogg") end
  cue["warioDeMamboThree"] = function() return newSource("/resources/sfx/wario de mambo/three.ogg") end
  cue["warioDeMamboFour"] = function() return newSource("/resources/sfx/wario de mambo/four.ogg") end
  cue["warioDeMamboMemorize"] = function() return newSource("/resources/sfx/wario de mambo/memorize.ogg") end
  cue["warioDeMamboLeanLeft"] = function() return newSource("/resources/sfx/wario de mambo/leanLeft.ogg") end
  cue["warioDeMamboLeanRight"] = function() return newSource("/resources/sfx/wario de mambo/leanRight.ogg") end
  cue["warioDeMamboJump"] = function() return newSource("/resources/sfx/wario de mambo/bounce.ogg") end
  
  cue["tapTrialTap"] = function() return newSource("/resources/sfx/tap tap trial (GBA)/tap.ogg") end
  cue["tapTrialOok"] = function() return newSource("/resources/sfx/tap tap trial (GBA)/ook1.ogg") end
  cue["tapTrialOokook1"] = function() return newSource("/resources/sfx/tap tap trial (GBA)/ookook1.ogg") end
  cue["tapTrialOokook2"] = function() return newSource("/resources/sfx/tap tap trial (GBA)/ookook1.ogg") end
  cue["tapTrialOokee1"] = function() return newSource("/resources/sfx/tap tap trial (GBA)/ookee1.ogg") end
  cue["tapTrialOokee2"] = function() return newSource("/resources/sfx/tap tap trial (GBA)/ookee2.ogg") end
  
  cue["tapTroupeTap1"] = function() return newSource("/resources/sfx/tap troupe/tap1.ogg") end
  cue["tapTroupeTap2"] = function() return newSource("/resources/sfx/tap troupe/tap2.ogg") end
  cue["tapTroupeReady1"] = function() return newSource("/resources/sfx/tap troupe/ready1.ogg") end
  cue["tapTroupeReady2"] = function() return newSource("/resources/sfx/tap troupe/ready2.ogg") end
  cue["tapTroupeAnd"] = function() return newSource("/resources/sfx/tap troupe/and.ogg") end
  cue["tapTroupeTapVoice1"] = function() return newSource("/resources/sfx/tap troupe/tapVoice1.ogg") end
  cue["tapTroupeTapVoice2"] = function() return newSource("/resources/sfx/tap troupe/tapVoice2.ogg") end
  cue["tapTroupeTapVoice3"] = function() return newSource("/resources/sfx/tap troupe/tapVoice3.ogg") end
  cue["tapTroupeBom1"] = function() return newSource("/resources/sfx/tap troupe/bom1.ogg") end
  cue["tapTroupeBom2"] = function() return newSource("/resources/sfx/tap troupe/bom2.ogg") end
  
  cue["fanClubSingerHai1"] = function() return newSource("/resources/sfx/fan club (3DS)/singerHai1.ogg") end
  cue["fanClubSingerHai2"] = function() return newSource("/resources/sfx/fan club (3DS)/singerHai2.ogg") end
  cue["fanClubSingerHai3"] = function() return newSource("/resources/sfx/fan club (3DS)/singerHai3.ogg") end
  cue["fanClubAudienceHai"] = function() return newSource("/resources/sfx/fan club (3DS)/audienceHai.ogg") end
  cue["fanClubSingerKamone1"] = function() return newSource("/resources/sfx/fan club (3DS)/singerKamone1.ogg") end
  cue["fanClubSingerKamone2"] = function() return newSource("/resources/sfx/fan club (3DS)/singerKamone2.ogg") end
  cue["fanClubSingerKamone3"] = function() return newSource("/resources/sfx/fan club (3DS)/singerKamone3.ogg") end
  cue["fanClubAudienceKamone1"] = function() return newSource("/resources/sfx/fan club (3DS)/audienceKamone1.ogg") end
  cue["fanClubAudienceKamone2"] = function() return newSource("/resources/sfx/fan club (3DS)/audienceKamone2.ogg") end
  cue["fanClubAudienceKamone3"] = function() return newSource("/resources/sfx/fan club (3DS)/audienceKamone3.ogg") end
  cue["fanClubAudienceKamone4"] = function() return newSource("/resources/sfx/fan club (3DS)/audienceKamone4.ogg") end
  cue["fanClubOoh1"] = function() return newSource("/resources/sfx/fan club (3DS)/ooh1.ogg") end
  cue["fanClubOoh2"] = function() return newSource("/resources/sfx/fan club (3DS)/ooh2.ogg") end
  cue["fanClubOoh3"] = function() return newSource("/resources/sfx/fan club (3DS)/ooh3.ogg") end
end









