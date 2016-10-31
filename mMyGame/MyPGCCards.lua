
local MJPGCCards = import("src.app.Game.mMJGame.MJPGCCards")
local MyPGCCards = class("MJCardPGC", MJPGCCards)

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")
local MyPGCCardsItem            = import("src.app.Game.mMyGame.MyPGCCardsItem")

local PGCCARDS_SCALETIME        = {{1, 1, 1, 1, 1}, {1, 1, 0.9, 0.8, 0.75}, {1, 1, 1, 1, 1}, {1, 1, 0.9, 0.8, 0.75}}

function MyPGCCards:onCardChi(sourceIndex, baseIDs, cardID)
    baseIDs[3] = cardID
    self:sortIDs(baseIDs, 3)
    cardID = baseIDs[1]
    baseIDs[1] = baseIDs[2]
    baseIDs[2] = baseIDs[3]
    baseIDs[3] = -1
    self:onOpration(sourceIndex, baseIDs, cardID, MJGameDef.MJ_TYPE_CHI)
end

function MyPGCCards:onOpration(sourceIndex, baseIDs, cardID, type)
    if self._PGCCardsPanel then
        local pgcNode = MyPGCCardsItem:create(self, sourceIndex, baseIDs, cardID, type)
        if pgcNode then
            self:addPGCNode(pgcNode)
        end
    end
end

function MyPGCCards:getPGCItemPos(pgcIndex, scaleTime)
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
        local width = 0
        for i = 1, pgcIndex - 1 do
            local pgcItem = self._pgcItems[i]
            if pgcItem then
                width = width + pgcItem:getContentSize().width * scaleTime + MJGameDef.MJ_PGC_SPACE * scaleTime
            end
        end
        return cc.p(self._PGCCardsPanel:getContentSize().width / 2 - width, self._PGCCardsPanel:getContentSize().height / 2)
    end
end

return MyPGCCards
