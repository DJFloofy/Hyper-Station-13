
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
//////////////////////// Engine Construction /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/engine
	group = "Engine Construction"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engine/am_jar
	name = "Antimatter Containment Jar Crate"
	desc = "Two Antimatter containment jars stuffed into a single crate."
	cost = 2300
	contains = list(/obj/item/am_containment,
					/obj/item/am_containment)
	crate_name = "antimatter jar crate"

/datum/supply_pack/engine/am_core
	name = "Antimatter Control Crate"
	desc = "The brains of the Antimatter engine, this device is sure to teach the station's powergrid the true meaning of real power."
	cost = 5200
	contains = list(/obj/machinery/power/am_control_unit)
	crate_name = "antimatter control crate"

/datum/supply_pack/engine/am_shielding
	name = "Antimatter Shielding Crate"
	desc = "Contains ten Antimatter shields, somehow crammed into a crate."
	cost = 2500
	contains = list(/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container,
					/obj/item/am_shielding_container) //10 shields: 3x3 containment and a core
	crate_name = "antimatter shielding crate"

/datum/supply_pack/engine/emitter
	name = "Emitter Crate"
	desc = "Useful for powering forcefield generators while destroying locked crates and intruders alike. Contains two high-powered energy emitters. Requires CE access to open."
	cost = 1750
	access = ACCESS_CE
	contains = list(/obj/machinery/power/emitter,
					/obj/machinery/power/emitter)
	crate_name = "emitter crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/field_gen
	name = "Field Generator Crate"
	desc = "Typically the only thing standing between the station and a messy death. Powered by emitters. Contains two field generators."
	cost = 1750
	contains = list(/obj/machinery/field/generator,
					/obj/machinery/field/generator)
	crate_name = "field generator crate"

/datum/supply_pack/engine/grounding_rods
	name = "Grounding Rod Crate"
	desc = "Four grounding rods guaranteed to keep any uppity tesla's lightning under control."
	cost = 2200
	contains = list(/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod)
	crate_name = "grounding rod crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/mason
	name = "M.A.S.O.N RIG Crate"
	desc = "The rare M.A.S.O.N RIG. Requires CE access to open."
	cost = 15000
	access = ACCESS_CE
	contains = list(/obj/item/clothing/suit/space/hardsuit/ancient/mason)
	crate_name = "M.A.S.O.N Rig"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engine/PA
	name = "Particle Accelerator Crate"
	desc = "A supermassive black hole or hyper-powered teslaball are the perfect way to spice up any party! This \"My First Apocalypse\" kit contains everything you need to build your own Particle Accelerator! Ages 10 and up."
	cost = 3750
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	crate_name = "particle accelerator crate"

/datum/supply_pack/engine/collector
	name = "Radiation Collector Crate"
	desc = "Contains three radiation collectors. Useful for collecting energy off nearby Supermatter Crystals, Singularities or Teslas!"
	cost = 2750
	contains = list(/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector)
	crate_name = "collector crate"

/datum/supply_pack/engine/sing_gen
	name = "Singularity Generator Crate"
	desc = "The key to unlocking the power of Lord Singuloth. Particle Accelerator not included."
	cost = 6000
	contains = list(/obj/machinery/the_singularitygen)
	crate_name = "singularity generator crate"

/datum/supply_pack/engine/solar
	name = "Solar Panel Crate"
	desc = "Go green with this DIY advanced solar array. Contains twenty one solar assemblies, a solar-control circuit board, and tracker. If you have any questions, please check out the enclosed instruction book."
	cost = 2850
	contains  = list(/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/circuitboard/computer/solar_control,
					/obj/item/electronics/tracker,
					/obj/item/paper/guides/jobs/engi/solars)
	crate_name = "solar panel crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/supermatter_shard
	name = "Supermatter Shard Crate"
	desc = "The power of the heavens condensed into a single crystal. Requires CE access to open."
	cost = 10000
	access = ACCESS_CE
	contains = list(/obj/machinery/power/supermatter_crystal/shard)
	crate_name = "supermatter shard crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/tesla_coils
	name = "Tesla Coil Crate"
	desc = "Whether it's high-voltage executions, creating research points, or just plain old power generation: This pack of four Tesla coils can do it all!"
	cost = 3500
	contains = list(/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil)
	crate_name = "tesla coil crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/tesla_gen
	name = "Tesla Generator Crate"
	desc = "The key to unlocking the power of the Tesla energy ball. Particle Accelerator not included."
	cost = 7000
	contains = list(/obj/machinery/the_singularitygen/tesla)
	crate_name = "tesla generator crate"

/datum/supply_pack/engine/teg
	name = "Thermoelectric Generator Assembly"
	desc = "Contains your very own Thermoelectric Generator Assembly. Time to turn cargo into a blazing hellfire, perhaps?"
	cost = 3000
	contains = list(/obj/item/paper/teg,
					/obj/item/circuitboard/machine/generator,
					/obj/item/circuitboard/machine/circulator,
					/obj/item/circuitboard/machine/circulator,
					/obj/item/stack/cable_coil,
					/obj/item/stack/sheet/metal/twenty)
	crate_name = "thermoelectric generator crate"

/obj/item/paper/teg
	info = "*The seemingly useful notes have been scribbled over with red and black crayon. Hmm.*"
	name = "TEG Instructions"
	color = "red"

/datum/supply_pack/engine/energy_harvester
	name = "Energy Harvesting Module"
	desc = "A Device which upon connection to a node, will harvest the energy and send it to engineerless stations in return for credits, derived from a syndicate powersink model."
	cost = 7500
	access = ACCESS_CE
	contains = list(/obj/item/energy_harvester)
	crate_name = "energy harvesting module crate"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engine/fuel_rod
	name = "Uranium Fuel Rod crate"
	desc = "Two additional fuel rods for use in a reactor, requires CE access to open. Caution: Radioactive"
	cost = 3000
	access = ACCESS_CE
	contains = list(/obj/item/twohanded/required/fuel_rod,
					/obj/item/twohanded/required/fuel_rod)
	crate_name = "Uranium-235 Fuel Rod crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/bananium_fuel_rod
	name = "Bananium Fuel Rod crate"
	desc = "Two fuel rods designed to utilize and multiply bananium in a reactor, requires CE access to open. Caution: Radioactive"
	cost = 4000
	access = ACCESS_CE // Nag your local CE
	contains = list(/obj/item/twohanded/required/fuel_rod/material/bananium,
					/obj/item/twohanded/required/fuel_rod/material/bananium)
	crate_name = "Bluespace Crystal Fuel Rod crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE
	contraband = TRUE

/datum/supply_pack/engine/reactor
	name = "RMBK Nuclear Reactor Kit" // (not) a toy
	desc = "Contains a reactor beacon and 3 reactor consoles. Uranium rods not included."
	cost = 12000
	access = ACCESS_CE
	contains = list(/obj/item/survivalcapsule/reactor,
					/obj/machinery/computer/reactor/control_rods/cargo,
					/obj/machinery/computer/reactor/stats/cargo,
					/obj/machinery/computer/reactor/fuel_rods/cargo)
	crate_name = "Build Your Own Reactor Kit"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE
