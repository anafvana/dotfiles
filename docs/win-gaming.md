# Setup for Gaming on Windows PC

## PS3 Emulation

> [!TIP]
> With extra configuration, works for PS Vita, PS1 and PSP too

1. Get [RPCS3](https://rpcs3.net/download)

2. Unzip it
```
7z x rpcs3*.7z -orpcs3
```

3. Move it to a convenient location
```
mv rpcs3 %AppData%
```

4. Run `rpcs3.exe`. It will create shortcuts for you

> [!NOTE]
> The next steps are directly from the [quickstart guide](https://rpcs3.net/quickstart)

5. Download PS3 software from [PS website](https://www.playstation.com/en-us/support/hardware/ps3/system-software/)

6. On rpcs3 > File > Install Firmware, select the downloaded `.pup` file

### Installing games

> [!NOTE]
> Information from the [quickstart guide](https://rpcs3.net/quickstart)

.PKG files must be extracted using RPCS3's package installer found under `File > Install Packages/Raps/Edats` (or drag and dropped onto emulator window)

Blu-ray disc game data should be placed in `\games` located in your RPCS3 root folder or anywhere else except for `\dev_hdd0\game\` and can be booted from `File > Boot Game` if not present on the game list.

Save data files can be managed in `\dev_hdd0\home\00000001\savedata\`

ROMs can be downloaded from:
- (RECOMMENDED) [NoPayStation](#nopaystation)
- [romsfun.com](https://romsfun.com)
- [dlpsgame.com](https://dlpsgame.com)
- [vimm.net](https://vimm.net)

#### NoPayStation

1. Get [pkg2zip](https://github.com/lusid1/pkg2zip/releases) and extract it (recommended dir: `%AppData%/NoPayStation`)
2. Download PC file from [nopaystation](https://nopaystation.com/) and extract it (recommended dir: `%AppData%/NoPayStation`)
3. Launch NPSBrowser (nopaystation download)
4. Fill the form with links (retrieved from [nopaystation](https://nopaystation.com/)):
	- Games
		- PSV tsv http://nopaystation.com/tsv/PSV_GAMES.tsv
		- PSM tsv http://nopaystation.com/tsv/PSM_GAMES.tsv
		- PSX tsv http://nopaystation.com/tsv/PSX_GAMES.tsv
		- PS3 tsv http://nopaystation.com/tsv/PS3_GAMES.tsv
		- PSP tsv http://nopaystation.com/tsv/PSP_GAMES.tsv
	- Demos
		- PSV tsv http://nopaystation.com/tsv/PSV_DEMOS.tsv
		- PS3 tsv http://nopaystation.com/tsv/PS3_DEMOS.tsv
	- DLCs
		- PSV tsv http://nopaystation.com/tsv/PSV_DLCS.tsv
		- PS3 tsv http://nopaystation.com/tsv/PS3_DLCS.tsv
		- PSP tsv http://nopaystation.com/tsv/PSP_DLCS.tsv
	- Updates
		- PSV tsv http://nopaystation.com/tsv/PSV_UPDATES.tsv
		- PSP tsv http://nopaystation.com/tsv/PSP_UPDATES.tsv
	- Themes
		- PSV tsv http://nopaystation.com/tsv/PSV_THEMES.tsv
		- PS3 tsv http://nopaystation.com/tsv/PS3_THEMES.tsv
		- PS3AV tsv http://nopaystation.com/tsv/PS3_AVATARS.tsv
		- PSP tsv http://nopaystation.com/tsv/PSP_THEMES.tsv
5. Fill the form part2:
	- Download and unpack dir: (RECOMMENDED) `%AppData%/NoPayStation`
	- Any pkg dec tool: (RECOMMENDED) `%AppData%/pkg2zip.exe`
6. Close the dialog and wait for sync to finish
7. If you see no data, close the NPS Browser and re-open
8. Download desired game(s)
9. In rpcs3, go `File > Install packages, rapts, edats`, select desired `rap` from `exdata` directory
10. Go to `File > Install packages, rapts, edats` again and select game from `package` directory
11. It should now be playable

## Stepmania

1. Download game from [stepmania.com](https://www.stepmania.com/download/)

2. Install game

3. Download song packs from:
    - [zenius-i-vanisher](https://zenius-i-vanisher.com/v5.2/simfiles.php?category=simfiles) (SEARCH SONG/ARTIST!)
    - [stepmaniaonline](https://search.stepmaniaonline.net/)
    - [flashflash revolution's thread](https://www.flashflashrevolution.com/vbz/showthread.php?t=133223)
    - [stepmania.com](https://www.stepmania.com/forums/song-packs/)
    - [houkouonchi archive](https://web.archive.org/web/20151226051543/http://houkouonchi.net:8080/packs/)
    - [User-created packs Google Sheet](https://docs.google.com/spreadsheets/d/1F1IURV1UAYiICTLhAOKIJfwUN1iG12ZOufHZuDKiP48/htmlview)
    - [Otaku's dream](https://www.otakusdream.com/downloads/)

4. Install song packs by unzipping them into the `StepMania 5/Songs` folder. </br>Default directory is `C:\Games\StepMania 5\Songs`

### Missing `d3dx9_43.dll`

1. Download [DirectX from Microsoft's website](https://www.microsoft.com/en-us/download/details.aspx?id=8109)

2. Run `.exe`. </br>It will ask you for a directory where to extract the files. </br>**Make sure you remember this directory** (Tip: make it an empty folder)

3. Go into the directory you extracted the files to

4. Run `DXSETUP.exe`

5. Once it's done, you should be able to run Stepmania
