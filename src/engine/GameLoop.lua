local TICK_RATE = 1 / 60
local MAX_FRAME_SKIP = 25

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

    local lag = 0.0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end


		-- Update dt, as we'll be passing it to update
		if love.timer then
            dt = love.timer.step()
            lag = math.min(lag + dt, TICK_RATE * MAX_FRAME_SKIP)
        end

        while (lag >= TICK_RATE) do
    		-- Call update
    		if love.update then love.update(TICK_RATE) end -- will pass 0 if love.timer is disabled
            lag = lag - TICK_RATE
        end

        -- Draw
        if love.graphics and love.graphics.isActive() then render() end

        -- Even though we limit tick rate and not frame rate, we might want to cap framerate at 1000
        if love.timer then love.timer.sleep(0.001) end
	end
end

function render()
    love.graphics.origin()
    love.graphics.clear(love.graphics.getBackgroundColor())

    if love.draw then love.draw() end

    love.graphics.present()
end
