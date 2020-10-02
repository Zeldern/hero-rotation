--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- HeroDBC
local DBC = HeroDBC.DBC
-- HeroLib
local HL         = HeroLib
local Cache      = HeroCache
local Unit       = HL.Unit
local Player     = Unit.Player
local Target     = Unit.Target
local Pet        = Unit.Pet
local Spell      = HL.Spell
local MultiSpell = HL.MultiSpell
local Item       = HL.Item
-- HeroRotation
local HR         = HeroRotation

-- Azerite Essence Setup
local AE         = DBC.AzeriteEssences
local AESpellIDs = DBC.AzeriteEssenceSpellIDs

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
if not Spell.Priest then Spell.Priest = {} end
Spell.Priest.Shadow = {
  -- Azerite Traits
  WhispersoftheDamned                   = Spell(275722),
  SearingDialogue                       = Spell(272788),
  DeathThroes                           = Spell(278659),
  ThoughtHarvester                      = Spell(288340),
  SpitefulApparitions                   = Spell(277682),
  HarvestedThoughtsBuff                 = Spell(288343),
  ChorusofInsanity                      = Spell(278661),

  -- Base Spells
  Shadowform                            = Spell(232698),
  ShadowformBuff                        = Spell(232698),
  MindBlast                             = Spell(8092),
  VampiricTouch                         = Spell(34914),
  VampiricTouchDebuff                   = Spell(34914),
  VoidEruption                          = Spell(228260),
  VoidformBuff                          = Spell(194249),
  MindSear                              = Spell(48045),
  DarkThoughtsBuff                      = Spell(341207),
  VoidBolt                              = Spell(205448),
  ShadowWordDeath                       = Spell(32379),
  ShadowWordPain                        = Spell(589),
  ShadowWordPainDebuff                  = Spell(589),
  Mindbender                            = MultiSpell(200174,34433),
  MindFlay                              = Spell(15407),
  Silence                               = Spell(15487),
  PowerInfusion                         = Spell(10060),
  DevouringPlague                       = Spell(335467),
  DevouringPlagueDebuff                 = Spell(335467),
  Dispersion                            = Spell(47585),

  -- Talents
  SurrenderToMadness                    = Spell(319952),
  ShadowCrash                           = Spell(205385),
  Misery                                = Spell(238558),
  VoidTorrent                           = Spell(263165),
  HungeringVoid                         = Spell(345218),
  FortressOfTheMind                     = Spell(193195),
  Damnation                             = Spell(341374),
  UnfurlingDarknessBuff                 = Spell(341282),
  SearingNightmare                      = Spell(341385),
  PsychicLink                           = Spell(199484),

  -- Covenant Abilities
  AscendedBlast                         = Spell(325283),
  AscendedNova                          = Spell(325020),
  BoonoftheAscended                     = Spell(325013),
  BoonoftheAscendedBuff                 = Spell(325013),
  FaeGuardians                          = Spell(327661),
  FaeGuardiansBuff                      = Spell(327661),
  WrathfulFaerieDebuff                  = Spell(342132),
  Mindgames                             = Spell(323673),
  UnholyNova                            = Spell(324724),

  -- Conduit Effects
  DissonantEchoesBuff                   = Spell(343144),

  -- Racials
  Berserking                            = Spell(26297),
  LightsJudgment                        = Spell(255647),
  Fireblood                             = Spell(265221),
  AncestralCall                         = Spell(274738),
  BagofTricks                           = Spell(312411),
  ArcaneTorrent                         = Spell(50613),

  -- Essences
  BloodoftheEnemy                       = Spell(297108),
  MemoryofLucidDreams                   = Spell(298357),
  PurifyingBlast                        = Spell(295337),
  RippleInSpace                         = Spell(302731),
  ConcentratedFlame                     = Spell(295373),
  TheUnboundForce                       = Spell(298452),
  WorldveinResonance                    = Spell(295186),
  FocusedAzeriteBeam                    = Spell(295258),
  GuardianofAzeroth                     = Spell(295840),
  ReapingFlames                         = Spell(310690),
  LifebloodBuff                         = MultiSpell(295137, 305694),
  RecklessForceBuff                     = Spell(302932),
  ConcentratedFlameBurn                 = Spell(295368)
}
local S = Spell.Priest.Shadow

