
local MJGameClock = import("src.app.Game.mMJGame.MJGameClock")
local MyGameClock = class("MyGameClock", MJGameClock)

function MyGameClock:setClockHand(drawIndex)
    if self._clockHand then
        local rotation = 0
        if 1 == drawIndex then
            rotation = 0
        elseif 2 == drawIndex then
            rotation = 180
        end

        self._clockHand:setRotation(rotation)
    end
end

function MyGameClock:moveClockHandTo(index)
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

return MyGameClock
