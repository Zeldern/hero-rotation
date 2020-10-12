**Not every spec is updated for Shadowlands, so please check the table below (Supported Rotations). If a spec is in WIP or Outdated status, please do not report an issue about it.**

**If you are experiencing issues with AoE rotations (likely abilities not being recommended), be sure to have enemies nameplates enabled and enough nameplates shown (camera can hide them).**

**If you see an icon with "POOL" written inside, it means you have to pool your resources. It's a normal behavior. Please see this [link explaining resource pooling](https://wow.gamepedia.com/Resource_pooling).**

**If you update the addon via the Twitch Client and wish to get every change as they are released, please set the addon type to Alpha by right clicking the addon name and selecting Alpha under Release Type. Note that this can potentially include updates that break functionality!**

# HeroRotation

[![GitHub license](https://img.shields.io/badge/license-EUPL-blue.svg)](https://raw.githubusercontent.com/herotc/hero-rotation/master/LICENSE) [![GitHub forks](https://img.shields.io/github/forks/herotc/hero-rotation.svg)](https://github.com/herotc/hero-rotation/network) [![GitHub stars](https://img.shields.io/github/stars/herotc/hero-rotation.svg)](https://github.com/herotc/hero-rotation/stargazers) [![GitHub issues](https://img.shields.io/github/issues/herotc/hero-rotation.svg)](https://github.com/herotc/hero-rotation/issues)

HeroRotation is a World of Warcraft addon to provide the player useful and precise information to execute the best possible DPS rotation in every PvE situation at max level.
The project is hosted on [GitHub](https://github.com/herotc/hero-rotation) and powered by [HeroLib](https://github.com/herotc/hero-lib) and [HeroDBC](https://github.com/herotc/hero-dbc).
It is maintained by [Aethys](https://github.com/aethys256/) and the [HeroTC](https://github.com/herotc) team.
Also, you can find it on [CurseForge](https://www.curseforge.com/wow/addons/herorotation).

**There are a lot of helpful commands. Do '/hr help' to see them in-game!
Most of the commands and options are being moved to Addons Panels, and you can see them by going into Interface -> Addons -> HeroRotation.**

Feel free to join our [Discord](https://discord.gg/tFR2uvK). Feedback is highly appreciated!

## Key Features
- Main icon that shows the next ability you should cast.
- Two smaller icons above the previous one that shows the useful OffGCD abilities to use.
- One medium icon on the left that shows every ability that should be cycled (i.e. multi-dotting).
- One medium-small icon on the upper-left that does proposals about situational abilities (trinkets, potions, ...).
- Toggles to turn On/Off the CDs or AoE to adjust the rotation according to the situation (the addon can be disabled this way aswell).

_Toggles can now use directly key bindings, set them in 'Game Menu -> Key Bindings -> AddOns'_

Every rotation is based on [SimulationCraft](http://simulationcraft.org/) [Action Priority Lists](https://github.com/simulationcraft/simc/wiki/ActionLists).

## Special Features
- Handle both single target and AoE rotations (it auto adapts).
- Optimized pooling of resources when needed (ex: energy before using cooldowns as a rogue).
- Accurate TimeToDie prediction.
- Next cast prediction for casters.
- Special handlers for tricky abilities (ex: finality or exsanguinated bleeds for rogues).
- Solo mode to prioritize survivability over DPS. (Not available in every rotation)

## Supported Rotations
| Class        | Specs                                                                                 |                                                                                   |                                                                                 |
| :---         | :---                                                                                  | :---                                                                              | :---                                                                            |
| Death Knight | [![Blood](https://img.shields.io/badge/Blood-Outdated-red.svg)]()                     | [![Frost](https://img.shields.io/badge/Frost-WIP-orange.svg)]()               | [![Unholy](https://img.shields.io/badge/Unholy-WIP-orange.svg)]()           |
| Demon Hunter | [![Vengeance](https://img.shields.io/badge/Vengeance-WIP-orange.svg)]()           | [![Havoc](https://img.shields.io/badge/Havoc-Outdated-red.svg)]()               |                                                                                 |
| Druid        | [![Balance](https://img.shields.io/badge/Balance-Outdated-red.svg)]()                 | [![Guardian](https://img.shields.io/badge/Guardian-Outdated-red.svg)]()           | [![Feral](https://img.shields.io/badge/Feral-Outdated-red.svg)]()               |
| Hunter       | [![Beast Mastery](https://img.shields.io/badge/Beast%20Mastery-WIP-orange.svg)]() | [![Marksmanship](https://img.shields.io/badge/Marksmanship-WIP-orange.svg)]() | [![Survival](https://img.shields.io/badge/Survival-Outdated-red.svg)]()           |
| Mage         | [![Frost](https://img.shields.io/badge/Frost-WIP-orange.svg)]()                       | [![Fire](https://img.shields.io/badge/Fire-Outdated-red.svg)]()                     | [![Arcane](https://img.shields.io/badge/Arcane-Outdated-red.svg)]()           |
| Monk         | [![Brewmaster](https://img.shields.io/badge/Brewmaster-Outdated-red.svg)]()           | [![Windwalker](https://img.shields.io/badge/Windwalker-Outdated-red.svg)]()       |                                                                                 |
| Paladin      | [![Protection](https://img.shields.io/badge/Protection-Outdated-red.svg)]()           | [![Retribution](https://img.shields.io/badge/Retribution-Outdated-red.svg)]()     |                                                                                 |
| Priest       | [![Shadow](https://img.shields.io/badge/Shadow-WIP-orange.svg)]()                   |                                                                                   |                                                                                 |
| Rogue        | [![Assassination](https://img.shields.io/badge/Assassination-Outdated-red.svg)]()   | [![Outlaw](https://img.shields.io/badge/Outlaw-OK-brightgreen.svg)]()             | [![Subtlety](https://img.shields.io/badge/Subtlety-Outdated-red.svg)]()       |
| Shaman       | [![Elemental](https://img.shields.io/badge/Elemental-Outdated-red.svg)]()             | [![Enhancement](https://img.shields.io/badge/Enhancement-Outdated-red.svg)]()     |                                                                                 |
| Warlock      | [![Affliction](https://img.shields.io/badge/Affliction-Outdated-red.svg)]()           | [![Demonology](https://img.shields.io/badge/Demonology-WIP-orange.svg)]()       | [![Destruction](https://img.shields.io/badge/Destruction-Outdated-red.svg)]()   |
| Warrior      | [![Arms](https://img.shields.io/badge/Arms-Outdated-red.svg)]()                       | [![Fury](https://img.shields.io/badge/Fury-Outdated-red.svg)]()                 |                                                                                 |

[![Spec](https://img.shields.io/badge/Spec-OK-brightgreen.svg)]() [![Spec](https://img.shields.io/badge/Spec-WIP-orange.svg)]() [![Spec](https://img.shields.io/badge/Spec-Outdated-red.svg)]()

## Support the team
| Name                                        | Maintaining                         | Since     | Donate                                                                                                    | Watch                                                                                                |
| :---                                        | :---                                | ---:      | :---:                                                                                                     | :---:                                                                                                |
| [Aethys](https://github.com/Aethys256)      | Core, Rogue, Hunter, Warlock, Blood |  Aug 2016 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/Aethys/5)        | [![Stream](https://img.shields.io/badge/Stream-Twitch-6441a4.svg)](https://www.twitch.tv/aethys)     |
| [Nia](https://github.com/Nianel)            | Warlock                             |  Feb 2017 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/Nianel/5)        | [![Stream](https://img.shields.io/badge/Stream-Twitch-6441a4.svg)](https://www.twitch.tv/nianel)     |
| [KutiKuti](https://github.com/Kutikuti)     | Mage, Priest                        |  Mar 2017 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/kutikuti/5)      |                                                                                                      |
| [Mystler](https://github.com/Mystler)       | Rogue                               |  May 2017 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/Mystler/5)       |                                                                                                      |
| [Krich](https://github.com/chrislopez24)    | Death Knight                        |  Jun 2017 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/krige/5)         |                                                                                                      |
| [Kojiyama](https://github.com/EvanMichaels) | Core, DH, Rogue                     |  Sep 2017 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/kojiyama/5)      |                                                                                                      |
| [Blackytemp](https://github.com/ghr74)      | Feral                               |  Oct 2017 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/blackytempdev/5) |                                                                                                      |
| [Hinalover](https://github.com/Hinalover)   | Windwalker                          |  Jan 2018 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/Hinalover/5)     |                                                                                                      |
| [Cilraaz](https://github.com/Cilraaz)       | Core, DH, Priest                    |  Jan 2019 | [![Donate](https://img.shields.io/badge/Donate-PayPal-003087.svg)](https://www.paypal.me/Cilraaz/5)       |[![Stream](https://img.shields.io/badge/Stream-Twitch-6441a4.svg)](https://www.twitch.tv/cilraaz)     |

### Past members
[Riff](https://github.com/tombell), [Tael](https://github.com/Tae-l), [Locke](https://github.com/Lockem90), [3L00DStrike](https://github.com/3L00DStrike), [Lithium](https://github.com/lithium720), [Glynny](https://github.com/Glynnyx)


## Special Mention About SimC APL
As said earlier, every rotation is based on SimulationCraft Action Priority Lists (APL).
What this means is it heavily relies on how optimized those APLs are, especially for some talents, tier bonuses, and legendaries support.
Do remember that what the addon tells you is what the robot on SimulationCraft would do in your situation.
It also means that you can improve the current APL by using the addon and reporting any issues you might encounter.
I am a Rogue theorycrafter and contributor to SimulationCraft, so both SimC APL and addon rotation are 100% synced. Both tools are used to do Rogue theorycrafting.

## Special Thanks
- [SimulationCraft](http://simulationcraft.org/) for everything the project gives to the whole WoW Community.
- [KutiKuti](https://github.com/Kutikuti) & [Nia](https://github.com/Nianel) for their daily support.
- [Skasch](https://github.com/skasch) for what we built together and the motivation he gave to me.
- [Mystler](https://github.com/Mystler) & [Kojiyama](https://github.com/EvanMichaels) for their help on everything related to rogues that frees me a lot of time.

## Advanced Users / Developer Notes
If you want to use the addon directly from the [GitHub repository](https://github.com/herotc/hero-rotation), you would have to symlink every folder from this repository (HeroRotation folder and every class module, except for the template) to your WoW Addons folder.
Furthermore, to make it work, you need to add the only dependency, which is [HeroLib](https://github.com/herotc/hero-lib) following the same processus (symlink HeroLib & HeroCache from the repository).
There is a script that does this for you. Open symlink.bat (or symlink.sh) and modify the two vars (WoWRep and GHRep) to match your local setup.
Make sure HeroRotation's directories doesn't already exist as it will not override them.
Finally, launch symlink.bat.

Stay tuned !
Aethys