-- Items
if not Item.Priest then Item.Priest = {} end
Item.Priest.Shadow = {
  PotionofDeathlyFixation          = Item(171351),
  AzsharasFontofPower              = Item(169314, {13, 14}),
  PainbreakerPsalmChest            = Item(173241),
  PainbreakerPsalmCloak            = Item(173242),
  CalltotheVoidGloves              = Item(173244),
  CalltotheVoidWrists              = Item(173249),
  ShadowflamePrismGloves           = Item(173244),
  ShadowflamePrismHelm             = Item(173245),
}
local I = Item.Priest.Shadow

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
  I.AzsharasFontofPower:ID()
}

-- Rotation Var
local ShouldReturn -- Used to get the return string
local Enemies8y, Enemies15y, Enemies40y
local EnemiesCount10
local PetActiveCD

-- GUI Settings
local Everyone = HR.Commons.Everyone
local Settings = {
  General = HR.GUISettings.General,
  Commons = HR.GUISettings.APL.Priest.Commons,
  Shadow = HR.GUISettings.APL.Priest.Shadow
}

-- Variables
local VarDotsUp = false
local VarAllDotsUp = false
local VarMindSearCutoff = 1
local VarSearingNightmareCutoff = false
local PainbreakerEquipped = (I.PainbreakerPsalmChest:IsEquipped() or I.PainbreakerPsalmCloak:IsEquipped())
local ShadowflamePrismEquipped = (I.ShadowflamePrismGloves:IsEquipped() or I.ShadowflamePrismHelm:IsEquipped())
--local CalltotheVoidEquipped = (I.CalltotheVoidGloves:IsEquipped() or I.CalltotheVoidWrists:IsEquipped())

HL:RegisterForEvent(function()
  VarDotsUp = false
  VarAllDotsUp = false
  VarMindSearCutoff = 1
  VarSearingNightmareCutoff = false
end, "PLAYER_REGEN_ENABLED")

HL:RegisterForEvent(function()
  S.ShadowCrash:RegisterInFlight()
end, "LEARNED_SPELL_IN_TAB")
S.ShadowCrash:RegisterInFlight()

local function num(val)
  if val then return 1 else return 0 end
end

local function bool(val)
  return val ~= 0
end

local function DotsUp(tar, all)
  if all then
    return (tar:DebuffUp(S.ShadowWordPainDebuff) and tar:DebuffUp(S.VampiricTouchDebuff) and tar:DebuffUp(S.DevouringPlagueDebuff))
  else
    return (tar:DebuffUp(S.ShadowWordPainDebuff) and tar:DebuffUp(S.VampiricTouchDebuff))
  end
end

local function EvaluateCycleDamnation200(TargetUnit)
  return (not VarAllDotsUp)
end

local function EvaluateCycleDevouringPlage202(TargetUnit)
  -- Added player level check, as Power Infusion isn't learned until 58
  return ((TargetUnit:DebuffRefreshable(S.DevouringPlagueDebuff) or Player:Insanity() > 75) and (Player:Level() < 58 or not S.PowerInfusion:CooldownUp()) and (not S.SearingNightmare:IsAvailable() or (S.SearingNightmare:IsAvailable() and not VarSearingNightmareCutoff)) and (not S.HungeringVoid:IsAvailable() or (S.HungeringVoid:IsAvailable() and not Player:BuffUp(S.VoidformBuff))))
end

local function EvaluateCycleShadowWordDeath204(TargetUnit)
  if S.Mindbender:ID() == 34433 then
    PetActiveCD = 170
  else
    PetActiveCD = 45
  end
  return (TargetUnit:HealthPercentage() < 20 or (S.Mindbender:CooldownRemains() > PetActiveCD and ShadowflamePrismEquipped))
end

local function EvaluateCycleSurrenderToMadness206(TargetUnit)
  return (TargetUnit:TimeToDie() < 25 and Player:BuffDown(S.VoidformBuff))
end

local function EvaluateCycleVoidTorrent208(TargetUnit)
  return (VarAllDotsUp and Player:BuffDown(S.VoidformBuff) and TargetUnit:TimeToDie() > 4)
end

local function EvaluateCycleMindSear210(TargetUnit)
  return (EnemiesCount10 > VarMindSearCutoff and Player:BuffUp(S.DarkThoughtsBuff))
end

local function EvaluateCycleVampiricTouch214(TargetUnit)
  return (TargetUnit:DebuffRefreshable(S.VampiricTouchDebuff) and TargetUnit:TimeToDie() > 6 or (S.Misery:IsAvailable() and TargetUnit:DebuffRefreshable(S.ShadowWordPainDebuff)) or Player:BuffUp(S.UnfurlingDarknessBuff))
