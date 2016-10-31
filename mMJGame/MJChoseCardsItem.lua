
local MJChoseCardsItem = class("MJChoseCardsItem", ccui.Layout)

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")

local MJCardChose               = import("src.app.Game.mMJGame.MJCardChose")
local MJCalculator              = import("src.app.Game.mMJGame.MJCalculator")

function MJChoseCardsItem:ctor(MJChoseCardsManager, baseIDs, cardID, choseCardstype)
    if not MJChoseCardsManager then printError("MJChoseCardsManager is nil!!!") return end
    self._MJChoseCardsManager   = MJChoseCardsManager

    self._MJChoseCardsType      = choseCardstype
    self._MJChoseItem           = nil
    self._MJChoseCardsList      = {}

    self._baseIDs               = baseIDs
    self._cardID                = cardID

    if self.onCreate then self:onCreate() end
end

function MJChoseCardsItem:onCreate()
    self:init()
end

function MJChoseCardsItem:init()
    self:initChoseCartItem()
    self:setChoseCards()
    self:setItemContentSize()
    self:setChoseCardsFace()
end

function MJChoseCardsItem:initChoseCartItem()
    local csbPath = ""
    if self._MJChoseCardsType == MJGameDef.MJ_TYPE_CHI then
        csbPath = "res/GameCocosStudio/game/ChoseChiNode.csb"
    elseif self._MJChoseCardsType == MJGameDef.MJ_TYPE_ANGANG then
        csbPath = "res/GameCocosStudio/game/ChoseAnGangNode.csb"
    elseif self._MJChoseCardsType == MJGameDef.MJ_TYPE_PNGANG then
        csbPath = "res/GameCocosStudio/game/ChosePnGangNode.csb"
    end
    self._MJChoseItem = cc.CSLoader:createNode(csbPath)
    if self._MJChoseItem then
        self:addChild(self._MJChoseItem)

        local function onItemClicked()
            self:onItemClicked()
        end
        local btnBG = self._MJChoseItem:getChildByName("Button_BG")
        if btnBG then
            btnBG:addClickEventListener(onItemClicked)
        end
    end
end

function MJChoseCardsItem:setChoseCards()
    if self._MJChoseItem then
        local len = 0
        if self._MJChoseCardsType == MJGameDef.MJ_TYPE_CHI then
            len = 3
        elseif self._MJChoseCardsType == MJGameDef.MJ_TYPE_ANGANG then
            len = 4
        elseif self._MJChoseCardsType == MJGameDef.MJ_TYPE_PNGANG then
            len = 1
        end
        for i = 1, len do
            local card = self._MJChoseItem:getChildByName(tostring(i))
            if card then
                self._MJChoseCardsList[i] = MJCardChose:create(card, self._MJChoseCardsManager:getMyDrawIndex(), self)
            end
        end
    end
end

function MJChoseCardsItem:setItemContentSize()
    local width = 0
    local height = 0

    for i = 1, #self._MJChoseCardsList do
        local card = self._MJChoseCardsList[i]
        if card then
            width = width + card:getContentSize().width
            height = math.max(height, card:getContentSize().height)
        end
    end

    if self._MJChoseItem then
        self._MJChoseItem:setContentSize(width, height)
    end

    self:setContentSize(width, height)
end

function MJChoseCardsItem:setChoseCardsFace()
    if self._MJChoseItem then
        for i = 1, #self._MJChoseCardsList do
            self._MJChoseCardsList[i]:resetCard()
        end

        local cardIDs = {}
        if self._MJChoseCardsType == MJGameDef.MJ_TYPE_CHI then
            cardIDs = {self._cardID, self._baseIDs[1], self._baseIDs[2]}
            self:sortIDs(cardIDs, 3)
        elseif self._MJChoseCardsType == MJGameDef.MJ_TYPE_ANGANG then
            cardIDs = {self._cardID, self._baseIDs[1], self._baseIDs[2], self._baseIDs[3]}
        elseif self._MJChoseCardsType == MJGameDef.MJ_TYPE_PNGANG then
            cardIDs = {self._cardID}
        end

        for i = 1, #cardIDs do
            if self._MJChoseCardsList[i] and cardIDs[i] and -1 ~= cardIDs[i] then
                self._MJChoseCardsList[i]:setMJID(cardIDs[i])
                self._MJChoseCardsList[i]:setVisible(true)
            end
        end
    end
end

function MJChoseCardsItem:sortIDs(cardIDs, count)
    local tableCards = {}
    for i = 1, count do
        table.insert(tableCards, i, cardIDs[i])
    end
    local function comps(a, b) return MJCalculator:MJ_CalcIndexByID(a, 0) < MJCalculator:MJ_CalcIndexByID(b, 0) end
    table.sort(tableCards, comps)
    for i = 1, count do
        cardIDs[i] = tableCards[i]
    end
end

function MJChoseCardsItem:onItemClicked()
    if not self:isVisible() then return end

    self._MJChoseCardsManager:choseCards(self._baseIDs, self._cardID, self._MJChoseCardsType)
end

return MJChoseCardsItem
