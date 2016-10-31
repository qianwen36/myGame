
local MJPGCCards = class("MJPGCCards")

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")

local MJPGCCardsItem            = import("src.app.Game.mMJGame.MJPGCCardsItem")
local MJCalculator              = import("src.app.Game.mMJGame.MJCalculator")

local PGCCARDS_SCALETIME        = {{1, 1, 1, 1, 1}, {1, 1, 0.9, 0.8, 0.75}, {1, 1, 1, 1, 1}, {1, 1, 0.9, 0.8, 0.75}}

function MJPGCCards:create(PGCCardsPanel, drawIndex, gameController)
    return MJPGCCards.new(PGCCardsPanel, drawIndex, gameController)
end

function MJPGCCards:ctor(PGCCardsPanel, drawIndex, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._PGCCardsPanel         = PGCCardsPanel
    self._drawIndex             = drawIndex

    self._currentIndex          = 1
    self._pgcItems              = {}

    self:init()
end

function MJPGCCards:init()
    if not self._PGCCardsPanel then return end

    self:resetMJPGCCards()
end

function MJPGCCards:getDrawIndex()
    return self._drawIndex
end

function MJPGCCards:getMyDrawIndex()
    return self._gameController:getMyDrawIndex()
end

function MJPGCCards:resetMJPGCCards()
    self:removeAllChildren()
    self:setVisible(true)

    self._currentIndex = 1
    self._pgcItems = {}
end

function MJPGCCards:removeAllChildren()
    if not self._PGCCardsPanel then return end

    local PGCCardsPanelChildren = self._PGCCardsPanel:getChildren()
    for i = 1, self._PGCCardsPanel:getChildrenCount() do
        local child = PGCCardsPanelChildren[i]
        if child then
            self._PGCCardsPanel:removeChild(child, true)
        end
    end
end

function MJPGCCards:setVisible(visible)
    if self._PGCCardsPanel then
        self._PGCCardsPanel:setVisible(visible)
    end
end

function MJPGCCards:sortIDs(baseIDs, count)
    local tableCards = {}
    for i = 1, count do
        table.insert(tableCards, i, baseIDs[i])
    end
    local function comps(a, b) return MJCalculator:MJ_CalcIndexByID(a, 0) < MJCalculator:MJ_CalcIndexByID(b, 0) end
    table.sort(tableCards, comps)
    for i = 1, count do
        baseIDs[i] = tableCards[i]
    end
end

function MJPGCCards:onCardPeng(sourceIndex, baseIDs, cardID)
    self:onOpration(sourceIndex, baseIDs, cardID, MJGameDef.MJ_TYPE_PENG)
end

function MJPGCCards:onCardChi(sourceIndex, baseIDs, cardID)
    self:sortIDs(baseIDs, 2)
    self:onOpration(sourceIndex, baseIDs, cardID, MJGameDef.MJ_TYPE_CHI)
end

function MJPGCCards:onCardMnGang(sourceIndex, baseIDs, cardID)
    self:onOpration(sourceIndex, baseIDs, cardID, MJGameDef.MJ_TYPE_MNGANG)
end

function MJPGCCards:onCardAnGang(sourceIndex, baseIDs, cardID)
    self:onOpration(sourceIndex, baseIDs, cardID, MJGameDef.MJ_TYPE_ANGANG)
end

function MJPGCCards:onCardPnGang(sourceIndex, baseIDs, cardID)
    local pengItem = self:findPengItem(baseIDs)
    if pengItem then
        pengItem:setPnGangCard(cardID)
    end
end

function MJPGCCards:findPengItem(baseIDs)
    local pengItem = nil
    for i = 1, self._currentIndex - 1 do
        local pgcItem = self._pgcItems[i]
        if pgcItem then
            if pgcItem:canMatchID(baseIDs) then
                pengItem = pgcItem
                break
            end
        end
    end
    return pengItem
end

function MJPGCCards:onOpration(sourceIndex, baseIDs, cardID, type)
    if self._PGCCardsPanel then
        local pgcNode = MJPGCCardsItem:create(self, sourceIndex, baseIDs, cardID, type)
        if pgcNode then
            self:addPGCNode(pgcNode)
        end
    end
end

function MJPGCCards:addPGCNode(pgcNode)
    if self._PGCCardsPanel and pgcNode then
        self._PGCCardsPanel:addChild(pgcNode)

        self._pgcItems[self._currentIndex] = pgcNode
        self._currentIndex = self._currentIndex + 1

        self:adjustPGCItemsPos()
    end
end

function MJPGCCards:adjustPGCItemsPos()
    local scaleTime = PGCCARDS_SCALETIME[self._drawIndex][self._currentIndex]

    for i = 1, self._currentIndex - 1 do
        local pgcItem = self._pgcItems[i]
        if pgcItem then
            pgcItem:setScale(scaleTime)
            pgcItem:setPosition(self:getPGCItemPos(i, scaleTime))
        end
    end
end

function MJPGCCards:getPGCItemPos(pgcIndex, scaleTime)
    if 1 == self._drawIndex then
        local width = 0
        for i = 1, pgcIndex - 1 do
            local pgcItem = self._pgcItems[i]
            if pgcItem then
                width = width + pgcItem:getContentSize().width * scaleTime + MJGameDef.MJ_PGC_SPACE * scaleTime
            end
        end
        return cc.p(width, self._PGCCardsPanel:getContentSize().height / 2)
    elseif 2 == self._drawIndex then
        local height = 0
        for i = 1, pgcIndex - 1 do
            local pgcItem = self._pgcItems[i]
            if pgcItem then
                height = height + pgcItem:getContentSize().height * scaleTime + MJGameDef.MJ_PGC_SPACE * scaleTime
            end
        end
        return cc.p(self._PGCCardsPanel:getContentSize().width / 2, self._PGCCardsPanel:getContentSize().height - height)
    elseif 3 == self._drawIndex then
        local width = 0
        for i = 1, pgcIndex - 1 do
            local pgcItem = self._pgcItems[i]
            if pgcItem then
                width = width + pgcItem:getContentSize().width * scaleTime + MJGameDef.MJ_PGC_SPACE * scaleTime
            end
        end
        return cc.p(self._PGCCardsPanel:getContentSize().width - width, self._PGCCardsPanel:getContentSize().height / 2)
    elseif 4 == self._drawIndex then
        local height = 0
        for i = 1, pgcIndex - 1 do
            local pgcItem = self._pgcItems[i]
            if pgcItem then
                height = height + pgcItem:getContentSize().height * scaleTime + MJGameDef.MJ_PGC_SPACE * scaleTime
            end
        end
        return cc.p(self._PGCCardsPanel:getContentSize().width / 2, height)
    end
end

function MJPGCCards:getPengCardIDs()
    local pengCardIDs = {}
    local index = 1

    for i = 1, self._currentIndex - 1 do
        local pgcItem = self._pgcItems[i]
        if pgcItem then
            if pgcItem:getPGCType() == MJGameDef.MJ_TYPE_PENG then
                local pengIDs = pgcItem:getPengIDs()
                if pengIDs and 3 == #pengIDs then
                    for j = 1, 3 do
                        pengCardIDs[index] = pengIDs[j]
                        index = index + 1
                    end
                end
            end
        end
    end
    return pengCardIDs
end

function MJPGCCards:onCardPengs(pengCards, pengCardsCount)
    for i = 1, pengCardsCount do
        local drawIndex = self._gameController:rul_GetDrawIndexByChairNO(pengCards[i][2])
        if drawIndex then
            local baseIDs = {pengCards[i][1][1], pengCards[i][1][2], -1}
            local cardID = pengCards[i][1][3]
            self:onCardPeng(drawIndex, baseIDs, cardID)
        end
    end
end

function MJPGCCards:onCardChis(chiCards, chiCardsCount)
    for i = 1, chiCardsCount do
        local drawIndex = self._gameController:rul_GetDrawIndexByChairNO(chiCards[i][2])
        if drawIndex then
            local baseIDs = {chiCards[i][1][1], chiCards[i][1][2], -1}
            local cardID = chiCards[i][1][3]
            self:onCardChi(drawIndex, baseIDs, cardID)
        end
    end
end

function MJPGCCards:onCardMnGangs(mnGangCards, mnGangCardsCount)
    for i = 1, mnGangCardsCount do
        local drawIndex = self._gameController:rul_GetDrawIndexByChairNO(mnGangCards[i][2])
        if drawIndex then
            local baseIDs = {mnGangCards[i][1][1], mnGangCards[i][1][2], mnGangCards[i][1][3]}
            local cardID = mnGangCards[i][1][4]
            self:onCardMnGang(drawIndex, baseIDs, cardID)
        end
    end
end

function MJPGCCards:onCardPnGangs(pnGangCards, pnGangCardsCount)
    for i = 1, pnGangCardsCount do
        local drawIndex = self._gameController:rul_GetDrawIndexByChairNO(pnGangCards[i][2])
        if drawIndex then
            local baseIDs = {pnGangCards[i][1][1], pnGangCards[i][1][2], pnGangCards[i][1][3]}
            local cardID = pnGangCards[i][1][4]
            self:onCardPnGang(drawIndex, baseIDs, cardID)
        end
    end
end

function MJPGCCards:onCardAnGangs(anGangCards, anGangCardsCount)
    for i = 1, anGangCardsCount do
        local drawIndex = self._gameController:rul_GetDrawIndexByChairNO(anGangCards[i][2])
        if drawIndex then
            local baseIDs = {anGangCards[i][1][1], anGangCards[i][1][2], anGangCards[i][1][3]}
            local cardID = anGangCards[i][1][4]
            self:onCardAnGang(drawIndex, baseIDs, cardID)
        end
    end
end

function MJPGCCards:onGameWin()
    for i = 1, self._currentIndex - 1 do
        local pgcItem = self._pgcItems[i]
        if pgcItem then
            if pgcItem:getPGCType() == MJGameDef.MJ_TYPE_ANGANG and self:getDrawIndex() ~= self:getMyDrawIndex() then
                pgcItem:onShowDownAnGang()
            end
        end
    end
end

return MJPGCCards
