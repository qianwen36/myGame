
local MJCardShowDown = import("..mMJGame.MJCardShowDown")
local MyCardShowDown = class("MyCardShowDown", MJCardShowDown)

function MyCardShowDown:getCardResName(resIndex)
    return "res/Game/GamePic/cardid/castoff/self/" ..self._resIndex.. ".png"
end

return MyCardShowDown
