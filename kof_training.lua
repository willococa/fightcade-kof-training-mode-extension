assert(rb,"Run fbneo-training-mode.lua")


local p1hitstatus = 0x108172
local p2hitstatus = 0x108372

local in_air = 0x108322


local stateMachine = {
    currentState = "start",
    lastState = nil,
}
--[[ local trigger_recovery = true ]]
local function isInAir()
	 return rb(in_air)~=0
end




--[[ customconfig = {
	dummy_guard = 0,
	dummy_random_guard = 0,
	dummy_reversal = 0,
	dummy_recovery = 0,
	dummy_reversal_random = 0,
	}

dummy_guard = customconfig.dummy_guard
dummy_random_guard = customconfig.dummy_random_guard
dummy_recovery = customconfig.dummy_recovery
dummy_reversal = customconfig.dummy_reversal
dummy_reversal_random = customconfig.dummy_reversal_random ]]

--local reversal_move =0x62 -- 0x63 --standing punch
--local p2move_adress = 0x108373
local p2blockstun_address = 0x1083E3
local p2blockstun_value = 0xA0

-------------------------------------------------
--- POSIBBLE MEMORIE ADRESSES ----
-------------------------------------------------
--108477 dizzy timer- it stops counting when the oponent is dizzy
--1084b0 combo counter
--1084bb dummy has been grabbed
--1081a6 Player1 is in air = c0, d8 = standing, e0 = crouching
--108318 - 108319 Dummy stage position from 0020 (left corner) to 02e0  (right corner)
--if rb(0x10837E) == 1  then player 2 is in proximity block
-- 10837c == 00 think is oponent recovering ko


	function playerOneIsBeingHit()
		return rb(p1hitstatus)~=0
	end
	
	function playerTwoIsBeingHit()
		return rb(p2hitstatus)~=0
	end
	
local function playerTwoInBlockstun()
	if (rb(p2blockstun_address) == 0x20) or (rb(p2blockstun_address) == 0xA0) then
		return true
	end
	return false
end

local function getFacingDirection()
	if playerTwoFacingLeft() then
		return "P2 Left"
	end
	return "P2 Right"
end
local function getBlockingDirection()
	if playerTwoFacingLeft() then
		return "P2 Right"
	end
	return "P2 Left"
end


local function transitionToState(newState)
	stateMachine.lastState = stateMachine.currentState
    -- Logic for transitioning to a new state
    stateMachine.currentState = newState
    print("Transitioned to state:", newState)
    -- Additional logic for state transition...
end
local iddle_time_running = false
local iddle_finish_time = 0
local iddle_time = 80
local current_iddle_time = 0
local current_frame_count = 0
local last_frame = 0
local curent_frame = 0
local last_result_of_wakeup_enabled  = false
local function moveEnabled()
	local res = false
	curent_frame = emu.framecount()
	if curent_frame == last_frame then
		return last_result_of_wakeup_enabled
	end
	if (current_frame_count + iddle_finish_time) > iddle_time then
		iddle_finish_time = emu.framecount() + iddle_time
	end
	if iddle_time_running then
		--print("current iddle Time is: "..(current_iddle_time))
		if current_iddle_time == 0  then			
			iddle_time_running = false
			res = true
			last_result_of_wakeup_enabled = res
			last_frame = curent_frame
			return res
		end
		current_iddle_time = current_iddle_time - 1
		res = false
			last_result_of_wakeup_enabled = res
			last_frame = curent_frame
		return res
	end	
	res = true
		last_result_of_wakeup_enabled = res
		last_frame = curent_frame
	return res
end

local function startWakeupIddleTime()
	iddle_time_running = true
	current_frame_count = emu.framecount()
	iddle_finish_time = current_frame_count + iddle_time
	current_iddle_time = iddle_finish_time - current_frame_count
end
local delay_count = 0

local function delay(delay_frames, functionToExecute, ...)
    if delay_count < delay_frames then
        delay_count = delay_count + 1
        --print("DELAYED BY: ", delay_count)
        return false
    end

    if functionToExecute(...) then
		--print("function ended")
        delay_count = 0
    end
end

