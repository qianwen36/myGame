
local MJChoseCardsManager = class("MJChoseCardsManager")

local MJGameDef                 = import(".MJGameDef")

local MJChoseCardsItem          = import(".MJChoseCardsItem")
local MJCalculator              = import(".MJCalculator")

function MJChoseCardsManager:create(choseCardsPanel, gameController)
    return MJChoseCardsManager.new(choseCardsPanel, gameController)
end

function MJChoseCardsManager:ctor(choseCardsPanel, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._choseCardsPanel       = choseCardsPanel

    self._currentIndex          = 1
    self._choseItems            = {}

    self:init()
end

function MJChoseCardsManager:init()
    if not self._choseCardsPanel then return end

    self:resetMJChoseCardsManager()
end

function MJChoseCardsManager:resetMJChoseCardsManager()
    self:removeAllChildren()

    self._currentIndex = 1
    self._choseItems = {}
end

function MJChoseCardsManager:getMyDrawIndex()
    return self._gameController:getMyDrawIndex()
end

function MJChoseCardsManager:removeAllChildren()
    if not self._choseCardsPanel then return end

    local choseCardsPanelChildren = self._choseCardsPanel:getChildren()
    for i = 1, self._choseCardsPanel:getChildrenCount() do
        local child = choseCardsPanelChildren[i]
        if child then
            self._choseCardsPanel:removeChild(child, true)
        end
    end
end

function MJChoseCardsManager:showChiUnit(chiUnit, cardID)
    self:resetMJChoseCardsManager()

    self:sortChiUnit(chiUnit)
    self:addChiUnitNode(chiUnit, cardID)
end

function MJChoseCardsManager:showGangUnit(anGangUnit, pnGangUnit)
    self:resetMJChoseCardsManager()

    self:sortGangUnit(anGangUnit)
    self:addGangUnitNode(anGangUnit, pnGangUnit)
end

function MJChoseCardsManager:sortChiUnit(chiUnit)
    if 4 == #chiUnit then
        if MJCalculator:MJ_CalcIndexByID(chiUnit[1], 0) > MJCalculator:MJ_CalcIndexByID(chiUnit[3], 0) then
            local tempUnit = {chiUnit[1], chiUnit[2]}
            chiUnit[1] = chiUnit[3]
            chiUnit[2] = chiUnit[4]
            chiUnit[3] = tempUnit[1]
            chiUnit[4] = tempUnit[2]
        end
    elseif 6 == #chiUnit then
        if MJCalculator:MJ_CalcIndexByID(chiUnit[1], 0) > MJCalculator:MJ_CalcIndexByID(chiUnit[5], 0) then
            local tempUnit = {chiUnit[1], chiUnit[2]}
            chiUnit[1] = chiUnit[5]
            chiUnit[2] = chiUnit[6]
            chiUnit[5] = tempUnit[1]
            chiUnit[6] = tempUnit[2]
        end
    end
end

function MJChoseCardsManager:sortGangUnit(gangUnit)
    if 8 == #gangUnit then
        if MJCalculator:MJ_CalcIndexByID(gangUnit[1], 0) > MJCalculator:MJ_CalcIndexByID(gangUnit[5], 0) then
            local tempUnit = {gangUnit[1], gangUnit[2], gangUnit[3], gangUnit[4]}
            gangUnit[1] = gangUnit[5]
            gangUnit[2] = gangUnit[6]
            gangUnit[3] = gangUnit[7]
            gangUnit[4] = gangUnit[8]
            gangUnit[5] = tempUnit[1]
            gangUnit[6] = tempUnit[2]
            gangUnit[7] = tempUnit[3]
            gangUnit[8] = tempUnit[4]
        end
    elseif 12 == #gangUnit then
        if MJCalculator:MJ_CalcIndexByID(gangUnit[1], 0) > MJCalculator:MJ_CalcIndexByID(gangUnit[9], 0) then
            local tempUnit = {gangUnit[1], gangUnit[2], gangUnit[3], gangUnit[4]}
            gangUnit[1] = gangUnit[9]
            gangUnit[2] = gangUnit[10]
            gangUnit[3] = gangUnit[11]
            gangUnit[4] = gangUnit[12]
            gangUnit[9] = tempUnit[1]
            gangUnit[10] = tempUnit[2]
            gangUnit[11] = tempUnit[3]
            gangUnit[12] = tempUnit[4]
        end
    end
end

function MJChoseCardsManager:addChiUnitNode(chiUnit, cardID)
    if self._choseCardsPanel then
        for i = 1, #chiUnit, 2 do
            local baseIDs = {}
            baseIDs[1] = chiUnit[i]
            baseIDs[2] = chiUnit[i + 1]
            if baseIDs[1] and baseIDs[2] then
                local choseCardsNode = MJChoseCardsItem:create(self, baseIDs, cardID, MJGameDef.MJ_TYPE_CHI)
                if choseCardsNode then
                    self._choseCardsPanel:addChild(choseCardsNode)
                    self._choseItems[self._currentIndex] = choseCardsNode
                    self._currentIndex = self._currentIndex + 1
                end
            end
        end

        self:adjustChoseCardsItemsPos()
    end
end

function MJChoseCardsManager:addGangUnitNode(anGangUnit, pnGangUnit)
    if self._choseCardsPanel then
        for i = 1, #anGangUnit, 4 do
            local baseIDs = {}
            baseIDs[1] = anGangUnit[i]
            baseIDs[2] = anGangUnit[i + 1]
            baseIDs[3] = anGangUnit[i + 2]
            local cardID = anGangUnit[i + 3]
            if baseIDs[1] and baseIDs[2] and baseIDs[3] and cardID then
                local choseCardsNode = MJChoseCardsItem:create(self, baseIDs, cardID, MJGameDef.MJ_TYPE_ANGANG)
                if choseCardsNode then
                    self._choseCardsPanel:addChild(choseCardsNode)
                    self._choseItems[self._currentIndex] = choseCardsNode
                    self._currentIndex = self._currentIndex + 1
                end
            end
        end

        for i = 1, #pnGangUnit, 4 do
            local baseIDs = {}
            baseIDs[1] = pnGangUnit[i]
            baseIDs[2] = pnGangUnit[i + 1]
            baseIDs[3] = pnGangUnit[i + 2]
            local cardID = pnGangUnit[i + 3]
            if baseIDs[1] and baseIDs[2] and baseIDs[3] and cardID then
                local choseCardsNode = MJChoseCardsItem:create(self, baseIDs, cardID, MJGameDef.MJ_TYPE_PNGANG)
                if choseCardsNode then
                    self._choseCardsPanel:addChild(choseCardsNode)
                    self._choseItems[self._currentIndex] = choseCardsNode
                    self._currentIndex = self._currentIndex + 1
                end
            end
        end

        self:adjustChoseCardsItemsPos()
    end
end

function MJChoseCardsManager:adjustChoseCardsItemsPos()
    local choseCardsSpace = MJGameDef.MJ_CHOSECARDS_SPACE

    local width = choseCardsSpace
    for i = 1, self._currentIndex - 1 do
        local choseCardsItem = self._choseItems[i]
        if choseCardsItem then
            width = width + choseCardsItem:getContentSize().width + choseCardsSpace
        end
    end

    local posStartX = 0
    local posStartY = 0

    if self._choseCardsPanel then
        posStartX = self._choseCardsPanel:getContentSize().width / 2 - width / 2 + choseCardsSpace
    end

    for i = 1, self._currentIndex - 1 do
        local choseCardsItem = self._choseItems[i]
        if choseCardsItem then
            choseCardsItem:setPosition(posStartX, posStartY)
            posStartX = posStartX + choseCardsItem:getContentSize().width + choseCardsSpace
        end
    end
end

function MJChoseCardsManager:choseCards(baseIDs, cardID, MJChoseCardsType)
    if MJChoseCardsType == MJGameDef.MJ_TYPE_CHI then
        self._gameController:playBtnPressedEffect()
        self._gameController:choseChiCards(baseIDs, cardID)
    elseif MJChoseCardsType == MJGameDef.MJ_TYPE_ANGANG then
        self._gameController:playBtnPressedEffect()
        self._gameController:choseAnGangCards(baseIDs, cardID)
    elseif MJChoseCardsType == MJGameDef.MJ_TYPE_PNGANG then
        self._gameController:playBtnPressedEffect()
        self._gameController:chosePnGangCards(baseIDs, cardID)
    end
end

return MJChoseCardsManager
