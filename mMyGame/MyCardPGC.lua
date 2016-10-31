
local MJCardPGC = import("src.app.Game.mMJGame.MJCardPGC")
local MyCardPGC = class("MJCardPGC", MJCardPGC)

function MyCardPGC:getCardResName(resIndex)
    return "res/Game/GamePic/cardid/pgc/self/" ..self._resIndex.. ".png"
end

return MyCardPGC
