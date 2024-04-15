# COD-BO3-ZOMBIES-PLAYER_ARMOR
The player armor in call of duty black ops 3 zombie mod tools
How to install:

put 2 GSC files in ROOT/usermaps/zm_yourmapname/scripts/zm

in your map zone file,add:

scriptparsetree,scripts/zm/_zm_armor.gsc

scriptparsetree,scripts/zm/_zm_armor.csc

In your map you can set a trigger to provide player armor e.g.

function give_armor()

{

	ArmorTrigger = GetEnt( "armor_trig", "targetname" );
 
	ArmorTrigger SetHintString( "Hold ^3[{+activate}]^7 for armor" );
 
	ArmorTrigger waittill( "trigger", player );
 
	player zm_armor::give_armor( 200 );
 
	ArmorTrigger delete();
 
}
