require "util"

function copyItem(object, newname)
	item = table.deepcopy(object)
	item.name = newname
	item.place_result = newname
	item.order = object.order .. "-"
	table.insert(mini.list,item)
end

function copyRecipe(object, newname)
	recipe = table.deepcopy(object)
	recipe.name = newname
	local nrec = {}
	if mini.balance then
		--For varied recipes
		if recipe.normal then
			nrec.normal = {}
			nrec.normal.ingredients = {}
			for _, ingredV in pairs(recipe.normal.ingredients) do
				local ning = {}
				--subIngred is either name or amount of ingredient
				for typ, subIngred in pairs (ingredV) do
					if type(subIngred) == "string" then
						if typ == "type" then
							ning.type = subIngred
						else
							ning.name = subIngred
						end
					end
					if type(subIngred) == "number" then
						ning.amount = math.ceil(2*subIngred/3)
					end
				end
				table.insert(nrec.normal.ingredients,ning)
			end
			recipe.normal = nrec.normal
			nrec.expensive = {}
			nrec.expensive.ingredients = {}
			for _, ingredV in pairs(recipe.expensive.ingredients) do
				local ning = {}
				--subIngred is either name or amount of ingredient
				for typ, subIngred in pairs (ingredV) do
					if type(subIngred) == "string" then
						if typ == "type" then
							ning.type = subIngred
						else
							ning.name = subIngred
						end
					end
					if type(subIngred) == "number" then
						ning.amount = math.ceil(2*subIngred/3)
					end
				end
				table.insert(nrec.expensive.ingredients,ning)
			end
			recipe.expensive = nrec.expensive
		--For regular recipes
		else
			--ingredV is table for specific ingredient
			for _, ingredV in pairs(recipe.ingredients) do
				local ning = {}
				--subIngred is either name, type, or amount of ingredient
				for typ, subIngred in pairs (ingredV) do
					if type(subIngred) == "string" then
						if typ == "type" then
							ning.type = subIngred
						else
							ning.name = subIngred
						end
					end
					if type(subIngred) == "number" then
						ning.amount = math.ceil(2*subIngred/3)
					end
				end
				table.insert(nrec,ning)
			end
			recipe.ingredients = nrec
		end
	end
	if recipe.normal then
		recipe.normal.result = newname
		recipe.expensive.result = newname
		recipe.normal.enabled = object.normal.enabled
		recipe.expensive.enabled = object.expensive.enabled
	else 
		recipe.result = newname
	end
	table.insert(mini.list,recipe)
end

function copyAssembler(object, newname, bobs)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	if entity.animation.layers then
		for _, layers in pairs(entity.animation.layers) do
			layers.shift = shrink(layers.shift, 0.66)
			layers.scale = 0.66
			if layers.hr_version then
				layers.hr_version.shift = shrink(layers.hr_version.shift, 0.66)
				layers.hr_version.scale = layers.hr_version.scale * 0.66
			end
		end
	else
		entity.animation.shift = shrink(entity.animation.shift, 0.66)
		entity.animation.scale = 0.66
	end
	table.insert(mini.list,entity)
end

function copyFurnace(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	for _, layers in pairs(entity.animation.layers) do
		layers.shift = shrink(layers.shift, 0.66)
		layers.scale = 0.66
		if layers.hr_version then
			layers.hr_version.shift = shrink(layers.hr_version.shift, 0.66)
			layers.hr_version.scale = layers.hr_version.scale * 0.66
		end
	end
	for _ , anim in pairs(entity.working_visualisations) do
		anim.animation.shift = shrink(anim.animation.shift, 0.66)
		anim.animation.scale = 0.66
		if anim.animation.hr_version then
			anim.animation.hr_version.shift = shrink(anim.animation.hr_version.shift, 0.66)
			anim.animation.hr_version.scale = anim.animation.hr_version.scale * 0.66	
		end
	end
	table.insert(mini.list,entity)
end

function copyRefinery(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
	entity.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
	entity.corpse = "medium-remnants"
	for _, anim in pairs(entity.animation) do
		if anim.layers then
			anim.layers[1].scale = anim.layers[1].scale * 0.66
			anim.layers[1].hr_version.scale = anim.layers[1].hr_version.scale * 0.66
			anim.layers[1].shift = shrink(anim.layers[1].shift, 0.66)
			anim.layers[1].hr_version.shift = shrink(anim.layers[1].hr_version.shift, 0.66)
			anim.layers[2].scale = anim.layers[1].scale * 0.66
			anim.layers[2].hr_version.scale = anim.layers[1].hr_version.scale * 0.66
			anim.layers[2].shift = shrink(anim.layers[1].shift, 0.66)
			anim.layers[2].hr_version.shift = shrink(anim.layers[1].hr_version.shift, 0.66)
		else
			anim.shift = shrink(anim.shift, 0.66)
			anim.scale = 0.66
			if anim.hr_version then
				anim.hr_version.scale = anim.hr_version.scale * 0.66
				anim.hr_version.shift = shrink(anim.hr_version.shift, 0.66)
			end
		end
	end
	for _ , anim in pairs(entity.working_visualisations) do
		anim.north_position = shrink(anim.north_position, 0.66)
		anim.east_position = shrink(anim.east_position, 0.66)
		anim.south_position = shrink(anim.south_position, 0.66)
		anim.west_position = shrink(anim.west_position, 0.66)
		anim.animation.shift = shrink(anim.animation.shift, 0.66)
		anim.animation.scale = 0.66
		if anim.animation.hr_version then
			anim.animation.hr_version.shift = shrink(anim.animation.hr_version.shift, 0.66)
			anim.animation.scale = anim.animation.scale * 0.66
		end
	end
	table.insert(mini.list,entity)
end

function copyMiner(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	entity.resource_searching_radius = 2.0
	entity.vector_to_place_result = {0, -1.25}
	entity.input_fluid_box.pipe_connections = 
      {
        { position = {-1.25, 0} },
        { position = {1.25, 0} },
        { position = {0, 1.25} },
      }
	shrinkMinerAnims(entity.animations)
	shrinkMinerAnims(entity.shadow_animations)
	shrinkMinerAnims(entity.input_fluid_patch_sprites)
	shrinkMinerAnims(entity.input_fluid_patch_shadow_sprites)
	shrinkMinerAnims(entity.input_fluid_patch_shadow_animations)
	shrinkMinerAnims(entity.input_fluid_patch_window_sprites)
	for _, anim in pairs(entity.input_fluid_patch_window_flow_sprites) do
		shrinkMinerAnims(anim)
	end
	for _, anim in pairs(entity.input_fluid_patch_window_base_sprites) do
		shrinkMinerAnims(anim)
	end
	table.insert(mini.list,entity)
end

function copyBeacon(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	entity.base_picture.shift = shrink(entity.base_picture.shift, 0.66)
	entity.base_picture.scale = 0.66
	entity.animation.shift = shrink(entity.animation.shift, 0.66)
	entity.animation.scale = 0.66
	entity.animation_shadow.shift = shrink(entity.animation_shadow.shift, 0.66)
	entity.animation_shadow.scale = 0.66
	entity.supply_area_distance = (entity.supply_area_distance - 1)
	table.insert(mini.list,entity)
end

function copyChem(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	for _, anim in pairs(entity.animation) do
		if anim.layers then
			if anim.layers[1].scale then anim.layers[1].scale = anim.layers[1].scale * 0.66
			else anim.layers[1].scale = 0.66 end
			anim.layers[1].hr_version.scale = anim.layers[1].hr_version.scale * 0.66
			anim.layers[1].shift = shrink(anim.layers[1].shift, 0.66)
			anim.layers[1].hr_version.shift = shrink(anim.layers[1].hr_version.shift, 0.66)
			anim.layers[2].scale = anim.layers[1].scale * 0.66
			anim.layers[2].shift = shrink(anim.layers[1].shift, 0.66)
			if anim.layers[2].hr_version then
				anim.layers[2].hr_version.scale = anim.layers[1].hr_version.scale * 0.66 
				anim.layers[2].hr_version.shift = shrink(anim.layers[1].hr_version.shift, 0.66)
			end
		else
			anim.shift = shrink(anim.shift, 0.66)
			anim.scale = 0.66
			if anim.hr_version then
				anim.hr_version.scale = anim.hr_version.scale * 0.66
				anim.hr_version.shift = shrink(anim.hr_version.shift, 0.66)
			end
		end
	end
	for _ , anim in pairs(entity.working_visualisations) do
		anim.north_position = shrink(anim.north_position, 0.66)
		anim.east_position = shrink(anim.east_position, 0.66)
		anim.south_position = shrink(anim.south_position, 0.66)
		anim.west_position = shrink(anim.west_position, 0.66)
		if anim.apply_recipe_tint ~= "tertiary" then
			--if anim.animation == nil then error(serpent.block(anim)) end
			anim.animation.scale = 0.66
			if anim.animation.hr_version then
				anim.animation.hr_version.scale = anim.animation.hr_version.scale * 0.66
			end
		else
			anim.north_animation.shift = shrink(anim.north_animation.shift, 0.66)
			anim.north_animation.scale = 0.66
			anim.north_animation.hr_version.shift = shrink(anim.north_animation.hr_version.shift, 0.66)
			anim.north_animation.hr_version.scale = anim.north_animation.hr_version.scale * 0.66
			anim.east_animation.shift = shrink(anim.north_animation.shift, 0.66)
			anim.east_animation.scale = 0.66
			anim.east_animation.hr_version.shift = shrink(anim.north_animation.hr_version.shift, 0.66)
			anim.east_animation.hr_version.scale = anim.north_animation.hr_version.scale * 0.66
			anim.south_animation.shift = shrink(anim.north_animation.shift, 0.66)
			anim.south_animation.scale = 0.66
			anim.south_animation.hr_version.shift = shrink(anim.north_animation.hr_version.shift, 0.66)
			anim.south_animation.hr_version.scale = anim.north_animation.hr_version.scale * 0.66
		end
	end
	table.insert(mini.list,entity)
end

function copyElectro(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	for _, anim in pairs(entity.animation) do
		anim.scale = 0.66
		anim.shift = shrink(anim.shift, 0.66)
	end
	table.insert(mini.list,entity)
end

function copyPumpjack(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	collision_box = {{-0.29, -0.29}, {0.29, 0.29}}
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
	entity.drawing_box = {{0,0},{0,0}}
	entity.corpse = "medium-remnants"
	entity.output_fluid_box.pipe_connections[1].positions = {{0,-1},{1,0},{0,1},{-1,0}}	
	entity.base_picture.sheet.shift = shrink(entity.base_picture.sheet.shift,0.66)
	entity.base_picture.sheet.scale = 0.66
	if entity.animations.north.shift then
		entity.animations.north.shift = shrink(entity.animations.north.shift,0.66)
		entity.animations.north.scale = 0.66
	end
	for _, point in pairs(entity.circuit_wire_connection_points) do
		point.shadow.red = shrink(point.shadow.red,0.66)
		point.shadow.green = shrink(point.shadow.green,0.66)
		point.wire.red = shrink(point.wire.red,0.66)
		point.wire.green = shrink(point.wire.green,0.66)
	end
	circuit_connector_sprites =
    {
      get_circuit_connector_sprites({0.15625*0.66, -1.0625*0.66}, {0.15625*0.66, -1.0625*0.66}, 2),
      get_circuit_connector_sprites({0.15625*0.66, -1.0625*0.66}, {0.15625*0.66, -1.0625*0.66}, 2),
      get_circuit_connector_sprites({0.15625*0.66, -1.0625*0.66}, {0.15625*0.66, -1.0625*0.66}, 2),
      get_circuit_connector_sprites({0.15625*0.66, -1.0625*0.66}, {0.15625*0.66, -1.0625*0.66}, 2)
    }
	table.insert(mini.list,entity)
end

function copyTank(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	entity.fluid_box.base_area = (entity.fluid_box.base_area / 2)
	entity.fluid_box.pipe_connections[1].position ={-0.5,-1.5}
	entity.fluid_box.pipe_connections[2].position ={1.5,0.5}
	entity.fluid_box.pipe_connections[3].position ={0.5,1.5}
	entity.fluid_box.pipe_connections[4].position ={-1.5,-0.5}
	entity.window_bounding_box[1] = shrink(entity.window_bounding_box[1], 0.66)
	entity.window_bounding_box[2] = shrink(entity.window_bounding_box[2], 0.66)
	entity.pictures.picture.sheet.shift = shrink(entity.pictures.picture.sheet.shift, 0.66)
	entity.pictures.picture.sheet.scale = 0.66
	--entity.pictures.fluid_background
	--entity.pictures.window_background
	--entity.pictures.flow_sprite
	--entity.pictures.gas_flow
	for _, point in pairs(entity.circuit_wire_connection_points) do
		point.shadow.red = shrink(point.shadow.red,0.66)
		point.shadow.green = shrink(point.shadow.green,0.66)
		point.wire.red = shrink(point.wire.red,0.66)
		point.wire.green = shrink(point.wire.green,0.66)
	end
	entity.circuit_connector_sprites = {
		get_circuit_connector_sprites({-0.1875*0.66, -0.375*0.66}, nil, 7),
		get_circuit_connector_sprites({0.375*0.66, -0.53125*0.66}, nil, 1),
		get_circuit_connector_sprites({-0.1875*0.66, -0.375*0.66}, nil, 7),
		get_circuit_connector_sprites({0.375*0.66, -0.53125*0.66}, nil, 1),
	}
	table.insert(mini.list,entity)
end

function copyRadar(object, newname)
	entity = table.deepcopy(object)
	entity.name = newname
	entity.minable.result = newname
	entity.collision_box = {{-0.75,-0.75},{0.75,0.75}}
	entity.selection_box = {{-1.0,-1.0},{1.0,1.0}}
	entity.corpse = "medium-remnants"
	entity.pictures.shift = shrink(entity.pictures.shift)
	entity.pictures.scale = 0.66
	entity.energy_per_sector = "1MJ"
	entity.max_distance_of_sector_revealed = 0
	table.insert(mini.list,entity)
end

function shrinkMinerAnims(animToShrink)
	for _, anim in pairs(animToShrink) do
		if anim.layers then
			for _, layers in pairs(anim.layers) do
				layers.shift = shrink(layers.shift, 0.66)
				layers.scale = 0.66
				layers.hr_version.shift = shrink(layers.hr_version.shift, 0.66)
				layers.hr_version.scale = layers.hr_version.scale * 0.66
			end
		else
			anim.shift = shrink(anim.shift, 0.66)
			anim.scale = 0.66
			anim.hr_version.shift = shrink(anim.hr_version.shift, 0.66)
			anim.hr_version.scale = anim.hr_version.scale * 0.66
		end
	end
end

function shrink(mult, percent)
	if (mult == nil) then
		error("If a user is seeing this message, please inform the mod author (Kryzeth)\n" .. serpent.block(debug.traceback()))
	end
	percent = percent or 0.66
	local tab = {}
	for _, num in pairs(mult) do
		table.insert(tab,(num * percent))
	end
	return tab
end

function shrinkEnergy(power)
	wattSub = string.sub(power,-2, -1)
	energyU = tonumber(string.sub(power, 1, -3))
	energyU = math.ceil(2*energyU /3)
	return (tostring(energyU) .. wattSub)
end

function replaceIngred(rec,old,new)
	if data.raw.recipe[rec] and data.raw.item[new] then
		local recipe = data.raw.recipe[rec]
		local nrec = {}
		if data.raw.recipe[rec].normal then
			nrec.normal = {}
			nrec.normal.ingredients = {}
			for _, ingredV in pairs(recipe.normal.ingredients) do
				local ning = {}
				for typ, subIngred in pairs (ingredV) do
					if type(subIngred) == "string" then
						if typ == "type" then
							ning.type = subIngred
						else
							if subIngred == old then
								ning.name = new
							else 
								ning.name = subIngred
							end
						end
					end
					if type(subIngred) == "number" then
						ning.amount = subIngred
					end
				end
				table.insert(nrec.normal.ingredients,ning)
			end
			nrec.expensive = {}
			nrec.expensive.ingredients = {}
			for _, ingredV in pairs(recipe.expensive.ingredients) do
				local ning = {}
				for typ, subIngred in pairs (ingredV) do
					if type(subIngred) == "string" then
						if typ == "type" then
							ning.type = subIngred
						else
							if subIngred == old then
								ning.name = new
							else 
								ning.name = subIngred
							end
						end
					end
					if type(subIngred) == "number" then
						ning.amount = subIngred
					end
				end
				table.insert(nrec.expensive.ingredients,ning)
			end
		else
			nrec.ingredients = {}
			for _, ingredV in pairs(recipe.ingredients) do
				local ning = {}
				for typ, subIngred in pairs (ingredV) do
					if type(subIngred) == "string" then
						if typ == "type" then
							ning.type = subIngred
						else
							if subIngred == old then
								ning.name = new
							else 
								ning.name = subIngred
							end
						end
					end
					if type(subIngred) == "number" then
						ning.amount = subIngred
					end
				end
				table.insert(nrec.ingredients,ning)
			end
		end
		nrec.type = recipe.type
		nrec.name = recipe.name
		nrec.energy_required = recipe.energy_required
		if data.raw.recipe[rec].normal then
			nrec.normal.result = recipe.normal.result
			nrec.normal.enabled = recipe.normal.enabled or false
			nrec.expensive.result = recipe.expensive.result
			nrec.expensive.enabled = recipe.expensive.enabled or false
		else
			nrec.result = recipe.result
			nrec.enabled = recipe.enabled or false
		end
		data.raw.recipe[rec] = nrec
	else error("Something went wrong with ReplaceIngred in MiniMachines, with recipe " .. rec .. ", turning " .. old .. " into " .. new)
	end
end

function copyTech(object, newname, prereq, icon)
	if data.raw.technology[object] ~= nil then
		tech = table.deepcopy(data.raw.technology[object])
		tech.name = newname
		tech.icon = icon
		tech.icon_size= 128
		tech.effects = {{type="unlock-recipe", recipe=newname}}
		tech.prerequisites = {prereq, object}
		tech.unit.count = math.ceil(2*tech.unit.count/3)
		table.insert(mini.techList, tech)
	else error("The technology " .. object .. " has been altered or removed by another mod.\n" .. "This tech is required for " .. newname)
	end
end

function replaceShinybars()
	for x=1, #mini.list do
		if mini.list[x].type == "item" or mini.list[x].type == "recipe" then
			if mini.list[x].icons then
				if string.match(mini.list[x].icons[2].icon, "__ShinyBobGFX__") then
					mini.list[x].icons[2].icon = string.gsub(mini.list[x].icons[2].icon, "__ShinyBobGFX__", "__mini-machines__")
				elseif string.match(mini.list[x].icons[2].icon, "__ShinyAngelGFX__") then
					mini.list[x].icons[2].icon = string.gsub(mini.list[x].icons[2].icon, "__ShinyAngelGFX__", "__mini-machines__")
				end
			end
		end
	end
end

mini.oilpipefix =
    {
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {-1, 2} }}
      },
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {1, 2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {-1, -2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {0, -2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {1, -2} }}
      }
    }

mini.chempipefix =
    {
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0.5, 1.5} }}
      },
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {-0.5, 1.5} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {0.5, -1.5} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {-0.5, -1.5} }}
      }
    }

mini.graypipefix = 
    {
      {
        production_type = "input",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0.5, -1.5} }},
        secondary_draw_orders = { north = -1 }
      },
      {
        production_type = "output",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0.5, 1.5} }},
        secondary_draw_orders = { north = -1 }
      },
      off_when_no_fluid_recipe = true
    }
	
mini.bluepipefix =
    {
      {
        production_type = "input",
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0.5, -1.5} }},
        secondary_draw_orders = { north = -1 }
      },
      {
        production_type = "output",
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0.5, 1.5} }},
        secondary_draw_orders = { north = -1 }
      },
      off_when_no_fluid_recipe = true
    }

