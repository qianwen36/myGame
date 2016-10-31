
local MJPGCHManager = class("MJPGCHManager")

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")

local MJCalculator              = import("src.app.Game.mMJGame.MJCalculator")

local MJ_PGCH_FLAG              = {MJGameDef.MJ_PENG, MJGameDef.MJ_GANG, MJGameDef.MJ_CHI, MJGameDef.MJ_HU, MJGameDef.MJ_GUO}
local MJ_PGCH_SORT              = {MJGameDef.MJ_PGCH_HU, MJGameDef.MJ_PGCH_GANG, MJGameDef.MJ_PGCH_PENG, MJGameDef.MJ_PGCH_CHI, MJGameDef.MJ_PGCH_GUO}

function MJPGCHManager:create(PGCHPanel, gameController)
    return MJPGCHManager.new(PGCHPanel, gameController)
end

function MJPGCHManager:ctor(PGCHPanel, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._PGCHPanel             = PGCHPanel
    self._PGCHBtns              = {}
    self._btnpos                = {}

    self._cardsThrow            = nil
    self._cardCaught            = nil
    self._currentFlags          = 0

    self._reqChiCardInfo        = {}
    self._reqPengCardInfo       = {}
    self._reqMnGangCardInfo     = {}
    self._reqPnGangCardInfo     = {}
    self._reqAnGangCardInfo     = {}
    self._reqAnGangCardInfo     = {}
    self._reqThrowCardInfo      = {}

    self._waitingOperation      = 0

    self._qiangGangInfo         = {}

    self._canSpecialGangIndex   = nil
    self:init()
end

function MJPGCHManager:init()
    if self._PGCHPanel then
        self._PGCHPanel:setSwallowTouches(false)
    end

    self:setPGCHBtns()

    self:resetMJPGCHManager()
end

function MJPGCHManager:resetMJPGCHManager()
    self:hideAllChildren()
    self._cardsThrow            = nil
    self._cardCaught            = nil
    self._currentFlags          = 0

    self._reqChiCardInfo        = {}
    self._reqPengCardInfo       = {}
    self._reqMnGangCardInfo     = {}
    self._reqPnGangCardInfo     = {}
    self._reqAnGangCardInfo     = {}
    self._reqAnGangCardInfo     = {}

    self._waitingOperation      = 0
    self._qiangGangInfo         = {}
    
    self._canSpecialGangIndex   = nil
end

function MJPGCHManager:setPGCHBtns()
    if self._PGCHPanel then
        local function onPeng()
            self:onPeng()
        end
        local buttonPeng = self._PGCHPanel:getChildByName("Button_peng")
        if buttonPeng then
            buttonPeng:addClickEventListener(onPeng)
            self._PGCHBtns[MJGameDef.MJ_PGCH_PENG] = buttonPeng
            self._btnpos[MJGameDef.MJ_PGCH_PENG] = cc.p(buttonPeng:getPositionX(), buttonPeng:getPositionY())
        end

        local function onGang()
            self:onGang()
        end
        local buttonGang = self._PGCHPanel:getChildByName("Button_bu")
        if buttonGang then
            buttonGang:addClickEventListener(onGang)
            
            self._PGCHBtns[MJGameDef.MJ_PGCH_GANG] = buttonGang
            self._btnpos[MJGameDef.MJ_PGCH_GANG] = cc.p(buttonGang:getPositionX(), buttonGang:getPositionY())
        end

        local function onChi()
            self:onChi()
        end
        local buttonChi = self._PGCHPanel:getChildByName("Button_chi")
        if buttonChi then
            buttonChi:addClickEventListener(onChi)

            self._PGCHBtns[MJGameDef.MJ_PGCH_CHI] = buttonChi
            self._btnpos[MJGameDef.MJ_PGCH_CHI] = cc.p(buttonChi:getPositionX(), buttonChi:getPositionY())
        end

        local function onHu()
            self:onHu()
        end
        local buttonHu = self._PGCHPanel:getChildByName("Button_hu")
        if buttonHu then
            buttonHu:addClickEventListener(onHu)

            self._PGCHBtns[MJGameDef.MJ_PGCH_HU] = buttonHu
            self._btnpos[MJGameDef.MJ_PGCH_HU] = cc.p(buttonHu:getPositionX(), buttonHu:getPositionY())
        end

        local function onGuo()
            self:onGuo()
        end
        local buttonGuo = self._PGCHPanel:getChildByName("Button_pass")
        if buttonGuo then
            buttonGuo:addClickEventListener(onGuo)

            self._PGCHBtns[MJGameDef.MJ_PGCH_GUO] = buttonGuo
            self._btnpos[MJGameDef.MJ_PGCH_GUO] = cc.p(buttonGuo:getPositionX(), buttonGuo:getPositionY())
        end
    end
end

function MJPGCHManager:hideAllChildren()
    if not self._PGCHPanel then return end

    local PGCHPanelChildren = self._PGCHPanel:getChildren()
    for i = 1, self._PGCHPanel:getChildrenCount() do
        local child = PGCHPanelChildren[i]
        if child then
            child:setVisible(false)
        end
    end
end

function MJPGCHManager:setCardsThrow(cardsThrow)
    self._cardsThrow = cardsThrow
end

function MJPGCHManager:setCurrentFlags(flags)
    self._currentFlags = flags
end

function MJPGCHManager:getCurrentFlags()
    return self._currentFlags
end

function MJPGCHManager:setCanSpecialCardIndex(nIndexSpecialGang)
    self._canSpecialGangIndex = nIndexSpecialGang
end

function MJPGCHManager:getCanSpecialCardIndex()
    return self._canSpecialGangIndex
end

function MJPGCHManager:setCardCaught(cardCaught)
    self._cardCaught = cardCaught
    if cardCaught then
        if cardCaught.dwFlags then
            self:setCurrentFlags(cardCaught.dwFlags)
        end
        
        if cardCaught.nIndexSpecialGang then
            self:setCanSpecialCardIndex(cardCaught.nIndexSpecialGang)
        end
    end
end

function MJPGCHManager:getThrowIndex()
    if self._cardsThrow then
        return self._gameController:rul_GetDrawIndexByChairNO(self._cardsThrow.nChairNO)
    end
    return 0
end

function MJPGCHManager:canCatchCardAfterThrow()
    if not self._cardsThrow then return false end

    if self._gameController:getMyDrawIndex() ~= self._gameController:getNextIndex(self:getThrowIndex()) then
        return false
    end

    local canCatchCard = true
    for i = 1, self._gameController:getTableChairCount() do
        if self._cardsThrow.nChairNO ~= i - 1 then
            if 0 < self._cardsThrow.dwFlags[i] then
                canCatchCard = false
                break
            end
        end
    end
    return canCatchCard
end

function MJPGCHManager:needWaitHu(flags, drawIndex)
    for i = 1, self._gameController:getTableChairCount() do
        if drawIndex ~= self._gameController:rul_GetDrawIndexByChairNO(i) and drawIndex ~= self._gameController:getMyDrawIndex() then
            if MJGameDef.MJ_HU == flags[i] then
                return true
            end
        end
    end
    return false
end

function MJPGCHManager:ope_EnableOperate(index)
    if self._PGCHBtns[index] then
        self._PGCHBtns[index]:setVisible(true)
    end
end

function MJPGCHManager:onHu()
    self._gameController:playBtnPressedEffect()
    self._gameController:onHu()
end

function MJPGCHManager:onGang()
    self._gameController:playBtnPressedEffect()
    self._gameController:onGang()
end

function MJPGCHManager:onPeng()
    self._gameController:playBtnPressedEffect()
    self._gameController:onPeng()
end

function MJPGCHManager:onChi()
    self._gameController:playBtnPressedEffect()
    self._gameController:onChi()
end

function MJPGCHManager:onGuo()
    self._gameController:playBtnPressedEffect()
    self._gameController:onGuo()
end

function MJPGCHManager:showPGCHBtns()
    if not self._cardsThrow then return false end

    local myChairNO = self._gameController:getMyChairNO()
    for i = 1, #MJ_PGCH_FLAG do
        if self._gameController:IS_BIT_SET(self._cardsThrow.dwFlags[myChairNO + 1], MJ_PGCH_FLAG[i]) then
            if self._PGCHBtns[i] then
                self._PGCHBtns[i]:setVisible(true)
            end
        end
    end


    self:adjustPGCHBtnPos()
end

function MJPGCHManager:adjustPGCHBtnPos()
    local sortIndex = 1
    for i = 1, #MJ_PGCH_SORT do
        local sortBtn = self._PGCHBtns[MJ_PGCH_SORT[i]]
        if sortBtn and sortBtn:isVisible() then
            if self._btnpos[MJ_PGCH_SORT[sortIndex]] then
                sortBtn:setPosition(self._btnpos[MJ_PGCH_SORT[sortIndex]])
                sortIndex = sortIndex + 1
            end
        end
    end
end

function MJPGCHManager:hidePGCHBtns()
    for i = 1, 6 do
        if self._PGCHBtns[i] then
            self._PGCHBtns[i]:setVisible(false)
        end
    end
end

function MJPGCHManager:ope_showHuBtn()
    self:hidePGCHBtns()
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_HU)
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_GUO)
    self:adjustPGCHBtnPos()
