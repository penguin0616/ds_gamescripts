
LEVELTYPE = {
	SURVIVAL = 1,
	CAVE = 2,
	ADVENTURE = 3,
	TEST = 4,
	UNKNOWN = 5,
	CUSTOM = 6,
	VOLCANO = 7,
	SHIPWRECKED = 8,
}


Level = Class( function(self, data)
	self.id = data.id or "UNKNOWN_ID"
	self.name = data.name or ""
	self.desc = data.desc or ""
	self.tasks = data.tasks or {}
	self.overrides = data.overrides or {}
	self.substitutes = data.substitutes or {}
	self.override_triggers = data.override_triggers
	self.set_pieces = data.set_pieces or {}
	self.numoptionaltasks = data.numoptionaltasks or 0
	self.nomaxwell = data.nomaxwell or false
	self.override_level_string = data.override_level_string or false
	self.optionaltasks = data.optionaltasks or {}
	self.hideminimap = data.hideminimap or false
	self.teleportaction = data.teleportaction or nil
	self.teleportmaxwell = data.teleportmaxwell or nil
	self.min_playlist_position = data.min_playlist_position or 0
	self.max_playlist_position = data.max_playlist_position or 999
	self.ordered_story_setpieces = data.ordered_story_setpieces
	self.required_prefabs = data.required_prefabs
	self.required_prefab_count = data.required_prefab_count or {}
	self.background_node_range = data.background_node_range
	self.blocker_blank_room_name = data.blocker_blank_room_name

	self.numrandom_set_pieces = data.numrandom_set_pieces or 0
	self.random_set_pieces = data.random_set_pieces or nil

	self.selectedtasks = data.selectedtasks or {}
	self.start_tasks = data.start_tasks or {}

	self.treasures = data.treasures or {}
	self.numoptional_treasures = data.numoptional_treasures or 0
	self.optional_treasures = data.optional_treasures or {}
	self.numrandom_treasures = data.numrandom_treasures or 0
	self.random_treasures = data.random_treasures or {}

	self.water_content = data.water_content or {}
	self.water_setpieces = data.water_setpieces or {}
	self.water_prefill_setpieces = data.water_prefill_setpieces or {}
	self.water_open_setpieces = data.water_open_setpieces or {}
end)

function Level:ApplyModsToTasks(tasklist)

	for i,task in ipairs(tasklist) do
		--print(i, "modding task "..task.id)
		local modfns = ModManager:GetPostInitFns("TaskPreInit", task.id)
		for i,modfn in ipairs(modfns) do
			print("Applying mod to task '"..task.id.."'")
			modfn(task)
		end
	end
end

function Level:GetOverridesForTasks(tasklist)
	-- Update the task with whatever overrrides are going
	local resources = require("map/resource_substitution")
	
	-- WE MAKE ONE SELECTION FOR ALL TASKS or ONE PER TASK
	for name, override in pairs(self.substitutes) do

		local substitute = resources.GetSubstitute(name)

		if name ~= substitute then
			print("Substituting [".. substitute.."] for [".. name.."]")
			for task_idx,val in ipairs(tasklist) do
				local chance = 	math.random()
				if chance < override.perstory then 
					if tasklist[task_idx].substitutes == nil then
						tasklist[task_idx].substitutes = {}
					end
					--print(task_idx, "Overriding", name, "with", substitute, "for:", self.name, chance, override.perstory )
					tasklist[task_idx].substitutes[name] = {name = substitute, percent = override.pertask}
				-- else
				-- 	print("NOT overriding ", name, "with", substitute, "for:", self.name, chance, override.perstory)

				end
			end
		end
	end

	return tasklist
end

function Level:GetTasksForLevel(sampletasks)
	--print("Getting tasks for level:", self.name)
	local tasklist = {}
	for i=1,#self.tasks do
		self:EnqueueATask(tasklist, self.tasks[i], sampletasks)
	end

	if self.numoptionaltasks and self.numoptionaltasks > 0 then
		local shuffletasknames = shuffleArray(self.optionaltasks)
		local numtoadd = self.numoptionaltasks
		local i = 1
		while numtoadd > 0 and i <= #self.optionaltasks do
			if type(self.optionaltasks[i]) == "table" then
				for i,taskname in ipairs(self.optionaltasks[i]) do
					self:EnqueueATask(tasklist, taskname, sampletasks)
					numtoadd = numtoadd - 1
				end
			else
				self:EnqueueATask(tasklist, self.optionaltasks[i], sampletasks)
				numtoadd = numtoadd - 1
			end
			i = i + 1
		end
	end

	for i = 1, #self.selectedtasks, 1 do
		local selectedtask = self.selectedtasks[i]
		local shuffletasknames = shuffleArray(selectedtask.task_choices)
		local numtoadd = math.random(selectedtask.min, selectedtask.max)
		local j = 1
		while numtoadd > 0 and i <= #selectedtask.task_choices do
			if type(selectedtask.task_choices[j]) == "table" then
				for i,taskname in ipairs(selectedtask.task_choices[j]) do
					self:EnqueueATask(tasklist, taskname, sampletasks)
					numtoadd = numtoadd - 1
				end
			else
				self:EnqueueATask(tasklist, selectedtask.task_choices[j], sampletasks)
				numtoadd = numtoadd - 1
			end
			j = j + 1
		end
	end

	for i = 1, self.numrandom_set_pieces do
		--Add random setpiece each loop.

		--Get random set piece to put in task
		local set_piece = self.random_set_pieces[math.random(#self.random_set_pieces)]
		
		--Get random task
		local task = tasklist[math.random(#tasklist)]

		if task.random_set_pieces == nil then
			task.random_set_pieces = {}
		end
		--print(set_piece)
		table.insert(task.random_set_pieces, set_piece)
	end

	for name, choicedata in pairs(self.set_pieces) do
		local found = false
		local idx = {}
		for i, task in ipairs(tasklist) do
			idx[task.id] = i
		end

		-- Pick one of the choces and add it to that task
		local choices = choicedata.tasks
		local count = choicedata.count or 1

		assert(choices, "Trying to add set piece '"..name.."' but no choices given.")

		-- Only one layout per task, so we stop when we run out of tasks or 
		while count > 0 and #choices > 0 do
			local idx_choice_offset = math.random(#choices) - 1 -- we'll convert back to 1-index in a moment
			-- To account for the fact that some of the choices might not exist in the level (i.e. option tasks) loop through them.
			for i=1,#choices do
				local idx_choice = ((idx_choice_offset + i)% #choices) + 1 -- convert back to 1-index
				local choice = idx[choices[idx_choice]]
				--print("choice", idx_choice, choice, #choices, choices[idx_choice], tasklist[choice])
				if tasklist[choice] then
					if tasklist[choice].set_pieces == nil then
						tasklist[choice].set_pieces = {}
					end
					table.insert(tasklist[choice].set_pieces, {name=name, restrict_to=choicedata.restrict_to})
					idx[choices[idx_choice]] = nil
					table.remove(choices, choice)
					break
				end
			end
			count = count-1
		end
	end

	--treasures

	--verify treasures exist
	--[[for i = 1, #self.random_treasures, 1 do
		local def = GetTreasureDefinition(self.random_treasures[i])
		assert(def ~= nil, "Treasure: '"..self.random_treasures[i].."' does not exist!, Check random_treasures in shipwrecked.lua")
	end
	for name, _ in pairs(self.treasures) do
		local def = GetTreasureDefinition(name)
		assert(def ~= nil, "Treasure: '"..name.."' does not exist!, Check treasures in shipwrecked.lua")
	end

	for i = 1, self.numrandom_treasures do
		local treasure = self.random_treasures[math.random(#self.random_treasures)]
		local task = tasklist[math.random(#tasklist)]
		if task.random_treasures == nil then
			task.random_treasures = {}
		end
		print(string.format("Adding treasure %s to %s random_treasures\n", treasure, task.id))
		table.insert(task.random_treasures, treasure)
	end

	for name, choicedata in pairs(self.treasures) do
		local found = false
		local idx = {}
		for i, task in ipairs(tasklist) do
			idx[task.id] = i
		end

		-- Pick one of the choces and add it to that task
		local choices = choicedata.tasks
		local count = choicedata.count or 1

		assert(choices, "Trying to add treasure '"..name.."' but no choices given.")

		-- Only one treasure per task, so we stop when we run out of tasks or 
		while count > 0 and #choices > 0 do
			local idx_choice_offset = math.random(#choices) - 1
			for i=1,#choices do
				local idx_choice = ((idx_choice_offset + i)% #choices) + 1 -- convert back to 1-index
				local choice = idx[choices[idx_choice] ]
				if tasklist[choice] then
					if tasklist[choice].treasures == nil then
						tasklist[choice].treasures = {}
					end
					print(string.format("Adding treasure %s to %s treasures\n", name, tasklist[choice].id))
					table.insert(tasklist[choice].treasures, {name=name, restrict_to=choicedata.restrict_to})
					idx[choices[idx_choice] ] = nil
					table.remove(choices, choice)
					break
				end
			end
			count = count-1
		end
	end]]

	self:ApplyModsToTasks(tasklist)
	
	self:GetOverridesForTasks(tasklist)

	return tasklist
end

function Level:EnqueueATask(tasklist, taskname, sampletasks)
	local task = self:GetTaskByName(taskname, sampletasks)
	if task then
		--print("\tChoosing task:",task.id)
		table.insert(tasklist, deepcopy(task))
	else
		assert(task, "Could not find a task called "..taskname)
	end
end

function Level:GetTaskByName(taskname, sampletasks)
	for j=1,#sampletasks do
		if string.upper(taskname) == string.upper(sampletasks[j].id) then
			return sampletasks[j]
		end
	end
	return nil
end

