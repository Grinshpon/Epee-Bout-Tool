--timer lua
--[[
local M = {}
function M.Timer(n, count) --(period, how many times repeated)
    if count > 0 then
        local iter= os.time()+n
        while iter ~= os.time() do --Can implement pause function
        end
        M.onTime(count) --Call on 'tick'
        count = count - 1
        M.Timer(n,count)
    end
end
function M.onTime(count)
    display.newtext(count,250,50,native.systemFont,16)  
end
return M
--]]
function Timer(n, count) --(period, how many times repeated)
    if count > 0 then
        local iter= os.time()+n
        while iter ~= os.time() do --Can implement pause function
        end
        onTime(count) --Call on 'tick'
        count = count - 1
        Timer(n,count)
    end
end
function onTime(count)
    display.newText(count,250,50,native.systemFont,16)  
end
Timer(1,5)