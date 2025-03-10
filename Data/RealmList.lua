local _, GFIO  = ...
--- realmlist to region
local REGION_REALMS_EU = {
    --German
    ["Aggramar"] = "british",
	["Arathor"] = "british",
	["Aszune"] = "british",
	["AzjolNerub"] = "british",
	["Bloodhoof"] = "british",
	["Doomhammer"] = "british",
	["Draenor"] = "british",
	["Dragonblight"] = "british",
	["EmeraldDream"] = "british",
	["Sunstrider"] = "british",
	["Twilight'sHammer"] = "british",
	["Zenedar"] = "british",
	["Agamaggan"] = "british",
	["Al'Akir"] = "british",
	["Bladefist"] = "british",
	["Bloodscalp"] = "british",
	["BurningBlade"] = "british",
	["BurningLegion"] = "british",
	["Crushridge"] = "british",
	["Daggerspine"] = "british",
	["Deathwing"] = "british",
	["Dragonmaw"] = "british",
	["Dunemaul"] = "british",
	["ArgentDawn"] = "british",
	["Runetotem"] = "british",
	["Shadowsong"] = "british",
	["Silvermoon"] = "british",
	["Stormrage"] = "british",
	["Terenas"] = "british",
	["Thunderhorn"] = "british",
	["Turalyon"] = "british",
	["Ravencrest"] = "british",
	["ShatteredHand"] = "british",
	["Skullcrusher"] = "british",
	["Spinebreaker"] = "british",
	["Stormreaver"] = "british",
	["Stormscale"] = "british",
	["EarthenRing"] = "british",
	["Genjuros"] = "british",
	["Balnazzar"] = "british",
	["Nordrassil"] = "british",
	["Hellscream"] = "british",
	["LaughingSkull"] = "british",
	["Magtheridon"] = "british",
	["Quel'Thalas"] = "british",
	["Neptulon"] = "british",
	["TwistingNether"] = "british",
	["Ragnaros"] = "british",
	["TheMaelstrom"] = "british",
	["Sylvanas"] = "british",
	["Vashj"] = "british",
	["Bloodfeather"] = "british",
	["Darksorrow"] = "british",
	["Frostwhisper"] = "british",
	["Kor'gall"] = "british",
	["DefiasBrotherhood"] = "british",
	["TheVentureCo"] = "british",
	["Lightning'sBlade"] = "british",
	["Haomarush"] = "british",
	["Xavius"] = "british",
	["Hakkar"] = "british",
	["Khadgar"] = "british",
	["Bronzebeard"] = "british",
	["KulTiras"] = "british",
	["Chromaggus"] = "british",
	["Dentarg"] = "british",
	["Moonglade"] = "british",
	["Executus"] = "british",
	["Trollbane"] = "british",
	["Mazrigos"] = "british",
	["Talnivarr"] = "british",
	["Emeriss"] = "british",
	["Drak'thul"] = "british",
	["Ahn'Qiraj"] = "british",
	["ScarshieldLegion"] = "british",
	["SteamwheedleCartel"] = "british",
	["Vek'nilash"] = "british",
	["Boulderfist"] = "british",
	["Frostmane"] = "british",
	["Outland"] = "british",
	["GrimBatol"] = "british",
	["Jaedenar"] = "british",
	["Kazzak"] = "british",
	["TarrenMill"] = "british",
	["ChamberofAspects"] = "british",
	["Ravenholdt"] = "british",
	["Eonar"] = "british",
	["Kilrogg"] = "british",
	["AeriePeak"] = "british",
	["Wildhammer"] = "british",
	["Saurfang"] = "british",
	["DarkmoonFaire"] = "british",
	["Lightbringer"] = "british",
	["Darkspear"] = "british",
	["Alonsus"] = "british",
	["BurningSteppes"] = "british",
	["BronzeDragonflight"] = "british",
	["Anachronos"] = "british",
	["Terokkar"] = "british",
	["Blade'sEdge"] = "british",
	["Azuremyst"] = "british",
	["Hellfire"] = "british",
	["Ghostlands"] = "british",
	["Nagrand"] = "british",
	["TheSha'tar"] = "british",
	["Karazhan"] = "british",
	["Auchindoun"] = "british",
	["ShatteredHalls"] = "british",
	["Sporeggar"] = "british",
	["PyrewoodVillage"] = "british",
	["MirageRaceway"] = "british",
	["NethergardeKeep"] = "british",
	["Golemagg"] = "british",
	["Firemaw"] = "british",
	["Gehennas"] = "british",
	["HydraxianWaterlords"] = "british",
	["EU4CWOWWeb"] = "british",
	["EU5CWOWWeb"] = "british",
	["EU4CWOWGMSS1"] = "british",
	["EU4CWOWGMSS2"] = "british",
	["Mograine"] = "british",
	["Ashbringer"] = "british",
	["Earthshaker"] = "british",
	["Giantstalker"] = "british",
	["Thekal"] = "british",
	["Jin'do"] = "british",
	["EU4CWOWGMSS2"] = "british",
	["EU4CWOWGMSS1"] = "british",
	["EU4CWOWWeb"] = "british",
	["Noxxion"] = "british",
	["Dragonfang"] = "british",
	["Earthshaker"] = "british",
	["Quel'Serrar"] = "british",
	["Bloodfang"] = "british",
	["Skullflame"] = "british",
	["Ashbringer"] = "british",
	["Noggenfogger"] = "british",
	["Gandling"] = "british",
	["Mograine"] = "british",
	["ZandalarTribe"] = "british",
	["Firemaw"] = "british",
	["Golemagg"] = "british",
	["Bonescythe"] = "british",
	["Dreadnaught"] = "british",
	["EU5CWOWWeb"] = "british",
	["Kingsfall"] = "british",
	["Ironfoe"] = "british",
	["Judgement"] = "british",
	["TenStorms"] = "british",
	["Dreadmist"] = "british",
	["Flamelash"] = "british",
	["Stonespine"] = "british",
	["HydraxianWaterlords"] = "british",
	["Razorgore"] = "british",
	["Gehennas"] = "british",
	["Shazzrah"] = "british",
	["NethergardeKeep"] = "british",
	["MirageRaceway"] = "british",
	["PyrewoodVillage"] = "british",
	["Garona"] = "french",
	["Vol'jin"] = "french",
	["Arakarahm"] = "french",
	["Medivh"] = "french",
	["Sinstralis"] = "french",
	["KirinTor"] = "french",
	["Dalaran"] = "french",
	["Archimonde"] = "french",
	["Elune"] = "french",
	["Illidan"] = "french",
	["Hyjal"] = "french",
	["Kael'thas"] = "french",
	["Ner'zhul"] = "french",
	["Cho'gall"] = "french",
	["Sargeras"] = "french",
	["KhazModan"] = "french",
	["Drek'Thar"] = "french",
	["Rashgarroth"] = "french",
	["Throk'Feroth"] = "french",
	["ConseildesOmbres"] = "french",
	["Varimathras"] = "french",
	["LesSentinelles"] = "french",
	["LaCroisadeécarlate"] = "french",
	["Uldaman"] = "french",
	["Eitrigg"] = "french",
	["ConfrérieduThorium"] = "french",
	["Suramar"] = "french",
	["Krasus"] = "french",
	["Arathi"] = "french",
	["Ysondre"] = "french",
	["Eldre'Thalas"] = "french",
	["CultedelaRivenoire"] = "french",
	["Chantséternels"] = "french",
	["MarécagedeZangar"] = "french",
	["Templenoir"] = "french",
	["Naxxramas"] = "french",
	["LesClairvoyants"] = "french",
	["Auberdine"] = "french",
	["Sulfuron"] = "french",
	["Amnennar"] = "french",
	["Finkle"] = "french",
	["Sulfuron"] = "french",
	["Auberdine"] = "french",
	["Amnennar"] = "french",
	["Forscherliga"] = "german",
	["Dethecus"] = "german",
	["Durotan"] = "german",
	["Alexstrasza"] = "german",
	["Alleria"] = "german",
	["Antonidas"] = "german",
	["Baelgun"] = "german",
	["Blackhand"] = "german",
	["Gilneas"] = "german",
	["Kargath"] = "german",
	["Khaz'goroth"] = "german",
	["Lothar"] = "german",
	["Madmortem"] = "german",
	["Malfurion"] = "german",
	["Zuluhed"] = "german",
	["Nozdormu"] = "german",
	["Perenolde"] = "german",
	["DieSilberneHand"] = "german",
	["Aegwynn"] = "german",
	["Arthas"] = "german",
	["Azshara"] = "german",
	["Blackmoore"] = "german",
	["Blackrock"] = "german",
	["Destromath"] = "german",
	["Eredar"] = "german",
	["Frostmourne"] = "german",
	["Frostwolf"] = "german",
	["Gorgonnash"] = "german",
	["Gul'dan"] = "german",
	["Kel'Thuzad"] = "german",
	["Kil'jaeden"] = "german",
	["Mal'Ganis"] = "german",
	["Mannoroth"] = "german",
	["ZirkeldesCenarius"] = "german",
	["Proudmoore"] = "german",
	["Nathrezim"] = "german",
	["DunMorogh"] = "german",
	["Aman'thul"] = "german",
	["Sen'jin"] = "german",
	["Thrall"] = "german",
	["Theradras"] = "german",
	["Anub'arak"] = "german",
	["Wrathbringer"] = "german",
	["Onyxia"] = "german",
	["Nera'thor"] = "german",
	["Nefarian"] = "german",
	["KultderVerdammten"] = "german",
	["DasSyndikat"] = "german",
	["Terrordar"] = "german",
	["Krag'jin"] = "german",
	["DerRatvonDalaran"] = "german",
	["Ysera"] = "german",
	["Malygos"] = "german",
	["Rexxar"] = "german",
	["Anetheron"] = "german",
	["Nazjatar"] = "german",
	["Tichondrius"] = "german",
	["DieewigeWacht"] = "german",
	["DieTodeskrallen"] = "german",
	["DieArguswacht"] = "german",
	["Vek'lor"] = "german",
	["Mug'thol"] = "german",
	["Taerar"] = "german",
	["Dalvengyr"] = "german",
	["Rajaxx"] = "german",
	["Ulduar"] = "german",
	["Malorne"] = "german",
	["DerAbyssischeRat"] = "german",
	["DerMithrilorden"] = "german",
	["Tirion"] = "german",
	["Ambossar"] = "german",
	["DieNachtwache"] = "german",
	["Un'Goro"] = "german",
	["Garrosh"] = "german",
	["Area52"] = "german",
	["Todeswache"] = "german",
	["Arygos"] = "german",
	["Teldrassil"] = "german",
	["Norgannon"] = "german",
	["Lordaeron"] = "german",
	["Nethersturm"] = "german",
	["Shattrath"] = "german",
	["FestungderStürme"] = "german",
	["Echsenkessel"] = "german",
	["Blutkessel"] = "german",
	["DieAldor"] = "german",
	["DasKonsortium"] = "german",
	["Everlook"] = "german",
	["Lakeshire"] = "german",
	["Razorfen"] = "german",
	["Patchwerk"] = "german",
	["Venoxis"] = "german",
	["Transcendence"] = "german",
	["Transcendence"] = "german",
	["Patchwerk"] = "german",
	["Lucifron"] = "german",
	["Lakeshire"] = "german",
	["Everlook"] = "german",
	["Heartstriker"] = "german",
	["Celebras"] = "german",
	["Dragon'sCall"] = "german",
	["Venoxis"] = "german",
	["Razorfen"] = "german",
	["Pozzodell'Eternità"] = "italian",
	["Nemesis"] = "italian",
	["DunModr"] = "spanish",
	["Zul'jin"] = "spanish",
	["Uldum"] = "spanish",
	["C'Thun"] = "spanish",
	["Sanguino"] = "spanish",
	["Shen'dralar"] = "spanish",
	["Tyrande"] = "spanish",
	["Exodar"] = "spanish",
	["Minahonda"] = "spanish",
	["LosErrantes"] = "spanish",
	["ColinasPardas"] = "spanish",
	["Mandokir"] = "spanish",
	["Mandokir"] = "spanish",
	["Aggra(Português)"] = "portuguese",
	["Гордунни"] = "russian",
	["Корольлич"] = "russian",
	["СвежевательДуш"] = "russian",
	["СтражСмерти"] = "russian",
	["Подземье"] = "russian",
	["Седогрив"] = "russian",
	["Галакронд"] = "russian",
	["Ревущийфьорд"] = "russian",
	["Разувий"] = "russian",
	["ТкачСмерти"] = "russian",
	["Дракономор"] = "russian",
	["Борейскаятундра"] = "russian",
	["Азурегос"] = "russian",
	["Ясеневыйлес"] = "russian",
	["ПиратскаяБухта"] = "russian",
	["ВечнаяПесня"] = "russian",
	["Термоштепсель"] = "russian",
	["Гром"] = "russian",
	["Голдринн"] = "russian",
	["ЧерныйШрам"] = "russian",
	["Хроми"] = "russian",
	["Пламегор"] = "russian",
	["ВестникРока(RU)"] = "russian",
	["Кровавыйзов"] = "russian",
	["РокДелар(RU)"] = "russian",
	["Змейталак(RU)"] = "russian",
	["Пламегор(RU)"] = "russian",
	["Хроми(RU)"] = "russian",
}

