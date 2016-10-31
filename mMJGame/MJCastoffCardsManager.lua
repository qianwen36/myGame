
local MJCastoffCardsManager = class("MJCastoffCardsManager")

function MJCastoffCardsManager:create(MJCastoffCards, gameController)
    return MJCastoffCardsManager.new(MJCastoffCards, gameController)
end

function MJCastoffCardsManager:ctor(MJCastoffCards, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._MJCastoffCards        = MJCastoffCards

    self:init()
end

function MJCastoffCardsManager:init()
    if not self._MJCastoffCards then return end

    self:resetCastoffCardsManager()
end

function MJCastoffCardsManager:resetCastoffCardsManager()
    if not self._MJCastoffCards then return end

    for i = 1, self._gameController:getTableChairCount() do
        local MJCastoffCards = self._MJCastoffCards[i]
        if MJCastoffCards then
            MJCastoffCards:resetMJCastoffCards()
        end
    end
end

function MJCastoffCardsManager:getMJCastoffCards(index)
    return self._MJCastoffCards[index]
end

function MJCastoffCardsManager:castoffCard(index, cardID)
    if self._MJCastoffCards[index] then
        self._MJCastoffCards[index]:castoffCard(cardID)
    end
end

function MJCastoffCardsManager:castoffCards(drawIndex, cardIDs, cardsCount)
    if self._MJCastoffCards[drawIndex] then
        self._MJCastoffCards[drawIndex]:castoffCards(cardIDs, cardsCount)
    end
end

return MJCastoffCardsManager
