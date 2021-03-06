private ["_veh3","_veh2","_veh","_post","_time","_wp1","_tg1wp1","_posPl","_class","_random","_unitrate","_tg1","_tank","_header","_Lna","_Tid","_marS","_size","_start2","_st2","_timer","_locationA","_uCar","_VarVEH","_ALLunits","_VEHs","_INFgroups","_VEHgroups","_marks","_B","_nn","_roads","_RedGuardPs","_FrGuardPs","_RedCamps","_FrCamps","_tA","_text","_V","_classes","_group","_l","_nul","_ran","_ordercode","_ker","_n","_C","_Zcol","_st","_star","_classs","_F","_E","_G","_num","_mP","_ResultColor","_A","_roadA","_tP","_type","_net","_net2","_net3","_dist","_mar5","_data","_desc"];

_VEHgroups = [];
_INFgroups = [];
_VEHs = [];
_ALLunits = [];
_marks = [];
{if (getmarkercolor _x == "ColorGreen" || {getmarkercolor _x == "ColorBlue"}) then {_marks = _marks + [_x];};} foreach (PierMarkers + StoMarkers + PowMarkers + FacMarkers + AmbientZonesN);

if (count _marks < 2) exitWith {};
_A = getmarkerpos (_marks call RETURNRANDOM);
_B = getmarkerpos (_marks call RETURNRANDOM);
while {_A distance _B < 100} do {_B = getmarkerpos (_marks call RETURNRANDOM); sleep 1;};
_C = [((_A select 0)+(_B select 0))*0.5,((_A select 1)+(_B select 1))*0.5,0];
_nn = 200;
_roads = (_C nearRoads _nn);
while {count _roads == 0} do {_nn = _nn + 100; _roads = (_C nearRoads _nn);sleep 1;};

//INIT
_VarVEH = (ARMEDVEHICLES select 1)+(ARMEDTANKS select 1);
_uCar =[ENEMYC1,ENEMYC2,ENEMYC3] call RETURNRANDOM;
//_marrr = (_this select 0);
_roadA = (_roads call RETURNRANDOM);
_locationA = getposATL _roadA;

_st2 = [_locationA, 150,"(1 - forest) * (1 - sea) * (1 - houses)",1] CALL FUNKTIO_POS;
_tP = (_st2 select 0) select 0;
_type = (ARMEDSUPPORT select 2) call RETURNRANDOM;
_veh = createVehicle [_type, _tP, [], 0, "NONE"];
_veh setdir (random 360);
_veh setvariable ["AmCrate",1];
_net = createVehicle ["CamoNet_INDP_big_F", _tP, [], 0, "NONE"];
_net allowdamage false;
_net setdir (random 360);

_st2 = [_locationA, 150,"(1 - forest) * (1 - sea) * (1 - houses)",1] CALL FUNKTIO_POS;
_tP = (_st2 select 0) select 0;
_type = (ARMEDSUPPORT select 2) call RETURNRANDOM;
_veh2 = createVehicle [_type, _tP, [], 0, "NONE"];
_veh2 setdir (random 360);
_veh2 setvariable ["AmCrate",1];
_net2 = createVehicle ["CamoNet_INDP_big_F", _tP, [], 0, "NONE"];
_net2 allowdamage false;
_net2 setdir (random 360);

_st2 = [_locationA, 150,"(1 - forest) * (1 - sea) * (1 - houses)",1] CALL FUNKTIO_POS;
_tP = (_st2 select 0) select 0;
_type = (ARMEDSUPPORT select 2) call RETURNRANDOM;
_veh3 = createVehicle [_type, _tP, [], 0, "NONE"];
_veh3 setdir (random 360);
_veh3 setvariable ["AmCrate",1];
_net3 = createVehicle ["CamoNet_INDP_big_F", _tP, [], 0, "NONE"];
_net3 allowdamage false;
_net3 setdir (random 360);


