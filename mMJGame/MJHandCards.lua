
local MJHandCards = class("MJHandCards")

local MJCardHand                = import(".MJCardHand")
local MJCalculator              = import(".MJCalculator")

function MJHandCards:create(handCardsPanel, drawIndex, gameController)
    return MJHandCards.new(handCardsPanel, drawIndex, gameController)
end

function MJHandCards:ctor(handCardsPanel, drawIndex, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._handCardsPanel        = handCardsPanel
    self._drawIndex             = drawIndex
    self._cards                 = {}
    self._cardsCount            = 0
    self._bNeedThrow            = false

    self:init()
end

function MJHandCards:init()
    if not self._handCardsPanel then return end

    for i = 1, self._gameController:getChairCardsCount() do
        local card = self._handCardsPanel:getChildByName("HandCard" .. tostring(i))
        if card then
            self._cards[i] = MJCardHand:create(card, self._drawIndex, self)
        end
    end
end

function MJHandCards:getHandCardsPanel()
    return self._handCardsPanel
end

function MJHandCards:getMyDrawIndex()
    return self._gameController:getMyDrawIndex()
end

function MJHandCards:resetMJHandCards()
    if not self._cards then return end

    for i = 1, self._gameController:getChairCardsCount() do
        local card = self._cards[i]
        if card then
            card:resetCard()
        end
    end
    self:setVisible(true)
    self._bNeedThrow = false
end

function MJHandCards:getMJCardHand(index)
    return self._cards[index]
end

function MJHandCards:setVisible(visible)
    if self._handCardsPanel then
        self._handCardsPanel:setVisible(visible)
    end
end

function MJHandCards:onDealCard(dealCircles, bLastCircle)
    if not self._cards then return end

    local dealCount = self._gameController:getOnceDealCount()
    if bLastCircle then
        dealCount = 1
    end

    for i = 1, dealCount do
        local dealIndex = (dealCircles - 1) * self._gameController:getOnceDealCount() + i - 1
        local card = self._cards[self._gameController:getChairCardsCount() - dealIndex]
        if card then
            card:dealCard(false)
        end
    end
end

function MJHandCards:onDealLastCard()
    if not self._cards then return end

    local card = self._cards[1]
    if card then
        card:dealCard(true)
    end
end

function MJHandCards:onDealCardFinished(lastDeal)
    if lastDeal then
        self:setNeedThrow(true)
        self._gameController:onDealCardFinished()
    end
end

function MJHandCards:setEnableTouch(enableTouch)
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] and self._cards[i]:isVisible() then
            self._cards[i]:setEnableTouch(enableTouch)
        end
    end
end

function MJHandCards:sortHandCards()
    if not self:isCardsFaceShow() then return end

    local tableCards = {}
    for i = 1, self._gameController:getChairCardsCount() do
        table.insert(tableCards, i, self._cards[i])
    end

    local function comps(a, b) return a:getResIndex() > b:getResIndex() end
    table.sort(tableCards, comps)

    local tableCardIDs = {}
    for i = 1, self._gameController:getChairCardsCount() do
        table.insert(tableCardIDs, i, tableCards[i]:getMJID())
    end

    local startIndex = 2
    if self:needThrow() then
        startIndex = 1
    end
    local count = 0
    for i = 1, self._gameController:getChairCardsCount() - startIndex + 1 do
        if count > self._cardsCount then
            self._cards[i + startIndex - 1]:clearMJID()
        else
            self._cards[i + startIndex - 1]:setMJID(tableCardIDs[i])
            count = count + 1
        end 
    end
    if not self:needThrow() then
        self._cards[1]:clearMJID()
    end
end

function MJHandCards:setHandCardsCount(cardsCount)
    self._cardsCount = cardsCount
end

function MJHandCards:setHandCards(handCards)
    for i = 1, self._cardsCount do
        if not self._cards[i] then break end

        self._cards[self._gameController:getChairCardsCount() - i + 1]:setMJID(handCards[i])
    end
end

function MJHandCards:getHandCardIDs()
    local handCardIDs = {}
    local index = 1
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] and self._cards[i]:isVisible() and self._cards[i]:isValidateID(self._cards[i]:getMJID()) then
            handCardIDs[index] = self._cards[i]:getMJID()
            index = index + 1
        end
    end
    return handCardIDs
end

function MJHandCards:getFirstHandCardID()
    local firstHandCardID = -1
    if self._cards[1] then
        firstHandCardID = self._cards[1]:getMJID()
    end
    return firstHandCardID
end

function MJHandCards:setNeedThrow(bNeedThrow)
    self._bNeedThrow = bNeedThrow
end

function MJHandCards:needThrow()
    return self._bNeedThrow
end

function MJHandCards:canThrow()
    return self._cards[1] and self._cards[1]:isVisible() and self:needThrow()
end

function MJHandCards:getHandCardsCount()
    return self._cardsCount
end

function MJHandCards:onThrowCard(id)
    self._gameController:onThrowCard(id)
end

function MJHandCards:onCardsThrow(id)
    self:throwOneCard(id)
end

function MJHandCards:throwOneCard(id)
    if self:isCardsFaceShow() then
        local thrownCard = self:getCardByID(id)
        if thrownCard then
            self:removeOneCard(id)
        end
    else
        self:cardsCountDecrease()
    end
    self:setNeedThrow(false)
    self:sortHandCards()
    self:updateHandCards()
end

function MJHandCards:getCardByID(id)
    local card = nil
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] and self._cards[i]:getMJID() == id and self._cards[i]:isVisible() then
            card = self._cards[i]
            break
        end
    end
    return card
end

