#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_player;
#using scripts\zm\_zm_playerhealth;

#using scripts\zm\_zm_utility;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\zm\_zm_weapons.gsh;

#namespace zm_armor;

REGISTER_SYSTEM_EX( "zm_armor", &__init__, &__main__, undefined )

#define PLAYER_MAX_ARMOR 500

function __init__()
{
    clientfield::register( "clientuimodel", "r6e.armor", VERSION_SHIP, GetMinBitCountForNum( PLAYER_MAX_ARMOR ), "int" );
}

function __main__()
{
    callback::on_spawned( &player_spawned );
    zm::register_player_damage_callback( &player_taken_damage );
}

function player_spawned()
{
    self.armorValue = 0;
}

function player_taken_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
    if( !should_player_armor_taken_damage( sMeansOfDeath ) ) return -1;

    if( isdefined( self.armorValue ) )
    {
        //BO4的护甲，完全抵挡僵尸的伤害
        /*
        if( self.armorValue - iDamage < 0 && self.armorValue != 0 ) //玩家剩余护甲已不足以抵挡本次伤害
        {
            iDamage -= self.armorValue;
            self.armorValue = 0;
            self notify( "player_armor_taken_damage" );
            self notify( "player_armor_depleted" ); //只有当玩家护甲还不为0的时候才发出这两个通知
            self clientfield::set_player_uimodel( "r6e.armor", self.armorValue );
            return iDamage;
        }
        else 
        {
            self.armorValue -= iDamage;
            iDamage = 0;
            self notify( "player_armor_taken_damage" );
            self clientfield::set_player_uimodel( "r6e.armor", self.armorValue );
            return 0;
        }
        */
        ///////////////////////////////////////////////////////////////////////////////
        //冷战的护甲，只能抵挡部分伤害
        if( self.armorValue <= 0 ) 
        {
            self.armorValue = 0;
            return -1;
        }
        self.armorValue -= 20;
       // iDamage *= 0.7;
        iDamage -= 20;
        self notify( "player_armor_taken_damage" );
        self clientfield::set_player_uimodel( "r6e.armor", self.armorValue );
        return iDamage;
    }
    return -1;
}

function should_player_armor_taken_damage( sMeansOfDeath )
{
    armor_should_taken_damage = true;

    switch( sMeansOfDeath )
    {
        case "MOD_CRUSH":
        case "MOD_TELEFRAG":
        case "MOD_SUICIDE":
        case "MOD_DROWN":
        case "MOD_HIT_BY_OBJECT":
        case "MOD_FALLING": armor_should_taken_damage = false; break;
        default: break;
    }

    return armor_should_taken_damage;
}

function give_armor( value )
{
    if( !isdefined( self.armorValue ) ) return;
    if( value >= PLAYER_MAX_ARMOR ) 
    {
        self.armorValue = PLAYER_MAX_ARMOR;
        self notify( "player_gained_full_armor" );
        self clientfield::set_player_uimodel( "r6e.armor", PLAYER_MAX_ARMOR );
    }
    else 
    {
        self.armorValue = value;
        self clientfield::set_player_uimodel( "r6e.armor", value );
    }
}

function get_armor()
{
    if( !isdefined( self.armorValue ) ) return undefined;
    return self.armorValue;
}