end

function MJPGCHManager:ope_showGangBtn()
    self:hidePGCHBtns()
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_GANG)
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_GUO)
    self:adjustPGCHBtnPos()
end

function MJPGCHManager:ope_showGuoBtn()
    self:hidePGCHBtns()
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_GUO)
    self:adjustPGCHBtnPos()
end

function MJPGCHManager:getThrownChair()
    if self._cardsThrow then
        return self._cardsThrow.nChairNO
    end
    return 0
end

function MJPGCHManager:getThrownCardID()
    if self._cardsThrow then
        return self._cardsThrow.nCardIDs[1]
    end
    return -1
end

function MJPGCHManager:getCaughtCardID()
    if self._cardCaught then
        return self._cardCaught.nCardID
    end
    return -1
end

function MJPGCHManager:getJokerID()
    return self._gameController:getJokerID()
end

function MJPGCHManager:getJokerID2()
    return self._gameController:getJokerID2()
end


function MJPGCHManager:getGameFlags()
    return self._gameController:getGameFlags()
end

function MJPGCHManager:getPengCardIDs(selfHandCardIDs)
    local pengCardIDs= {}
    if selfHandCardIDs and "table" == type(selfHandCardIDs) then
        self:MJ_JudgePeng(selfHandCardIDs, self:getThrownCardID(), pengCardIDs)
    end
    return pengCardIDs
