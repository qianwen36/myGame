
local MJPGCCardsManager = class("MJPGCCardsManager")

function MJPGCCardsManager:create(MJPGCCards, gameController)
    return MJPGCCardsManager.new(MJPGCCards, gameController)
end

function MJPGCCardsManager:ctor(MJPGCCards, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._MJPGCCards            = MJPGCCards

    self:init()
end

function MJPGCCardsManager:init()
    if not self._MJPGCCards then return end

    self:resetPGCCardsManager()
end

function MJPGCCardsManager:resetPGCCardsManager()
    if not self._MJPGCCards then return end

    for i = 1, self._gameController:getTableChairCount() do
        local MJPGCCards = self._MJPGCCards[i]
        if MJPGCCards then
            MJPGCCards:resetMJPGCCards()
        end
    end
end

function MJPGCCardsManager:onCardPeng(drawIndex, sourceIndex, baseIDs, cardID)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardPeng(sourceIndex, baseIDs, cardID)
    end
end

function MJPGCCardsManager:onCardChi(drawIndex, sourceIndex, baseIDs, cardID)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardChi(sourceIndex, baseIDs, cardID)
    end
end

function MJPGCCardsManager:onCardMnGang(drawIndex, sourceIndex, baseIDs, cardID)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardMnGang(sourceIndex, baseIDs, cardID)
    end
end

function MJPGCCardsManager:onCardAnGang(drawIndex, sourceIndex, baseIDs, cardID)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardAnGang(sourceIndex, baseIDs, cardID)
    end
end

function MJPGCCardsManager:onCardPnGang(drawIndex, sourceIndex, baseIDs, cardID)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardPnGang(sourceIndex, baseIDs, cardID)
    end
end

function MJPGCCardsManager:getSelfPengCardIDs()
    local selfPengCardIDs = nil
    if self._MJPGCCards[self._gameController:getMyDrawIndex()] then
    
        selfPengCardIDs = self._MJPGCCards[self._gameController:getMyDrawIndex()]:getPengCardIDs()
    end
    return selfPengCardIDs
end

function MJPGCCardsManager:onCardPengs(drawIndex, pengCards, pengCardsCount)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardPengs(pengCards, pengCardsCount)
    end
end

function MJPGCCardsManager:onCardChis(drawIndex, chiCards, chiCardsCount)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardChis(chiCards, chiCardsCount)
    end
end

function MJPGCCardsManager:onCardMnGangs(drawIndex, mnGangCards, mnGangCardsCount)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardMnGangs(mnGangCards, mnGangCardsCount)
    end
end

function MJPGCCardsManager:onCardPnGangs(drawIndex, pnGangCards, pnGangCardsCount)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardPnGangs(pnGangCards, pnGangCardsCount)
    end
end

function MJPGCCardsManager:onCardAnGangs(drawIndex, anGangCards, anGangCardsCount)
    if self._MJPGCCards[drawIndex] then
        self._MJPGCCards[drawIndex]:onCardAnGangs(anGangCards, anGangCardsCount)
    end
end

function MJPGCCardsManager:onGameWin()
    for i = 1, self._gameController:getTableChairCount() do
        local MJPGCCards = self._MJPGCCards[i]
        if MJPGCCards then
            MJPGCCards:onGameWin()
        end
    end
end

return MJPGCCardsManager
