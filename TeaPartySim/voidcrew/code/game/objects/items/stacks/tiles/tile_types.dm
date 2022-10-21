/obj/item/stack/tile/grass/attackby(obj/item/item, mob/user, params)
	if((item.tool_behaviour == TOOL_SHOVEL) && params)
		to_chat(user, "<span class='notice'>You start digging up [src].</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
		if(do_after(user, 2 * get_amount(), target = src))
			new /obj/item/stack/ore/glass(get_turf(src), 2 * get_amount())
			user.visible_message("<span class='notice'>[user] digs up [src].</span>", "<span class='notice'>You uproot [src].</span>")
			playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
			qdel(src)
	else
		return ..()