local REGION_REALMS_US = {
    ["Lightbringer"] = "american",
	["Cenarius"] = "american",
	["Uther"] = "american",
	["Kilrogg"] = "american",
	["Proudmoore"] = "american",
	["Hyjal"] = "american",
	["Frostwolf"] = "american",
	["Ner'zhul"] = "american",
	["Kil'jaeden"] = "american",
	["Blackrock"] = "american",
	["Tichondrius"] = "american",
	["SilverHand"] = "american",
	["Doomhammer"] = "american",
	["Icecrown"] = "american",
	["Deathwing"] = "american",
	["Kel'Thuzad"] = "american",
	["Eitrigg"] = "american",
	["Garona"] = "american",
	["Alleria"] = "american",
	["Hellscream"] = "american",
	["Blackhand"] = "american",
	["Whisperwind"] = "american",
	["Archimonde"] = "american",
	["Illidan"] = "american",
	["Stormreaver"] = "american",
	["Mal'Ganis"] = "american",
	["Stormrage"] = "american",
	["Zul'jin"] = "american",
	["Medivh"] = "american",
	["Durotan"] = "american",
	["Bloodhoof"] = "american",
	["Khadgar"] = "american",
	["Dalaran"] = "american",
	["Elune"] = "american",
	["Lothar"] = "american",
	["Arthas"] = "american",
	["Mannoroth"] = "american",
	["Warsong"] = "american",
	["ShatteredHand"] = "american",
	["BleedingHollow"] = "american",
	["Skullcrusher"] = "american",
	["ArgentDawn"] = "american",
	["Sargeras"] = "american",
	["Azgalor"] = "american",
	["Magtheridon"] = "american",
	["Destromath"] = "american",
	["Gorgonnash"] = "american",
	["Dethecus"] = "american",
	["Spinebreaker"] = "american",
	["Bonechewer"] = "american",
	["Dragonmaw"] = "american",
	["Shadowsong"] = "american",
	["Silvermoon"] = "american",
	["Windrunner"] = "american",
	["CenarionCircle"] = "american",
	["Nathrezim"] = "american",
	["Terenas"] = "american",
	["BurningBlade"] = "american",
	["Gorefiend"] = "american",
	["Eredar"] = "american",
	["Shadowmoon"] = "american",
	["Lightning'sBlade"] = "american",
	["Eonar"] = "american",
	["Gilneas"] = "american",
	["Kargath"] = "american",
	["Llane"] = "american",
	["EarthenRing"] = "american",
	["LaughingSkull"] = "american",
	["BurningLegion"] = "american",
	["Thunderlord"] = "american",
	["Malygos"] = "american",
	["Thunderhorn"] = "american",
	["Aggramar"] = "american",
	["Crushridge"] = "american",
	["Stonemaul"] = "american",
	["Daggerspine"] = "american",
	["Stormscale"] = "american",
	["Dunemaul"] = "american",
	["Boulderfist"] = "american",
	["Suramar"] = "american",
	["Dragonblight"] = "american",
	["Draenor"] = "american",
	["Uldum"] = "american",
	["Bronzebeard"] = "american",
	["Feathermoon"] = "american",
	["Bloodscalp"] = "american",
	["Darkspear"] = "american",
	["AzjolNerub"] = "american",
	["Perenolde"] = "american",
	["Eldre'Thalas"] = "american",
	["Spirestone"] = "american",
	["ShadowCouncil"] = "american",
	["ScarletCrusade"] = "american",
	["Firetree"] = "american",
	["Frostmane"] = "american",
	["Gurubashi"] = "american",
	["Smolderthorn"] = "american",
	["Skywall"] = "american",
	["Runetotem"] = "american",
	["Moonrunner"] = "american",
	["Detheroc"] = "american",
	["Kalecgos"] = "american",
	["Ursin"] = "american",
	["DarkIron"] = "american",
	["Greymane"] = "american",
	["Wildhammer"] = "american",
	["Staghelm"] = "american",
	["EmeraldDream"] = "american",
	["Maelstrom"] = "american",
	["TwistingNether"] = "american",
	["Cho'gall"] = "american",
	["Gul'dan"] = "american",
	["Kael'thas"] = "american",
	["Alexstrasza"] = "american",
	["KirinTor"] = "american",
	["Ravencrest"] = "american",
	["Balnazzar"] = "american",
	["Azshara"] = "american",
	["Agamaggan"] = "american",
	["Lightninghoof"] = "american",
	["Nazjatar"] = "american",
	["Malfurion"] = "american",
	["Aegwynn"] = "american",
	["Akama"] = "american",
	["Chromaggus"] = "american",
	["Draka"] = "american",
	["Drak'thul"] = "american",
	["Garithos"] = "american",
	["Hakkar"] = "american",
	["KhazModan"] = "american",
	["Mug'thol"] = "american",
	["Korgath"] = "american",
	["KulTiras"] = "american",
	["Malorne"] = "american",
	["Rexxar"] = "american",
	["ThoriumBrotherhood"] = "american",
	["Arathor"] = "american",
	["Madoran"] = "american",
	["Trollbane"] = "american",
	["Muradin"] = "american",
	["Vek'nilash"] = "american",
	["Sen'jin"] = "american",
	["Baelgun"] = "american",
	["Duskwood"] = "american",
	["Zuluhed"] = "american",
	["SteamwheedleCartel"] = "american",
	["Norgannon"] = "american",
	["Thrall"] = "american",
	["Anetheron"] = "american",
	["Turalyon"] = "american",
	["Haomarush"] = "american",
	["Scilla"] = "american",
	["Ysondre"] = "american",
	["Ysera"] = "american",
	["Dentarg"] = "american",
	["Andorhal"] = "american",
	["Executus"] = "american",
	["Dalvengyr"] = "american",
	["BlackDragonflight"] = "american",
	["AltarofStorms"] = "american",
	["Uldaman"] = "american",
	["AeriePeak"] = "american",
	["Onyxia"] = "american",
	["DemonSoul"] = "american",
	["Gnomeregan"] = "american",
	["Anvilmar"] = "american",
	["TheVentureCo"] = "american",
	["Sentinels"] = "american",
	["Jaedenar"] = "american",
	["Tanaris"] = "american",
	["AlteracMountains"] = "american",
	["Undermine"] = "american",
	["Lethon"] = "american",
	["BlackwingLair"] = "american",
	["Arygos"] = "american",
	["EchoIsles"] = "american",
	["TheForgottenCoast"] = "american",
	["Fenris"] = "american",
	["Anub'arak"] = "american",
	["BlackwaterRaiders"] = "american",
	["Vashj"] = "american",
	["Korialstrasz"] = "american",
	["Misha"] = "american",
	["Darrowmere"] = "american",
	["Ravenholdt"] = "american",
	["Bladefist"] = "american",
	["Shu'halo"] = "american",
	["Winterhoof"] = "american",
	["SistersofElune"] = "american",
	["Maiev"] = "american",
	["Rivendare"] = "american",
	["Nordrassil"] = "american",
	["Tortheldrin"] = "american",
	["Cairne"] = "american",
	["Drak'Tharon"] = "american",
	["Antonidas"] = "american",
	["Shandris"] = "american",
	["MoonGuard"] = "american",
	["Nazgrel"] = "american",
	["Hydraxis"] = "american",
	["WyrmrestAccord"] = "american",
	["Farstriders"] = "american",
	["BoreanTundra"] = "american",
	["Quel'dorei"] = "american",
	["Garrosh"] = "american",
	["Mok'Nathal"] = "american",
	["Nesingwary"] = "american",
	["Drenden"] = "american",
	["Azuremyst"] = "american",
	["Auchindoun"] = "american",
	["Coilfang"] = "american",
	["ShatteredHalls"] = "american",
	["BloodFurnace"] = "american",
	["TheUnderbog"] = "american",
	["Terokkar"] = "american",
	["Blade'sEdge"] = "american",
	["Exodar"] = "american",
	["Area52"] = "american",
	["Velen"] = "american",
	["TheScryers"] = "american",
	["Zangarmarsh"] = "american",
	["Fizzcrank"] = "american",
	["Ghostlands"] = "american",
	["GrizzlyHills"] = "american",
	["Galakrond"] = "american",
	["Dawnbringer"] = "american",
	["Skyfury"] = "american",
	["Maladath"] = "american",
	["Angerforge"] = "american",
	["Eranikus"] = "american",
	["Herod"] = "american",
	["Whitemane"] = "american",
	["Westfall"] = "american",
	["Azuresong"] = "american",
	["Ashkandi"] = "american",
	["Nightfall"] = "american",
	["ArcaniteReaper"] = "american",
	["Anathema"] = "american",
	["Thunderfury"] = "american",
	["ObsidianEdge"] = "american",
	["Mutanus"] = "american",
	["Smolderweb"] = "american",
	["Rattlegore"] = "american",
	["Grobbulus"] = "american",
	["Kurinnaxx"] = "american",
	["Bigglesworth"] = "american",
	["Blaumeux"] = "american",
	["Fairbanks"] = "american",
	["OldBlanchy"] = "american",
	["Myzrael"] = "american",
	["Atiesh"] = "american",
	["Shadowstrike"] = "american",
	["JomGabbar"] = "american",
	["Heartseeker"] = "american",
	["Earthfury"] = "american",
	["BarmanShanker"] = "american",
	["Netherwind"] = "american",
	["Benediction"] = "american",
	["Windseeker"] = "american",
	["Sulfuras"] = "american",
	["Kirtonos"] = "american",
	["Kromcrush"] = "american",
	["Incendius"] = "american",
	["BloodsailBuccaneers"] = "american",
	["Skeram"] = "american",
	["Stalagg"] = "american",
	["Faerlina"] = "american",
	["Thalnos"] = "american",
	["DeviateDelight"] = "american",
	["Pagle"] = "american",
	["Mankrik"] = "american",
	["US2CWOWWeb"] = "american",
	["US1CWOWGMSS1"] = "american",
	["US1CWOWWeb"] = "american",
	["US1CWOWGMSS2"] = "american",
	["Drakkari"] = "mexican",
	["Ragnaros"] = "mexican",
	["Quel'Thalas"] = "mexican",
	["Loatheb"] = "mexican",
    
	["Goldrinn"] = "brazilian",
	["Nemesis"] = "brazilian",
	["Azralon"] = "brazilian",
	["TolBarad"] = "brazilian",
	["Gallywix"] = "brazilian",
	["Sul'thraze"] = "brazilian",
	["Caelestrasz"] = "oceanic",
	["Aman'Thul"] = "oceanic",
	["Barthilas"] = "oceanic",
	["Thaurissan"] = "oceanic",
	["Frostmourne"] = "oceanic",
	["Khaz'goroth"] = "oceanic",
	["Dreadmaul"] = "oceanic",
	["Nagrand"] = "oceanic",
	["Dath'Remar"] = "oceanic",
	["Jubei'Thos"] = "oceanic",
	["Gundrak"] = "oceanic",
	["Saurfang"] = "oceanic",
	["Lionheart(AU)"] = "oceanic",
	["Felstriker"] = "oceanic",
	["Yojamba"] = "oceanic",
	["Arugal"] = "oceanic",
	["SwampofSorrows(AU)"] = "oceanic",
	["Remulos"] = "oceanic",
}