_timer = time + (180 + (random 500));
_dist = 100 + (random 250);
_st2 = [_locationA, 1200,"(1 - forest) * (1 - sea) * (1 - houses)",1] CALL FUNKTIO_POS;
_start2 = (_st2 select 0) select 0;
_size = 1200;
while {{_start2 distance _x < 500} count VarBlackListE > 0 || {{_start2 distance _x < 500} count VarBlackListF > 0} || {{_x distance _start2 < 900} count ([] CALL AllPf) > 0} || {_start2 distance _locationA < 900}} do {
sleep 1;
_st2 = [_locationA, _size,"(1 - forest) * (1 - sea) * (1 - houses)",1] CALL FUNKTIO_POS;
_start2 = (_st2 select 0) select 0;
_size = _size + 50;
};
_marS = format ["LINEmar%1",NUMM];
NUMM=NUMM+1;
//_mar5 = [_marS,_locationA,"Select",[0.9,0.9],"ColorPink","Defend Supply Road"] CALL FUNKTIO_CREATEMARKER;
[] SPAWN {sleep 20; "Look for map, where the help is needed." SPAWN HINTSAOK;};
_data = ["EXPECTED BATTLE",_locationA,[],["INFI",["I_ATgroup","n_inf"],["I_Snipergroup","n_inf"]]] CALL BattleVirtualIntel;
_ResultColor = _data select 0;
_Tid = format ["TaskBat%1",NUMM];
_TidE = format ["TaskBatE%1",NUMM];
NUMM=NUMM+1;
_Lna = _locationA CALL NEARESTLOCATIONNAME;
_header = format ["Protect Supply Road near %1",_Lna];
_desc =("One of our supply lines is getting unwanted visitors. Is it protected enough, can we let our resources flow worse for some time or should we head there and kick some asses"+_ResultColor);
[
WEST, // Task owner(s)
_Tid, // Task ID (used when setting task state, destination or description later)
[_desc, _header, _header], // Task description
_locationA, // Task destination
"CREATED" // true to set task as current upon creation
] call BIS_fnc_taskCreate;
_header = format ["Damage Supply Road near %1",_Lna];
_desc =("NATO supply lines is about to get unwanted visitors. We could hurt their resources flowing less."+_ResultColor);
[
EAST, // Task owner(s)
_TidE, // Task ID (used when setting task state, destination or description later)
[_desc, _header, _header], // Task description
_locationA, // Task destination
"CREATED" // true to set task as current upon creation
] call BIS_fnc_taskCreate;

