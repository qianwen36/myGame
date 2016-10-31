
local MJHandCardsManager = class("MJHandCardsManager")

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")

function MJHandCardsManager:create(MJHandCards, gameController)
    return MJHandCardsManager.new(MJHandCards, gameController)
end

function MJHandCardsManager:ctor(MJHandCards, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._MJHandCards           = MJHandCards
    self._dealCircles           = 1
    self._startDealIndex        = 0
    self._currentDealIndex      = 0
    self._bLastCircle           = false

    self._sortAnimaSprite       = nil

    self:init()
end

function MJHandCardsManager:init()
    if not self._MJHandCards then return end

    self:resetHandCardsManager()
    self:createSortCardsAnimation()
end

function MJHandCardsManager:resetHandCardsManager()
    if not self._MJHandCards then return end

    self._dealCircles           = 1
    self._startDealIndex        = 1
    self._currentDealIndex      = 1
    self._bLastCircle           = false

    if self.dealCardTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dealCardTimerID)
        self.dealCardTimerID = nil
    end
    if self.dealLastCardTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dealLastCardTimerID)
        self.dealLastCardTimerID = nil
    end

    for i = 1, self._gameController:getTableChairCount() do
        local MJHandCards = self._MJHandCards[i]
        if MJHandCards then
            MJHandCards:resetMJHandCards()
        end
    end
end

function MJHandCardsManager:getMJHandCards(index)
    return self._MJHandCards[index]
end

function MJHandCardsManager:createSortCardsAnimation()
    self._sortAnimaSprite = cc.Sprite:create()
    if self._sortAnimaSprite and self._MJHandCards[self._gameController:getMyDrawIndex()] then
        local selfHandCardsPanel = self._MJHandCards[self._gameController:getMyDrawIndex()]:getHandCardsPanel()
        if selfHandCardsPanel then
            self._sortAnimaSprite:setAnchorPoint(1, 0)
            self._sortAnimaSprite:setVisible(false)
            selfHandCardsPanel:addChild(self._sortAnimaSprite, 10)
        end
    end

    local action = cc.Animation:create()
    if action then
        local duration = 0.5
        local framecount = 8
        for i = 1, framecount do
            action:addSpriteFrameWithFile("res/Game/GamePic/sortcards/sortcards" .. i .. ".png")
        end
        action:setDelayPerUnit(duration / framecount)
        local animation = cc.Animate:create(action)
        if animation then
            self._sortAnimaSprite:runAction(cc.RepeatForever:create(animation))
        end
    end
end

function MJHandCardsManager:ope_DealCard()
    local function onDealCard(dt)
        self:onDealCard(dt)
    end

    self.dealCardTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onDealCard, MJGameDef.MJ_DEAL_CARDS_INTERVAL, false)
end

function MJHandCardsManager:onDealCard(dt)
    if not self._MJHandCards then return end
    assert(0 < self._currentDealIndex, "current deal Index error!")

    local MJHandCards = self._MJHandCards[self._currentDealIndex]
    if MJHandCards then
        MJHandCards:onDealCard(self._dealCircles, self._bLastCircle)
        self._gameController:playDealCardEffect()
    end

    local nextDealIndex = self:getNextDealIndex()
    if nextDealIndex == self._startDealIndex then
        if self._bLastCircle then
            if self.dealCardTimerID then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dealCardTimerID)
                self.dealCardTimerID = nil
            end

            local function onDealLastCard(dt)
                self:onDealLastCard(dt)
            end

            self.dealLastCardTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onDealLastCard, MJGameDef.MJ_DEAL_CARDS_INTERVAL * 3, false)
        else
            self._dealCircles = self._dealCircles + 1

            if self._dealCircles * self._gameController:getOnceDealCount() > self._gameController:getChairCardsCount() then
                self._bLastCircle = true
            end

            self._currentDealIndex = nextDealIndex
        end
    else
        self._currentDealIndex = nextDealIndex
    end
end

function MJHandCardsManager:onDealLastCard(dt)
    if self.dealLastCardTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dealLastCardTimerID)
        self.dealLastCardTimerID = nil
    end

    if not self._MJHandCards then return end

    local MJHandCards = self._MJHandCards[self._startDealIndex]
    if MJHandCards then
        MJHandCards:onDealLastCard()
        self._gameController:playDealCardEffect()
    end
end

function MJHandCardsManager:getNextDealIndex()
    if self._gameController then
        return self._gameController:getPreIndex(self._currentDealIndex)
    end
    return 0
end

function MJHandCardsManager:ope_SortCards()
    self:showSortCardsAnimation(true)
end

function MJHandCardsManager:ope_SortSelfHandCards()
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:sortHandCards()
    end
end

function MJHandCardsManager:ope_resetSelfCardsPos()
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:resetCardsPos()
    end
end

function MJHandCardsManager:ope_resetSelfCardsState()
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:resetCardsState()
    end
end

