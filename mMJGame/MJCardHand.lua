
local MJCardBase = import("src.app.Game.mMJGame.MJCardBase")
local MJCardHand = class("MJCardHand", MJCardBase)

function MJCardHand:ctor(MJCardNode, drawIndex, cardDelegate)    
    self._card                  = nil
    self._MJMask                = nil
    self._bMask                 = false
    self._MJPositionX           = 0
    self._MJPositionY           = 0
    self._MJPlanePositionX      = 0
    self._MJPlanePositionY      = 0
    self._MJOffsetY             = 50
    self._bTouched              = false
    self._bEnableTouch          = false
    self._bSelected             = false
    self._touchBegan            = false
    
    self._isSpecialGangCard     = false
    self._bHaiDiCard            = false
    MJCardHand.super.ctor(self, MJCardNode, drawIndex, cardDelegate)
end

function MJCardHand:init()

    MJCardHand.super.init(self)
    
    self._MJMask        = self._MJCardSprite:getChildByName("mask")
   self:setMask(false)
    
    if self._MJCardSprite then
        self._MJPositionX = self._MJCardSprite:getPositionX()
        self._MJPositionY = self._MJCardSprite:getPositionY()

        local plane = self._MJCardNode:getParent()
        self._MJPlanePositionX = plane:getPositionX()
        self._MJPlanePositionY = plane:getPositionY()
    end   
    self:setTouch()
end

function MJCardHand:setTouch()
    if not self._MJCardSprite then return end

    local listener = cc.EventListenerTouchOneByOne:create()

    listener:registerScriptHandler(function(touch, event)
        --print("touchBegan")
        if self._bTouched then
            if self:isSingleClk() then
            else
                if self:containsTouchLocation(touch:getLocation().x, touch:getLocation().y + self._MJOffsetY) then
                    self:touchBegan()
                end
            end
        else
            --print("touchBegan4")
            if self:isSelectCard() then
                print("touchBegan2")
                if self:containsTouchLocation(touch:getLocation().x, touch:getLocation().y + self._MJOffsetY) then
                    self:touchBegan()
                end
            else
                --print("touchBegan3")
                if self:containsTouchLocation(touch:getLocation().x, touch:getLocation().y) then
                    self:touchBegan()
                end
            end
        end
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function(touch, event)
        if self._bTouched then
            if self:isSingleClk() then
                if not self:containsTouchLocation(touch:getLocation().x, touch:getLocation().y + self._MJOffsetY) then
                    self:touchOut()
                end
            else
                if self:canMoveCard(touch:getLocation().y) then
                    self:touchMoved(touch:getLocation().x, touch:getLocation().y)
                elseif not self:containsTouchLocation(touch:getLocation().x, touch:getLocation().y + self._MJOffsetY) then
                    self:touchOut()
                else
                    self:touchOut()
                end
            end
        else
        end
        return true
    end, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function(touch, event)
        if self._bTouched then
            if self:isSelectCard() then
                if self:containsTouchLocation(touch:getLocation().x, touch:getLocation().y + self._MJOffsetY) then
                    self:touchEnd()
                end
            else
                if self:containsTouchLocation(touch:getLocation().x, touch:getLocation().y)  then
                    self:touchEnd()
                end
            end
        end
        return true
    end,
    cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self._MJCardSprite:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._MJCardSprite)
end

function MJCardHand:containsTouchLocation(x, y)
    if self:isMask() then return false  end
    local position = cc.p(self._MJCardNode:getPosition())
    local position1= cc.p(self._MJCardSprite:getPosition())
    local s = self._MJCardSprite:getContentSize()
    local touchRect
    if self:isSelectCard() then
        touchRect = cc.rect(position.x+ position1.x + self._MJPlanePositionX - (s.width/2), position.y + position1.y + self._MJPlanePositionY - (s.height/2), s.width, s.height+50)
    else
        touchRect = cc.rect(position.x+ position1.x + self._MJPlanePositionX - (s.width/2), position.y + position1.y + self._MJPlanePositionY - (s.height/2), s.width, s.height)
    end
    --local touchRect = cc.rect(position.x+ position1.x + self._MJPlanePositionX - (s.width/2), position.y + position1.y + self._MJPlanePositionY - (s.height/2), s.width, s.height+50)
    local b = cc.rectContainsPoint(touchRect, cc.p(x, y))
    return b
