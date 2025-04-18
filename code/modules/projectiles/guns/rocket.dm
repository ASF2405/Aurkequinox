/obj/item/gun/launcher/rocket
	name = "\"Bazooka\""
	desc = "An ancient rocket-propelled grenade launcher, this model is centuries old but well preserved."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = ITEM_SIZE_HUGE
	throw_speed = 2
	throw_range = 10
	force = 5.0
	flags = CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)

	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/list/rockets = new/list()
	serial_type = "SA"

	wield_delay = 2 SECOND
	wield_delay_factor = 0.6 // 60 vig , heavy stuff

/obj/item/gun/launcher/rocket/examine(mob/user)
	if(!..(user, 2))
		return
	to_chat(user, "\blue [rockets.len] / [max_rockets] rockets.")

/obj/item/gun/launcher/rocket/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			user.drop_item()
			I.loc = src
			rockets += I
			to_chat(user, SPAN_NOTICE("You put the rocket in [src]."))
			to_chat(user, SPAN_NOTICE("[rockets.len] / [max_rockets] rockets."))
		else
			to_chat(user, SPAN_WARNING("[src] cannot hold more rockets."))

/obj/item/gun/launcher/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new (src)
		M.primed = 1
		rockets -= I
		return M
	return null

/obj/item/gun/launcher/rocket/handle_post_fire(mob/user, atom/target)
	message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]) at [target].")
	log_game("[key_name_admin(user)] used a rocket launcher ([src.name]) at [target].")
	..()
