
local MJCardBase = class("MJCardBase")

local MJGameDef                 = import(".MJGameDef")

local MJCalculator              = import(".MJCalculator")

function MJCardBase:create(MJCardSprite, drawIndex, cardDelegate)
    return MJCardBase.new(MJCardSprite, drawIndex, cardDelegate)
end

function MJCardBase:ctor(MJCardSprite, drawIndex, cardDelegate)
    if not cardDelegate then printError("cardDelegate is nil!!!") return end
    self._cardDelegate          = cardDelegate

    self._MJCardSprite          = MJCardSprite
    self._drawIndex             = drawIndex

    self._MJID                  = -1
    self._resIndex              = -1
    self._cardFaceSprite        = nil

    self:init()
end

function MJCardBase:init()
    if not self._MJCardSprite then return end

    self._cardFaceSprite = cc.Sprite:create()
    if self._cardFaceSprite then
        self._cardFaceSprite:setAnchorPoint(1, 1)
        self._MJCardSprite:addChild(self._cardFaceSprite)
        self._cardFaceSprite:setPosition(cc.p(self._MJCardSprite:getContentSize().width, self._MJCardSprite:getContentSize().height))
    end
end

function MJCardBase:resetCard()
    self:setVisible(false)
    self._MJID = -1
    self._resIndex = -1
end

function MJCardBase:setVisible(visible)
    if self._MJCardSprite then
        self._MJCardSprite:setVisible(visible)
    end
    if self._cardFaceSprite then
        local bFaceVisible = visible
        if self._MJID == -1 then
            bFaceVisible = false
        end
        self._cardFaceSprite:setVisible(bFaceVisible)
    end
end

function MJCardBase:isValidateID(id)
    return -1 < id and MJGameDef.MJ_MAX_CARDID > id
end

function MJCardBase:setMJID(id)
    if self:isValidateID(id) then
        self._MJID = id
        if self._cardFaceSprite then
            self._resIndex = self:getCardResIndex(id)
            local resName = self:getCardResName(self._resIndex)
            if resName then
                local resSprite = cc.Sprite:create(resName)
                if resSprite then
                    local rect = cc.rect(0, 0, resSprite:getContentSize().width, resSprite:getContentSize().height)
                    local cardFaceFrame = cc.SpriteFrame:create(resName, rect)
                    if cardFaceFrame then
                        self._cardFaceSprite:setSpriteFrame(cardFaceFrame)
                        self._cardFaceSprite:setVisible(true)
                    end
                end
            end
        end
    elseif MJGameDef.MJ_CARD_BACK_ID == id then
        self._MJID = id
        self._resIndex = MJGameDef.MJ_CARD_BACK_ID
        if self._cardFaceSprite then
            local resName = self:getCardResName(self._resIndex)
            if resName then
                local resSprite = cc.Sprite:create(resName)
                if resSprite then
                    local rect = cc.rect(0, 0, resSprite:getContentSize().width, resSprite:getContentSize().height)
                    local cardFaceFrame = cc.SpriteFrame:create(resName, rect)
                    if cardFaceFrame then
                        self._cardFaceSprite:setSpriteFrame(cardFaceFrame)
                        self._cardFaceSprite:setVisible(true)
                    end
                end
            end
        end
    else
        self._MJID = -1
        self._resIndex = -1
        if self._cardFaceSprite then
            self._cardFaceSprite:setVisible(false)
        end
    end
end

function MJCardBase:clearMJID()
    self:setMJID(-1)
end

function MJCardBase:getCardResName(resIndex)
    return nil
end

function MJCardBase:getCardResIndex(cardID)
    local resIndex = 0
    local cardShape = MJCalculator:MJ_CalculateCardShapEx(cardID)
    local cardValue = MJCalculator:MJ_CalculateCardValueEx(cardID)

    if 0 == cardShape then
        resIndex = cardValue - 1
    elseif 1 == cardShape then
        resIndex = 8 + cardValue
    elseif 2 == cardShape then
        resIndex = 17 + cardValue
    elseif 3 == cardShape then
        resIndex = 26 + cardValue
    elseif 4 == cardShape then
        resIndex = 33 + cardValue
    end

    return resIndex
end

function MJCardBase:getMJID()
    return self._MJID
end

function MJCardBase:getResIndex()
    return self._resIndex
end

function MJCardBase:isVisible()
    return self._MJCardSprite and self._MJCardSprite:isVisible()
end

function MJCardBase:getContentSize()
    if self._MJCardSprite then
        return self._MJCardSprite:getContentSize()
    end
    return cc.p(0, 0)
end

return MJCardBase
