
local MJCardBase = import(".MJCardBase")
local MJCardCastoff = class("MJCardCastoff", MJCardBase)

function MJCardCastoff:getCardResName(resIndex)
    local resName = nil
    if self._drawIndex == 2 then
        resName = "res/Game/GamePic/cardid/pgc/left/" ..self._resIndex.. ".png"
    elseif self._drawIndex == 4 then
        resName = "res/Game/GamePic/cardid/pgc/right/" ..self._resIndex.. ".png"
    else
        resName = "res/Game/GamePic/cardid/castoff/self/" ..self._resIndex.. ".png"
    end
    return resName
end

return MJCardCastoff