end

function MJCardHand:canMoveCard(touchPosY)
     if touchPosY > self._MJPositionY + self._MJCardSprite:getContentSize().height / 2  then
        return true
     end
     return false
end

function MJCardHand:touchBegan()
    if not self:isVisible() then return end
    if not self._bEnableTouch then return end
    if self:isSingleClk() then
        self._cardDelegate:resetCardsPos()
        self:selectCard()
        self._bTouched = true
    else
        if self:isSelectCard() then
            if self._cardDelegate:canThrow() then
                --print("self._cardDelegate:onThrowCard(%d)", self._MJID)
                self._cardDelegate:onThrowCard(self._MJID)
                self:resetCardPos()
                self:unSelectCard()
                self._bTouched = false
                self._touchBegan = false
            else
                self._bTouched = true
                self._touchBegan = true
            end
        else
            self._cardDelegate:unSelectCards()
            self._bTouched = true
            self._touchBegan = true
        end
    end
end

function MJCardHand:initSelState()
    self._bTouched = false
    self._touchBegan = false
    self:unSelectCard()
end

function MJCardHand:moveOver()
    if not self:isVisible() then return end
    if not self._bEnableTouch then return end

    if not self:isSelectCard()then
        self._cardDelegate:resetCardsPos()
        self:selectCard()
        self._bTouched = true
        self._touchBegan = true
    end
end

function MJCardHand:touchMoved(x, y)
    if not self:isVisible() then return end
    if not self._bEnableTouch then return end

    local position = cc.p(self._MJCardNode:getPosition())
    local s = self._MJCardSprite:getContentSize()
    local cardPosition = cc.p(position.x+ self._MJPlanePositionX , position.y + self._MJPlanePositionY )
    
    self._cardDelegate:resetCardsPos()
    if self._MJCardSprite then
        self._MJCardSprite:setPosition(x - cardPosition.x , y - cardPosition.y )
    end
end

function MJCardHand:resetCardPos()
    if self._MJCardSprite then
        self._MJCardSprite:setPosition(self._MJPositionX, self._MJPositionY)
    end
end

function MJCardHand:isRunning()
    if self._MJCardSprite then
        return self._MJCardSprite:numberOfRunningActions() > 0
    end
    return false
end

function MJCardHand:touchOut()
    if not self:isVisible() then return end
    if not self._bEnableTouch then return end

    print("touchOut")
    if self:isSingleClk() then
        self._bTouched = false
        self:unSelectCard()
    else
        self._bTouched = false
        self:unSelectCard()
        self._touchBegan = false
    end
end

function MJCardHand:touchEnd()
    if not self:isVisible() then return end
    if not self._bEnableTouch then return end

    if self:isSingleClk() then
        --print("self._cardDelegate:onThrowCard(%d)", self._MJID)
        self._cardDelegate:onThrowCard(self._MJID)
        self._bTouched = false
        self:unSelectCard()
    else
        if self:isMoveCard() then
            --print("self._cardDelegate:onThrowCard(%d)", self._MJID)
            self._cardDelegate:onThrowCard(self._MJID)
            self._cardDelegate:resetCardsPos()
            self:unSelectCard()
        elseif self:isSelectCard() then
            if self._touchBegan then
                self._touchBegan = false
                self._cardDelegate:resetCardsPos()
                --self:selectCard()
                self:unSelectCard()
            else
                if self._cardDelegate:canThrow() then

                else
                    self._cardDelegate:resetCardsPos()
                    self:unSelectCard()
                end
            end
        else
            self._cardDelegate:resetCardsPos()
            self:selectCard()
        end
        self._bTouched = false
    end
end