end

local function EvaluateCycleMindSear216(TargetUnit)
  return (EnemiesCount10 > VarMindSearCutoff)
end

local function EvaluateCycleSearingNightmare218(TargetUnit)
  -- Added player level check, as Power Infusion isn't learned until 58
  return ((VarSearingNightmareCutoff and (Player:Level() < 58 or not S.PowerInfusion:CooldownUp())) or (TargetUnit:DebuffRefreshable(S.ShadowWordPainDebuff) and EnemiesCount10 > 1))
end

local function EvaluateCycleShadowWordPain220(TargetUnit)
  return (TargetUnit:DebuffRefreshable(S.ShadowWordPainDebuff) and Target:TimeToDie() > 4 and (not S.PsychicLink:IsAvailable() or (S.PsychicLink:IsAvailable() and EnemiesCount10 <= 2)))
end

local function EvaluateCycleMindSear222(TargetUnit)
  return (S.SearingNightmare:IsAvailable() and EnemiesCount10 > (VarMindSearCutoff + 1) and TargetUnit:DebuffDown(S.ShadowWordPainDebuff) and not S.Mindbender:CooldownUp())
end

local function EvaluateCycleMindSear224(TargetUnit)
  return (S.SearingNightmare:IsAvailable() and TargetUnit:DebuffRefreshable(S.ShadowWordPainDebuff) and EnemiesCount10 > 2)
end

local function Precombat()
  -- Update Painbreaker Psalm equip status; this is in Precombat, as equipment can't be changed once in combat
  PainbreakerEquipped = (I.PainbreakerPsalmChest:IsEquipped() or I.PainbreakerPsalmCloak:IsEquipped())
  -- Update Call to the Void equip status; this is in Precombat, as equipment can't be changed once in combat
  --CalltotheVoidEquipped = (I.CalltotheVoidGloves:IsEquipped() or I.CalltotheVoidWrists:IsEquipped())
  -- flask
  -- food
  -- augmentation
  -- snapshot_stats
  if Everyone.TargetIsValid() then
    -- potion
    if I.PotionofDeathlyFixation:IsReady() and Settings.Commons.UsePotions then
      if HR.CastSuggested(I.PotionofDeathlyFixation) then return "potion_of_spectral_intellect 2"; end
    end
    -- shadowform,if=!buff.shadowform.up
    if S.Shadowform:IsCastable() and (Player:BuffDown(S.ShadowformBuff)) then
      if HR.Cast(S.Shadowform, Settings.Shadow.GCDasOffGCD.Shadowform) then return "shadowform 4"; end
    end
    -- arcane_torrent
    if S.ArcaneTorrent:IsCastable() then
      if HR.Cast(S.ArcaneTorrent, nil, nil, not Target:IsSpellInRange(S.ArcaneTorrent)) then return "arcane_torrent 6"; end
    end
    -- use_item,name=azsharas_font_of_power
    if I.AzsharasFontofPower:IsEquipped() and I.AzsharasFontofPower:IsReady() and Settings.Commons.UseTrinkets then
      if HR.Cast(I.AzsharasFontofPower, nil, Settings.Commons.TrinketDisplayStyle) then return "azsharas_font_of_power 8"; end
    end
    -- variable,name=mind_sear_cutoff,op=set,value=1
    VarMindSearCutoff = 1
    -- mind_blast
    if S.MindBlast:IsReady() and not Player:IsCasting(S.MindBlast) then
      if HR.Cast(S.MindBlast, nil, nil, not Target:IsSpellInRange(S.MindBlast)) then return "mind_blast 10"; end
    end
  end
end

