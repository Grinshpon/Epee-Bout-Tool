--main lua
display.setStatusBar(display.HiddenStatusBar)
local background = display.newImage("greyback.jpg", 0, 0)
--[[
local timeTool = require ("timer")
timeTool.Timer(1,5)
--]]
--dofile('timer.lua')

local count = 60 * 3
print(count)
local screenX, screenY = display.contentWidth, display.contentHeight

function writ(h)
	return math.floor(h/10)
end

function convertTime(s)
	local m = (math.floor(s/60)%60)
	s = s%60
	local os = writ(s)
	return (m .. " : " .. os .. " " .. s-os*10)
end

local counter1 = display.newText(convertTime(count),screenX/2,screenY/2,native.systemFont,40)
counter1:setFillColor( 1, 0.27, 0 )

function listener(event)
	print(count)
	count = count-1
	counter1.text=(convertTime(count))
	if count == 0 then
		print("Time is up")
		counter1:setFillColor( 1, 0, 0 )
		system.vibrate()
		local alarm = audio.loadSound("alarm.wav")
		audio.play(alarm, {loops = 0, duration = 2000,})
	end
end

timer1 = timer.performWithDelay(1000, listener, count)
timer.pause(timer1)
local isPaused = true
local left, right = 0,0
local ScoreLeft = display.newText(left,screenX/4,screenY/8,native.systemFont,40)
local ScoreRight = display.newText(right,screenX*3/4,screenY/8,native.systemFont,40)
ScoreLeft:setFillColor( 1, 0.27, 0 )
ScoreRight:setFillColor( 1, 0.27, 0 )

local widget = require( "widget" )
 
--Functions called by events
local function setTime(minutes)
	timer.cancel(timer1)
    count = 60*minutes
    counter1.text=(convertTime(count))
    counter1:setFillColor( 1, 0.27, 0 )
    timer1 = timer.performWithDelay(1000, listener, count)
    timer.pause(timer1)
	isPaused = true
end

local function rightPoint(point)
	right = right + point
	ScoreRight.text = (right)
end

local function leftPoint(point)
	left = left + point
	ScoreLeft.text = (left)
end

local function changeTime(oneSec)
	count = count + oneSec
	counter1.text=(convertTime(count))
	counter1:setFillColor( 1, 0.27, 0 )
end
 
-- Functions to handle button events
local function handleFive(event)
    if ( "ended" == event.phase ) then
		system.vibrate()
		if isPaused then
			print( "reset five" )
			setTime(5)
		end
    end
end

local function handleThree(event)
    if ( "ended" == event.phase ) then
        system.vibrate()
		if isPaused then
			print( "reset three" )
			setTime(3)
		end
    end
end

local function handleOne(event)
    if ( "ended" == event.phase ) then
        system.vibrate()
		if isPaused then
			print( "reset one" )
			setTime(1)
		end
    end
end

local function handleLeft(event)
    if ( "ended" == event.phase ) then
        system.vibrate()
		if isPaused then
        	print( "point left" )
        	leftPoint(1)
        end
    end
end

local function handleRight(event)
    if ( "ended" == event.phase ) then
    	system.vibrate()
		if isPaused then
        	print( "point right" )
	        rightPoint(1)
	    end
    end
end

local function minusLeft(event)
    if ( "ended" == event.phase ) then
        system.vibrate()
		if isPaused and left ~= 0 then
        	print( "subtract left" )
        	leftPoint(-1)
        end
    end
end

local function minusRight(event)
    if ( "ended" == event.phase ) then
    	system.vibrate()
		if isPaused and right ~= 0 then
        	print( "subtract right" )
	        rightPoint(-1)
	    end
    end
end

local function handleDouble(event)
    if ( "ended" == event.phase ) then
    	system.vibrate()
		if isPaused then
        	print( "double touch" )
	    	rightPoint(1)
			leftPoint(1)
	    end
    end
end

local function handleReset(event)
    if ( "ended" == event.phase ) then
    	system.vibrate()
		if isPaused then
        	print( "reset scores" )
	    	left,right = 0,0
	    	ScoreLeft.text = (left)
	    	ScoreRight.text = (right)
	    end
    end
end

local function handlePause(event)
    if ( "ended" == event.phase ) then
        system.vibrate()
		print( "pause/continue" )
        if isPaused then
        	timer.resume(timer1)
        	isPaused = false
        else
        	timer.pause(timer1)
        	isPaused = true
        end
    end
end