end

function MJPGCHManager:MJ_JudgePeng(cardIDs, cardID, resultIDs)
    local dwFlag = MJCalculator:MJ_CanPengEx(cardIDs, MJGameDef.MJ_CHAIR_CARDS, cardID, self:getJokerID(), self:getJokerID2(), self:getGameFlags(), resultIDs)
    return self._gameController:IS_BIT_SET(dwFlag, MJGameDef.MJ_PENG)
end

function MJPGCHManager:getChiCardIDs(selfHandCardIDs)
    local chiCardIDs= {}
    if selfHandCardIDs and "table" == type(selfHandCardIDs) then
        self:MJ_JudgeChi(selfHandCardIDs, self:getThrownCardID(), chiCardIDs)
    end
    return chiCardIDs
end

function MJPGCHManager:MJ_JudgeChi(cardIDs, cardID, resultIDs)
    local dwFlag = MJCalculator:MJ_CanChiEx(cardIDs, MJGameDef.MJ_CHAIR_CARDS, cardID, self:getJokerID(), self:getJokerID2(), self:getGameFlags(), resultIDs)
    return self._gameController:IS_BIT_SET(dwFlag, MJGameDef.MJ_CHI)
end

function MJPGCHManager:getMnGangCardIDs(selfHandCardIDs)
    local gangCardIDs= {}
    if selfHandCardIDs and "table" == type(selfHandCardIDs) then
        self:MJ_JudgeMnGang(selfHandCardIDs, self:getThrownCardID(), gangCardIDs)
    end
    return gangCardIDs
end

function MJPGCHManager:MJ_JudgeMnGang(cardIDs, cardID, resultIDs)
    local dwFlag = MJCalculator:MJ_CanMnGangEx(cardIDs, MJGameDef.MJ_CHAIR_CARDS, cardID, self:getJokerID(), self:getJokerID2(), self:getGameFlags(), resultIDs)
    return self._gameController:IS_BIT_SET(dwFlag, MJGameDef.MJ_GANG)
end

function MJPGCHManager:getAnGangCardIDs(selfHandCardIDs)
    local gangCardIDs= {}
    if selfHandCardIDs and "table" == type(selfHandCardIDs) then
        self:MJ_JudgeAnGang(selfHandCardIDs, self:getThrownCardID(), gangCardIDs)
    end
    return gangCardIDs
end

function MJPGCHManager:MJ_JudgeAnGang(cardIDs, cardID, resultIDs)
    local dwFlag = MJCalculator:MJ_CanAnGangEx(cardIDs, MJGameDef.MJ_CHAIR_CARDS, cardID, self:getJokerID(), self:getJokerID2(), self:getGameFlags(), resultIDs)
    return self._gameController:IS_BIT_SET(dwFlag, MJGameDef.MJ_GANG)
end

function MJPGCHManager:getPnGangCardIDs(selfPengCardIDs, selfHandCardIDs)
    local gangCardIDs= {}
    if selfHandCardIDs and "table" == type(selfHandCardIDs) and selfPengCardIDs and "table" == type(selfPengCardIDs) then
        self:MJ_JudgePnGang(selfPengCardIDs, selfHandCardIDs, gangCardIDs)
    end
    return gangCardIDs
