
local MJShowDownCards = import("src.app.Game.mMJGame.MJShowDownCards")
local MyShowDownCards = class("MyShowDownCards", MJShowDownCards)

local MyCardShowDown            = import("src.app.Game.mMyGame.MyCardShowDown")

function MyShowDownCards:init()
    if not self._showDownCardsPanel then return end

    for i = 1, self._gameController:getChairCastoffCardsCount() do
        local card = self._showDownCardsPanel:getChildByName("ShowDownCard" .. tostring(i))
        if card then
            self._cards[i] = MyCardShowDown:create(card, self._drawIndex, self)
        end
    end
end

return MyShowDownCards