local function Essences()
  -- memory_of_lucid_dreams
  if S.MemoryofLucidDreams:IsCastable() then
    if HR.Cast(S.MemoryofLucidDreams, nil, Settings.Commons.EssenceDisplayStyle) then return "memory_of_lucid_dreams essences"; end
  end
  -- blood_of_the_enemy
  if S.BloodoftheEnemy:IsCastable() then
    if HR.Cast(S.BloodoftheEnemy, nil, Settings.Commons.EssenceDisplayStyle, nil, nil, not Target:IsSpellInRange(S.BloodoftheEnemy)) then return "blood_of_the_enemy essences"; end
  end
  -- guardian_of_azeroth
  if S.GuardianofAzeroth:IsCastable() then
    if HR.Cast(S.GuardianofAzeroth, nil, Settings.Commons.EssenceDisplayStyle) then return "guardian_of_azeroth essences"; end
  end
  -- focused_azerite_beam,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
  if S.FocusedAzeriteBeam:IsCastable() and (EnemiesCount10 >= 2 or Settings.Shadow.UseFABST) then
    if HR.Cast(S.FocusedAzeriteBeam, nil, Settings.Commons.EssenceDisplayStyle) then return "focused_azerite_beam essences"; end
  end
  -- purifying_blast,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
  if S.PurifyingBlast:IsCastable() and (EnemiesCount10 >= 2) then
    if HR.Cast(S.PurifyingBlast, nil, Settings.Commons.EssenceDisplayStyle, not Target:IsInRange(40)) then return "purifying_blast essences"; end
  end
  -- concentrated_flame,line_cd=6,if=time<=10|full_recharge_time<gcd|target.time_to_die<5
  if S.ConcentratedFlame:IsCastable() and (HL.CombatTime() <= 10 or S.ConcentratedFlame:FullRechargeTime() < Player:GCD() or Target:TimeToDie() < 5) then
    if HR.Cast(S.ConcentratedFlame, nil, Settings.Commons.EssenceDisplayStyle, not Target:IsSpellInRange(S.ConcentratedFlame)) then return "concentrated_flame essences"; end
  end
  -- ripple_in_space
  if S.RippleInSpace:IsCastable() then
    if HR.Cast(S.RippleInSpace, nil, Settings.Commons.EssenceDisplayStyle) then return "ripple_in_space essences"; end
  end
  -- reaping_flames
  if (true) then
    local ShouldReturn = Everyone.ReapingFlamesCast(Settings.Commons.EssenceDisplayStyle); if ShouldReturn then return ShouldReturn; end
  end
  -- worldvein_resonance
  if S.WorldveinResonance:IsCastable() then
    if HR.Cast(S.WorldveinResonance, nil, Settings.Commons.EssenceDisplayStyle) then return "worldvein_resonance essences"; end
  end
  -- the_unbound_force
  if S.TheUnboundForce:IsCastable() then
    if HR.Cast(S.TheUnboundForce, nil, Settings.Commons.EssenceDisplayStyle) then return "the_unbound_force essences"; end
  end
end