end

function MJPGCHManager:MJ_JudgePnGang(selfPengCardIDs, selfHandCardIDs, resultIDs)
    local dwFlag = MJCalculator:MJ_CanPnGangEx(selfPengCardIDs, MJGameDef.MJ_CHAIR_CARDS, selfHandCardIDs, self:getJokerID(), self:getJokerID2(), self:getGameFlags(), resultIDs)
    return self._gameController:IS_BIT_SET(dwFlag, MJGameDef.MJ_GANG)
end

function MJPGCHManager:reqChiCardInfo(cardChair, cardID, baseIDs)
    self._reqChiCardInfo.cardChair = cardChair
    self._reqChiCardInfo.cardID = cardID
    self._reqChiCardInfo.baseIDs = baseIDs
end

function MJPGCHManager:getReqChiCardInfo()
    return self._reqChiCardInfo.cardChair, self._reqChiCardInfo.cardID, self._reqChiCardInfo.baseIDs
end

function MJPGCHManager:reqPengCardInfo(cardChair, cardID, baseIDs)
    self._reqPengCardInfo.cardChair = cardChair
    self._reqPengCardInfo.cardID = cardID
    self._reqPengCardInfo.baseIDs = baseIDs
end

function MJPGCHManager:getReqPengCardInfo()
    return self._reqPengCardInfo.cardChair, self._reqPengCardInfo.cardID, self._reqPengCardInfo.baseIDs
end

function MJPGCHManager:reqMnGangCardInfo(cardChair, cardID, baseIDs)
    self._reqMnGangCardInfo.cardChair = cardChair
    self._reqMnGangCardInfo.cardID = cardID
    self._reqMnGangCardInfo.baseIDs = baseIDs
end

function MJPGCHManager:getReqMnGangCardInfo()
    return self._reqMnGangCardInfo.cardChair, self._reqMnGangCardInfo.cardID, self._reqMnGangCardInfo.baseIDs
end

function MJPGCHManager:reqPnGangCardInfo(cardChair, cardID, baseIDs)
    self._reqPnGangCardInfo.cardChair = cardChair
    self._reqPnGangCardInfo.cardID = cardID
    self._reqPnGangCardInfo.baseIDs = baseIDs
end

function MJPGCHManager:getReqPnGangCardInfo()
    return self._reqPnGangCardInfo.cardChair, self._reqPnGangCardInfo.cardID, self._reqPnGangCardInfo.baseIDs
end

function MJPGCHManager:reqAnGangCardInfo(cardChair, cardID, baseIDs)
    self._reqAnGangCardInfo.cardChair = cardChair
    self._reqAnGangCardInfo.cardID = cardID
    self._reqAnGangCardInfo.baseIDs = baseIDs
end

function MJPGCHManager:getReqAnGangCardInfo()
    return self._reqAnGangCardInfo.cardChair, self._reqAnGangCardInfo.cardID, self._reqAnGangCardInfo.baseIDs
end

function MJPGCHManager:reqThrowCardInfo(cardID)
    self._reqThrowCardInfo.cardID = cardID
end

function MJPGCHManager:getReqThrowCardInfo()
    return self._reqThrowCardInfo.cardID
end

function MJPGCHManager:setWaitingOperation(waitingOperation)
    self._waitingOperation = waitingOperation
end

function MJPGCHManager:clearWaitingOperation()
    self:setWaitingOperation(0)
end

function MJPGCHManager:getWaitingOperation()
    return self._waitingOperation
end

function MJPGCHManager:setQiangGangInfo(qiangGangFlags, qiangGangCardID, gangCardChair)
    self._qiangGangInfo.qiangGangFlags = qiangGangFlags
    self._qiangGangInfo.qiangGangCardID = qiangGangCardID
    self._qiangGangInfo.gangCardChair = gangCardChair
end

function MJPGCHManager:getQiangGangInfo()
    return self._qiangGangInfo.qiangGangFlags, self._qiangGangInfo.qiangGangCardID, self._qiangGangInfo.gangCardChair
end

function MJPGCHManager:clearQiangGangInfo()
    self._qiangGangInfo = {}
end

function MJPGCHManager:isHuBtnVisible()
    if self._PGCHBtns[MJGameDef.MJ_PGCH_HU] then
        return self._PGCHBtns[MJGameDef.MJ_PGCH_HU]:isVisible()
    end
    return false
end

function MJPGCHManager:isGuoBtnVisible()
    if self._PGCHBtns[MJGameDef.MJ_PGCH_GUO] then
        return self._PGCHBtns[MJGameDef.MJ_PGCH_GUO]:isVisible()
    end
    return false
end

return MJPGCHManager
