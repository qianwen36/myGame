
local MJCardBase = import(".MJCardBase")
local MJCardPGC = class("MJCardPGC", MJCardBase)

function MJCardPGC:getCardResName(resIndex)
    local resName = nil
    if self._drawIndex == 2 then
        resName = "res/Game/GamePic/cardid/pgc/left/" ..self._resIndex.. ".png"
    elseif self._drawIndex == 3 then
        resName = "res/Game/GamePic/cardid/pgc/top/" ..self._resIndex.. ".png"
    elseif self._drawIndex == 4 then
        resName = "res/Game/GamePic/cardid/pgc/right/" ..self._resIndex.. ".png"
    else
        resName = "res/Game/GamePic/cardid/pgc/self/" ..self._resIndex.. ".png"
    end
    return resName
end

return MJCardPGC
