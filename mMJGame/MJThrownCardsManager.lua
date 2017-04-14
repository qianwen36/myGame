
local MJThrownCardsManager = class("MJThrownCardsManager")

local MJCardThrown              = import(".MJCardThrown")

function MJThrownCardsManager:create(thrownCardsPanel, gameController)
    return MJThrownCardsManager.new(thrownCardsPanel, gameController)
end

function MJThrownCardsManager:ctor(thrownCardsPanel, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._thrownCardsPanel      = thrownCardsPanel
    self._thrownCards           = {}

    self:init()
end

function MJThrownCardsManager:init()
    if not self._thrownCardsPanel then return end

    for i = 1, self._gameController:getChairCardsCount() do
        local thrownCard = self._thrownCardsPanel:getChildByName("ThrowCard" .. tostring(i))
        if thrownCard then
            self._thrownCards[i] = MJCardThrown:create(thrownCard, self._drawIndex, self)
        end
    end

    self:resetHandCardsManager()
end

function MJThrownCardsManager:resetHandCardsManager()
    if not self._thrownCards then return end

    for i = 1, self._gameController:getTableChairCount() do
        local thrownCard = self._thrownCards[i]
        if thrownCard then
            thrownCard:resetCard()
        end
    end
end

function MJThrownCardsManager:onCardsThrow(drawIndex, id)
    local thrownCard = self._thrownCards[drawIndex]
    if thrownCard then
        thrownCard:setMJID(id)
        thrownCard:setVisible(true)
    end
end

function MJThrownCardsManager:isThrownCardVisible(drawIndex)
    local bThrownCardVisible = false
    local thrownCard = self._thrownCards[drawIndex]
    if thrownCard then
        bThrownCardVisible = thrownCard:isVisible()
    end
    return bThrownCardVisible
end

function MJThrownCardsManager:clearThrownCards()
    self:resetHandCardsManager()
end

function MJThrownCardsManager:clearThrownCard(drawIndex)
    local thrownCard = self._thrownCards[drawIndex]
    if thrownCard then
        thrownCard:resetCard()
    end
end

function MJThrownCardsManager:getLastThrownCardID(drawIndex)
    local lastThrownCardID = -1
    local thrownCard = self._thrownCards[drawIndex]
    if thrownCard and thrownCard:isVisible() then
        lastThrownCardID = thrownCard:getMJID()
    end
    return lastThrownCardID
end

return MJThrownCardsManager