local current_move_index_counter = 1
local current_move_time_counter = 1
local function doMove(move_name, times, conf)
	--print("move is being executed")
	if (conf == nil) then conf = false end
	local seq = nil
	if (conf == false) then
		seq =  moves[move_name].sequence
	else  
		seq = KOF_CONFIG.MOVES[move_name].sequence
	end
	

	local tbl = {}

	if current_move_time_counter > times then	
		current_move_time_counter =1
		return true
	end

	if current_move_index_counter > #seq  then
		current_move_index_counter = 1	
		if 	current_move_time_counter == times then
			current_move_time_counter = 1
			return true
		else
			current_move_time_counter = current_move_time_counter + 1
		end
	end
	for index, value in ipairs(seq[current_move_index_counter]) do
		if value == 'forward' then
			tbl[getFacingDirection()] = 1
		elseif value == 'back' then
			tbl[getBlockingDirection()] = 1
		elseif value == 'down' then
			tbl["P2 Down"] = 1
		elseif value == 'up' then
			tbl["P2 Up"] = 1
		elseif value == 'a' then
			tbl["P2 Button A"] = 1
		elseif value == 'b' then
			tbl["P2 Button B"] = 1
		elseif value == 'c' then
			tbl["P2 Button C"] = 1
		elseif value == 'd' then
			tbl["P2 Button D"] = 1
		end
	end
	current_move_index_counter = current_move_index_counter +1
	joypad.set(tbl)
	return false
end

local move_index_counter = 1

function doMoves(moveList, callback)
	
    if #moveList == 0 then
        if callback then
            callback()  -- Trigger the callback if provided and there are no moves
        end
        return true  -- No moves to execute
    end
	if move_index_counter > #moveList then
		move_index_counter = 1
		if callback then
			callback()  -- Trigger the callback if provided and all moves are executed
		end
		return true -- All moves executed the specified number of times
	end

    local currentMove = moveList[move_index_counter]

    delay(currentMove.delay, function()
        local res = doMove(currentMove.name, currentMove.times, currentMove.conf)  -- Execute the current move once

        if res == true then
            move_index_counter = move_index_counter + 1
        end

        return res
    end)

    return true
end


