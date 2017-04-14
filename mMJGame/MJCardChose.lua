
local MJCardBase = import(".MJCardBase")
local MJCardChose = class("MJCardChose", MJCardBase)

function MJCardChose:getCardResName(resIndex)
    return "res/Game/GamePic/cardid/hand/" ..self._resIndex.. ".png"
end

return MJCardChose