local function Cds()
  -- power_infusion,if=buff.voidform.up
  -- Added player level check, as Power Infusion isn't learned until 58.
  if Player:Level() >= 58 and S.PowerInfusion:IsCastable() and (Player:BuffUp(S.VoidformBuff)) then
    if HR.Cast(S.PowerInfusion) then return "power_infusion 50"; end
  end
  -- Covenant: fae_guardians
  if S.FaeGuardians:IsReady() then
    if HR.Cast(S.FaeGuardians, Settings.Commons.CovenantDisplayStyle) then return "fae_guardians 52"; end
  end
  -- Covenant: mindgames,if=insanity<90&(variable.all_dots_up|buff.voidform.up)
  if S.Mindgames:IsReady() and (Player:Insanity() < 90 and (VarAllDotsUp or Player:BuffUp(S.VoidformBuff))) then
    if HR.Cast(S.Mindgames, Settings.Commons.CovenantDisplayStyle, nil, not Target:IsSpellInRange(S.Mindgames)) then return "mindgames 54"; end
  end
  -- Covenant: unholy_nova,if=raid_event.adds.in>50
  if S.UnholyNova:IsReady() and (#Enemies15y > 0) then
    if HR.Cast(S.UnholyNova, Settings.Commons.CovenantDisplayStyle, nil, not Target:IsInRange(15)) then return "unholy_nova 56"; end
  end
  -- Covenant: boon_of_the_ascended,if=!buff.voidform.up&!cooldown.void_eruption.up&spell_targets.mind_sear>1&!talent.searing_nightmare.enabled|(buff.voidform.up&spell_targets.mind_sear<2&!talent.searing_nightmare.enabled)|(buff.voidform.up&talent.searing_nightmare.enabled)
  if S.BoonoftheAscended:IsReady() and (Player:BuffDown(S.VoidformBuff) and not S.VoidEruption:CooldownUp() and EnemiesCount10 > 1 and not S.SearingNightmare:IsAvailable() or (Player:BuffUp(S.VoidformBuff) and EnemiesCount10 < 2 and not S.SearingNightmare:IsAvailable()) or (Player:BuffUp(S.VoidformBuff) and S.SearingNightmare:IsAvailable())) then
    if HR.Cast(S.BoonoftheAscended, Settings.Commons.CovenantDisplayStyle) then return "boon_of_the_ascended 58"; end
  end
  -- call_action_list,name=essences
  if (true) then
    local ShouldReturn = Essences(); if ShouldReturn then return ShouldReturn; end
  end
  -- use_items
  local TrinketToUse = HL.UseTrinkets(OnUseExcludes)
  if TrinketToUse then
    if HR.Cast(TrinketToUse, nil, Settings.Commons.TrinketDisplayStyle) then return "Generic use_items for " .. TrinketToUse:Name(); end
  end
end

local function Boon()
  -- ascended_blast,if=spell_targets.mind_sear<=3
  if S.AscendedBlast:IsReady() and (EnemiesCount10 <= 3) then
    if HR.Cast(S.AscendedBlast, Settings.Commons.CovenantDisplayStyle, nil, not Target:IsSpellInRange(S.AscendedBlast)) then return "ascended_blast 70"; end
  end
  -- ascended_nova,if=(spell_targets.mind_sear>2&talent.searing_nightmare.enabled|(spell_targets.mind_sear>1&!talent.searing_nightmare.enabled))&spell_targets.ascended_nova>1
  if S.AscendedNova:IsReady() then
    local EnemiesCount8 = #Enemies8y
    if ((EnemiesCount8 > 2 and S.SearingNightmare:IsAvailable() or (EnemiesCount8 > 1 and not S.SearingNightmare:IsAvailable())) and EnemiesCount8 > 1) then
      if HR.Cast(S.AscendedNova, Settings.Commons.CovenantDisplayStyle, nil, not Target:IsInRange(8)) then return "ascended_nova 72"; end
    end
  end
end

local function Cwc()
  -- searing_nightmare,use_while_casting=1,target_if=(variable.searing_nightmare_cutoff&!cooldown.power_infusion.up)|(dot.shadow_word_pain.refreshable&spell_targets.mind_sear>1)
  if S.SearingNightmare:IsReady() and Player:IsChanneling(S.MindSear) then
    if Everyone.CastCycle(S.SearingNightmare, Enemies40y, EvaluateCycleSearingNightmare218, not Target:IsSpellInRange(S.SearingNightmare)) then return "searing_nightmare 80"; end
  end
  -- searing_nightmare,use_while_casting=1,target_if=talent.searing_nightmare.enabled&dot.shadow_word_pain.refreshable&spell_targets.mind_sear>2
  if S.SearingNightmare:IsReady() and Player:IsChanneling(S.MindSear) then
    if Everyone.CastCycle(S.SearingNightmare, Enemies40y, EvaluateCycleMindSear224, not Target:IsSpellInRange(S.SearingNightmare)) then return "searing_nightmare 82"; end
  end
  -- mind_blast,only_cwc=1
  if S.MindBlast:IsCastable() and ((Player:IsChanneling(S.MindFlay) or Player:IsChanneling(S.MindSear)) and Player:BuffUp(S.DarkThoughtsBuff)) then
    if HR.Cast(S.MindBlast, nil, nil, not Target:IsSpellInRange(S.MindBlast)) then return "mind_blast 84"; end
  end
end

local function Main()
  -- call_action_list,name=boon,if=buff.boon_of_the_ascended.up
  if (Player:BuffUp(S.BoonoftheAscendedBuff)) then
    local ShouldReturn = Boon(); if ShouldReturn then return ShouldReturn; end
  end
  -- Manually added: Cast free Void Bolt
  if S.VoidBolt:CooldownUp() and (Player:BuffUp(S.DissonantEchoesBuff)) then
    if HR.Cast(S.VoidBolt, nil, nil, not Target:IsSpellInRange(S.VoidBolt)) then return "void_bolt 90"; end
  end
  -- void_eruption,if=if=cooldown.power_infusion.up&insanity>=40&(!talent.legacy_of_the_void.enabled|(talent.legacy_of_the_void.enabled&dot.devouring_plague.ticking))
  -- Added player level check, as Power Infusion isn't learned until 58
  if S.VoidEruption:IsReady() and ((Player:Level() < 58 or S.PowerInfusion:CooldownUp()) and Player:Insanity() >= 40 and (not S.HungeringVoid:IsAvailable() or (S.HungeringVoid:IsAvailable() and Target:DebuffUp(S.DevouringPlagueDebuff)))) then
    if HR.Cast(S.VoidEruption, Settings.Shadow.GCDasOffGCD.VoidEruption, nil, not Target:IsSpellInRange(S.VoidEruption)) then return "void_eruption 92"; end
  end
  -- shadow_word_pain,if=buff.fae_guardians.up&!debuff.wrathful_faerie.up
  if S.ShadowWordPain:IsCastable() and (Player:BuffUp(S.FaeGuardiansBuff) and Target:DebuffDown(S.WrathfulFaerieDebuff)) then
    if S.Misery:IsAvailable() then
      if HR.Cast(S.VampiricTouch, nil, nil, not Target:IsSpellInRange(S.VampiricTouch)) then return "vampiric_touch 94"; end
    else
      if HR.Cast(S.ShadowWordPain, nil, nil, not Target:IsSpellInRange(S.ShadowWordPain)) then return "shadow_word_pain 94"; end
    end
  end
  -- void_bolt,if=!dot.devouring_plague.refreshable
  if S.VoidBolt:IsReady() and (not Target:DebuffRefreshable(S.DevouringPlagueDebuff)) then
    if HR.Cast(S.VoidBolt, nil, nil, not Target:IsSpellInRange(S.VoidBolt)) then return "void_bolt 96"; end
  end
  -- call_action_list,name=cds
  if (HR.CDsON()) then
    local ShouldReturn = Cds(); if ShouldReturn then return ShouldReturn; end
  end
  -- mind_sear,target_if=talent.searing_nightmare.enabled&spell_targets.mind_sear>(variable.mind_sear_cutoff+1)&!dot.shadow_word_pain.ticking&!cooldown.mindbender.up
  if S.MindSear:IsCastable() then
    if Everyone.CastCycle(S.MindSear, Enemies40y, EvaluateCycleMindSear222, not Target:IsSpellInRange(S.MindSear)) then return "mind_sear 97"; end
  end
  -- damnation,target_if=!variable.all_dots_up
  if S.Damnation:IsCastable() then
    if Everyone.CastCycle(S.Damnation, Enemies40y, EvaluateCycleDamnation200, not Target:IsSpellInRange(S.Damnation)) then return "damnation 98"; end
  end
  -- devouring_plague,if=talent.legacy_of_the_void.enabled&cooldown.void_eruption.up&insanity=100
  if S.DevouringPlague:IsReady() and (S.HungeringVoid:IsAvailable() and S.VoidEruption:CooldownUp() and Player:Insanity() == 100) then
    if HR.Cast(S.DevouringPlague, nil, nil, not Target:IsSpellInRange(S.DevouringPlague)) then return "devouring_plague 100"; end
  end
  -- devouring_plague,target_if=(refreshable|insanity>75)&!cooldown.power_infusion.up&(!talent.searing_nightmare.enabled|(talent.searing_nightmare.enabled&!variable.searing_nightmare_cutoff))&(!talent.legacy_of_the_void.enabled|(talent.legacy_of_the_void.enabled&buff.voidform.down))
  if S.DevouringPlague:IsReady() then
    if Everyone.CastCycle(S.DevouringPlague, Enemies40y, EvaluateCycleDevouringPlage202, not Target:IsSpellInRange(S.DevouringPlague)) then return "devouring_plague 102"; end
  end
  -- shadow_word_death,target_if=target.health.pct<20|(pet.fiend.active&runeforge.shadowflame_prism.equipped)
  if S.ShadowWordDeath:IsCastable() then
    if Everyone.CastCycle(S.ShadowWordDeath, Enemies40y, EvaluateCycleShadowWordDeath204, not Target:IsSpellInRange(S.ShadowWordDeath)) then return "shadow_word_death 104"; end
  end
  -- surrender_to_madness,target_if=target.time_to_die<25&buff.voidform.down
  if S.SurrenderToMadness:IsCastable() then
    if Everyone.CastCycle(S.SurrenderToMadness, Enemies40y, EvaluateCycleSurrenderToMadness206, not Target:IsSpellInRange(S.SurrenderToMadness)) then return "surrender_to_madness 106"; end
  end
  -- mindbender
  if S.Mindbender:IsCastable() then
    if HR.Cast(S.Mindbender, Settings.Shadow.GCDasOffGCD.Mindbender, nil, not Target:IsSpellInRange(S.Mindbender)) then return "shadowfiend/mindbender 108"; end
  end
  -- void_torrent,target_if=variable.all_dots_up&!buff.voidform.up&target.time_to_die>4
  if S.VoidTorrent:IsCastable() then
    if HR.Cast(S.VoidTorrent, 40, EvaluateCycleVoidTorrent208) then return "void_torrent 110"; end
  end
  -- shadow_word_death,if=runeforge.painbreaker_psalm.equipped&variable.dots_up&target.time_to_pct_20>(cooldown.shadow_word_death.duration+gcd)
  if S.ShadowWordDeath:IsReady() and (PainbreakerEquipped and VarDotsUp and Target:TimeToX(20) > S.ShadowWordDeath:Cooldown() + Player:GCD()) then
    if HR.Cast(S.ShadowWordDeath, nil, nil, not Target:IsSpellInRange(S.ShadowWordDeath)) then return "shadow_word_death 112"; end
  end
  -- shadow_crash,if=spell_targets.shadow_crash=1&(cooldown.shadow_crash.charges=3|debuff.shadow_crash_debuff.up|action.shadow_crash.in_flight|target.time_to_die<cooldown.shadow_crash.full_recharge_time)&raid_event.adds.in>30
  if S.ShadowCrash:IsReady() and not Player:IsCasting(S.ShadowCrash) and (EnemiesCount10 == 1 and (S.ShadowCrash:Charges() == 3 or Target:DebuffUp(S.ShadowCrashDebuff) or S.ShadowCrash:InFlight() or Target:TimeToDie() < S.ShadowCrash:FullRechargeTime())) then
    if HR.Cast(S.ShadowCrash, nil, nil, not Target:IsSpellInRange(S.ShadowCrash)) then return "shadow_crash 114"; end
  end
  -- shadow_crash,if=raid_event.adds.in>30&spell_targets.shadow_crash>1
  if S.ShadowCrash:IsReady() and not Player:IsCasting(S.ShadowCrash) and (EnemiesCount10 > 1) then
    if HR.Cast(S.ShadowCrash, nil, nil, not Target:IsSpellInRange(S.ShadowCrash)) then return "shadow_crash 116"; end
  end
  -- mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff&buff.dark_thoughts.up,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
  if S.MindSear:IsCastable() then
    if Everyone.CastCycle(S.MindSear, Enemies40y, EvaluateCycleMindSear210, not Target:IsSpellInRange(S.MindSear)) then return "mind_sear 118"; end
  end
  -- mind_flay,if=buff.dark_thoughts.up&variable.dots_up,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&cooldown.void_bolt.up
  if S.MindFlay:IsCastable() and not Player:IsCasting(S.MindFlay) and (Player:BuffUp(S.DarkThoughtsBuff) and VarDotsUp) then
    if HR.Cast(S.MindFlay, nil, nil, not Target:IsSpellInRange(S.MindFlay)) then return "mind_flay 120"; end
  end
  -- mind_blast,if=variable.dots_up&raid_event.movement.in>cast_time+0.5&spell_targets.mind_sear<4
  if S.MindBlast:IsCastable() and (VarDotsUp and EnemiesCount10 < 4) then
    if HR.Cast(S.MindBlast, nil, nil, not Target:IsSpellInRange(S.MindBlast)) then return "mind_blast 122"; end
  end
  -- vampiric_touch,target_if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)|buff.unfurling_darkness.up
  if S.VampiricTouch:IsCastable() then
    if Everyone.CastCycle(S.VampiricTouch, Enemies40y, EvaluateCycleVampiricTouch214, not Target:IsSpellInRange(S.VampiricTouch)) then return "vampiric_touch 124"; end
  end
  -- shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&talent.psychic_link.enabled&spell_targets.mind_sear>2
  if S.ShadowWordPain:IsCastable() and (Target:DebuffRefreshable(S.ShadowWordPainDebuff) and Target:TimeToDie() > 4 and not S.Misery:IsAvailable() and S.PsychicLink:IsAvailable() and EnemiesCount10 > 2) then
    if HR.Cast(S.ShadowWordPain, nil, nil, not Target:IsSpellInRange(S.ShadowWordPain)) then return "shadow_word_pain 126"; end
  end
  -- shadow_word_pain,target_if=refreshable&target.time_to_die>4&!talent.misery.enabled&(!talent.psychic_link.enabled|(talent.psychic_link.enabled&spell_targets.mind_sear<=2))
  if S.ShadowWordPain:IsCastable() and (not S.Misery:IsAvailable()) then
    if Everyone.CastCycle(S.ShadowWordPain, Enemies40y, EvaluateCycleShadowWordPain220, not Target:IsSpellInRange(S.ShadowWordPain)) then return "shadow_word_pain 128"; end
  end
  -- mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
  if S.MindSear:IsCastable() then
    if Everyone.CastCycle(S.MindSear, Enemies40y, EvaluateCycleMindSear216, not Target:IsSpellInRange(S.MindSear)) then return "mind_sear 130"; end
  end
  -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
  if S.MindFlay:IsCastable() then
    if HR.Cast(S.MindFlay, nil, nil, not Target:IsSpellInRange(S.MindFlay)) then return "mind_flay 132"; end
  end
  -- shadow_word_pain
  if S.ShadowWordPain:IsCastable() then
    if HR.Cast(S.ShadowWordPain, nil, nil, not Target:IsSpellInRange(S.ShadowWordPain)) then return "shadow_word_pain 134"; end
  end
