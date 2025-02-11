#define DYNAMIC_DEFAULT_CHAOS       1.0 //The default chaos value for low pop low vote rounds
#define DYNAMIC_VOTE_NORMALIZATION  5   //If there are fewer than this many votes, the average will be skewed towards the default

SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

	flags = SS_KEEP_TIMING|SS_NO_INIT

	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	var/list/choices = list()
	var/list/voted = list()
	var/list/voting = list()
	var/list/generated_actions = list()

	var/obfuscated = FALSE//CIT CHANGE - adds obfuscated/admin-only votes

	var/list/stored_gamemode_votes = list() //Basically the last voted gamemode is stored here for end-of-round use.

/datum/controller/subsystem/vote/fire()	//called by master_controller
	if(mode)
		time_remaining = round((started_time + CONFIG_GET(number/vote_period) - world.time)/10)

		if(time_remaining < 0)
			result()
			for(var/client/C in voting)
				C << browse(null, "window=vote;can_close=0")
			reset()
		else
			var/datum/browser/client_popup
			for(var/client/C in voting)
				client_popup = new(C, "vote", "Voting Panel")
				client_popup.set_window_options("can_close=0")
				client_popup.set_content(interface(C))
				client_popup.open(0)


/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	mode = null
	question = null
	choices.Cut()
	voted.Cut()
	voting.Cut()
	obfuscated = FALSE //CIT CHANGE - obfuscated votes
	remove_action_buttons()

/datum/controller/subsystem/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	
	//Catch for dynamic vote. We want to return all the votes.
	if(mode == "dynamic")
		return choices //Just return everything to handle
	/*
		. = list()
		for(var/option in choices)
			. += option
			return .
	*/
	else
		for (var/option in choices)
			var/votes = choices[option]
			total_votes += votes
			if(votes > greatest_votes)
				greatest_votes = votes
	
	//default-vote for everyone who didn't vote
	if(!CONFIG_GET(flag/default_no_vote) && choices.len)
		var/list/non_voters = GLOB.directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if (!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(non_voters.len > 0)
			if(mode == "restart")
				choices["Continue Playing"] += non_voters.len
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]
			else if(mode == "gamemode")
				if(GLOB.master_mode in choices)
					choices[GLOB.master_mode] += non_voters.len
					if(choices[GLOB.master_mode] >= greatest_votes)
						greatest_votes = choices[GLOB.master_mode]
			else if(mode == "transfer") // austation sort of but not really begin -- Crew autotransfer vote
				choices["Initiate Crew Transfer"] += non_voters.len
				if(choices["Initiate Crew Transfer"] >= greatest_votes)
					greatest_votes = choices["Initiate Crew Transfer"]

	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	var/was_roundtype_vote = mode == "roundtype"
	if(winners.len > 0)
		if(question)
			text += "<b>[question]</b>"
		else
			text += "<b>[capitalize(mode)] Vote</b>"
		if(was_roundtype_vote)
			stored_gamemode_votes = list()
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			if(was_roundtype_vote)
				stored_gamemode_votes[choices[i]] = votes
			text += "\n<b>[choices[i]]:</b> [obfuscated ? "???" : votes]" //CIT CHANGE - adds obfuscated votes
		
		//Dynamic mode
		if(mode == "dynamic")
			text = "\n<b> Dynamic Chaos Vote: </b>"
			var/numbers = list()
			var/v = 0
			for (var/option in winners) //Everyone is a winner in aggregate vote
				//We returned choices, which is now winners. So syntax and variables gets a little weird here.
				switch(option) //If there is a proc for string to digits, I couldn't find it. Might clean this later.
					if("0")
						v += winners[option] //Add the number votes to the pool
						numbers += (winners[option]*0) //Add the value of the vote to numbers
					if("1")
						v += winners[option] //Add the number votes to the pool
						numbers += (winners[option]*1) //Add the value of the vote to numbers
					if("2")
						v += winners[option] //Add the number votes to the pool
						numbers += (winners[option]*2) //Add the value of the vote to numbers
					if("3")
						v += winners[option] //Add the number votes to the pool
						numbers += (winners[option]*3) //Add the value of the vote to numbers
					if("4")
						v += winners[option] //Add the number votes to the pool
						numbers += (winners[option]*4) //Add the value of the vote to numbers
					if("5")
						v += winners[option] //Add the number votes to the pool
						numbers += (winners[option]*5) //Add the value of the vote to numbers
			if(v < DYNAMIC_VOTE_NORMALIZATION)
				while (v < DYNAMIC_VOTE_NORMALIZATION) //For low low pop, low vote rounds.
					numbers += DYNAMIC_DEFAULT_CHAOS //stops the one person voting from setting the chaos to five and flooding the station with anomalies
					v += 1
			else if (voted.len < GLOB.clients.len)	//Have non-voters "vote" 2, if we're not lowpop
				for(var/I in 1 to (GLOB.clients.len - voted.len))
					v += 1
					numbers += 2
			var/total = 0
			for (var/i in numbers)
				total += i
			. = (total / v)
			if(total == 0)//If statements down the road break if total is allowed to be 0 and it defaults to normal extended.
				. = 0.1 
			text += "\n<b>Chaos level [.]</b>"
			
		if(mode != "custom" && mode != "dynamic")
			if(winners.len > 1 && !obfuscated) //CIT CHANGE - adds obfuscated votes
				text = "\n<b>Vote Tied Between:</b>"
				for(var/option in winners)
					text += "\n\t[option]"
			. = pick(winners)
			text += "\n<b>Vote Result: [obfuscated ? "???" : .]</b>" //CIT CHANGE - adds obfuscated votes
		else
			text += "\n<b>Did not vote:</b> [GLOB.clients.len-voted.len]"
	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	log_vote(text)
	remove_action_buttons()
	to_chat(world, "\n<font color='purple'>[text]</font>")
	if(obfuscated) //CIT CHANGE - adds obfuscated votes. this messages admins with the vote's true results
		var/admintext = "Obfuscated results"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			admintext += "\n<b>[choices[i]]:</b> [votes]"
		message_admins(admintext)
	return .

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if("roundtype") //CIT CHANGE - adds the roundstart extended/secret vote
				if(SSticker.current_state > GAME_STATE_PREGAME)//Don't change the mode if the round already started.
					return message_admins("A vote has tried to change the gamemode, but the game has already started. Aborting.")
				GLOB.master_mode = .
				SSticker.save_mode(.)
				message_admins("The gamemode has been voted for, and has been changed to: [GLOB.master_mode]")
				log_admin("Gamemode has been voted for and switched to: [GLOB.master_mode].")
			if("dynamic")
				GLOB.master_mode = "dynamic"
				GLOB.dynamic_chaos_level = .
			if("restart")
				if(. == "Restart Round")
					restart = 1
			if("gamemode")
				if(GLOB.master_mode != .)
					SSticker.save_mode(.)
					if(SSticker.HasRoundStarted())
						restart = 1
					else
						GLOB.master_mode = .
			if("map")
				var/datum/map_config/VM = config.maplist[.]
				message_admins("The map has been voted for and will change to: [VM.map_name]")
				log_admin("The map has been voted for and will change to: [VM.map_name]")
				if(SSmapping.changemap(config.maplist[.]))
					to_chat(world, "<span class='boldannounce'>The map vote has chosen [VM.map_name] for next round!</span>")
			if("transfer") // austation begin -- Crew autotransfer vote
				if(. == "Initiate Crew Transfer")
					//TODO find a cleaner way to do this
					SSshuttle.requestEvac(null,"Crew transfer requested.")
					var/obj/machinery/computer/communications/C = locate() in GLOB.machines
					if(C)
						C.post_status("shuttle") // austation end
	if(restart)
		var/active_admins = 0
		for(var/client/C in GLOB.admins)
			if(!C.is_afk() && check_rights_for(C, R_SERVER))
				active_admins = 1
				break
		if(!active_admins)
			SSticker.Reboot("Restart vote successful.", "restart vote")
		else
			to_chat(world, "<span style='boldannounce'>Notice:Restart vote will not restart the server automatically because there are active admins on.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +server, so it has been canceled. If you wish, you may restart the server.")

	return .

