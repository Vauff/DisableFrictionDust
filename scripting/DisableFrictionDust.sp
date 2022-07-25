#include <sourcemod>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "Disable Friction Dust",
	author = "Vauff",
	description = "Disables dust particles from collision friction that can cause lag",
	version = "1.0",
	url = "https://github.com/Vauff/DisableFrictionDust"
};

Handle g_hPhysFrictionEffect;

public void OnPluginStart()
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "gamedata/DisableFrictionDust.games.txt");

	if (!FileExists(path))
		SetFailState("Can't find DisableFrictionDust.games.txt gamedata");

	Handle gameData = LoadGameConfigFile("DisableFrictionDust.games");
	
	if (gameData == INVALID_HANDLE)
		SetFailState("Can't find DisableFrictionDust.games.txt gamedata");

	g_hPhysFrictionEffect = DHookCreateFromConf(gameData, "PhysFrictionEffect");
	CloseHandle(gameData);

	if (!g_hPhysFrictionEffect)
		SetFailState("Failed to setup detour for PhysFrictionEffect");

	if (!DHookEnableDetour(g_hPhysFrictionEffect, false, Detour_PhysFrictionEffect))
		SetFailState("Failed to detour PhysFrictionEffect");
}

public MRESReturn Detour_PhysFrictionEffect()
{
	return MRES_Supercede;
}