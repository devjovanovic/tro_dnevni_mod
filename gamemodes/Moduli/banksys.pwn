// Bank system kreiran od strane Jovanovica datuma 30.12.2000

#include <YSI\y_hooks>

//----------------------------------------------------------
stock NovacPlus(playerid, iznos)
{
	GivePlayerMoney(playerid, iznos);
	PI[playerid][pNovac] += iznos;
	return 1;
}
//----------------------------------------------------------
stock NovacMinus(playerid, iznos)
{
	GivePlayerMoney(playerid, -iznos);
	PI[playerid][pNovac] -= iznos;
	return 1;
}
//----------------------------------------------------------
CMD:banka(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 2.0, 0.0000, 0.0000, 0.0000)) return GRESKA(playerid, "Morate biti u banci za salterom!");\
	SPD(playerid, DIALOG_BANKA, DIALOG_STYLE_LIST, "BANKA", "Stanje\nPodigni novac\nOstavi novac\nTransfer novca", "DALJE", "IZLAZ");
	return 1;
}
//----------------------------------------------------------
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_BANKA:
		{
		    if(!response) { SCM(playerid, -1, "Odustali ste od biranja usluge u banci!"); }
	 		else if(response)
			{
				switch(listitem)
				{
				    case 0:
				    {
				        SCMF(playerid, -1, ""ZUTA"[BANKA] "BELA"Stanje na racunu je "ZUTA"%d$", PI[playerid][pBanka]);
				    }
				    case 1:
				    {
				        SPD(playerid, DIALOG_BANKA2, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite kolicinu novca koju zelite da podignete sa racuna.","DALJE","IZLAZ");
				    }
				    case 2:
				    {
				        SPD(playerid, DIALOG_BANKA3, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite kolicinu novca koju zelite da ostavite na racun.","DALJE","IZLAZ");
				    }
				    case 3:
				    {
				        SPD(playerid, DIALOG_BANKA4, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite id i kolicinu novca koju zelite da transferujete na tudji racun.","DALJE","IZLAZ");
				    }
				}
			}
		}
		case DIALOG_BANKA2:
		{
		    if(!response) { SCM(playerid, -1, "Odustali ste od podizanja novca iz banke!"); }
		    else if(response)
		    {
		        new novac;
		        if(sscanf(inputtext, "d", novac)) return SPD(playerid, DIALOG_BANKA2, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite kolicinu novca koju zelite da podignete sa racuna.","DALJE","IZLAZ");
				if(novac > PI[playerid][pBanka]) { SPD(playerid, DIALOG_BANKA2, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite kolicinu novca koju zelite da podignete sa racuna.","DALJE","IZLAZ"); GRESKA(playerid, "Nemate dovoljno novca u banci."); }
		        PI[playerid][pBanka] -= novac;
		        NovacPlus(playerid, novac);
		        SCMF(playerid, -1, ""ZUTA"[BANKA] "BELA"Podigli ste sa vaseg racuna "ZUTA"%d$", novac);
			}
		}
		case DIALOG_BANKA3:
		{
		    if(!response) { SCM(playerid, -1, "Odustali ste od ostavljanja novca u banci!"); }
		    else if(response)
		    {
		        new novac;
		        if(sscanf(inputtext, "d", novac)) return SPD(playerid, DIALOG_BANKA3, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite kolicinu novca koju zelite da ostavite na racuna.","DALJE","IZLAZ");
				if(novac > PI[playerid][pNovac]) { SPD(playerid, DIALOG_BANKA3, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite kolicinu novca koju zelite da ostavite na racuna.","DALJE","IZLAZ"); GRESKA(playerid, "Nemate dovoljno novca kod sebe."); }
		        PI[playerid][pBanka] += novac;
		        NovacMinus(playerid, novac);
		        SCMF(playerid, -1, ""ZUTA"[BANKA] "BELA"Ostavili na vas racun "ZUTA"%d$", novac);
			}
		}
		case DIALOG_BANKA4:
		{
		    if(!response) { SCM(playerid, -1, "Odustali ste od transfera novca!"); }
		    else if(response)
		    {
		        new id, novac;
		        if(sscanf(inputtext, "dd", id, novac)) return SPD(playerid, DIALOG_BANKA4, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite id i kolicinu novca koju zelite da transferujete na tudji racun.","DALJE","IZLAZ");
				if(novac > PI[playerid][pBanka]) { SPD(playerid, DIALOG_BANKA4, DIALOG_STYLE_INPUT, "BANKA",""BELA"Upisite id i kolicinu novca koju zelite da transferujete na tudji racun.","DALJE","IZLAZ"); GRESKA(playerid, "Nemate dovoljno novca za na racunu."); }
				if(id == INVALID_PLAYER_ID) return GRESKA(playerid, "Taj igrac nije na serveru.");
				if(id == playerid) return GRESKA(playerid, "Ne mozete sami sebi slati novac");
				PI[id][pBanka] += novac;
		        PI[playerid][pBanka] -= novac;
		        SCMF(playerid, -1, ""ZUTA"[BANKA] "BELA"Transferovali ste "ZUTA"%d$"BELA" na racun %s,", novac, GetName(id));
		        SCMF(id, -1, ""ZUTA"[BANKA] "BELA"Transferovano vam je "ZUTA"%d$"BELA" na racun %s,", novac, GetName(playerid));
			}
		}
	}
	return 1;
}
//podigni
//ostavi
//transfer