function MJCardHand:selectCard()
    if not self._MJCardSprite then return end

    self._MJCardSprite:setPosition(self._MJPositionX, self._MJPositionY + self._MJOffsetY)
    self._bSelected = true
end

function MJCardHand:unSelectCard()
    if not self._MJCardSprite then return end
    
    
    self._MJCardSprite:setPosition(self._MJPositionX, self._MJPositionY)
    self._bSelected = false
end

function MJCardHand:isSelectCard()    
    return self._bSelected
end

function MJCardHand:isMoveCard()
    if not self._MJCardSprite then return false end

    return self._MJCardSprite:getPositionY() > self._MJPositionY + self._MJOffsetY
end

function MJCardHand:resetCard()
    self:setEnableTouch(false)
    self:setMask(false)
    self._bSelected = false
    self._bHaiDiCard= false
    MJCardHand.super.resetCard(self)
end

function MJCardHand:setMask(bMask)
    self._bMask = bMask
    if self._MJMask then
        self._MJMask:setVisible(bMask)
    end
end

function MJCardHand:isMask()
    return self._bMask
end

function MJCardBase:getCardResName(resIndex)
    return     "res/GameCocosStudio/game/card/images/" ..self._resIndex.. ".png"
end

function MJCardHand:dealCard(lastDeal)
    if not self._MJCardSprite then return end

    self:setVisible(true)

    if self._cardDelegate:getMyDrawIndex() == self._drawIndex then
        local MJCardPosition = cc.p(self._MJCardSprite:getPositionX(), self._MJPositionY)
        self._MJCardSprite:setPosition(MJCardPosition.x, MJCardPosition.y + self._MJOffsetY)

        local dealAction = cc.MoveTo:create(0.3, MJCardPosition)
        if dealAction then
            self._MJCardSprite:runAction(cc.Sequence:create(dealAction, cc.CallFunc:create(function()
                self:dealCardCallback(lastDeal)
            end)))
        end
    else
        self:dealCardCallback(lastDeal)
    end
end

function MJCardHand:dealCardCallback(lastDeal)
    self._cardDelegate:onDealCardFinished(lastDeal)
end

function MJCardHand:setEnableTouch(enableTouch)
    self._bEnableTouch = enableTouch
end

function MJCardHand:catchCard(id)
    if not self._MJCardSprite then return end

    self:setMJID(id)
    self:setVisible(true)

    if self._cardDelegate:getMyDrawIndex() == self._drawIndex then
        local MJCardPosition = cc.p(self._MJCardSprite:getPositionX(), self._MJPositionY)
        self._MJCardSprite:setPosition(MJCardPosition.x, MJCardPosition.y + self._MJOffsetY)

        local dealAction = cc.MoveTo:create(0.3, MJCardPosition)
        if dealAction then
            self._MJCardSprite:runAction(cc.Sequence:create(dealAction, cc.CallFunc:create(function()
                self:catchCardCallback(id)
            end)))
        end
    else
        self:setVisible(false)
        self._MJCardSprite:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
            self:setVisible(true)
            self:catchCardCallback(id)
        end)))
    end
end

function MJCardHand:catchHaiDiCard(id)
    self:setHaiDiCard(true)   
    self:catchCard(id)
end

function MJCardHand:catchCardCallback(id)
    if self:isSpecialGangCard() then
        self._cardDelegate:onCatchSpecialGangCardFinished(id)
    elseif self:isHaiDiCard() then
        self._cardDelegate:onCatchHaiDiCardFinished(id)
    else
        self._cardDelegate:onCatchCardFinished(id)
    end
end

function MJCardHand:isSingleClk()
    if self._cardDelegate then
        return self._cardDelegate:isSingleClk()
    end
    return true
end

function MJCardHand:setSpecialGangCard(bGangCard)
    self._isSpecialGangCard = bGangCard
end

function MJCardHand:isSpecialGangCard()
    return self._isSpecialGangCard
end

function MJCardHand:setHaiDiCard(bHaiDi)
    self._bHaiDiCard = bHaiDi
end

function MJCardHand:isHaiDiCard()
    return self._bHaiDiCard
end

return MJCardHand
