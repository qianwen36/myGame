
local MJCardCastoff = import("..mMJGame.MJCardCastoff")
local MyCardCastoff = class("MyCardCastoff", MJCardCastoff)

function MyCardCastoff:getCardResName(resIndex)
    return "res/Game/GamePic/cardid/castoff/self/" ..self._resIndex.. ".png"
end

return MyCardCastoff