function MJHandCardsManager:showSortCardsAnimation(bFirstSort)
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        local selfHandCardsPanel = self._MJHandCards[self._gameController:getMyDrawIndex()]:getHandCardsPanel()
        if selfHandCardsPanel then
            if self._sortAnimaSprite then
                self._sortAnimaSprite:setPosition(selfHandCardsPanel:getPositionX() - selfHandCardsPanel:getContentSize().width / 2,
                    selfHandCardsPanel:getPositionY() - selfHandCardsPanel:getContentSize().height)

                local destPosition = cc.p(selfHandCardsPanel:getPositionX() + selfHandCardsPanel:getContentSize().width / 2,
                    selfHandCardsPanel:getPositionY() - selfHandCardsPanel:getContentSize().height)
                local sortMoveAction = cc.MoveTo:create(0.6, destPosition)
                local function startAction()
                    self:sortCardsAnimationBegan()
                end
                self._sortAnimaSprite:runAction(cc.Sequence:create(cc.CallFunc:create(startAction), sortMoveAction, cc.CallFunc:create(function(bFirstSort)
                    self:sortCardsAnimationFinished(bFirstSort)
                end)))
            end
        end
    end
end

function MJHandCardsManager:sortCardsAnimationBegan()
    self._sortAnimaSprite:setVisible(true)
end

function MJHandCardsManager:sortCardsAnimationFinished(bFirstSort)
    if self._sortAnimaSprite then
        self._sortAnimaSprite:setVisible(false)
    end

    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:sortHandCards()
    end

    if self._gameController then
        self._gameController:onSortCardsFinished(bFirstSort)
    end

    self:setEnableTouch(true)
end

function MJHandCardsManager:setEnableTouch(enableTouch)
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:setEnableTouch(enableTouch)
    end
end

function MJHandCardsManager:onGameExit()
    if self.dealCardTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dealCardTimerID)
        self.dealCardTimerID = nil
    end
    if self.dealLastCardTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dealLastCardTimerID)
        self.dealLastCardTimerID = nil
    end
end

function MJHandCardsManager:setStartIndex(startIndex)
    self._startDealIndex = startIndex
    self._currentDealIndex = startIndex
end

function MJHandCardsManager:setHandCardsCount(drawIndex, cardsCount)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:setHandCardsCount(cardsCount)
    end
end

function MJHandCardsManager:setSelfHandCards(handCards)
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:setHandCards(handCards)
    end
end

function MJHandCardsManager:updateHandCards(drawIndex)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:updateHandCards()
    end
end

function MJHandCardsManager:setNeedThrow(drawIndex, bNeedThrow)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:setNeedThrow(bNeedThrow)
    end
end

function MJHandCardsManager:needThrow(drawIndex)
    if self._MJHandCards[drawIndex] then
        return self._MJHandCards[drawIndex]:needThrow()
    end
    return false
end

function MJHandCardsManager:getSelfHandCardIDs()
    local selfHandCardIDs = nil
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        selfHandCardIDs = self._MJHandCards[self._gameController:getMyDrawIndex()]:getHandCardIDs()
    end
    return selfHandCardIDs
end

function MJHandCardsManager:getSelfFirstHandCardID()
    local selfFirstHandCardID = nil
        if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        selfFirstHandCardID = self._MJHandCards[self._gameController:getMyDrawIndex()]:getFirstHandCardID()
    end
    return selfFirstHandCardID
end

function MJHandCardsManager:maskSelfCardsForTing(tingCardsIndex)
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:maskSelfCardsForTing(tingCardsIndex)
    end
end

function MJHandCardsManager:maskSelfCards()
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:maskCards()
    end
end

function MJHandCardsManager:unMaskSelfCards()
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        self._MJHandCards[self._gameController:getMyDrawIndex()]:unMaskCards()
    end
end

function MJHandCardsManager:onCardsThrow(drawIndex, id)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardsThrow(id)
    end
end

function MJHandCardsManager:onCardCaught(drawIndex, id)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardCaught(id)
    end
end

function MJHandCardsManager:isNeedThrow(drawIndex)
    local bNeedThrow = false
    if self._MJHandCards[drawIndex] then
        bNeedThrow = self._MJHandCards[drawIndex]:needThrow()
    end
    return bNeedThrow
end

function MJHandCardsManager:onCardHua(drawIndex, cardID, cardGot)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardHua(cardID, cardGot)
    end
end

function MJHandCardsManager:onCardPeng(drawIndex, baseIDs)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardPeng(baseIDs)
    end
end

function MJHandCardsManager:onCardChi(drawIndex, baseIDs)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardChi(baseIDs)
    end
end

function MJHandCardsManager:onCardMnGang(drawIndex, baseIDs, cardGot)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardMnGang(baseIDs, cardGot)
    end
end

function MJHandCardsManager:onCardAnGang(drawIndex, baseIDs, cardID, cardGot)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardAnGang(baseIDs, cardID, cardGot)
    end
end

function MJHandCardsManager:onCardPnGang(drawIndex, cardID, cardGot)
    if self._MJHandCards[drawIndex] then
        self._MJHandCards[drawIndex]:onCardPnGang(cardID, cardGot)
    end
end

function MJHandCardsManager:containsTouchLocation(x, y)
    local b = false
    if self._MJHandCards[self._gameController:getMyDrawIndex()] then
        b = self._MJHandCards[self._gameController:getMyDrawIndex()]:containsTouchLocation(x, y)
    end
    return b
end

return MJHandCardsManager
