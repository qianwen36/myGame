
local Base = cc.load("mvc").ViewBase
local GameFrameScene = class("GameFrameScene", Base)

function GameFrameScene:ctor(app, name, param)
    Base.ctor(self, app, name, param)
end

function GameFrameScene:onCreate(param)
    self:init()
end

function GameFrameScene:init()
    self:createBaseLayer()
    self:createLoadingLayer()
end

function GameFrameScene:createBaseLayer()       end
function GameFrameScene:createGameLayer()       end
function GameFrameScene:createSysInfoLayer()    end
function GameFrameScene:createLoadingLayer()    end

function GameFrameScene:onEnter()
    self:nextSchedule(function()
        self:createGameLayer()
        self:createSysInfoLayer()
    end)
end

function GameFrameScene:onExit()
end

--[[
function GameFrameScene:nextSchedule( func, interval ) -- overload]]
function GameFrameScene:nextSchedule( func, arg, interval )
	local Scheduler = self:getScheduler()
	local timer
	interval = interval or tonumber(arg) or 0
	timer = Scheduler:scheduleScriptFunc(function ( ... )
		self:log(':nextSchedule( func )#timer=', tostring(timer), ', #func=', tostring(func))
		timer = timer and Scheduler:unscheduleScriptEntry(timer)
		func(self, arg)
	end, interval, false)
	return timer
end

return GameFrameScene
