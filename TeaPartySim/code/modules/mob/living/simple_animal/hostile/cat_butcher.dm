/mob/living/simple_animal/hostile/cat_butcherer
	name = "Cat Surgeon"
	desc = "Felinid physiological modification surgery is outlawed in Nanotrasen-controlled sectors. This doctor doesn't seem to care, and thus, is wanted for several warcrimes."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "cat_butcher"
	icon_living = "cat_butcher"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	projectiletype = /obj/projectile/bullet/dart/tranq
	projectilesound = 'sound/items/syringeproj.ogg'
	ranged = 1
	ranged_message = "fires the syringe gun at"
	ranged_cooldown_time = 30
	speak_chance = 0
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes at"
	attack_verb_simple = "slash at"
	attack_sound = 'sound/weapons/circsawhit.ogg'
	a_intent = INTENT_HARM
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	loot = list(/obj/effect/mob_spawn/human/corpse/cat_butcher, /obj/item/circular_saw, /obj/item/gun/syringe)
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	faction = list("hostile")
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = 1
	var/impatience = 0

/mob/living/simple_animal/hostile/cat_butcherer/AttackingTarget()
	if(iscarbon(target))
		var/mob/living/carbon/human/L = target
		if(!L.getorgan(/obj/item/organ/ears/cat) && L.stat >= UNCONSCIOUS) //target doesnt have cat ears
			if(L.getorgan(/obj/item/organ/ears)) //slice off the old ears
				var/obj/item/organ/ears/ears = L.getorgan(/obj/item/organ/ears)
				visible_message("[src] slices off [L]'s ears!", "<span class='notice'>You slice [L]'s ears off.</span>")
				ears.Remove(L)
				ears.forceMove(get_turf(L))
			else //implant new ears
				visible_message("[src] attaches a pair of cat ears to [L]!", "<span class='notice'>You attach a pair of cat ears to [L].</span>")
				var/obj/item/organ/ears/cat/newears = new
				newears.Insert(L, drop_if_replaced = FALSE)
				return
		else if(!L.getorgan(/obj/item/organ/tail/cat) && L.stat >= UNCONSCIOUS)
			if(L.getorgan(/obj/item/organ/tail)) //cut off the tail if they have one already
				var/obj/item/organ/tail/tail = L.getorgan(/obj/item/organ/tail)
				visible_message("[src] severs [L]'s tail in one swift swipe!", "<span class='notice'>You sever [L]'s tail in one swift swipe.</span>")
				tail.Remove(L)
				tail.forceMove(get_turf(L))
			else //put a cat tail on
				visible_message("[src] attaches a cat tail to [L]!", "<span class='notice'>You attach a tail to [L].</span>")
				var/obj/item/organ/tail/cat/newtail = new
				newtail.Insert(L, drop_if_replaced = FALSE)
				return
		else if(!L.has_trauma_type(/datum/brain_trauma/severe/pacifism) && L.stat >= UNCONSCIOUS) //still does damage
			visible_message("[src] drills a hole in [L]'s skull!", "<span class='notice'>You pacify [L]. Another successful creation.</span>")
			L.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_SURGERY)
			say("I'm a genius!!")
			L.health += 20 //he heals a bit whenever he finishes
		else if(L.stat >= UNCONSCIOUS) //quickly heal them up and move on to our next target!
			visible_message("[src] injects [L] with an unknown medicine!", "<span class='notice'>You inject [L] with medicine.</span>")
			L.SetSleeping(0, FALSE)
			L.SetUnconscious(0, FALSE)
			L.adjustOxyLoss(-50)// do CPR first
			if(L.blood_volume <= 500) //bandage them up and give em some blood if they're bleeding
				L.blood_volume += 30
				L.suppress_bloodloss(1800)
			if(L.getBruteLoss() >= 50)// first, did we beat them into crit? if so, heal that
				var/healing = min(L.getBruteLoss(), 120)
				L.adjustBruteLoss(-healing)
				L.suppress_bloodloss(1800)//bandage their ass
				return
			else if(L.getFireLoss() >= 50) // are they still down from other damage? fix it, but not as fast as the burns
				var/healing = min(L.getFireLoss(), 50)
				L.adjustFireLoss(-healing)
			impatience += 50
			if(prob(impatience))
				FindTarget()//so we don't focus on some unconscious dude when we could get our eyes on the prize
				impatience = 0
				say("Bah!!")
			return
	return ..()
