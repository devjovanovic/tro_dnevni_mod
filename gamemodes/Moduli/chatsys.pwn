// Cetovi sistem kreirao Jovanovic datuma 30.12.2020.
#include <YSI\y_hooks>

//----------------------------------------------------------
function ProxDetector(playerid, Float:range, string[], boja)
{
	new Float:Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	foreach(new i : Player)
	{
	    if(IsPlayerInRangeOfPoint(i, range, Pos[0], Pos[1], Pos[2]))
	    {
	        if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
	        {
	        	SCM(i, boja, string);
			}
		}
	}
	return 1;
}
//----------------------------------------------------------
CMD:do(playerid, params[])
{
	new text[128], string[128];
	if(sscanf(params, "s[128]", text)) return KORISTI(playerid, "/do [tekst]");
	format(string, sizeof(string), "*%s %s", text, GetName(playerid));
	ProxDetector(playerid, 15.0, string, 0xf9b7ffaa);
	SetPlayerChatBubble(playerid, text, 0xf9b7ffaa, 15.0, 10000);
	return 1;
}
//----------------------------------------------------------
CMD:me(playerid, params[])
{
	new text[128], string[128];
	if(sscanf(params, "s[128]", text)) return KORISTI(playerid, "/me [tekst]");
	format(string, sizeof(string), "*%s %s", GetName(playerid), text);
	ProxDetector(playerid, 15.0, string, 0xf9b7ffaa);
	SetPlayerChatBubble(playerid, text, 0xf9b7ffaa, 15.0, 10000);
	return 1;
}
//----------------------------------------------------------
CMD:b(playerid, params[])
{
	new text[128], string[128];
	if(sscanf(params, "s[128]", text)) return KORISTI(playerid, "/b [tekst]");
	format(string, sizeof(string), "[%d] %s: "BELA"(( %s ))", playerid, GetName(playerid), text);
	ProxDetector(playerid, 15.0, string, 0xd6cf00ff);
	return 1;
}
//----------------------------------------------------------
hook OnPlayerText(playerid, text[])
{
	new string[128];
	format(string, sizeof(string), "[%d] %s kaze: "BELA"%s", playerid, GetName(playerid), text);
	ProxDetector(playerid, 15.0, string, 0xd6cf00ff);
	SetPlayerChatBubble(playerid, text, 0xFFFFFFFF, 15.0, 10000);
	return 1;
}
//----------------------------------------------------------
