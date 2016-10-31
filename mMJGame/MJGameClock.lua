
local BaseGameClock = import("src.app.Game.mBaseGame.BaseGameClock")
local MJGameClock = class("MJGameClock", BaseGameClock)

function MJGameClock:ctor(clockPanel, gameController)
    self._drawIndex     = 0
    self._clockHand     = nil

    MJGameClock.super.ctor(self, clockPanel, gameController)
end

function MJGameClock:init()
    if self._clockPanel then
        self._clockHand = self._clockPanel:getChildByName("Clock_sp_hand")
    end

    MJGameClock.super.init(self)
end

function MJGameClock:step(dt)
    if self._clockPanel then
        if self._clockPanel then
            self._clockPanel:setVisible(0 < self._drawIndex and self._gameController:getTableChairCount() >= self._drawIndex)
        end
    end

    MJGameClock.super.step(self, dt)
end

function MJGameClock:setDrawIndex(drawIndex)
    self._drawIndex = drawIndex
    self:setClockHand(drawIndex)
end

function MJGameClock:getDrawIndex()
    return self._drawIndex
end

function MJGameClock:setClockHand(drawIndex)
    if self._clockHand then
        local rotation = 0
        if 1 == drawIndex then
            rotation = 0
        elseif 2 == drawIndex then
            rotation = 90
        elseif 3 == drawIndex then
            rotation = 180
        elseif 4 == drawIndex then
            rotation = 270
        end

        self._clockHand:setRotation(rotation)
    end
end

function MJGameClock:moveClockHandTo(index)
    if 0 >= self._drawIndex or self._gameController:getTableChairCount() < self._drawIndex then return end
    if 0 >= index or self._gameController:getTableChairCount() < index then return end

    self:setDrawIndex(index)

--    local clockHand = self._clockPanel:getChildByName("Clock_sp_hand")
--    if clockHand then
--        local angle = clockHand:getRotation() + 180
--        local actionTo = cc.RotateTo:create(0.3, angle)
--        clockHand:runAction(actionTo)
--    end
end

function MJGameClock:zeroClock()
    if 0 == self._gameZeroCount then
        self._gameController:onGameClockZero()
    end
    if self._gameZeroCount > 0 and self._gameZeroCount % 10 == 3 then
        self._gameController:onClockStop()
    end
end

return MJGameClock
