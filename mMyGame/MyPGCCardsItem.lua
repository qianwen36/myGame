
local MJPGCCardsItem = import("..mMJGame.MJPGCCardsItem")
local MyPGCCardsItem = class("MyPGCCardsItem", MJPGCCardsItem)

local MJGameDef                 = import("..mMJGame.MJGameDef")
local MyCardPGC                 = import(".MyCardPGC")

local MJPGC_Table               = {{1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}}
local MJPGC_CARD_Table          = {{1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}}

function MyPGCCardsItem:initPGCCartItem()
    local drawIndex = self._MJPGCCards:getDrawIndex()
    local sourceIndex = MJPGC_Table[drawIndex][self._sourceIndex]
    local csbPath = "res/GameCocosStudio/game/PGCNode_" .. drawIndex .. sourceIndex .. ".csb"
    self._MJPGCItem = cc.CSLoader:createNode(csbPath)
    if self._MJPGCItem then
        self:addChild(self._MJPGCItem)
    end
end

function MyPGCCardsItem:setPGCCards()
    if self._MJPGCItem then
        local card = self._MJPGCItem:getChildByName("1")
        if card then
            local drawIndex = MJPGC_CARD_Table[self._MJPGCCards:getDrawIndex()][self._sourceIndex]
            self._MJPGCCardsList[1] = MyCardPGC:create(card, drawIndex, self)
        end

        for i = 2, 4 do
            local card = self._MJPGCItem:getChildByName(tostring(i))
            if card then
                self._MJPGCCardsList[i] = MyCardPGC:create(card, self._MJPGCCards:getDrawIndex(), self)
            end
        end
    end
end

function MyPGCCardsItem:setItemContentSize()
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
                width = width + card:getContentSize().width
                height = math.max(height, card:getContentSize().height)
            end
        end
    end
    self:setContentSize(width, height)
end

return MyPGCCardsItem
