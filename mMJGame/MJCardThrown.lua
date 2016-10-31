
local MJCardBase = import("src.app.Game.mMJGame.MJCardBase")
local MJCardThrown = class("MJCardThrown", MJCardBase)

function MJCardThrown:getCardResName(resIndex)
    return     "res/GameCocosStudio/game/card/images/" ..self._resIndex.. ".png"
end

return MJCardThrown
