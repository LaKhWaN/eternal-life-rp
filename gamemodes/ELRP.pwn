/*



// Trading

---- > How it works
?
? : :
? ? : :
? ? ? : :
? ? ? : : :
? ? ? ? : : :

Well;;;;g2777

Eur -> USD // Euro to USD // 1.096 : 1.095
GBP -> USD // GBP to USD // 1.228 : 1.226
USD -> JPY // USD to Japanese // 107.52 : 107.35
USD -> CAD // USD to Canadaian // 1.376 : 1.371
NZD -> USD // New zealand to USD // 0.623 : 0.614
AUD -> USD // AUD to USD // 0.661 : 0.599
XAU -> USD // GOLD // 1709.2 : 1707.2
XAG -> USD // SILVER //


--------------------------- [ELRP BY MILTON & LaKhWaN] ---------------------------
=========================== [ To - DO List ] ===========================

	0. Player System ------------------

	1. Admin System -------------------
	    . Admin Levels:
			. 0: None
			. 1: Helper
			. 2: Trial Admin
			. 3: Senior Admin
			. 4: Head Admin
			. 5: Manager
			. 6: Owner
			. 7: Scripter

	2. Vehicle System -----------------

	3. House System -------------------

	4. Biz System ---------------------

	4. Faction System -----------------

	5. No TOW cmd so mechanic job is used

	6. Do basic systems

	7. Add gate system

=========================== [ Done    List ] ===========================

	1. Added Admins Levels
	2. Added /makeadmin and /omakeadmin
	3. Added Player System
	4. COMMANDS and AHELP cmd added
	5. /v create & /v
	6. /b, /o, /me, /do
	7. /house, /car, /ahouse
	8. /afaction, /faction, /afactory, /ahq added


/ *********************************************************************** /
/ ======================================================================= /

*/


#pragma warning disable 239
#pragma warning disable 214

#include <a_samp>
#include <a_mysql>
#include <zcmd>
#include <streamer>
#include <sscanf2>
#include <a_zones>
#include <mSelection>
#include <YSI_Data\y_iterate>

#define SERVER_GM   	"Eternal Life Roleplay"
#define SERVER_MODE 	"Roleplay"
#define SERVER_VERSION  "1.1b"
#define SERVER_SCRIPTER "Milton & LaKhWaN"


// ======================== [MAX DEFINES] =============================

#undef 		MAX_VEHICLES

// ====================================================================

#define 	MAX_VEHICLES		200
#define 	MAX_HOUSES  		200
#define 	MAX_BUSINESS    	200
#define 	MAX_FACTIONS    	10
#define 	MAX_FACTION_NAME	40
#define 	MAX_GATES			50
#define 	MAX_BANKS           20

// ====================================================================

#define RESIDUE_FEES 1000
#define B_GUNS_FEES     2000

new skinlist = mS_INVALID_LISTID;
new counter_cars = 0;
new tmpobjid;
//new Text:TDEditor_PTD[MAX_PLAYERS][1];

new IsOOCOn = 1;


#define DRUGS_TYPES 			3
#define HOUSE_WEAPON_SLOTS   	2



native WP_Hash(buffer[], len, const str[]);
#define PUBLIC:%0(%1) forward %0(%1); public %0(%1)

// ========================================================================= //

new MySQL:MySQL;


#define mysql_host 													 "localhost"
#define mysql_user 													 "root"
#define mysql_password                                               ""
#define mysql_database 										    	 "lakhwan"

/*

#define mysql_host 													 "127.0.0.1:3306"
#define mysql_user 													 "u7_ngYihBwZuX"
#define mysql_password                                               "D^.FBkv=ABfiwO=7mKiZG.go"
#define mysql_database 										    	 "s7_elrp"

*/

// ========================================================================= //

#define ALTCOMMAND:%1->%2;           \
COMMAND:%1(playerid, params[])   \
return cmd_%2(playerid, params);

#define COLOR_GREY			                                          	0x5D5D5DFF
#define COLOR_WHITE                                                   	0xFFFFFFFF
#define COLOR_BLACK			                                          	0x000000FF
#define COLOR_RED                                                     	0xFF0000FF
#define COLOR_GREEN 													0x33AA33AA
#define COLOR_GOLD 														0xB8860BAA
#define COLOR_SUCCESS                                                   0x33AA33AA

#define COLOR_ACTION        0xC3A3DBAA

#define COLOR_FACTIONCHAT   0
#define COLOR_ADMINCHAT     0xB8860BAA
#define COLOR_SERVERMSG 	0

//CHAT COLORS
#define CWHITE                                                        "{FFFEFF}"
#define CGREEN                                                        "{05E200}"
#define CLIGHTBLUE                                                    "{00FFFA}"
#define CRED                                                          "{FF0000}"
#define CSYNTAX                                                    	  "{CDCDCD}" // Light Grey
#define CYELLOW                                                       "{FFFA00}"

// ========================================================================= //

#define     CANT_USE_CMD        "You are not authorized to use this command."
#define     PNF                 "Player not found."

#define 	MAX_ADMIN_LVLS		8

/*new PlayerText:Speedo_Dynamic_Bar[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:Speedo_Dynamic_Fuel[MAX_PLAYERS][20];
new PlayerText:Speedo_Dynamic_Speed[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:Speedo_Dynamic_SpeedM[MAX_PLAYERS][10];
new PlayerText:Speedo_Dynamic_Fuel_Bar[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};*/

enum e_PlayerData
{
	pID,			// Variable to store the players account ID
	Username[24],		// Variable to store the players Username
	Password[256],		// Variable to store the players Password HASH!
	IPAddress[16],		// Variable to store the players IP Address
	Admin,
	bool:Banned,
	IPBanned,
	BanReason[162],
	Kicks,
	Warns,
	Level,
	Money,
	bankMoney,
	pDrugs[DRUGS_TYPES],
	hasPhone,
	hasSIM,
	hasRadio,
	hasGPS,
	Skin,
	Faction,
	fTier,
	fRank[10],
	Sellables,
	jail,
	jailtime,
	jailreason[162],
 	Text:CarTD,
 	pJob[24],
	//===== BELOW ARE NON SAVED VARIABLES ====//
	bool:pConnecting,
	bool:pLogged,
	pFailedLogins,
	MySQLRaceCheck,
	TogCMDS,
	cuffed,
	tazed,
	pToolkit,
	pGascan,
}
new pData[MAX_PLAYERS][e_PlayerData];

enum e_VehicleData
{
	vModel,
	vOwner[24],
	Float:vX,
	Float:vY,
	Float:vZ,
	Float:vA,
	vVW,
	vInt,
	vColour1,
	vColour2,
	vPaintJob,
	//vFaction,
	//vReserved,
	vSell,
	vLocked,
	vLockedBy,
	Float:vHealth,
	vFuel,
	vFaction,
	//vWeapon[13], // weapon slots...
	//vAmmo[13], // weapon (ammo) slots...
	Float:vMileage,
	vAlarm,
	vPlate[15],
	vRegistered,
	// warehouse
	//vWHLead,
	//vWHMetal,
	// not saved..
	vID,
	vActive,
	vResidue,
	vGuns,
	vToolkit,
	vGascan,
}
new vData[MAX_VEHICLES][e_VehicleData];

enum HouseData
{
	hOwner[24],
	Float:hX,
    Float:hY,
    Float:hZ,
    hInt,
    hVW,
	hAlarm,
	hMoney,
	hInteriorPack,

	hPickupID,
	Text3D:hLabel,
	hActive,

	hLocked,
	hSell,
	hSafe,
	hDrugs [DRUGS_TYPES],
	hGuns [HOUSE_WEAPON_SLOTS],
	hAmmo [HOUSE_WEAPON_SLOTS],
}
new hData[MAX_HOUSES][HouseData];

enum
{
	DRUG_COCAINE,
	DRUG_CANNABIS,
	DRUG_HEROIN,
}

enum drugstypes
{
	drugid, // id
	drugname[24], // name
	drugprice, // FOR DRUG DEALER - SEED
	drughp, // HP it gives
}
new DrugData[DRUGS_TYPES][drugstypes] = {

	{DRUG_CANNABIS, 		"Cannabis",		100,		20}, // 0
    {DRUG_COCAINE, 			"Cocaine",		100,		30}, // 1
    {DRUG_HEROIN, 			"Heroin",		100,		40} // 2
};

enum
{
	BTYPE_BANK, // done
	BTYPE_247,
	BTYPE_CASINO,
	BTYPE_GAS,
	BTYPE_HARDWARE,
	BTYPE_CLUB,
	//BTYPE_PUB,
	//BTYPE_STRIPCLUB,
	BTYPE_AMMU,
	//BTYPE_PIZZA,
	//BTYPE_BURGER,
	//BTYPE_CHICKEN,
	//BTYPE_CAFE,
	BTYPE_CLOTHES,
	BTYPE_RESTAURANT,
	BTYPE_PAYNSPRAY,
	//BTYPE_DRUGFACTORY,
	//BTYPE_GOV,
	//BTYPE_REFINARY,
	//BTYPE_AIRPORT,
	//BTYPE_TAXI,
	//BTYPE_RENT,
	//BTYPE_DRIVER,
	//BTYPE_STADIUM,
	//BTYPE_PAINTBALL,
	//BTYPE_ADTOWER,
	//BTYPE_PHONE,
	//BTYPE_EXPORT,
	//BTYPE_DRUGSTORE,
	//BTYPE_BIKE_DEALER,
	//BTYPE_HEAVY_DEALER,
	//BTYPE_CAR_DEALER,
	//BTYPE_LUXUS_DEALER,
	//BTYPE_NOOB_DEALER,
	//BTYPE_AIR_DEALER,
	//BTYPE_BOAT_DEALER,
	//BTYPE_JOB_DEALER,
	//BTYPE_WHEEL,
	//BTYPE_TOYSTORE,
	//BTYPE_APPARTMENT,
	//BTYPE_HOTEL,
	//BTYPE_VREGISTER,
	//BTYPE_NITRO,
}

enum biz_Lists
{
	biz_T,
	biz_N[50],
}
new BizTypeList[][biz_Lists] = {
//	{BTYPE_BANK, "Bank"},
	{BTYPE_247, "24/7 Store"},
	{BTYPE_CASINO, "Casino"},
//	{BTYPE_GAS, "Gas Station"},
	{BTYPE_HARDWARE, "Hardware Store"},
//	{BTYPE_CLUB, "Night club"},
//	{BUSINESS_TYPE_PUB, "Pub"},
//	{BUSINESS_TYPE_STRIPCLUB, "Strip Club"},
	{BTYPE_AMMU, "Ammunation"},
//	{BUSINESS_TYPE_PIZZA, "Pizza Stack"},
//	{BUSINESS_TYPE_BURGER, "Burger Shot"},
//	{BUSINESS_TYPE_CHICKEN, "Cluckin' Bell"},
//	{BUSINESS_TYPE_CAFE, "Cafe"},
	{BTYPE_CLOTHES, "Clothes Store"}
//	{BTYPE_RESTAURANT, "Restaurant"},
//	{BTYPE_PAYNSPRAY, "Pay 'N' Spray"}
//	{BUSINESS_TYPE_DRUGFACTORY, "Drug Factory"},
//	{BUSINESS_TYPE_GOV, "Government Tax Income"},
//	{BUSINESS_TYPE_REFINARY, "Refinary Income"},
//	{BUSINESS_TYPE_AIRPORT, "Airport"},
//	{BUSINESS_TYPE_TAXI, "Taxi Station"},
//	{BUSINESS_TYPE_RENT, "Vehicle Rent"},
//	{BUSINESS_TYPE_DRIVER, "Driver Business"},
//	{BUSINESS_TYPE_STADIUM, "Stadium Business"},
//	{BUSINESS_TYPE_PAINTBALL, "Paintball"},
//	{BUSINESS_TYPE_ADTOWER, "Advertisement Tower"},
//	{BUSINESS_TYPE_PHONE, "Phone Provider"},
//	{BUSINESS_TYPE_EXPORT, "Vehicle Exports"},
//	{BUSINESS_TYPE_DRUGSTORE, "Drug Store"},
//	{BUSINESS_TYPE_BIKE_DEALER, "Bike Dealership"},
//	{BUSINESS_TYPE_HEAVY_DEALER, "Heavy Dealership"},
//	{BUSINESS_TYPE_CAR_DEALER, "Car Dealership"},
//	{BUSINESS_TYPE_LUXUS_DEALER, "Luxus Dealership"},
//	{BUSINESS_TYPE_NOOB_DEALER, "Noobie Dealership"},
//	{BUSINESS_TYPE_AIR_DEALER, "Air Dealership"},
//	{BUSINESS_TYPE_BOAT_DEALER, "Boat Dealership"},
//	{BUSINESS_TYPE_JOB_DEALER, "Job Dealership"},
//	{BUSINESS_TYPE_WHEEL, "Wheel Mod Shop"},
//	{BUSINESS_TYPE_TOYSTORE, "Toy Store"},
//	{BUSINESS_TYPE_APPARTMENT, "Appartment Complex"},
//	{BUSINESS_TYPE_HOTEL, "Hotel"},
//	{BUSINESS_TYPE_VREGISTER, "Vehicle Register"},
//	{BUSINESS_TYPE_NITRO,"Car Nitro shop"}
};

enum bInteriors
{
	interiorid,
	Float:enterX,
	Float:enterY,
	Float:enterZ,
	Float:enterA,
	enterInt,
	INTprice,
	intType,
}
new BusinessInteriors[][bInteriors] = {
	{0, 	1563.1683,	-2252.9592,	166.2183,	181.1492, 	4, 		0, 	BTYPE_BANK},
	{1, 	-27.3268,	-31.4991,	1003.5573,	357.0238, 	4, 		0, 	BTYPE_247},
	{2,		2019.0660,	1017.8765,	996.8750,	90.02160, 	10, 	0, 	BTYPE_CASINO},
	{3,		-27.3268,	-31.4991,	1003.5573,	357.0238, 	4, 		0, 	BTYPE_GAS},
	{4,		-100.3234,	-24.8766,	1000.7188,	358.9892, 	3, 		0, 	BTYPE_HARDWARE},
	{5,		493.3569,	-24.7790,	1000.6797,	359.9628, 	17, 	0, 	BTYPE_CLUB},
//	{6,		-229.1562,	1401.2476,	27.7656,	270.6783, 	18,		0, 	BTYPE_PUB},
//	{7,		-229.221,	1401.1639,	27.76560,	268.2433, 	3, 		0, 	BTYPE_STRIPCLUB},
	{6,		315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BTYPE_AMMU},
//	{7,		364.8251,	-11.41790,	1001.851,	358.3588,	9,		0,	BTYPE_CHICKEN},
//	{10,	372.2757,	-133.3900,	1001.492,	357.9828,	5,		0,	BTYPE_PIZZA},
	{7,	203.7175,	-50.34860,	1001.804,	358.0455,	1,		0,	BTYPE_CLOTHES},
//	{12,	363.0546,	-75.10130,	1001.507,	314.9304,	10,		0,	BTYPE_BURGER},
//	{13,	460.2277,	-88.58570,	999.5547,	88.72490,	4,		0,	BTYPE_CAFE},
	{8,	453.0318,	-18.14820,	1001.132,	88.45780,	1,		0,	BTYPE_RESTAURANT}
	// ^^^^^^ default interiors - FREE!
//	{15, 	-25.8763,	-141.2666,	1003.5469,	358.4652, 	16, 	0, 	BTYPE_247},
//	{16, 	-30.9616, 	-91.5419, 	1003.5469, 	357.0500, 	18, 	0, 	BTYPE_247},
//	{17, 	6.117700,	-31.5707,	1003.5494,	0.117800, 	10, 	0, 	BTYPE_247},
//	{18, 	-25.8665,	-188.1023,	1003.5469,	0.055200, 	17, 	0, 	BTYPE_247},
	// ******* 24/7 finish
//	{19,	2019.0660,	1017.8765,	996.8750,	90.02160, 	10, 	0, 	BTYPE_CASINO},
//	{20,	2234.0598,	1714.5258,	1012.3828,	181.5783, 	1, 		0, 	BTYPE_CASINO},
	// ******* casino finish
//	{21,	-2240.628,	137.2648,	1035.414,	266.3939, 	6, 		0, 	BTYPE_HARDWARE},
//	{22,	316.4254,	-169.8015,	999.6010,	0.0814, 	6, 		0, 	BTYPE_HARDWARE},
	// ******* hardware finish
//	{23,	-2636.70,	1402.6003,	906.4609,	359.5495, 	3, 		0, 	BTYPE_CLUB},
 	// ******** club finish
//	{24,	501.9083,	-67.7105,	998.7578,	178.9960, 	11, 	0, 	BTYPE_PUB},
//	{25,	681.4684,	-451.5404,	-25.6172,	179.1841, 	1, 		0, 	BTYPE_PUB},
	// ********* pub finish
//	{26,	1204.8899,	-13.6871,	1000.9219,	359.8602, 	2, 		0, 	BTYPE_STRIPCLUB},
//	{27,	-2636.659,	1402.654,	906.4609,	359.9855, 	3, 		0, 	BTYPE_STRIPCLUB},
	// ********* gunstore
//	{28,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BTYPE_AMMU},
//	{29,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BTYPE_AMMU},
//	{30,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BTYPE_AMMU},
//	{31,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BTYPE_AMMU}
//	{32, 	2188.0693,	-1244.7605,	1529.1060,	271.0636,	1,		0,	BTYPE_DRUGSTORE}
};


enum bankInfo{
	bankName[24],
	bankTotalMoney,
	Float:bankX,
	Float:bankY,
	Float:bankZ,
	bankInt,
	bankVW,
	bankInterior,
	bankActive,
	Text3D:bankLabel,
	bankMapIcon,
}
new bankData[MAX_BANKS][bankInfo];

enum bankInteriorData {
	intID,
	Float:bankIntX,
	Float:bankIntY,
	Float:bankIntZ,
	Float:bankIntA,
	bankIntInt,
	bankIntVW,
}
new BankInterior[bankInteriorData] = { 0, 978.3553,764.6108,501.0859,178.4878, 4, 0 };

enum bInfo
{
	bOwner[24],
	bName[52],
	bType,
	Float:bX, // outside
	Float:bY, // outside
	Float:bZ, // outside
	bVW, // outside
	bInt, // outside
	bInteriorPack,
	//bLevel,
	bSell,
	bMoney,
	bLocked,
	bFee,
	// no save
	bActive,
	Text3D:bLabel,
	bMapIcon,
}
new bData[MAX_BUSINESS][bInfo];



enum _Interiors {
	hintpack,
	Float:hintx,
	Float:hinty,
	Float:hintz,
	hinterior,
	hvirtual,
	hprice,
}
new HouseInteriors[][_Interiors] = {
//  intpack     x       	y           z       int     vw      price
	{0,		445.04,		508.86, 	1001.42,	12,		2, 		0     },
	{1,		2807.62,	-1171.90,	1025.57,	8,		15,		100000},
	{2,		27.13,		1341.15,	1084.38,	10,		20,		100000},
	{3,		2333.11,	-1075.10,	1049.02,	6,		17,		100000},
	{4,		261.00, 	1286.00, 	1080.2600, 	4,		1,		100000},
	{5,		2350.34,	-1181.65,	1027.98,	5,		16,		100000},
	{6,		2268.39,	-1210.45,	1047.75,	10,		18,		100000},
	{7,		318.57,		1118.21,	1083.88,	5,		19,		100000},
	{8,		219.34,		1251.26,	1082.15,	2,		4,		100000},
	{9,		295.34,		1473.09,	1080.26,	15,		3,		100000},
	{10,	447.73,		1400.44,	1084.30,	2,		8,		100000},
	{11,	2282.91,	-1138.29,	1050.90,	11,		14,		100000},
	{12,	83.30,		1324.70,	1083.86,	9,		11,		100000},
	{13,	2194.79,	-1204.35,	1049.02,	6,		12,		100000},
	{14,	2365.30,	-1132.92,	1050.88,	8,		13,		100000},
	{15,	227.72,		1114.39,	1080.99,	5,		9,		100000},
	{16,	225.74,		1024.54,	1084.00,	7,		10,		100000},
	{17,	1261.4819,	-785.4633,	1091.9063,	9,		11,		100000}
};

enum adminlevels { adlvl, adlvlname[40] }
new AdminLvls[MAX_ADMIN_LVLS][adminlevels] = {
	{0, "Player"},
	{1, "Helper"},
	{2, "Trail Admin"},
	{3, "Senior Admin"},
	{4, "Head Admin"},
	{5, "Manager"},
	{6, "Owner"},
	{7, "Scripter"}
};



new Float:PrisonCells[][3] =
{
    {377.9175,182.5063,889.5491}, // Cell ID 0
	{383.4862,182.4703,889.5491}, // Cell ID 1
	{388.8247,182.3085,889.5491}, // Cell ID 2
	{394.2729,160.5242,889.5491}, // Cell ID 3
	{388.5340,160.3431,889.5491}, // Cell ID 4
	{383.2203,160.9012,894.7221}, // Cell ID 5
	{388.3102,160.5569,894.7224}, // Cell ID 6
	{393.4509,160.1735,894.7227}, // Cell ID 7
	{389.1766,181.5983,894.6671}, // Cell ID 8
	{383.0786,182.3985,894.6537}, // Cell ID 9
	{377.1996,182.3003,894.6554} // Cell ID 10
};

enum
{
	b247_PHONE,
	b247_RADIO,
	b247_SIM,
	b247_GPS,
}

enum b247items
{
	b247id,
	b247name[40],
	b247price
}
new b247Items[][b247items] = {

	{b247_PHONE, 	"Mobile Phone", 		10000},
	{b247_RADIO, 	"Portable Radio", 		5000},
	{b247_SIM, 		"SIM Card", 			2500},
	{b247_GPS,		"GPS Device", 			20000}

};

enum {
	HARDWARE_TOOLKIT,
}

enum hardwareItemsEnum {
	hardwareItemID,
	hardwareName[24],
	hardwarePrice
}

new hardwareItems[][hardwareItemsEnum] = {
	{HARDWARE_TOOLKIT, "Vehicle Toolkit", 10000}
};

enum
{
	AMMU_DEAGLE,
	AMMU_M4,
	AMMU_SHOTGUN,
	AMMU_SNIPER,
}

enum ammuitems
{
	ammuid,
	ammuname[40],
	ammuprice,
	ammuwepid,
	ammuammo,
}
new AmmuItems[][ammuitems] = {
	{AMMU_DEAGLE,		"Desert Eagle", 		5000,		24, 		50},
	{AMMU_M4,			"M4A1",					8000,		31,			80},
	{AMMU_SHOTGUN,		"Pump Action Shotgun", 	12000,		27,			20},
	{AMMU_SNIPER,		"Sniper Rifle", 		21000,		34,			10}
};

enum
{
	FACTION_CIV,
	FACTION_LEGAL,
	FACTION_POLICE,
	FACTION_ILLEGAL,
}


enum faclisttype
{
	fac_T,
	fac_N[40],
}
new FacTypeList[][faclisttype] = {
	{FACTION_LEGAL,		"Legal (GOVT)"},
	{FACTION_POLICE,	"Police"},
	{FACTION_ILLEGAL,	"Illegal"}
};

enum fInteriors
{
	finteriorid,
	Float:enterX,
	Float:enterY,
	Float:enterZ,
	Float:enterA,
	enterInt,
	facType,
}
new FactionInteriors[][fInteriors] = {
	{0, 	384.808624,173.804992,1008.382812,	181.1492, 	3, 	FACTION_LEGAL},
	{1, 	246.375991,109.245994,1003.218750,	357.0238, 	10, 	FACTION_POLICE},
	{2, 	2324.419921,-1145.568359,1050.710083,	181.1492, 	12, 	FACTION_ILLEGAL}
};

enum facdata
{
	fName[MAX_FACTION_NAME],
	fType,
//	fGangZoneColour,
	fColour,
//	bool:fTogColour,
	fChat,
	fPoints,
	fMaxVehicles,
	fMaxMemberSlots,
	fStartPayment,
//	fStartrank[MAX_FACTION_RANK],
	fLeader[24],
//	fMOTD[MAX_FMOTD],
	fBank,
	fFreq,

	// HQ Auto created where you create faction
	Float:fhX, //
	Float:fhY,
	Float:fhZ,
	Float:fhA,
	fInt,
	fVW,

	fInteriorPack,

    Float:fInX, //
	Float:fInY,
	Float:fInZ,
	Float:fInA,
	fInInt,
	fInVW,

	fOpen,

	// Factory
	Float:fFX, //
	Float:fFY,
	Float:fFZ,
	Float:fFA,
	fFInt,
	fFVW,
	fFOpen, // is open or close
	fFSellables,
	fFGunParts, /// gun parts which prodcues guns
	fFMoney, // if has money, else no shit produce


	//no save
	fActive,
	fFTimer, // timer which keeps making thingss
	Text3D:fLabel,
	fPickup,
	Text3D:fFLabel,
}
new fData[MAX_FACTIONS][facdata];



enum
{
	CP_IMPORT,
	CP_TRUCKER,
	CP_TAXI,
	CP_GUNSMITH,
}

enum coords
{
	coid,
	Float:cox,
	Float:coy,
	Float:coz,
	interior,
	vw,
}

enum cpcoords
{
	coid,
	Float:cox,
	Float:coy,
	Float:coz,
	interior,
	vw,
	cpID,
}

new mCheckpoints[][cpcoords] = {
	{CP_IMPORT,     2091.6494,	-52.7551,	1.3207,     	0,      0}, // import export
	{CP_GUNSMITH, 	2351.2266,	-654.1318,	128.0547,		0,		0}
};

enum
{
	OBJ_RESIDUE,
	OBJ_BROKENGUNS,
}

enum floatingobjenum
{
	oinfoid,
	oplacename[256],
	oinfomsg[256],
	Float:olocation_x,
	Float:olocation_y,
	Float:olocation_z,
	icontype,
	pickupID,
}
new objfloat[][floatingobjenum] = {
	{OBJ_RESIDUE,		"GunPartsResidue",		"~w~Illegal Guns Parts Residue~n~~r~/loadresidue~n~",									889.5781,-24.3816,62.8002,355},
    {OBJ_BROKENGUNS,		"BrokenGuns",			"~w~Illegal Broken Guns~n~~r~/loadguns~n~",												-539.9718,-74.3120,62.4302,355}
};


enum PDStocks
{
	pdGuns,
	Float:pdX,
	Float:pdY,
	Float:pdZ,
	pdInt,
	pdVW,
	Text3D:pdLabel,
}
new PDStock[][PDStocks] = {
	{100, 2262.9600,-101.0336,25.9138, 0, 0}
};


enum importcarpos
{
	impid,
    Float:posX,
	Float:posY,
	Float:posZ,
	Float:posA,
	isUsed,
}

new ImportCarPos[][importcarpos] = {
	{0,	2106.0486,	-20.7157,	0.8994,	179.9366, 0},
	{1,	2108.9890,	-20.8521,	0.9000,	179.8936, 0},
	{2,	2111.7461,	-20.7012,	0.8993,	179.9345, 0},
	{3,	2115.0281,	-20.7162,	0.8997,	179.9695, 0},
	{4,	2118.5894,	-20.6278,	0.8997,	179.9532, 0},
	{5,	2122.2727,	-20.7740,	0.8998,	179.8286, 0},
	{6,	2125.3118,	-20.8818,	0.9000,	179.8884, 0}
};


enum    _:e_gatestates
{
	GATE_STATE_CLOSED,
	GATE_STATE_OPEN
}

#define     GATE_PASS_LEN   	8
#define     MOVE_SPEED          (1.65)

enum gatesd
{
	GateModel,
	GatePassword[GATE_PASS_LEN],
	Float: GatePos[3],
	Float: GateRot[3],
	Float: GateOpenPos[3],
	Float: GateOpenRot[3],
	GateState,
	bool: GateEditing,
	GateObject,
	Text3D: GateLabel,
	gActive,
}
new GateData[MAX_GATES][gatesd],
	Iterator: Gates<MAX_GATES>,
	EditingGateID[MAX_PLAYERS] = {-1, ...},
	EditingGateType[MAX_PLAYERS] = {-1, ...},
	bool: HasGateAuth[MAX_PLAYERS][MAX_GATES];

new GateStates[2][16] = {"{E74C3C}Closed", "{2ECC71}Open"};


SaveGate(gid)
{
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "UPDATE `gatesdata` SET `Password` = '%e', `X` = '%f', `Y` = '%f', \
	`Z` = '%f', `rX` = '%f', `rY` = '%f', `rZ` = '%f', `OpenX` = '%f', `OpenY` = '%f', \
	`OpenZ` = '%f', `OpenrX` = '%f', `OpenrY` = '%f', `OpenrZ` = '%f' WHERE `ID` = '%i'", GateData[gid][GatePassword],
	GateData[gid][GatePos][0], GateData[gid][GatePos][1], GateData[gid][GatePos][2], GateData[gid][GateRot][0], GateData[gid][GateRot][1],
	GateData[gid][GateRot][2], GateData[gid][GateOpenPos][0], GateData[gid][GateOpenPos][1], GateData[gid][GateOpenPos][2],
	GateData[gid][GateOpenRot][0], GateData[gid][GateOpenRot][1], GateData[gid][GateOpenRot][2], gid);
	mysql_tquery(MySQL, mQuery);
	return 1;
}
DeleteGate(gid)
{
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "DELETE FROM `gatesdata` WHERE `ID` = '%i'", gid);
	mysql_tquery(MySQL, mQuery);
}

enum
{
	NOOB_SPAWN,
	PD_ARMORY,
}
new noobspawn[coords] = {NOOB_SPAWN, 2101.9099, -104.4874, 2.2818, 0, 0};
new PDArmory[coords] = {PD_ARMORY, 11.1, 11.1, 11.1, 0, 0};


IsPlayerAtPDArmory(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5, PDArmory[cox], PDArmory[coy], PDArmory[coz])) return 1;
	return 0;
}
/*
Eur -> USD // Euro to USD // 1.096 : 1.095
GBP -> USD // GBP to USD // 1.228 : 1.226
USD -> JPY // USD to Japanese // 107.52 : 107.35
AUD -> USD // AUD to USD // 0.661 : 0.599
XAU -> USD // GOLD // 1709.2 : 1707.2
XAG -> USD // SILVER // */


/*Uncomment this when it becomes in Use*/
//new Float:IncDec[][1] = {{1.045}, {2.042}, {-1.045}, {-2.042}, {1.234}, {-1.234}, {-0.124}, {0.124}};

new Float:LastPos[MAX_PLAYERS][3];

enum
{
	DIALOG_BANK_DEPOSIT,
	DIALOG_BANK_WITHDRAW,
    DIALOG_IMPORT,
    DIALOG_VEHIMPORT,
    DIALOG_GUNSMITH,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_ADMIN_VEH,
	DIALOG_ADMIN_VEH_MODEL,
	DIALOG_ADMIN_VEH_OWNER,
	DIALOG_ADMIN_VEH_COLOUR,
	DIALOG_ADMIN_VEH_SELL,
	DIALOG_ADMIN_VEH_PLATE,
	DIALOG_PLAYER_CAR,
	DIALOG_PLAYER_CAR_IN,
	DIALOG_PLAYER_VEH,
	DIALOG_ADMIN_HOUSE,
	DIALOG_ADMIN_HOUSE_OWNER,
	DIALOG_ADMIN_HOUSE_SELL,
	DIALOG_ADMIN_HOUSE_INT,
	DIALOG_ADMIN_HOUSE_MONEY,
	DIALOG_PLAYER_HOUSE_OUT,
	DIALOG_PLAYER_HOUSE_SELL,
	DIALOG_PLAYER_HOUSE_ALARM,
	DIALOG_PLAYER_HOUSE_INT,
	DIALOG_PLAYER_HOUSE,
	DIALOG_PLAYER_HOUSE_IN,
	DIALOG_HOUSE_IN_SAFE,
	DIALOG_HOUSE_IN_MONEY,
	DIALOG_HOUSE_IN_DRUGS,
	DIALOG_HOUSE_IN_GUNS,
	DIALOG_HOUSE_MONEY_TAKE,
	DIALOG_HOUSE_MONEY_PUT,
	DIALOG_HOUSE_DRUGS_TAKE,
	DIALOG_HOUSE_DRUGS_PUT,
	DIALOG_HOUSE_GUNS_TAKE,
	DIALOG_HOUSE_GUNS_PUT,
	DIALOG_HOUSE_DRUGS_TAKE0,
	DIALOG_HOUSE_DRUGS_TAKE1,
	DIALOG_HOUSE_DRUGS_TAKE2,
	DIALOG_HOUSE_DRUGS_PUT0,
	DIALOG_HOUSE_DRUGS_PUT1,
	DIALOG_HOUSE_DRUGS_PUT2,
	DIALOG_ADMIN_BIZ_SELL,
	DIALOG_ADMIN_BIZ_OWNER,
	DIALOG_ADMIN_BIZ_MONEY,
	DIALOG_ADMIN_BIZ_NAME,
    DIALOG_ADMIN_BIZ_FEE,
	DIALOG_ADMIN_BIZ,
	DIALOG_BIZ_CRT,
	DIALOG_PLAYER_BIZ,
	DIALOG_PLAYER_BIZ_INFO,
	DIALOG_PLAYER_BIZ_OUT,
	DIALOG_BIZ_NAME,
	DIALOG_BIZ_SELL,
	DIALOG_BIZ_DETAILS,
	DIALOG_BIZ_NAME1,
	DIALOG_BUY_247,
	DIALOG_BUY_HARDWARE,
	DIALOG_BUY_AMMU,
	DIALOG_CLOSEST_BIZS,
	DIALOG_FACTION_CRT,
	DIALOG_LEADER_FACTION,
	DIALOG_FACTION_NAME,
	DIALOG_FACTION_INVITE,
	DIALOG_FACTION_UNINVITE,
	DIALOG_F_NAME_C,
	DIALOG_OFFLINE_UNINVITE,
	DIALOG_PLAYER_FACTION,
	DIALOG_GATE_PASSWORD,
	DIALOG_GATE_EDITMENU,
	DIALOG_GATE_NEWPASSWORD,
}

new VehicleName[212][] = {
	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
	{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
	{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
	{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
	{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
	{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"MonsterA"},
	{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},{"Speeder"},
	{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},{"Skimmer"},
	{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},{"Sanchez"},
	{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},{"Rustler"},
	{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},{"Baggage"},
	{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
	{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
	{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
	{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
	{"Tanker"},{"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
	{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
	{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},{"Blade"},
	{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},{"Firetruck LA"},
	{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},{"Utility"},
	{"Nevada"},{"Yosemite"},{"Windsor"},{"MonsterB"},{"MonsterC"},{"Uranus"},{"Jester"},{"Sultan"},
	{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},{"Bandito"},
	{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},{"Broadway"},
	{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},{"Tug"},
	{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
	{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},
	{"Police Car (SFPD)"},{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},
	{"Alpha"},{"Phoenix"},{"Glendale"},{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},
	{"Stair Trailer"},{"Boxville"},{"Farm Plow"},{"Utility Trailer"}
};

#if defined FILTERSCRIPT


public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("----------------------------------");
	print(" LVRP by Milton & LaKhWaN");
	print("----------------------------------");
}

#endif






























public OnGameModeInit()
{
	ManualVehicleEngineAndLights();
    ShowPlayerMarkers(0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();


    //mysql_log(ERROR | WARNING); // Set the MySQL logging type
	mysql_log(ALL);
	//connects to MySQL then Make MySQL tables if they do not exist
	MySQL = mysql_connect(mysql_host, mysql_user, mysql_password, mysql_database);

	if(mysql_errno() == 0)
	{
		print("================================================================");
		print("       MySQL has successfully connected to the database         ");
		print("================================================================");
	}
	else
	{
		print("================================================================");
		print("         MySQL has FAILED!!! to connect to the database         ");
		print("================================================================");
		SendRconCommand("exit");
	}

    skinlist = LoadModelSelectionMenu("skins.txt");

	// LOAD SHITS
	LoadVehicles();
	LoadHouses();
	LoadBizs();
	LoadFactions();
	LoadGates();
	LoadBanks();

	//Load maps
	LoadMaps();

	//

	// Timers
	SetTimer("SaveHouses", 30000, true);
	SetTimer("SaveVehicles", 30000, true);
	SetTimer("SaveFactions", 30000, true);
	SetTimer("SaveBizs", 30000, true);
	SetTimer("SavePlayers", 30000, true);
	SetTimer("SaveGates", 30000, true);
    SetTimer("SaveBanks", 30000, true);

	SetTimer("TwentySecTimer", 20000, true);
	SetTimer("FastTimer", 400, true);
	SetTimer("OneSecTimer", 1000, true);

	SetTimer("FuelDown", 30000, true);

	SetTimer("ReloadAllFactoryText", 20000, true);
	SetTimer("ReloadPDStockLabel", 20000, true);

	for(new o; o < sizeof(objfloat); o++) objfloat[o][pickupID] = CreateDynamicPickup(objfloat[o][icontype], 1, objfloat[o][olocation_x], objfloat[o][olocation_y], objfloat[o][olocation_z],-1);
	for(new i = 0; i < sizeof(mCheckpoints); i++) mCheckpoints[i][cpID] = CreateDynamicCP(mCheckpoints[i][cox], mCheckpoints[i][coy], mCheckpoints[i][coz], 2.0, mCheckpoints[i][vw], mCheckpoints[i][interior], -1);



	// Don't use these lines if it's a filterscript
	AddPlayerClass(299, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 0, 0); // CJ
	return 1;
}

LoadPTDs(playerid)
{
    pData[playerid][CarTD] = TextDrawCreate(493.069824, 312.366668, "Speed: 100km/h~n~Mileage: 10000~n~Fuel: 1000~n~Health: 100~n~Status: Locked");
	TextDrawLetterSize(pData[playerid][CarTD], 0.177001, 0.910000);
	TextDrawTextSize(pData[playerid][CarTD], 29.169981, 74.000000);
	TextDrawAlignment(pData[playerid][CarTD], 2);
	TextDrawColor(pData[playerid][CarTD], -1);
	TextDrawUseBox(pData[playerid][CarTD], 1);
	TextDrawBoxColor(pData[playerid][CarTD], 255);
	TextDrawSetShadow(pData[playerid][CarTD], 0);
	TextDrawSetOutline(pData[playerid][CarTD], 0);
	TextDrawBackgroundColor(pData[playerid][CarTD], 255);
	TextDrawFont(pData[playerid][CarTD], 2);
	TextDrawSetProportional(pData[playerid][CarTD], 1);
	TextDrawSetShadow(pData[playerid][CarTD], 0);
}

PUBLIC:SaveGates()
{
	for(new i = 0; i < MAX_GATES; i++)
	{
		if(GateData[i][gActive] !=  1) continue;
		SaveGate(i);
	}
}

PUBLIC:LoadGates()
{
	mysql_tquery(MySQL, "SELECT * FROM `gatesdata`", "OnLoadGates");
}

PUBLIC:OnLoadGates()
{
	if(cache_num_rows())
	{
		new gid;
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name_int(i, "ID", gid);
			cache_get_value_name_int(i, "ModelID", GateData[gid][GateModel]);
			cache_get_value_name(i, "Password", GateData[gid][GatePassword]);
			cache_get_value_name_float(i, "X", GateData[gid][GatePos][0]);
			cache_get_value_name_float(i, "Y", GateData[gid][GatePos][1]);
			cache_get_value_name_float(i, "Z", GateData[gid][GatePos][2]);
			cache_get_value_name_float(i, "rX", GateData[gid][GateRot][0]);
			cache_get_value_name_float(i, "rY", GateData[gid][GateRot][1]);
			cache_get_value_name_float(i, "rZ", GateData[gid][GateRot][2]);
			cache_get_value_name_float(i, "OpenX", GateData[gid][GateOpenPos][0]);
			cache_get_value_name_float(i, "OpenY", GateData[gid][GateOpenPos][1]);
			cache_get_value_name_float(i, "OpenZ", GateData[gid][GateOpenPos][2]);
			cache_get_value_name_float(i, "OpenrX", GateData[gid][GateOpenRot][0]);
			cache_get_value_name_float(i, "OpenrY", GateData[gid][GateOpenRot][1]);
			cache_get_value_name_float(i, "OpenrZ", GateData[gid][GateOpenRot][2]);
			new mlabel[256];
			format(mlabel, sizeof(mlabel), "Gate #%d\n%s", gid, GateStates[GATE_STATE_CLOSED]);
			GateData[gid][GateObject] = CreateDynamicObject(GateData[gid][GateModel], GateData[gid][GatePos][0], GateData[gid][GatePos][1], GateData[gid][GatePos][2], GateData[gid][GateRot][0], GateData[gid][GateRot][1], GateData[gid][GateRot][2]);
			GateData[gid][GateLabel] = CreateDynamic3DTextLabel(mlabel, 0xECF0F1FF, GateData[gid][GatePos][0], GateData[gid][GatePos][1], GateData[gid][GatePos][2], 10.0);
			Iter_Add(Gates, gid);

			GateData[gid][gActive] = 1;
		}
	}
}

PUBLIC:TwentySecTimer()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        SetPlayerMoney(i, pData[i][Money]);
	    }
	}
}

PUBLIC:OneSecTimer()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(pData[i][jail] > 0 && pData[i][jailtime] > 2)
			{
			   	new Float:tmpx, Float:tmpy, Float:tmpz;
			   	GetPlayerPos(i,tmpx,tmpy,tmpz);
			   	if(!IsPlayerAtPrison(i))
				{
					new rid = random(sizeof(PrisonCells));
					SetPlayerPosEx(i, PrisonCells[rid][0],PrisonCells[rid][1],PrisonCells[rid][2], 0, 0, false);
				}
				pData[i][jailtime]=pData[i][jailtime]-1;
			}
			if(pData[i][jail] > 0 && pData[i][jailtime] <= 3)
			{
			    SendClientMessage(i,COLOR_GREEN,"[JAIL] Unjailed");
			    UnJail(i);
			}
		}
	}
}

PUBLIC:FastTimer()
{
	new Float:tmpx, Float:tmpy, Float:tmpz, Float:distance, value, speed;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    GetPlayerPos(i, tmpx, tmpy, tmpz);
			if(!IsPlayerInAnyVehicle(i))
			{
				if(pData[i][tazed]) ApplyAnimation(i,"CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 1); // irl crack!
				TextDrawHideForPlayer(i, pData[i][CarTD]);
			}
			else
			{
			    new carid = GetPlayerVehicleID(i);
				new vehicleid = FindVehicleID(carid);
				distance = floatsqroot(floatpower(floatabs(floatsub(tmpx,LastPos[i][0])),2)+floatpower(floatabs(floatsub(tmpy,LastPos[i][1])),2)+floatpower(floatabs(floatsub(tmpz,LastPos[i][2])),2));
                value = floatround(distance * 5600);
                speed = floatround(value/600);
                new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				if(IsVehicleOccupied(carid) && engine == 1)
				{
					new Float:mileagetoadd = floatround(value/600) / 60;
					vData[vehicleid][vMileage] += mileagetoadd / 60;
				}
				new Float:tmph;
            	GetVehicleHealth(carid, tmph);
            	new mstr[512], isLocked[512];
				if (vData[vehicleid][vLocked] == 1) format(isLocked, 512, "Locked"); else format(isLocked, 512, "Unlocked");
            	format(mstr, sizeof(mstr),"~g~Speed: ~w~%d km/h~n~~g~Mileage: ~w~%dkm~n~~g~Health: ~w~%.0f%%~n~~g~Fuel: ~w~%d%%~n~~g~Status: ~w~%s", speed, floatround(vData[vehicleid][vMileage]), (tmph / 10), vData[vehicleid][vFuel], isLocked);
                TextDrawSetString(pData[i][CarTD], mstr);
				TextDrawShowForPlayer(i, pData[i][CarTD]);

				//UpdatePlayerVehTD(i);

			}

			LastPos[i][0] = tmpx;
			LastPos[i][1] = tmpy;
			LastPos[i][2] = tmpz;
		}
	}
}

LoadFactions()
{
	mysql_pquery(MySQL, "SELECT * FROM `factiondata`", "OnLoadFactions");
}

PUBLIC:OnLoadFactions()
{
	if(cache_num_rows())
	{
	    new fid;
	    for(new i = 0; i < cache_num_rows(); i++)
	    {
	        cache_get_value_name_int(i, "SQLID", fid);
	        cache_get_value_name(i, "Name", fData[fid][fName]);
	        cache_get_value_name_int(i, "Type", fData[fid][fType]);
			cache_get_value_name_int(i, "Colour", fData[fid][fColour]);
            cache_get_value_name_int(i, "Chat", fData[fid][fChat]);
            cache_get_value_name_int(i, "Points", fData[fid][fPoints]);
            cache_get_value_name_int(i, "MaxCars", fData[fid][fMaxVehicles]);
            cache_get_value_name_int(i, "MaxBoys", fData[fid][fMaxMemberSlots]);
            cache_get_value_name_int(i, "StartPay", fData[fid][fStartPayment]);
            cache_get_value_name(i, "Leader", fData[fid][fLeader]);
            cache_get_value_name_int(i, "Bank", fData[fid][fBank]);
            cache_get_value_name_int(i, "Freq", fData[fid][fFreq]);
			cache_get_value_name_float(i, "fX", fData[fid][fhX]);
	        cache_get_value_name_float(i, "fY", fData[fid][fhY]);
	        cache_get_value_name_float(i, "fZ", fData[fid][fhZ]);
	        cache_get_value_name_float(i, "fA", fData[fid][fhA]);
	        cache_get_value_name_int(i, "fVW", fData[fid][fVW]);
	        cache_get_value_name_int(i, "fInt", fData[fid][fInt]);
            cache_get_value_name_int(i, "fOpen", fData[fid][fOpen]);
			cache_get_value_name_int(i, "fInteriorPack", fData[fid][fInteriorPack]);
			cache_get_value_name_float(i, "fInX", fData[fid][fInX]);
	        cache_get_value_name_float(i, "fInY", fData[fid][fInY]);
	        cache_get_value_name_float(i, "fInZ", fData[fid][fInZ]);
	        cache_get_value_name_float(i, "fInA", fData[fid][fInA]);
	        cache_get_value_name_int(i, "fInVW", fData[fid][fInVW]);
	        cache_get_value_name_int(i, "fInInt", fData[fid][fInInt]);
			cache_get_value_name_float(i, "fFX", fData[fid][fFX]);
	        cache_get_value_name_float(i, "fFY", fData[fid][fFY]);
	        cache_get_value_name_float(i, "fFZ", fData[fid][fFZ]);
	        cache_get_value_name_float(i, "fFA", fData[fid][fFA]);
	        cache_get_value_name_int(i, "fFVW", fData[fid][fFVW]);
	        cache_get_value_name_int(i, "fFInt", fData[fid][fFInt]);
	        cache_get_value_name_int(i, "fFOpen", fData[fid][fFOpen]);
	        cache_get_value_name_int(i, "fFGunParts", fData[fid][fFGunParts]);
	        cache_get_value_name_int(i, "fFSellables", fData[fid][fFSellables]);
	        cache_get_value_name_int(i, "fFMoney", fData[fid][fFMoney]);


	        fData[fid][fActive] = 1;

	        KillTimer(fData[fid][fFTimer]);
	        DestroyDynamic3DTextLabel(fData[fid][fLabel]);
	        DestroyDynamicPickup(fData[fid][fPickup]);
	        DestroyDynamic3DTextLabel(fData[fid][fFLabel]);

			fData[fid][fFTimer] = SetTimerEx("FactoryStart", 20000, false, "d", fid);

			new mstr[256], tmpstr[256];
			format(tmpstr, 256, "{667aca}%s's Factory\n", fData[fid][fName]); strcat(mstr, tmpstr);
			format(tmpstr, 256, "{667aca}Gun Parts: {FFFEFF}%i\n", fData[fid][fFGunParts]); strcat(mstr, tmpstr);
			format(tmpstr, 256, "{667aca}Money: {FFFEFF}$%i\n", fData[fid][fFMoney]); strcat(mstr, tmpstr);
			format(tmpstr, 256, "{667aca}Sellables Available: {FFFEFF}%i", fData[fid][fFSellables]); strcat(mstr, tmpstr);
			fData[fid][fFLabel] = CreateDynamic3DTextLabel(mstr, 0x667acaFF, fData[fid][fFX], fData[fid][fFY], fData[fid][fFZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, fData[fid][fFVW], fData[fid][fFInt]);

			format(mstr, 256, "");
			format(tmpstr, 256, "{667aca}%s's HQ\n", fData[fid][fName]); strcat(mstr, tmpstr);
			new open[10];
			if(fData[fid][fOpen] == 1) format(open, 10, "Open"); else format(open, 10, "Closed");
			format(tmpstr, 256, "{667aca}Status: {FFFEFF}%s", open); strcat(mstr, tmpstr);
			fData[fid][fLabel] = CreateDynamic3DTextLabel(mstr, 0x667acaFF, fData[fid][fhX], fData[fid][fhY], fData[fid][fhZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, fData[fid][fVW], fData[fid][fInt]);

            fData[fid][fPickup] = CreateDynamicPickup(1239, 1, fData[fid][fhX], fData[fid][fhY], fData[fid][fhZ], fData[fid][fVW], fData[fid][fInt]);
		}
	}
}

InsertFaction(fid)
{
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "INSERT INTO `factiondata` (`SQLID`, `Name`, `Type`, `Leader`, `fInteriorPack`) VALUES \
	('%i', '%e', '%i', '%e', '%i')", fid, fData[fid][fName], fData[fid][fType], fData[fid][fLeader], fData[fid][fInteriorPack]);
	mysql_tquery(MySQL, mQuery);
}

SaveFaction(fid)
{
	new mQuery[800], mstr[256];
	mysql_format(MySQL, mQuery, 800, "UPDATE `factiondata` SET ");
	mysql_format(MySQL, mstr, 256, "`Name` = '%e', ", fData[fid][fName]); strcat(mQuery, mstr);
	mysql_format(MySQL, mstr, 256, "`Type` = '%i', ", fData[fid][fType]); strcat(mQuery, mstr);
	mysql_format(MySQL, mstr, 256, "`Colour` = '%i', ", fData[fid][fColour]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`Chat` = '%i', ", fData[fid][fChat]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`Points` = '%i', ", fData[fid][fPoints]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`MaxCars` = '%i', ", fData[fid][fMaxVehicles]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`MaxBoys` = '%i', ", fData[fid][fMaxMemberSlots]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`StartPay` = '%i', ", fData[fid][fStartPayment]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`Leader` = '%e', ", fData[fid][fLeader]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`Bank` = '%i', ", fData[fid][fBank]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`Freq` = '%i', ", fData[fid][fFreq]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fX` = '%f', ", fData[fid][fhX]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fY` = '%f', ", fData[fid][fhY]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fZ` = '%f', ", fData[fid][fhZ]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fA` = '%f', ", fData[fid][fhA]); strcat(mQuery, mstr);
	mysql_format(MySQL, mstr, 256, "`fInt` = '%i', ", fData[fid][fInt]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fVW` = '%i', ", fData[fid][fVW]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fOpen` = '%i', ", fData[fid][fOpen]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fInteriorPack` = '%i', ", fData[fid][fInteriorPack]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fInX` = '%f', ", fData[fid][fInX]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fInY` = '%f', ", fData[fid][fInY]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fInZ` = '%f', ", fData[fid][fInZ]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fInA` = '%f', ", fData[fid][fInA]); strcat(mQuery, mstr);
	mysql_format(MySQL, mstr, 256, "`fInInt` = '%i', ", fData[fid][fInInt]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fInVW` = '%i', ", fData[fid][fInVW]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFX` = '%f', ", fData[fid][fFX]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFY` = '%f', ", fData[fid][fFY]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFZ` = '%f', ", fData[fid][fFZ]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFA` = '%f', ", fData[fid][fFA]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFInt` = '%i', ", fData[fid][fFInt]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFVW` = '%i', ", fData[fid][fFVW]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFOpen` = '%i', ", fData[fid][fFOpen]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFGunParts` = '%i', ", fData[fid][fFGunParts]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFSellables` = '%i', ", fData[fid][fFSellables]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "`fFMoney` = '%i' ", fData[fid][fFMoney]); strcat(mQuery, mstr);
    mysql_format(MySQL, mstr, 256, "WHERE `SQLID` = '%i'", fid); strcat(mQuery, mstr);

    mysql_tquery(MySQL, mQuery);

}

PUBLIC:SaveFactions()
{
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
	    if(fData[i][fActive] != 1) continue;
		SaveFaction(i);
	}
}

DeleteFaction(fid)
{
    KillTimer(fData[fid][fFTimer]);
    DestroyDynamic3DTextLabel(fData[fid][fLabel]);
    DestroyDynamicPickup(fData[fid][fPickup]);
    DestroyDynamic3DTextLabel(fData[fid][fFLabel]);
    fData[fid][fActive] = 0;
    new mQuery[256];
    mysql_format(MySQL, mQuery, 256, "DELETE FROM `factiondata` WHERE `SQLID` = '%i'", fid);
    mysql_pquery(MySQL, mQuery);
}

ReloadFaction(fid)
{
	SaveFaction(fid);
    fData[fid][fActive] = 0;
    new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "SELECT * FROM `factiondata` WHERE `SQLID` = '%i' LIMIT 1", fid);
	mysql_tquery(MySQL, mQuery, "OnReloadFaction", "i", fid);

}

PUBLIC:OnReloadFaction(fid)
{
	if(cache_num_rows())
	{

	    cache_get_value_name(0, "Name", fData[fid][fName]);
	    cache_get_value_name_int(0, "Type", fData[fid][fType]);
		cache_get_value_name_int(0, "Colour", fData[fid][fColour]);
	    cache_get_value_name_int(0, "Chat", fData[fid][fChat]);
	    cache_get_value_name_int(0, "Points", fData[fid][fPoints]);
	    cache_get_value_name_int(0, "MaxCars", fData[fid][fMaxVehicles]);
	    cache_get_value_name_int(0, "MaxBoys", fData[fid][fMaxMemberSlots]);
	    cache_get_value_name_int(0, "StartPay", fData[fid][fStartPayment]);
	    cache_get_value_name(0, "Leader", fData[fid][fLeader]);
	    cache_get_value_name_int(0, "Bank", fData[fid][fBank]);
	    cache_get_value_name_int(0, "Freq", fData[fid][fFreq]);
		cache_get_value_name_float(0, "fX", fData[fid][fhX]);
	    cache_get_value_name_float(0, "fY", fData[fid][fhY]);
	    cache_get_value_name_float(0, "fZ", fData[fid][fhZ]);
	    cache_get_value_name_float(0, "fA", fData[fid][fhA]);
	    cache_get_value_name_int(0, "fVW", fData[fid][fVW]);
	    cache_get_value_name_int(0, "fInt", fData[fid][fInt]);
	    cache_get_value_name_int(0, "fOpen", fData[fid][fOpen]);
		cache_get_value_name_int(0, "fInteriorPack", fData[fid][fInteriorPack]);
		cache_get_value_name_float(0, "fInX", fData[fid][fInX]);
        cache_get_value_name_float(0, "fInY", fData[fid][fInY]);
        cache_get_value_name_float(0, "fInZ", fData[fid][fInZ]);
        cache_get_value_name_float(0, "fInA", fData[fid][fInA]);
        cache_get_value_name_int(0, "fInVW", fData[fid][fInVW]);
        cache_get_value_name_int(0, "fInInt", fData[fid][fInInt]);
		cache_get_value_name_float(0, "fFX", fData[fid][fFX]);
	    cache_get_value_name_float(0, "fFY", fData[fid][fFY]);
	    cache_get_value_name_float(0, "fFZ", fData[fid][fFZ]);
	    cache_get_value_name_float(0, "fFA", fData[fid][fFA]);
	    cache_get_value_name_int(0, "fFVW", fData[fid][fFVW]);
	    cache_get_value_name_int(0, "fFInt", fData[fid][fFInt]);
	    cache_get_value_name_int(0, "fFOpen", fData[fid][fFOpen]);
	    cache_get_value_name_int(0, "fFGunParts", fData[fid][fFGunParts]);
	    cache_get_value_name_int(0, "fFSellables", fData[fid][fFSellables]);
	    cache_get_value_name_int(0, "fFMoney", fData[fid][fFMoney]);

	    fData[fid][fActive] = 1;

	    KillTimer(fData[fid][fFTimer]);
	    DestroyDynamic3DTextLabel(fData[fid][fLabel]);
	    DestroyDynamicPickup(fData[fid][fPickup]);
	    DestroyDynamic3DTextLabel(fData[fid][fFLabel]);

		fData[fid][fFTimer] = SetTimerEx("FactoryStart", 20000, false, "d", fid);

		new mstr[256], tmpstr[256];
		format(tmpstr, 256, "{667aca}%s's Factory\n", fData[fid][fName]); strcat(mstr, tmpstr);
		format(tmpstr, 256, "{667aca}Gun Parts: {FFFEFF}%i\n", fData[fid][fFGunParts]); strcat(mstr, tmpstr);
		format(tmpstr, 256, "{667aca}Money: {FFFEFF}$%i\n", fData[fid][fFMoney]); strcat(mstr, tmpstr);
		format(tmpstr, 256, "{667aca}Sellables Available: {FFFEFF}%i", fData[fid][fFSellables]); strcat(mstr, tmpstr);
		fData[fid][fFLabel] = CreateDynamic3DTextLabel(mstr, 0x667acaFF, fData[fid][fFX], fData[fid][fFY], fData[fid][fFZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, fData[fid][fFVW], fData[fid][fFInt]);

		format(mstr, 256, "");
		format(tmpstr, 256, "{667aca}%s's HQ\n", fData[fid][fName]); strcat(mstr, tmpstr);
		new open[10];
		if(fData[fid][fOpen] == 0) format(open, 10, "Open"); else format(open, 10, "Closed");
		format(tmpstr, 256, "{667aca}Status: {FFFEFF}%s", open); strcat(mstr, tmpstr);
		fData[fid][fLabel] = CreateDynamic3DTextLabel(mstr, 0x667acaFF, fData[fid][fhX], fData[fid][fhY], fData[fid][fhZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, fData[fid][fVW], fData[fid][fInt]);

	    fData[fid][fPickup] = CreateDynamicPickup(1239, 1, fData[fid][fhX], fData[fid][fhY], fData[fid][fhZ], fData[fid][fVW], fData[fid][fInt]);

	}
}



PUBLIC:FactoryStart(factionid)
{
	if(fData[factionid][fFGunParts] >= 20)
	{
		if(fData[factionid][fFMoney] > 10000)
		{
			fData[factionid][fFGunParts] -= 20;
			fData[factionid][fFSellables] += 10;
			fData[factionid][fFMoney] -= 500;
		}
		ReloadFaction(factionid);
	}
	return 1;
}

PUBLIC:ReloadAllFactoryText()
{
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
	    if(fData[i][fActive] != 1) continue;
	    ReloadFactoryText(i);
	}
}

PUBLIC:ReloadFactoryText(fid)
{
	DestroyDynamic3DTextLabel(fData[fid][fFLabel]);
    new mstr[256], tmpstr[256];
	format(tmpstr, 256, "{667aca}%s's Factory\n", fData[fid][fName]); strcat(mstr, tmpstr);
	format(tmpstr, 256, "{667aca}Gun Parts: {FFFEFF}%i\n", fData[fid][fFGunParts]); strcat(mstr, tmpstr);
	format(tmpstr, 256, "{667aca}Money: {FFFEFF}$%i\n", fData[fid][fFMoney]); strcat(mstr, tmpstr);
	format(tmpstr, 256, "{667aca}Sellables Available: {FFFEFF}%i", fData[fid][fFSellables]); strcat(mstr, tmpstr);
	fData[fid][fFLabel] = CreateDynamic3DTextLabel(mstr, 0x667acaFF, fData[fid][fFX], fData[fid][fFY], fData[fid][fFZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, fData[fid][fFVW], fData[fid][fFInt]);
}

LoadVehicles()
{
	mysql_pquery(MySQL, "SELECT * FROM `vehicledata`", "OnLoadVehicles");
}


PUBLIC:OnLoadVehicles()
{
	if(cache_num_rows())
	{
	    new vid;
	    for(new i = 0; i < cache_num_rows(); i++)
	    {
	        cache_get_value_name_int(i, "SQLID", vid);
	        cache_get_value_name_int(i, "Model", vData[vid][vModel]);
	        cache_get_value_name(i, "Owner", vData[vid][vOwner]);
	        cache_get_value_name_float(i, "vX", vData[vid][vX]);
	        cache_get_value_name_float(i, "vY", vData[vid][vY]);
	        cache_get_value_name_float(i, "vZ", vData[vid][vZ]);
	        cache_get_value_name_float(i, "vA", vData[vid][vA]);
	        cache_get_value_name_int(i, "vVW", vData[vid][vVW]);
	        cache_get_value_name_int(i, "vInt", vData[vid][vInt]);
	        cache_get_value_name_int(i, "vColour1", vData[vid][vColour1]);
	        cache_get_value_name_int(i, "vColour2", vData[vid][vColour2]);
	        cache_get_value_name_int(i, "vPaintJob", vData[vid][vPaintJob]);
	        cache_get_value_name_int(i, "vSell", vData[vid][vSell]);
	        cache_get_value_name_int(i, "vLocked", vData[vid][vLocked]);
            cache_get_value_name_int(i, "vLockedBy", vData[vid][vLockedBy]);
            cache_get_value_name_float(i, "vHealth", vData[vid][vHealth]);
			cache_get_value_name_int(i, "vFuel", vData[vid][vFuel]);
	        cache_get_value_name_float(i, "vMileage", vData[vid][vMileage]);
	        cache_get_value_name_int(i, "vAlarm", vData[vid][vAlarm]);
	        cache_get_value_name(i, "vPlate", vData[vid][vPlate]);
	        cache_get_value_name_int(i, "vRegistered", vData[vid][vRegistered]);
	        cache_get_value_name_int(i, "vFaction", vData[vid][vFaction]);
			cache_get_value_name_int(i, "Toolkit", vData[vid][vToolkit]);
			cache_get_value_name_int(i, "Gascan", vData[vid][vGascan]);


	        vData[vid][vID] =   CreateVehicle(vData[vid][vModel], vData[vid][vX], vData[vid][vY], vData[vid][vZ], vData[vid][vA], vData[vid][vColour1], vData[vid][vColour2], -1);
			SetVehicleNumberPlate(vData[vid][vID], vData[vid][vPlate]);

			SetVehicleToRespawn(vData[vid][vID]);//This needs to happen to append the Number Plate, else they dont show correctly
			SetVehicleEngineOff(vData[vid][vID]);
			SetVehicleVirtualWorld(vData[vid][vID], vData[vid][vVW]);
			RepairVehicle(vData[vid][vID]);
			GetVehicleHealth(vData[vid][vID], vData[vid][vHealth]);
			vData[vid][vActive] = 1;
	    }
	}
}

////////////////////////////////////////////////////////////////////////////////

LoadBanks()
{
	mysql_pquery(MySQL, "SELECT * FROM `bankdata`", "OnLoadBanks");
}

PUBLIC:OnLoadBanks()
{
	if(cache_num_rows())
	{
	    new bid;
	    for(new i = 0; i < cache_num_rows(); i++)
	    {
            cache_get_value_name_int(i, "SQLID", bid);
	        cache_get_value_name(i, "Name", bankData[bid][bankName]);
	        cache_get_value_name_float(i, "BankX", bankData[bid][bankX]);
	        cache_get_value_name_float(i, "BankY", bankData[bid][bankY]);
	        cache_get_value_name_float(i, "BankZ", bankData[bid][bankZ]);
	        cache_get_value_name_int(i, "BankInt", bankData[bid][bankInt]);
	        cache_get_value_name_int(i, "BankVW", bankData[bid][bankVW]);
	        cache_get_value_name_int(i, "BankInterior", bankData[bid][bankInterior]);
	        cache_get_value_name_int(i, "BankTotalMoney", bankData[bid][bankTotalMoney]);

	        bankData[bid][bankActive] = 1;

	        new string[512], zone[48];
		    GetZone(bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], zone);
			format(string,sizeof(string),"[ Bank ]\nName: %s\nAddress: %s, %d", bankData[bid][bankName], zone,bid);
			bankData[bid][bankLabel] = CreateDynamic3DTextLabel(string, -1,  bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
            bankData[bid][bankMapIcon] = CreateDynamicMapIcon(bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], 56, 0xAAFFAAFF);

	    }
	}
}

InsertBank(bid)
{
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "INSERT INTO `bankdata` (`SQLID`, `Name`, `BankX`, `BankY`, `BankZ`, `BankInt`, `BankVW`, \
	`BankTotalMoney`, `BankInterior`) VALUES ('%i', '%e', '%f', '%f', '%f', '%i', '%i', \
	'%i', '%i')", bid, bankData[bid][bankName], bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], bankData[bid][bankInt], bankData[bid][bankVW],
	bankData[bid][bankTotalMoney], bankData[bid][bankInterior]);
	mysql_tquery(MySQL, mQuery);
}

SaveBank(bid)
{
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "UPDATE `bankdata` SET `Name` = '%e', `BankX` = '%f', `BankY` = '%f', `BankZ` = '%f', `BankInt` = '%i', `BankVW` = '%i', \
	`BankTotalMoney` = '%i', `BankInterior` = '%i' WHERE `SQLID` = '%i'", bankData[bid][bankName], bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], bankData[bid][bankInt], bankData[bid][bankVW],
	bankData[bid][bankTotalMoney], bankData[bid][bankInterior], bid);
	mysql_tquery(MySQL, mQuery);
}

PUBLIC:SaveBanks()
{
	for(new i = 0; i < MAX_BANKS; i++)
	{
	    if(bankData[i][bankActive] != 1) continue;
	    SaveBank(i);
	}
}

DeleteBank(bid)
{
	DestroyDynamicMapIcon(bankData[bid][bankMapIcon]);
	DestroyDynamic3DTextLabel(bankData[bid][bankLabel]);
	bankData[bid][bankActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "DELETE FROM `bankdata` WHERE SQLID = '%i'", bid);
	mysql_tquery(MySQL, mQuery);
}

ReloadBank(bid)
{
	SaveBank(bid);
    DestroyDynamicMapIcon(bankData[bid][bankMapIcon]);
	DestroyDynamic3DTextLabel(bankData[bid][bankLabel]);
	bankData[bid][bankActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "SELECT * FROM `bankdata` WHERE `SQLID` = '%i' LIMIT 1", bid);
	mysql_tquery(MySQL, mQuery, "OnReloadBank", "i", bid);
}

PUBLIC:OnReloadBank(bid)
{
	if(cache_num_rows())
	{
	    cache_get_value_name_int(0, "SQLID", bid);
        cache_get_value_name(0, "Name", bankData[bid][bankName]);
        cache_get_value_name_float(0, "BankX", bankData[bid][bankX]);
        cache_get_value_name_float(0, "BankY", bankData[bid][bankY]);
        cache_get_value_name_float(0, "BankZ", bankData[bid][bankZ]);
        cache_get_value_name_int(0, "BankInt", bankData[bid][bankInt]);
        cache_get_value_name_int(0, "BankVW", bankData[bid][bankVW]);
        cache_get_value_name_int(0, "BankInterior", bankData[bid][bankInterior]);
        cache_get_value_name_int(0, "BankTotalMoney", bankData[bid][bankTotalMoney]);

        bankData[bid][bankActive] = 1;

        new string[512], zone[48];
	    GetZone(bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], zone);
		format(string,sizeof(string),"[ Bank ]\nName: %s\nAddress: %s, %d", bankData[bid][bankName], zone,bid);
		bankData[bid][bankLabel] = CreateDynamic3DTextLabel(string, -1,  bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
        bankData[bid][bankMapIcon] = CreateDynamicMapIcon(bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], 56, 0xAAFFAAFF);
	}
}


////////////////////////////////////////////////////////////////////////////////

LoadBizs()
{
	mysql_pquery(MySQL, "SELECT * FROM `bizdata`", "OnLoadBizs");
}

PUBLIC:OnLoadBizs()
{
	if(cache_num_rows())
	{
	    new bid;
	    for(new i = 0; i < cache_num_rows(); i++)
	    {
	        cache_get_value_name_int(i, "SQLID", bid);
	        cache_get_value_name(i, "Owner", bData[bid][bOwner]);
            cache_get_value_name(i, "Name", bData[bid][bName]);
            cache_get_value_name_int(i, "Type", bData[bid][bType]);
			cache_get_value_name_float(i, "bX", bData[bid][bX]);
	        cache_get_value_name_float(i, "bbY", bData[bid][bY]);
	        cache_get_value_name_float(i, "bZ", bData[bid][bZ]);
	        cache_get_value_name_int(i, "bInt", bData[bid][bInt]);
	        cache_get_value_name_int(i, "bVW", bData[bid][bVW]);
	        cache_get_value_name_int(i, "bMoney", bData[bid][bMoney]);
	        cache_get_value_name_int(i, "bInteriorPack", bData[bid][bInteriorPack]);
	        cache_get_value_name_int(i, "bLocked", bData[bid][bLocked]);
	        cache_get_value_name_int(i, "bSell", bData[bid][bSell]);
	        cache_get_value_name_int(i, "bFee", bData[bid][bFee]);

	        bData[bid][bActive] = 1;



         	new string[512], zone[48];
		    GetZone(bData[bid][bX], bData[bid][bY], bData[bid][bZ], zone);
			if(bData[bid][bSell] < 1) format(string,sizeof(string),"[ %s ]\nOwner: %s\nAddress: %s, %d", bData[bid][bName], NoUnderscore(bData[bid][bOwner]),zone,bid);
			else format(string,sizeof(string),"[ %s ]\nOwner: %s\nAddress: %s %d\nPrice: $%d (/buybiz to  buy)", bData[bid][bName], NoUnderscore(bData[bid][bOwner]),zone,bid, bData[bid][bSell]);
			bData[bid][bLabel] = CreateDynamic3DTextLabel(string, -1,  bData[bid][bX], bData[bid][bY], bData[bid][bZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
            bData[bid][bMapIcon] = CreateDynamicMapIcon(bData[bid][bX], bData[bid][bY], bData[bid][bZ], 56, 0xAAFFAAFF);
	    }
	}
}

InsertBiz(bid)
{
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "INSERT INTO `bizdata` (`SQLID`, `Owner`, `Name`, `Type`, `bX`, `bbY`, `bZ`, `bInt`, `bVW`, \
	`bMoney`, `bInteriorPack`, `bLocked`, `bSell`, `bFee`) VALUES ('%i', '%e', '%e', '%i', '%f', '%f', '%f', '%i', '%i', \
	'%i', '%i', '%i', '%i', '%i')", bid, bData[bid][bOwner], bData[bid][bName], bData[bid][bType], bData[bid][bX], bData[bid][bY], bData[bid][bZ], bData[bid][bInt], bData[bid][bVW],
	bData[bid][bMoney], bData[bid][bInteriorPack], bData[bid][bLocked], bData[bid][bSell], bData[bid][bFee]);
	mysql_tquery(MySQL, mQuery);
}

SaveBiz(bid)
{
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "UPDATE `bizdata` SET `Owner` = '%e', `Name` = '%e', `Type` = '%i', `bX` = '%f', `bbY` = '%f', `bZ` = '%f', `bInt` = '%i', `bVW` = '%i',\
	`bMoney` = '%i', `bInteriorPack` = '%i', `bLocked` = '%i', `bSell` = '%i', `bFee` = '%i' WHERE `SQLID` = '%i'", bData[bid][bOwner], bData[bid][bName], bData[bid][bType], bData[bid][bX], bData[bid][bY], bData[bid][bZ], bData[bid][bInt], bData[bid][bVW],
	bData[bid][bMoney], bData[bid][bInteriorPack], bData[bid][bLocked], bData[bid][bSell], bData[bid][bFee], bid);
	mysql_tquery(MySQL, mQuery);
}

PUBLIC:SaveBizs()
{
	for(new i = 0; i < MAX_BUSINESS; i++)
	{
	    if(bData[i][bActive] != 1) continue;
	    SaveBiz(i);
	}
}

DeleteBiz(bid)
{
	DestroyDynamicMapIcon(bData[bid][bMapIcon]);
	DestroyDynamic3DTextLabel(bData[bid][bLabel]);
	bData[bid][bActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "DELETE FROM `bizdata` WHERE SQLID = '%i'", bid);
	mysql_tquery(MySQL, mQuery);
}

ReloadBiz(bid)
{
	SaveBiz(bid);
    DestroyDynamicMapIcon(bData[bid][bMapIcon]);
	DestroyDynamic3DTextLabel(bData[bid][bLabel]);
	bData[bid][bActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "SELECT * FROM `bizdata` WHERE `SQLID` = '%i' LIMIT 1", bid);
	mysql_tquery(MySQL, mQuery, "OnReloadBiz", "i", bid);
}

PUBLIC:OnReloadBiz(bid)
{
	if(cache_num_rows())
	{
	    cache_get_value_name(0, "Owner", bData[bid][bOwner]);
        cache_get_value_name(0, "Name", bData[bid][bName]);
        cache_get_value_name_int(0, "Type", bData[bid][bType]);
		cache_get_value_name_float(0, "bX", bData[bid][bX]);
        cache_get_value_name_float(0, "bbY", bData[bid][bY]);
        cache_get_value_name_float(0, "bZ", bData[bid][bZ]);
        cache_get_value_name_int(0, "bInt", bData[bid][bInt]);
        cache_get_value_name_int(0, "bVW", bData[bid][bVW]);
        cache_get_value_name_int(0, "bMoney", bData[bid][bMoney]);
        cache_get_value_name_int(0, "bInteriorPack", bData[bid][bInteriorPack]);
        cache_get_value_name_int(0, "bLocked", bData[bid][bLocked]);
        cache_get_value_name_int(0, "bSell", bData[bid][bSell]);
        cache_get_value_name_int(0, "bFee", bData[bid][bFee]);



        bData[bid][bActive] = 1;
     	new string[512], zone[48];
	    GetZone(bData[bid][bX], bData[bid][bY], bData[bid][bZ], zone);
		if(bData[bid][bSell] < 1) format(string,sizeof(string),"[ %s ]\nOwner: %s\nAddress: %s, %d", bData[bid][bName], NoUnderscore(bData[bid][bOwner]),zone,bid);
		else format(string,sizeof(string),"[ %s ]\nOwner: %s\nAddress: %s %d\nPrice: $%d (/buybiz to  buy)", bData[bid][bName], NoUnderscore(bData[bid][bOwner]),zone,bid, bData[bid][bSell]);
		bData[bid][bLabel] = CreateDynamic3DTextLabel(string, -1,  bData[bid][bX], bData[bid][bY], bData[bid][bZ], 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
        bData[bid][bMapIcon] = CreateDynamicMapIcon(bData[bid][bX], bData[bid][bY], bData[bid][bZ], 56, 0xAAFFAAFF);
	}
}

LoadHouses()
{
	mysql_pquery(MySQL, "SELECT * FROM `housedata`", "OnLoadHouses");
}

PUBLIC:OnLoadHouses()
{
	if(cache_num_rows())
	{
	    new hid;
	    for(new i = 0; i < cache_num_rows(); i++)
	    {
	        cache_get_value_name_int(i, "SQLID", hid);
	        cache_get_value_name(i, "Owner", hData[hid][hOwner]);
	        cache_get_value_name_float(i, "hX", hData[hid][hX]);
	        cache_get_value_name_float(i, "hY", hData[hid][hY]);
	        cache_get_value_name_float(i, "hZ", hData[hid][hZ]);
	        cache_get_value_name_int(i, "hInt", hData[hid][hInt]);
	        cache_get_value_name_int(i, "hVW", hData[hid][hVW]);
	        cache_get_value_name_int(i, "hAlarm", hData[hid][hAlarm]);
	        cache_get_value_name_int(i, "hMoney", hData[hid][hMoney]);
	        cache_get_value_name_int(i, "hInteriorPack", hData[hid][hInteriorPack]);
	        cache_get_value_name_int(i, "hLocked", hData[hid][hLocked]);
	        cache_get_value_name_int(i, "hSell", hData[hid][hSell]);
	        cache_get_value_name_int(i, "hSafe", hData[hid][hSafe]);
			new iGet[256];

			cache_get_value_name(i, "hDrugs", iGet);
			new iP[35];
			strcat(iP, "p<,>");
			for(new drugID = 0; drugID < sizeof(DrugData); drugID++) strcat(iP, "i");
  			sscanf(iGet, iP, hData[hid][hDrugs][0], hData[hid][hDrugs][1], hData[hid][hDrugs][2]);

            cache_get_value_name(i, "hGuns", iGet);
	        new iPP[35];
			strcat(iPP, "p<,>");
			for(new gunID = 0; gunID < HOUSE_WEAPON_SLOTS; gunID++) strcat(iPP, "i");
			sscanf(iGet, iPP, hData[hid][hGuns][0], hData[hid][hGuns][1]);

	        cache_get_value_name(i, "hAmmo", iGet);
	        new iPPP[35];
			strcat(iPPP, "p<,>");
			for(new ammoID = 0; ammoID < HOUSE_WEAPON_SLOTS; ammoID++) strcat(iPPP, "i");
			sscanf(iGet, iPPP, hData[hid][hAmmo][0], hData[hid][hAmmo][1]);

	        hData[hid][hActive] = 1;
         	hData[hid][hPickupID] = CreateDynamicPickup(1273, 23, hData[hid][hX], hData[hid][hY], hData[hid][hZ], hData[hid][hVW], hData[hid][hInt], -1, 100.0);
            new string[512], zone[48];
		    GetZone(hData[hid][hX], hData[hid][hY], hData[hid][hZ], zone);
			if(hData[hid][hSell] < 1) format(string,sizeof(string),"Owner: %s\nAddress: %s, %d",NoUnderscore(hData[hid][hOwner]),zone,hid);
			else format(string,sizeof(string),"Owner: %s\nAddress: %s %d\nPrice: $%d (/buyhouse to  buy)",NoUnderscore(hData[hid][hOwner]),zone,hid, hData[hid][hSell]);
			hData[hid][hLabel] = CreateDynamic3DTextLabel(string, -1,  hData[hid][hX], hData[hid][hY], hData[hid][hZ], 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
		}

	}
}

InsertHouse(hid)
{
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "INSERT INTO `housedata` (`SQLID`, `Owner`, `hX`, `hY`, `hZ`, `hInt`, `hVW`, \
	`hAlarm`, `hMoney`, `hInteriorPack`, `hLocked`, `hSell`, `hSafe`, `hDrugs`, `hGuns`, `hAmmo`)\
	VALUES ('%i', '%s', '%f', '%f', '%f', '%i', '%i', \
	'%i', '%i', '%i', '%i', '%i', '%i', '%e', '%e', '%e')", hid, hData[hid][hOwner], hData[hid][hX], hData[hid][hY], hData[hid][hZ], hData[hid][hInt], hData[hid][hVW], hData[hid][hAlarm],
	hData[hid][hMoney], hData[hid][hInteriorPack], hData[hid][hLocked], hData[hid][hSell],
	hData[hid][hSafe], "0,0,0", "0,0", "0,0");
	mysql_tquery(MySQL, mQuery);
}

SaveHouse(hid)
{
    new iString[ 50 ], tmp[ 10 ];
    new iString2[ 50 ], tmp2[ 10 ];
    new iString3[ 50 ], tmp3[ 10 ];
    for(new c = 0; c < DRUGS_TYPES; c++)
	{
	    format(tmp,sizeof(tmp),"%d,", hData[hid][hDrugs][c]);
	    strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	for(new c = 0; c < HOUSE_WEAPON_SLOTS; c++)
	{
	    format(tmp2,sizeof(tmp2),"%d,", hData[hid][hGuns][c]);
	    strcat(iString2,tmp2);
	}
	strdel(iString2, strlen(iString2)-1, strlen(iString2));
	for(new c = 0; c < HOUSE_WEAPON_SLOTS; c++)
	{
	    format(tmp3,sizeof(tmp3),"%d,", hData[hid][hAmmo][c]);
	    strcat(iString3,tmp3);
	}
	strdel(iString3, strlen(iString3)-1, strlen(iString3));
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "UPDATE `housedata` SET `Owner` = '%e', `hX` = '%f', `hY` = '%f', `hZ`= '%f', `hInt` = '%i', `hVW` = '%i', \
	`hAlarm` = '%i', `hMoney`= '%i', `hInteriorPack`= '%i', `hLocked`= '%i', `hSell`= '%i', hDrugs = '%e', `hGuns` = '%e', `hAmmo` = '%e', `hSafe` = '%i' WHERE `SQLID` = '%i'", hData[hid][hOwner], hData[hid][hX], hData[hid][hY], hData[hid][hZ], hData[hid][hInt], hData[hid][hVW],
 	hData[hid][hAlarm], hData[hid][hMoney], hData[hid][hInteriorPack], hData[hid][hLocked], hData[hid][hSell], iString, iString2, iString3, hData[hid][hSafe], hid);
	mysql_tquery(MySQL, mQuery);
}

PUBLIC:SaveHouses()
{
	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if(hData[i][hActive] != 1) continue;
	    SaveHouse(i);
	}
}

DeleteHouse(hid)
{
    DestroyDynamicPickup(hData[hid][hPickupID]);
	DestroyDynamic3DTextLabel(hData[hid][hLabel]);
	hData[hid][hActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "DELETE FROM `housedata` WHERE SQLID = '%i'", hid);
	mysql_tquery(MySQL, mQuery);
}

ReloadHouse(hid)
{
	SaveHouse(hid);
	DestroyDynamicPickup(hData[hid][hPickupID]);
	DestroyDynamic3DTextLabel(hData[hid][hLabel]);
	hData[hid][hActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "SELECT * FROM `housedata` WHERE `SQLID` = '%i' LIMIT 1", hid);
	mysql_tquery(MySQL, mQuery, "OnReloadHouse", "i", hid);
}

PUBLIC:OnReloadHouse(hid)
{
	if(cache_num_rows())
	{
	    cache_get_value_name(0, "Owner", hData[hid][hOwner]);
        cache_get_value_name_float(0, "hX", hData[hid][hX]);
        cache_get_value_name_float(0, "hY", hData[hid][hY]);
        cache_get_value_name_float(0, "hZ", hData[hid][hZ]);
        cache_get_value_name_int(0, "hInt", hData[hid][hInt]);
        cache_get_value_name_int(0, "hVW", hData[hid][hVW]);
        cache_get_value_name_int(0, "hAlarm", hData[hid][hAlarm]);
        cache_get_value_name_int(0, "hMoney", hData[hid][hMoney]);
        cache_get_value_name_int(0, "hInteriorPack", hData[hid][hInteriorPack]);
        cache_get_value_name_int(0, "hLocked", hData[hid][hLocked]);
        cache_get_value_name_int(0, "hSell", hData[hid][hSell]);
        cache_get_value_name_int(0, "hSafe", hData[hid][hSafe]);
        new iGet[256];
		cache_get_value_name(0, "hDrugs", iGet);
		new iP[35];
		strcat(iP, "p<,>");
		for(new drugID = 0; drugID < sizeof(DrugData); drugID++) strcat(iP, "i");
		sscanf(iGet, iP, hData[hid][hDrugs][0], hData[hid][hDrugs][1], hData[hid][hDrugs][2]);

        cache_get_value_name(0, "hGuns", iGet);
        new iPP[35];
		strcat(iPP, "p<,>");
		for(new gunID = 0; gunID < HOUSE_WEAPON_SLOTS; gunID++) strcat(iPP, "i");
		sscanf(iGet, iPP, hData[hid][hGuns][0], hData[hid][hGuns][1]);

        cache_get_value_name(0, "hAmmo", iGet);
        new iPPP[35];
		strcat(iPPP, "p<,>");
		for(new ammoID = 0; ammoID < HOUSE_WEAPON_SLOTS; ammoID++) strcat(iPPP, "i");
		sscanf(iGet, iPPP, hData[hid][hAmmo][0], hData[hid][hAmmo][1]);

        hData[hid][hActive] = 1;
     	hData[hid][hPickupID] = CreateDynamicPickup(1273, 23, hData[hid][hX], hData[hid][hY], hData[hid][hZ], hData[hid][hVW], hData[hid][hInt], -1, 100.0);
        new string[512], zone[48];
	    GetZone(hData[hid][hX], hData[hid][hY], hData[hid][hZ], zone);
		if(hData[hid][hSell] < 1) format(string,sizeof(string),"Owner: %s\nAddress: %s, %d",NoUnderscore(hData[hid][hOwner]),zone,hid);
		else format(string,sizeof(string),"Owner: %s\nAddress: %s %d\nPrice: $%d (/buyhouse to  buy)",NoUnderscore(hData[hid][hOwner]),zone,hid, hData[hid][hSell]);
		hData[hid][hLabel] = CreateDynamic3DTextLabel(string, -1,  hData[hid][hX], hData[hid][hY], hData[hid][hZ], 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
	}
}

InsertVehicle(vid)
{
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "INSERT INTO `vehicledata` (`SQLID`, `Model`, `Owner`, `vX`, `vY`, \
	`vZ`, `vA`, `vVW`, `vInt`, `vColour1`, `vColour2`, `vPaintJob`, `vSell`, `vLocked`, `vLockedBy`, `vFuel`, `vMileage`,\
	 `vAlarm`, `vPlate`, `vRegistered`, `vFaction`, `Toolkit`, `Gascan`) VALUES \
	('%i', '%i', '%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%s', '%i', '%i', '%i', '%i')",
	vid, vData[vid][vModel], vData[vid][vOwner], vData[vid][vX], vData[vid][vY], vData[vid][vZ], vData[vid][vA], vData[vid][vVW], vData[vid][vInt],
	vData[vid][vColour1], vData[vid][vColour2], vData[vid][vPaintJob], vData[vid][vSell], vData[vid][vLocked],
 	vData[vid][vLockedBy], vData[vid][vFuel], vData[vid][vMileage], vData[vid][vAlarm], vData[vid][vPlate],
	vData[vid][vRegistered], vData[vid][vFaction], vData[vid][vToolkit], vData[vid][vGascan]);
	mysql_tquery(MySQL, mQuery);
}

SaveVehicle(vid)
{
    new mQuery[800];

	mysql_format(MySQL, mQuery, 800, "UPDATE `vehicledata` SET `Model` = '%i', `Owner` = '%s', `vX` = '%f', `vY` = '%f', `vZ` = '%f', `vA` = '%f', `vVW`='%i', `vInt` = '%i', `vColour1`='%i', `vColour2`='%i', `vPaintJob`='%i', `vSell`='%i', `vLocked`='%i', `vLockedBy`='%i', `vFuel`='%i', `vMileage`='%f', `vAlarm`='%i', `vPlate`='%s', `vRegistered`='%i', `vFaction` = '%i', `Toolkit` = '%i', `Gascan` = '%i' WHERE `SQLID` = '%i'",
 	vData[vid][vModel], vData[vid][vOwner], vData[vid][vX], vData[vid][vY], vData[vid][vZ], vData[vid][vA], vData[vid][vVW], vData[vid][vInt],
	vData[vid][vColour1], vData[vid][vColour2], vData[vid][vPaintJob], vData[vid][vSell], vData[vid][vLocked], vData[vid][vLockedBy], vData[vid][vFuel], vData[vid][vMileage], vData[vid][vAlarm], vData[vid][vPlate], vData[vid][vRegistered], vData[vid][vFaction], vData[vid][vToolkit], vData[vid][vGascan], vid);
	mysql_tquery(MySQL, mQuery);
}

PUBLIC:SaveVehicles()
{
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(vData[i][vActive] != 1) continue;
	    SaveVehicle(i);
	}
}

DeleteVehicle(vid)
{
    DestroyVehicle(vData[vid][vID]);
	vData[vid][vID] = INVALID_VEHICLE_ID;
	vData[vid][vActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "DELETE FROM `vehicledata` WHERE SQLID = '%i'", vid);
	mysql_tquery(MySQL, mQuery);
}

ReloadVehicle(vid)
{
	SaveVehicle(vid);
	DestroyVehicle(vData[vid][vID]);
	vData[vid][vID] = INVALID_VEHICLE_ID;
	vData[vid][vActive] = 0;
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "SELECT * FROM `vehicledata` WHERE `SQLID` = '%i' LIMIT 1", vid);
	mysql_tquery(MySQL, mQuery, "OnReloadVehicle", "i", vid);
}

PUBLIC:OnReloadVehicle(vid)
{
	if(cache_num_rows())
	{
	    cache_get_value_name_int(0, "SQLID", vid);
	    cache_get_value_name_int(0, "Model", vData[vid][vModel]);
	    cache_get_value_name(0, "Owner", vData[vid][vOwner]);
	    cache_get_value_name_float(0, "vX", vData[vid][vX]);
	    cache_get_value_name_float(0, "vY", vData[vid][vY]);
	    cache_get_value_name_float(0, "vZ", vData[vid][vZ]);
	    cache_get_value_name_float(0, "vA", vData[vid][vA]);
	    cache_get_value_name_int(0, "vVW", vData[vid][vVW]);
	    cache_get_value_name_int(0, "vInt", vData[vid][vInt]);
	    cache_get_value_name_int(0, "vColour1", vData[vid][vColour1]);
	    cache_get_value_name_int(0, "vColour2", vData[vid][vColour2]);
	    cache_get_value_name_int(0, "vPaintJob", vData[vid][vPaintJob]);
	    cache_get_value_name_int(0, "vSell", vData[vid][vSell]);
	    cache_get_value_name_int(0, "vLocked", vData[vid][vLocked]);
	    cache_get_value_name_int(0, "vLockedBy", vData[vid][vLockedBy]);
		cache_get_value_name_int(0, "vFuel", vData[vid][vFuel]);
	    cache_get_value_name_float(0, "vMileage", vData[vid][vMileage]);
	    cache_get_value_name_int(0, "vAlarm", vData[vid][vAlarm]);
	    cache_get_value_name(0, "vPlate", vData[vid][vPlate]);
	    cache_get_value_name_int(0, "vRegistered", vData[vid][vRegistered]);
        cache_get_value_name_int(0, "vFaction", vData[vid][vFaction]);
        cache_get_value_name_int(0, "Toolkit", vData[vid][vToolkit]);
        cache_get_value_name_int(0, "Gascan", vData[vid][vGascan]);

	    vData[vid][vID] =   CreateVehicle(vData[vid][vModel], vData[vid][vX], vData[vid][vY], vData[vid][vZ], vData[vid][vA], vData[vid][vColour1], vData[vid][vColour2], -1);
	    vData[vid][vActive] = 1;
	    SetVehicleVirtualWorld(vData[vid][vID], vData[vid][vVW]);
		SetVehicleNumberPlate(vData[vid][vID], vData[vid][vPlate]);
		SetVehicleEngineOff(vData[vid][vID]);
	}
}



public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	switch(errorid)
	{
		case CR_SERVER_GONE_ERROR:
		{
			printf("Lost connection to server");
		}
		default:
		{
			printf("Something Went Wrong, query:\n Query - %s\nError %i - %s\nCallback - %s", query, errorid, error, callback);
		}
	}
	return 1;
}

PUBLIC:SkipSpawn(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SpawnPlayer(playerid);
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new tmppData[e_PlayerData];
	pData[playerid] = tmppData;

	pData[playerid][pConnecting] = true;
	pData[playerid][MySQLRaceCheck]++;
	pData[playerid][pFailedLogins] = 0;

	EditingGateID[playerid] = -1;
	EditingGateType[playerid] = -1;
	for(new i; i < MAX_GATES; i++) HasGateAuth[playerid][i] = false;

	RemoveBuildings(playerid);

	GetPlayerName(playerid, pData[playerid][Username], 24);
	if(IsRPName(pData[playerid][Username]))
	{
		new mQuery[256];
		mysql_format(MySQL, mQuery, 256, "SELECT * FROM `playerdata` WHERE `Username` = '%e'", pData[playerid][Username]);
		mysql_tquery(MySQL, mQuery, "OnLoadPlayerData", "i", playerid);
/*			orm_addvar_int(ormid, pData[playerid][ID], "ID");
		orm_addvar_string(ormid, pData[playerid][Username], 24, "Username");
		orm_addvar_string(ormid, pData[playerid][Password], 129, "Password");
		orm_addvar_string(ormid, pData[playerid][IPAddress], 24, "IPAddress");
		orm_addvar_int(ormid, pData[playerid][Admin], "Admin");
		orm_addvar_int(ormid, pData[playerid][Banned], "Banned");
		orm_addvar_int(ormid, pData[playerid][IPBanned], "IPBanned");
		orm_addvar_string(ormid, pData[playerid][BanReason], 512, "BanReason");
		orm_addvar_int(ormid, pData[playerid][Kicks], "Kicks");
		orm_addvar_int(ormid, pData[playerid][Warns], "Warns");
		orm_addvar_int(ormid, pData[playerid][Level], "Level");
		orm_addvar_int(ormid, pData[playerid][Money], "Money");
		orm_addvar_int(ormid, pData[playerid][hasPhone], "hasPhone");
		orm_addvar_int(ormid, pData[playerid][hasSIM], "hasSIM");
		orm_addvar_int(ormid, pData[playerid][hasRadio], "hasRadio");
		orm_addvar_int(ormid, pData[playerid][hasGPS], "hasGPS");
		orm_addvar_int(ormid, pData[playerid][Skin], "Skin");
		orm_addvar_int(ormid, pData[playerid][Faction], "Faction");
		orm_addvar_int(ormid, pData[playerid][fTier], "Tier");
		orm_addvar_int(ormid, pData[playerid][Sellables], "Sellables");
		orm_addvar_string(ormid, pData[playerid][fRank], 10, "Rank");
		new iGet[256];
		orm_addvar_string(ormid, iGet, 256, "pDrugs");
		new iPPP[35];
		strcat(iPPP, "p<,>");
		for(new ammoID = 0; ammoID < DRUGS_TYPES; ammoID++) strcat(iPPP, "i");
		sscanf(iGet, iPPP, pData[playerid][pDrugs][0], pData[playerid][pDrugs][1], pData[playerid][pDrugs][2]);

		orm_setkey(ormid, "Username");
		orm_load(pData[playerid][ORM_ID], "OnAccountDataLoad", "ii", playerid, pData[playerid][MySQLRaceCheck]);*/
	}
	else
	{
		SendClientError(playerid, "Please use a RP Name, for example My_Name.");
		KickPlayer(playerid);
	}
	return 1;
}

PUBLIC:OnLoadPlayerData(playerid)
{
    pData[playerid][pConnecting] = false;
	if(cache_num_rows()) // if player account eexits
	{
	    cache_get_value_name_int(0, "ID", pData[playerid][pID]);
	    cache_get_value_name(0, "Username", pData[playerid][Username]);
	    cache_get_value_name(0, "Password", pData[playerid][Password]);
	    cache_get_value_name(0, "IPAddress", pData[playerid][IPAddress]);
	    cache_get_value_name_int(0, "Admin", pData[playerid][Admin]);
	    cache_get_value_name_int(0, "Banned", pData[playerid][Banned]);
	    cache_get_value_name_int(0, "IPBanned", pData[playerid][IPBanned]);
	    cache_get_value_name(0, "BanReason", pData[playerid][BanReason]);
	    cache_get_value_name_int(0, "Kicks", pData[playerid][Kicks]);
	    cache_get_value_name_int(0, "Warns", pData[playerid][Warns]);
	    cache_get_value_name_int(0, "Level", pData[playerid][Level]);
	    cache_get_value_name_int(0, "Money", pData[playerid][Money]);
	    cache_get_value_name_int(0, "BankMoney", pData[playerid][bankMoney]);
	    cache_get_value_name_int(0, "hasPhone", pData[playerid][hasPhone]);
	    cache_get_value_name_int(0, "hasSIM", pData[playerid][hasSIM]);
	    cache_get_value_name_int(0, "hasGPS", pData[playerid][hasGPS]);
	    cache_get_value_name_int(0, "hasRadio", pData[playerid][hasRadio]);
	    cache_get_value_name_int(0, "Skin", pData[playerid][Skin]);
	    cache_get_value_name_int(0, "Faction", pData[playerid][Faction]);
	    cache_get_value_name_int(0, "Tier", pData[playerid][fTier]);
	    cache_get_value_name_int(0, "Sellables", pData[playerid][Sellables]);
	    cache_get_value_name_int(0, "Jail", pData[playerid][jail]);
	    cache_get_value_name_int(0, "JailTime", pData[playerid][jailtime]);
	    cache_get_value_name(0, "JailReason", pData[playerid][jailreason]);
	    cache_get_value_name(0, "Rank", pData[playerid][fRank]);
	    cache_get_value_name(0, "Job", pData[playerid][pJob]);

		new iGet[256];
        cache_get_value_name(0, "pDrugs", iGet);
		new iPPP[35];
		strcat(iPPP, "p<,>");
		for(new ammoID = 0; ammoID < DRUGS_TYPES; ammoID++) strcat(iPPP, "i");
		sscanf(iGet, iPPP, pData[playerid][pDrugs][0], pData[playerid][pDrugs][1], pData[playerid][pDrugs][2]);

		AccountLoaded(playerid, 1);
	}
	else
	{
		AccountLoaded(playerid, 0);
	}
}

PUBLIC:AccountLoaded(playerid, exits)
{
	if(exits == 1)
	{
	    if(pData[playerid][Banned]) // If the players account is banned
		{
			new dstr[256];
			format(dstr, sizeof(dstr), "You are banned. Reason: %s", pData[playerid][BanReason]);
			SendClientError(playerid, dstr);
			KickPlayer(playerid);
		}
		else
		{
			ShowPlayerLoginDialog(playerid);
		}
	}
	else if(exits == 0)
	{
	    ShowPlayerRegisterDialog(playerid);
	}
}

PUBLIC:SavePlayers()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        SavePlayer(i);
	    }
	}
}

SavePlayer(playerid)
{
    new iString[ 50 ], tmp[ 10 ];
    for(new c = 0; c < DRUGS_TYPES; c++)
	{
	    format(tmp,sizeof(tmp),"%d,", pData[playerid][pDrugs][c]);
	    strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	new mQuery[800];
	mysql_format(MySQL, mQuery, 800, "UPDATE `playerdata` SET `Username` = '%e', \
	`Password` = '%e', `IPAddress` = '%e', `Admin` = '%i', `Banned` = '%i',\
 	`IPBanned` = '%i', `BanReason` = '%e', `Kicks` = '%i', `Warns` = '%i', \
	 `Level` = '%i', `Money` = '%i', `BankMoney` = '%i', \
	 `hasPhone` = '%i', `hasRadio` = '%i', `hasSIM` = '%i',`hasGPS` = '%i',\
	 `Skin` = '%i', `Faction` = '%i', `Tier` = '%i', \
	 `Rank` = '%e', `Sellables` = '%i', \
	 `pDrugs` = '%e', `Jail` = '%i', `JailTime` = '%i', \
	 `JailReason` = '%e', `Job` = '%e' WHERE `ID` = '%i'",
	 pData[playerid][Username], pData[playerid][Password], pData[playerid][IPAddress],
	 pData[playerid][Admin], pData[playerid][Banned], pData[playerid][IPBanned],
	 pData[playerid][BanReason], pData[playerid][Kicks], pData[playerid][Warns],
	 pData[playerid][Level], pData[playerid][Money], pData[playerid][bankMoney],
	 pData[playerid][hasPhone], pData[playerid][hasRadio], pData[playerid][hasSIM],
	 pData[playerid][hasGPS],pData[playerid][Skin], pData[playerid][Faction],
	 pData[playerid][fTier], pData[playerid][fRank], pData[playerid][Sellables],
	 iString,
	 pData[playerid][jail], pData[playerid][jailtime],
	 pData[playerid][jailreason], pData[playerid][pJob], pData[playerid][pID]);
	mysql_tquery(MySQL, mQuery);
}



PUBLIC:OnAccountRegistered(playerid)
{
	new mstr[256];
	format(mstr, 256, "Welcome to %s, Enjoy your stay.", SERVER_GM);
	SendClientMessage(playerid, COLOR_GOLD, mstr);
	DefaultSpawn(playerid);
	return 1;
}

ShowPlayerRegisterDialog(playerid)
{
	return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration", "This account IS NOT registered\nEnter your desired password below", "Register", "Cancel");
}

ShowPlayerLoginDialog(playerid)
{
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", ""CWHITE"This Account is registered\nPlease enter your password below", "Login", "Quit");
}


public OnPlayerDisconnect(playerid, reason)
{
	if(EditingGateID[playerid] != -1) GateData[ EditingGateID[playerid] ][GateEditing] = false;
    if(pData[playerid][pLogged] == true)
	{
		SavePlayer(playerid);
	}

	return 1;
}

public OnPlayerSpawn(playerid)
{
	LoadPTDs(playerid);

    if(pData[playerid][jailtime] > 1 || pData[playerid][jail])
	{
		Jail(playerid, pData[playerid][jailtime], pData[playerid][jailreason]);
		return 1;
	}
	DefaultSpawn(playerid);
	return 1;
}
/*
UpdatePlayerVehTD(playerid)
{
    PlayerTextDrawHide(playerid,Speedo_Dynamic_Speed[playerid]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel_Bar[playerid]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Bar[playerid]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][0]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][1]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][2]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][3]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][4]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][5]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][6]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][7]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][8]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][9]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][10]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][11]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][12]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][13]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][14]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][15]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][16]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][17]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][18]);
	PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][19]);
	new pState = GetPlayerState(playerid);
	//if(show && ToggleHUD[playerid] != 1)//prikazi ili updejtuj
	//{
	    //if(pSpeedo[playerid] == 0 && pState == PLAYER_STATE_DRIVER || pSpeedo[playerid] == 1 && pState == PLAYER_STATE_DRIVER)//PRIKAZI MU TEXTDRAWOVE ILI AKO SU PRIKAZANI UPDEJTUJ
	    //{
    new vehicle = GetPlayerVehicleID(playerid);
    new model = GetVehicleModel(vehicle);
    new string[20];
	new tempFuel = floatround(vData[FindVehicleID(vehicle)][vFuel]);
	if(tempFuel > 100) tempFuel = 100;
	format(string,sizeof(string),"F: %d%",tempFuel);
	PlayerTextDrawSetString(playerid,Speedo_Dynamic_Fuel_Bar[playerid],string);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel_Bar[playerid]);
    new fuel = floatround(tempFuel / 5,floatround_round);

    for(new j; j < sizeof(Speedo_Dynamic_Fuel[]); j++)//reset na sivo
    {
        PlayerTextDrawColor(playerid,Speedo_Dynamic_Bar[playerid],-190703361);

		PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][j],-2004384257);

    	if(j < fuel)
		{
		    PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][j],-190703361);
		}
    }
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Speed[playerid]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel_Bar[playerid]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Bar[playerid]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][0]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][1]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][2]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][3]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][4]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][5]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][6]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][7]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][8]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][9]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][10]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][11]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][12]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][13]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][14]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][15]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][16]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][17]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][18]);
	PlayerTextDrawShow(playerid,Speedo_Dynamic_Fuel[playerid][19]);
    }
    else//sakrij
    {
    	if(pSpeedo[playerid] == 1)//SAKRIJ TD
	    {
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Speed[playerid]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel_Bar[playerid]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Bar[playerid]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][0]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][1]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][2]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][3]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][4]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][5]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][6]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][7]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][8]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][9]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][10]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][11]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][12]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][13]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][14]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][15]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][16]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][17]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][18]);
			PlayerTextDrawHide(playerid,Speedo_Dynamic_Fuel[playerid][19]);
	        pSpeedo[playerid] = 0;
	    }
    }
    return 1;
}
*/

DefaultSpawn(playerid)
{
    SetPlayerScore(playerid, pData[playerid][Level]);
	SetPlayerColor(playerid, COLOR_WHITE);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pData[playerid][Money]);
	SetPlayerSkin(playerid, pData[playerid][Skin]);
    if(pData[playerid][Faction] == -1) // civilian
    {
        SetPlayerInterior(playerid, noobspawn[interior]);
		SetPlayerVirtualWorld(playerid, noobspawn[vw]);
        SetSpawnInfo(playerid, NO_TEAM, pData[playerid][Skin], noobspawn[cox], noobspawn[coy], noobspawn[coz], 0,0,0,0,0,0,0);
        SetPlayerPos(playerid, noobspawn[cox], noobspawn[coy], noobspawn[coz]);
		SetPlayerFacingAngle(playerid, 0);
    }
    else
    {
        new fid = GetPlayerFaction(playerid);
        SetPlayerInterior(playerid, fData[fid][fInInt]);
        SetPlayerVirtualWorld(playerid, fData[fid][fInVW]);
        SetSpawnInfo(playerid, fid, pData[playerid][Skin], fData[fid][fInX], fData[fid][fInY], fData[fid][fInZ], 0,0,0,0,0,0,0);
        SetPlayerPos(playerid, fData[fid][fInX], fData[fid][fInY], fData[fid][fInZ]);
		SetPlayerFacingAngle(playerid, fData[fid][fInA]);
    }
 	SetCameraBehindPlayer(playerid);
 	return 1;
}

forward FuelDown();
public FuelDown()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
   	{
   	    if(!IsPlayerConnected(i)) continue;
   		new carid = GetPlayerVehicleID(i);
   		if(GetPlayerState(i) != PLAYER_STATE_DRIVER) continue;
		if(carid == 0) continue;
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
		if(engine == 0) continue;
		if(CheckIfVehicleUsesFuel(carid) == 0) continue;
		vData[FindVehicleID(carid)][vFuel]--;
   	}
  	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	pData[playerid][cuffed] = 0;
	pData[playerid][tazed] = 0;
	DeletePVar(playerid, "Tazer");
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	if(GetPVarInt(playerid, "Tazer") != 0 && weaponid == 23 && IsPlayerLegal(playerid) && !IsPlayerInAnyVehicle(damagedid) && pData[damagedid][tazed] != 1)
	{
		new iFormat[228];
		format(iFormat, sizeof(iFormat), "has tazed %s.", RPName(damagedid));
		Action(playerid, iFormat);
		pData[damagedid][tazed] = 1;
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

///////////////////////


public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new mstrr[256];
    format(mstrr, 256, "%s: %s", RPName(playerid), text);
	NearMessage(playerid, -1, mstrr);
	SetPlayerChatBubble(playerid, text, -1, 40.0, 7000);
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	new mstr[256];
	if(!success) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: This command does not exists in this server! For all the commands: /commands.");
	if(success)
	{
		format(mstr, 256, "[AMDIN-SPY] %s(%i): %s", NoUnderscore(GetName(playerid)), playerid, cmdtext);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(pData[i][Admin])
				{
					if(pData[i][TogCMDS])
					{
						SendClientMessage(i, COLOR_GOLD, mstr);
					}
				}
			}
		}
	}
	return 1;
}

enum weeshit
{
	wname[50],
	pricea,
	requ,
}

new wepshit[][weeshit] = {
	{"Desert Eagle", 5000, 20},
	{"AK-47", 10000, 30},
	{"Sniper Rifle", 20000, 40}
};


enum veeshit
{
	vname[50],
	pricev,
	modelv,
}
new vehshit[][veeshit] = {
	{"Sultan",	600000, 560}, {"Huntley", 800000, 579}, {"Tow Truck",  400000, 525},
	{"PCJ-600", 200000, 461}, {"Wayfarer", 300000, 586}, {"Bus", 800000, 431},
	{"Linerunner", 600000, 403}, {"Stratum", 500000, 561}, {"Uranus", 400000, 558},
	{"Maverick", 1200000, 487}, {"Banshee", 1000000, 429}, {"Infernus", 1200000, 411},
	{"Comet", 1000000, 480}
};



public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	for(new i = 0; i < sizeof(mCheckpoints); i++)
	{
		if(checkpointid == mCheckpoints[i][cpID])
		{
			if(mCheckpoints[i][coid] == CP_GUNSMITH) // if gunsmithc chekcpont
			{
				new mstr[256], cnt = 0, tmpstr[256];
				for(new ij = 0; ij < sizeof(wepshit); ij++)
				{
					if(cnt == 0)
					{
						format(tmpstr, 256, "%s\t\t\t$%i\t\t\t%i", wepshit[ij][wname], wepshit[ij][pricea], wepshit[ij][requ]);
						cnt++;
					}
					else format(tmpstr, 256, "\n%s\t\t\t$%i\t\t\t%i", wepshit[ij][wname], wepshit[ij][pricea], wepshit[ij][requ]);
					strcat(mstr, tmpstr);
				}
				ShowPlayerDialog(playerid, DIALOG_GUNSMITH, DIALOG_STYLE_LIST, "Make Gun", mstr, "OK", "Exit");
			}
			if(mCheckpoints[i][coid] == CP_IMPORT)
			{
			    ShowPlayerDialog(playerid, DIALOG_IMPORT, DIALOG_STYLE_LIST, "Welcome to Platinum Exporters", "Work for US\nImport Vehicle From Wang Cars", "YES", "Exit");
			}
		}
	}
}

ShowVehicleImportDialog(playerid)
{
    new mstr[256], tmpstr[256], cnt = 0;
    for(new j = 0; j < sizeof(vehshit); j++)
    {
        if(cnt == 0)
        {
            format(tmpstr, 256, "%s [%i]\t\t\t$%i", vehshit[j][vname], vehshit[j][modelv], vehshit[j][pricev]);
			cnt++;
        }
        else format(tmpstr, 256, "\n%s [%i]\t\t\t$%i", vehshit[j][vname], vehshit[j][modelv], vehshit[j][pricev]);
        strcat(mstr, tmpstr);
    }
    ShowPlayerDialog(playerid, DIALOG_VEHIMPORT, DIALOG_STYLE_LIST, "Import Vehicle", mstr, "OK", "Exit");
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}


public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    new mstr[256];
	    new vehi = GetPlayerVehicleID(playerid);
	    new vd = FindVehicleID(vehi);
	    new mid = GetVehicleModel(vehi);
	    new StartStop[6];
	    new UnOwnedVehicle, IsPlayerOwned, IsFacVehicle, vehengine, vehlights, vehalarm, vehdoors, vehbonnet, vehboot, vehobjective, IsCorrectFac, IsOwner;
		GetVehicleParamsEx(vehi, vehengine, vehlights, vehalarm, vehdoors, vehbonnet, vehboot, vehobjective);

		if(vehengine == 0) format(StartStop, 6, "Off");
		if(vehengine == 1) format(StartStop, 6, "On");
		if(!strfind(vData[vehi][vOwner], "None")) UnOwnedVehicle = 0;
		if(strfind(vData[vehi][vOwner], "None")) UnOwnedVehicle = 1;

		if(!strfind(vData[vehi][vOwner], "_")) IsPlayerOwned = 0;
		if(strfind(vData[vehi][vOwner], "_")) IsPlayerOwned = 1;

		if(!strfind(vData[vehi][vOwner], GetName(playerid))) IsOwner = 0;
	 	if(strfind(vData[vehi][vOwner], pData[playerid][Username])) IsOwner = 1;

	 	if(vData[vehi][vFaction] == -1) IsFacVehicle = 0;
		if(vData[vehi][vFaction] != -1) IsFacVehicle = 1;



	 	if(pData[playerid][Faction] != vData[vehi][vFaction]) IsCorrectFac = 0;
	 	if(pData[playerid][Faction] == vData[vehi][vFaction]) IsCorrectFac = 1;

	    if(UnOwnedVehicle == 1) format(mstr, 256, "No one owns this %s | Engine Status: %s", VehicleName[mid-400], StartStop);
	 	if(IsPlayerOwned == 1 && IsOwner == 1) format(mstr, 256, "You are the owner of this %s | Engine Status: %s", VehicleName[mid-400], StartStop);
	 	if(IsPlayerOwned == 1 && IsOwner == 0) format(mstr, 156, "You are not the owner of this %s", VehicleName[mid-400]);
	 	if(IsFacVehicle == 1 && IsCorrectFac == 1) format(mstr, 256, "You are in the Faction that owns this %s | Engine Status: %s", VehicleName[mid-400], StartStop);
	 	if(IsFacVehicle == 1 && IsCorrectFac == 0) format(mstr, 156, "You are not in the Faction that owns this %s", VehicleName[mid-400]);
	 	SendClientMessage(playerid, COLOR_GREY, mstr);
		if(vData[vd][vSell] > 0)
		{
		    format(mstr, 156, "This %s is on sale for %i. /buycar to buy this %s.", VehicleName[mid-400], vData[vd][vSell], VehicleName[mid-400]);
		    SendClientMessage(playerid, COLOR_GOLD, mstr);
		    TogglePlayerControllable(playerid, false);
		    format(mstr, 156, "If you do not want to buy, /exitcar to exit the %s.", VehicleName[mid-400]);
		    SendClientMessage(playerid, COLOR_GOLD, mstr);
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(EditingGateID[playerid] == -1) return 1;
	switch(response)
	{
		case EDIT_RESPONSE_FINAL:
		{
		    new id = EditingGateID[playerid];
		    GateData[id][GateEditing] = false;

		    switch(EditingGateType[playerid])
		    {
				case GATE_STATE_CLOSED:
				{
				    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, GateData[id][GateLabel], E_STREAMER_X, x);
		            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, GateData[id][GateLabel], E_STREAMER_Y, y);
		            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, GateData[id][GateLabel], E_STREAMER_Z, z);
				    SetDynamicObjectPos(objectid, x, y, z);
				    SetDynamicObjectRot(objectid, rx, ry, rz);
				    GateData[id][GatePos][0] = x;
					GateData[id][GatePos][1] = y;
					GateData[id][GatePos][2] = z;
					GateData[id][GateRot][0] = rx;
					GateData[id][GateRot][1] = ry;
					GateData[id][GateRot][2] = rz;
					SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Edited gate's default position.");

					if(GateData[id][GateOpenPos][0] == 0.0 && GateData[id][GateOpenRot][0] == 0.0) {
				        GateData[id][GateEditing] = true;
		    			EditingGateType[playerid] = GATE_STATE_OPEN;
				        EditDynamicObject(playerid, objectid);

				        SendClientMessage(playerid, 0xF39C12FF, "WARNING: {FFFFFF}This gate doesn't have an opening position.");
				        SendClientMessage(playerid, 0xF39C12FF, "WARNING: {FFFFFF}You can define an opening position now or you can do it later.");
				        SendClientMessage(playerid, 0xF39C12FF, "WARNING: {FFFFFF}People won't be able to open this gate until you define an opening position.");
				    }else{
				        EditingGateID[playerid] = -1;
		    			EditingGateType[playerid] = -1;
				    }

				    SaveGate(id);
				}

				case GATE_STATE_OPEN:
				{
				    SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Edited gate's opening position.");
				    SetGateState(id, GATE_STATE_CLOSED, 2);
				    GateData[id][GateOpenPos][0] = x;
					GateData[id][GateOpenPos][1] = y;
					GateData[id][GateOpenPos][2] = z;
					GateData[id][GateOpenRot][0] = rx;
					GateData[id][GateOpenRot][1] = ry;
					GateData[id][GateOpenRot][2] = rz;

				    EditingGateID[playerid] = -1;
		    		EditingGateType[playerid] = -1;
		    		SaveGate(id);
				}
		    }
		}

		case EDIT_RESPONSE_CANCEL:
		{
            new id = EditingGateID[playerid];
            GateData[id][GateEditing] = false;

		    switch(EditingGateType[playerid])
		    {
				case GATE_STATE_CLOSED:
				{
				    SetDynamicObjectPos(objectid, GateData[id][GatePos][0], GateData[id][GatePos][1], GateData[id][GatePos][2]);
				    SetDynamicObjectRot(objectid, GateData[id][GateRot][0], GateData[id][GateRot][1], GateData[id][GateRot][2]);
				    GateData[id][GatePos][0] = x;
					GateData[id][GatePos][1] = y;
					GateData[id][GatePos][2] = z;
					GateData[id][GateRot][0] = rx;
					GateData[id][GateRot][1] = ry;
					GateData[id][GateRot][2] = rz;
					SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Cancelled editing gate's default position.");
				}

				case GATE_STATE_OPEN:
				{
				    SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Cancelled editing gate's opening position.");

				    if(GateData[id][GateOpenPos][0] == 0.0 && GateData[id][GateOpenRot][0] == 0.0)
					{
				        SendClientMessage(playerid, 0xF39C12FF, "WARNING: {FFFFFF}This gate doesn't have an opening position.");
				        SendClientMessage(playerid, 0xF39C12FF, "WARNING: {FFFFFF}People won't be able to open it until you define an opening position.");
				    }

				    SetGateState(id, GATE_STATE_CLOSED, 2);
				    EditingGateID[playerid] = -1;
		    		EditingGateType[playerid] = -1;
				}
			}
		}
	}

	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	for(new o; o < sizeof(objfloat); o++)
	{
		if(pickupid == objfloat[o][pickupID]) GameTextForPlayer(playerid, objfloat[o][oinfomsg], 3000, 6);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & 16 && !IsPlayerInAnyVehicle(playerid))
	{
		CheckExit(playerid);
		CheckEnter(playerid);
	}
	if(newkeys & 2 && IsPlayerInAnyVehicle(playerid)) // h pressed
	{
	    new id = GetClosestGate(playerid);
		if(id == -1) return 1;
		if(GateData[id][GateEditing]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This gate is being edited, you can't use it.");
		if(GateData[id][GateOpenPos][0] == 0.0 && GateData[id][GateOpenRot][0] == 0.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This gate has no opening position.");
		if(!strlen(GateData[id][GatePassword])) {
		    ToggleGateState(id);
		}else{
		    if(HasGateAuth[playerid][id]) {
		        ToggleGateState(id);
			}else{
			    ShowPlayerDialog(playerid, DIALOG_GATE_PASSWORD, DIALOG_STYLE_PASSWORD, "Gate Password", "This gate is password protected.\nPlease enter this gate's password:", "Done", "Cancel");
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	new carid = FindVehicleID(vehicleid);
	if(vData[carid][vLocked] == 1 && vData[carid][vLockedBy] != forplayerid) SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
	else SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 0);
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(pData[playerid][Admin] > 4)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsPlayerInAnyVehicle(playerid))
        {
        	SetPlayerPos(playerid, fX, fY, fZ);
    	}
        else
        {
    		SetVehiclePos(vehicleid, fX, fY, fZ);
    	}
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if(listid == skinlist)
    {
        new bd = IsPlayerInBiz(playerid);
        if(bd == -1) return SendClientError(playerid, "You are not inside a biz.");
        if(bData[bd][bType] != BTYPE_CLOTHES) return SendClientError(playerid, "You are not inside clothes shop.");
        if(response)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Clothes Bought");
            SetPlayerSkin(playerid, modelid);
            pData[playerid][Skin] = modelid;
            GivePlayerMoneyEx(playerid, -bData[bd][bFee]);
        }
        else SendClientMessage(playerid, 0xFF0000FF, "Canceled clothes selection");
        return 1;
    }
    return 1;
}

PUBLIC:ImportHisCar(ssid)
{
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "SELECT * FROM `importcars` WHERE `ID` = '%i' LIMIT 1", ssid);
	mysql_tquery(MySQL, mQuery, "LoadedImportedCar");
}

PUBLIC:RemoveImportCarID(ssid)
{
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "DELETE FROM `importcars` WHERE `ID` = '%i'", ssid);
	mysql_tquery(MySQL, mQuery);
}

PUBLIC:LoadedImportedCar()
{
	if(cache_num_rows())
	{
	    new ssid, model, pname[24];
	    cache_get_value_name_int(0, "ID", ssid);
	    cache_get_value_name_int(0, "ModelID", model);
	    cache_get_value_name(0, "Name", pname);
		new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa;
		for(new i = 0; i < sizeof(ImportCarPos); i++)
		{
		    if(ImportCarPos[i][isUsed] == 0)
		    {
		        tmpx = ImportCarPos[i][posX];
		        tmpy = ImportCarPos[i][posY];
		        tmpz = ImportCarPos[i][posZ];
		        tmpa = ImportCarPos[i][posA];
				break;
		    }
		}
		new vid = GetUnusedVehicleID();
        if(vid == INVALID_VEHICLE_ID) return printf("Maximum vehicles created.");
        vData[vid][vModel] = model;
		format(vData[vid][vOwner], 24, pname);
		vData[vid][vX] = tmpx+0.2;
        vData[vid][vY] = tmpy+0.2;
        vData[vid][vZ] = tmpz+0.3;
        vData[vid][vA] = tmpa;
        vData[vid][vInt] = 0;
        vData[vid][vPaintJob] = 0;
        vData[vid][vColour1] = 0;
        vData[vid][vColour2] = 0;
        vData[vid][vSell] = 0;
        vData[vid][vLocked] = 0;
        vData[vid][vLockedBy] = INVALID_PLAYER_ID;
        vData[vid][vVW] = 0;
        vData[vid][vFuel] = 100;
        vData[vid][vMileage] = 0.0;
        vData[vid][vAlarm] = 0;
        vData[vid][vRegistered] = 0;
        vData[vid][vFaction] = -1;
        format(vData[vid][vPlate], 15, "NONE00");
        vData[vid][vActive] = 1;
        vData[vid][vID] = CreateVehicle(vData[vid][vModel], vData[vid][vX], vData[vid][vY], vData[vid][vZ], vData[vid][vA], vData[vid][vColour1], vData[vid][vColour2], -1);
        SetVehicleEngineOff(vData[vid][vID]);
		InsertVehicle(vid);
		RemoveImportCarID(ssid);
		if(IsPlayerConnected(GetPlayerID(pname)))
		{
		    SendClientMessage(GetPlayerID(pname), COLOR_GOLD, "[Platinum Exporters] Your vehicle has arrived, please take the keys from us as soon as possible.");
		}
	}
	else printf("Timer was set but the ssid row is not found means not inserted into table,");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
	{
		case DIALOG_GATE_PASSWORD:
		{
			if(!response) return 1;
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_GATE_PASSWORD, DIALOG_STYLE_PASSWORD, "Gate Password", "{E74C3C}You didn't write a password.\n{FFFFFF}Please enter this gate's password:", "Done", "Cancel");
			new id = GetClosestGate(playerid);
			if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a gate.");
			if(strcmp(GateData[id][GatePassword], inputtext)) return ShowPlayerDialog(playerid, DIALOG_GATE_PASSWORD, DIALOG_STYLE_PASSWORD, "Gate Password", "{E74C3C}Wrong password.\n{FFFFFF}Please enter this gate's password:", "Done", "Cancel");
			HasGateAuth[playerid][id] = true;
			ToggleGateState(id);
			return 1;
		}

		case DIALOG_GATE_EDITMENU:
		{
			if(pData[playerid][Admin] < 4) return 1;
			if(!response)
			{
				if(EditingGateID[playerid] != -1) GateData[ EditingGateID[playerid] ][GateEditing] = false;
				EditingGateID[playerid] = -1;
				return 1;
			}

			new id = EditingGateID[playerid];
			if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not editing a gate.");
			if(listitem == 0)
			{
				ToggleGateState(id);
				ShowEditMenu(playerid, id);
			}

			if(listitem == 1) ShowPlayerDialog(playerid, DIALOG_GATE_NEWPASSWORD, DIALOG_STYLE_INPUT, "Change Gate Password", "Write a new password for selected gate:\nYou can leave this empty if you want to remove gate's password.", "Update", "Cancel");
			if(listitem == 2)
			{
				SetGateState(id, GATE_STATE_CLOSED, 2);
				EditingGateType[playerid] = GATE_STATE_CLOSED;
				EditDynamicObject(playerid, GateData[id][GateObject]);
				SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Editing gate's default position.");
			}

			if(listitem == 3)
			{
				SetGateState(id, GATE_STATE_OPEN, 2);
				EditingGateType[playerid] = GATE_STATE_OPEN;
				EditDynamicObject(playerid, GateData[id][GateObject]);
				SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Editing gate's opening position.");
			}

			if(listitem == 4)
			{
				GateData[id][GateEditing] = false;
				GateData[id][GatePos][0] = GateData[id][GatePos][1] = GateData[id][GatePos][2] = 0.0;
				GateData[id][GateRot][0] = GateData[id][GateRot][1] = GateData[id][GateRot][2] = 0.0;
				GateData[id][GateOpenPos][0] = GateData[id][GateOpenPos][1] = GateData[id][GateOpenPos][2] = 0.0;
				GateData[id][GateOpenRot][0] = GateData[id][GateOpenRot][1] = GateData[id][GateOpenRot][2] = 0.0;
				DestroyDynamicObject(GateData[id][GateObject]);
				DestroyDynamic3DTextLabel(GateData[id][GateLabel]);
				Iter_Remove(Gates, id);

				DeleteGate(id);

				foreach(new i : Player) if(EditingGateID[i] == id) EditingGateID[i] = -1;
				SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Gate removed.");
			}

			return 1;
		}

		case DIALOG_GATE_NEWPASSWORD:
		{
			if(pData[playerid][Admin] < 4) return 1;
			new id = EditingGateID[playerid];
			if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not editing a gate.");
			if(!response) return ShowEditMenu(playerid, id);
			format(GateData[id][GatePassword], GATE_PASS_LEN, "%s", inputtext);
			foreach(new i : Player) HasGateAuth[i][id] = false;
			SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Password updated.");
			SaveGate(id);
			ShowEditMenu(playerid, id);
			return 1;
		}
	    case DIALOG_IMPORT:
	    {
	  		if(listitem == 0) // work for us
	  		{
	  		}
	  		if(listitem == 1) // buy
	  		{
	  		    ShowVehicleImportDialog(playerid);
	  		}
	    }

	    case DIALOG_VEHIMPORT:
	    {
	        if(GetPlayerMoneyEx(playerid) < vehshit[listitem][pricev]) return SendClientError(playerid, "You do not have enough money.");
 	        counter_cars++;
			new mid, pname[24], ssid;
			ssid = counter_cars;
			mid = vehshit[listitem][modelv];
			format(pname, 24, GetName(playerid));
			GivePlayerMoneyEx(playerid, -vehshit[listitem][pricev]);
			new mQuery[256];
			mysql_format(MySQL, mQuery, 256, "INSERT INTO `importcars` (`ID`, `ModelID`, `Name`) VALUES ('%i', '%i', '%e')", ssid, mid, pname);
			mysql_tquery(MySQL, mQuery);
			SetTimerEx("ImportHisCar", 1800000, false, "i", ssid);
			SendClientSuccess(playerid, "Your order has been placed. Please wait for its delivery. (Probably 30 hours.)");
	    }

		case DIALOG_GUNSMITH:
		{
			if(response)
			{
				if(listitem == 0)
				{
					if(GetPlayerMoneyEx(playerid) < wepshit[listitem][pricea]) return SendClientError(playerid, "You do not have enough money.");
					if(pData[playerid][Sellables] < wepshit[listitem][requ]) return SendClientError(playerid, "You do not have enough sellables.");
					GivePlayerWeapon(playerid, 24, 50);
					pData[playerid][Sellables] -= wepshit[listitem][requ];
					GivePlayerMoneyEx(playerid, -wepshit[listitem][pricea]);
				}
				if(listitem == 1)
				{
				    if(GetPlayerMoneyEx(playerid) < wepshit[listitem][pricea]) return SendClientError(playerid, "You do not have enough money.");
					if(pData[playerid][Sellables] < wepshit[listitem][requ]) return SendClientError(playerid, "You do not have enough sellables.");
					GivePlayerWeapon(playerid, 30, 100);
					pData[playerid][Sellables] -= wepshit[listitem][requ];
					GivePlayerMoneyEx(playerid, -wepshit[listitem][pricea]);
				}
				if(listitem == 2)
				{
				    if(GetPlayerMoneyEx(playerid) < wepshit[listitem][pricea]) return SendClientError(playerid, "You do not have enough money.");
					if(pData[playerid][Sellables] < wepshit[listitem][requ]) return SendClientError(playerid, "You do not have enough sellables.");
					GivePlayerWeapon(playerid, 34, 20);
					pData[playerid][Sellables] -= wepshit[listitem][requ];
					GivePlayerMoneyEx(playerid, -wepshit[listitem][pricea]);
				}
			}
		}

		case DIALOG_BANK_DEPOSIT:
		{
		    if(response)
		    {
		        new in = IsPlayerInBank(playerid);
				if(in == -1) return SendClientError(playerid, "You need to be inside a bank to use this command!");
				if(bankData[in][bankActive] != 1) return SendClientError(playerid, "Report this to Scripter.");
				if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Invalid amount.");
				if(pData[playerid][Money] < strval(inputtext)) return SendClientError(playerid, "You do not have enough money to deposit.");
				pData[playerid][bankMoney] += strval(inputtext);
				bankData[in][bankTotalMoney] += strval(inputtext);
				GivePlayerMoneyEx(playerid, -strval(inputtext));
				new mstr[256];
				format(mstr, 256, "[Bank: %i] You have successfully deposited $%i, your new balance is: $%i.", in, strval(inputtext), pData[playerid][bankMoney]);
				SendClientMessage(playerid, COLOR_GREEN, mstr);
			}
		}

		case DIALOG_BANK_WITHDRAW:
		{
		    if(response)
		    {
		        new in = IsPlayerInBank(playerid);
				if(in == -1) return SendClientError(playerid, "You need to be inside a bank to use this command!");
				if(bankData[in][bankActive] != 1) return SendClientError(playerid, "Report this to Scripter.");
				if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Invalid amount.");
				if(pData[playerid][bankMoney] < strval(inputtext)) return SendClientError(playerid, "You do not have enough money in bank to withdraw.");
				if(bankData[in][bankTotalMoney] < strval(inputtext)) return SendClientError(playerid, "The bank doesnt have enough money to give you! Try another bank.");
				pData[playerid][bankMoney] -= strval(inputtext);
				bankData[in][bankTotalMoney] -= strval(inputtext);
				GivePlayerMoneyEx(playerid, strval(inputtext));
				new mstr[256];
				format(mstr, 256, "[Bank: %i] You have successfully withdrawn $%i, your new balance is: $%i.", in, strval(inputtext), pData[playerid][bankMoney]);
				SendClientMessage(playerid, COLOR_GREEN, mstr);
			}
		}

	    case DIALOG_ADMIN_VEH:
	    {
			if(response)
			{
			    new newvid, vd;
       			newvid = GetPlayerVehicleID(playerid);
        		vd = FindVehicleID(newvid);
				switch(listitem)
	            {
	                case 0: ShowPlayerDialog(playerid, DIALOG_ADMIN_VEH_MODEL, DIALOG_STYLE_INPUT, "Model ID", "Please enter the Model ID you want to change to:", "Enter", "Quit");
	                case 1: ShowPlayerDialog(playerid, DIALOG_ADMIN_VEH_OWNER, DIALOG_STYLE_INPUT, "Vehicle Owner", "Please enter the Name you want to make owner of vehicle:", "Enter", "Quit");
	                case 2://Park Vehicle
	                {
	                    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
	                    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
				        newvid = GetPlayerVehicleID(playerid);
		        		vd = FindVehicleID(newvid);
		        		GetVehiclePos(newvid, tmpx, tmpy, tmpz);
						GetVehicleZAngle(newvid, tmpa);
						intt = GetPlayerInterior(playerid);
				        vww = GetPlayerVirtualWorld(playerid);
	                    vData[vd][vX] = tmpx;
		        		vData[vd][vY] = tmpy;
		        		vData[vd][vZ] = tmpz;
		        		vData[vd][vA] = tmpa;
		        		vData[vd][vInt] = intt;
		        		vData[vd][vVW] = vww;
		        		SendClientSuccess(playerid, "Parked the vehicle successfully.");
	                }
	                case 3: ShowPlayerDialog(playerid, DIALOG_ADMIN_VEH_COLOUR, DIALOG_STYLE_INPUT, "Colour ID", "Please enter the Colour IDs:\n[Color 1] [Color2]", "Enter", "Quit");
	                case 4: ShowPlayerDialog(playerid, DIALOG_ADMIN_VEH_SELL, DIALOG_STYLE_INPUT, "Sell Vehicle", "Please enter the price you want to sell this vehicle for:", "Enter", "Quit");
	                case 5: ShowPlayerDialog(playerid, DIALOG_ADMIN_VEH_PLATE, DIALOG_STYLE_INPUT, "Vehicle Plate", "Please enter the plate number for this vehicle:", "Enter", "Quit");
	                case 6:
	                {
	                    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
				        newvid = GetPlayerVehicleID(playerid);
		        		vd = FindVehicleID(newvid);
		        		Up(playerid);
		        		DeleteVehicle(vd);
		        		SendClientSuccess(playerid, "Deleted the vehicle successfully.");
	                }
	            }
			}
	    }
	    case DIALOG_ADMIN_VEH_MODEL:
	    {
	        if(response)
	        {
	            if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
	            new mid;
	            if(!strlen(inputtext)) return SendClientError(playerid, "Please type the model id you want to set.");
	            if(strval(inputtext) < 400 || strval(inputtext) > 612) return SendClientError(playerid, "Invalid MODEL ID");
	            if(!IsNumeric(inputtext))
	            {
	                mid = GetModelIDFromName(inputtext);
	                if(mid == -1) return SendClientError(playerid, "No such vehicle name found.");
	            }
	            else mid = strval(inputtext);
	            new newvid, vd;
		        newvid = GetPlayerVehicleID(playerid);
        		vd = FindVehicleID(newvid);
	            vData[vd][vModel] = mid;
	            SendClientSuccess(playerid, "Model ID set successfully.");
	        	SaveVehicle(vd);
				ReloadVehicle(vd);
	        }
	    }

	    case DIALOG_ADMIN_VEH_OWNER:
	    {
	        if(response)
	        {
	            if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
	            if(!strlen(inputtext)) return SendClientError(playerid, "Please type the owner name you want to set.");
				new newvid, vd;
		        newvid = GetPlayerVehicleID(playerid);
        		vd = FindVehicleID(newvid);
	            format(vData[vd][vOwner], 24, inputtext);
	            SendClientSuccess(playerid, "Vehicle Owner set successfully.");
	            SaveVehicle(vd);
	        }
	    }

	    case DIALOG_ADMIN_VEH_COLOUR:
	    {
	        if(response)
	        {
                if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
		        new cl1[10], cl2[10];
	            CheckForSpace(inputtext, cl1, cl2);
                new newvid, vd;
		        newvid = GetPlayerVehicleID(playerid);
        		vd = FindVehicleID(newvid);
				vData[vd][vColour1] = strval(cl1);
	            vData[vd][vColour2] = strval(cl2);
	            SaveVehicle(vd);
	            ChangeVehicleColor(vd, vData[vd][vColour1], vData[vd][vColour2]);
	        }
	    }

	    case DIALOG_ADMIN_VEH_SELL:
	    {
	        if(response)
	        {
	            if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
				new newvid, vd;
		        newvid = GetPlayerVehicleID(playerid);
        		vd = FindVehicleID(newvid);
	            if(!strlen(inputtext)) return SendClientError(playerid, "Please type the amount you want to sell the car for.");
                if(!IsNumeric(inputtext)) return SendClientError(playerid, "Please type the amount you want to sell the car for.");
                if(strval(inputtext) < 0) return SendClientError(playerid, "The sell price can not be less than 0.");
                vData[vd][vSell] = strval(inputtext);
				SendClientSuccess(playerid, "Vehicle on sell set successfully.");
				SaveVehicle(vd);
	        }
	    }

	    case DIALOG_ADMIN_VEH_PLATE:
	    {
	        if(response)
	        {
	            if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
				new newvid, vd;
		        newvid = GetPlayerVehicleID(playerid);
        		vd = FindVehicleID(newvid);
	            if(!strlen(inputtext)) return SendClientError(playerid, "Please type the number plate to set.");
                format(vData[vd][vPlate], 15, inputtext);
				SendClientSuccess(playerid, "Vehicle plate set successfully.");
				SaveVehicle(vd);
				ReloadVehicle(vd);
	        }
	    }


		case DIALOG_REGISTER:
		{
			if(!response) KickPlayer(playerid);

			if(isnull( inputtext )) // If the player has not yet entered a password.
			{
				SendClientError(playerid, "You need to type a password in");
				return ShowPlayerRegisterDialog(playerid);
			}

			new EscapedText[64], buffer[129];
			mysql_escape_string(inputtext, EscapedText);
			WP_Hash(buffer, sizeof(buffer), EscapedText);

			format(pData[playerid][Username], 24, "%s", GetPName(playerid));
			format(pData[playerid][Password], 129, "%s", buffer);
			format(pData[playerid][IPAddress], 16, "%s", GetPIp(playerid));
			pData[playerid][Faction] = -1;
			format(pData[playerid][pJob], 24, "None");

			new mQuery[256];
			mysql_format(MySQL, mQuery, 256, "INSERT INTO `playerdata` (`Username`, `Password`, `Faction`, `Job`) VALUES ('%e', '%e', '%i', '%e')", pData[playerid][Username], pData[playerid][Password], pData[playerid][Faction], pData[playerid][pJob]);
			mysql_tquery(MySQL, mQuery, "OnAccountRegistered", "i", playerid);
		}

		case DIALOG_LOGIN:
		{
			if(!response) return KickPlayer(playerid);

			new buffer[129], dstr[512];
			WP_Hash(buffer, sizeof(buffer), inputtext);

			if(strlen(inputtext) == 0) return ShowPlayerLoginDialog(playerid);

			if(strcmp(pData[playerid][Password], buffer, false, 129) == 0) // Password was correct
			{
				pData[playerid][pFailedLogins] = 0; //Reset Failed attempts
			    SendClientSuccess(playerid, "Welcome back, you are now logged in"); //Send Success message
			    pData[playerid][pLogged] = true; // Set the player as logged in
				format(pData[playerid][IPAddress], 16, "%s", GetPIp(playerid));
				DefaultSpawn(playerid);

			}
			else //Password was incorrect
			{
				if(pData[playerid][pFailedLogins] == 3)
				{
				    SendClientError(playerid, "You have been kicked (Too many login attempts)");
					return KickPlayer(playerid);
				}
				else
				{
					pData[playerid][pFailedLogins]++;
					format(dstr, sizeof(dstr), "Incorrect password.  Attempts remaining: %i", 4 - pData[playerid][pFailedLogins]);
					SendClientError(playerid, dstr);
					return ShowPlayerLoginDialog(playerid);
				}
			}
		}

		case DIALOG_PLAYER_CAR:
		{
		    if(response)
		    {
		        new vd = strval(inputtext);
		        new vid = vData[vd][vID];
		        new onestr[256], mstr[256], ilock[10];
				GetVehicleHealth(vid, vData[vd][vHealth]);
		        if(vData[vd][vLocked] == 1) format(ilock, 10, "Yes"); else format(ilock, 256, "No");
				format(onestr, 256, "%s's %s", RPName(playerid), VehicleName[vData[vd][vModel] - 400]);
				format(mstr, 256, "Name:\t\t\t%s\nMileage:\t\t%f\nFuel:\t\t\t\%i\nHealth:\t\t\t%f\nLocked:\t\t%s",
				VehicleName[vData[vd][vModel] - 400], vData[vd][vMileage], vData[vd][vFuel], vHealth, ilock );
				ShowPlayerDialog(playerid, DIALOG_PLAYER_CAR_IN, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
		    }
		}

		case DIALOG_PLAYER_CAR_IN:
		{
		    if(response)
		    {
		        OnPlayerCommandText(playerid, "/car");
		    }
		}

		case DIALOG_PLAYER_VEH:
		{
		    if(response)
		    {
		        if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle any more.");
		        if(listitem == 0) OnPlayerCommandText(playerid, "/car");
		        if(listitem == 1)
		        {
		            new newvid = GetPlayerVehicleID(playerid);
	        		new vd = FindVehicleID(newvid);
	        		new mstr[256];
		            if(vData[vd][vLocked] == 1)
			    	{
						if(DoesVehicleHaveLock(newvid) == 1)
						{
							UnlockVehicle(newvid);
							format(mstr, sizeof(mstr),"has unlocked their %s.", VehicleName[vData[vd][vModel] - 400]);
							Action(playerid, mstr);
						}
						else return SendClientError(playerid, "This vehicle doesn't have a lock.");
			    		return 1;
			    	}
			    	else if(vData[vd][vLocked] == 0)
				    {
						if(DoesVehicleHaveLock(newvid) == 1)
						{
							LockVehicle(-1, newvid); // nobody can open it
							format(mstr, sizeof(mstr),"has locked their %s.",VehicleName[vData[vd][vModel] - 400]);
							Action(playerid, mstr);
						}
						else return SendClientError(playerid, "This vehicle doesn't have a lock.");
					   	return 1;
			   		}
		        }
		        if(listitem == 2)
		        {
		            new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww, newvid, vd;
			        newvid = GetPlayerVehicleID(playerid);
	        		vd = FindVehicleID(newvid);
	        		GetVehiclePos(newvid, tmpx, tmpy, tmpz);
					GetVehicleZAngle(newvid, tmpa);
					intt = GetPlayerInterior(playerid);
			        vww = GetPlayerVirtualWorld(playerid);
                    vData[vd][vX] = tmpx;
	        		vData[vd][vY] = tmpy;
	        		vData[vd][vZ] = tmpz;
	        		vData[vd][vA] = tmpa;
	        		vData[vd][vInt] = intt;
	        		vData[vd][vVW] = vww;
	        		SendClientSuccess(playerid, "Parked the vehicle successfully.");
	        		OnPlayerCommandText(playerid, "/car");
		        }
		        if(listitem == 3)
		        {
		            SendClientError(playerid, "Lemme add busienss system so i add pay n spray");
		        }
		        if(listitem == 4)
		        {
		            if(GetPlayerFaction(playerid) == -1) return SendClientError(playerid, "You are not in any faction.");
		            new fid = GetPlayerFaction(playerid);
                    new newvid = GetPlayerVehicleID(playerid);
	        		new vd = FindVehicleID(newvid);
	        		if(vData[vd][vFaction] != -1) return SendClientError(playerid, "This vehicle is already of a faction.");
	        		vData[vd][vFaction] = fid;
					GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		        }
		        if(listitem == 5)
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_VEH_SELL, DIALOG_STYLE_INPUT, "Sell Vehicle", "Please enter the price you want to sell this vehicle for:", "Enter", "Quit");
		        }
		        if(listitem == 6)
		        {
		            new newvid, vd;
			        newvid = GetPlayerVehicleID(playerid);
	        		vd = FindVehicleID(newvid);
	        		SaveVehicle(vd);
	        		SendClientSuccess(playerid, "Saved the vehicle successfully.");
		        }
		    }
		}

		case DIALOG_ADMIN_HOUSE:
		{
		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
		        if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
		        if(listitem == 0) // owner
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_HOUSE_OWNER, DIALOG_STYLE_INPUT, "House Owner", "Please enter the Owner Name you want to set:", "Enter", "Quit");
		        }
		        if(listitem == 1) // interior
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_HOUSE_INT, DIALOG_STYLE_INPUT, "House Interior", "Please enter the Interior Pack (0-16) you want to set:", "Enter", "Quit");
		        }
		        if(listitem == 2) // alarm
		        {
		            if(hData[hid][hAlarm] == 0)
		            {
		                hData[hid][hAlarm] = 1;
		                SendClientSuccess(playerid, "Added alarm to the house successfully.");
		            }
		            else
		            {
		                hData[hid][hAlarm] = 0;
		                SendClientSuccess(playerid, "Removed alarm from the house successfully.");
		            }
		        }
		        if(listitem == 3) // money
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_HOUSE_MONEY, DIALOG_STYLE_INPUT, "House Money", "Please enter the amount you want to set:", "Enter", "Quit");
		        }
		        if(listitem == 4) // locked
		        {
		            if(hData[hid][hLocked] == 0)
		            {
		                hData[hid][hLocked] = 1;
		                SendClientSuccess(playerid, "Locked the house successfully.");
		            }
		            else
		            {
		                hData[hid][hLocked] = 0;
		                SendClientSuccess(playerid, "Unlocked the house successfully.");
		            }
		        }
		        if(listitem == 5) // sell
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_HOUSE_SELL, DIALOG_STYLE_INPUT, "Sell House", "Please enter the amount you want to sell for:", "Enter", "Quit");
		        }
		        if(listitem == 6) // save
		        {
					SaveHouse(hid);
					SendClientSuccess(playerid, "Saved the house successfully.");
		        }
		        if(listitem == 7) // reload
		        {
		            ReloadHouse(hid);
		            SendClientSuccess(playerid, "Reloaded the house successfull.");
		        }
		        if(listitem == 8) // delete
		        {
		            DeleteHouse(hid);
		            SendClientSuccess(playerid, "Deleted the house successfully.");
		        }
		    }
		}

		case DIALOG_ADMIN_HOUSE_OWNER:
		{
		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
		        if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
		        if(!strlen(inputtext)) return SendClientError(playerid, "Please type the name of owner you want to set.");
				format(hData[hid][hOwner], 24, inputtext);
				SendClientSuccess(playerid, "Changed the owner successfully.");
		    }
		}

		case DIALOG_ADMIN_HOUSE_INT:
		{
		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
		        if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
		        if(!strlen(inputtext)) return SendClientError(playerid, "Please type the interior pack you want to set.");
				if(!IsNumeric(inputtext) || strval(inputtext) < 0 || strval(inputtext) > 17) return SendClientError(playerid, "Only 0-16 Packs allowed.");
				hData[hid][hInteriorPack] = strval(inputtext);
				SendClientSuccess(playerid, "Changed the interior successfully.");
		    }
		}

		case DIALOG_ADMIN_HOUSE_MONEY:
		{
		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
		        if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
		        if(!strlen(inputtext)) return SendClientError(playerid, "Please enter the amount you want to set.");
				if(!IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientError(playerid, "Please type the AMOUNT you want to set.");
				hData[hid][hMoney] = strval(inputtext);
				SendClientSuccess(playerid, "Changed the money successfully.");
		    }
		}

		case DIALOG_ADMIN_HOUSE_SELL:
		{
		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
		        if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
		        if(!strlen(inputtext)) return SendClientError(playerid, "Please enter the amount you want to sell for.");
				if(!IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientError(playerid, "Please type the AMOUNT you want to sell for.");
				hData[hid][hSell] = strval(inputtext);
				SendClientSuccess(playerid, "Changed the SALE PRICE successfully.");
		    }
		}

		case DIALOG_PLAYER_HOUSE_OUT:
		{
			if(response)
			{
			    new hid = IsPlayerOutHouse(playerid);
			    if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
			    if(listitem == 0) // sell
			    {
			        ShowPlayerDialog(playerid, DIALOG_PLAYER_HOUSE_SELL, DIALOG_STYLE_INPUT, "Sell House", "Please enter the amount you want to sell for:", "Enter", "Quit");
			    }
			    if(listitem == 1) // upgrade
			    {
			        new mstr[256], tmpr[256];
			        format(mstr, 256, "%i\tLevel %i\t$%i", 0, HouseInteriors[0][hintpack], HouseInteriors[0][hprice]);
			        for(new i = 1; i < sizeof(HouseInteriors); i++)
			        {
						format(tmpr, 256, "%i\tLevel %i\t$%i", i, HouseInteriors[i][hintpack], HouseInteriors[i][hprice]);
						strcat(mstr, tmpr);
			        }
			        ShowPlayerDialog(playerid, DIALOG_PLAYER_HOUSE_INT, DIALOG_STYLE_TABLIST, "House Upgrade Interior", mstr, "OK", "Exit");
			    }
			    if(listitem == 2) // alarm
			    {
			        if(hData[hid][hAlarm] != 0) return SendClientError(playerid, "Your house already has installed alarm.");
			        else ShowPlayerDialog(playerid, DIALOG_PLAYER_HOUSE_ALARM, DIALOG_STYLE_MSGBOX, "House Alarm", "Are you  sure you want to buy house alarm?\n House alarm costs {33AA33}$50,000.", "Yes", "No");
			    }
			    if(listitem == 3) // lock
			    {
			        if(hData[hid][hLocked] == 0)
		            {
		                hData[hid][hLocked] = 1;
		                GameTextForPlayer(playerid,"~r~Locked", 3000, 3);
		            }
		            else
		            {
		                hData[hid][hLocked] = 0;
		                GameTextForPlayer(playerid,"~g~Unlocked", 3000, 3);
		            }
			    }
			}
		}

		case DIALOG_PLAYER_HOUSE_SELL:
		{
		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
			    if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
			    if(!strlen(inputtext) || !IsNumeric(inputtext)) return SendClientError(playerid, "Please type the amount you want to sell this house for.");
			    if(strval(inputtext) < 0) return SendClientError(playerid, "Can not be less than zero.");
			    hData[hid][hSell] = strval(inputtext);
			    ReloadHouse(hid);
		    }
		}

		case DIALOG_PLAYER_HOUSE_INT:
		{
		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
			    if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
			    if(GetPlayerMoneyEx(playerid) < HouseInteriors[strval(inputtext)][hprice]) return SendClientError(playerid, "You do not have enough money.");
				hData[hid][hInteriorPack] = strval(inputtext);
				GivePlayerMoneyEx(playerid, -HouseInteriors[strval(inputtext)][hprice]);
				SendClientSuccess(playerid, "You have successfully upgraded the interior.");
				ReloadHouse(hid);
		    }
		}

		case DIALOG_PLAYER_HOUSE_ALARM:
		{

		    if(response)
		    {
		        new hid = IsPlayerOutHouse(playerid);
			    if(hid == -1) return SendClientError(playerid, "You are not outside the house anymore.");
				if(GetPlayerMoneyEx(playerid) < 50000) return  SendClientError(playerid, "You do not have enough money.");
				GivePlayerMoneyEx(playerid, -50000);
				hData[hid][hAlarm] = 1;
				SendClientSuccess(playerid, "You have successfully added alarm to the house.");
				ReloadHouse(hid);
		    }
		}

		case DIALOG_PLAYER_HOUSE_IN:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0)
		        {
		            if(hData[hid][hSafe] == 0) // unlocked
		            {
		                new mstr[256];
						format(mstr, 256, "Money: {33AA33}$%i\nDrugs\nWeapons", hData[hid][hMoney]);
					    ShowPlayerDialog(playerid, DIALOG_HOUSE_IN_SAFE, DIALOG_STYLE_LIST, "House Safe", mstr, "OK", " Exit");
		            }
		            else if(hData[hid][hSafe] == 1) // locked
		            {
		                if(strcmp(hData[hid][hOwner], GetName(playerid), false)) return SendClientError(playerid, "The safe is locked, you dont have keys aswell.");
		                else return SendClientError(playerid, "Please unlock the safe first.");
		            }
		        }
		        if(listitem == 1)
		        {
		            if(strcmp(hData[hid][hOwner], GetName(playerid), false)) return SendClientError(playerid, "You dont have keys to lock/unlock the safe.");
		            if(hData[hid][hSafe] == 0)
		            {
		                hData[hid][hSafe] = 1;
		                return GameTextForPlayer(playerid,"~r~Locked", 3000, 3);
		            }
		            if(hData[hid][hSafe] == 1)
		            {
		                hData[hid][hSafe] = 0;
		                return GameTextForPlayer(playerid,"~g~Unlocked", 3000, 3);
		            }
		        }
			}
		}

		case DIALOG_HOUSE_IN_SAFE:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0)
		        {
		            ShowPlayerDialog(playerid, DIALOG_HOUSE_IN_MONEY, DIALOG_STYLE_LIST, "House Safe", "Take Money\nPut Money", "OK", " Exit");
		        }
		        if(listitem == 1)
		        {
		            ShowPlayerDialog(playerid, DIALOG_HOUSE_IN_DRUGS, DIALOG_STYLE_LIST, "House Safe", "Take Drugs\nPut Drugs", "OK", " Exit");
		        }
		        if(listitem == 2)
		        {
		            ShowPlayerDialog(playerid, DIALOG_HOUSE_IN_GUNS, DIALOG_STYLE_LIST, "House Safe", "Take Guns\nPut Guns", "OK", " Exit");
		        }
		    }
		}

		case DIALOG_HOUSE_IN_MONEY:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0) // take
		        {
		            if(hData[hid][hMoney] < 1) return SendClientError(playerid, "There is no money in the safe to take from.");
		            else ShowPlayerDialog(playerid, DIALOG_HOUSE_MONEY_TAKE, DIALOG_STYLE_INPUT, "Take Money", "Please enter the amount you want to take:", "Enter", "Quit");
		        }
		        if(listitem == 1) // put
		        {
		            ShowPlayerDialog(playerid, DIALOG_HOUSE_MONEY_PUT, DIALOG_STYLE_INPUT, "Put Money", "Please enter the amount you want to put:", "Enter", "Quit");
		        }
		    }
		}

		case DIALOG_HOUSE_IN_DRUGS:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0) // take
		        {
		            new mstr[256];
		            format(mstr, 256, "%s: %i\n%s: %i\n%s: %i", DrugData[0][drugname], hData[hid][hDrugs][0], DrugData[1][drugname], hData[hid][hDrugs][1], DrugData[2][drugname], hData[hid][hDrugs][2]);
					if(hData[hid][hDrugs][0] == 0 && hData[hid][hDrugs][1] == 0 && hData[hid][hDrugs][2] == 0) return SendClientError(playerid, "There is no any drugs stored");
	 				else ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_TAKE, DIALOG_STYLE_LIST, "Take Drugs", mstr, "OK", "Exit");
				}
		        if(listitem == 1) // put
		        {
		            new mstr[256];
		            format(mstr, 256, "%s: %i\n%s: %i\n%s: %i", DrugData[0][drugname], hData[hid][hDrugs][0], DrugData[1][drugname], hData[hid][hDrugs][1], DrugData[2][drugname], hData[hid][hDrugs][2]);
					ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_PUT, DIALOG_STYLE_LIST, "Put Drugs", mstr, "OK", "Exit");
		        }
		    }
		}

		case DIALOG_HOUSE_IN_GUNS:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0) // take
		        {
		            new mstr[256];
		            if(hData[hid][hGuns][0] == 0 && hData[hid][hGuns][1] == 0) return SendClientError(playerid, "No any weapon is stored in the safe.");
		            format(mstr, 256, "Weapon Slot 1 (%s - %i)\nWeapon Slot 2 (%s - %i)", GetWeaponNameByID(hData[hid][hGuns][0]), hData[hid][hAmmo][0], GetWeaponNameByID(hData[hid][hGuns][1]), hData[hid][hAmmo][1]);
					ShowPlayerDialog(playerid, DIALOG_HOUSE_GUNS_TAKE, DIALOG_STYLE_LIST, "Take Gun", mstr, "OK", "Exit");
				}
		        if(listitem == 1) // put
		        {
		            new mstr[256];
		            format(mstr, 256, "Weapon Slot 1 (%s - %i)\nWeapon Slot 2 (%s - %i)", GetWeaponNameByID(hData[hid][hGuns][0]), hData[hid][hAmmo][0], GetWeaponNameByID(hData[hid][hGuns][1]), hData[hid][hAmmo][1]);
					ShowPlayerDialog(playerid, DIALOG_HOUSE_GUNS_PUT, DIALOG_STYLE_LIST, "Put Gun", mstr, "OK", "Exit");
		        }
		    }
		}

		case DIALOG_HOUSE_GUNS_TAKE:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0)
		        {
		            if(hData[hid][hGuns][0] == 0) return SendClientError(playerid, "There is no any gun stored in this slot.");
		            GivePlayerWeapon(playerid, hData[hid][hGuns][0], hData[hid][hAmmo][0]);
		            hData[hid][hGuns][0] = 0;
		            hData[hid][hAmmo][0] = 0;
		            GameTextForPlayer(playerid,"~g~Taken Gun", 3000, 3);
		        }
		        if(listitem == 1)
		        {
		            if(hData[hid][hGuns][1] == 0) return SendClientError(playerid, "There is no any gun stored in this slot.");
		            GivePlayerWeapon(playerid, hData[hid][hGuns][1], hData[hid][hAmmo][1]);
		            hData[hid][hGuns][1] = 0;
		            hData[hid][hAmmo][1] = 0;
		            GameTextForPlayer(playerid,"~g~Taken Gun", 3000, 3);
		        }
		    }
		}

		case DIALOG_HOUSE_GUNS_PUT:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0)
		        {
		            if(hData[hid][hGuns][0] != 0) return SendClientError(playerid, "There is a gun stored in the slot already.");
					if(GetPlayerWeapon(playerid) == 0) return SendClientError(playerid, "You are not holding any gun!");
					hData[hid][hGuns][0] = GetPlayerWeapon(playerid);
					hData[hid][hAmmo][0] = GetPlayerAmmo(playerid);
					RemovePlayerWeapon(playerid, GetPlayerWeapon(playerid));
					GameTextForPlayer(playerid,"~g~Put Gun", 3000, 3);
		        }
		        if(listitem == 1)
		        {
		            if(hData[hid][hGuns][1] != 0) return SendClientError(playerid, "There is a gun stored in the slot already.");
					if(GetPlayerWeapon(playerid) == 0) return SendClientError(playerid, "You are not holding any gun!");
					hData[hid][hGuns][1] = GetPlayerWeapon(playerid);
					hData[hid][hAmmo][1] = GetPlayerAmmo(playerid);
					RemovePlayerWeapon(playerid, GetPlayerWeapon(playerid));
					GameTextForPlayer(playerid,"~g~Put Gun", 3000, 3);
		        }
		    }
		}

		case DIALOG_HOUSE_MONEY_TAKE:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to take.");
		        if(strval(inputtext) > hData[hid][hMoney]) return SendClientError(playerid, "There is not this much amount in the safe.");
		        GivePlayerMoneyEx(playerid, strval(inputtext));
		        hData[hid][hMoney] -= strval(inputtext);
		        GameTextForPlayer(playerid,"~g~Taken Money", 3000, 3);
		    }
		}

		case DIALOG_HOUSE_MONEY_PUT:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to put.");
		        if(strval(inputtext) > GetPlayerMoneyEx(playerid)) return SendClientError(playerid, "You do not have this much money on you.");
		        GivePlayerMoneyEx(playerid, -strval(inputtext));
		        hData[hid][hMoney] += strval(inputtext);
		        GameTextForPlayer(playerid,"~g~Put Money", 3000, 3);
		    }
		}

		case DIALOG_HOUSE_DRUGS_TAKE:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0)
		        {
		            if(hData[hid][hDrugs][0] < 1) return SendClientError(playerid, "There is no drug stored.");
			        else ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_TAKE0, DIALOG_STYLE_INPUT, "Take Cannabis", "Please enter the amount you want to take:", "OK", "Exit");
		        }
		        if(listitem == 1)
		        {
		            if(hData[hid][hDrugs][1] < 1) return SendClientError(playerid, "There is no drug stored.");
			        else ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_TAKE1, DIALOG_STYLE_INPUT, "Take Cocaine", "Please enter the amount you want to take:", "OK", "Exit");
		        }
		        if(listitem == 2)
		        {
		            if(hData[hid][hDrugs][2] < 1) return SendClientError(playerid, "There is no drug stored.");
			        else ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_TAKE2, DIALOG_STYLE_INPUT, "Take Heroin", "Please enter the amount you want to take:", "OK", "Exit");
				}
		    }
		}

		case DIALOG_HOUSE_DRUGS_TAKE0:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to take.");
		        if(strval(inputtext) > hData[hid][hDrugs][0]) return SendClientError(playerid, "You do not have this much drugs in the safe.");
		        pData[playerid][pDrugs][0] += strval(inputtext);
		        hData[hid][hDrugs][0] -= strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Taken Cannabis", 3000, 3);
		    }
		}
		case DIALOG_HOUSE_DRUGS_TAKE1:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to take.");
		        if(strval(inputtext) > hData[hid][hDrugs][1]) return SendClientError(playerid, "You do not have this much drugs in the safe.");
		        pData[playerid][pDrugs][1] += strval(inputtext);
		        hData[hid][hDrugs][1] -= strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Taken Cocaine", 3000, 3);
		    }
		}
		case DIALOG_HOUSE_DRUGS_TAKE2:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to take.");
		        if(strval(inputtext) > hData[hid][hDrugs][2]) return SendClientError(playerid, "You do not have this much drugs in the safe.");
		        pData[playerid][pDrugs][2] += strval(inputtext);
		        hData[hid][hDrugs][2] -= strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Taken Heroin", 3000, 3);
		    }
		}

		case DIALOG_HOUSE_DRUGS_PUT:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(listitem == 0)
		        {
		            ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_PUT0, DIALOG_STYLE_INPUT, "Put Cannabis", "Please enter the amount you want to put:", "OK", "Exit");
		        }
		        if(listitem == 1)
		        {
		            ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_PUT1, DIALOG_STYLE_INPUT, "Put Cocaine", "Please enter the amount you want to put:", "OK", "Exit");
		        }
		        if(listitem == 2)
		        {
		            ShowPlayerDialog(playerid, DIALOG_HOUSE_DRUGS_PUT2, DIALOG_STYLE_INPUT, "Put Heroin", "Please enter the amount you want to put:", "OK", "Exit");
				}
		    }
		}

		case DIALOG_HOUSE_DRUGS_PUT0:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to put.");
		        if(strval(inputtext) > pData[playerid][pDrugs][0]) return SendClientError(playerid, "You do not have this much drugs on you.");
		        pData[playerid][pDrugs][0] -= strval(inputtext);
		        hData[hid][hDrugs][0] += strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Put Cannabis", 3000, 3);
		    }
		}

		case DIALOG_HOUSE_DRUGS_PUT1:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to put.");
		        if(strval(inputtext) > pData[playerid][pDrugs][1]) return SendClientError(playerid, "You do not have this much drugs on you.");
		        pData[playerid][pDrugs][1] -= strval(inputtext);
		        hData[hid][hDrugs][1] += strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Put Cocaine", 3000, 3);
		    }
		}

		case DIALOG_HOUSE_DRUGS_PUT2:
		{
		    new hid = IsPlayerInHouse(playerid);
		    if(hid == -1) return SendClientError(playerid, "You are not inside the house anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1) return SendClientError(playerid, "Please enter the amount you want to put.");
		        if(strval(inputtext) > pData[playerid][pDrugs][2]) return SendClientError(playerid, "You do not have this much drugs on you.");
		        pData[playerid][pDrugs][2] -= strval(inputtext);
		        hData[hid][hDrugs][2] += strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Put Heroin", 3000, 3);
		    }
		}

		case DIALOG_BIZ_CRT:
		{
		    if(response)
		    {
		        new bid = GetUnusedBizID();
		        if(bid == -1) return SendClientError(playerid, "Max businesses created.");
				format(bData[bid][bOwner], 24, "None");
				format(bData[bid][bName], 256, "NO Name");
				new Float:tmpx, Float:tmpy, Float:tmpz, intt, vww;
				GetPlayerPos(playerid, tmpx, tmpy, tmpz);
				intt = GetPlayerInterior(playerid);
				vww = GetPlayerVirtualWorld(playerid);
				bData[bid][bX] = tmpx;
				bData[bid][bY] = tmpy;
				bData[bid][bZ] = tmpz;
				bData[bid][bInt] = intt;
				bData[bid][bVW] = vww;
				bData[bid][bMoney] = 0;
				bData[bid][bLocked] = 0;
				bData[bid][bSell] = 0;
				bData[bid][bFee] = 0;
				for(new i = 0; i < sizeof(BusinessInteriors); i++)
				{
				    if(BizTypeList[listitem][biz_T] == BusinessInteriors[i][intType])
				    {
				        bData[bid][bType] = BizTypeList[listitem][biz_T];
				        bData[bid][bInteriorPack] = BusinessInteriors[i][interiorid];
				        break;
				    }
				}
				bData[bid][bActive] = 1;
				InsertBiz(bid); // interior type fee name
	         	new string[512], zone[48];
			    GetZone(bData[bid][bX], bData[bid][bY], bData[bid][bZ], zone);
				if(bData[bid][bSell] < 1) format(string,sizeof(string),"[ %s ] \nOwner: %s\nAddress: %s, %d", bData[bid][bName],  NoUnderscore(bData[bid][bOwner]),zone,bid);
				else format(string,sizeof(string),"[ %s ]\nOwner: %s\nAddress: %s %d\nPrice: $%d (/buybiz to  buy)", bData[bid][bName], NoUnderscore(bData[bid][bOwner]),zone,bid, bData[bid][bSell]);
				bData[bid][bLabel] = CreateDynamic3DTextLabel(string, -1,  bData[bid][bX], bData[bid][bY], bData[bid][bZ], 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
	            bData[bid][bMapIcon] = CreateDynamicMapIcon(bData[bid][bX], bData[bid][bY], bData[bid][bZ], 56, 0xAAFFAAFF);
		    }
		}



		case DIALOG_ADMIN_BIZ:
		{
		    if(response)
		    {
		        new bid = IsPlayerOutBiz(playerid);
		        if(bid == -1) return SendClientError(playerid, "You are not outside the biz anymore.");
				if(listitem == 0) // name
				{
				    ShowPlayerDialog(playerid, DIALOG_ADMIN_BIZ_NAME, DIALOG_STYLE_INPUT, "Edit Name", "Please enter the new biz name you want to set:", "OK", "Exit");
				}
				if(listitem == 1) // owner
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_BIZ_OWNER, DIALOG_STYLE_INPUT, "Edit Owner", "Please enter the new owner name you want to set:", "OK", "Exit");
		        }
		        if(listitem == 2) //money
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_BIZ_MONEY, DIALOG_STYLE_INPUT, "Edit Money", "Please enter the new amount you want to set:", "OK", "Exit");
		        }
		        if(listitem == 3) //locked
		        {
		            if(bData[bid][bLocked] == 0)
		            {
		                bData[bid][bLocked] = 1;
						GameTextForPlayer(playerid, "~r~Locked", 3000, 3);
		            }
		            else
		            {
		                bData[bid][bLocked] = 0;
						GameTextForPlayer(playerid, "~g~Unlocked", 3000, 3);
		            }
		        }
		        if(listitem == 4) //sell
		        {
                    ShowPlayerDialog(playerid, DIALOG_ADMIN_BIZ_SELL, DIALOG_STYLE_INPUT, "Edit Sell Price", "Please enter the amount you want to sell for:", "OK", "Exit");
		        }
		        if(listitem == 5) // fee
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_BIZ_FEE, DIALOG_STYLE_INPUT, "Business Fee", "Please enter the amount you want to set fee:", "OK", "Exit");
		        }
		        if(listitem == 6) //save
		        {
		            SaveBiz(bid);
		            SendClientSuccess(playerid, "Saved the biz successfully.");
		        }
		        if(listitem == 7) // reload
		        {
		            ReloadBiz(bid);
		            SendClientSuccess(playerid, "Reloaded the biz successfully.");
		        }
		        if(listitem == 8) // delete
		        {
		            DeleteBiz(bid);
		            SendClientSuccess(playerid, "Deleted the biz successfully.");
		        }
		    }
		}

		case DIALOG_ADMIN_BIZ_FEE:
		{
		    if(response)
		    {
		        new bid = IsPlayerOutBiz(playerid);
		        if(bid == -1) return SendClientError(playerid, "You are not outside the biz anymore.");
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientError(playerid, "Please enter the amount.");
		        bData[bid][bFee] = strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

		case DIALOG_ADMIN_BIZ_OWNER:
		{
		    if(response)
		    {
                new bid = IsPlayerOutBiz(playerid);
		        if(bid == -1) return SendClientError(playerid, "You are not outside the biz anymore.");
		        if(!strlen(inputtext)) return SendClientError(playerid, "Please type the new owner name.");
		        format(bData[bid][bOwner], 24, inputtext);
		        GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

		case DIALOG_ADMIN_BIZ_NAME:
		{
		    if(response)
		    {
                new bid = IsPlayerOutBiz(playerid);
		        if(bid == -1) return SendClientError(playerid, "You are not outside the biz anymore.");
		        if(!strlen(inputtext)) return SendClientError(playerid, "Please type the new biz name.");
		        format(bData[bid][bName], 256, inputtext);
		        GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

		case DIALOG_ADMIN_BIZ_MONEY:
		{
		    if(response)
		    {
                new bid = IsPlayerOutBiz(playerid);
		        if(bid == -1) return SendClientError(playerid, "You are not outside the biz anymore.");
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientError(playerid, "Please enter the amount.");
		        bData[bid][bMoney] = strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

		case DIALOG_ADMIN_BIZ_SELL:
		{
		    if(response)
		    {
                new bid = IsPlayerOutBiz(playerid);
		        if(bid == -1) return SendClientError(playerid, "You are not outside the biz anymore.");
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientError(playerid, "Please enter the amount you want to sell for.");
		        bData[bid][bSell] = strval(inputtext);
		        GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

		case DIALOG_PLAYER_BIZ:
		{
		    if(response)
		    {
		        new bd;
		        bd = GetNumberFromString(inputtext);
		        if(bd != -1)
		        {
		            new mstr[256], onestr[256], lock[4];
		            if(bData[bd][bLocked] == 0) format(lock, 4, "No"); else format(lock, 4, "Yes");
				    format(onestr, 256, "%s's %s", NoUnderscore(bData[bd][bOwner]), bData[bd][bName]);
					format(mstr, 256, "Name:\t\t\t%s\nLocked:\t\t%s\nMoney:\t\t\t$%i", bData[bd][bName], lock, bData[bd][bMoney]);
					ShowPlayerDialog(playerid, DIALOG_PLAYER_BIZ_INFO, DIALOG_STYLE_MSGBOX, onestr, mstr, "OK", "Exit");
		        }
		    }
		}

		case DIALOG_PLAYER_BIZ_OUT:
		{
		    if(response)
		    {
		        new bid = IsPlayerOutBiz(playerid);
          		if(bid == -1) return SendClientError(playerid, "You are not outside your business anymore.");
		        if(listitem == 0) //name
		        {
                    ShowPlayerDialog(playerid, DIALOG_BIZ_NAME, DIALOG_STYLE_MSGBOX, "Business Name Change", "Do you really want to change business name?\nChanging a business's name costs {33AA33}$30,000", "Yes", "No");
		        }
		        if(listitem == 1) //lock
		        {
		            if(bData[bid][bLocked] == 0)
		            {
		                bData[bid][bLocked] = 1;
						GameTextForPlayer(playerid, "~r~Locked", 3000, 3);
		            }
		            if(bData[bid][bLocked] == 1)
		            {
		                bData[bid][bLocked] = 0;
						GameTextForPlayer(playerid, "~g~Unlocked", 3000, 3);
		            }
		        }
		        if(listitem == 2) // fee
		        {
		            ShowPlayerDialog(playerid, DIALOG_ADMIN_BIZ_FEE, DIALOG_STYLE_INPUT, "Business Fee", "Please enter the amount you want to set fee:", "OK", "Exit");
		        }
		        if(listitem == 3) // sell
		        {
		            ShowPlayerDialog(playerid, DIALOG_BIZ_SELL, DIALOG_STYLE_INPUT, "Business Sell", "Please enter the amount you want to sell for.", "Yes", "No");
		        }
		        if(listitem == 4) // details
		        {
					new onestr[256], mstr[256];
					format(onestr, 256, "%s's Details", bData[bid][bName]);
					format(mstr, 256, "Name: %s\nMoney: $%i\nTax: (Will add soon)", bData[bid][bName], bData[bid][bMoney]);
		            ShowPlayerDialog(playerid, DIALOG_BIZ_DETAILS, DIALOG_STYLE_MSGBOX, onestr, mstr, "OK", "");
		        }
		    }
		}

		case DIALOG_BIZ_NAME:
		{
		    new bid = IsPlayerOutBiz(playerid);
    		if(bid == -1) return SendClientError(playerid, "You are not outside your business anymore.");
		    if(response)
		    {
                ShowPlayerDialog(playerid, DIALOG_BIZ_NAME1, DIALOG_STYLE_INPUT, "Business Name Change", "Please enter the new name you want to set.", "Yes", "No");
		    }
		}

		case DIALOG_BIZ_NAME1:
		{
		    new bid = IsPlayerOutBiz(playerid);
    		if(bid == -1) return SendClientError(playerid, "You are not outside your business anymore.");
		    if(response)
		    {
		        if(strlen(inputtext) < 8) return SendClientError(playerid, "Please enter at least 8 characters as a name.");
				format(bData[bid][bName], 256, inputtext);
				GivePlayerMoneyEx(playerid, -30000);
				GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
				ReloadBiz(bid);
		    }
		}

		case DIALOG_BIZ_SELL:
		{
		    new bid = IsPlayerOutBiz(playerid);
    		if(bid == -1) return SendClientError(playerid, "You are not outside your business anymore.");
		    if(response)
		    {
		        if(!strlen(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientError(playerid, "Please enter amount you want to sell for.");
				bData[bid][bSell] = strval(inputtext);
				GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
				ReloadBiz(bid);
		    }
		}

		case DIALOG_BUY_HARDWARE:
		{
		    if(response)
		    {
		        new bd = IsPlayerInBiz(playerid);
		        if(bd == -1) return SendClientError(playerid, "You are not inside any business.");
		        if(listitem == HARDWARE_TOOLKIT)
		        {
		            if(pData[playerid][pToolkit] != 0) return SendClientError(playerid, "You already have a toolkit on you!");
		            if(GetPlayerMoneyEx(playerid) < hardwareItems[HARDWARE_TOOLKIT][hardwarePrice]) return SendClientError(playerid, "You do not have enough money!");
		            GivePlayerMoneyEx(playerid, -hardwareItems[HARDWARE_TOOLKIT][hardwarePrice]);
		            pData[playerid][pToolkit] = 1;
		            bData[bd][bMoney] += hardwareItems[HARDWARE_TOOLKIT][hardwarePrice] * 3;
		            SendClientSuccess(playerid, "You have bought a vehicle toolkit successfully. Store it ina vehicle by /storetoolkit.");
				}
			}
		}

		case DIALOG_BUY_247:
		{
		    if(response)
		    {
		        new bd = IsPlayerInBiz(playerid);
		        if(bd == -1) return SendClientError(playerid, "You are not inside any business.");
		        if(listitem == b247_PHONE)
		        {
		            if(pData[playerid][hasPhone] == 1) return SendClientError(playerid, "You already have a phone on you.");
		            if(GetPlayerMoneyEx(playerid) < b247Items[b247_PHONE][b247price]) return SendClientError(playerid, "You do not have enough money to buy this.");
		            pData[playerid][hasPhone] = 1;
		            GivePlayerMoneyEx(playerid, -b247Items[b247_PHONE][b247price]);
		            SendClientSuccess(playerid, "You have bought a Mobile Phone successfully.");
		            bData[bd][bMoney] += b247Items[b247_PHONE][b247price] * 3;
		        }
		        if(listitem == b247_SIM)
		        {
		            if(pData[playerid][hasSIM] == 1) return SendClientError(playerid, "You already have a SIM Card on you.");
		            if(GetPlayerMoneyEx(playerid) < b247Items[b247_SIM][b247price]) return SendClientError(playerid, "You do not have enough money to buy this.");
		            pData[playerid][hasSIM] = 1;
		            GivePlayerMoneyEx(playerid, -b247Items[b247_SIM][b247price]);
		            SendClientSuccess(playerid, "You have bought a SIM Card successfully.");
		            bData[bd][bMoney] += b247Items[b247_SIM][b247price] * 3;
		        }
		        if(listitem == b247_RADIO)
		        {
		            if(pData[playerid][hasRadio] == 1) return SendClientError(playerid, "You already have a radio on you.");
		            if(GetPlayerMoneyEx(playerid) < b247Items[b247_RADIO][b247price]) return SendClientError(playerid, "You do not have enough money to buy this.");
		            pData[playerid][hasRadio] = 1;
		            GivePlayerMoneyEx(playerid, -b247Items[b247_RADIO][b247price]);
		            SendClientSuccess(playerid, "You have bought a Radio successfully.");
		            bData[bd][bMoney] += b247Items[b247_RADIO][b247price] * 3;
		        }
		        if(listitem == b247_GPS)
		        {
		            if(pData[playerid][hasGPS] == 1) return SendClientError(playerid, "You already have a GPS on you.");
		            if(GetPlayerMoneyEx(playerid) < b247Items[b247_GPS][b247price]) return SendClientError(playerid, "You do not have enough money to buy this.");
		            pData[playerid][hasGPS] = 1;
		            GivePlayerMoneyEx(playerid, -b247Items[b247_GPS][b247price]);
		            SendClientSuccess(playerid, "You have bought a Portable GPS successfully.");
		            bData[bd][bMoney] += b247Items[b247_GPS][b247price] * 3;
		        }
		    }
		}

		case DIALOG_BUY_AMMU:
		{
		    if(response)
		    {
		        new bd = IsPlayerInBiz(playerid);
		        if(bd == -1) return SendClientError(playerid, "You are not inside any business.");
          		if(GetPlayerMoneyEx(playerid) < AmmuItems[listitem][ammuprice]) return SendClientError(playerid, "You do not have enough money.");
          		GivePlayerWeapon(playerid, AmmuItems[listitem][ammuwepid], AmmuItems[listitem][ammuammo]);
          		GivePlayerMoneyEx(playerid, -AmmuItems[listitem][ammuprice]);
          		bData[bd][bMoney] += AmmuItems[listitem][ammuprice] * 2;
          		SendClientSuccess(playerid, "You have successfully bought the weapon.");
		    }
		}

		case DIALOG_CLOSEST_BIZS:
		{
			if(response)
			{
				new bd = GetClosestBiz(playerid, listitem, 0);
			    SetPlayerCheckpoint(playerid, bData[bd][bX], bData[bd][bY], bData[bd][bZ], 3.0);
			    SendClientSuccess(playerid, "Navigated the business successfully.");
			}
		}

		case DIALOG_FACTION_CRT:
		{
		    if(response)
		    {
		        new fid = GetUnusedFacID();
		        if(fid == -1) return SendClientError(playerid, "Max factions created.");
				format(fData[fid][fLeader], 24, "None");
				format(fData[fid][fName], 256, "NO Name");
				new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
				GetPlayerPos(playerid, tmpx, tmpy, tmpz);
				GetPlayerFacingAngle(playerid, tmpa);
				intt = GetPlayerInterior(playerid);
				vww = GetPlayerVirtualWorld(playerid);

				for(new i = 0; i < sizeof(FactionInteriors); i++)
				{
				    if(FacTypeList[listitem][fac_T] == FactionInteriors[i][facType])
				    {
				        fData[fid][fType] = FacTypeList[listitem][fac_T];
				        fData[fid][fInteriorPack] = FactionInteriors[i][finteriorid];
						fData[fid][fInX] = FactionInteriors[i][enterX];
						fData[fid][fInY] = FactionInteriors[i][enterY];
						fData[fid][fInZ] = FactionInteriors[i][enterZ];
						fData[fid][fInA] = FactionInteriors[i][enterA];
						fData[fid][fInInt] = FactionInteriors[i][enterInt];
						fData[fid][fInVW] = fid+1;
				        break;
				    }
				}

				fData[fid][fColour] = 1;
				fData[fid][fChat] = 1;
				fData[fid][fPoints] = 0;
				fData[fid][fMaxVehicles] = 10;
				fData[fid][fMaxMemberSlots] = 10;
				fData[fid][fStartPayment] = 1000;
				fData[fid][fBank] = 20000;
				fData[fid][fFreq] = 0;

				fData[fid][fhX] = tmpx;
				fData[fid][fhY] = tmpy;
				fData[fid][fhZ] = tmpz;
				fData[fid][fhA] = tmpa;
				fData[fid][fInt] = intt;
				fData[fid][fVW] = vww;
				fData[fid][fOpen] = 1;

				fData[fid][fFX] = 0;
				fData[fid][fFY] = 0;
				fData[fid][fFZ] = 0;
				fData[fid][fFA] = 0;
				fData[fid][fFInt] = 0;
				fData[fid][fFVW] = 0;
				fData[fid][fFOpen] = 0;
				fData[fid][fFSellables] = 0;
				fData[fid][fFGunParts] = 0;
				fData[fid][fFMoney] = 0;

				InsertFaction(fid);

				fData[fid][fActive] = 1;

		        KillTimer(fData[fid][fFTimer]);
		        DestroyDynamic3DTextLabel(fData[fid][fLabel]);
		        DestroyDynamicPickup(fData[fid][fPickup]);
		        DestroyDynamic3DTextLabel(fData[fid][fFLabel]);

				fData[fid][fFTimer] = SetTimerEx("FactoryStart", 20000, false, "d", fid);

				new mstr[256], tmpstr[256];
				format(tmpstr, 256, "{667aca}%'s Factory\n", fData[fid][fName]); strcat(mstr, tmpstr);
				format(tmpstr, 256, "{667aca}Gun Parts: {FFFEFF}%i\n", fData[fid][fFGunParts]); strcat(mstr, tmpstr);
				format(tmpstr, 256, "{667aca}Money: {FFFEFF}$%i\n", fData[fid][fFMoney]); strcat(mstr, tmpstr);
				format(tmpstr, 256, "{667aca}Sellables Available: {FFFEFF}%i", fData[fid][fFSellables]); strcat(mstr, tmpstr);
				fData[fid][fFLabel] = CreateDynamic3DTextLabel(mstr, 0x667acaFF, fData[fid][fFX], fData[fid][fFY], fData[fid][fFZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, fData[fid][fFVW], fData[fid][fFInt]);

				format(mstr, 256, "");
				format(tmpstr, 256, "{667aca}%s's HQ\n", fData[fid][fName]); strcat(mstr, tmpstr);
				new open[10];
				if(fData[fid][fOpen] == 0) format(open, 10, "Open"); else format(open, 10, "Closed");
				format(tmpstr, 256, "{667aca}Status: {FFFEFF}%s", open); strcat(mstr, tmpstr);
				fData[fid][fLabel] = CreateDynamic3DTextLabel(mstr, 0x667acaFF, fData[fid][fhX], fData[fid][fhY], fData[fid][fhZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, fData[fid][fVW], fData[fid][fInt]);

		        fData[fid][fPickup] = CreateDynamicPickup(1239, 1, fData[fid][fhX], fData[fid][fhY], fData[fid][fhZ], fData[fid][fVW], fData[fid][fInt]);


				SaveFaction(fid);
		    }
		}

		case DIALOG_LEADER_FACTION:
		{
		    if(response)
		    {
		        if(listitem == 0) // name
				{
				    if(GetPlayerMoneyEx(playerid) < 50000) return SendClientError(playerid, "You do not have enough money.");
				    ShowPlayerDialog(playerid, DIALOG_FACTION_NAME, DIALOG_STYLE_MSGBOX, "Faction Name Change", "Do you really want to change faction name?\nChanging a faction's name costs {33AA33}$50,000", "Yes", "No");
		        }
				if(listitem == 1) // invite
				{
					new mstr[256], tmpstr[256], cnt = 0;
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
					    if(IsPlayerConnected(i))
					    {
					        if(pData[i][Faction] == -1)
					        {
					            if(cnt == 0)
					            {
					                format(tmpstr, 256, "%s", pData[i][Username]);
					                cnt++;
					            }
					            else format(tmpstr, 256, "\n%s", pData[i][Username]);
					            strcat(mstr, tmpstr);
					        }
					        else continue;
					    }
					}
					ShowPlayerDialog(playerid, DIALOG_FACTION_INVITE, DIALOG_STYLE_LIST, "Invite Player", mstr, "Yes", "No");
				}
				if(listitem == 2) // uninvite
				{
					new mstr[256], tmpstr[256], cnt = 0;
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
					    if(IsPlayerConnected(i))
					    {
					        if(pData[i][Faction] == pData[playerid][Faction])
					        {
					            if(cnt == 0)
					            {
					                format(tmpstr, 256, "%s", pData[i][Username]);
					                cnt++;
					            }
					            else format(tmpstr, 256, "\n%s", pData[i][Username]);
					            strcat(mstr, tmpstr);
					        }
					        else continue;
					    }
					}
					ShowPlayerDialog(playerid, DIALOG_FACTION_UNINVITE, DIALOG_STYLE_LIST, "Uninvite Player", mstr, "Yes", "No");
				}
				if(listitem == 3) // Offline uninv
				{
				    ShowPlayerDialog(playerid, DIALOG_OFFLINE_UNINVITE, DIALOG_STYLE_INPUT, "Offline Uninvite", "Please type the player name you want to o-uninvite?\nType name like this: (Player_Name):", "Yes", "No");
				}
		    }
		}

		case DIALOG_FACTION_NAME:
		{
		    if(response)
		    {
		        ShowPlayerDialog(playerid, DIALOG_F_NAME_C, DIALOG_STYLE_INPUT, "New Faction Name", "Please Type the faction name:", "Yes", "No");
		    }
		}

		case DIALOG_FACTION_INVITE:
		{
		    if(response)
		    {
		        if(GetTotalMembers(pData[playerid][Faction]) == fData[pData[playerid][Faction]][fMaxMemberSlots]) return SendClientError(playerid, "Maximum Slots used.");
		        new pid = GetPlayerID(inputtext);
		        if(!IsPlayerConnected(pid)) return SendClientError(playerid, "please report admin this error.");
		        InviteToFac(pid, pData[playerid][Faction], playerid);
		        GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

		case DIALOG_FACTION_UNINVITE:
		{
		    if(response)
		    {
		        new pid = GetPlayerID(inputtext);
		        if(!IsPlayerConnected(pid)) return SendClientError(playerid, "please report admin this error.");
				Uninvite(pid);
				GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

		case DIALOG_OFFLINE_UNINVITE:
		{
		    if(response)
		    {
		        new pid = GetPlayerID(inputtext);
		        if(IsPlayerConnected(pid)) return SendClientError(playerid, "Player is connected.");
		        new mQuery[256];
		        mysql_format(MySQL, mQuery, 256, "SELECT * FROM `playerdata` WHERE `Username` = '%e'", inputtext);
		        mysql_tquery(MySQL, mQuery, "OffUninvite", "is", playerid, inputtext);
		    }
		}

		case DIALOG_F_NAME_C:
		{
		    if(response)
		    {
		        format(fData[pData[playerid][Faction]][fName], 40, inputtext);
				GivePlayerMoneyEx(playerid, -50000);
				ReloadFaction(pData[playerid][Faction]);
				GameTextForPlayer(playerid, "~g~Done", 3000, 3);
		    }
		}

	}
	return 0;
}


GMX(playerid)
{
	new mstr[256];
	format(mstr, 256, "[SERVER] %s has initiated a GMX, server will restart in 20 seconds.", RPName(playerid));
	SendClientMessageToAll(COLOR_RED, mstr);
	GameTextForAll("~r~Restarting ~w~"SERVER_GM"", 7000, 0);
	SetTimer("GMXTimer", 20000, false);
	SaveServer();
}

SaveServer()
{
	SavePlayers();
	SaveBizs();
	SaveFactions();
	SaveGates();
	SaveHouses();
	SaveVehicles();
}

PUBLIC:GMXTimer()
{
    SendRconCommand("gmx");
}


/* *********************************************************************** */
// ============================= [ COMMANDS ] ============================ //
/* *********************************************************************** */
// Add /factory, /hq ---------------------> remaining

// add /noobspawn [move] 		&&		 /pdarmory [move]

CMD:noobspawn(playerid, params[])
{
	new var[24];
	if(pData[playerid][Admin] < 6) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "s[24]", var)) return SendClientUsage(playerid, "/noobspawn [ move ]");
	if(!strcmp(var, "move", true, 4))
	{
	    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
		GetPlayerPos(playerid, tmpx, tmpy, tmpz);
		GetPlayerFacingAngle(playerid, tmpa);
		intt = GetPlayerInterior(playerid);
		vww = GetPlayerVirtualWorld(playerid);
		noobspawn[cox] = tmpx;
		noobspawn[coy] = tmpy;
		noobspawn[coz] = tmpz;
		noobspawn[interior] = intt;
		noobspawn[vw] = vww;
		GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
	}
	return 1;
}

CMD:pdarmory(playerid, params[])
{
	new var[24];
	if(pData[playerid][Admin] < 6) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "s[24]", var)) return SendClientUsage(playerid, "/pdarmory [ move ]");
	if(!strcmp(var, "move", true, 4))
	{
	    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
		GetPlayerPos(playerid, tmpx, tmpy, tmpz);
		GetPlayerFacingAngle(playerid, tmpa);
		intt = GetPlayerInterior(playerid);
		vww = GetPlayerVirtualWorld(playerid);
		PDArmory[cox] = tmpx;
		PDArmory[coy] = tmpy;
		PDArmory[coz] = tmpz;
		PDArmory[interior] = intt;
		PDArmory[vw] = vww;
		GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
	}
	return 1;
}

CMD:goto(playerid, params[])
{
	new Float:one, Float:two, Float:three;
	if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "fff", one, two, three)) return SendClientUsage(playerid, "/goto [X] [Y] [Z]");
	SetPlayerPos(playerid, one, two, three);
	LetItLoadLOL(playerid);
	return 1;
}


CMD:givelicense(playerid, params[])
{
	new mstr[24], plr;
	if(GetPlayerFactionType(playerid) != FACTION_LEGAL) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "us[24]", plr, mstr)) return SendClientUsage(playerid, "/givelicense [ID/Name] [ mechanic ]");
	if(!IsPlayerConnected(plr)) return SendClientError(playerid, "Player not found.");
	if(strcmp(pData[plr][pJob], "None", true, 24)) return SendClientError(playerid, "Player already has a job.");
	format(pData[plr][pJob], 24, "Mechanic");
	new pstr[256];
	format(pstr, 256, "[MECHANIC] %s has given you mechanic job license, now you can fix cars!");
	SendClientMessage(plr, COLOR_GREEN, pstr);
	GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
	return 1;
}

CMD:storetoolkit(playerid, params[])
{
	new vid = IsPlayerNearAnyVehicle(playerid), mstr[256];
	if(vid == -1) return SendClientError(playerid, "There is no car to store toolkit in!");
	if(pData[playerid][pToolkit] == 0) return SendClientError(playerid, "You do not have any toolkit on you! Buy one from hardware shop.");
	if(vData[vid][vModel] == 525) return SendClientError(playerid, "You can not store toolkit inside Tow Truck.");
	if(!GetBootStatus(vData[vid][vID])) return SendClientError(playerid, "The boot of car is closed!");
	if(vData[vid][vToolkit] != 0) return SendClientError(playerid, "There is already a toolkit integrated in that car!");
	vData[vid][vToolkit] = 1;
	pData[playerid][pToolkit] = 0;
	GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
	format(mstr, 256, "successfully stores a toolkit in %s.", VehicleName[vData[vid][vModel] - 400]);
	Action(playerid, mstr);
	return 1;
}

CMD:taketoolkit(playerid, params[])
{
    new vid = IsPlayerNearAnyVehicle(playerid), mstr[256];
	if(vid == -1) return SendClientError(playerid, "There is no car to take toolkit from!");
	if(pData[playerid][pToolkit] == 1) return SendClientError(playerid, "You already have a toolkit on you!");
	if(vData[vid][vModel] == 525){
	    if(!strcmp(pData[playerid][pJob], "Mechanic", true, 24)) {
	        pData[playerid][pToolkit] = 1;
	        format(mstr, 256, "successfully takes a toolkit from %s.", VehicleName[vData[vid][vModel] - 400]);
			Action(playerid, mstr);
		} else {
		    SendClientError(playerid, "You need to be mechanic to do this.");
		}
	}
	else {
	    if(!GetBootStatus(vData[vid][vID])) return SendClientError(playerid, "The boot of car is closed!");
		if(vData[vid][vToolkit] != 1) return SendClientError(playerid, "There is no toolkit integrated in that car!");
		vData[vid][vToolkit] = 0;
		pData[playerid][pToolkit] = 1;
		GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
		format(mstr, 256, "successfully takes a toolkit from %s.", VehicleName[vData[vid][vModel] - 400]);
		Action(playerid, mstr);
	}
	return 1;
}


CMD:saveserver(playerid, params[])
{
	if(pData[playerid][Admin] < 6) return SendClientError(playerid, CANT_USE_CMD);
	SaveServer();
	SendClientSuccess(playerid, "Saved the server successfully.");
	return 1;
}

CMD:gmx(playerid, params[])
{
	if(pData[playerid][Admin] < 7) return SendClientError(playerid, CANT_USE_CMD);
	GMX(playerid);
	return 1;
}


CMD:gate(playerid, params[])
{
	new id = GetClosestGate(playerid);
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a gate.");
	if(GateData[id][GateEditing]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This gate is being edited, you can't use it.");
	if(GateData[id][GateOpenPos][0] == 0.0 && GateData[id][GateOpenRot][0] == 0.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This gate has no opening position.");
	if(!strlen(GateData[id][GatePassword])) {
	    ToggleGateState(id);
	}else{
	    if(HasGateAuth[playerid][id]) {
	        ToggleGateState(id);
		}else{
		    ShowPlayerDialog(playerid, DIALOG_GATE_PASSWORD, DIALOG_STYLE_PASSWORD, "Gate Password", "This gate is password protected.\nPlease enter this gate's password:", "Done", "Cancel");
		}
	}

	return 1;
}

CMD:creategate(playerid, params[])
{
	if(pData[playerid][Admin] < 5) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Only Level 5 + admins can use this command.");
	if(EditingGateID[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't create a gate while editing one.");
	new id = Iter_Free(Gates);
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Gate limit reached, you can't place any more gates.");
	new model, password[GATE_PASS_LEN];
	if(sscanf(params, "iS()["#GATE_PASS_LEN"]", model, password)) return SendClientMessage(playerid, 0xF39C12FF, "USAGE: {FFFFFF}/creategate [model id] [password (optional)]");
	GateData[id][GateModel] = model;
	GateData[id][GatePassword] = password;

	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);
	GetXYInFrontOfPlayer(playerid, x, y, 3.0);

	GateData[id][GatePos][0] = x;
	GateData[id][GatePos][1] = y;
	GateData[id][GatePos][2] = z;
	GateData[id][GateRot][0] = GateData[id][GateRot][1] = GateData[id][GateRot][2] = 0.0;
	GateData[id][GateOpenPos][0] = GateData[id][GateOpenPos][1] = GateData[id][GateOpenPos][2] = 0.0;
	GateData[id][GateOpenRot][0] = GateData[id][GateOpenRot][1] = GateData[id][GateOpenRot][2] = 0.0;
	GateData[id][GateState] = GATE_STATE_CLOSED;
	GateData[id][GateEditing] = true;
	GateData[id][GateObject] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, 0.0);
	new string[32];
	format(string, sizeof(string), "Gate #%d\n%s", id, GateStates[GATE_STATE_CLOSED]);
	GateData[id][GateLabel] = CreateDynamic3DTextLabel(string, 0xECF0F1FF, x, y, z, 10.0);
	Iter_Add(Gates, id);

	InsertGate(id);
	GateData[id][gActive] = 1;

	EditingGateID[playerid] = id;
	EditingGateType[playerid] = GATE_STATE_CLOSED;
	EditDynamicObject(playerid, GateData[id][GateObject]);
	SendClientMessage(playerid, 0x2ECC71FF, "INFO: {FFFFFF}Gate created, now you can edit it.");
	return 1;
}

PUBLIC:InsertGate(id)
{
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "INSERT INTO `gatesdata` (`ID`, `ModelID`, `Password`, `X`, `Y`, `Z`) VALUES\
	('%i', '%i', '%e', '%f', '%f', '%f')", id, GateData[id][GateModel], GateData[id][GatePassword],
	GateData[id][GatePos][0], GateData[id][GatePos][1], GateData[id][GatePos][2]);
	mysql_tquery(MySQL, mQuery);
}

CMD:editgate(playerid, params[])
{
    if(pData[playerid][Admin] < 4) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Only Level 3+ admins can use this command.");
	if(EditingGateID[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're already editing a gate.");
	new id;
	sscanf(params, "I(-2)", id);
	if(id == -2) id = GetClosestGate(playerid);
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a gate.");
	if(GateData[id][GateEditing]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Gate is being edited.");
	if(!IsPlayerInRangeOfPoint(playerid, 20.0, GateData[id][GatePos][0], GateData[id][GatePos][1], GateData[id][GatePos][2])) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near the gate you want to edit.");
	GateData[id][GateEditing] = true;
	EditingGateID[playerid] = id;
	ShowEditMenu(playerid, id);
	return 1;
}

COMMAND:shout(playerid, params[])
{
	new iText[ 228 ];
	if(sscanf(params, "s[228]", iText)) return SendClientUsage(playerid, "/shout [text]");
	new Float:px,Float:py,Float:pz; GetPlayerPos(playerid,px,py,pz);
	new iStr[256];
	format(iStr, sizeof(iStr), "%s shouts <: %s", RPName(playerid), iText);
   	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerInRangeOfPoint(i, 70.0, px,py,pz)) continue;
		if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid) || GetPlayerInterior(i) != GetPlayerInterior(playerid)) continue;
    	SendClientMessage(i,COLOR_WHITE,iStr);
	}
	return 1;
}

CMD:jail(playerid, params[])
{
	if(!IsPlayerLegal(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, time, iReason[92];
	if( sscanf ( params, "uds[92]", iPlayer,time,iReason))  return SendClientUsage(playerid, "/jail [PlayerID/PartOfName] [jailtime (MINUTES)] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PNF);
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 8.0) return SendClientError(playerid, "He is too far away!");

	if(IsPlayerAtArrestPoint(playerid))
	{
		Jail(iPlayer,time*60, "Arrested");
	}
	else return SendClientError(playerid, "You are not at a correct spot to arrest.");
	new iStr[256];
	format(iStr,sizeof(iStr),"* Police has arrested suspect %s for %d months - %s *",RPName(iPlayer), time, iReason);
    SendClientMessageToAll(COLOR_RED,iStr);

	fData[GetPlayerFaction(playerid)][fPoints] += 5;
	return 1;
}
COMMAND:unjail(playerid, params[])
{
    if(pData[playerid][Admin] < 3 && !IsPlayerLegal(playerid)) return SendClientError(playerid, CANT_USE_CMD);

	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SendClientUsage(playerid, "/unjail [PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PNF);
	if(iPlayer == playerid && !pData[playerid][Admin]) return SendClientError(playerid, "Not today baby :)");

	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 10 && !pData[playerid][Admin]) return SendClientError(playerid, "He is too far away!");
	if(pData[iPlayer][jail])
	{
		UnJail(iPlayer);
	}
	return 1;
}

Jail(playerid, time, reason[])
{
	pData[playerid][cuffed] = 0;
	pData[playerid][tazed] = 0;
	new id = random(sizeof(PrisonCells));
	SetPlayerPos(playerid, PrisonCells[id][0], PrisonCells[id][1], PrisonCells[id][2]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	format(pData[playerid][jailreason], 128, "%s", reason);
	pData[playerid][jailtime] = time;
	pData[playerid][jail] = 1;
	new iStr[256];
	format(iStr,sizeof(iStr),"[JAIL] You have been jailed for %d months! Reason: %s",time/60, pData[playerid][jailreason]);
	SendClientMessage(playerid, COLOR_RED, iStr);
	return 1;
}

UnJail(playerid)
{
	pData[playerid][jailtime] = 0;
	format(pData[playerid][jailreason], 128, "None");
 	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid,COLOR_GREEN,"[JAIL] Unjailed.");
	SpawnPlayer(playerid);
	pData[playerid][jail] = 0;
	return 1;
}

CMD:tazer(playerid, params[])
{
	if(pData[playerid][Faction] != 0 && IsPlayerLegal(playerid))
	{
		if(GetPVarInt(playerid, "Tazer") != 0) // has out
		{
			new iFormat[228];
			format(iFormat, sizeof(iFormat), "puts the tazer away.");
			Action(playerid, iFormat);
			DeletePVar(playerid, "Tazer");
			GivePlayerWeaponEx(playerid, 24, 64);
		}
		else // take out
		{
			new iFormat[228];
			format(iFormat, sizeof(iFormat), "takes the tazer out.");
			Action(playerid, iFormat);
			SetPVarInt(playerid, "Tazer", 1);
			GivePlayerWeaponEx(playerid, 23, 64);
		}
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}

CMD:uncuff(playerid, params[])
{
	if(!IsPlayerLegal(playerid) && GetAdminLevel(playerid) < 2) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iStr[256];
	if( sscanf ( params, "u", iPlayer)) return SendClientUsage(playerid, "/uncuff [PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PNF);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(iPlayer)==GetPlayerVehicleID(playerid) || GetDistanceBetweenPlayers(playerid, iPlayer) < 5)
	{
		format(iStr,sizeof(iStr),"has uncuffed %s",RPName(iPlayer));
		Action(playerid,iStr);
		TogglePlayerControllable(iPlayer,true);
		pData[iPlayer][cuffed] = 0;
		pData[iPlayer][tazed] = 0;
		SetPlayerSpecialAction(iPlayer,SPECIAL_ACTION_NONE);
	}
	else SendClientError(playerid, " You can't un-cuff that person.");
	return 1;
}

CMD:cuff(playerid, params[])
{
	if(!IsPlayerLegal(playerid) && GetAdminLevel(playerid) < 2) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iStr[256];
	if( sscanf ( params, "u", iPlayer)) return SendClientUsage(playerid, "/cuff [PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PNF);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(iPlayer) == GetPlayerVehicleID(playerid) && GetPlayerState(iPlayer) != PLAYER_STATE_DRIVER || pData[iPlayer][tazed] == 1 && GetDistanceBetweenPlayers(playerid, iPlayer) < 5 && GetPlayerState(iPlayer) != PLAYER_STATE_DRIVER)
	{
		format(iStr,sizeof(iStr),"has cuffed %s.",  RPName(iPlayer));
		Action(playerid,iStr);
		TogglePlayerControllable(iPlayer,false);
		pData[iPlayer][cuffed] = 1;
		pData[iPlayer][tazed] = 0;
		SetPlayerSpecialAction(iPlayer, SPECIAL_ACTION_CUFFED);
		GameTextForPlayer(iPlayer,"~r~You have been cuffed",3000,3);
	}
	else SendClientError(playerid, " You can't cuff that person.");
	return 1;
}

CMD:spy(playerid, params[])
{
	if(pData[playerid][Admin] < 5) return SendClientError(playerid, CANT_USE_CMD);
	if(pData[playerid][TogCMDS])
	{
		pData[playerid][TogCMDS] = 0;
		SendClientSuccess(playerid, "Toggled the spy off.");
	}
	else
	{
		pData[playerid][TogCMDS] = 1;
		SendClientSuccess(playerid, "Toggled the spy on.");
	}
	return 1;
}

CMD:whisper(playerid, params[])
{
	new pid, txt[256], mstr[256];
	if(sscanf(params, "us[256]", pid, txt)) return SendClientUsage(playerid, "/whisper [Player ID / Name] [Text]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(GetDistanceBetweenPlayers(playerid, pid) > 5) return SendClientError(playerid, "That player is not near you.");
	format(mstr, 256, "whispers something to %s", RPName(pid));
	Action(playerid, mstr);
	format(mstr, 256, "[WHISPER] %s ( %s )", RPName(playerid), txt);
	SendClientMessage(pid, COLOR_GOLD, mstr);
	SendClientMessage(playerid, COLOR_GOLD, mstr);
	return 1;
}

new FriskTimer[MAX_PLAYERS];
CMD:frisk(playerid, params[])
{
	new pid;
	if(sscanf(params, "u", pid)) return SendClientUsage(playerid, "/frisk [Player ID / Name]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(GetDistanceBetweenPlayers(playerid, pid) > 5) return SendClientError(playerid, "That player is not near you.");
	new mstr[256];
	format(mstr, 256, "tries to frisk %s", RPName(pid));
	Action(playerid, mstr);
	format(mstr, 256, "Success / Fail");
	DoAction(playerid, mstr);
	SetPVarInt(pid, "FriskAsked", playerid+1); // escape 0
	format(mstr, 256, "%s is trying to frisk you, /acceptfrisk to within 10 seconds to let them.", RPName(playerid));
	SendClientMessage(pid, COLOR_GOLD, mstr);
	FriskTimer[playerid] = SetTimerEx("FriskTime", 10000, false, "ii", playerid, pid);
	return 1;
}

CMD:acceptfrisk(playerid, params[])
{
	new pid = GetPVarInt(playerid, "FriskAsked");
	if(pid == 0) return SendClientError(playerid, "No one tried to firsk you.");
	pid -= 1; // escaped 0 now back
	KillTimer(FriskTimer[pid]);
	DoAction(playerid, "Success");
	new mstr[256];
	format(mstr, 256, "successfully frisks %s", RPName(playerid));
	Action(pid, mstr);
	format(mstr, 256, " ======== %s's Inventory ======== ", RPName(playerid));
	SendClientMessage(pid, COLOR_GOLD, mstr);
	format(mstr, 256, "Money: $%i\nSellables: %i", pData[playerid][Money], pData[playerid][Sellables]);
	SendClientMessage(pid, -1, mstr);
	return 1;
}

PUBLIC:FriskTime(playerid, pid)
{
	DeletePVar(pid, "FriskAsked");
	DoAction(pid, "Fail");
	new mstr[256];
	format(mstr, 256, "fails to frisk %s", RPName(pid));
	Action(playerid, mstr);
}

CMD:takegun(playerid, params[])
{
	new gun[20];
	if(GetPlayerFaction(playerid) == -1) return SendClientError(playerid, CANT_USE_CMD);
	if(!IsPlayerLegal(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	if(!IsPlayerAtPDArmory(playerid)) return SendClientError(playerid, "You are not at the armory.");
	if(sscanf(params, "s[20]", gun)) return SendClientUsage(playerid, "/takegun [Gun Name]");
	new wepid = GetWeaponIDByName(gun);
	if(wepid == 0) return SendClientUsage(playerid, "/takegun [Gun Name]");
	new guns = GetGunsRequiredFor(wepid);
	if(guns == -1) return SendClientError(playerid, "Invalid Weapon");
	if(PDStock[0][pdGuns] < guns) return SendClientError(playerid, "You are out of stock, please refill your Stock.");
	GivePlayerWeapon(playerid, wepid, 50);
	PDStock[0][pdGuns] -= guns;
	new mstr[256];
	format(mstr, 256, "%s has taken a %s from the stock. (Remaining Stock: %i)", RPName(playerid), GetWeaponNameByID(wepid), PDStock[0][pdGuns]);
	SendFactionMessage(pData[playerid][Faction], mstr);
	return 1;
}

CMD:pdstock(playerid, params[])
{
	new var[24], ok[24];
	if(pData[playerid][Admin] < 6) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "s[24]S()[24]", var, ok)) return SendClientUsage(playerid, "/pdstock [ move / setguns ] ");
	if(!strcmp(var, "move", true, 4))
	{
	    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
		GetPlayerPos(playerid, tmpx, tmpy, tmpz);
		GetPlayerFacingAngle(playerid, tmpa);
		intt = GetPlayerInterior(playerid);
		vww = GetPlayerVirtualWorld(playerid);
	    PDStock[0][pdX] = tmpx;
	    PDStock[0][pdY] = tmpy;
	    PDStock[0][pdZ] = tmpz;
	    PDStock[0][pdInt] = intt;
	    PDStock[0][pdVW] = vww;
	    ReloadPDStockLabel();
	    GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
	}
	else if(!strcmp(var, "setguns", true, 7))
	{
	    if(!IsNumeric(ok) || !strlen(ok) || strval(ok) < 1) return SendClientUsage(playerid, "/pdstock setguns [Amount]");
	    PDStock[0][pdGuns] = strval(ok);
	    ReloadPDStockLabel();
	    GameTextForPlayer(playerid, "~g~DONE", 3000, 3);
	}
	else return SendClientUsage(playerid, "/pdstock [ move / setguns ]");
	return 1;
}

CMD:takesellables(playerid, params[])
{
	new tak, mstr[256];
	if(GetPlayerFaction(playerid) == -1) return SendClientError(playerid, CANT_USE_CMD);
	new factid = IsPlayerOutFactory(playerid);
	if(factid != GetPlayerFaction(playerid)) return SendClientError(playerid, "You are not outside your faction's factory.");
	if(fData[factid][fFOpen] == 0) return SendClientError(playerid, "Factory is closed, firstly open it.");
	if(sscanf(params, "i", tak)) return SendClientUsage(playerid, "/takesellables [AMOUNT]");
	if(tak < 1) return SendClientUsage(playerid, "/takesellables [AMOUNT]");
	if(tak > fData[factid][fFSellables]) return SendClientError(playerid, "Your faction's factory does not have that much sellables.");
	fData[factid][fFSellables] -= tak;
	pData[playerid][Sellables] += tak;
	format(mstr, 256, "%s has taken %i sellables from the faction's factory.", RPName(playerid), tak);
	SendFactionMessage(factid, mstr);
	return 1;
}

CMD:loadresidue(playerid, params[])
{
	if(!IsPlayerAtObj(playerid, OBJ_RESIDUE)) return  SendClientError(playerid, "You are not at the Residue Collection Place.");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle.");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not the driver.");
	new vid, vd;
	vd = GetPlayerVehicleID(playerid);
	vid = FindVehicleID(vd);
	if(vData[vid][vModel] != 482) return SendClientError(playerid, "You are not in the burrito.");
	if(GetPlayerMoneyEx(playerid) < RESIDUE_FEES) return SendClientError(playerid, "You do not have enough money to buy residue.");
	if(GetVehiclePeople(vd) < 3) return SendClientError(playerid, "There needs to be three people in the buritto.");
	if(vData[vid][vResidue] != 0) return SendClientError(playerid, "You already have filled the buritto with residue.");
	vData[vid][vResidue] += 100;
	SendClientSuccess(playerid, "Successfully loaded residue into the buritto.");
	GivePlayerMoneyEx(playerid, -RESIDUE_FEES);
	return 1;
}

CMD:loadguns(playerid, params[])
{
	if(!IsPlayerAtObj(playerid, OBJ_BROKENGUNS)) return  SendClientError(playerid, "You are not at the Broken Guns Collection Place.");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle.");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not the driver.");
	new vid, vd;
	vd = GetPlayerVehicleID(playerid);
	vid = FindVehicleID(vd);
	if(vData[vid][vModel] != 482) return SendClientError(playerid, "You are not in the burrito.");
	if(GetPlayerMoneyEx(playerid) < B_GUNS_FEES) return SendClientError(playerid, "You do not have enough money to buy residue.");
	if(GetVehiclePeople(vd) < 3) return SendClientError(playerid, "There needs to be three people in the buritto.");
	if(vData[vid][vGuns] != 0) return SendClientError(playerid, "You already have filled the buritto with Broken Guns.");
	vData[vid][vGuns] += 100;
	SendClientSuccess(playerid, "Successfully loaded Broken Guns into the buritto.");
	GivePlayerMoneyEx(playerid, -B_GUNS_FEES);
	return 1;
}

CMD:storeinfactory(playerid, params[])
{
	if(GetPlayerFaction(playerid) == -1) return SendClientError(playerid, CANT_USE_CMD);
	new factid = IsPlayerOutFactory(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle.");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not the driver.");
	new vid, vd;
	vd = GetPlayerVehicleID(playerid);
	vid = FindVehicleID(vd);
	if(vData[vid][vModel] != 482) return SendClientError(playerid, "You are not in the burrito.");
	if(GetVehiclePeople(vd) < 3) return SendClientError(playerid, "There needs to be three people in the buritto.");
	if(vData[vid][vGuns] == 0 || vData[vid][vResidue] == 0) return SendClientError(playerid, "You dont have Broken Guns or Residue in the buritto.");
	if(factid != GetPlayerFaction(playerid)) return SendClientError(playerid, "You are not outside your faction's factory.");
	if(fData[factid][fFOpen] == 0) return SendClientError(playerid, "Factory is closed, firstly open it.");
	new stored = (vData[vid][vGuns] + vData[vid][vResidue])/2;
	fData[factid][fFGunParts] += stored;
	vData[vid][vGuns] = 0;
	vData[vid][vResidue] = 0;
	new mstr[256];
	format(mstr, 256, "%s has stored %i Gun Parts into the factory.", RPName(playerid), stored);
	SendFactionMessage(factid, mstr);
	ReloadFaction(factid);
	return 1;
}

CMD:makeleader(playerid, params[])
{
	new pid, fid;
	if(pData[playerid][Admin] < 4) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "ui", pid, fid)) return SendClientUsage(playerid, "/makeleader [Player ID / Name] [Faction ID]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(fData[fid][fActive] != 1) return SendClientError(playerid, "WRONG ID");
	pData[pid][Faction] = fid;
	pData[pid][fTier] = 0;
	SendClientSuccess(playerid, "DONE");
	return 1;
}

CMD:f(playerid, params[])
{
	new txt[256], mstr[256];
	if(GetPlayerFaction(playerid) == -1) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "s[256]", txt)) return SendClientUsage(playerid, "/f [CHAT]");
	format(mstr, 256, "%s %s: %s", pData[playerid][fRank], RPName(playerid), txt);
	SendFactionMessage(pData[playerid][Faction], mstr);
	return 1;
}

CMD:admins(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GOLD, " ===================== [ "SERVER_GM" Admins ] =====================");
	new cnt = 0, mstr[256];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(pData[i][Admin] == 0) continue;
			format(mstr, 256, "[ID: %i] %s (%s)", i, RPName(i), AdminLvls[pData[i][Admin]][adlvlname]);
	        SendClientMessage(playerid, -1, mstr);
	        cnt++;
	    }
	}
	if(cnt == 0) SendClientMessage(playerid, -1, "No any admin online at the moment.");
	SendClientMessage(playerid, COLOR_GOLD, " =====================================================================");
	return 1;
}

CMD:factions(playerid, params[])
{
	new mstr[256];
	SendClientMessage(playerid, COLOR_GOLD, " ===================== [ "SERVER_GM" Factions ] =====================");
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
	    if(fData[i][fActive] != 1) continue;
	    format(mstr, 256, "[ID: %i] %s (Online: %i)", i, fData[i][fName], GetOnlineMembers(i));
	    SendClientMessage(playerid, -1, mstr);
	}
	SendClientMessage(playerid, COLOR_GOLD, " =====================================================================");
	return 1;
}

CMD:asetrank(playerid, params[])
{
	new pid, rnk[10];
	if(pData[playerid][Admin] < 4) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "us[10]", pid, rnk)) return SendClientUsage(playerid, "/asetrank [Player ID / Name] [Rank]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[pid][Faction] == -1) return SendClientError(playerid, "Player is not in any faction.");
	format(pData[pid][fRank], 10, rnk);
	GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	return 1;
}

CMD:asettier(playerid, params[])
{
	new pid, rnk;
	if(pData[playerid][Admin] < 4) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "ui", pid, rnk)) return SendClientUsage(playerid, "/asettier [Player ID / Name] [Tier]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[pid][Faction] == -1) return SendClientError(playerid, "Player is not in any faction.");
	if(rnk < 0 || rnk > 3) return SendClientError(playerid, "Tier must be 0-3");
	pData[pid][fTier] = rnk;
	GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	return 1;
}

CMD:setrank(playerid, params[])
{
	new pid, rnk[10];
	if(pData[playerid][Faction] == -1 || pData[playerid][fTier] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "us[10]", pid, rnk)) return SendClientUsage(playerid, "/setrank [Player ID / Name] [Rank]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[pid][Faction] != pData[playerid][Faction]) return SendClientError(playerid, "Player is not in your faction.");
	format(pData[pid][fRank], 10, rnk);
	GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	new mstr[256];
	format(mstr, 256, "%s has set the rank of %s to %s.", RPName(playerid), RPName(pid), rnk);
	SendFactionMessage(pData[playerid][Faction], mstr);
	return 1;
}

CMD:settier(playerid, params[])
{
	new pid, rnk, mstr[256];
	if(pData[playerid][Faction] == -1 || pData[playerid][fTier] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "ui", pid, rnk)) return SendClientUsage(playerid, "/settier [Player ID / Name] [Tier]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[pid][Faction] != pData[playerid][Faction]) return SendClientError(playerid, "Player is not in your faction.");
	if(rnk < 0 || rnk > 3) return SendClientError(playerid, "Tier must be 0-3");
	if(rnk == 0)
	{
	    if(GetTotalMembers(pData[playerid][Faction], 1, 0) >= 2) return SendClientError(playerid, "Only 2 tier 0 are allowed.");
	    else pData[pid][fTier] = rnk;
	}
	if(rnk == 1)
	{
	    if(GetTotalMembers(pData[playerid][Faction], 1, 1) >= 4) return SendClientError(playerid, "Only 2 tier 0 are allowed.");
	    else pData[pid][fTier] = rnk;
	}
	if(rnk == 2)
	{
	    if(GetTotalMembers(pData[playerid][Faction], 1, 2) >= 10) return SendClientError(playerid, "Only 2 tier 0 are allowed.");
	    else pData[pid][fTier] = rnk;
	}
	if(rnk == 3)
	{
	    if(GetTotalMembers(pData[playerid][Faction], 1, 0) >= 100) return SendClientError(playerid, "Only 2 tier 0 are allowed.");
	    else pData[pid][fTier] = rnk;
	}
	format(mstr, 256, "%s has set the tier of %s to %i.", RPName(playerid), RPName(pid), rnk);
	SendFactionMessage(pData[playerid][Faction], mstr);
	GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	return 1;
}

CMD:joinfaction(playerid, params[])
{
	if(pData[playerid][Faction] != -1) return SendClientError(playerid, "You are already in a faction.");
	if(GetPVarInt(playerid, "InvitedTo") == 0) return SendClientError(playerid, "You are not invited to any faction");
	new mstr[256];
	pData[playerid][Faction] = GetPVarInt(playerid, "InvitedTo") - 1; // zero shit
	pData[playerid][fTier] = 3;
	format(pData[playerid][fRank], 10, "None");
	format(mstr, 256, "%s has been invited to the faction by %s.", NoUnderscore(pData[playerid][Username]), NoUnderscore(pData[GetPVarInt(playerid, "InvitedBy")][Username]));
	SendFactionMessage(pData[playerid][Faction], mstr);
	DeletePVar(playerid, "InvitedTo");
	DeletePVar(playerid, "InvitedBy");
	return 1;
}

CMD:faction(playerid, params[])
{
	if(pData[playerid][Faction] == -1) return SendClientError(playerid, CANT_USE_CMD);
	new fid = GetPlayerFaction(playerid);
	if(pData[playerid][fTier] == 0)
	{
	    new onestr[256], mstr[256], lock[10];
	    if(fData[fid][fOpen] == 0) format(lock, 10, "Closed"); else format(lock, 10, "Opened");
	    format(onestr, 256, "%s Faction", fData[fid][fName]);
	    format(mstr, 256, "Name:\t\t\t%s\nInvite\nUninvite\nOffline Uninvite", fData[fid][fName]);
		ShowPlayerDialog(playerid, DIALOG_LEADER_FACTION, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	else SendClientError(playerid, CANT_USE_CMD);
	return 1;
}

CMD:factioninfo(playerid, params[])
{
	new fid = GetPlayerFaction(playerid);
	if(fid == -1) return SendClientError(playerid, CANT_USE_CMD);
	else
	{
	    new onestr[256], mstr[256];
	    format(onestr, 256, "%s Faction Info", fData[fid][fName]);
	    format(mstr, 256, "Name: %s\nTotal Members: %i / %i\nOnline Members: %i\nVehicles: %i/%i", fData[fid][fName], GetTotalMembers(fid), fData[fid][fMaxMemberSlots], GetOnlineMembers(fid), GetFactionVehicles(fid), fData[fid][fMaxVehicles]);
		ShowPlayerDialog(playerid, DIALOG_PLAYER_FACTION, DIALOG_STYLE_MSGBOX, onestr, mstr, "OK", "");
	}
	return 1;
}

CMD:afaction(playerid, params[])
{
	new wat[20], wat2[20];
	if(pData[playerid][Admin] < 5) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "s[20]S()[20]", wat, wat2)) return SendClientUsage(playerid, "/afaction [ create / delete / spawn ]");
    if(!strcmp(wat, "create", true, 6))
    {
        new mstr[256], onestr[256], cnt = 0;
        for(new i = 0; i < sizeof(FacTypeList); i++)
        {
            if(cnt == 0)
            {
                format(onestr, 256, "%s", FacTypeList[i][fac_N]);
                cnt++;
            }
            else
            {
                format(onestr, 256, "\n%s", FacTypeList[i][fac_N]);
            }
            strcat(mstr, onestr);
        }
        ShowPlayerDialog(playerid, DIALOG_FACTION_CRT, DIALOG_STYLE_LIST, "Create Faction", mstr, "OK", "Exit");
    }
    else if(!strcmp(wat, "delete", true, 6))
    {
     	if(!strlen(wat2) || !IsNumeric(wat2) || strval(wat2) < 0) return SendClientUsage(playerid, "/afaction delete [ID]");
		if(fData[strval(wat2)][fActive] != 0)
		{
		    DeleteFaction(strval(wat2));
		    SendClientSuccess(playerid, "Deleted.");
		}
		else SendClientError(playerid, "Wrong ID.");
    }
    else if(!strcmp(wat, "spawn", true, 5))
    {
        if(!strlen(wat2) || !IsNumeric(wat2) || strval(wat2) < 0) return SendClientUsage(playerid, "/afaction spawn [ID]");
		if(fData[strval(wat2)][fActive] != 0)
		{
			new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
			GetPlayerPos(playerid, tmpx, tmpy, tmpz);
			GetPlayerFacingAngle(playerid, tmpa);
			intt = GetPlayerInterior(playerid);
			vww = GetPlayerVirtualWorld(playerid);
			fData[strval(wat2)][fInX] = tmpx;
			fData[strval(wat2)][fInY] = tmpy;
			fData[strval(wat2)][fInZ] = tmpz;
			fData[strval(wat2)][fInA] = tmpa;
			fData[strval(wat2)][fInInt] = intt;
			fData[strval(wat2)][fInVW] = vww;
			SendClientSuccess(playerid, "Success");
		}
		else SendClientError(playerid, "Wrong ID.");
    }
    else SendClientUsage(playerid, "/afaction [ create / delete / spawn ]");
	return 1;
}

CMD:ahq(playerid, params[])
{
	new wat[20], wat2;
	if(pData[playerid][Admin] < 5) return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "s[20]i", wat, wat2)) return SendClientUsage(playerid, "/ahq [ move / open / close / reload ] [Faction ID]");
    if(!strcmp(wat, "move", true, 4))
    {
		if(fData[wat2][fActive] == 1)
		{
		    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
			GetPlayerPos(playerid, tmpx, tmpy, tmpz);
			GetPlayerFacingAngle(playerid, tmpa);
			intt = GetPlayerInterior(playerid);
			vww = GetPlayerVirtualWorld(playerid);
			fData[wat2][fhX] = tmpx;
			fData[wat2][fhY] = tmpy;
			fData[wat2][fhZ] = tmpz;
			fData[wat2][fhA] = tmpa;
			fData[wat2][fInt] = intt;
			fData[wat2][fVW] = vww;
			ReloadFaction(wat2);
			SendClientSuccess(playerid, "Success");
		}
		else SendClientError(playerid, "Wrong ID");
    }
    else if(!strcmp(wat, "open", true, 4))
    {
        if(fData[wat2][fActive] == 1)
        {
            if(fData[wat2][fOpen] == 1) SendClientError(playerid, "Already open.");
            else
			{
				fData[wat2][fOpen] = 1;
				GameTextForPlayer(playerid, "~g~Opened", 3000, 3);
			}
        }
        else SendClientError(playerid, "Wrong ID");
    }
    else if(!strcmp(wat, "close", true, 5))
    {
        if(fData[wat2][fActive] == 1)
        {
            if(fData[wat2][fOpen] == 0) SendClientError(playerid, "Already closed.");
            else
			{
				fData[wat2][fOpen] = 0;
				GameTextForPlayer(playerid, "~r~Closed", 3000, 3);
			}
        }
        else SendClientError(playerid, "Wrong ID");
    }
    else if(!strcmp(wat, "reload", true, 6))
    {
        if(fData[wat2][fActive] == 1)
        {
            ReloadFaction(wat2);
            GameTextForPlayer(playerid, "~g~Done", 3000, 3);
        }
        else SendClientError(playerid, "Wrong ID");
    }
	else SendClientUsage(playerid, "/ahq [ move / open / close / reload ] [Faction ID]");
	return 1;
}

CMD:afactory(playerid, params[])
{
	new wat[20], fid, tmp[10];
	if(sscanf(params, "s[20]iS()[10]", wat, fid, tmp)) return SendClientUsage(playerid, "/afactory [move / open / close / money / gunparts / sellables / reload] [Faction ID]");
	if(!strcmp(wat, "move", true, 4))
	{
	    if(fData[fid][fActive] == 1)
		{
		    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
			GetPlayerPos(playerid, tmpx, tmpy, tmpz);
			GetPlayerFacingAngle(playerid, tmpa);
			intt = GetPlayerInterior(playerid);
			vww = GetPlayerVirtualWorld(playerid);
			fData[fid][fFX] = tmpx;
			fData[fid][fFY] = tmpy;
			fData[fid][fFZ] = tmpz;
			fData[fid][fFA] = tmpa;
			fData[fid][fFInt] = intt;
			fData[fid][fFVW] = vww;
			ReloadFaction(fid);
			SendClientSuccess(playerid, "Success");
		}
		else SendClientError(playerid, "Wrong ID");
	}
	else if(!strcmp(wat, "open", true, 4))
	{
	    if(fData[fid][fActive] == 1)
        {
            if(fData[fid][fFOpen] == 1) SendClientError(playerid, "Already open.");
            else
			{
				fData[fid][fFOpen] = 1;
				GameTextForPlayer(playerid, "~g~Opened", 3000, 3);
			}
        }
        else SendClientError(playerid, "Wrong ID");
	}
	else if(!strcmp(wat, "close", true, 5))
	{
	    if(fData[fid][fActive] == 1)
        {
            if(fData[fid][fFOpen] == 0) SendClientError(playerid, "Already closed.");
            else
			{
				fData[fid][fFOpen] = 0;
				GameTextForPlayer(playerid, "~r~Closed", 3000, 3);
			}
        }
        else SendClientError(playerid, "Wrong ID");
	}
	else if(!strcmp(wat, "money", true, 5))
	{
	    if(!strlen(tmp) || !IsNumeric(tmp) || strval(tmp) < 0) return SendClientUsage(playerid, "/afactory [Money] [ID] [AMOUNT]");
	    if(fData[fid][fActive] == 1)
	    {
	        fData[fid][fFMoney] = strval(tmp);
			GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	    }
	    else SendClientError(playerid, "Wrong ID");
	}
	else if(!strcmp(wat, "gunparts", true, 8))
	{
	    if(!strlen(tmp) || !IsNumeric(tmp) || strval(tmp) < 0) return SendClientUsage(playerid, "/afactory [Gun Parts] [ID] [AMOUNT]");
	    if(fData[fid][fActive] == 1)
	    {
	        fData[fid][fFGunParts] = strval(tmp);
			GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	    }
	    else SendClientError(playerid, "Wrong ID");
	}
	else if(!strcmp(wat, "sellables", true, 9))
	{
	    if(!strlen(tmp) || !IsNumeric(tmp) || strval(tmp) < 0) return SendClientUsage(playerid, "/afactory [Sellables] [ID] [AMOUNT]");
	    if(fData[fid][fActive] == 1)
	    {
	        fData[fid][fFSellables] = strval(tmp);
			GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	    }
	    else SendClientError(playerid, "Wrong ID");
	}
	else if(!strcmp(wat, "reload", true, 6))
	{
	    if(fData[fid][fActive] == 1)
	    {
	        ReloadFaction(fid);
	        GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	    }
	    else SendClientError(playerid, "Wrong ID");
	}
	else SendClientUsage(playerid, "/afactory [move / open / close / money / gunparts / sellables / reload] [Faction ID]");
	return 1;
}

CMD:buy(playerid, params[])
{
    new bd = IsPlayerInBiz(playerid);
	if(bd != -1) // if player is inside biz
	{
	    new onestr[256], mstr[256], tmpstr[256];
	    if(bData[bd][bType] == BTYPE_247)
	    {
	        new cnt = 0;
	        format(onestr, 256, "%s's Available Items", bData[bd][bName]);
	        format(mstr, 256, "");
	        for(new i = 0; i < sizeof(b247Items); i++)
	        {
	            if(cnt == 0)
				{
					format(tmpstr, 256, "%s\t\t\t$%i", b247Items[i][b247name], b247Items[i][b247price]);
					cnt++;
	            }
				else format(tmpstr, 256, "\n%s\t\t\t$%i", b247Items[i][b247name], b247Items[i][b247price]);
				strcat(mstr, tmpstr);
	        }
	        ShowPlayerDialog(playerid, DIALOG_BUY_247, DIALOG_STYLE_LIST, onestr, mstr, "Buy", "Exit");
	    }
	    else if(bData[bd][bType] == BTYPE_HARDWARE)
	    {
	        new cnt = 0;
	        format(onestr, 256, "%s's Available Items", bData[bd][bName]);
	        format(mstr, 256, "");
	        for(new i = 0; i < sizeof(hardwareItems); i++)
	        {
	            if(cnt == 0)
				{
					format(tmpstr, 256, "%s\t\t$%i", hardwareItems[i][hardwareName], hardwareItems[i][hardwarePrice]);
					cnt++;
	            }
				else format(tmpstr, 256, "\n%s\t\t$%i", hardwareItems[i][hardwareName], hardwareItems[i][hardwarePrice]);
				strcat(mstr, tmpstr);
	        }
	        ShowPlayerDialog(playerid, DIALOG_BUY_HARDWARE, DIALOG_STYLE_LIST, onestr, mstr, "Buy", "Exit");
	    }
	    else if(bData[bd][bType] == BTYPE_AMMU)
	    {
			new cnt = 0;
	        format(onestr, 256, "%s's Available Guns", bData[bd][bName]);
	        format(mstr, 256, "");
	        for(new i = 0; i < sizeof(AmmuItems); i++)
	        {
	            if(cnt == 0)
				{
					format(tmpstr, 256, "%s\t\t\t$%i", AmmuItems[i][ammuname], AmmuItems[i][ammuprice]);
					cnt++;
	            }
				else format(tmpstr, 256, "\n%s\t\t\t$%i", AmmuItems[i][ammuname], AmmuItems[i][ammuprice]);
				strcat(mstr, tmpstr);
	        }
	        ShowPlayerDialog(playerid, DIALOG_BUY_AMMU, DIALOG_STYLE_LIST, onestr, mstr, "Buy", "Exit");
	    }
	    else if(bData[bd][bType] == BTYPE_CLOTHES)
	    {
	        ShowModelSelectionMenu(playerid, skinlist, "Select Skin");
	    }
	    else SendClientError(playerid, "You can not use this command in here.");
	}
	if(bd == -1) // if outside
	{
	    if(pData[playerid][hasGPS] != 0)
	    {
	        ShowClosestBizs(playerid);
	    }
	    else SendClientError(playerid, "You are not inside any business, buy an advanced GPS from 24/7 to learn around the town.");
	}
	return 1;
}

CMD:debug(playerid, params[])
{
	new mstr[256], Float:tmpx, Float:tmpy, Float:tmpz;
	GetPlayerPos(playerid, tmpx, tmpy, tmpz);
	format(mstr, 256, "[DBG] int: %i, vw: %i, %f, %f, %f", GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), tmpx, tmpy, tmpz);
	SendClientMessage(playerid, -1, mstr);
	return 1;
}

CMD:debugbiz(playerid, params[])
{
	new bd = IsPlayerInBiz(playerid);
	if(bd == -1) return SendClientError(playerid, "You are not inside  any biz");
	new mstr[256];
	format(mstr, 256, "bd = '%i', interiorpack = '%i', bType = '%i'", bd, bData[bd][bInteriorPack], bData[bd][bType]);
	SendClientMessage(playerid, -1, mstr);
	return 1;
}

CMD:biz(playerid, params[])
{
    new bid = IsPlayerOutBiz(playerid);
	new bd = IsPlayerInBiz(playerid);
	if(bid == -1 && bd == -1) // away
	{
	    if(GetPlayerBizs(playerid) == 0) return SendClientError(playerid, "You do not own any business.");
	    new onestr[256], mstr[256], tmpstr[256], zone[20], cnt = 0;
	    format(onestr, 256, "%s's Businesses", RPName(playerid));
	    for(new i = 0; i < MAX_BUSINESS; i++)
	    {
	        if(bData[i][bActive] != 1) continue;
	        if(!strcmp(bData[i][bOwner], GetName(playerid), false))
	        {
	            if(cnt == 0)
	            {
	                cnt++;
	                GetZone(bData[i][bX], bData[i][bY], bData[i][bZ], zone);
	                format(tmpstr, 256, "[ID: %i] %s - %s", i, bData[i][bName], zone);
	            }
	            else
	            {
	                GetZone(bData[i][bX], bData[i][bY], bData[i][bZ], zone);
	                format(tmpstr, 256, "\n[ID: %i] %s - %s", i, bData[i][bName], zone);
	            }
	            strcat(mstr, tmpstr);
	        }
	    }
	    ShowPlayerDialog(playerid, DIALOG_PLAYER_BIZ, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	if(bid != -1 && bd == -1) // if outside
	{
	    if(strcmp(bData[bid][bOwner], GetName(playerid), false)) return SendClientError(playerid, "You are not the owner of this business.");
	    new mstr[256], lock[4], onestr[256];
	    format(onestr, 256, "%s's %s", NoUnderscore(bData[bid][bOwner]), bData[bid][bName]);
	    if(bData[bid][bLocked] == 0) format(lock, 4, "No"); else format(lock, 4, "Yes");
		format(mstr, 256, "Name:\t\t\t%s\nLocked:\t\t%s\nFee:\t\t\t$%i\nSell\nDetails", bData[bid][bName], lock, bData[bid][bFee]);
		ShowPlayerDialog(playerid, DIALOG_PLAYER_BIZ_OUT, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	if(bid == -1 && bd != -1) // inside
	{
	    if(strcmp(bData[bd][bOwner], GetName(playerid), false)) return SendClientError(playerid, "You are not the owner of this business.");
	    SendClientError(playerid, "You can not use this cmd inside.");
	}
	return 1;
}

CMD:createbank(playerid, params[])
{
    if(pData[playerid][Admin] < 5)  return SendClientError(playerid, CANT_USE_CMD);
    new bid = GetUnusedBankID();
    if(bid == -1) return SendClientError(playerid, "Max banks created.");
	format(bankData[bid][bankName], 256, "No Name");
	new Float:tmpx, Float:tmpy, Float:tmpz, intt, vww;
	GetPlayerPos(playerid, tmpx, tmpy, tmpz);
	intt = GetPlayerInterior(playerid);
	vww = GetPlayerVirtualWorld(playerid);
	bankData[bid][bankX] = tmpx;
	bankData[bid][bankY] = tmpy;
	bankData[bid][bankZ] = tmpz;
	bankData[bid][bankInt] = intt;
	bankData[bid][bankVW] = vww;
	bankData[bid][bankTotalMoney] = 0;
	bankData[bid][bankInterior] = 0;
	bankData[bid][bankActive] = 1;
	InsertBank(bid); // interior type fee name
 	new string[512], zone[48];
    GetZone(bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], zone);
	format(string,sizeof(string),"[ Bank ]\nName: %s\nAddress: %s, %d", bankData[bid][bankName], zone,bid);
	bankData[bid][bankLabel] = CreateDynamic3DTextLabel(string, -1,  bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
    bankData[bid][bankMapIcon] = CreateDynamicMapIcon(bankData[bid][bankX], bankData[bid][bankY], bankData[bid][bankZ], 56, 0xAAFFAAFF);
    return 1;
}

CMD:deposit(playerid, params[])
{
	new mstr[256];
	new in = IsPlayerInBank(playerid);
	if(in == -1) return SendClientError(playerid, "You need to be inside a bank to use this command!");
	if(bankData[in][bankActive] != 1) return SendClientError(playerid, "Report this to Scripter.");
	format(mstr, 256, "Your Balance: $%i\n\nPlease enter the amount you want to deposit:", pData[playerid][bankMoney]);
	ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit Money", mstr, "Deposit", "Exit");
	return 1;
}

CMD:withdraw(playerid, params[])
{
	new mstr[256];
	new in = IsPlayerInBank(playerid);
	if(in == -1) return SendClientError(playerid, "You need to be inside a bank to use this command!");
	if(bankData[in][bankActive] != 1) return SendClientError(playerid, "Report this to Scripter.");
    format(mstr, 256, "Your Balance: $%i\n\nPlease enter the amount you want to withdraw:", pData[playerid][bankMoney]);
	ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "Withdraw Money", mstr, "Withdraw", "Exit");
	return 1;
}

CMD:bank(playerid, params[])
{
	new var[24], nam[24], bid;
	if(pData[playerid][Admin] < 5)  return SendClientError(playerid, CANT_USE_CMD);
	if(sscanf(params, "is[24]S()[24]", bid, var, nam)) return SendClientUsage(playerid, "/bank [ID] [name / move / delete]");
	if(bankData[bid][bankActive] != 1) return SendClientError(playerid, "Wrong Bank ID.");
	if(!strcmp(var, "name", true, 24))
	{
	    if(!strlen(nam)) return SendClientUsage(playerid, "/bank [ID] name [New Name]");
	    format(bankData[bid][bankName], 24, nam);
	    ReloadBank(bid);
     	GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	}
	else if(!strcmp(var, "move", true, 24))
	{
	    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
		GetPlayerPos(playerid, tmpx, tmpy, tmpz);
		GetPlayerFacingAngle(playerid, tmpa);
		intt = GetPlayerInterior(playerid);
		vww = GetPlayerVirtualWorld(playerid);
		bankData[bid][bankX] = tmpx;
		bankData[bid][bankY] = tmpy;
		bankData[bid][bankZ] = tmpz;
		bankData[bid][bankInt] = intt;
		bankData[bid][bankVW] = vww;
		ReloadBank(bid);
		GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	}
	else if(!strcmp(var, "delete", true, 24))
	{
	    DeleteBank(bid);
	    GameTextForPlayer(playerid, "~g~Done", 3000, 3);
	}
	return 1;
}

CMD:abiz(playerid, params[])
{
	new wat[10];
	if(pData[playerid][Admin] < 5) return SendClientError(playerid, CANT_USE_CMD);
	new bid = IsPlayerOutBiz(playerid);
	new bd = IsPlayerInBiz(playerid);
	if(bid != -1 && bd == -1) // if outside
	{
	    new mstr[256], onestr[256], locked[10];
	    format(onestr, 256, "%s's Business (ID: %i)", NoUnderscore(bData[bid][bOwner]), bid);
	    if(bData[bid][bLocked] == 0) format(locked, 10, "No"); else format(locked, 10, "Yes");
	    format(mstr, 256, "Name:\t\t\t%s\nOwner:\t\t\t%s\nMoney:\t\t\t$%i\nLocked:\t\t%s\nSell:\t\t\t%i\nFee:\t\t\t$%i\nSave\nReload\nDelete",
		bData[bid][bName], bData[bid][bOwner], bData[bid][bMoney], locked, bData[bid][bSell], bData[bid][bFee]);
		ShowPlayerDialog(playerid, DIALOG_ADMIN_BIZ, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	else if(bid == -1 && bd == -1)
	{
	    if(sscanf(params, "s[10]", wat)) return SendClientUsage(playerid, "/abiz [create]");
	    if(!strcmp(wat, "create", true, 6))
	    {
	        new mstr[256], onestr[256], cnt = 0;
	        for(new i = 0; i < sizeof(BizTypeList); i++)
	        {
	            if(cnt == 0)
	            {
	                format(onestr, 256, "%s", BizTypeList[i][biz_N]);
	                cnt++;
	            }
	            else
	            {
	                format(onestr, 256, "\n%s", BizTypeList[i][biz_N]);
	            }
	            strcat(mstr, onestr);
	        }
	        ShowPlayerDialog(playerid, DIALOG_BIZ_CRT, DIALOG_STYLE_LIST, "Create Business", mstr, "OK", "Exit");
	    }
	}
	else if(bid == -1 && bd != -1)
	{
	    SendClientError(playerid, "You cant use this cmd inside a biz.");
	}
	return 1;
}

CMD:vw(playerid, params[])
{
	if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	new idd;
	if(sscanf(params, "i", idd)) return SendClientUsage(playerid, "/vw [ID]");
	SetPlayerVirtualWorld(playerid, idd);
	return 1;
}

CMD:int(playerid, params[])
{
	if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	new pid;
	if(sscanf(params, "i", pid)) return SendClientUsage(playerid, "/int [ID]");
	SetPlayerInterior(playerid, pid);
	return 1;
}

CMD:kill(playerid, params[])
{
	SetTimerEx("KillTiming", 10000, false, "i", playerid);
	TogglePlayerControllable(playerid, false);
	new mstr[256];
	format(mstr, 256, "[OOC] %s has used /kill and is now respawning.", RPName(playerid));
	NearMessage(playerid, COLOR_RED, mstr);
	return 1;
}



CMD:respawn(playerid, params[])
{
    if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	new pid;
	if(sscanf(params, "u", pid)) return SendClientUsage(playerid, "/respawn [PlayerID / Name]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[playerid][Admin] < pData[pid][Admin]) return SendClientError(playerid, "You can not respawn an admin higher rank than yours.");
	SetPlayerHealth(pid, 0);
	SendClientSuccess(playerid, "Respawned the player successully.");
	SendClientMessage(playerid, COLOR_RED, "An admin has respawned you.");
	return 1;
}

CMD:freeze(playerid, params[])
{
    if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	new pid;
	if(sscanf(params, "u", pid)) return SendClientUsage(playerid, "/freeze [PlayerID / Name]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[playerid][Admin] < pData[pid][Admin]) return SendClientError(playerid, "You can not freeze an admin higher rank than yours.");
	TogglePlayerControllable(pid, false);
	SendClientSuccess(playerid, "Froze the player successully.");
	SendClientMessage(pid, COLOR_RED, "An admin has frozen you.");
	return 1;
}

CMD:unfreeze(playerid, params[])
{
    if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	new pid;
	if(sscanf(params, "u", pid)) return SendClientUsage(playerid, "/unfreeze [PlayerID / Name]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[playerid][Admin] < pData[pid][Admin]) return SendClientError(playerid, "You can not unfreeze an admin higher rank than yours.");
	TogglePlayerControllable(pid, true);
	SendClientSuccess(playerid, "Unfroze the player successully.");
	SendClientMessage(pid, COLOR_RED, "An admin has unfrozen you.");
	return 1;
}


CMD:tptome(playerid, params[])
{
	if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	new pid, mstr[256];
	if(sscanf(params, "u", pid)) return SendClientUsage(playerid, "/tptome [PlayerID / Name]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(pData[playerid][Admin] < pData[pid][Admin])
	{
		SendClientSuccess(playerid, "They have got your request to tp to you, let them tp.");
		format(mstr, 256, "%s wants you to tp to them.", RPName(playerid));
		SendClientMessage(pid, COLOR_GREEN, mstr);
	}
	else
	{
	    new Float:tmpx, Float:tmpy, Float:tmpz;
		GetPlayerPos(playerid, tmpx, tmpy, tmpz);
		SetPlayerPos(pid, tmpx, tmpy, tmpz+0.3);
		SendClientSuccess(playerid, "Teleported the player successfully to you.");
	}
	return 1;
}


CMD:ahouse(playerid, params[])
{
	new wat[10];
	if(pData[playerid][Admin] < 5) return SendClientError(playerid, CANT_USE_CMD);
	new hid = IsPlayerOutHouse(playerid);
	new hd = IsPlayerInHouse(playerid);
	if(hid != -1 && hd == -1) // if outside
	{
	    new mstr[256], onestr[256], alrm[10], locked[10];
	    format(onestr, 256, "%s's House (ID: %i)", hData[hid][hOwner], hid);
	    if(hData[hid][hAlarm] == 0) format(alrm, 10, "No"); else format(alrm, 10, "Yes");
	    if(hData[hid][hLocked] == 0) format(locked, 10, "No"); else format(locked, 10, "Yes");
	    format(mstr, 256, "Owner:\t\t\t%s\nInterior:\t\t%i\nAlarm:\t\t\t%s\nMoney:\t\t\t$%i\nLocked:\t\t%s\nSell:\t\t\t%i\nSave\nReload\nDelete",
		hData[hid][hOwner], hData[hid][hInteriorPack], alrm, hData[hid][hMoney], locked, hData[hid][hSell]);
		ShowPlayerDialog(playerid, DIALOG_ADMIN_HOUSE, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	else if(hid == -1 && hd == -1)
	{
	    if(sscanf(params, "s[10]", wat)) return SendClientUsage(playerid, "/ahouse [create]");
	    if(!strcmp(wat, "create", true, 6))
	    {
	        hid = GetUnusedHouseID();
			format(hData[hid][hOwner], 24, "None");
			new Float:tmpx, Float:tmpy, Float:tmpz, intt, vww;
			GetPlayerPos(playerid, tmpx, tmpy, tmpz);
			intt = GetPlayerInterior(playerid);
			vww = GetPlayerVirtualWorld(playerid);
			hData[hid][hX] = tmpx;
			hData[hid][hY] = tmpy;
			hData[hid][hZ] = tmpz;
			hData[hid][hInt] = intt;
			hData[hid][hVW] = vww;
			hData[hid][hAlarm] = 0;
			hData[hid][hMoney] = 0;
			hData[hid][hInteriorPack] = 0;
			hData[hid][hLocked] = 0;
			hData[hid][hSell] = 0;
			hData[hid][hActive] = 1;
			InsertHouse(hid);
			hData[hid][hActive] = 1;
         	hData[hid][hPickupID] = CreateDynamicPickup(1273, 23, hData[hid][hX], hData[hid][hY], hData[hid][hZ], hData[hid][hVW], hData[hid][hInt], -1, 100.0);
            new string[512], zone[48];
		    GetZone(hData[hid][hX], hData[hid][hY], hData[hid][hZ], zone);
			if(hData[hid][hSell] < 1) format(string,sizeof(string),"Owner: %s\nAddress: %s, %d",NoUnderscore(hData[hid][hOwner]),zone,hid);
			else format(string,sizeof(string),"Owner: %s\nAddress: %s %d\nPrice: $%d (/buyhouse to  buy)",NoUnderscore(hData[hid][hOwner]),zone,hid, hData[hid][hSell]);
			hData[hid][hLabel] = CreateDynamic3DTextLabel(string, -1,  hData[hid][hX], hData[hid][hY], hData[hid][hZ], 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5);
	    }
	}
	else if(hid == -1 && hd != -1)
	{
	    SendClientError(playerid, "You cant use this cmd inside a house.");
	}
	return 1;
}

CMD:buyhouse(playerid, params[])
{
	new hid = IsPlayerOutHouse(playerid);
	if(hid != -1)
	{
	    if(hData[hid][hSell] == 0) return SendClientError(playerid, "House is not on sale.");
	    if(GetPlayerMoneyEx(playerid) < hData[hid][hSell]) return SendClientError(playerid, "You do not have enough money.");
		new pid = GetPlayerID(hData[hid][hOwner]);
		if(IsPlayerConnected(pid))
		{
		    GivePlayerMoneyEx(playerid, -hData[hid][hSell]);
		    GivePlayerMoneyEx(pid, hData[hid][hSell]);
		    SendClientMessage(playerid, -1, "House bought");
		    SendClientMessage(pid, -1, "someone bought ur house");
		}
		else
		{
		    GiveOfflineMoneyEx(hData[hid][hOwner], hData[hid][hSell]);
		    GivePlayerMoneyEx(playerid, -hData[hid][hSell]);
		    SendClientMessage(playerid, -1, "DOne bought");
		}
		hData[hid][hSell] = 0;
		format(hData[hid][hOwner], 24, GetName(playerid));
		ReloadHouse(hid);
	}
	else SendClientError(playerid, "You are not outside any house.");
	return 1;
}

CMD:house(playerid, params[])
{
	new hid = IsPlayerOutHouse(playerid);
	new hd = IsPlayerInHouse(playerid);
	if(hid == -1 && hd == -1) // away
	{
	    if(GetPlayerHouses(playerid) == 0) return SendClientError(playerid, "You do not own any house");
	    new onestr[256], mstr[256], tmpstr[256], zone[20], cnt = 0;
	    format(onestr, 256, "%s's Houses", RPName(playerid));
	    for(new i = 0; i < MAX_HOUSES; i++)
	    {
	        if(hData[i][hActive] != 1) continue;
	        if(!strcmp(hData[i][hOwner], GetName(playerid), false))
	        {
	            if(cnt == 0)
	            {
	                cnt++;
	                GetZone(hData[i][hX], hData[i][hY], hData[i][hZ], zone);
	                format(tmpstr, 256, "House ID: %i at %s", i, zone);
	            }
	            else
	            {
	                GetZone(hData[i][hX], hData[i][hY], hData[i][hZ], zone);
	                format(tmpstr, 256, "\nHouse ID: %i at %s", i, zone);
	            }
	            strcat(mstr, tmpstr);
	        }
	    }
	    ShowPlayerDialog(playerid, DIALOG_PLAYER_HOUSE, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	if(hid != -1 && hd == -1) // outside
	{
	    if(strcmp(hData[hid][hOwner], GetName(playerid), false)) return SendClientError(playerid, "You do not own this house.");
	    new onestr[256], mstr[256], lock[10], alrm[10];
	    format(onestr, 256, "%s's House (ID: %i)", hData[hid][hOwner], hid);
		if(hData[hid][hLocked] == 1) format(lock, 10, "Yes"); else format(lock, 10, "No");
        if(hData[hid][hAlarm] == 1) format(alrm, 10, "Yes"); else format(alrm, 10, "No");
		format(mstr, 256, "Sell\nUpgrade\nAlarm:\t\t\t%s\nLocked:\t\t%s", alrm, lock);
		ShowPlayerDialog(playerid, DIALOG_PLAYER_HOUSE_OUT, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	if(hid == -1 && hd != -1) // inside
	{
	    new onestr[256], mstr[256], lock[10];
	    format(onestr, 256, "%s's House Safe", hData[hd][hOwner]);
		if(hData[hd][hSafe] == 0) format(lock, 10, "Unlocked"); else format(lock, 10, "Locked");
		format(mstr, 256, "Open Safe\nSafe Status: %s", lock);
		ShowPlayerDialog(playerid, DIALOG_PLAYER_HOUSE_IN, DIALOG_STYLE_LIST, onestr, mstr, "OK", "Exit");
	}
	return 1;
}

CMD:car(playerid, params[])
{
	if(GetPlayerVehicles(playerid) == 0) return SendClientError(playerid, "You do not own any vehicle");
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    new onestr[256], mstr[256], tmpstr[256];
		format(onestr, 256, "%s's Vehicles", RPName(playerid));
		new linecnt = 0;
		for(new i = 0; i < MAX_VEHICLES; i++)
		{
		    if(vData[i][vActive] != 1) continue;
		    if(!strcmp(vData[i][vOwner], GetName(playerid), false))
		    {
		        if(linecnt == 0)
		        {
		            format(tmpstr, 256, "%i\t%s\t%f", i, VehicleName[vData[i][vModel] - 400], vData[i][vMileage]);
		            linecnt++;
		        }
				else format(tmpstr, 256, "\n%i\t%s\t%f", i, VehicleName[vData[i][vModel] - 400], vData[i][vMileage]);
		        strcat(mstr, tmpstr);
		    }
		}
		ShowPlayerDialog(playerid, DIALOG_PLAYER_CAR, DIALOG_STYLE_TABLIST, onestr, mstr, "OK", "Exit");
	}
	else
	{
	    if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not the driver of this vehicle.");
     	new mstr[256], newvid, vd, ilock[10];
 		newvid = GetPlayerVehicleID(playerid);
   		vd = FindVehicleID(newvid);
   		if(vData[vd][vLocked] == 0) format(ilock, 10, "Lock"); else format(ilock, 10, "Unlock");
   		if(strcmp(vData[vd][vOwner], GetName(playerid), false)) return SendClientError(playerid, "You are not the owner of this vehicle");
     	format(mstr, 256, "Name: %s\n%s\nPark\nColour\nFactionize\nSell\nSave", VehicleName[vData[vd][vModel] - 400], ilock);
	  	ShowPlayerDialog(playerid, DIALOG_PLAYER_VEH, DIALOG_STYLE_LIST, "Vehicle Menu", mstr, "OK", "Exit");
	}
	return 1;
}

CMD:fcar(playerid, params[])
{
	if(GetPlayerFaction(playerid) == -1) return SendClientError(playerid, CANT_USE_CMD);
	new fid = GetPlayerFaction(playerid);
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    new onestr[256], mstr[256], tmpstr[256];
		format(onestr, 256, "%s's Vehicles", fData[fid][fName]);
		new linecnt = 0;
		for(new i = 0; i < MAX_VEHICLES; i++)
		{
		    if(vData[i][vActive] != 1) continue;
		    if(vData[i][vFaction] == fid)
		    {
		        if(linecnt == 0)
		        {
		            format(tmpstr, 256, "%i\t%s\t%f", i, VehicleName[vData[i][vModel] - 400], vData[i][vMileage]);
		            linecnt++;
		        }
				else format(tmpstr, 256, "\n%i\t%s\t%f", i, VehicleName[vData[i][vModel] - 400], vData[i][vMileage]);
		        strcat(mstr, tmpstr);
		    }
		}
		ShowPlayerDialog(playerid, DIALOG_PLAYER_CAR, DIALOG_STYLE_TABLIST, onestr, mstr, "OK", "Exit");
	}
	else
	{
	    if(pData[playerid][fTier] > 1) return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not the driver of this vehicle.");
     	new mstr[256], newvid, vd, ilock[10];
 		newvid = GetPlayerVehicleID(playerid);
   		vd = FindVehicleID(newvid);
   		if(vData[vd][vLocked] == 0) format(ilock, 10, "Lock"); else format(ilock, 10, "Unlock");
   		if(vData[vd][vFaction] != fid) return SendClientError(playerid, "You are not the owner of this vehicle");
     	format(mstr, 256, "Name: %s\n%s\nPark\nColour\nFactionize\nSell\nSave", VehicleName[vData[vd][vModel] - 400], ilock);
	  	ShowPlayerDialog(playerid, DIALOG_PLAYER_VEH, DIALOG_STYLE_LIST, "Vehicle Menu", mstr, "OK", "Exit");
	}
	return 1;
}

CMD:buycar(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not the driver of this vehicle");
	    new newvid, vd, mstr[256];
 		newvid = GetPlayerVehicleID(playerid);
   		vd = FindVehicleID(newvid);
   		if(vData[vd][vSell] < 1) return SendClientError(playerid, "This Vehicle is not on sale.");
   		if(GetPlayerMoneyEx(playerid) < vData[vd][vSell]) return SendClientError(playerid, "You do not have enough money to buy this vehicle.");
		new pid = GetPlayerID(vData[vd][vOwner]);
		if(IsPlayerConnected(pid))
		{
		    GivePlayerMoneyEx(pid, vData[vd][vSell]);
		    GivePlayerMoneyEx(playerid, -vData[vd][vSell]);
			format(mstr, 256, "%s has bought your %s for $%i.", RPName(playerid), VehicleName[vData[vd][vModel] - 400], vData[vd][vSell]);
			SendClientMessage(pid, COLOR_GREEN, mstr);
            format(mstr, 256, "%s has sold you his %s for $%i.", vData[vd][vOwner], VehicleName[vData[vd][vModel] - 400], vData[vd][vSell]);
            SendClientMessage(playerid, COLOR_GREEN, mstr);
            format(vData[vd][vOwner], 24, GetName(playerid));
            vData[vd][vSell] = 0;
            ReloadVehicle(vd);
			TogglePlayerControllable(playerid, true);
		}
		else
		{
			GiveOfflineMoneyEx(vData[vd][vOwner], vData[vd][vSell]);
			GivePlayerMoneyEx(playerid, -vData[vd][vSell]);
			format(mstr, 256, "%s has sold you his %s for $%i.", RPName(pid), VehicleName[vData[vd][vModel] - 400], vData[vd][vSell]);
            SendClientMessage(playerid, COLOR_GREEN, mstr);
            format(vData[vd][vOwner], 24, GetName(playerid));
            vData[vd][vSell] = 0;
            ReloadVehicle(vd);
            TogglePlayerControllable(playerid, true);
		}
	}
	else SendClientError(playerid, "You are not inside any vehicle.");
	return 1;
}

CMD:agive(playerid, params[])
{
	new wat[10], pid, much;
	if(sscanf(params, "us[10]i", pid, wat, much)) return SendClientUsage(playerid, "/agive [Player ID / Name] [Money] [Amount]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	if(!strcmp(wat, "money", true, 5))
	{
	    new mstr[256];
	    GivePlayerMoneyEx(pid, much);
	    format(mstr, 256, "You have given %s $%i.", RPName(pid), much);
	    SendClientSuccess(playerid, mstr);
	    format(mstr, 256, "%s has given you $%i.", RPName(playerid), much);
        SendClientSuccess(pid, mstr);
	}
	return 1;
}

CMD:exitcar(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle.");
	RemovePlayerFromVehicle(playerid);
	TogglePlayerControllable(playerid, true);
	return 1;
}

CMD:carlock(playerid, params[])
{
	new newvid, vd, mstr[256];
	if(IsPlayerNearAnyVehicle(playerid) == -1) return SendClientError(playerid, "You are not near any vehicle.");
	newvid = IsPlayerNearAnyVehicle(playerid);
	vd = FindVehicleID(newvid);
	if(strcmp(vData[vd][vOwner], GetName(playerid), false)) return SendClientError(playerid, "You are not the owner of this vehicle.");
	if(vData[vd][vLocked] == 1)
	{
		if(DoesVehicleHaveLock(newvid) == 1)
		{
			UnlockVehicle(newvid);
			format(mstr, sizeof(mstr),"has unlocked their %s.", VehicleName[vData[vd][vModel] - 400]);
			Action(playerid, mstr);
		}
		else return SendClientError(playerid, "This vehicle doesn't have a lock.");
	}
	else if(vData[vd][vLocked] == 0)
    {
		if(DoesVehicleHaveLock(newvid) == 1)
		{
			LockVehicle(-1, newvid); // nobody can open it
			format(mstr, sizeof(mstr),"has locked their %s.",VehicleName[vData[vd][vModel] - 400]);
			Action(playerid, mstr);
		}
		else return SendClientError(playerid, "This vehicle doesn't have a lock.");
	}
	return 1;
}



CMD:tpto(playerid, params[])
{
	if(!pData[playerid][Admin]) return SendClientError(playerid, CANT_USE_CMD);
	new pid;
	if(sscanf(params, "u", pid)) return SendClientUsage(playerid, "/tpto [Player ID / Name]");
	if(!IsPlayerConnected(pid)) return SendClientError(playerid, PNF);
	new Float:tmpx, Float:tmpy, Float:tmpz;
	GetPlayerPos(pid, tmpx, tmpy, tmpz);
	SetPlayerPos(playerid, tmpx, tmpy, tmpz+0.3);
	return 1;
}

CMD:me(playerid, params[])
{
	new mstr[256], mstrr[256];
	if(sscanf(params, "s[256]", mstr)) return SendClientUsage(playerid, "/me [Action]");
	Action(playerid, mstr);
	format(mstrr, 256, "** %s", mstr);
	SetPlayerChatBubble(playerid, mstrr, COLOR_ACTION, 40.0, 7000);
	return 1;
}

CMD:do(playerid, params[])
{
	new mstr[256], mstrr[256];
	if(sscanf(params, "s[256]", mstr)) return SendClientUsage(playerid, "/do [Action]");
	DoAction(playerid, mstr);
	format(mstrr, 256, "** %s", mstr);
	SetPlayerChatBubble(playerid, mstrr, COLOR_ACTION, 40.0, 7000);
	return 1;
}

CMD:b(playerid, params[])
{
	new mstr[256], mstrr[256];
	if(sscanf(params, "s[256]", mstr)) return SendClientUsage(playerid, "/b [Text]");
	format(mstrr, 256, "(( %s: %s ))", RPName(playerid), mstr);
	NearMessage(playerid, -1, mstrr);
	format(mstrr, 256, "(( %s ))", mstr);
	SetPlayerChatBubble(playerid, mstrr, -1, 40.0, 7000);
	return 1;
}

CMD:o(playerid, params[])
{
	new mstr[256], mstrr[256];
	if(IsOOCOn == 0) return SendClientError(playerid, "Server OOC Chat is not on.");
	if(sscanf(params, "s[256]", mstr)) return SendClientUsage(playerid, "/o [Text]");
	format(mstrr, 256, "(( OOC | %s %s: %s ))", AdminLvls[pData[playerid][Admin]][adlvlname], RPName(playerid), mstr);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        SendClientMessage(i, -1, mstrr);
	    }
	}
	return 1;
}

CMD:togooc(playerid, params[])
{
	if(pData[playerid][Admin] < 4) return SendClientError(playerid, CANT_USE_CMD);
	if(IsOOCOn == 1) // is on already
	{
		new mstr[256];
		format(mstr, 256, "%s has toggled the OOC Chat OFF.", RPName(playerid));
		SendClientMessageToAll(COLOR_RED, mstr);
		IsOOCOn = 0;
	}
	else
	{
		new mstr[256];
		format(mstr, 256, "%s has toggled the OOC Chat ON.", RPName(playerid));
		SendClientMessageToAll(COLOR_RED, mstr);
		IsOOCOn = 1;
	}
	return 1;
}

CMD:v(playerid, params[])
{
    if(pData[playerid][Admin] < 3) return SendClientError(playerid, CANT_USE_CMD);
	else if(pData[playerid][Admin] > 3)
	{
	    new param1[15], param2[15], mid;
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not the driver of this vehicle.");
	        new mstr[256], newvid, vd;
	        newvid = GetPlayerVehicleID(playerid);
	        vd = FindVehicleID(newvid);
	        format(mstr, 256, "Model ID: %i\nOwner: %s\nPark\nColour\nSell\nPlate: %s\nDelete Vehicle", vData[vd][vModel], vData[vd][vOwner], vData[vd][vPlate]);
	        ShowPlayerDialog(playerid, DIALOG_ADMIN_VEH, DIALOG_STYLE_LIST, "Vehicle Menu", mstr, "OK", "Exit");
	    }
	    else
	    {
	        if(isnull(params) && pData[playerid][Admin] >=3) return SendClientUsage(playerid, "/v [create] [ModelID / Name]");

    		sscanf(params, "s[15]s[15]", param1, param2);

    		if(strcmp(param1, "create", true) == 0)
		    {
				if(!IsNumeric(param2))
    			{
       				mid = GetModelIDFromName(param2);
       				if(mid == -1) return SendClientError(playerid, "No such vehicle name found.");
       			}
				else mid = strval(param2);
			    new Float:tmpx, Float:tmpy, Float:tmpz, Float:tmpa, intt, vww;
	            new vid = GetUnusedVehicleID();
	            if(vid == INVALID_VEHICLE_ID) return SendClientError(playerid, "Maximum vehicles created.");
	            GetPlayerPos(playerid, tmpx, tmpy, tmpz);
				intt = GetPlayerInterior(playerid);
				vww = GetPlayerVirtualWorld(playerid);
				vData[vid][vModel] = mid;
				vData[vid][vX] = tmpx+0.2;
                vData[vid][vY] = tmpy+0.2;
                vData[vid][vZ] = tmpz+0.3;
                vData[vid][vA] = tmpa;
                vData[vid][vInt] = intt;
                vData[vid][vPaintJob] = 0;
                vData[vid][vColour1] = 0;
                vData[vid][vColour2] = 0;
                vData[vid][vSell] = 0;
                vData[vid][vLocked] = 0;
                vData[vid][vLockedBy] = INVALID_PLAYER_ID;
                vData[vid][vVW] = vww;
                vData[vid][vFuel] = 100;
                vData[vid][vHealth] = 1000.0;
                vData[vid][vMileage] = 0.0;
                vData[vid][vAlarm] = 0;
                vData[vid][vRegistered] = 0;
                vData[vid][vFaction] = -1;
                vData[vid][vActive] = 1;
                format(vData[vid][vOwner], 24, "none");
  				format(vData[vid][vPlate], 15, "NONE00");
  				vData[vid][vID] = CreateVehicle(vData[vid][vModel], vData[vid][vX], vData[vid][vY], vData[vid][vZ], vData[vid][vA], vData[vid][vColour1], vData[vid][vColour2], -1);
                PutPlayerInVehicle(playerid, vData[vid][vID], 0);
				SetVehicleEngineOff(vData[vid][vID]);
				InsertVehicle(vid);
			}
			else return SendClientUsage(playerid, "/v [create] [ModelID / Name]");
		}
	}
	else if(pData[playerid][Admin] >=3) SendClientUsage(playerid, "/v [create] [ModelID / Name] ");
	return 1;
}

CMD:engine(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You need to be in a vehicle to use this!");
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	GetVehicleHealth(carid, vData[vehicleid][vHealth]);
	new UnOwnedVehicle, IsPlayerOwned, IsFacVehicle, vehengine, vehlights, vehalarm, vehdoors, vehbonnet, vehboot, vehobjective;
	new IsCorrectFac, IsOwner;
	GetVehicleParamsEx(carid, vehengine, vehlights, vehalarm, vehdoors, vehbonnet, vehboot, vehobjective);

	if(!strfind(vData[vehicleid][vOwner], "None")) UnOwnedVehicle = 0;
	if(strfind(vData[vehicleid][vOwner], "None")) UnOwnedVehicle = 1;

	if(!strfind(vData[vehicleid][vOwner], "_")) IsPlayerOwned = 0;
	if(strfind(vData[vehicleid][vOwner], "_")) IsPlayerOwned = 1;

	if(!strfind(vData[vehicleid][vOwner], GetName(playerid))) IsOwner = 0;
 	if(strfind(vData[vehicleid][vOwner], pData[playerid][Username])) IsOwner = 1;

 	if(vData[vehicleid][vFaction] == -1) IsFacVehicle = 0;
	if(vData[vehicleid][vFaction] != -1) IsFacVehicle = 1;

 	if(pData[playerid][Faction] != vData[vehicleid][vFaction]) IsCorrectFac = 0;
 	if(pData[playerid][Faction] == vData[vehicleid][vFaction]) IsCorrectFac = 1;

	if(vData[vehicleid][vHealth] < 250.0) return SendClientError(playerid, "Couldn't start engine! Vehicle damaged.");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not driving any vehicle!");
	if(DoesVehicleHaveEngine(carid) == 0) return SendClientError(playerid, "This vehicle doens't have an engine.");
	if(IsPlayerOwned == 1 && IsOwner == 1 || IsFacVehicle == 1 && IsCorrectFac == 1|| UnOwnedVehicle == 1)
	{
		switch(vehengine)
		{
	 		case 1:
	   		{
	    		SetVehicleParamsEx(carid, 0, vehlights, vehalarm, vehdoors, vehbonnet, vehboot, vehobjective);
			    Action(playerid, "Turns the key, stopping the Engine.");
			    return 1;
			}
			case 0:
			{
	  			SetVehicleParamsEx(carid, 1, vehlights, vehalarm, vehdoors, vehbonnet, vehboot, vehobjective);
		    	Action(playerid, "Turns the key, starting the Engine.");
		    	return 1;
			}
		}
	}
	else return SendClientError(playerid, "You don't have the Key to this Vehicle!");
	return 1;
}

CMD:makeadmin(playerid, params[])
{
	new plID, lvl, promote = 0;
	if(pData[playerid][Admin] > 5 || IsPlayerAdmin(playerid))
	{
	    if(sscanf(params, "ui", plID, lvl)) return SendClientUsage(playerid, "makeadmin [PlayerID/Name] [Admin Level]");
	    if(!IsPlayerConnected(plID)) return SendClientError(playerid, PNF);
	    if(lvl < 0 || lvl > 7) return SendClientError(playerid, "Wrong admin level entered.");
	    if(lvl == pData[plID][Admin]) return SendClientError(playerid, "Player is already that level admin.");
		if(lvl > pData[plID][Admin]) promote = 1;
	    pData[plID][Admin] = lvl;
	    SavePlayer(plID);
	    new mstr[256];
	    if(promote == 1)
	    {
	        format(mstr, 256, "%s has promoted %s to %s.", RPName(playerid), RPName(plID), AdminLvls[lvl][adlvlname]);
	        SendMessageToAdmins(mstr);
	    }
	    else
	    {
	        format(mstr, 256, "%s has demoted %s to %s.", RPName(playerid), RPName(plID), AdminLvls[lvl][adlvlname]);
	        SendMessageToAdmins(mstr);
	    }
	}
	else SendClientError(playerid, CANT_USE_CMD);
	return 1;
}

CMD:omakeadmin(playerid, params[])
{
	new pname[24], lvl;
	if(pData[playerid][Admin] > 5 || IsPlayerAdmin(playerid))
	{
	    if(sscanf(params, "s[24]i", pname, lvl)) return SendClientMessage(playerid,-1, "/omakeadmin [Player_Name] [Admin Level]");
	    new mQuery[256];
		mysql_format(MySQL, mQuery, 256, "UPDATE `playerdata` SET `Admin` = '%i' WHERE `Username` = '%s'", lvl, pname);
		mysql_tquery(MySQL, mQuery);
		SendClientSuccess(playerid, "Changed the admin level successfully.");
	}
	else SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
CMD:commands(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GOLD, " ========== [ "SERVER_GM" Commands ] ==========");
    SendClientMessage(playerid, COLOR_GREY, "[GENERAL] /me, /do, /b, /o, /kill, /frisk, /whisper");
    SendClientMessage(playerid, COLOR_GREY, "[VEHICLE] /car, /buycar, /exitcar, /engine, /carlock");
    SendClientMessage(playerid, COLOR_GREY, "[HOUSE] /house");
    SendClientMessage(playerid, COLOR_GREY, "[FACTION] /faction, /factioninfo, /loadresidue, /loadguns, /storeinfactory");
    if(pData[playerid][Admin]) SendClientMessage(playerid, COLOR_GREY, "[ADMIN] /ahelp");
	return 1;
}

CMD:ahelp(playerid, params[])
{
	if(pData[playerid][Admin])
	{
	    SendClientMessage(playerid, COLOR_GOLD, " ========== [ "SERVER_GM" Admin Commands ] ==========");
	    if(pData[playerid][Admin] > 0)
	        SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1] /tpto, /tptome, /freeze, /unfreeze, /respawn, /int, /vw");
        if(pData[playerid][Admin] > 1)
	        SendClientMessage(playerid, COLOR_GREY, "[LEVEL 2] Nothing for now");
        if(pData[playerid][Admin] > 2)
        	SendClientMessage(playerid, COLOR_GREY, "[LEVEL 3] Nothing for now");
        if(pData[playerid][Admin] > 3)
        	SendClientMessage(playerid, COLOR_GREY, "[LEVEL 4] /v, /asetrank, /asettier, /makeleader");
        if(pData[playerid][Admin] > 4)
        	SendClientMessage(playerid, COLOR_GREY, "[LEVEL 5] /ahouse, /abiz, /afaction, /ahq, /afactory");
        if(pData[playerid][Admin] > 5)
        	SendClientMessage(playerid, COLOR_GREY, "[LEVEL 6] /makeadmin, /omakeadmin");
   		SendClientMessage(playerid, COLOR_GOLD, " ====================================================");
	}
	else SendClientError(playerid, CANT_USE_CMD);
	return 1;
}

CMD:pm(playerid,params[])
{
	new fId;
	new pName[24];
	new pMsg[100];
	new fMsg[100];
	new msg[100];
	if(sscanf(params,"su",msg,fId)) return SendClientMessage(playerid, -1, "USAGE: /pm [playerid] [text]");
	if(fId == playerid) return SendClientError(playerid,"You can't pm yourself.");
	if(!IsPlayerConnected(fId)) return SendClientError(playerid, "Player not Connected!");
	GetPlayerName(playerid, pName, sizeof(pName));
	format(pMsg,sizeof(pMsg),"%s : %s",pName,msg);
	format(fMsg, sizeof(fMsg), "%s : %s", pName,msg);
	SendClientMessage(playerid, COLOR_GOLD, pMsg);
	SendClientMessage(fId, COLOR_GOLD, fMsg);
	return 1;
}

CMD:jp(playerid,params[])
{
	if(pData[playerid][Admin] > 2)
		SetPlayerSpecialAction(playerid, 2);
	else
		SendClientError(playerid,CANT_USE_CMD);
	return 1;
}
/* ======================================================================= */
// **************************** [ FUNCTIONS ] **************************** //
/* ======================================================================= */
GetVehiclePeople(carid)
{
	new szCount = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if( GetPlayerVehicleID( i ) == carid ) szCount++;
	}
	return szCount;
}

IsPlayerAtObj(playerid, obtype)
{
	new getid;
	for(new i = 0; i < sizeof(objfloat); i++)
	{
	    if(objfloat[i][oinfoid] == obtype)
	    {
	        getid = i;
	        break;
	    }
	}
	if(IsPlayerInRangeOfPoint(playerid, 5, objfloat[getid][olocation_x], objfloat[getid][olocation_y], objfloat[getid][olocation_z]))
	{
	    return 1;
	}
	else return 0;
}

ShowClosestBizs(playerid)
{
	new cnt = 0, mstr[256], tmpstr[256];
	for(new i = 0; i < sizeof(BizTypeList); i++)
	{
	    if(cnt == 0)
	    {
	    	format(tmpstr, 256, "%s\t\t\t%f", BizTypeList[i][biz_N], GetClosestBiz(playerid, BizTypeList[i][biz_T], 1));
	    	cnt++;
	  	}
	  	else format(tmpstr, 256, "\n%s\t\t\t%f", BizTypeList[i][biz_N], GetClosestBiz(playerid, BizTypeList[i][biz_T], 1));
	  	strcat(mstr, tmpstr);
	}
	ShowPlayerDialog(playerid, DIALOG_CLOSEST_BIZS, DIALOG_STYLE_LIST, "Closest Businesses", mstr, "Navigate", "Exit");
	return 1;
}

GetClosestBiz(playerid, bdType, wantdist = 0)
{
	new bid = -1, Float:bdist = 9999.0;
	for(new b = 0; b < MAX_BUSINESS; b++)
	{
	    if(bData[b][bActive] != 1) continue;
	    if(bData[b][bType] != bdType) continue;
		if( GetPlayerDistanceToPointEx(playerid, bData[b][bX], bData[b][bY], bData[b][bZ]) < bdist )
		{
		    bid = b;
		    bdist = GetPlayerDistanceToPointEx(playerid, bData[b][bX], bData[b][bY], bData[b][bZ]);
		}
	}
	if(wantdist == 1)
	{
	    return floatround(bdist);
	}
	return bid;
}

GetPlayerDistanceToPointEx(playerid,Float:sx,Float:sy,Float:sz) //By Sacky
{
	new Float:x1,Float:y1,Float:z1;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(sx,x1)),2)+floatpower(floatabs(floatsub(sy,y1)),2)+floatpower(floatabs(floatsub(sz,z1)),2));
	return floatround(tmpdis);
}

PUBLIC:KillTiming(playerid)
{
	TogglePlayerControllable(playerid, true);
	SetPlayerHealth(playerid, 0);
}

CheckEnter(playerid)
{
	new tmps;
	tmps = IsPlayerOutHouse(playerid);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    if(hData[tmps][hLocked] == 1) return GameTextForPlayer(playerid,"~r~Locked", 3000, 3);
	    new intp = GetHouseInteriorID(tmps);
	    SetPlayerInterior(playerid, HouseInteriors[intp][hinterior]);
	    SetPlayerVirtualWorld(playerid, tmps+1);
	    SetPlayerPos(playerid, HouseInteriors[intp][hintx], HouseInteriors[intp][hinty], HouseInteriors[intp][hintz]);
	    SetCameraBehindPlayer(playerid);
	    LetItLoadLOL(playerid);
	}
	tmps = IsPlayerOutBiz(playerid);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    if(bData[tmps][bLocked] == 1) return GameTextForPlayer(playerid, "~r~Locked", 3000, 3);
	    new intp = GetBizInteriorID(tmps);
	    SetPlayerInterior(playerid, BusinessInteriors[intp][enterInt]);
	    SetPlayerVirtualWorld(playerid, tmps+1);
	    SetPlayerPos(playerid, BusinessInteriors[intp][enterX], BusinessInteriors[intp][enterY], BusinessInteriors[intp][enterZ]);
	    SetPlayerFacingAngle(playerid, BusinessInteriors[intp][enterA]);
	    SetCameraBehindPlayer(playerid);
	    LetItLoadLOL(playerid);
	}
	tmps = IsPlayerOutHQ(playerid);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    if(fData[tmps][fOpen] == 0) return GameTextForPlayer(playerid, "~r~Closed", 3000, 3);
	    SetPlayerInterior(playerid, fData[tmps][fInInt]);
	    SetPlayerVirtualWorld(playerid, fData[tmps][fInVW]);
	    SetPlayerPos(playerid, fData[tmps][fInX], fData[tmps][fInY], fData[tmps][fInZ]);
	    SetPlayerFacingAngle(playerid, fData[tmps][fInA]);
	    SetCameraBehindPlayer(playerid);
	    LetItLoadLOL(playerid);
	}
	tmps = IsPlayerOutBank(playerid);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    SetPlayerInterior(playerid, BankInterior[bankIntInt]);
		SetPlayerVirtualWorld(playerid, tmps+1);
		SetPlayerPos(playerid, BankInterior[bankIntX], BankInterior[bankIntY], BankInterior[bankIntZ]);
		SetPlayerFacingAngle(playerid, BankInterior[bankIntA]);
		SetCameraBehindPlayer(playerid);
		LetItLoadLOL(playerid);
	}
	return 1;
}

CheckExit(playerid)
{
	new tmps;
	tmps = IsPlayerInHouse(playerid, 5.0);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
		SetPlayerInterior(playerid, hData[tmps][hInt]);
		SetPlayerVirtualWorld(playerid, hData[tmps][hVW]);
		SetPlayerPos(playerid, hData[tmps][hX], hData[tmps][hY], hData[tmps][hZ]);
		SetCameraBehindPlayer(playerid);
		LetItLoadLOL(playerid);
	}
	tmps = IsPlayerInBiz(playerid, 5.0);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    SetPlayerInterior(playerid, bData[tmps][bInt]);
	    SetPlayerVirtualWorld(playerid, bData[tmps][bVW]);
	    SetPlayerPos(playerid, bData[tmps][bX], bData[tmps][bY], bData[tmps][bZ]);
	    SetCameraBehindPlayer(playerid);
	    LetItLoadLOL(playerid);
	}
	tmps = IsPlayerInHQ(playerid, 5.0);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    SetPlayerInterior(playerid, fData[tmps][fInt]);
	    SetPlayerVirtualWorld(playerid, fData[tmps][fVW]);
	    SetPlayerPos(playerid, fData[tmps][fhX], fData[tmps][fhY], fData[tmps][fhZ]);
	    SetCameraBehindPlayer(playerid);
	    LetItLoadLOL(playerid);
	}
	tmps = IsPlayerInBank(playerid, 5.0);
	if(tmps != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    SetPlayerInterior(playerid, bankData[tmps][bankInt]);
	    SetPlayerVirtualWorld(playerid, bankData[tmps][bankVW]);
	    SetPlayerPos(playerid, bankData[tmps][bankX], bankData[tmps][bankY], bankData[tmps][bankZ]);
	    SetCameraBehindPlayer(playerid);
	    LetItLoadLOL(playerid);
	}
	return 1;
}

LetItLoadLOL(playerid)
{
	TogglePlayerControllable(playerid, false);
	GameTextForPlayer(playerid,"~r~Loading Map", 3000, 3);
	SetTimerEx("LoadedLOL", 4000, false, "i", playerid);
}

PUBLIC:LoadedLOL(playerid)
{
	TogglePlayerControllable(playerid, true);
}

IsPlayerOutFactory(playerid)
{
    new isyes = -1;
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
	    if(fData[i][fActive] != 1) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, fData[i][fFX], fData[i][fFY], fData[i][fFZ]))
	    {
	        if(GetPlayerInterior(playerid) == fData[i][fFInt] && GetPlayerVirtualWorld(playerid) == fData[i][fFVW])
	        {
	            isyes = i;
	        	break;
	        }
	    }
	}
	return isyes;
}

IsPlayerOutHQ(playerid)
{
	new isyes = -1;
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
	    if(fData[i][fActive] != 1) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, fData[i][fhX], fData[i][fhY], fData[i][fhZ]))
	    {
	        if(GetPlayerInterior(playerid) == fData[i][fInt] && GetPlayerVirtualWorld(playerid) == fData[i][fVW])
	        {
	            isyes = i;
	        	break;
	        }
	    }
	}
	return isyes;
}

IsPlayerInHQ(playerid, Float:range = 30.0)
{
	new isyes = -1;
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
	    if(fData[i][fActive] != 1) continue;
		if(GetPlayerInterior(playerid) == fData[i][fInInt] && GetPlayerVirtualWorld(playerid) == fData[i][fInVW])
		{
  			if(IsPlayerInRangeOfPoint(playerid, range, fData[i][fInX], fData[i][fInY], fData[i][fInZ]))
     		{
       			isyes = i;
          		break;
       		}
		}
	}
	return isyes;
}



GetPlayerBizs(playerid)
{
	new isyes = 0;
	for(new i = 0; i < MAX_BUSINESS; i++)
	{
	    if(bData[i][bActive] != 1) continue;
	    if(!strcmp(bData[i][bOwner], GetName(playerid), false))  isyes++;
	}
	return isyes;
}


GetPlayerHouses(playerid)
{
	new isyes = 0;
	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if(hData[i][hActive] != 1) continue;
	    if(!strcmp(hData[i][hOwner], GetName(playerid), false))  isyes++;
	}
	return isyes;
}

GetUnusedFacID()
{
	new isyes = -1;
	for(new i = 0; i < MAX_FACTIONS; i++)
	{
	    if(fData[i][fActive] == 0)
	    {
	        isyes = i;
	        break;
	    }
	}
	return isyes;
}

GetUnusedBizID()
{
	new isyes = -1;
	for(new i = 0; i < MAX_BUSINESS; i++)
	{
	    if(bData[i][bActive] == 0)
	    {
	        isyes = i;
	        break;
	    }
	}
	return isyes;
}

GetUnusedBankID()
{
	new isyes = -1;
	for(new i = 0; i < MAX_BANKS; i++)
	{
	    if(bankData[i][bankActive] == 0)
	    {
	        isyes = i;
	        break;
	    }
	}
	return isyes;
}

GetUnusedHouseID()
{
	new isyes = -1;
	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if(hData[i][hActive] == 0)
	    {
	        isyes = i;
	        break;
	    }
	}
	return isyes;
}

IsPlayerOutBiz(playerid)
{
	new isyes = -1;
	for(new i = 0; i < MAX_BUSINESS; i++)
	{
	    if(bData[i][bActive] != 1) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, bData[i][bX], bData[i][bY], bData[i][bZ]))
	    {
	        if(GetPlayerInterior(playerid) == bData[i][bInt] && GetPlayerVirtualWorld(playerid) == bData[i][bVW])
	        {
	            isyes = i;
	        	break;
	        }
	    }
	}
	return isyes;
}

IsPlayerInBiz(playerid, Float:range = 30.0)
{
	new isyes = -1;
	for(new i = 0; i < MAX_BUSINESS; i++)
	{
	    if(bData[i][bActive] != 1) continue;
		new intp = GetBizInteriorID(i);
		if(intp != -1)
		{
		    if(GetPlayerInterior(playerid) == BusinessInteriors[intp][enterInt] && GetPlayerVirtualWorld(playerid) == i+1)
		    {
		        if(IsPlayerInRangeOfPoint(playerid, range, BusinessInteriors[intp][enterX], BusinessInteriors[intp][enterY], BusinessInteriors[intp][enterZ]))
		        {
		            isyes = i;
		            break;
		        }
			}
		}
	}
	return isyes;
}

GetBizInteriorID(bid)
{
	new isyes = -1;
	for(new i = 0; i < sizeof(BusinessInteriors); i++)
	{
	    if(bData[bid][bInteriorPack] == BusinessInteriors[i][interiorid])
	    {
			isyes = i;
			break;
	    }
	}
	return isyes;
}

IsPlayerOutBank(playerid)
{
	new isyes = -1;
	for(new i = 0; i < MAX_BANKS; i++)
	{
	    if(bankData[i][bankActive] != 1) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, bankData[i][bankX], bankData[i][bankY], bankData[i][bankZ]))
	    {
	        if(GetPlayerInterior(playerid) == bankData[i][bankInt] && GetPlayerVirtualWorld(playerid) == bankData[i][bankVW])
	        {
	            isyes = i;
	        	break;
	        }
	    }
	}
	return isyes;
}

IsPlayerInBank(playerid, Float:range = 30.0)
{
	new isyes = -1;
	for(new i = 0; i < MAX_BANKS; i++)
	{
	    if(bankData[i][bankActive] != 1) continue;
		new intp = bankData[i][bankInterior];
		if(intp != -1)
		{
		    if(GetPlayerInterior(playerid) == BankInterior[bankIntInt] && GetPlayerVirtualWorld(playerid) == i+1)
		    {
		        if(IsPlayerInRangeOfPoint(playerid, range, BankInterior[bankIntX], BankInterior[bankIntY], BankInterior[bankIntZ]))
		        {
		            isyes = i;
		            break;
		        }
			}
		}
	}
	return isyes;
}

IsPlayerOutHouse(playerid)
{
	new isyes = -1;
	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if(hData[i][hActive] != 1) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, hData[i][hX], hData[i][hY], hData[i][hZ]))
	    {
	        if(GetPlayerInterior(playerid) == hData[i][hInt] && GetPlayerVirtualWorld(playerid) == hData[i][hVW])
	        {
	            isyes = i;
	        	break;
	        }
	    }
	}
	return isyes;
}

IsPlayerInHouse(playerid, Float:range = 30.0)
{
	new isyes = -1;
	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if(hData[i][hActive] != 1) continue;
		new intp = GetHouseInteriorID(i);
		if(intp != -1)
		{
		    if(GetPlayerInterior(playerid) == HouseInteriors[intp][hinterior] && GetPlayerVirtualWorld(playerid) == i+1)
		    {
		        if(IsPlayerInRangeOfPoint(playerid, range, HouseInteriors[intp][hintx], HouseInteriors[intp][hinty], HouseInteriors[intp][hintz]))
		        {
		            isyes = i;
		            break;
		        }
			}
		}
	}
	return isyes;
}

GetHouseInteriorID(hid)
{
	new isyes = -1;
	for(new i = 0; i < sizeof(HouseInteriors); i++)
	{
	    if(hData[hid][hInteriorPack] == HouseInteriors[i][hintpack])
	    {
			isyes = i;
			break;
	    }
	}
	return isyes;
}

GiveOfflineMoneyEx(pname[], money)
{
	new mQuery[256];
	mysql_format(MySQL, mQuery, 256, "UPDATE `playerdata` SET `Money` = `playerdata`.`Money`+ '%i' WHERE `Username` = '%s'", money, pname);
	mysql_tquery(MySQL, mQuery);
}

GetPlayerVehicles(playerid)
{
	new count = 0;
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(vData[i][vActive] != 1) continue;
	    if(!strcmp(vData[i][vOwner], GetName(playerid), false)) count++;
	}
	return count;
}

CheckForSpace(s1[], s2[], s3[])
{
	new isone = 1, s2cnt = 0, s3cnt = 0;
	for(new i = 0, len = strlen(s1); i < len; i++)
	{
	    if(isone == 1)
		{
			if(s1[i] != ' ')
			{
				s2[s2cnt] = s1[i];
				s2cnt++;
			}
			else isone = 0;
		}
		else
		{
		    if(s1[i] != ' ')
		    {
		        s3[s3cnt] = s1[i];
		        s3cnt++;
		    }
		}
	}
}
IsPlayerDriver(playerid) //By Sacky
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)	return 1;
	return 0;
}

stock GetOnlinePlayers()
{
	new count=0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			count++;
		}
	}
	return count;
}

stock minrand(min, max) //By Alex "Y_Less" Cole
{
	return random(max - min) + min;
}

IsRPName(pname[])
{
	new isyes = 0;
	for(new i = 1, len = strlen(pname); i < len-1; i++)
	{
	    if(pname[0] == '_')
		{
			isyes = 0;
			break;
		}
		if(pname[len-1] == '_')
		{
		    isyes = 0;
		    break;
		}
		if(pname[i] == '_')
		{
		    isyes = 1;
		    break;
		}
	}
	return isyes;
}

NoUnderscore(string[]) // by w00t
{
    new str[512];
    strmid(str,string,0,strlen(string), 512);
    for(new i = 0; i < 512; i++)
    {
        if (str[i] == '_') str[i] = ' ';
    }
    return str;
}

NearMessage(playerid, color, text[], Float:dist = 50.0)
{
	new Float:newx,Float:newy,Float:newz;
	GetPlayerPos(playerid,newx,newy,newz);
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerInRangeOfPoint(i, dist, newx, newy, newz)) continue;
		if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid) || GetPlayerInterior(i) != GetPlayerInterior(playerid)) continue;
		SendClientMessage(i,color,text);
	}
	return 1;
}

stock NearMessageEx(color, text[], Float:rrX, Float:rrY, Float:rrZ, rrInterior, rrVirtualWorld, Float:dist = 75.00)
{
    PlayerLoop(i)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerInRangeOfPoint(i, dist, rrX, rrY, rrZ)) continue;
		if(GetPlayerVirtualWorld(i) != rrVirtualWorld || GetPlayerInterior(i) != rrInterior) continue;
		SendClientMessage(i, color, text);
	}
	return 1;
}

Action(playerid, what[])
{
	new iStr[256];
	format(iStr,sizeof(iStr),"** %s %s", RPName(playerid), what);
	NearMessage(playerid,COLOR_ACTION, iStr);
}

DoAction(playerid, what[])
{
	new iStr[256];
	format(iStr,sizeof(iStr),"** %s (( %s ))", what, RPName(playerid));
	NearMessage(playerid,COLOR_ACTION, iStr);
}

RPName(playerid)
{
	new pname[24], mstr[24];
	GetPlayerName(playerid, pname, 24);
	format(mstr, 24, NoUnderscore(pname));
	return mstr;
}

SetPlayerMoney(playerid,ammount)
{
     ResetPlayerMoney(playerid);
     GivePlayerMoney(playerid,ammount);
     return 1;
}

stock IsPlayerOnline(const name[])
{
	new tmp = -1;
	for(new i =0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new pname[24];
	        GetPlayerName(i, pname, 24);
	        if(!strcmp(pname, name, true))
	        {
	            tmp = i;
	        }
	    }
	}
	return tmp;
}

RemovePlayerWeapon(playerid, weaponid)
{
    SetPlayerArmedWeapon(playerid, weaponid);
    if (GetPlayerWeapon(playerid) != 0) GivePlayerWeapon(playerid, GetPlayerWeapon(playerid), -(GetPlayerAmmo(playerid)));

    return 1;
}

GetWeaponIDByName(str[])
{
	new wid = 0;
	for(new i = 0; i < 55; i++)
	{
		if(!strcmp(GetWeaponNameByID(i), str, true))
		{
			wid = i;
			break;
		}
	}
	return wid;
}

stock IsPlayerAtPDStock(playerid)
{
	new a = 0;
	if(IsPlayerInRangeOfPoint(playerid, 10, PDStock[0][pdX], PDStock[0][pdY], PDStock[0][pdZ]))
	{
		if(GetPlayerInterior(playerid) == PDStock[0][pdInt] && GetPlayerVirtualWorld(playerid) == PDStock[0][pdVW])
		{
			a = 1;
		}
	}
	return a;
}

ReloadPDStockLabel()
{
	DestroyDynamic3DTextLabel(PDStock[0][pdLabel]);
	new mstr[256];
	format(mstr, 256, "{A1C2FF}Police Department Stock\n{A1C2FF}Stock: {FFFFFF}%i Guns", PDStock[0][pdGuns]);
	CreateDynamic3DTextLabel(mstr, COLOR_WHITE, PDStock[0][pdX], PDStock[0][pdY], PDStock[0][pdZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PDStock[0][pdVW], PDStock[0][pdInt]);
}

IsPlayerLegal(playerid)
{
	if(GetPlayerFaction(playerid) == -1) return 0;
	new fid = GetPlayerFaction(playerid);
	if(fData[fid][fType] == FACTION_LEGAL || fData[fid][fType] == FACTION_POLICE) return 1;
	return 0;
}

stock IsPlayerIllegal(playerid)
{
	if(GetPlayerFaction(playerid) == -1) return 0;
	new fid = GetPlayerFaction(playerid);
	if(fData[fid][fType] == FACTION_ILLEGAL) return 1;
	return 0;
}



GetGunsRequiredFor(wepid)
{
	new gn = -1;
	switch(wepid)
	{
		case 1 .. 24: gn = 1;
		case 25 .. 28: gn = 2;
		case 29: gn = 3;
		case 30 .. 32: gn = 4;
		case 33 .. 34: gn = 5;
		default: gn  = -1;
	}
	return gn;
}

IsPlayerAtArrestPoint(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1.1, 2.2, 3.3)) return 1;
	return 0;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid))
	{
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

GetClosestGate(playerid, Float: range = 5.0)
{
	new id = -1, Float: playerdist, Float: tempdist = 9999.0;
	foreach(new i : Gates)
	{
        playerdist = GetPlayerDistanceFromPoint(playerid, GateData[i][GatePos][0], GateData[i][GatePos][1], GateData[i][GatePos][2]);
        if(playerdist > range) continue;
	    if(playerdist <= tempdist)
	    {
	        tempdist = playerdist;
	        id = i;
	    }
	}

	return id;
}

SetGateState(id, gate_state, move = 1)
{
    new string[32];
	format(string, sizeof(string), "Gate #%d\n%s", id, GateStates[gate_state]);
	UpdateDynamic3DTextLabelText(GateData[id][GateLabel], 0xECF0F1FF, string);
	GateData[id][GateState] = gate_state;

	switch(move)
	{
	    case 1:
	    {
	        if(gate_state == GATE_STATE_CLOSED) {
	        	MoveDynamicObject(GateData[id][GateObject], GateData[id][GatePos][0], GateData[id][GatePos][1], GateData[id][GatePos][2], MOVE_SPEED, GateData[id][GateRot][0], GateData[id][GateRot][1], GateData[id][GateRot][2]);
			}else{
                MoveDynamicObject(GateData[id][GateObject], GateData[id][GateOpenPos][0], GateData[id][GateOpenPos][1], GateData[id][GateOpenPos][2], MOVE_SPEED, GateData[id][GateOpenRot][0], GateData[id][GateOpenRot][1], GateData[id][GateOpenRot][2]);
			}
		}

		case 2:
		{
		    if(gate_state == GATE_STATE_CLOSED) {
	        	SetDynamicObjectPos(GateData[id][GateObject], GateData[id][GatePos][0], GateData[id][GatePos][1], GateData[id][GatePos][2]);
				SetDynamicObjectRot(GateData[id][GateObject], GateData[id][GateRot][0], GateData[id][GateRot][1], GateData[id][GateRot][2]);
			}else{
                SetDynamicObjectPos(GateData[id][GateObject], GateData[id][GateOpenPos][0], GateData[id][GateOpenPos][1], GateData[id][GateOpenPos][2]);
				SetDynamicObjectRot(GateData[id][GateObject], GateData[id][GateOpenRot][0], GateData[id][GateOpenRot][1], GateData[id][GateOpenRot][2]);
			}
		}
	}

	return 1;
}

ToggleGateState(id, move = 1)
{
	if(GateData[id][GateState] == GATE_STATE_CLOSED) {
	    SetGateState(id, GATE_STATE_OPEN, move);
	}else{
	    SetGateState(id, GATE_STATE_CLOSED, move);
	}

	return 1;
}

ShowEditMenu(playerid, id)
{
    new string[128];
	format(string, sizeof(string), "Gate State\t%s\nGate Password\t%s\nEdit Gate Position\nEdit Opening Position\nRemove Gate", GateStates[ GateData[id][GateState] ], GateData[id][GatePassword]);
	ShowPlayerDialog(playerid, DIALOG_GATE_EDITMENU, DIALOG_STYLE_TABLIST, "Gate Editing", string, "Choose", "Cancel");
	return 1;
}

GetWeaponNameByID(wid) // By JONNy5
{
    new gunname[32];
    switch (wid)
    {
        case    1 .. 17,
                22 .. 43,
                46 :        GetWeaponName(wid,gunname,sizeof(gunname));
        case    0:          format(gunname,32,"%s","None");
        case    18:         format(gunname,32,"%s","Molotov Cocktail");
        case    44:         format(gunname,32,"%s","Night Vis Goggles");
        case    45:         format(gunname,32,"%s","Thermal Goggles");
        default:            format(gunname,32,"%s","Invalid Weapon Id");

    }
    return gunname;
}

GetPlayerFaction(playerid)
{
	return pData[playerid][Faction];
}

GetTotalMembers(fid, count = -1, rank = -1)
{
	if(fData[fid][fActive] != 1) return 0;
	if(count == -1 && rank == -1)
	{
	    new iQuery[228];
		mysql_format(MySQL, iQuery, sizeof(iQuery), "SELECT * FROM `playerdata` WHERE `Faction` = '%i'", fid);
		new Cache:result = mysql_query(MySQL, iQuery);
		new rows = cache_num_rows();
		cache_delete(result);
		return rows;
	}
	else if(count != -1 && rank != -1)
	{
	    new iQuery[228];
		mysql_format(MySQL, iQuery, sizeof(iQuery), "SELECT * FROM `playerdata` WHERE `Faction` = '%i', `Tier` = '%i'", fid, rank);
		new Cache:result = mysql_query(MySQL, iQuery);
		new rows = cache_num_rows();
		cache_delete(result);
		return rows;
	}
	else return 0;
}

GetOnlineMembers(fid)
{
	new count = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
 	{
	    if(IsPlayerConnected(i))
	    {
	        if(pData[i][Faction] == fid) count++;
	    }
	}
	return count;
}

GetFactionVehicles(fid)
{
	new count = 0;
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(vData[i][vActive] != 1) continue;
	    if(vData[i][vFaction] == fid)
	    {
	        count++;
	    }
	}
	return count;
}

IsPlayerAtPrison(playerid)
{
	if(IsPlayerInArea(playerid, 369.3492,157.6740, 404.3284,184.1811)) return 1;
	return 0;
}

IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) return 1;
	return 0;
}

GetNumberFromString(string[])
{
	new str[10], cnt = -1, tmps[2];
	for(new i = 0, len = strlen(string); i < len; i++)
	{
	    if(isNumber(string, i) && cnt == -1)
		{
		    format(tmps, 2, string[i]);
		    strcat(str, tmps);
		    cnt = i;
		}
		if(isNumber(string, i) && cnt == i-1)
		{
		    format(tmps, 2, string[i]);
		    strcat(str, tmps);
		    cnt = i;
		}
	}
	new intt = -1;
	intt = strval(str);
	return intt;
}

PUBLIC:OffUninvite(playerid, str[])
{
	if(cache_num_rows())
	{
		new fid;
		cache_get_value_name_int(0, "Faction", fid);
		if(fid == pData[playerid][Faction])
		{
		    new mQuery[256];
		    mysql_format(MySQL, mQuery, 256, "UPDATE `playerdata` SET `Faction` = -1, `Tier` = -1, `Rank` = 'None' WHERE `Username` = '%e'", str);
		    mysql_tquery(MySQL, mQuery);
			SendClientSuccess(playerid, "Successfully uninvited that retard.");
		}
		else SendClientError(playerid, "Player is not of your faction.");
	}
	else SendClientError(playerid, "Player doesnt exist.");
}

InviteToFac(pid, fid, playerid)
{
	new mstr[256];
	if(pData[pid][Faction] != -1) return SendClientError(playerid, "Player is already in another faction.");
	SetPVarInt(pid, "InvitedTo", fid+1); // escape 0
	SetPVarInt(pid, "InvitedBy", playerid);
	format(mstr, 256, "[F-Invite] %s has invited you to %s. /joinfaction to join %s.", NoUnderscore(pData[playerid][Username]), fData[fid][fName], fData[fid][fName]);
	SendClientMessage(pid, 0xB8860BAA, mstr);
	return 1;
}


SendFactionMessage(fid, str[])
{
	new mstr[256];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(pData[i][Faction] == fid)
	        {
				format(mstr, 256, "(( [%s] - %s ))", fData[fid][fName], str);
	            SendClientMessage(i, 0xB8860BAA, mstr);
	        }
	    }
	}
}

Uninvite(playerid)
{
	new mstr[256];
    format(mstr, 256, "%s has been uninvited from the faction.", NoUnderscore(pData[playerid][Username]));
	SendFactionMessage(pData[playerid][Faction], mstr);
	pData[playerid][Faction] = -1;
	pData[playerid][fTier] = -1;
	format(pData[playerid][fRank], 10, "None");
}


isNumber(c[], index)
{
	switch(c[index])
	{
	    case '0' .. '9': return true;
	    default: return false;
	}
	return false;
}

IsNumeric(const str[])
{
    for(new i, len = strlen(str); i < len; i++)
    {
        if(!('0' <= str[i] <= '9')) return false;
    }
    return true;
}
GetPlayerID(const pName[])
{
    new playerid = INVALID_PLAYER_ID;
    sscanf(pName,"u",playerid);
    return playerid;
}

IsVehicleOccupied(vehicleid)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerInVehicle(i,vehicleid))
        return 1;
    }
    return 0;
}
GetName(playerid)
{
    new
        name[24];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
GetPName(playerid)
{
	new pname[24];
	GetPlayerName(playerid, pname, 24);
	return pname;
}

GetPIp(playerid)
{
	new pip[16];
	GetPlayerIp(playerid, pip, 16);
	return pip;
}

KickPlayer(playerid)
{
	SetTimerEx("tKickPlayer", 1000, false, "i", playerid);
	return 1;
}

PUBLIC:tKickPlayer(playerid)
{
    Kick(playerid);
}

SendClientError(playerid, const msg[])
{
	new dstr[374];
	format(dstr, sizeof(dstr), "[Error] %s", msg);
	return SendClientMessage(playerid, COLOR_RED, dstr);
}

SendClientSuccess(playerid, const msg[])
{
	new dstr[374];
	format(dstr, sizeof(dstr), "[Success] %s", msg);
	return SendClientMessage(playerid, COLOR_SUCCESS, dstr);
}

stock SendClientNotice(playerid, const msg[])
{
	new dstr[374];
	format(dstr, sizeof(dstr), ""CLIGHTBLUE"[Notice] "CWHITE"%s", msg);
	return SendClientMessage(playerid, 0xFFFFFFFF, dstr);
}

SendMessageToAdmins(const msg[])
{
	new dstr[374];
	format(dstr, sizeof(dstr), "[ADMIN] %s", msg);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(pData[i][Admin] || IsPlayerAdmin(i)) SendClientMessage(i, COLOR_ADMINCHAT, dstr);
	    }
	}
}

SendClientUsage(playerid, const msg[])
{
	new dstr[374];
	format(dstr, sizeof(dstr), "[Usage] %s", msg);
	return SendClientMessage(playerid, COLOR_GREY, dstr);
}

stock SendClientMessageToTeam(team, clr, const str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(pData[i][Team] == team)
			{
				SendClientMessage(i, clr, str);
			}
		}
	}
}

SetPlayerPosEx(playerid, Float:tp_x, Float:tp_y, Float:tp_z, tp_interior = 0, tp_virtualworld = 0, bool:freeZe = true)
{
	SetPlayerInterior(playerid, tp_interior);
	SetPlayerVirtualWorld(playerid, tp_virtualworld);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), tp_x, tp_y, tp_z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),  tp_interior);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), tp_virtualworld);
		return 1;
	}
	else
	{
		SetPlayerPos(playerid, tp_x, tp_y, tp_z);
		if(freeZe == true)
		{
			TogglePlayerControllable(playerid, false);
			SetTimerEx("Unfreeze", 500, false, "d", playerid);
		}
		return 1;
	}
}

/*function:Unfreeze(plr)
{
	TogglePlayerControllable(plr, true);
}*/


GetPlayerFactionType(playerid)
{
	if(pData[playerid][Faction] == -1) return FACTION_CIV;
	else return fData[pData[playerid][Faction]][fType];
}

GetPlayerMoneyEx(playerid)
{
	return pData[playerid][Money];
}

GivePlayerMoneyEx(playerid, amount)
{
	GivePlayerMoney(playerid, amount);
	pData[playerid][Money] += amount;
}

GetUnusedVehicleID()
{
	for(new c = 0; c < MAX_VEHICLES; c++)
	{
	    if(vData[c][vActive] != 1) return c;
	}
	return INVALID_VEHICLE_ID;
}

/*bool:IsVehicleBoat(carid)
{
	switch(GetVehicleModel(carid))
	{
	    case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return true;
	    default: return false;
	}
	return false;
}*/

DoesVehicleHaveLock(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 448, 461, 462, 463, 468, 471, 481, 509, 510, 521, 522, 523, 581, 586, 424, 457, 430, 431, 539, 568, 571, 572: return 0;
		default: return 1;
	}
	return 0;
}

GetDistanceBetweenPlayers(playerid,playerid2) //By Slick (Edited by Sacky)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	GetPlayerPos(playerid2,x2,y2,z2);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(tmpdis);
}


DoesVehicleHaveEngine(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 481, 509, 510: return 0;
		default: return 1;
	}
	return 0;
}

/*bool:IsVehiclePlane(carid)
{
	switch(GetVehicleModel(carid))
	{
	    case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return true;
	    default: return false;
	}
	return false;
}*/

CheckIfVehicleUsesFuel(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 417, 425, 430, 435, 441, 446, 447, 449, 450, 452, 453, 454, 457, 460, 464, 465, 469, 472, 473, 476, 481, 484, 487, 488, 493, 497, 501, 509, 510, 511, 512, 513, 519, 520, 537, 538, 548, 553, 563, 564, 571, 577, 584, 591, 592, 593, 594, 595, 606, 607, 608, 610, 611: return 0;
		default: return 0;
	}
	return 0;
}


stock SetVehicleEngineOn(carid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(carid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
}

stock SetVehicleEngineOff(carid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	SetVehicleParamsEx(carid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
}

stock GetEngineStatus(carid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	return engine;
}

GetBootStatus(carid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	return boot;
}

LockVehicle(playerid, carid)
{
	for(new i = 0; i < MAX_PLAYERS; i++) SetVehicleParamsForPlayer(carid, i, 0, 1);
	vData[FindVehicleID(carid)][vLocked] = true;
	vData[FindVehicleID(carid)][vLockedBy] = playerid;
	return 1;
}

UnlockVehicle(carid)
{
	for(new i = 0; i < MAX_PLAYERS; i++) SetVehicleParamsForPlayer(carid, i, 0, 0);
    vData[FindVehicleID(carid)][vLocked] = false;
	vData[FindVehicleID(carid)][vLockedBy] = -1;
}

FindVehicleID(carid) // get's the ID of the vehicle from the carid
{
	for(new v = 0; v < MAX_VEHICLES; v++)
	{
	    if(vData[v][vActive] != 1) continue;
		if(carid == vData[v][vID]) return v;
	}
	return INVALID_VEHICLE_ID;
}

GetModelIDFromName(vehname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleName[i], vehname, true) != -1 ) return i + 400;
	}
	return -1;
}

Up(playerid)
{
	new Float:PosX, Float:PosY, Float:PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	SetPlayerPos(playerid, PosX, PosY, PosZ+3);
}

GivePlayerWeaponEx(playerid, weaponid, ammoo)
{
	GivePlayerWeapon(playerid, weaponid, ammoo);
	return 1;
}

IsPlayerNearAnyVehicle(playerid, Float:mRange = 3.0)
{
	new yes = -1, Float:tmpx, Float:tmpy, Float:tmpz;
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(vData[i][vActive] != 1) continue;
	    GetVehiclePos(vData[i][vID], tmpx, tmpy, tmpz);
	    if(IsPlayerInRangeOfPoint(playerid, mRange, tmpx, tmpy, tmpz))
	    {
	        yes = vData[i][vID];
			break;
	    }
	}
	return yes;
}

GetAdminLevel(playerid)
{
	return pData[playerid][Admin];
}

/*
HectorTD(playerid)
{
    Speedo_Dynamic_Fuel[playerid][0] = CreatePlayerTextDraw(playerid,631.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][0], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][0], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][0], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][0], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][0], 1);

	Speedo_Dynamic_Fuel[playerid][1] = CreatePlayerTextDraw(playerid,627.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][1], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][1], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][1], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][1], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][1], 1);

	Speedo_Dynamic_Fuel[playerid][2] = CreatePlayerTextDraw(playerid,623.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][2], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][2], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][2], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][2], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][2], 1);

	Speedo_Dynamic_Fuel[playerid][3] = CreatePlayerTextDraw(playerid,619.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][3], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][3], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][3], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][3], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][3], 1);

	Speedo_Dynamic_Fuel[playerid][4] = CreatePlayerTextDraw(playerid,615.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][4], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][4], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][4], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][4], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][4], 1);

	Speedo_Dynamic_Fuel[playerid][5] = CreatePlayerTextDraw(playerid,611.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][5], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][5], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][5], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][5], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][5], 1);

	Speedo_Dynamic_Fuel[playerid][6] = CreatePlayerTextDraw(playerid,607.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][6], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][6], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][6], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][6], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][6], 1);

	Speedo_Dynamic_Fuel[playerid][7] = CreatePlayerTextDraw(playerid,603.000000, 398.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][7], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][7], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][7], 0.079999, 1.899999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][7], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][7], 1);

	Speedo_Dynamic_Fuel[playerid][8] = CreatePlayerTextDraw(playerid,599.000000, 397.500000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][8], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][8], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][8], 0.079999, 2.000000);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][8], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][8], 1);

	Speedo_Dynamic_Fuel[playerid][9] = CreatePlayerTextDraw(playerid,595.000000, 396.500000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][9], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][9], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][9], 0.079999, 2.099999);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][9], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][9], 1);

	Speedo_Dynamic_Fuel[playerid][10] = CreatePlayerTextDraw(playerid,591.000000, 395.700012, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][10], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][10], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][10], 0.079999, 2.200000);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][10], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][10], 1);

	Speedo_Dynamic_Fuel[playerid][11] = CreatePlayerTextDraw(playerid,587.000000, 395.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][11], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][11], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][11], 0.079999, 2.299998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][11], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][11], 1);

	Speedo_Dynamic_Fuel[playerid][12] = CreatePlayerTextDraw(playerid,583.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][12], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][12], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][12], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][12], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][12], 1);

	Speedo_Dynamic_Fuel[playerid][13] = CreatePlayerTextDraw(playerid,579.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][13], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][13], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][13], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][13], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][13], 1);

	Speedo_Dynamic_Fuel[playerid][14] = CreatePlayerTextDraw(playerid,575.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][14], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][14], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][14], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][14], -190703361);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][14], 1);

	Speedo_Dynamic_Fuel[playerid][15] = CreatePlayerTextDraw(playerid,571.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][15], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][15], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][15], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][15], -2004384257);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][15], 1);

	Speedo_Dynamic_Fuel[playerid][16] = CreatePlayerTextDraw(playerid,567.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][16], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][16], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][16], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][16], -2004384257);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][16], 1);

	Speedo_Dynamic_Fuel[playerid][17] = CreatePlayerTextDraw(playerid,563.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][17], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][17], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][17], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][17], -2004384257);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][17], 1);

	Speedo_Dynamic_Fuel[playerid][18] = CreatePlayerTextDraw(playerid,559.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][18], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][18], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][18], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][18], -2004384257);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][18], 1);

	Speedo_Dynamic_Fuel[playerid][19] = CreatePlayerTextDraw(playerid,555.000000, 394.000000, "�");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel[playerid][19], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel[playerid][19], 3);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel[playerid][19], 0.079999, 2.399998);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel[playerid][19], -2004384257);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel[playerid][19], 1);

	Speedo_Dynamic_Speed[playerid] = CreatePlayerTextDraw(playerid, 589.999572, 371.0, "   337");
	PlayerTextDrawLetterSize(playerid, Speedo_Dynamic_Speed[playerid], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, Speedo_Dynamic_Speed[playerid], -1);
	PlayerTextDrawSetOutline(playerid, Speedo_Dynamic_Speed[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Speedo_Dynamic_Speed[playerid], 255);
	PlayerTextDrawFont(playerid, Speedo_Dynamic_Speed[playerid], 2);
	PlayerTextDrawSetProportional(playerid, Speedo_Dynamic_Speed[playerid], 1);
	PlayerTextDrawSetSelectable(playerid,Speedo_Dynamic_Speed[playerid], 0);

	Speedo_Dynamic_Fuel_Bar[playerid] = CreatePlayerTextDraw(playerid,553.999572, 371.000000, "F: 100%");
	PlayerTextDrawBackgroundColor(playerid,Speedo_Dynamic_Fuel_Bar[playerid], 255);
	PlayerTextDrawFont(playerid,Speedo_Dynamic_Fuel_Bar[playerid], 2);
	PlayerTextDrawLetterSize(playerid,Speedo_Dynamic_Fuel_Bar[playerid], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid,Speedo_Dynamic_Fuel_Bar[playerid], -1);
	PlayerTextDrawSetOutline(playerid,Speedo_Dynamic_Fuel_Bar[playerid], 1);
	PlayerTextDrawSetProportional(playerid,Speedo_Dynamic_Fuel_Bar[playerid], 1);
	PlayerTextDrawSetSelectable(playerid,Speedo_Dynamic_Fuel_Bar[playerid], 0);

	Speedo_Dynamic_SpeedM[playerid][1] = CreatePlayerTextDraw(playerid, 526.000305, 362.853393, "box");
	PlayerTextDrawLetterSize(playerid, Speedo_Dynamic_SpeedM[playerid][1], 0.000000, 6.280001);
	PlayerTextDrawTextSize(playerid, Speedo_Dynamic_SpeedM[playerid][1], 660.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, Speedo_Dynamic_SpeedM[playerid][1], 1);
	PlayerTextDrawColor(playerid, Speedo_Dynamic_SpeedM[playerid][1], -16776961);
	PlayerTextDrawUseBox(playerid, Speedo_Dynamic_SpeedM[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, Speedo_Dynamic_SpeedM[playerid][1], 85);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, Speedo_Dynamic_SpeedM[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, Speedo_Dynamic_SpeedM[playerid][1], 255);
	PlayerTextDrawFont(playerid, Speedo_Dynamic_SpeedM[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, Speedo_Dynamic_SpeedM[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][1], 0);

	Speedo_Dynamic_SpeedM[playerid][2] = CreatePlayerTextDraw(playerid, 508.200195, 314.040252, "");//528
	PlayerTextDrawLetterSize(playerid, Speedo_Dynamic_SpeedM[playerid][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Speedo_Dynamic_SpeedM[playerid][2], 58.000000, 79.000000);
	PlayerTextDrawAlignment(playerid, Speedo_Dynamic_SpeedM[playerid][2], 1);
	PlayerTextDrawColor(playerid, Speedo_Dynamic_SpeedM[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, Speedo_Dynamic_SpeedM[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, Speedo_Dynamic_SpeedM[playerid][2], -256);
	PlayerTextDrawFont(playerid, Speedo_Dynamic_SpeedM[playerid][2], 5);
	PlayerTextDrawSetProportional(playerid, Speedo_Dynamic_SpeedM[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, Speedo_Dynamic_SpeedM[playerid][2], 411);
	PlayerTextDrawSetPreviewRot(playerid, Speedo_Dynamic_SpeedM[playerid][2], 0.000000, 0.000000, -30.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, Speedo_Dynamic_SpeedM[playerid][2], 0, 0);

	Speedo_Dynamic_SpeedM[playerid][3] = CreatePlayerTextDraw(playerid, 561.999938, 350.160064, "inFERNUS");//581
	PlayerTextDrawLetterSize(playerid, Speedo_Dynamic_SpeedM[playerid][3], 0.293998, 1.252799);
	PlayerTextDrawAlignment(playerid, Speedo_Dynamic_SpeedM[playerid][3], 1);
	PlayerTextDrawColor(playerid, Speedo_Dynamic_SpeedM[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, Speedo_Dynamic_SpeedM[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, Speedo_Dynamic_SpeedM[playerid][3], 255);
	PlayerTextDrawFont(playerid, Speedo_Dynamic_SpeedM[playerid][3], 3);
	PlayerTextDrawSetProportional(playerid, Speedo_Dynamic_SpeedM[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][3], 0);

	Speedo_Dynamic_SpeedM[playerid][4] = CreatePlayerTextDraw(playerid, 521.000061, 387.960174, "");
	PlayerTextDrawLetterSize(playerid, Speedo_Dynamic_SpeedM[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Speedo_Dynamic_SpeedM[playerid][4], 35.000000, 29.000000);
	PlayerTextDrawAlignment(playerid, Speedo_Dynamic_SpeedM[playerid][4], 1);
	PlayerTextDrawColor(playerid, Speedo_Dynamic_SpeedM[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, Speedo_Dynamic_SpeedM[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, Speedo_Dynamic_SpeedM[playerid][4], -256);
	PlayerTextDrawFont(playerid, Speedo_Dynamic_SpeedM[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, Speedo_Dynamic_SpeedM[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, Speedo_Dynamic_SpeedM[playerid][4], 1650);
	PlayerTextDrawSetPreviewRot(playerid, Speedo_Dynamic_SpeedM[playerid][4], 0.000000, 0.000000, 0.000000, 1.000000);

	Speedo_Dynamic_SpeedM[playerid][5] = CreatePlayerTextDraw(playerid, 526.200134, 366.306671, "");
	PlayerTextDrawLetterSize(playerid, Speedo_Dynamic_SpeedM[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Speedo_Dynamic_SpeedM[playerid][5], 23.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, Speedo_Dynamic_SpeedM[playerid][5], 1);
	PlayerTextDrawColor(playerid, Speedo_Dynamic_SpeedM[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, Speedo_Dynamic_SpeedM[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, Speedo_Dynamic_SpeedM[playerid][5], -256);
	PlayerTextDrawFont(playerid, Speedo_Dynamic_SpeedM[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, Speedo_Dynamic_SpeedM[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, Speedo_Dynamic_SpeedM[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, Speedo_Dynamic_SpeedM[playerid][5], 1075);
	PlayerTextDrawSetPreviewRot(playerid, Speedo_Dynamic_SpeedM[playerid][5], 0.000000, 0.000000, 90.000000, 1.000000);
}*/

RemoveBuildings(playerid)
{
    RemoveBuildingForPlayer(playerid, 13026, 2261.4219, -71.8125, 25.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 781, 2253.7734, -79.5313, 25.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 12959, 2261.4219, -71.8125, 25.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 1688, 2269.0938, -68.6094, 31.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1691, 2262.2031, -69.4297, 30.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 956, 2271.7266, -76.4609, 25.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 781, 2259.3906, -79.4141, 25.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 781, 2266.0859, -79.4141, 25.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 2274.6641, -69.8438, 26.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2285.0234, -89.4453, 29.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 669, 2248.6250, -65.6797, 25.8125, 0.25);
}



LoadMaps()
{

//pd by Menace. (https://forum.sa-mp.com/member.php?u=10323)


	CreateDynamicObject(1223, 621.70001, -1425.50000, 12.90000,   0.00000, 0.00000, 356.00000);
	CreateDynamicObject(1223, 621.70001, -1443.69995, 13.30000,   0.00000, 0.00000, 356.00000);
	CreateDynamicObject(1223, 621.70001, -1471.59998, 13.60000,   0.00000, 0.00000, 356.00000);
	CreateDynamicObject(1223, 622.00000, -1493.30005, 13.80000,   0.00000, 0.00000, 356.00000);
	CreateDynamicObject(8406, 617.20001, -1508.30005, 19.50000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(11102, 607.90002, -1488.69995, 15.90000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4639, 619.50000, -1524.69995, 15.80000,   0.00000, 0.00000, 182.00000);
	CreateDynamicObject(1223, 612.79999, -1411.50000, 12.60000,   0.00000, 0.00000, 96.00000);
	CreateDynamicObject(1223, 600.00000, -1412.80005, 12.60000,   0.00000, 0.00000, 98.00000);
	CreateDynamicObject(1223, 587.50000, -1414.40002, 12.80000,   0.00000, 0.00000, 94.00000);
	CreateDynamicObject(1257, 643.90002, -1425.00000, 14.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 643.79999, -1486.00000, 15.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(996, 682.09998, -1410.69995, 13.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(996, 673.79999, -1410.69995, 13.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(996, 665.50000, -1410.69995, 13.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(996, 657.20001, -1410.69995, 13.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(996, 648.79999, -1410.69995, 13.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(996, 642.59998, -1439.69995, 14.00000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.50000, -1458.19995, 14.20000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.50000, -1466.59998, 14.30000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.59998, -1513.50000, 14.80000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.50000, -1475.00000, 14.40000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.70001, -1505.19995, 14.70000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(997, 642.70001, -1489.50000, 13.80000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.50000, -1522.90002, 14.90000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.40002, -1531.30005, 15.00000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(996, 642.40002, -1539.69995, 15.10000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(997, 642.90002, -1552.59998, 14.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(997, 642.59998, -1547.09998, 14.60000,   0.00000, 0.00000, 268.00000);
	CreateDynamicObject(1215, 695.29999, -1421.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 695.20001, -1419.50000, 14.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 695.09998, -1417.50000, 13.60000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 695.00000, -1415.80005, 13.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 681.40002, -1410.90002, 15.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 673.20001, -1410.90002, 15.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 664.90002, -1410.90002, 15.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 656.70001, -1410.90002, 15.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.70001, -1447.30005, 16.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.70001, -1465.50000, 16.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.79999, -1474.09998, 16.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.59998, -1482.69995, 16.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.90002, -1493.00000, 16.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.79999, -1504.40002, 16.60000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.79999, -1513.00000, 16.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.70001, -1530.50000, 16.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.70001, -1538.90002, 16.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 642.70001, -1547.09998, 17.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1232, 646.40002, -1552.69995, 17.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 651.50000, -1430.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 649.29999, -1430.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 647.50000, -1430.50000, 13.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 651.50000, -1434.59998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 649.29999, -1434.59998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 647.50000, -1434.59998, 13.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 648.90002, -1447.50000, 14.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 647.59998, -1447.50000, 13.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 651.70001, -1457.00000, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 649.50000, -1456.69995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 647.59998, -1456.69995, 14.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 647.70001, -1494.80005, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 651.40002, -1503.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 649.50000, -1503.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 647.59998, -1503.50000, 14.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 662.50000, -1447.30005, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 657.20001, -1447.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 651.59998, -1447.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 655.70001, -1456.50000, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 662.50000, -1456.19995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.59998, -1446.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.40002, -1457.09998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 673.20001, -1446.69995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 681.00000, -1446.59998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 689.79999, -1446.69995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.40002, -1477.50000, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.40002, -1482.00000, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.29999, -1477.50000, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.40002, -1481.90002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.50000, -1493.90002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.29999, -1457.09998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 676.70001, -1457.09998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 685.20001, -1457.19995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.29999, -1494.00000, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.40002, -1504.40002, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.20001, -1504.30005, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.29999, -1524.69995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.50000, -1524.69995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.40002, -1529.00000, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.40002, -1529.19995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.29999, -1541.09998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 665.29999, -1541.09998, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 676.79999, -1541.19995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 683.79999, -1541.19995, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 647.29999, -1551.50000, 15.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 654.59998, -1551.30005, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 661.00000, -1551.30005, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 667.50000, -1551.30005, 14.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 674.00000, -1551.30005, 14.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 680.29999, -1551.30005, 14.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 687.09998, -1551.30005, 14.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3928, 599.70001, -1444.30005, 79.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3928, 600.00000, -1458.19995, 79.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10829, 600.29999, -1475.40002, 79.20000,   0.00000, 0.00000, 268.00000);
	CreateDynamicObject(1215, 589.20001, -1456.09998, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 608.79999, -1462.50000, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 608.90002, -1455.00000, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 609.00000, -1447.59998, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 609.00000, -1440.00000, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 609.00000, -1434.30005, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 599.29999, -1434.40002, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 589.20001, -1434.30005, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 589.09998, -1441.59998, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 589.09998, -1448.59998, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 589.29999, -1464.00000, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 592.90002, -1467.09998, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 599.09998, -1467.09998, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 606.79999, -1466.50000, 79.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.59998, -1417.50000, 15.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.59998, -1426.19995, 15.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.59998, -1435.40002, 15.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1443.30005, 15.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1452.90002, 15.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1460.69995, 16.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.29999, -1468.19995, 16.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1475.40002, 16.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1482.59998, 16.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1490.19995, 16.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1498.40002, 16.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.50000, -1505.59998, 16.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.40002, -1512.40002, 16.60000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1231, 632.40002, -1519.09998, 16.60000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1776, 611.59998, -1430.19995, 14.10000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1215, 616.90002, -1453.90002, 13.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 614.29999, -1453.90002, 13.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 611.50000, -1454.09998, 13.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 608.20001, -1454.19995, 13.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 617.20001, -1463.80005, 14.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 614.09998, -1463.80005, 14.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 611.09998, -1464.00000, 14.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 608.20001, -1464.00000, 14.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1281, 671.70001, -1453.80005, 14.70000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1281, 682.90002, -1453.80005, 14.70000,   0.00000, 0.00000, 268.00000);
	CreateDynamicObject(1432, 671.09998, -1449.40002, 13.90000,   0.00000, 0.00000, 14.00000);
	CreateDynamicObject(1432, 679.70001, -1452.00000, 13.90000,   0.00000, 0.00000, 26.00000);
	CreateDynamicObject(1432, 675.09998, -1451.80005, 13.90000,   0.00000, 0.00000, 338.00000);
	CreateDynamicObject(1432, 683.70001, -1449.40002, 13.90000,   0.00000, 0.00000, 336.00000);
	CreateDynamicObject(1340, 675.00000, -1447.40002, 15.00000,   0.00000, 0.00000, 268.00000);
	CreateDynamicObject(1341, 679.70001, -1447.19995, 14.90000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1342, 679.90002, -1457.30005, 14.90000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1346, 662.70001, -1446.00000, 15.20000,   0.00000, 0.00000, 92.00000);
	CreateDynamicObject(2946, 606.20001, -1460.40002, 13.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2946, 606.20001, -1457.30005, 13.40000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1256, 617.79999, -1475.90002, 14.30000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1256, 617.59998, -1468.69995, 14.20000,   0.00000, 0.00000, 179.99451);
	CreateDynamicObject(1256, 617.70001, -1442.30005, 13.90000,   0.00000, 0.00000, 179.99451);
	CreateDynamicObject(1256, 617.69922, -1450.09961, 14.00000,   0.00000, 0.00000, 179.99451);
	CreateDynamicObject(669, 2248.53174, -59.43650, 25.81250,   356.85840, 0.00000, 3.14159);
	CreateDynamicObject(8947, 2277.20459, -80.70600, 22.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8947, 2277.20459, -56.14960, 22.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8947, 2262.49487, -80.70530, 22.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8947, 2262.49487, -56.14960, 22.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8947, 2247.75757, -80.70530, 22.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8947, 2247.75757, -56.14960, 22.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16563, 2263.57983, -73.31253, 24.15050,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1408, 2993.61597, 824.43793, 26.05469,   3.14159, 0.00000, 1.57080);
	CreateDynamicObject(1408, 2280.57446, -63.38407, 26.05470,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1408, 2283.20190, -66.05656, 26.05470,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1408, 2283.17456, -71.27347, 26.05470,   0.00000, 0.00000, 89.76000);
	CreateDynamicObject(1408, 2283.20190, -66.05656, 26.05470,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1408, 2283.12183, -76.46398, 26.05470,   0.00000, 0.00000, 89.76000);
	CreateDynamicObject(1412, 2257.09839, -87.77620, 27.27480,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1412, 2259.74585, -79.87640, 27.27480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1412, 2259.74585, -85.13830, 27.27480,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1408, 2268.58813, -88.28468, 26.05470,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1408, 2273.77832, -88.27480, 26.05470,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18763, 2266.07886, -78.80090, 23.01910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18763, 2263.55176, -78.80090, 23.03910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18763, 2261.23096, -78.81181, 23.01910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18763, 2266.50391, -76.35650, 23.03910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18763, 2269.50659, -74.86430, 23.03910,   0.00000, 0.00000, -0.48000);
	CreateDynamicObject(18763, 2270.17480, -74.86210, 23.01910,   0.00000, 0.00000, -0.48000);
	CreateDynamicObject(1438, 2266.83838, -64.52057, 25.45313,   356.85840, 0.00000, -3.23334);
	CreateDynamicObject(1345, 2265.20459, -67.80330, 26.15690,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1345, 2265.20459, -65.36640, 26.15690,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18763, 2270.20435, -71.86260, 23.01910,   0.00000, 0.00000, -0.48000);
	CreateDynamicObject(18763, 2267.30396, -71.83750, 23.01910,   0.00000, 0.00000, -0.48000);
	CreateDynamicObject(18763, 2266.43823, -70.53267, 23.01910,   0.00000, 0.00000, -0.48000);
	CreateDynamicObject(18763, 2263.50684, -67.88272, 23.01910,   0.00000, 0.00000, -0.48000);
	CreateDynamicObject(18763, 2263.55957, -65.16400, 23.01910,   0.00000, 0.00000, -0.48000);
	CreateDynamicObject(637, 2270.54761, -89.16540, 25.52920,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(637, 2272.08691, -89.16580, 25.52920,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(638, 2260.21387, -78.84820, 26.21940,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(638, 2267.11133, -78.79493, 26.21944,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(638, 2272.19165, -73.36539, 26.13540,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1345, 2272.57666, -64.25191, 26.15690,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(638, 2269.57300, -76.77840, 26.13540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19364, 2255.92261, -87.81810, 24.31240,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19364, 2258.24976, -87.81980, 24.31340,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19364, 2259.76196, -86.15960, 24.31340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19364, 2259.76196, -82.95990, 24.31340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19364, 2259.76196, -79.86470, 24.31340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19364, 2259.76196, -76.75390, 24.31340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18553, 2257.24707, -71.06700, 26.33300,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(966, 2253.81641, -87.83654, 25.46308,   0.00000, 0.00000, 0.00000);
	print("PD MAP LOADED");

	// port
    CreateDynamicObject(4242, 618.99249, -2318.45337, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4242, 818.57019, -2318.52808, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4242, 220.76021, -2569.51904, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4242, 219.98364, -2318.44165, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4242, 619.05389, -2569.82617, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4242, 818.62408, -2569.79077, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4242, 419.49460, -2569.76050, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4242, 419.61255, -2318.36768, 5.99774,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7052, 519.17212, -2233.27905, 6.18175,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(7432, 469.09271, -2313.87183, 6.18180,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(7433, 439.10660, -2483.65503, 6.18180,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(7482, 528.95587, -2654.10352, 6.30000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8447, 797.95789, -2623.94336, 6.18180,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(7486, 728.17126, -2394.13184, 6.37061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7433, 259.92679, -2483.68677, 6.18000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(7482, 289.87650, -2433.82642, 6.25000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8472, 249.87440, -2284.01953, 6.12000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8510, 668.39526, -2604.05103, 6.28606,   0.00000, 0.00000, 90.11273);
	CreateDynamicObject(6117, 549.51392, -2524.31250, 6.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(6956, 579.10748, -2274.18481, 6.23550,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(7605, 618.87653, -2444.13599, 6.37060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8510, 826.18506, -2424.13867, 6.37050,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(7326, 716.96741, -2250.61572, 6.70500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(17613, 629.57343, -2213.78491, 6.70500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(5495, 863.15613, -2285.30957, 6.70500,   0.00000, 0.00000, 90.00000);
	print("PORT LOADED");

	//Transport
	tmpobjid = CreateObject(6959, 2428.088134, 126.688659, 25.582237, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2407.429199, 133.261825, 26.906970, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2407.429199, 136.441864, 26.906970, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2407.429199, 139.651870, 26.906970, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2407.429199, 142.831909, 26.906970, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2407.429199, 145.331802, 26.906970, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 133.261825, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 136.441864, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 139.651870, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 142.831909, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 145.331802, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 130.061828, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 126.871910, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2448.853027, 123.701950, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2437.636718, 146.846282, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2434.456542, 146.851821, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2431.246582, 146.857421, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2428.066650, 146.862976, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2425.566650, 146.867324, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2440.836669, 146.840698, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2444.026611, 146.835128, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2447.196533, 146.829605, 26.906970, 0.000007, 0.000015, 89.900009, 300.00);
	tmpobjid = CreateObject(19364, 2421.061523, 146.846282, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2417.881347, 146.851821, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2414.671386, 146.857421, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2411.491455, 146.862976, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2408.991455, 146.867324, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2424.261474, 146.840698, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2427.451416, 146.835128, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2430.621337, 146.829605, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2437.636718, 106.746444, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2434.456542, 106.751983, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2431.246582, 106.757583, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2428.066650, 106.763137, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2425.566650, 106.767486, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2440.836669, 106.740859, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2444.026611, 106.735290, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2447.196533, 106.729766, 26.906970, 0.000015, 0.000015, 89.899986, 300.00);
	tmpobjid = CreateObject(19364, 2421.061523, 106.746444, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2417.881347, 106.751983, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2414.671386, 106.757583, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2411.491455, 106.763137, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2410.551513, 106.764747, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2424.261474, 106.740859, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2427.451416, 106.735290, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2430.621337, 106.729766, 26.906970, 0.000022, 0.000015, 89.899963, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 118.061759, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 121.241798, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 124.451805, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 127.631843, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 130.131744, 26.906970, 0.000000, 0.000007, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 108.301712, 26.906970, 0.000000, 0.000015, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 111.481750, 26.906970, 0.000000, 0.000015, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 114.691757, 26.906970, 0.000000, 0.000015, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 117.871795, 26.906970, 0.000000, 0.000015, 0.000000, 300.00);
	tmpobjid = CreateObject(19364, 2408.970214, 120.371696, 26.906970, 0.000000, 0.000015, 0.000000, 300.00);
	tmpobjid = CreateObject(10183, 2428.150146, 142.807113, 25.550987, 0.000000, 0.000000, 45.499992, 300.00);
	tmpobjid = CreateObject(1233, 2448.948730, 121.433662, 26.899753, 0.000000, 0.000000, 94.100006, 300.00);
	tmpobjid = CreateObject(923, 2448.116699, 123.683746, 26.443620, 0.000000, 0.000000, -88.099945, 300.00);
	tmpobjid = CreateObject(2973, 2446.855957, 126.467124, 25.498094, 0.000000, 0.000000, -26.600000, 300.00);
	tmpobjid = CreateObject(1458, 2440.058837, 108.002784, 25.878744, 0.000000, 0.000000, 94.299980, 300.00);
	tmpobjid = CreateObject(922, 2434.582275, 107.489913, 26.451068, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(8407, 2447.432128, 107.857208, 26.906961, 0.000000, 0.000000, 0.000000, 300.00);
	tmpobjid = CreateObject(16001, 2411.519531, 112.478385, 25.550987, 0.000000, 0.000000, -89.999855, 300.00);
	print("TRANSPORT LOADED");
}


