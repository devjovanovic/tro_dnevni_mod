// Register i Login system kreiran od strane Jovanovica 30.12.2020.
#include <YSI\y_hooks>

//----------------------------------------------------------
#define IGRACIFILE "/Igraci/%s.ini"
enum pInfo
{
    pPass,
    pLevel,
    pIskustvo,
    pPol,
    pGodine,
    pNovac,
    pBanka,
    pAdmin,
    pTutorijal,
    pSkin,
    pWarn,
    pSpawn,
    pKuca,
    pFirma,
    pMobilni
}
new PI[MAX_PLAYERS][pInfo];
new TutTimer[MAX_PLAYERS];

//----------------------------------------------------------
function Tutorijal(playerid, stepentuta)
{
	if(stepentuta == 1)
	{
		if(PI[playerid][pTutorijal] == 1) return TutTimer[playerid] = SetTimerEx("Tutorijal", 1000, false, "ii", playerid, 5);
	    KillTimer(TutTimer[playerid]);
		InterpolateCameraPos(playerid, 1423.301757, -1703.885253, 23.241132, 1504.572631, -1675.111206, 19.247322, 10000);
		InterpolateCameraLookAt(playerid, 1423.236328, -1708.860107, 22.744037, 1509.568969, -1675.221557, 19.090316, 10000);
	    SCM(playerid, -1, ""ZUTA"[TUTORIJAL]: "BELA"Prikazani su vam opstina i policija, ovo su dve najvanije lokacije!");
	    TutTimer[playerid] = SetTimerEx("Tutorijal", 9000, false, "ii", playerid, 2);
	}
	else if(stepentuta == 2)
	{
	    KillTimer(TutTimer[playerid]);
	    InterpolateCameraPos(playerid, 1495.728027, -1043.363525, 28.983205, 1426.280151, -1039.416503, 27.037996, 10000);
		InterpolateCameraLookAt(playerid, 1495.819702, -1038.434570, 28.148332, 1426.342163, -1034.417968, 26.933895, 10000);
	    SCM(playerid, -1, ""ZUTA"[TUTORIJAL]: "BELA"Prikazana vam je banka!");
	    TutTimer[playerid] = SetTimerEx("Tutorijal", 9000, false, "ii", playerid, 3);
	}
	else if(stepentuta == 3)
	{
	    KillTimer(TutTimer[playerid]);
	    InterpolateCameraPos(playerid, 1286.897338, -923.150573, 64.541236, 1170.529418, -956.407470, 52.256179, 10000);
		InterpolateCameraLookAt(playerid, 1285.596801, -918.500366, 63.243564, 1172.596313, -952.017761, 51.048507, 10000);
	    SCM(playerid, -1, ""ZUTA"[TUTORIJAL]: "BELA"Prikazan vam je burg mesto zabave!");
	    TutTimer[playerid] = SetTimerEx("Tutorijal", 9000, false, "ii", playerid, 4);
	}
	else if(stepentuta == 4)
	{
	    KillTimer(TutTimer[playerid]);
	    InterpolateCameraPos(playerid, 1278.715698, -946.563049, 59.636783, 1423.409423, -888.945129, 58.239036, 10000);
		InterpolateCameraLookAt(playerid, 1280.521118, -941.933959, 59.078056, 1423.532958, -883.964538, 58.661247, 10000);
	    SCM(playerid, -1, ""ZUTA"[TUTORIJAL]: "BELA"Kraj tutorijala!");
	    TutTimer[playerid] = SetTimerEx("Tutorijal", 9000, false, "ii", playerid, 5);
	}
	else if(stepentuta == 5)
	{
	    KillTimer(TutTimer[playerid]);

		PI[playerid][pTutorijal] = 1;
		SetCameraBehindPlayer(playerid);
		SetSpawnInfo(playerid, 0, 0, 1481.0356,-1772.1704,18.7958, 0.0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		new dobrodosli[248];
		va_format(dobrodosli, sizeof(dobrodosli), ""BELA"Dobro dosli %s na "ZUTA"Casa Campo RolePlay"BELA".\nVas trenutni stats je\nLevel: %d\nIskustvo: %d/%d\nNovac: %d$", GetName(playerid), PI[playerid][pLevel], PI[playerid][pIskustvo], PI[playerid][pNovac]);
		SPD(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX,  ""ZUTA"DOBRO DOSLI", dobrodosli, ""ZUTA"OK", "");
	}
	return 1;
}
//----------------------------------------------------------
function LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PI[playerid][pPass]);
    INI_Int("Level",PI[playerid][pLevel]);
    INI_Int("Iskustvo",PI[playerid][pIskustvo]);
    INI_Int("Pol",PI[playerid][pPol]);
    INI_Int("Godine",PI[playerid][pGodine]);
    INI_Int("Novac",PI[playerid][pNovac]);
    INI_Int("Banka",PI[playerid][pBanka]);
    INI_Int("Admin",PI[playerid][pAdmin]);
    INI_Int("Tutorijal",PI[playerid][pTutorijal]);
    INI_Int("Skin",PI[playerid][pSkin]);
    INI_Int("Warn",PI[playerid][pWarn]);
    INI_Int("Spawn",PI[playerid][pSpawn]);
    INI_Int("Kuca",PI[playerid][pKuca]);
    INI_Int("Firma",PI[playerid][pFirma]);
    INI_Int("Mobilni",PI[playerid][pMobilni]);
    return 1;
}
//----------------------------------------------------------
function SACC(playerid)
{
	new INI:File = INI_Open(PlayerPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Novac",GetPlayerMoney(playerid));
    INI_WriteInt(File,"Banka",PI[playerid][pBanka]);
    INI_WriteInt(File,"Level",PI[playerid][pLevel]);
    INI_WriteInt(File,"Iskustvo",PI[playerid][pIskustvo]);
    INI_WriteInt(File,"Pol",PI[playerid][pPol]);
    INI_WriteInt(File,"Godine",PI[playerid][pGodine]);
    INI_WriteInt(File,"Admin",PI[playerid][pAdmin]);
    INI_WriteInt(File,"Tutorijal",PI[playerid][pTutorijal]);
    INI_WriteInt(File,"Skin",PI[playerid][pSkin]);
    INI_WriteInt(File,"Warn",PI[playerid][pWarn]);
    INI_WriteInt(File,"Spawn",PI[playerid][pSpawn]);
    INI_WriteInt(File,"Kuca",PI[playerid][pKuca]);
    INI_WriteInt(File,"Firma",PI[playerid][pFirma]);
    INI_WriteInt(File,"Mobilni",PI[playerid][pMobilni]);
    INI_Close(File);
}
//----------------------------------------------------------
stock PlayerPath(playerid)
{
    new string[128], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    format(string, sizeof(string), IGRACIFILE, playername);
    return string;
}
//----------------------------------------------------------
stock udb_hash(buf[])
{
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}
//----------------------------------------------------------
stock GetName(playerid)
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if(pName[i] == '_') pName[i] = ' ';
    }
	return pName;
}
//----------------------------------------------------------
hook OnPlayerConnect(playerid)
{
    if(fexist(PlayerPath(playerid)))
    {
    	InterpolateCameraPos(playerid, -732.346191, 1546.594116, 43.032466, -813.619445, 1557.513671, 30.895584, 10000);
		InterpolateCameraLookAt(playerid, -737.305541, 1546.673461, 42.401340, -808.644714, 1557.228759, 30.481994, 10000);
        new login[248];
        INI_ParseFile(PlayerPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        va_format(login, sizeof(login), ""BELA"Dobro dosli %s na "ZUTA"Casa Campo RolePlay"BELA".\nUnesite vasu lozinku da bi ste pristupili vasem nalogu!", GetName(playerid));
        SPD(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, ""ZUTA"LOGIN", login, ""ZUTA"LOGIN", ""ZUTA"KICK");
    }
    else
    {
    	InterpolateCameraPos(playerid, -732.346191, 1546.594116, 43.032466, -813.619445, 1557.513671, 30.895584, 10000);
		InterpolateCameraLookAt(playerid, -737.305541, 1546.673461, 42.401340, -808.644714, 1557.228759, 30.481994, 10000);
        new reg[248];
        va_format(reg, sizeof(reg), ""BELA"Dobro dosli %s na "ZUTA"Casa Campo RolePlay"BELA".\nVas nalog nije pronadjen unesite vasu lozinku za nastavak registracije!", GetName(playerid));
        SPD(playerid, DIALOG_REGISTRACIJA, DIALOG_STYLE_INPUT, ""ZUTA"REGISTRACIJA - UNOS LOZINKE", reg, ""ZUTA"DALJE", ""ZUTA"KICK");
    }
	return 1;
}
//----------------------------------------------------------
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		//---
        case DIALOG_REGISTRACIJA:
        {
            if(!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext))
                {
                    new reg[248];
			        va_format(reg, sizeof(reg), ""BELA"Dobro dosli %s na "ZUTA"Casa Campo RolePlay"BELA".\nVas nalog nije pronadjen unesite vasu lozinku za nastavak registracije!", GetName(playerid));
			        SPD(playerid, DIALOG_REGISTRACIJA, DIALOG_STYLE_INPUT, ""ZUTA"REGISTRACIJA - UNOS LOZINKE", reg, ""ZUTA"DALJE", ""ZUTA"KICK");
                }
                else
                {
			        SPD(playerid, DIALOG_POL, DIALOG_STYLE_LIST, ""ZUTA"REGISTRACIJA - UNOS POLA", ""BELA"Musko\nZensko", ""ZUTA"DALJE", ""ZUTA"KICK");
				}
			}
        }
        //---
        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid);
            if(response)
            {
                if(udb_hash(inputtext) == PI[playerid][pPass])
                {
                    INI_ParseFile(PlayerPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                    GivePlayerMoney(playerid, PI[playerid][pNovac]);
                    SetPlayerSkin(playerid, PI[playerid][pSkin]);
                	SetCameraBehindPlayer(playerid);
                    new dobrodosli[248];
	                va_format(dobrodosli, sizeof(dobrodosli), ""BELA"Dobro dosli %s na "ZUTA"Casa Campo RolePlay"BELA".\nVas trenutni stats je\nLevel: %d\nIskustvo: %d/%d\nNovac: %d$", GetName(playerid), PI[playerid][pLevel], PI[playerid][pIskustvo], PI[playerid][pNovac]);
	                SPD(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX,  ""ZUTA"DOBRO DOSLI", dobrodosli, ""ZUTA"OK", "");
                }
                else
                {
                    new login[248];
                    va_format(login, sizeof(login), ""BELA"Dobro dosli %s na "ZUTA"Casa Campo RolePlay"BELA".\nUnesite vasu lozinku da bi ste pristupili vasem nalogu!", GetName(playerid));
        			SPD(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, ""ZUTA"LOGIN", login, ""ZUTA"LOGIN", ""ZUTA"KICK");
                }
                return 1;
            }
        }
        //---
        case DIALOG_POL:
        {
            if(!response) return Kick(playerid);
            if(response)
            {
                switch(listitem)
			    {
			        case 0:
					{
				 		PI[playerid][pPol] = 1;
                        SCM(playerid, -1, ""ZUTA"REGISTRACIJA: "BELA"Odabrali ste pol vi ste musko!");
						SPD(playerid, DIALOG_GODINE, DIALOG_STYLE_INPUT, ""ZUTA"REGISTRACIJA - GODINE", ""BELA"Unesite broj vasih godina(Minimalni broj godina 10, maksimalni broj godina 99)!", ""ZUTA"DALJE", ""ZUTA"KICK");
				 	}
			        case 1:
					{
						PI[playerid][pPol] = 2;
						SCM(playerid, -1, ""ZUTA"REGISTRACIJA: "BELA"Odabrali ste pol vi ste zensko!");
						SPD(playerid, DIALOG_GODINE, DIALOG_STYLE_INPUT, ""ZUTA"REGISTRACIJA - GODINE", ""BELA"Unesite broj vasih godina(Minimalni broj godina 10, maksimalni broj godina 99)!", ""ZUTA"DALJE", ""ZUTA"KICK");
					}
			    }
			    return 1;
			}
		}
		//---
  		case DIALOG_GODINE:
    	{
     		if(!response) return Kick(playerid);
            if(response)
            {
            	if(strlen(inputtext) < 0 || strlen(inputtext) > 99)
			 	{
	    			SPD(playerid, DIALOG_GODINE, DIALOG_STYLE_INPUT, ""ZUTA"REGISTRACIJA - GODINE", ""BELA"Unesite broj vasih godina(Minimalni broj godina 10, maksimalni broj godina 99)!", ""ZUTA"DALJE", ""ZUTA"KICK");
			 	}
     			else
     			{
					PI[playerid][pGodine] = strlen(inputtext);
					SCM(playerid, -1, ""ZUTA"REGISTRACIJA: "BELA"Uneli ste da imate %d godina!", PI[playerid][pGodine]);

					TutTimer[playerid] = SetTimerEx("Tutorijal", 1000, false, "ii", playerid, 1);

					new INI:File = INI_Open(PlayerPath(playerid));
			     	INI_SetTag(File,"data");
			     	INI_WriteInt(File,"Password",udb_hash(inputtext));
			     	INI_WriteInt(File,"Level",1);
			     	INI_WriteInt(File,"Iskustvo",0);
			     	INI_WriteInt(File,"Pol",0);
			     	INI_WriteInt(File,"Novac",2000);
			     	INI_WriteInt(File,"Banka",15000);
			     	INI_WriteInt(File,"Admin",0);
			     	INI_WriteInt(File,"Tutorijal",0);
			     	INI_WriteInt(File,"Skin",36);
			     	INI_WriteInt(File,"Warn",0);
			     	INI_WriteInt(File,"Spawn",1);
			     	INI_WriteInt(File,"Kuca",-1);
			     	INI_WriteInt(File,"Firma",-1);
			     	INI_WriteInt(File,"Mobilni",0);
			     	INI_Close(File);

				}
				return 1;
            }
       	}
       	//---
	}
	return 1;
}
//----------------------------------------------------------