/datum/controller/subsystem/vote/proc/submit_vote(vote)
	if(mode)
		if(CONFIG_GET(flag/no_dead_vote) && usr.stat == DEAD && !usr.client.holder)
			return 0
		if(!(usr.ckey in voted))
			if(vote && 1<=vote && vote<=choices.len)
				voted += usr.ckey
				voted[usr.ckey] = vote
				choices[choices[vote]]++	//check this
				return vote
		else if(vote && 1<=vote && vote<=choices.len)
			choices[choices[voted[usr.ckey]]]--
			voted[usr.ckey] = vote
			choices[choices[vote]]++
			return vote
	return 0

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key, hideresults)//CIT CHANGE - adds hideresults argument to votes to allow for obfuscated votes
	if(!mode)
		if(started_time)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, "<span class='warning'>There is already a vote in progress! please wait for it to finish.</span>")
				return 0

			var/admin = FALSE
			var/ckey = ckey(initiator_key)
			if(GLOB.admin_datums[ckey])
				admin = TRUE

			if(next_allowed_time > world.time && !admin)
				to_chat(usr, "<span class='warning'>A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!</span>")
				return 0

		SEND_SOUND(world, sound('sound/misc/notice2.ogg'))
		reset()
		obfuscated = FALSE //CIT CHANGE - adds obfuscated votes
		switch(vote_type)
			if("restart")
				choices.Add("Restart Round","Continue Playing")
			if("gamemode")
				choices.Add(config.votable_modes)
			if("map")
				choices.Add(config.maplist)
				for(var/i in choices)//this is necessary because otherwise we'll end up with a bunch of /datum/map_config's as the default vote value instead of 0 as intended
					choices[i] = 0
			if("transfer") // austation begin -- Crew autotranfer vote
				choices.Add("Initiate Crew Transfer","Continue Playing") // austation end
			if("roundtype") //CIT CHANGE - adds the roundstart secret/extended vote
				choices.Add("secret", "extended")
			if("dynamic")
				obfuscated = TRUE
				choices.Add("0","1","2","3","4","5")
			if("custom")
				question = stripped_input(usr,"What is the vote for?")
				if(!question)
					return 0
				for(var/i=1,i<=10,i++)
					var/option = capitalize(stripped_input(usr,"Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			else
				return 0
		mode = vote_type
		initiator = initiator_key ? initiator_key : "the Server" // austation -- Crew autotransfer vote
		started_time = world.time
		var/text = "[capitalize(mode)] vote started by [initiator]."
		if(mode == "custom")
			text += "\n[question]"
		log_vote(text)
		var/vp = CONFIG_GET(number/vote_period)
		to_chat(world, "\n<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=[REF(src)]'>here</a> to place your votes.\nYou have [DisplayTimeText(vp)] to vote.</font>")
		time_remaining = round(vp/10)
		for(var/c in GLOB.clients)
			SEND_SOUND(c, sound('sound/misc/server-ready.ogg'))
			var/client/C = c
			var/datum/action/vote/V = new
			if(question)
				V.name = "Vote: [question]"
			C.player_details.player_actions += V
			V.Grant(C.mob)
			generated_actions += V
		return 1
	return 0

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = 0
	var/trialmin = 0
	if(C.holder)
		admin = 1
		if(check_rights_for(C, R_ADMIN))
			trialmin = 1
	voting |= C

	if(mode)
		if(question)
			. += "<h2>Vote: '[question]'</h2>"
		else
			. += "<h2>Vote: [capitalize(mode)]</h2>"
			if(mode =="dynamic")
				. += "<h2>\nSelect your chaos level.</h2>"
				. += "<h2>\nHigher values mean more antags and chaos.\n</h2>"
		. += "Time Left: [time_remaining] s<hr><ul>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			var/ivotedforthis = ((C.ckey in voted) && (voted[C.ckey] == i) ? TRUE : FALSE)
			if(!votes)
				votes = 0
			. += "<li>[ivotedforthis ? "<b>" : ""]<a href='?src=[REF(src)];vote=[i]'>[choices[i]]</a> ([obfuscated ? (admin ? "??? ([votes])" : "???") : votes] votes)[ivotedforthis ? "</b>" : ""]</li>" // CIT CHANGE - adds obfuscated votes
		. += "</ul><hr>"
		if(admin)
			. += "(<a href='?src=[REF(src)];vote=cancel'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul><li>"
		//restart
		var/avr = CONFIG_GET(flag/allow_vote_restart)
		if(trialmin || avr)
			. += "<a href='?src=[REF(src)];vote=restart'>Restart</a>"
		else
			. += "<font color='grey'>Restart (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_restart'>[avr ? "Allowed" : "Disallowed"]</a>)"
		. += "</li><li>"
		//gamemode
		var/avm = CONFIG_GET(flag/allow_vote_mode)
		if(trialmin || avm)
			. += "<a href='?src=[REF(src)];vote=gamemode'>GameMode</a>"
		else
			. += "<font color='grey'>GameMode (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_gamemode'>[avm ? "Allowed" : "Disallowed"]</a>)"

		. += "</li>"
		//custom
		if(trialmin)
			. += "<li><a href='?src=[REF(src)];vote=custom'>Custom</a></li>"
		. += "</ul><hr>"
	. += "<a href='?src=[REF(src)];vote=close' style='position:absolute;right:50px'>Close</a>"
	return .


/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid
	switch(href_list["vote"])
		if("close")
			voting -= usr.client
			usr << browse(null, "window=vote")
			return
		if("cancel")
			if(usr.client.holder)
				reset()
		if("toggle_restart")
			if(usr.client.holder)
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
		if("toggle_gamemode")
			if(usr.client.holder)
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))
		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || usr.client.holder)
				initiate_vote("restart",usr.key)
		if("gamemode")
			if(CONFIG_GET(flag/allow_vote_mode) || usr.client.holder)
				initiate_vote("gamemode",usr.key)
		if("custom")
			if(usr.client.holder)
				initiate_vote("custom",usr.key)
		else
			submit_vote(round(text2num(href_list["vote"])))
	usr.vote()

/datum/controller/subsystem/vote/proc/remove_action_buttons()
	for(var/v in generated_actions)
		var/datum/action/vote/V = v
		if(!QDELETED(V))
			V.remove_from_client()
			V.Remove(V.owner)
	generated_actions = list()

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	var/datum/browser/popup = new(src, "vote", "Voting Panel")
	popup.set_window_options("can_close=0")
	popup.set_content(SSvote.interface(client))
	popup.open(0)

/datum/action/vote
	name = "Vote!"
	button_icon_state = "vote"

/datum/action/vote/Trigger()
	if(owner)
		owner.vote()
		remove_from_client()
		Remove(owner)

/datum/action/vote/IsAvailable()
	return 1

/datum/action/vote/proc/remove_from_client()
	if(!owner)
		return
	if(owner.client)
		owner.client.player_details.player_actions -= src
	else if(owner.ckey)
		var/datum/player_details/P = GLOB.player_details[owner.ckey]
		if(P)
			P.player_actions -= src