function MJHandCards:removeFirstCard()
    self:removeCard(1)
end

function MJHandCards:removeCard(index)
    if self._cards[index] then
        self._cards[index]:resetCard()
    end
end

function MJHandCards:onCardCaught(id)
    if not self:canThrow() then
        self:catchCard(id)
    end
end

function MJHandCards:catchCard(id)
    if not self:isMySelf() then
        id = -1
    end
    self:resetCardsPos()
    if self._cards[1] then
        self._cards[1]:catchCard(id)
    end
end

function MJHandCards:onCatchCardFinished(id)
    if self:isMySelf() then
        if self._cards[1] then
            self._cards[1]:setEnableTouch(true)
        end
    end
    self:setNeedThrow(true)
    self:cardsCountIncrease()
    self._gameController:onCatchCardFinished(self._drawIndex, id)
end

function MJHandCards:onCardHua(cardID, cardGot)
    if self:canThrow() then
        self:throwOneCard(cardID)
    end
    self:catchCard(cardGot)
end

function MJHandCards:isMySelf()
    return self._drawIndex == self:getMyDrawIndex()
end

function MJHandCards:onCardPeng(baseIDs)
    self:removeHandCards(baseIDs, 2)
    self:setNeedThrow(true)
    self:sortHandCards()
    self:updateHandCards()
    self:setEnableTouch(true)
end

function MJHandCards:onCardChi(baseIDs)
    self:removeHandCards(baseIDs, 2)
    self:setNeedThrow(true)
    self:sortHandCards()
    self:updateHandCards()
    self:setEnableTouch(true)
end

function MJHandCards:onCardMnGang(baseIDs, cardGot)
    self:removeHandCards(baseIDs, 3)
    self:setNeedThrow(false)
    self:sortHandCards()
    self:updateHandCards()
    self:catchCard(cardGot)
    self:setEnableTouch(true)
end

function MJHandCards:onCardAnGang(baseIDs, cardID, cardGot)
    self:removeHandCards(baseIDs, 3)
    self:removeHandCards({cardID}, 1)
    self:setNeedThrow(false)
    self:sortHandCards()
    self:updateHandCards()
    self:catchCard(cardGot)
    self:setEnableTouch(true)
end

function MJHandCards:onCardPnGang(cardID, cardGot)
    self:removeHandCards({cardID}, 1)
    self:setNeedThrow(false)
    self:sortHandCards()
    self:updateHandCards()
    self:catchCard(cardGot)
    self:setEnableTouch(true)
end

function MJHandCards:isCardsFaceShow()
    return self:isMySelf()
end

function MJHandCards:removeOneCard(cardID)
    self:removeHandCards({cardID}, 1)
end

function MJHandCards:removeHandCards(baseIDs, count)
    for i = 1, count do
        local cardID = baseIDs[i]
        if not self:isCardsFaceShow() then
            cardID = -1
        end

        local card = self:getCardByID(cardID)
        if card then
            card:clearMJID()
        end

        self:cardsCountDecrease()
    end
end

function MJHandCards:cardsCountIncrease()
    self._cardsCount = math.min(self._cardsCount + 1, self._gameController:getChairCardsCount())
end

function MJHandCards:cardsCountDecrease()
    self._cardsCount = math.max(self._cardsCount - 1, 0)
end

function MJHandCards:updateHandCards()
    if self:isCardsFaceShow() then
        for i = 1, self._gameController:getChairCardsCount() do
            local card = self._cards[i]
            if card and -1 == card:getMJID() then
                card:resetCard()
            end
        end
    else
        for i = 1, self._gameController:getChairCardsCount() do
            local card = self._cards[i]
            if card then
                card:resetCard()
            end
        end
    end

    local startIndex = 2
    if self:needThrow() then
        startIndex = 1
    end
    for i = 1, self._cardsCount do
        local card = self._cards[i + startIndex - 1]
        if card then
            card:setVisible(true)
        end
    end
end

function MJHandCards:maskSelfCardsForTing(tingCardsIndex)
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] and -1 < self._cards[i]:getMJID() and self._cards[i]:isVisible() then
            local bFind = false
            for j = 0, #tingCardsIndex do
                if tingCardsIndex[j] == MJCalculator:MJ_CalcIndexByID(self._cards[i]:getMJID(), 0) then
                    bFind = true
                    break
                end
            end
            if not bFind then
                self._cards[i]:setMask(true)
            end
        end
    end
end

function MJHandCards:maskCards()
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] then
            self._cards[i]:setMask(true)
        end
    end
end

function MJHandCards:unMaskCards()
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] then
            self._cards[i]:setMask(false)
        end
    end
end

function MJHandCards:isSingleClk()
    return self._gameController:isSingleClk()
end

function MJHandCards:unSelectCards()
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] then
            self._cards[i]:unSelectCard()
            self._cards[i]:initSelState()
        end
    end
end

function MJHandCards:resetCardsPos()
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] then
            if not self._cards[i]:isRunning() then
                self._cards[i]:resetCardPos()
            end
        end
    end
end

function MJHandCards:resetCardsState()
    for i = 1, self._gameController:getChairCardsCount() do
        if self._cards[i] then
            self._cards[i]:initSelState()
        end
    end
end

function MJHandCards:containsTouchLocation(x, y)
    local position = cc.p(self._handCardsPanel:getPosition())
    local s = self._handCardsPanel:getContentSize()
    local touchRect = cc.rect(position.x - s.width / 2, position.y - s.height / 2, s.width, s.height)
    local b = cc.rectContainsPoint(touchRect, cc.p(x, y))
    return b
end

return MJHandCards
