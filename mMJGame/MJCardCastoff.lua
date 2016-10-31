
local MJCardBase = import("src.app.Game.mMJGame.MJCardBase")
local MJCardCastoff = class("MJCardCastoff", MJCardBase)

function MJCardCastoff:getCardResName(resIndex)
    return     "res/GameCocosStudio/game/card/images/" ..self._resIndex.. ".png"
end

return MJCardCastoff
