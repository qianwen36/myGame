
local MJCastoffCards = import("src.app.Game.mMJGame.MJCastoffCards")
local MyCastoffCards = class("MyCastoffCards", MJCastoffCards)

local MyCardCastoff             = import("src.app.Game.mMyGame.MyCardCastoff")

function MyCastoffCards:init()
    if not self._castoffCardsPanel then return end

    for i = 1, self._gameController:getChairCastoffCardsCount() do
        local card = self._castoffCardsPanel:getChildByName("CastoffCard" .. tostring(i))
        if card then
            self._cards[i] = MyCardCastoff:create(card, self._drawIndex, self)
        end
    end
end

return MyCastoffCards
