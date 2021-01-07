// Sistem kuca kreiran od strane Jovanovic 31.12.2020.
#include <YSI\y_hooks>

//----------------------------------------------------------
#define KUCE_FILE    "Kuce/%d.ini"
#define MAX_KUCA 100
enum Kuce
{
	Vlasnik,
	ImeVlasnika[45],
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:EntPosX,
	Float:EntPosY,
	Float:EntPosZ,
	Level,
	Cena,
	Int,
	Zakljucano,
	VW,
};
new KI[MAX_KUCA][Kuce];
new KucaPickup[sizeof(KI)];
new Text3D:KucaLabel[sizeof(KI)];
//----------------------------------------------------------
stock SledeciIDKuce()
{
	new file[80];
	for(new i = 0; i < MAX_KUCA; i++)
	{
		format(file,sizeof(file),KUCE_FILE,i);
		if(!fexist(file)) return i;
	}
	return 1;
}
//----------------------------------------------------------
forward UcitajKuce(id, name[], value[]);
public UcitajKuce(id, name[], value[])
{
	INI_Int("ProveraVlasnika",KI[id][Vlasnik]);
	INI_String("Vlasnik",KI[id][ImeVlasnika],45);
    INI_Float("UlazX",KI[id][PosX]);
    INI_Float("UlazY",KI[id][PosY]);
    INI_Float("UlazZ",KI[id][PosZ]);
    INI_Float("IzlazX",KI[id][EntPosX]);
    INI_Float("IzlazY",KI[id][EntPosY]);
    INI_Float("IzlazZ",KI[id][EntPosZ]);
    INI_Int("Level",KI[id][Level]);
    INI_Int("Cena",KI[id][Cena]);
    INI_Int("Interior",KI[id][Int]);
    INI_Int("Zatvoreno",KI[id][Zakljucano]);
    INI_Int("VW",KI[id][VW]);
	return 1;
}
//----------------------------------------------------------
stock SacuvajKucu(id)
{
	new file[128];
    format(file, sizeof(file), KUCE_FILE, id);
	new INI:File = INI_Open(file);
	INI_WriteInt(File,"ProveraVlasnika",KI[id][Vlasnik]);
	INI_WriteString(File,"Vlasnik",KI[id][ImeVlasnika]);
	INI_WriteFloat(File,"UlazX",KI[id][PosX]);
	INI_WriteFloat(File,"UlazY",KI[id][PosY]);
	INI_WriteFloat(File,"UlazZ",KI[id][PosZ]);
	INI_WriteFloat(File,"IzlazX",KI[id][EntPosX]);
	INI_WriteFloat(File,"IzlazY",KI[id][EntPosY]);
	INI_WriteFloat(File,"IzlazZ",KI[id][EntPosZ]);
	INI_WriteInt(File,"Level",KI[id][Level]);
    INI_WriteInt(File,"Cena",KI[id][Cena]);
    INI_WriteInt(File,"Interior",KI[id][Int]);
    INI_WriteInt(File,"Zatvoreno",KI[id][Zakljucano]);
    INI_WriteInt(File,"VW",KI[id][VW]);
	INI_Close(File);
	return 1;
}
//----------------------------------------------------------
stock RefreshKuce(id)
{
	new string[400];
	if(KI[id][Vlasnik] == 0)
	{
		DestroyDynamic3DTextLabel(KucaLabel[id]);
		DestroyDynamicPickup(KucaPickup[id]);
        format(string,sizeof(string),"Kuca na Prodaju (ID: %d)\nCena: %d\nLevel: %d\nZa kupovinu /kupikucu", id, KI[id][Cena], KI[id][Level]);
        KucaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,KI[id][PosX],KI[id][PosY],KI[id][PosZ],25,0,1);
        KucaPickup[id] = CreateDynamicPickup(1273, 1, KI[id][PosX], KI[id][PosY], KI[id][PosZ]);
	}
	else if(KI[id][Vlasnik] == 1)
	{
		DestroyDynamic3DTextLabel(KucaLabel[id]);
		DestroyDynamicPickup(KucaPickup[id]);
		format(string,sizeof(string),"Vlasnik: %s (ID: %d)\nCena: %d\nLevel: %d\nZa kupovinu /kupikucu", KI[id][ImeVlasnika], id, KI[id][Cena], KI[id][Level]);
        KucaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,KI[id][PosX],KI[id][PosY],KI[id][PosZ],25,0,1);
        KucaPickup[id] = CreateDynamicPickup(1239, 1, KI[id][PosX], KI[id][PosY], KI[id][PosZ]);
	}
	return 1;
}
//----------------------------------------------------------
CMD:kuca(playerid, params[])
{
    new string[256];
	if(PI[playerid][pKuca] == -1) return GRESKA(playerid, "Morate posedovati kucu.");
	if(strcmp(KI[PI[playerid][pKuca]][ImeVlasnika], GetName(playerid), true)) return GRESKA(playerid, "Morate biti vlasnik ove kuce.");
    format(string,sizeof(string),"Informacije\nOtkljucaj/Zakljucaj\nProdaj kucu\nLociraj");
    SPD(playerid, DIALOG_KUCA, DIALOG_STYLE_LIST, "KUCA", string, "DALJE", "IZLAZ");
	return 1;
}
//----------------------------------------------------------
CMD:kupikucu(playerid, params[])
{
    for(new i; i < sizeof(KI); i++)
	{
    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, KI[i][PosX], KI[i][PosY], KI[i][PosZ])) return GRESKA(playerid, "Niste pored kuce.");
   		if(strcmp(KI[i][ImeVlasnika], "Niko", true) && KI[i][Vlasnik] == 0) return GRESKA(playerid, "Ova kuca nije na prodaju.");
		if(PI[playerid][pKuca] != -1) return GRESKA(playerid, "Vi vec posedujete kucu.");
		if(PI[playerid][pLevel] < KI[i][Level]) return GRESKA(playerid, "Morate biti %d level za kupovinu ove kuce.", KI[i][Level]);
		if(PI[playerid][pNovac] < KI[i][Cena]) return GRESKA(playerid, "Morate imati kod sebe %d$ za kupovinu ove kuce.", KI[i][Cena]);
		strmid(KI[i][ImeVlasnika], GetName(playerid), 0, strlen(GetName(playerid)), 255);
		KI[i][Vlasnik] = 1;
		PI[playerid][pKuca] = i;
		KI[i][Zakljucano] = 0;
		NovacMinus(playerid, KI[i][Cena]);
		RefreshKuce(i);
		SacuvajKucu(i);
		SACC(playerid);
		SCM(playerid,-1, "Uspesno ste kupili kucu, za kontrolu nad kucom koristite /kuca.");
		return 1;
	}
    return 1;
}
//----------------------------------------------------------
CMD:nkucu(playerid, params[],help)
{
	if(PI[playerid][pAdmin] < 7) return GRESKA(playerid, "Nemas ovlascenje za ovu komandu!");
	new Float:X, Float:Y, Float:Z, string[400];
	GetPlayerPos(playerid,X,Y,Z);
	new id = SledeciIDKuce();
	if(id >= MAX_KUCA) return GRESKA(playerid, "Povecaj limit kuca!");
 	KI[id][EntPosX] = 235.508994;
	KI[id][EntPosY] = 1189.169897;
	KI[id][EntPosZ] = 1080.339966;
	KI[id][Int] = 1;
	KI[id][Cena] = 50000;
	KI[id][Level] = 3;
	KI[id][PosX] = X;
    KI[id][PosY] = Y;
	KI[id][PosZ] = Z;
	KI[id][Vlasnik] = 0;
	KI[id][Zakljucano] = 1;
	KI[id][VW] = id;
	SacuvajKucu(id);
    strmid(KI[id][ImeVlasnika],"Niko",0,strlen("Niko"),255);
    format(string,sizeof(string),"Kuca na Prodaju (ID: %d)\nCena: %d\nLevel: %d\nZa kupovinu /kupikucu", id, KI[id][Cena], KI[id][Level]);
    KucaLabel[id] = CreateDynamic3DTextLabel(string ,-1,X,Y,Z,25,0,1);
    KucaPickup[id] = CreateDynamicPickup(1273, 1, KI[id][PosX], KI[id][PosY], KI[id][PosZ]);
	ASCM(playerid, "Kreirao si kucu.");
	return 1;
}
//----------------------------------------------------------
hook OnGameModeInit()
{
    for(new id = 0; id < sizeof(KI); id++)
    {
        new file[50], string[400];
        format(file, sizeof(file), KUCE_FILE, id);
        if(fexist(file))
        {
            INI_ParseFile(file, "UcitajKuce", .bExtra = true, .extra = id);
            if(KI[id][Vlasnik] == 0)
	        {
        	    format(string,sizeof(string),"Kuca na Prodaju (ID: %d)\nCena: %d\nLevel: %d\nZa kupovinu /kupikucu", id, KI[id][Cena], KI[id][Level]);
        	    KucaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,KI[id][PosX],KI[id][PosY],KI[id][PosZ],25,0,1);
        	    KucaPickup[id] = CreateDynamicPickup(1273, 1, KI[id][PosX], KI[id][PosY], KI[id][PosZ]);
        	}
        	else if(KI[id][Vlasnik] == 1)
        	{
				format(string,sizeof(string),"Vlasnik: %s (ID: %d)\nCena: %d\nLevel: %d\nZa kupovinu /kupikucu", KI[id][ImeVlasnika], id, KI[id][Cena], KI[id][Level]);
        	    KucaLabel[id] = CreateDynamic3DTextLabel(string ,0x33CCFFAA,KI[id][PosX],KI[id][PosY],KI[id][PosZ],25,0,1);
        	    KucaPickup[id] = CreateDynamicPickup(1239, 1, KI[id][PosX], KI[id][PosY], KI[id][PosZ]);
        	}
		}
	}
	return 1;
}
//----------------------------------------------------------
hook OnGameModeExit()
{
    for(new id = 0; id <= MAX_KUCA; id++)
	{
		SacuvajKucu(id);
	}
	return 1;
}
//----------------------------------------------------------
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SECONDARY_ATTACK)
	{
		for(new i; i < MAX_KUCA; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, KI[i][PosX], KI[i][PosY], KI[i][PosZ]))
			{
    			if(PI[playerid][pKuca] == i || KI[i][Zakljucano] == 0)
    		   	{
    		   	    SetPlayerInterior(playerid, KI[i][Int]);
                    SetPlayerVirtualWorld(playerid, KI[i][VW]);
                 	SetPlayerPos(playerid, KI[i][EntPosX], KI[i][EntPosY], KI[i][EntPosZ]);
                }
                else return GRESKA(playerid, "Ova kuca je zakljucana.");
			}
            if(IsPlayerInRangeOfPoint(playerid, 2.0, KI[i][EntPosX], KI[i][EntPosY], KI[i][EntPosZ]) && GetPlayerVirtualWorld(playerid) == KI[i][VW])
	        {
             	SetPlayerInterior(playerid, KI[i][Int]);
             	SetPlayerVirtualWorld(playerid, KI[i][VW]);
             	SetPlayerPos(playerid, KI[i][PosX], KI[i][PosY], KI[i][PosZ]);
             	return 1;
            }
		}
	}
	return 1;
}
//----------------------------------------------------------
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
	{
		case DIALOG_KUCA:
		{
			if(!response) return 1;
			if(PI[playerid][pKuca] == -1) return GRESKA(playerid, "Morate posedovati kucu.");
			new i = PI[playerid][pKuca];
			switch(listitem)
			{
				case 0:
				{
				    if(!IsPlayerInRangeOfPoint(playerid, 15.0, KI[i][EntPosX], KI[i][EntPosY], KI[i][EntPosZ])) return GRESKA(playerid, "Morate biti u vasoj kuci.");
					new lock[16];
				    if(KI[i][Zakljucano] == 1) lock = "Zakljucano";
	      			else lock = "Otkljucano";
					SCMF(playerid, -1, " ID: %d | Vlasnik: %s | Level: %d | Zakljucano: %s | Cena: %d", i, KI[i][ImeVlasnika], KI[i][Level], lock, KI[i][Cena]);
				}
				case 1:
				{
				    if(!IsPlayerInRangeOfPoint(playerid, 15.0, KI[i][EntPosX], KI[i][EntPosY], KI[i][EntPosZ])) return GRESKA(playerid, "Morate biti u vasoj kuci.");
				    if(KI[i][Zakljucano] == 0)
				    {
						KI[i][Zakljucano] = 0;
						SacuvajKucu(i);
						SCM(playerid, -1, "Uspesno ste otkljucali vasu kucu.");
					}
					else if(KI[i][Zakljucano] == 1)
					{
					    KI[i][Zakljucano] = 1;
						SacuvajKucu(i);
					    SCM(playerid, -1, "Uspesno ste zakljucali vasu kucu.");
				    }
				}
				case 3:
				{
				    if(!IsPlayerInRangeOfPoint(playerid, 15.0, KI[i][PosX], KI[i][PosY], KI[i][PosZ])) return GRESKA(playerid, "Morate biti ispred vase kuce.");
					NovacPlus(playerid, KI[i][Cena]);
					KI[i][Vlasnik] = 0;
					KI[i][Zakljucano] = 1;
					strmid(KI[i][ImeVlasnika], "Niko", 0, strlen("Niko"), 255);
					PI[playerid][pKuca] = -1;
					SacuvajKucu(i);
					RefreshKuce(i);
					SACC(playerid);
					SCMF(playerid, -1, "Uspesno ste prodali kucu za %d$.", KI[i][Cena]);
				}
				case 4:
				{
				    if(GPSUpaljen[playerid] == 0)
				    {
						SetPlayerCheckpoint(playerid,KI[i][PosX],KI[i][PosY],KI[i][PosZ], 3.0);
						GPSUpaljen[playerid] = 1;
						SCM(playerid, -1, "Locirali ste kucu, crvena kocka na mapi.");
					}
					else if(GPSUpaljen[playerid] == 1)
					{
					    GPSUpaljen[playerid] = 0;
						SCM(playerid, -1, "Prekinuli ste lociranje vase kuce.");
						DisablePlayerCheckpoint(playerid);
					}
				}
			}
		}
	}
	return 1;
}
//----------------------------------------------------------
