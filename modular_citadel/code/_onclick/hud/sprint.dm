/obj/screen/mov_intent
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
/*
/obj/screen/sprintbutton
	name = "toggle sprint"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "act_sprint"
	layer = ABOVE_HUD_LAYER - 0.1

/obj/screen/sprintbutton/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.togglesprint()

/obj/screen/sprintbutton/proc/insert_witty_toggle_joke_here(mob/living/carbon/human/H)
	if(!H)
		return
	if(H.sprinting)
		icon_state = "act_sprint_on"
	else
		icon_state = "act_sprint"

//Sprint buffer onscreen code.
/datum/hud/var/obj/screen/sprint_buffer/sprint_buffer

/obj/screen/sprint_buffer
	name = "sprint buffer"
	icon = 'icons/effects/progessbar.dmi'
	icon_state = "prog_bar_100"

/obj/screen/sprint_buffer/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		to_chat(L, "<span class='boldnotice'>Your sprint buffer's maximum capacity is [L.sprint_buffer_max]. It is currently at [L.sprint_buffer], regenerating at [L.sprint_buffer_regen_ds * 10] per second. \
		Sprinting while this is empty will incur a [L.sprint_stamina_cost] stamina cost per tile.</span>")

/obj/screen/sprint_buffer/proc/update_to_mob(mob/living/L)
	var/amount = 0
	if(L.sprint_buffer_max > 0)
		amount = round(CLAMP((L.sprint_buffer / L.sprint_buffer_max) * 100, 0, 100), 5)
	icon_state = "prog_bar_[amount]"
*/