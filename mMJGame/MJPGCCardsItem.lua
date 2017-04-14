
local MJPGCCardsItem = class("MJPGCCardsItem", ccui.Layout)

local MJGameDef                 = import(".MJGameDef")

local MJCalculator              = import(".MJCalculator")
local MJCardPGC                 = import(".MJCardPGC")

local MJPGC_Table               = {{2, 1, 2, 3}, {3, 2, 1, 2}, {2, 3, 2, 1}, {1, 2, 3, 2}}
local MJPGC_CARD_Table          = {{1, 4, 1, 2}, {3, 2, 3, 2}, {3, 4, 3, 2}, {3, 4, 3, 4}}

function MJPGCCardsItem:ctor(MJPGCCards, sourceIndex, baseIDs, cardID, type)
    if not MJPGCCards then printError("MJPGCCards is nil!!!") return end
    self._MJPGCCards            = MJPGCCards

    self._MJPGCItem             = nil
    self._MJPGCCardsList        = {}

    self._sourceIndex           = sourceIndex
    self._baseIDs               = baseIDs
    self._cardID                = cardID
    self._type                  = type

    if self.onCreate then self:onCreate() end
end

function MJPGCCardsItem:onCreate()
    self:init()
end

function MJPGCCardsItem:init()
    self:initPGCCartItem()
    self:setPGCCards()
    self:setItemContentSize()
    self:setPGCCardsFace()
end

function MJPGCCardsItem:initPGCCartItem()
    local drawIndex = self._MJPGCCards:getDrawIndex()
    local sourceIndex = MJPGC_Table[drawIndex][self._sourceIndex]
    local csbPath = "res/GameCocosStudio/game/PGCNode_" .. drawIndex .. sourceIndex .. ".csb"
    self._MJPGCItem = cc.CSLoader:createNode(csbPath)
    if self._MJPGCItem then
        self:addChild(self._MJPGCItem)
    end
end

function MJPGCCardsItem:setPGCCards()
    if self._MJPGCItem then
        local card = self._MJPGCItem:getChildByName("1")
        if card then
            local drawIndex = MJPGC_CARD_Table[self._MJPGCCards:getDrawIndex()][self._sourceIndex]
            self._MJPGCCardsList[1] = MJCardPGC:create(card, drawIndex, self)
        end

        for i = 2, 4 do
            local card = self._MJPGCItem:getChildByName(tostring(i))
            if card then
                self._MJPGCCardsList[i] = MJCardPGC:create(card, self._MJPGCCards:getDrawIndex(), self)
            end
        end
    end
end

function MJPGCCardsItem:setItemContentSize()
    local width = 0
    local height = 0

    local drawIndex = self._MJPGCCards:getDrawIndex()
    if 1 == drawIndex then
        for i = 1, 3 do
            local card = self._MJPGCCardsList[i]
            if card then
                width = width + card:getContentSize().width
                height = math.max(height, card:getContentSize().height)
            end
        end
    elseif 2 == drawIndex then
        for i = 1, 3 do
            local card = self._MJPGCCardsList[i]
            if card then
                height = height + card:getContentSize().height
                width = math.max(width, card:getContentSize().width)
            end
        end
        height = height - MJGameDef.MJ_PGC_HEIGHT_OFFSET
    elseif 3 == drawIndex then
        for i = 1, 3 do
            local card = self._MJPGCCardsList[i]
            if card then
                width = width + card:getContentSize().width
                height = math.max(height, card:getContentSize().height)
            end
        end
    elseif 4 == drawIndex then
        for i = 1, 3 do
            local card = self._MJPGCCardsList[i]
            if card then
                height = height + card:getContentSize().height
                width = math.max(width, card:getContentSize().width)
            end
        end
        height = height - MJGameDef.MJ_PGC_HEIGHT_OFFSET
    end
    self:setContentSize(width, height)
end

function MJPGCCardsItem:setPGCCardsFace()
    if self._MJPGCItem then
        for i = 1, 4 do
            self._MJPGCCardsList[i]:resetCard()
        end

        local cardID = -1
        local baseIDs = {}

        if self:getPGCType() == MJGameDef.MJ_TYPE_ANGANG then
            if self._MJPGCCards:getDrawIndex() == self._MJPGCCards:getMyDrawIndex() then
                for i = 1, 2 do
                    baseIDs[i] = MJGameDef.MJ_CARD_BACK_ID
                end
                baseIDs[3] = self._baseIDs[3]
            else
                for i = 1, 3 do
                    baseIDs[i] = MJGameDef.MJ_CARD_BACK_ID
                end
            end
            cardID = MJGameDef.MJ_CARD_BACK_ID
        else
            cardID = self._cardID
            baseIDs = self._baseIDs
        end

        if self._MJPGCCardsList[1] then
            self._MJPGCCardsList[1]:setMJID(cardID)
            self._MJPGCCardsList[1]:setVisible(true)
        end
        for i = 1, #self._baseIDs do
            if self._MJPGCCardsList[i + 1] and baseIDs[i] and -1 ~= baseIDs[i] then
                self._MJPGCCardsList[i + 1]:setMJID(baseIDs[i])
                self._MJPGCCardsList[i + 1]:setVisible(true)
            end
        end
    end
end

function MJPGCCardsItem:canMatchID(baseIDs)
    local bMatchID = true
    for i = 1, 3 do
        if not MJCalculator:MJ_IsSameCard(self._MJPGCCardsList[i]:getMJID(), baseIDs[i]) then
            bMatchID = false
            break
        end
    end
    return bMatchID
end

function MJPGCCardsItem:setPnGangCard(cardID)
    if self._MJPGCItem then
        if self._MJPGCCardsList[4] then
            self._MJPGCCardsList[4]:setMJID(cardID)
            self._MJPGCCardsList[4]:setVisible(true)
        end
    end
    self._type = MJGameDef.MJ_TYPE_PNGANG
end

function MJPGCCardsItem:getPGCType()
    return self._type
end

function MJPGCCardsItem:getPengIDs()
    if self._type == MJGameDef.MJ_TYPE_PENG then
        return {self._baseIDs[1], self._baseIDs[2], self._cardID}
    end
    return nil
end

function MJPGCCardsItem:onShowDownAnGang()
    if self._MJPGCCardsList[1] then
        self._MJPGCCardsList[1]:setMJID(self._cardID)
        self._MJPGCCardsList[1]:setVisible(true)
    end
    for i = 1, #self._baseIDs do
        if self._MJPGCCardsList[i + 1] and self._baseIDs[i] and -1 ~= self._baseIDs[i] then
            self._MJPGCCardsList[i + 1]:setMJID(self._baseIDs[i])
            self._MJPGCCardsList[i + 1]:setVisible(true)
        end
    end
end

return MJPGCCardsItem
