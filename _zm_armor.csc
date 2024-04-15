#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_armor;

REGISTER_SYSTEM_EX( "zm_armor", &__init__, &__main__, undefined )

#define PLAYER_MAX_ARMOR 500 

function __init__()
{
    clientfield::register( "clientuimodel", "r6e.armor", VERSION_SHIP, GetMinBitCountForNum( PLAYER_MAX_ARMOR ), "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function __main__()
{
}