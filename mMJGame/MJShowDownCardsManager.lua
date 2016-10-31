
local MJShowDownCardsManager = class("MJShowDownCardsManager")

function MJShowDownCardsManager:create(MJShowDownCards, gameController)
    return MJShowDownCardsManager.new(MJShowDownCards, gameController)
end

function MJShowDownCardsManager:ctor(MJShowDownCards, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._MJShowDownCards       = MJShowDownCards

    self:init()
end

function MJShowDownCardsManager:init()
    if not self._MJShowDownCards then return end

    self:resetShowDownCardsManager()
end

function MJShowDownCardsManager:resetShowDownCardsManager()
    if not self._MJShowDownCards then return end

    for i = 1, self._gameController:getTableChairCount() do
        local MJShowDownCards = self._MJShowDownCards[i]
        if MJShowDownCards then
            MJShowDownCards:resetMJShowDownCards()
        end
    end
end

function MJShowDownCardsManager:getMJShowDownCards(index)
    return self._MJShowDownCards[index]
end

function MJShowDownCardsManager:showDownCards(drawIndex, cardIDs, cardsCount, needThrow)
    if self._MJShowDownCards[drawIndex] then
        self._MJShowDownCards[drawIndex]:showDownCards(cardIDs, cardsCount, needThrow)
    end
end

function MJShowDownCardsManager:showDownHuCard(drawIndex, huCard)
    if self._MJShowDownCards[drawIndex] then
        self._MJShowDownCards[drawIndex]:showDownHuCard(huCard)
    end
end

return MJShowDownCardsManager
