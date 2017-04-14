
local MJCardBase = import(".MJCardBase")
local MJCardThrown = class("MJCardThrown", MJCardBase)

function MJCardThrown:getCardResName(resIndex)
    return "res/Game/GamePic/cardid/hand/" ..self._resIndex.. ".png"
end

return MJCardThrown