local function handleAdd(event)
    if ( "ended" == event.phase ) then
        system.vibrate()
		print( "add second" )
        if isPaused then
        	changeTime(1)
        end
    end
end

local function handleSub(event)
    if ( "ended" == event.phase ) then
        system.vibrate()
		print( "add second" )
        if isPaused then
        	changeTime(-1)
        end
    end
end

local pause = widget.newButton( --PAUSE
    {
        width = screenX,
        height = screenY/3.3,
        top = screenY/2 + screenY/14,
        defaultFile = "pauseDefault.png",
        overFile = "pauseOver.png",
        label = "Pause / Continue",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 32,
        onEvent = handlePause
    }
)
 
local buttonFive = widget.newButton( --FIVE MINUTES
    {
        width = screenX/3,
        height = screenY/10,
        top = screenY*3/4 + screenY/5.5,
		left = screenX*2/3,
        defaultFile = "buttonDefault.png",
        overFile = "buttonOver.png",
        label = "5:00",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 40,
        onEvent = handleFive
    }
)
local buttonThree = widget.newButton( --THREE MINUTES
    {
        width = screenX/3,
        height = screenY/10,
        top = screenY*3/4 + screenY/5.5,
		left = screenX/3+1,
        defaultFile = "buttonDefault.png",
        overFile = "buttonOver.png",
        label = "3:00",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 40,
        onEvent = handleThree
    }
)
local buttonOne = widget.newButton( --ONE MINUTE
    {
        width = screenX/3,
        height = screenY/10,
        top = screenY*3/4 + screenY/5.5,
		left = 1,
        defaultFile = "buttonDefault.png",
        overFile = "buttonOver.png",
        label = "1:00",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 40,
        onEvent = handleOne
    }
)
local buttonLeft = widget.newButton( --POINT LEFT
    {
        width = screenX/4,
        height = screenY/10,
        top = screenY/5,
        left = 0,
        defaultFile = "leftDefault.png",
        overFile = "leftOver.png",
        label = "+",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 40,
        onEvent = handleLeft
    }
)
local buttonRight = widget.newButton( --POINT RIGHT
    {
        width = screenX/4,
        height = screenY/10,
        top = screenY/5,
        left = screenX*3/4,
        defaultFile = "rightDefault.png",
        overFile = "rightOpen.png",
        label = "+",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 40,
        onEvent = handleRight
    }
)
local buttonLeft = widget.newButton( --SUBTRACT LEFT
    {
        width = screenX/4,
        height = screenY/10,
        top = screenY/5,
        left = screenX/4,
        defaultFile = "leftDefault.png",
        overFile = "leftOver.png",
        label = "-",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 40,
        onEvent = minusLeft
    }
)
local buttonRight = widget.newButton( --SUBTRACT RIGHT
    {
        width = screenX/4,
        height = screenY/10,
        top = screenY/5,
		left = screenX/2,
        defaultFile = "rightDefault.png",
        overFile = "rightOpen.png",
        label = "-",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 40,
        onEvent = minusRight
    }
)
local buttonDouble = widget.newButton( --DOUBLE TOUCH
    {
        width = screenX,
        height = screenY/10,
        top = screenY/5 + screenY/10,
        defaultFile = "doubleDefault.png",
        overFile = "doubleOpen.png",
        label = "Double Touch",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 24,
        onEvent = handleDouble,
    }
)
local buttonRight = widget.newButton( --RESET SCORE
    {
        width = screenY/15,
        height = screenY/15,
        top = screenY/12,
        left = screenX/2-screenY/30,
        defaultFile = "reset.png",
        overFile = "resetOver.png",
        fontSize = 40,
        onEvent = handleReset
    }
)
local buttonOne = widget.newButton( --ADD TIME
    {
        width = screenX/5,
        height = screenY/15,
        top = screenY/2-screenY/30,
		left = screenX*4/5-screenX/20,
        defaultFile = "doubleDefault.png",
        overFile = "buttonOver.png",
        label = "+ :01",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 25,
        onEvent = handleAdd
    }
)
local buttonOne = widget.newButton( --SUBTRACT TIME
    {
        width = screenX/5,
        height = screenY/15,
        top = screenY/2-screenY/30,
		left = screenX/20,
        defaultFile = "doubleDefault.png",
        overFile = "buttonOver.png",
        label = "- :01",
        labelColor = { default={ 0, 0, 0, 0.8 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 25,
        onEvent = handleSub
    }
)