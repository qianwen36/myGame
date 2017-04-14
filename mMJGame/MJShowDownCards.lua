
local MJShowDownCards = class("MJShowDownCards")

local MJCardShowDown            = import(".MJCardShowDown")
local MJCalculator              = import(".MJCalculator")

function MJShowDownCards:create(showDownCardsPanel, drawIndex, gameController)
    return MJShowDownCards.new(showDownCardsPanel, drawIndex, gameController)
end

function MJShowDownCards:ctor(showDownCardsPanel, drawIndex, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._showDownCardsPanel    = showDownCardsPanel
    self._drawIndex             = drawIndex
    self._cards                 = {}

    self:init()
end

function MJShowDownCards:init()
    if not self._showDownCardsPanel then return end

    for i = 1, self._gameController:getChairCastoffCardsCount() do
        local card = self._showDownCardsPanel:getChildByName("ShowDownCard" .. tostring(i))
        if card then
            self._cards[i] = MJCardShowDown:create(card, self._drawIndex, self)
        end
    end
end

function MJShowDownCards:getCastoffCardsPanel()
    return self._showDownCardsPanel
end

function MJShowDownCards:getMyDrawIndex()
    return self._gameController:getMyDrawIndex()
end

function MJShowDownCards:resetMJShowDownCards()
    if not self._cards then return end

    for i = 1, self._gameController:getChairCardsCount() do
        local card = self._cards[i]
        if card then
            card:resetCard()
        end
    end
    self:setVisible(true)
end

function MJShowDownCards:getMJCardShowDown(index)
    return self._cards[index]
end

function MJShowDownCards:setVisible(visible)
    if self._showDownCardsPanel then
        self._showDownCardsPanel:setVisible(visible)
    end
end

function MJShowDownCards:showDownCards(cardIDs, cardsCount, needThrow)
    local tableCards = {}
    for i = 1, cardsCount do
        table.insert(tableCards, i, cardIDs[i])
    end
    local function comps(a, b) return MJCalculator:MJ_CalcIndexByID(a, 0) > MJCalculator:MJ_CalcIndexByID(b, 0) end
    table.sort(tableCards, comps)

    local startCardIndex = 2
    if needThrow then
        startCardIndex = 1
    end

    for i = 1, cardsCount do
        if tableCards[i] and -1 < tableCards[i] then
            local index = i + startCardIndex - 1
            if self._cards[index] then
                self._cards[index]:setMJID(tableCards[i])
                self._cards[index]:setVisible(true)
            end
        end
    end
end

function MJShowDownCards:showDownHuCard(huCard)
    if self._cards[1] then
        self._cards[1]:setMJID(huCard)
        self._cards[1]:setVisible(true)
    end
end

return MJShowDownCards