end

--- ======= ACTION LISTS =======
local function APL()
  Enemies8y = Player:GetEnemiesInRange(8)
  Enemies15y = Player:GetEnemiesInRange(15)
  Enemies40y = Player:GetEnemiesInRange(40)
  EnemiesCount10 = Target:GetEnemiesInSplashRangeCount(10)

  -- call precombat
  if not Player:AffectingCombat() then
    local ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
  end
  if Everyone.TargetIsValid() then
    -- Manually Added: Use Dispersion if dying
    if S.Dispersion:IsCastable() and Player:HealthPercentage() < Settings.Shadow.DispersionHP then
      if HR.Cast(S.Dispersion, Settings.Shadow.OffGCDasOffGCD.Dispersion) then return "dispersion low_hp"; end
    end
    -- Interrupts
    local ShouldReturn = Everyone.Interrupt(30, S.Silence, Settings.Commons.OffGCDasOffGCD.Silence, false); if ShouldReturn then return ShouldReturn; end
    -- potion,if=buff.bloodlust.react|target.time_to_die<=80|target.health.pct<35
    if I.PotionofDeathlyFixation:IsReady() and Settings.Commons.UsePotions and (Player:BloodlustUp() or Target:TimeToDie() <= 80 or Target:HealthPercentage() < 35) then
      if HR.CastSuggested(I.PotionofDeathlyFixation) then return "potion_of_spectral_intellect 20"; end
    end
    -- variable,name=dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking
    VarDotsUp = DotsUp(Target, false)
    -- variable,name=all_dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking&dot.devouring_plague.ticking
    VarAllDotsUp = DotsUp(Target, true)
    -- variable,name=searing_nightmare_cutoff,op=set,value=spell_targets.mind_sear>2
    VarSearingNightmareCutoff = (EnemiesCount10 > 3)
    if (HR.CDsON()) then
      -- fireblood,if=buff.voidform.up
      if S.Fireblood:IsCastable() and (Player:BuffUp(S.VoidformBuff)) then
        if HR.Cast(S.Fireblood, Settings.Commons.OffGCDasOffGCD.Racials) then return "fireblood 22"; end
      end
      -- berserking
      if S.Berserking:IsCastable() then
        if HR.Cast(S.Berserking, Settings.Commons.OffGCDasOffGCD.Racials) then return "berserking 24"; end
      end
      -- lights_judgment
      if S.LightsJudgment:IsCastable() then
        if HR.Cast(S.LightsJudgment, Settings.Commons.OffGCDasOffGCD.Racials, nil, not Target:IsSpellInRange(S.LightsJudgment)) then return "lights_judgment 26"; end
      end
      -- ancestral_call,if=buff.voidform.up
      if S.AncestralCall:IsCastable() and (Player:BuffUp(S.VoidformBuff)) then
        if HR.Cast(S.AncestralCall, Settings.Commons.OffGCDasOffGCD.Racials) then return "ancestral_call 28"; end
      end
      -- bag_of_tricks
      if S.BagofTricks:IsCastable() then
        if HR.Cast(S.BagofTricks, Settings.Commons.OffGCDasOffGCD.Racials, nil, not Target:IsSpellInRange(S.BagofTricks)) then return "bag_of_tricks 30"; end
      end
    end
    -- call_action_list,name=cwc
    if (true) then
      local ShouldReturn = Cwc(); if ShouldReturn then return ShouldReturn; end
    end
    -- run_action_list,name=main
    if (true) then
      local ShouldReturn = Main(); if ShouldReturn then return ShouldReturn; end
    end
  end
end

local function Init()

end

HR.SetAPL(258, APL, Init)
