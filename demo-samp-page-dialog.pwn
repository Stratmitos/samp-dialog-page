#include <a_samp>
#include <zcmd>

#undef MAX_PLAYERS
#define MAX_PLAYERS                                                    150
#define DIALOG_WEAPON_SHOP                                             999
#include <samp-dialog-page\core\include\samp-dialog-page.pwn>

enum demoData {
    demoDataId,
    demoDataName[128],
    demoDataPrice,
}
new varDemo[][demoData] = {
    {WEAPON_AK47, "AK47", 5000},
    {WEAPON_MP5, "Mp5", 5000},
    {WEAPON_M4, "M4", 10000},
    {WEAPON_TEC9, "Tec9", 3500},
    {WEAPON_UZI, "Uzi", 3500},
    {WEAPON_COLT45, "Colt 45", 2500},
    {WEAPON_SILENCED, "Colt 45 - Silencer", 2760},
    {WEAPON_DEAGLE, "Desert Eagle", 3000},
    {WEAPON_SHOTGSPA, "Combat Shotgun", 8500},
    {WEAPON_SHOTGUN, "Shotgun", 6500},
    {WEAPON_SAWEDOFF, "Sawn Off Shotgun", 7500},
    {WEAPON_SNIPER, "Sniper", 15000},
    {WEAPON_RIFLE, "Rifle", 12500},
    {WEAPON_ROCKETLAUNCHER, "RPG", 17500},
    {WEAPON_HEATSEEKER, "Heatseeker", 20000},
    {WEAPON_KATANA, "Katana", 1000},
    {WEAPON_BAT, "Bat", 500},
    {WEAPON_KNIFE, "Knife", 750},
    {WEAPON_CANE, "Cane", 500},
    {WEAPON_SHOVEL, "Shovel", 500},
    {WEAPON_POOLSTICK, "Poolstick", 500},
    {WEAPON_GOLFCLUB, "Golfclub", 500},
    {WEAPON_FLOWER, "Flower", 500},
    {WEAPON_DILDO, "Dildo A", 6969},
    {WEAPON_DILDO2, "Dildo B", 6969},
    {WEAPON_VIBRATOR, "Vibrat A", 6969},
    {WEAPON_VIBRATOR2, "Vibrat B", 6969},
    {WEAPON_BRASSKNUCKLE, "Knuckle", 100},
    {WEAPON_CAMERA, "Camera", 250},
    {WEAPON_SPRAYCAN, "Spraycan", 150}
};

public OnFilterScriptInit()
{
    for (new i = 0; i < MAX_PLAYERS; i++) {
        ResetDialogData(i);
    }

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_WEAPON_SHOP) {
        if (response) {
            switch (listitem) {
                case 0..9: {
                    new dataId = GetFirstValueDialog(playerid, listitem);
                    GivePlayerWeapon(playerid, varDemo[dataId][demoDataId], 1000);
                    GivePlayerMoney(playerid, -varDemo[dataId][demoDataId]);
                    SendClientMessage(playerid, 0xFFFFFF, "-Ammunation- Weapon purchased!");
                }
                case 10: {
                    InitiateDialogNextPage(playerid);
                    cmd_weaponshop(playerid);
                }
                case 11: {
                    InitiateDialogPreviousPage(playerid);
                    cmd_weaponshop(playerid);
                }
            }
        }
    }

    return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
    ResetDialogData(playerid);
    return 1;
}

CMD:weaponshop (playerid) {
    new i = 0;
    new dataIndex = InitiateDialogDataIndex(playerid);
    while (i < MAX_DATA_PER_DIALOG) {
        new labelName[128];
        printf("Data index: %d", dataIndex);
        if (dataIndex < sizeof(varDemo)) {
            format(labelName, 128, "%s\t%d\n", varDemo[dataIndex][demoDataName], varDemo[dataIndex][demoDataPrice]);
            AddValueToDialog(playerid, i, labelName, dataIndex);
        } else {
            strcat(labelName, "-\t-\n", 128);
            AddValueToDialog(playerid, i, labelName, INVALID_ID);
            SetThisDialogPageAsLastPage(playerid);
        }

        i ++;
        dataIndex ++;
    }

    ShowDialogWithPage(playerid, DIALOG_WEAPON_SHOP, "Ammunation", "Select", "Exit", sizeof(varDemo), true);
    return 1;
}