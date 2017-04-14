
local MJCastoffCards = class("MJCastoffCards")

local MJCardCastoff             = import(".MJCardCastoff")

function MJCastoffCards:create(castoffCardsPanel, drawIndex, gameController)
    return MJCastoffCards.new(castoffCardsPanel, drawIndex, gameController)
end

function MJCastoffCards:ctor(castoffCardsPanel, drawIndex, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._castoffCardsPanel     = castoffCardsPanel
    self._drawIndex             = drawIndex
    self._cards                 = {}

    self._currentIndex          = 1

    self:init()
end

function MJCastoffCards:init()
    if not self._castoffCardsPanel then return end

    for i = 1, self._gameController:getChairCastoffCardsCount() do
        local card = self._castoffCardsPanel:getChildByName("CastoffCard" .. tostring(i))
        if card then
            self._cards[i] = MJCardCastoff:create(card, self._drawIndex, self)
        end
    end
end

function MJCastoffCards:getCastoffCardsPanel()
    return self._castoffCardsPanel
end

function MJCastoffCards:getMyDrawIndex()
    return self._gameController:getMyDrawIndex()
end

function MJCastoffCards:resetMJCastoffCards()
    if not self._cards then return end

    for i = 1, self._gameController:getChairCastoffCardsCount() do
        local card = self._cards[i]
        if card then
            card:resetCard()
        end
    end
    self:setVisible(true)

    self._currentIndex = 1
end

function MJCastoffCards:getMJCardCastoff(index)
    return self._cards[index]
end

function MJCastoffCards:setVisible(visible)
    if self._castoffCardsPanel then
        self._castoffCardsPanel:setVisible(visible)
    end
end

function MJCastoffCards:castoffCard(cardID)
    if self._cards[self._currentIndex] then
        self._cards[self._currentIndex]:setMJID(cardID)
        self._cards[self._currentIndex]:setVisible(true)

        self._currentIndex = self._currentIndex + 1
    end
end

function MJCastoffCards:castoffCards(cardIDs, cardsCount)
    for i = 1, cardsCount do
        self:castoffCard(cardIDs[i])
    end
end

return MJCastoffCards