local CURRENT_REVERSAL_MOVE_NAME = nil
local function getCurrentReversalMove(state)
	if (CURRENT_REVERSAL_MOVE_NAME) == nil then
		if state == "guard_reversal"	then
			if KOF_CONFIG.GUARD.reversal  == KOF_CONFIG.GUARD.REVERSAL_OPTIONS.RANDOM then
				CURRENT_REVERSAL_MOVE_NAME =KOF_CONFIG.GUARD.reversal_moves[math.random(1,  #KOF_CONFIG.GUARD.reversal_moves)]
			else
				CURRENT_REVERSAL_MOVE_NAME =KOF_CONFIG.GUARD.reversal_moves[1]
			end
		elseif state == "waking_up" then	
			if KOF_CONFIG.WAKEUP.reversal  == KOF_CONFIG.WAKEUP.REVERSAL_OPTIONS.RANDOM then
				CURRENT_REVERSAL_MOVE_NAME =KOF_CONFIG.WAKEUP.reversal_moves[math.random(1,  #KOF_CONFIG.WAKEUP.reversal_moves)]
			else
				CURRENT_REVERSAL_MOVE_NAME =KOF_CONFIG.WAKEUP.reversal_moves[1]
			end
		end
	end
	return CURRENT_REVERSAL_MOVE_NAME
end

local function resetCurrentReversalName()
	CURRENT_REVERSAL_MOVE_NAME = nil
end
local function buildReversal(reversal_name)
	local _reversal = KOF_CONFIG.REVERSAL_MOVES.MOVELIST:getReversal(reversal_name)
	return _reversal
end
local function doReversal(_name, _times)

	if doMove(_name, _times) then
		
		resetCurrentReversalName()
		return true
	end
	return false
end

local function dummyCrouchGuardForATime()
	return doMove("CROUCH_GUARD", 60, true)
end

local function dummyCrouchForATime()
	return doMove("CROUCH", 20, true)
end

local function dummyCrouchGuard()	
	local tbl = {}	
	tbl[getBlockingDirection()] = 1
	tbl["P2 Down"] = 1
	joypad.set(tbl)
end
-- Initial state
local previousButtonState = {}

local function playerOnePressedButtons()
    local tbl = joypad.get()
    local buttonsPressed = false

    if (tbl["P1 Button A"] and not previousButtonState["P1 Button A"]) or
       (tbl["P1 Button B"] and not previousButtonState["P1 Button B"]) or
       (tbl["P1 Button C"] and not previousButtonState["P1 Button C"]) or
       (tbl["P1 Button D"] and not previousButtonState["P1 Button D"]) then
        buttonsPressed = true
    end

    -- Update the previous button state for the next frame
    previousButtonState["P1 Button A"] = tbl["P1 Button A"]
    previousButtonState["P1 Button B"] = tbl["P1 Button B"]
    previousButtonState["P1 Button C"] = tbl["P1 Button C"]
    previousButtonState["P1 Button D"] = tbl["P1 Button D"]

    return buttonsPressed
end

local function dummyGuardForATime()
	return doMove('GUARD_BACK',10, true)
end

local cooldowns = {}  -- Table to store cooldowns for different functions
local functionRunningFlags = {}  -- flag to track whether a function is currently running


local function executeWithCooldown(func, cooldownDuration, funcName)
    if not cooldowns[funcName] or cooldowns[funcName] == 0 then
        if  func() then
            -- The function returned false, indicating it has finished executing
            cooldowns[funcName] = cooldownDuration  -- Set the cooldown
       
		else
			functionRunningFlags[funcName] = true -- Set the running flag
		end       
    end	
    if cooldowns[funcName] and cooldowns[funcName] > 0 then
        cooldowns[funcName] = cooldowns[funcName] - 1
		if(cooldowns[funcName]) == 0 then
			functionRunningFlags[funcName] = false-- Set the running flag
		end
	end
end





local function doNothing()
	--print('Doing nothing')
	return true
end

local start_press = false
local function block()
    -- Additional logic for blocking...
	if KOF_CONFIG.GUARD.standing_guard == 1 then
		if(start_press == false) then
			if playerOnePressedButtons()  then
				start_press = true
			end
		end
		if(start_press or  functionRunningFlags["dummyGuardForATime"] == true or functionRunningFlags['doNothing'] == true ) then			
			if start_press and KOF_CONFIG.GUARD.random_guard == 1 then
				local percentage_of_down = 50
				local randomNumber = math.random(1, 100)
				if(randomNumber <= percentage_of_down )then
					executeWithCooldown( doNothing, 20, "doNothing")
				else
					executeWithCooldown( dummyGuardForATime, 20, "dummyGuardForATime")
				end
				start_press = false
				return
			else
				executeWithCooldown( dummyGuardForATime, 20, "dummyGuardForATime")
				start_press = false
				return
			end

			if(functionRunningFlags["dummyGuardForATime"] ) then				
				executeWithCooldown( dummyGuardForATime, 20, "dummyGuardForATime")
			end
		
			if(functionRunningFlags["doNothing"] ) then				
				executeWithCooldown( doNothing, 20, "doNothing")
			end
		end
	end
	if KOF_CONFIG.GUARD.crouch_guard == 1 then
		
		if(start_press == false) then
			if playerOnePressedButtons()  then
				start_press = true
			end
		end
		if(start_press or   functionRunningFlags['dummyCrouchForATime'] == true ) then	
			local only_crouch_guard = false		
			if start_press and KOF_CONFIG.GUARD.random_guard == 1 then
				local percentage_of_down = 50
				local randomNumber = math.random(1, 100)
				if(randomNumber <= percentage_of_down )then
					executeWithCooldown( dummyCrouchForATime, 20, "dummyCrouchForATime")
				end
				start_press = false
				return
			else
				start_press = false
			end
			if(functionRunningFlags["dummyCrouchForATime"] ) then				
				executeWithCooldown( dummyCrouchForATime, 20, "dummyCrouchForATime")
				return
			end
				
		else
			dummyCrouchGuard()
		end
		--[[ if KOF_CONFIG.GUARD.random_guard == 1 then
			local percentage_of_down = 50
			local randomNumber = math.random(1, 100)
			if(randomNumber <= percentage_of_down )then
				dummyCrouchForATime()
			else
				dummyCrouchGuardForATime() 
			end
		else
			dummyCrouchGuardForATime()		
		end ]]
	end
end
local active_wake_up =false
local function isOnWakeUp()
	return rb(0x108321) > 0
end
local function closeToGround()
	return rb(0x108321) < 20 and rb(0x108321) >  5
end
local function isWakeUpTime()
	return rb(0x108321) == 0  
end

local function conditionsFor(_state)
	if _state == "recovery" then
		 local res = false
		 res = KOF_CONFIG.RECOVERY.dummy_recovering  and closeToGround() and moveEnabled()
		return  res
	else
		error("the state provided is not known")
	end
end


local dont_recover = false
local recovery_enabled = false
local set_config = true
function Run() -- runs every frame
--[[ 	if set_config then
		setDefaultConfig(KOF_CONFIG.TRAINING.CONFIGURATIONS["cd_pressure_1"])
		set_config=false
	end ]]
	moveEnabled() --this function has to run every frame to make sure the moves are able to run
	 if stateMachine.currentState == "start" then
        -- Logic for the "start" state
        -- Additional logic specific to the "start" state...
		if conditionsFor("recovery") then			
			transitionToState("recovering")		
		elseif KOF_CONFIG.GUARD.dummy_guarding  then
        	transitionToState("blocking")  -- Transition to the "blocking" state

		elseif KOF_CONFIG.WAKEUP.dummy_waking_up and not KOF_CONFIG.RECOVERY.dummy_recovering  then
			if (moveEnabled()) then			
				if(isOnWakeUp() and active_wake_up == false) then
					active_wake_up = true
					transitionToState("waking_up")
				end
			end
		end
	elseif stateMachine.currentState == "blocking" then
		if conditionsFor("recovery") then	
			--print("conditions met")		
			transitionToState("recovering")	
			return	
		end
		if not KOF_CONFIG.GUARD.dummy_guarding then
			transitionToState("start")
			return
		end
		if KOF_CONFIG.WAKEUP.dummy_waking_up then
			if (moveEnabled()) then			
				if(isOnWakeUp() and active_wake_up == false) then
					active_wake_up = true
					transitionToState("waking_up")
				end
			end
		end
		if  playerTwoInBlockstun() and KOF_CONFIG.GUARD.reversal ~= KOF_CONFIG.GUARD.REVERSAL_OPTIONS.OFF then
			transitionToState("guard_reversal")
		end
		block()
	elseif stateMachine.currentState == "waking_up" then
		if(isWakeUpTime() and active_wake_up == true and moveEnabled()) then
	
			local reversal_name = getCurrentReversalMove("waking_up")
			local reversal = buildReversal(reversal_name)
			delay(reversal.on_wake_up_delay, function ()
				local res = doReversal(reversal.name, reversal.on_wake_up_times)
				if res  then
					startWakeupIddleTime()
					active_wake_up=false
					resetCurrentReversalName()					
					if KOF_CONFIG.GUARD.dummy_guarding then
						transitionToState("blocking")  -- Transition to the "blocking" state
					else
						transitionToState("start")
						startWakeupIddleTime()
					end
				end
				return res
			end) --for state waking up
		end
	elseif stateMachine.currentState == "guard_reversal" then
		local reversal_name = getCurrentReversalMove("guard_reversal")
	local reversal = buildReversal(reversal_name)
	delay(reversal.on_guard_delay, function ()
		local res = doReversal(reversal.name, reversal.on_guard_times)
		if res  then
			startWakeupIddleTime()
			active_wake_up=false					
			if KOF_CONFIG.GUARD.dummy_guarding then
				transitionToState("blocking")  -- Transition to the "blocking" state
			else
				transitionToState("start")
				startWakeupIddleTime()
			end
		end
		return res
	end) --for state guard_reversal		
		 
	elseif stateMachine.currentState == "recovering" then
		
		if KOF_CONFIG.RECOVERY.recovery == KOF_CONFIG.RECOVERY.OPTIONS.RANDOM and not recovery_enabled and moveEnabled() then
			local percentage_of_success = 50
			local randomNumber = math.random(1, 100)
			if(randomNumber <= percentage_of_success )then
				dont_recover = true
				recovery_enabled = false
			else 
				recovery_enabled = true
			end
		elseif KOF_CONFIG.RECOVERY.recovery == KOF_CONFIG.RECOVERY.OPTIONS.ON then
			recovery_enabled = true
		end
		if dont_recover then
			--print("not recovering")
			delay(10, function()
				
				dont_recover = false
				recovery_enabled = false
				startWakeupIddleTime()
				transitionToState("start")
				return true
			end
			)
			return
		end			
		if  recovery_enabled == true then
			--print("recovery is enabled")
			local recovery_moves = {}
			table.insert(recovery_moves,{ name = "AB", delay = KOF_CONFIG.RECOVERY.delay, times = KOF_CONFIG.RECOVERY.times, conf = true } )
			if KOF_CONFIG.WAKEUP.dummy_waking_up and moveEnabled()then
				--print("activate d the wakeup reversal")
				local reversal_name = getCurrentReversalMove("waking_up")
				local reversal = buildReversal(reversal_name)
				table.insert(recovery_moves,{ name = reversal.name, delay = reversal.on_wake_up_delay, times = reversal.on_wake_up_times } )
			end
			doMoves(recovery_moves,function()
				--print("All moves executed!")
				recovery_enabled = false
				if KOF_CONFIG.WAKEUP.dummy_waking_up then 
					startWakeupIddleTime()
					resetCurrentReversalName()
				end
				if KOF_CONFIG.GUARD.dummy_guarding then
					transitionToState("blocking")
				else
					transitionToState("start")
				end
			end)
		end							
	
	end
	infiniteTime()
end
