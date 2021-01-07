// Sistem vozila kreiran od strane Jovanovica 1.1.2021.

#include <YSI\y_hooks>

//----------------------------------------------------------
#define MAX_VOZILA     			2000
#define VOZILA_FILE     		"Vozila/%d.ini"
enum vInfo
{
    ID,
    Model,
    ImeVlasnika[26],
    Cena,
    Zakljucan,
    Mod[14],
    Boja1,
    Boja2,
    Float:PosX,
    Float:PosY,
    Float:PosZ,
    Float:PosA,
    Text3D:voziloLabel
};

new VI[MAX_VOZILA][vInfo];
new VoziloID[MAX_PLAYERS];
//----------------------------------------------------------
new VehicleNames[212][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus","Voodoo", "Pony",
    "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero",
    "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy",
    "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad",
    "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
    "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa",
    "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust",
    "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
    "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet",
    "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster A",
    "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower",
    "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer A", "Emperor", "Wayfarer", "Euros",
    "Hotdog", "Club", "Trailer B", "Trailer C", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)", "Police Car (LVPD)", "Police Ranger",
    "Picador", "S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B", "Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
};
//----------------------------------------------------------
stock SledeciIDVozila()
{
	new file[80];
	for(new i = 0; i < MAX_VOZILA; i++)
	{
		format(file,sizeof(file),VOZILA_FILE,i);
		if(!fexist(file)) return i;
	}
	return 1;
}
//----------------------------------------------------------
function UcitajVozila(id, name[], value[])
{
	INI_Int("Model", VI[id][Model]);
	INI_String("Vlasnik", VI[id][ImeVlasnika], 26);
	INI_Float("Lokacija X", VI[id][PosX]);
	INI_Float("Lokacija Y", VI[id][PosY]);
	INI_Float("Lokacija Z", VI[id][PosZ]);
	INI_Float("Rotacija A", VI[id][PosA]);
	INI_Int("Zakljucan", VI[id][Zakljucan]);
	INI_Int("Boja1", VI[id][Boja1]);
	INI_Int("Boja2", VI[id][Boja2]);
	INI_Int("Model", VI[id][Model]);
	INI_Int("Mod0", VI[id][Mod][0]);
	INI_Int("Mod1", VI[id][Mod][1]);
	INI_Int("Mod2", VI[id][Mod][2]);
	INI_Int("Mod3", VI[id][Mod][3]);
	INI_Int("Mod4", VI[id][Mod][4]);
	INI_Int("Mod5", VI[id][Mod][5]);
	INI_Int("Mod6", VI[id][Mod][6]);
	INI_Int("Mod7", VI[id][Mod][7]);
	INI_Int("Mod8", VI[id][Mod][8]);
	INI_Int("Mod9", VI[id][Mod][9]);
	INI_Int("Mod10", VI[id][Mod][10]);
	INI_Int("Mod11", VI[id][Mod][11]);
	INI_Int("Mod12", VI[id][Mod][12]);
	INI_Int("Mod13", VI[id][Mod][13]);
	return 1;
}
//----------------------------------------------------------
stock SacuvajVozilo(id)
{
	new file[128];
    format(file, sizeof(file), VOZILA_FILE, id);
	new INI:File = INI_Open(file);
	INI_WriteInt(File, "Model", VI[id][Model]);
	INI_WriteString(File, "Vlasnik", VI[id][ImeVlasnika]);
	INI_WriteFloat(File, "Lokacija X", VI[id][PosX]);
	INI_WriteFloat(File, "Lokacija Y", VI[id][PosY]);
	INI_WriteFloat(File, "Lokacija Z", VI[id][PosZ]);
	INI_WriteFloat(File, "Rotacija A", VI[id][PosA]);
	INI_WriteInt(File, "Zakljucan", VI[id][Zakljucan]);
	INI_WriteInt(File, "Boja1", VI[id][Boja1]);
	INI_WriteInt(File, "Boja2", VI[id][Boja2]);
	INI_WriteInt(File, "Model", VI[id][Model]);
	INI_WriteInt(File, "Mod0", VI[id][Mod][0]);
	INI_WriteInt(File, "Mod1", VI[id][Mod][1]);
	INI_WriteInt(File, "Mod2", VI[id][Mod][2]);
	INI_WriteInt(File, "Mod3", VI[id][Mod][3]);
	INI_WriteInt(File, "Mod4", VI[id][Mod][4]);
	INI_WriteInt(File, "Mod5", VI[id][Mod][5]);
	INI_WriteInt(File, "Mod6", VI[id][Mod][6]);
	INI_WriteInt(File, "Mod7", VI[id][Mod][7]);
	INI_WriteInt(File, "Mod8", VI[id][Mod][8]);
	INI_WriteInt(File, "Mod9", VI[id][Mod][9]);
	INI_WriteInt(File, "Mod10", VI[id][Mod][10]);
	INI_WriteInt(File, "Mod11", VI[id][Mod][11]);
	INI_WriteInt(File, "Mod12", VI[id][Mod][12]);
	INI_WriteInt(File, "Mod13", VI[id][Mod][13]);
	INI_Close(File);
	return 1;
}
//----------------------------------------------------------
GetVehicleName(modelid) {

    new string[20];
    format(string,sizeof(string),"%s",VehicleNames[modelid - 400]);
    return string;
}
//----------------------------------------------------------
hook OnGameScriptInit()
{
    for(new i = 1; i < MAX_VOZILA; i++)
	{
	    new file[50], string[128];
        format(file, sizeof(file), VOZILA_FILE, i);
        if(fexist(file))
		{
		    INI_ParseFile(file, "UcitajVozila", .bExtra = true, .extra = i);
		    if(!strcmp(VI[i][ImeVlasnika], "-"))
			{
		    	VI[i][ID] = CreateVehicle(VI[i][Model], VI[i][PosX], VI[i][PosY], VI[i][PosZ], VI[i][PosA], VI[i][Boja1], VI[i][Boja2], 10);
			    format(string, sizeof(string), "Vozilo marke: %s\nCena: %d$\nDa kupite vozilo udjite u njega.", GetVehicleName(VI[i][Model]), VI[i][Cena]);
    			VI[i][voziloLabel] = CreateDynamic3DTextLabel(string, -1, VI[i][PosX], VI[i][PosY], VI[i][PosZ], 10.0, INVALID_PLAYER_ID, VI[i][ID]);
		     	return 1;
			}
		}
	}
	return 1;
}
//----------------------------------------------------------
hook OnGameScriptExit()
{
	for(new i = 1; i < MAX_VOZILA; i++)
	{
		SacuvajVozilo(i);
    }
	return 1;
}
//----------------------------------------------------------
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	switch(dialogid) {

		case DIALOG_KUPOVINAVOZILA: {

            if(response) {

                new i = VoziloID[playerid];
                if(PI[playerid][pNovac] < VI[i][Cena]) return GRESKA(playerid, "Nemate dovoljno novca.");
                if(strcmp(VI[i][ImeVlasnika], "-")) return GRESKA(playerid, "Ovo vozilo vec ima vlasnika.");

                DestroyDynamic3DTextLabel(VI[i][voziloLabel]);
                SetVehicleToRespawn(VI[i][ID]);

                NovacMinus(playerid, -VI[i][Cena]);
                GetName(playerid);

                SetVehicleParamsForPlayer(VI[i][ID], playerid, 0, 0);
                VI[i][Zakljucan] = 0;

                format(VI[i][ImeVlasnika], MAX_PLAYER_NAME, GetName(playerid));

                //SacuvajVozilo(i);
                return 1;
            }
        }
        case DIALOG_VOZILA:
		{
            if(response)
			{
                new count = 0;
                for(new i = 1; i < MAX_VOZILA; i++)
				{
                    if(!strcmp(VI[i][ImeVlasnika], GetName(playerid)))
					{
                        if(count == listitem)
						{
							VoziloID[playerid] = i;
                            SPD(playerid, DIALOG_VOZILA2, DIALOG_STYLE_LIST, "VOZILO", "Parkiraj\nOtkljucaj/Zakljucaj", "Select", "Close");
                            break;
                        }
                        else count++;
                    }
                }
            }
        }
        case DIALOG_VOZILA2:
		{
            if(response)
			{
                switch(listitem)
				{
                    case 0:
					{
                        new i = VoziloID[playerid];
            			if(!strcmp(VI[i][ImeVlasnika], GetName(playerid)))
						{
							new Float:X, Float:Y, Float:Z, Float:A;
							GetPlayerPos(playerid, X, Y, Z);
							GetPlayerFacingAngle(playerid, A);
							VI[i][PosX] = X;
							VI[i][PosY] = Y;
							VI[i][PosZ] = Z;
							VI[i][PosA] = A;
							SCM(playerid, -1, "Uspesno ste parkirali vase vozilo/");
						}
						else return GRESKA(playerid, "Ne mozete parkirati tudje vozilo.");
                    }
                    case 1:
					{
                        new i = VoziloID[playerid], engine, lights, alarm, doors, bonnet, boot, objective;
						GetVehicleParamsEx(VoziloID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
						if(doors == 0)
						{
	                        foreach(new p : Player)
							{
								if(p != playerid)
								{
									SetVehicleParamsForPlayer(VI[i][ID], p, 0, 1);
								}
							}
	                        VI[i][Zakljucan] = 1;
	                        //SacuvajVozilo(i);
	                        SCM(playerid, -1, "Uspesno ste zakljucali vozilo.");
                        }
                        else if(doors == 1)
                        {
                            foreach(new p : Player)
	                        {
								if(p != playerid)
								{
									SetVehicleParamsForPlayer(VI[i][ID], p, 0, 0);
								}
							}
	                        VI[i][Zakljucan] = 0;
	                        //SacuvajVozilo(i);
	                        SCM(playerid, -1, "Uspesno ste zakljucali vozilo.");
                        }
                    }
                }
            }
        }
	}
	return 0;
}
//----------------------------------------------------------
hook OnVehicleMod(playerid, vehicleid, componentid)
{
	for(new i = 1; i < MAX_VOZILA; i++)
	{
        if(IsPlayerInVehicle(playerid, VI[i][ID]))
		{
            if(!strcmp(VI[i][ImeVlasnika], GetName(playerid)))
			{
                for(new x; x < 14; x++)
				{
                    if(GetVehicleComponentType(componentid) == x)
					{
                        VI[i][Mod][x] = componentid;
                    }
                }
                //SacuvajVozilo(i);
            }
        }
    }
	return 1;
}
//----------------------------------------------------------
hook OnVehicleSpawn(vehicleid)
{
    foreach(new playerid : Player)
	{
        for(new i = 1; i < MAX_VOZILA; i++)
		{
            for(new x = 0; x < 14; x++)
			{
                if(!strcmp(VI[i][ImeVlasnika], GetName(playerid)))
				{
                    if(VI[i][Mod][x] > 0)
					{
						AddVehicleComponent(VI[i][ID], VI[i][Mod][x]);
					}
                }
            }
        }
    }
    return 1;
}
//----------------------------------------------------------
hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    for(new i = 1; i < MAX_VOZILA; i++)
		{
		    if(!strcmp(VI[i][ImeVlasnika], "-"))
			{
			    new string[128];
		        VoziloID[playerid] = i;
		        format(string, sizeof(string), "{FFFFFF}Vozilo: %s\nCena: $%s?", GetVehicleName(VI[i][Model]), VI[i][Cena]);
		        SPD(playerid, DIALOG_KUPOVINAVOZILA, DIALOG_STYLE_MSGBOX, "KUPOVINA VOZILA", string, "KUPI", "IZLAZ");
		        return 1;
		    }
	    }
    }
	return 1;
}
//----------------------------------------------------------
CMD:v(playerid, params[])
{
    new bool:found = false, list[512];
    list = "ID\tVozila\n";
    for(new i = 1; i < MAX_VOZILA; i++)
	{
        if(!strcmp(VI[i][ImeVlasnika], GetName(playerid)))
		{
            found = true;
            format(list, sizeof(list), "%s\t%s\n", i, GetVehicleName(VI[i][Model]));
        }
    }
    if(found == true) return SPD(playerid, DIALOG_VOZILA, DIALOG_STYLE_TABLIST_HEADERS, "VOZILA", list, "DALJE", "IZLAZ");
    else return GRESKA(playerid, "Nemate vozila.");
}
//----------------------------------------------------------
CMD:nvozilo(playerid, params[])
{
    if(PI[playerid][pAdmin] < 7) return GRESKA(playerid, "Nemas ovlascenje za ovu komandu!");
    new vehid, b1, b2, cena;
    if(sscanf(params, "iiid", vehid, b1, b2, cena)) return KORISTI(playerid, "/nvozilo [model][boja1][boja2][cena]");
	if(vehid < 400 || vehid > 611) return GRESKA(playerid, "ID-evi vozila idu od 400 do 611.");
	if(cena < 1) return GRESKA(playerid, "Cena vozila mora biti veca od 1.");
    new id = SledeciIDVozila();
    if(id == -1) return GRESKA(playerid, "Dostignut je limit.");
    if(IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));
    GetPlayerPos(playerid, VI[id][PosX], VI[id][PosY], VI[id][PosZ]);
    GetPlayerFacingAngle(playerid, VI[id][PosA]);
    SetPlayerPos(playerid, VI[id][PosX] + 3, VI[id][PosY], VI[id][PosZ]);
    VI[id][ID] = CreateVehicle(vehid, VI[id][PosX], VI[id][PosY], VI[id][PosZ], VI[id][PosA], b1, b2, 10);
    SetVehicleParamsEx(VI[id][ID], 0, 0, 0, 1, 0, 0, 0);
    format(VI[id][ImeVlasnika], MAX_PLAYER_NAME, "-");
    VI[id][Model] = vehid;
    VI[id][Cena] = cena;
    VI[id][Zakljucan] = 0;
    VI[id][Boja1] = b1;
    VI[id][Boja2] = b2;

    new string[128];
    format(string, sizeof(string), "Vozilo marke: %s\nCena: %d$\nDa kupite vozilo udjite u njega.", GetVehicleName(VI[id][Model]), VI[id][Cena]);
    VI[id][voziloLabel] = CreateDynamic3DTextLabel(string, -1, VI[id][PosX], VI[id][PosY], VI[id][PosZ], 10.0, INVALID_PLAYER_ID, VI[id][ID]);
    SCM(playerid, -1, "Uspesno ste kreirali vozilo.");
    return 1;
}
//----------------------------------------------------------