local REGION_REALMS_KR = {
	["아즈샤라"] = "korean",

	["줄진"] = "korean",
	["가로나"] = "korean",
	["굴단"] = "korean",
	["세나리우스"] = "korean",
	["노르간논"] = "korean",
	["달라란"] = "korean",
	["말퓨리온"] = "korean",
	["헬스크림"] = "korean",
	["하이잘"] = "korean",

	["윈드러너"] = "korean",
	["렉사르"] = "korean",
	["와일드해머"] = "korean",
	["데스윙"] = "korean",
	["알렉스트라자"] = "korean",

	["듀로탄"] = "korean",
	["불타는군단"] = "korean",
	["스톰레이지"] = "korean",
}

GFIO.LANGUAGES = {
    ["british"] = "ENG",
    ["french"] = "FR",
    ["german"] = "GER",
    ["spanish"] = "ES",
    ["italian"] = "IT",
    ["portuguese"] = "PT",
    ["russian"] = "RU",
    ["american"] = "US",
    ["mexican"] = "MX",
    ["brazilian"] = "BR",
    ["oceanic"] = "OCE",
	["korean"] = "KR",
}
setmetatable(GFIO.LANGUAGES, {
    __index = function(_, key)
        error(string.format("attempted to access invalid language: %s", tostring(key)), 2);
    end,
})
GFIO.REALMS = {}
if GetCurrentRegion() == 3 then
    GFIO.REALMS = REGION_REALMS_EU
elseif GetCurrentRegion() == 1 then
    GFIO.REALMS = REGION_REALMS_US
elseif GetCurrentRegion() == 2 then
    GFIO.REALMS = REGION_REALMS_KR
end
setmetatable(GFIO.REALMS, {
    __index = function(_, key)
        error(string.format("attempted to access invalid realm: %s", tostring(key)), 2);
    end,
})