///////////RADIO CHAT
_RedCamps = 0;
_RedGuardPs =0;
_FrCamps = 0;
_FrGuardPs =0;
{if (_x distance _locationA < 1700) then {
if (getmarkercolor (_x getvariable "Gmark") == "ColorRed") then {_RedGuardPs = _RedGuardPs + 1;} else {_FrGuardPs = _FrGuardPs + 1;};
};} foreach GuardPosts;
{if ((getmarkerpos _x) distance _locationA < 1700) then {
if ((getmarkercolor _x) == "ColorRed") then {_RedCamps = _RedCamps + 1;} else {_FrCamps = _FrCamps + 1;};
};} foreach AmbientZonesN;
_text = ("Wolf, our supply near "+_Lna+" is about to get attacked by some enemy vehicles and infantry");
//_text = _text + (getText (configfile >> "CfgVehicles" >> _tank >> "displayName"));
if ("o_air" in (_data select 2) || {"o_armor" in (_data select 2)} || {"o_uav" in (_data select 2)}) then {
_text = _text + ". We also have reports of possible recent hostile";
_tA = [];
if ("o_air" in (_data select 2)) then {_tA = _tA + ["air_support"];};
if ("o_armor" in (_data select 2)) then {_tA = _tA + ["armor"];};
if ("o_uav" in (_data select 2)) then {_tA = _tA + ["UAV"];};
{_text = _text + " "+_x; _tA = _tA - [_x]; if (count _tA == 1) then {_text = _text + " and";}; if (count _tA > 1) then {_text = _text + ",";};} foreach _tA;
_text = _text + " presence in the AO that could support the attack";
};
if (_RedCamps > 1 || {_RedGuardPs > 0}) then {_text = _text + ". There is ";};
if (_RedCamps > 1) then {_text = _text + "another ";
if ((_RedCamps-1) != 1) then {_text = _text + (format ["%1",(_RedCamps-1)]);};
_text = _text + " camp";_V = (format ["N%1",(_RedCamps-1)]);if (_V != "N1") then {};};
if (_RedCamps == 2) then {};
if (_RedCamps > 2) then {_text = _text +"s";};
if (_RedCamps > 1 && {_RedGuardPs > 0}) then {_text = _text + " and ";};
if (_RedGuardPs > 0) then {if (_RedGuardPs != 1) then {_text = _text +(format ["%1",_RedGuardPs]);};
_text = _text +" guardpost";_V = (format ["N%1",_RedGuardPs]);if (_V != "N1") then {};};
if (_RedGuardPs == 1) then {};
if (_RedGuardPs > 1) then {_text = _text + "s"; };
if (_RedCamps > 1 || {_RedGuardPs > 0}) then {_text = _text + " with passive hostile activity nearby that could have unknown role";};
_text = _text + ".";
[[BaseR, _text],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
sleep 9;
_text = "";
if ("b_air" in (_data select 2) || {"b_armor" in (_data select 2)} || {"b_uav" in (_data select 2)} || {"n_plane" in (_data select 2)} || {"n_air" in (_data select 2)} || {"n_armor" in (_data select 2)} || {"n_uav" in (_data select 2)}) then {
_text = _text + " We have friendly";
_tA = [];
if ("b_air" in (_data select 2) || {"n_plane" in (_data select 2)} || {"n_air" in (_data select 2)}) then {_tA = _tA + ["air_support"];};
if ("b_armor" in (_data select 2) || {"n_armor" in (_data select 2)}) then {_tA = _tA + ["armor"];};
if ("b_uav" in (_data select 2) || {"n_uav" in (_data select 2)}) then {_tA = _tA + ["UAV"];};
{_text = _text + " "+_x; _tA = _tA - [_x]; if (count _tA == 1) then {_text = _text + " and";}; if (count _tA > 1) then {_text = _text + ",";};} foreach _tA;
_text = _text + " operating near the camp which should heading to protect the road.";
};
if (_FrCamps > 1 || {_FrGuardPs > 0}) then {_text = _text + "Nearby ";} else {_text = _text + " There is no nearby friendly camps or any guardposts covering the road.";};
if (_FrCamps > 1) then {if ((_FrCamps-1) != 1) then {_text = _text + (format ["%1",(_FrCamps-1)]);};
_text = _text + " camp";_V = (format ["N%1",(_FrCamps-1)]);if (_V != "N1") then {};};
if (_FrCamps == 2) then {};
if (_FrCamps > 2) then {_text = _text +"s";};
if (_FrCamps > 1 && {_FrGuardPs > 0}) then {_text = _text + " and ";};
if (_FrGuardPs > 0) then {if (_FrGuardPs != 1) then {_text = _text +(format ["%1",_FrGuardPs]);}; 
 _text = _text + " guardpost";_V = (format ["N%1",_FrGuardPs]);if (_V != "N1") then {};};
if (_FrGuardPs == 1) then {};
if (_FrGuardPs > 1) then {_text = _text + "s"; };
if (_FrCamps > 1 || {_FrGuardPs > 0}) then {_text = _text + " are called to send men join the battle.";};

_text = _text + " If you are available, any extra help there could keep our resources running. Out";
[[BaseR, _text],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
////////////////////////////


waitUntil {sleep 5; ({_x distance _locationA < 1400} count ([] CALL AllPf) > 0) || {_timer < time}};
if ({_x distance _locationA < 1400} count ([] CALL AllPf) > 0) then {


//CLOSE
_size = [0,0,0,0,0,1,1,2] call RETURNRANDOM;
for "_i" from 0 to _size do {
_tank = _VarVEH call BIS_fnc_selectRandom;	
_tg1 = [[(_start2 select 0)-30+(random 60),(_start2 select 1)-30+(random 60),0], 0, _tank, EAST] call BIS_fnc_spawnVehicle;
_VEHgroups = _VEHgroups + [(_tg1 select 2)];
_VEHs = _VEHs + [(_tg1 select 0)];
(_tg1 select 0) forcespeed 3;
_unitrate = [4,5];
_random = round(random (_unitrate select 1));
while {_random < (_unitrate select 0)} do {_random = round(random (_unitrate select 1));};
_classes = [];
while {_random > 0} do {_classes set [count _classes,_uCar call RETURNRANDOM];_random = _random - 1;};
_group = [[(_start2 select 0)+40,(_start2 select 1)+30,0], EAST, _classes,[],[],[0.4,0.7]] call SpawnGroupCustom;
_INFgroups = _INFgroups + [_group];
};
{_ALLunits = _ALLunits + (units _x);} foreach _VEHgroups + _INFgroups;
waitUntil {sleep 5; _timer < time || ({_x distance _locationA < _dist} count ([] CALL AllPf) > 0)};
if (random 1 < 0.3 && _size < 1) then {
_class = ["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_Heli_Light_02_F","O_UAV_02_F","O_UAV_02_F"]; 
_class = _class call RETURNRANDOM;	
_l = getposATL vehicle (([] CALL AllPf) call RETURNRANDOM);
_tg1 = [[(_l select 0)+2500,(_l select 1)+2500,50], 0, _class, EAST] call SPAWNVEHICLE;
_posPl = [(_l select 0) + 100 -(random 200), (_l select 1)+ 100 -(random 200), 0];
_tg1wp1= (_tg1 select 2) addWaypoint [_locationA, 0]; 
[(_tg1 select 2), 1] setWaypointBehaviour "AWARE";
[(_tg1 select 2), 1] setWaypointType "GUARD";
_nul = [(_tg1 select 2), [1541.39,5059.05,0],200] SPAWN FUNKTIO_MAD;
};
//BEGIN ATTACK
{
_tg1wp1= _x addWaypoint [_locationA, 0]; 
[_x, 1] setWaypointBehaviour "COMBAT";
} foreach _VEHgroups;
{
_wp1 = _x addWaypoint [_locationA, 0];
[_x, 1] setWaypointCombatMode "RED";
[_x, 1] setWaypointType "GUARD";
} foreach _INFgroups;
_time = time + 600;
_ran = ["STR_Sp8t5r2"] call BIS_fnc_selectRandom;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
_ker = (count _ALLunits)*0.2;
waitUntil {sleep 5; {alive _x && {!(fleeing _x)}} count _ALLunits < _ker || {_time < time}  ||  {alive _x && {_x distance _locationA < 30}} count _ALLunits >= _ker};

if ({alive _x && {_x distance _locationA < 30}} count _ALLunits >= _ker) then {
//END2
{
VehicleGroups set [count VehicleGroups,_x];
} foreach _VEHgroups;
{
CARS set [count CARS,_x];
_x setvariable ["EndS",1];
} foreach _VEHs;
{
Pgroups set [count Pgroups,_x];
} foreach _INFgroups;

[getMarkerPos _marrr,EAST] SPAWN ADDR;
_nul = [_Tid,"FAILED"] call BIS_fnc_taskSetState;
_nul = [_TidE,"SUCCEEDED"] call BIS_fnc_taskSetState;
[] SPAWN {SUPF = SUPF*0.5;sleep 600;SUPF = SUPF*2;};
if (([_locationA] CALL RETURNGUARDPOST) distance _locationA < 400) then {
_post = ([_locationA] CALL RETURNGUARDPOST); 
deletemarker (_post getvariable "Gmark");
deletevehicle _post;
};
_ran = ["STR_Sp8t5r4"] call BIS_fnc_selectRandom;
[["Enemy attack succeeded. Supply line is halted for some time",WEST],"HINTSAOK",nil,false] spawn BIS_fnc_MP;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;

//deletemarker _mar5;
} else {
//END C
{
VehicleGroups set [count VehicleGroups,_x];
} foreach _VEHgroups;
{
CARS set [count CARS,_x];
_x setvariable ["EndS",1];
} foreach _VEHs;
{
Pgroups set [count Pgroups,_x];
} foreach _INFgroups;
//_marrr setmarkercolor "ColorGreen";
[getMarkerPos _marrr,WEST] SPAWN ADDR;
_nul = [_Tid,"SUCCEEDED"] call BIS_fnc_taskSetState;
_nul = [_TidE,"FAILED"] call BIS_fnc_taskSetState;
//_nul = [] SPAWN {VarPG = VarPG - 1;sleep 900;VarPG = VarPG + 1;};
_ran = ["STR_Sp8t5r3"] call BIS_fnc_selectRandom;
[["Enemy attack didnt succeed",WEST],"HINTSAOK",nil,false] spawn BIS_fnc_MP;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
//deletemarker _mar5;
};

} else {
//FAR W T
_time = time + 600;
_ran = ["STR_Sp8t5r2"] call BIS_fnc_selectRandom;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
waitUntil {sleep 5; _time < time || {{_x distance _locationA < 1400} count ([] CALL AllPf) > 0}};
if ({_x distance _locationA < 1400} count ([] CALL AllPf) > 0) then {
//CLOSE
_size = [0,0,0,0,0,1,1,2] call RETURNRANDOM;
for "_i" from 0 to _size do {
_tank = _VarVEH call BIS_fnc_selectRandom;	
_tg1 = [[(_start2 select 0)-30+(random 60),(_start2 select 1)-30+(random 60),0], 0, _tank, EAST] call BIS_fnc_spawnVehicle;
_VEHgroups = _VEHgroups + [(_tg1 select 2)];
_VEHs = _VEHs + [(_tg1 select 0)];
(_tg1 select 0) forcespeed 3;
_unitrate = [4,5];
_random = round(random (_unitrate select 1));
while {_random < (_unitrate select 0)} do {_random = round(random (_unitrate select 1));};
_classes = [];
while {_random > 0} do {_classes set [count _classes,_uCar call RETURNRANDOM];_random = _random - 1;};
_group = [[(_start2 select 0)+40,(_start2 select 1)+30,0], EAST, _classes,[],[],[0.4,0.7]] call SpawnGroupCustom;
_INFgroups = _INFgroups + [_group];
};
{_ALLunits = _ALLunits + (units _x);} foreach _VEHgroups + _INFgroups;
if (random 1 < 0.3 && {_size < 1}) then {
_class = ["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_Heli_Light_02_F","O_UAV_02_F","O_UAV_02_F"]; 
_class = _class call RETURNRANDOM;	
_l = getposATL vehicle (([] CALL AllPf) call RETURNRANDOM);
_tg1 = [[(_l select 0)+2500,(_l select 1)+2500,50], 0, _class, EAST] call SPAWNVEHICLE;
_posPl = [(_l select 0) + 100 -(random 200), (_l select 1)+ 100 -(random 200), 0];
_tg1wp1= (_tg1 select 2) addWaypoint [_locationA, 0]; 
[(_tg1 select 2), 1] setWaypointBehaviour "AWARE";
[(_tg1 select 2), 1] setWaypointType "GUARD";
_nul = [(_tg1 select 2), [1541.39,5059.05,0],200] SPAWN FUNKTIO_MAD;
};
//BEGIN ATTACK
{
_tg1wp1= _x addWaypoint [_locationA, 0]; 
[_x, 1] setWaypointBehaviour "COMBAT";
} foreach _VEHgroups;
{
_wp1 = _x addWaypoint [_locationA, 0];
[_x, 1] setWaypointCombatMode "RED";
[_x, 1] setWaypointType "GUARD";
} foreach _INFgroups;
_ker = (count _ALLunits)*0.2;
waitUntil {sleep 5; {alive _x && {!(fleeing _x)}} count _ALLunits < _ker || {_time < time} || {alive _x && {_x distance _locationA < 30}} count _ALLunits >= _ker};
if ({alive _x && {_x distance _locationA < 30}} count _ALLunits >= _ker) then {
//END2
{
VehicleGroups set [count VehicleGroups,_x];
} foreach _VEHgroups;
{
CARS set [count CARS,_x];
_x setvariable ["EndS",1];
} foreach _VEHs;
{
Pgroups set [count Pgroups,_x];
} foreach _INFgroups;

[getMarkerPos _marrr,EAST] SPAWN ADDR;
_nul = [_Tid,"FAILED"] call BIS_fnc_taskSetState;
_nul = [_TidE,"SUCCEEDED"] call BIS_fnc_taskSetState;
[] SPAWN {SUPF = SUPF*0.5;sleep 600;SUPF = SUPF*2;};
if (([_locationA] CALL RETURNGUARDPOST) distance _locationA < 400) then {
_post = ([_locationA] CALL RETURNGUARDPOST); 
deletemarker (_post getvariable "Gmark");
deletevehicle _post;
};
_ran = ["STR_Sp8t5r4"] call BIS_fnc_selectRandom;
[["Enemy attack succeeded. Supply route is halted for some time",WEST],"HINTSAOK",nil,false] spawn BIS_fnc_MP;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;

//deletemarker _mar5;
} else {
//END C
{
VehicleGroups set [count VehicleGroups,_x];
} foreach _VEHgroups;
{
CARS set [count CARS,_x];
_x setvariable ["EndS",1];
} foreach _VEHs;
{
Pgroups set [count Pgroups,_x];
} foreach _INFgroups;
//_marrr setmarkercolor "ColorGreen";
//["ScoreAdded",["Enemy attack didnt succeed",10]] call bis_fnc_showNotification;
[getMarkerPos _marrr,WEST] SPAWN ADDR;
_nul = [_Tid,"SUCCEEDED"] call BIS_fnc_taskSetState;
_nul = [_TidE,"FAILED"] call BIS_fnc_taskSetState;
//_nul = [] SPAWN {VarPG = VarPG - 1;sleep 900;VarPG = VarPG + 1;};
_ran = ["STR_Sp8t5r3"] call BIS_fnc_selectRandom;
[["Enemy attack didnt succeed",WEST],"HINTSAOK",nil,false] spawn BIS_fnc_MP;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
//deletemarker _mar5;
};

} else {
//FAR W T
_num = 0.5;
_F = [];
_E = [];
_G = [];
_C = [];
_C = _C + ["INFI",["I_ATgroup","n_inf"],["I_Snipergroup","n_inf"]];
_size = [0,1,2] call RETURNRANDOM;
for "_i" from 0 to _size do {
_C = _C + ["INFR"];
_Zcol = "ColorRed";
_st = [_locationA, 400,"(1 - trees) * (1 - sea) * (1 - houses)"] CALL FUNKTIO_POS;
_star = (_st select 0) select 0;
_classs = if (_Zcol == "ColorRed") then {ARMEDVEHICLES select 1} else {ARMEDVEHICLES select 2};
_classs = [_classs call RETURNRANDOM,_classs call RETURNRANDOM];
if (_Zcol == "ColorRed") then {
_n = [_star, _Zcol,_classs] CALL AddVehicleZone;
} else {
_n = [_star, "ColorGreen",_classs,"n_armor"] CALL AddVehicleZone;
};
};
_mP = _locationA;
{
if (getmarkerpos _x distance _mP < 1700) then {
if (getmarkercolor _x != "ColorRed") then {_F = _F + [_x];} else {_E = _E + [_x];};
};
} foreach VEHZONES;
{
if (_x distance _mP < 1700) then {
_G = _G + [_x];
};
} foreach GuardPosts;

{
if (getmarkerpos _x distance _mP < 1700) then {
_C = _C + [_x];
};
} foreach AmbientZonesN;
_ResultColor = [_F,_E,_G,_C,"SUPPLY LINE BATTLE",_locationA] CALL BattleVirtualCamp;
/*
if (([_locationA] CALL RETURNGUARDPOST) distance _locationA < 400) then {
if (!isNil{([_locationA] CALL RETURNGUARDPOST) getvariable "StaticW"}) then {_num = 0.5 / (1+(count (([_locationA] CALL RETURNGUARDPOST) getvariable "StaticW"))*0.5);};
};
*/
if (_ResultColor == "ColorRed") then {
//["ScoreRemoved",["Enemy attack succeeded. Supply line is halted for some time",30]] call bis_fnc_showNotification;
_nul = [_Tid,"FAILED"] call BIS_fnc_taskSetState;
_nul = [_TidE,"SUCCEEDED"] call BIS_fnc_taskSetState;
//_marrr setmarkercolor "ColorYellow";
[] SPAWN {SUPF = SUPF*0.5;sleep 600;SUPF = SUPF*2;};

_ran = ["STR_Sp8t5r4"] call BIS_fnc_selectRandom;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
} else {
//_marrr setmarkercolor "ColorGreen";
//["ScoreAdded",["Enemy attack didnt succeed",10]] call bis_fnc_showNotification;
_nul = [_Tid,"SUCCEEDED"] call BIS_fnc_taskSetState;
_nul = [_TidE,"FAILED"] call BIS_fnc_taskSetState;
//_nul = [] SPAWN {VarPG = VarPG - 1;sleep 900;VarPG = VarPG + 1;};
_ran = ["STR_Sp8t5r3"] call BIS_fnc_selectRandom;
[[BaseR, localize _ran],"SAOKMULTIGCHAT",nil,false] spawn BIS_fnc_MP;
};
//deletemarker _mar5;
};



};

{
CARS = CARS + [_x];
_x setvariable ["AmCrate",nil];
} foreach [_veh, _veh2,_veh3];
{
deletevehicle _x;
} foreach [_net, _net2,_net3];

sleep 60;
_n = [_Tid] CALL BIS_fnc_deleteTask;
_n = [_TidE] CALL BIS_fnc_deleteTask;