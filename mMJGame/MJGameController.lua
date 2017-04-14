
if nil == cc or nil == cc.exports then
    return
end


local BaseGameDef                               = import("..mBaseGame.BaseGameDef")
local MJGameDef                                 = import(".MJGameDef")
local BaseGameController                        = import("..mBaseGame.BaseGameController")

cc.exports.MJGameController                     = {}
local MJGameController                          = cc.exports.MJGameController

local MJGameData                                = import(".MJGameData")
local MJGameUtilsInfoManager                    = import(".MJGameUtilsInfoManager")
local MJGameConnect                             = import(".MJGameConnect")
local MJGameNotify                              = import(".MJGameNotify")

local MJCalculator                              = import(".MJCalculator")


MJGameController.super = BaseGameController
setmetatable(MJGameController, {__index = MJGameController.super})


function MJGameController:createGameData()
    self._baseGameData = MJGameData:create()
end

function MJGameController:createUtilsInfoManager()
    self._baseGameUtilsInfoManager = MJGameUtilsInfoManager:create()
    self:setUtilsInfo()
end

function MJGameController:initManagerAboveBaseGame()
    self:initManagerAboveMJGame()
end

function MJGameController:initManagerAboveMJGame() end

function MJGameController:setConnect()
    self._baseGameConnect = MJGameConnect:create(self)
end

function MJGameController:setNotify()
    self._baseGameNotify = MJGameNotify:create(self)
end

function MJGameController:getMJTotalCards()
    return MJGameDef.MJ_TOTAL_CARDS
end

function MJGameController:getNextIndex(index)
    if self:getTableChairCount() - 1 == index then
        return self:getTableChairCount()
    else
        return (index + 1) % self:getTableChairCount()
    end
    return 0
end

function MJGameController:getNextChair(chair)
    return self:getNextIndex(chair + 1) - 1
end

function MJGameController:getPreIndex(index)
    if 1 == index then
        return self:getTableChairCount()
    else
        return index - 1
    end
    return 0
end

function MJGameController:getPreChair(chair)
    return self:getPreIndex(chair + 1) - 1
end

function MJGameController:onTouchBegan(x, y)
    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        if not MJHandCardsManager:containsTouchLocation(x, y) then
            MJHandCardsManager:ope_resetSelfCardsPos()
            MJHandCardsManager:ope_resetSelfCardsState()
        end
    end

    MJGameController.super.onTouchBegan(self, x, y)
end

function MJGameController:addSelfFlower()
    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:addSelfFlower()
    end
end

function MJGameController:setSelfFlower(count)
    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:setSelfFlower(count)
    end
end

function MJGameController:showSelfBanker(bBanker)
    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:showSelfBanker(bBanker)
    end
end

function MJGameController:addPlayerFlower(drawIndex)
    if self:getMyDrawIndex() == drawIndex then
        self:addSelfFlower()
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:addPlayerFlower(drawIndex)
    end
end

function MJGameController:setPlayerFlower(drawIndex, count)
    if self:getMyDrawIndex() == drawIndex then
        self:setSelfFlower(count)
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:setPlayerFlower(drawIndex, count)
    end
end

function MJGameController:clearPlayerFlower()
    local playerManager = self._baseGameScene:getPlayerManager()
    for i = 1, self:getTableChairCount() do
        if self:getMyDrawIndex() == i then
            self:setSelfFlower(0)
        end

        if playerManager then
            playerManager:setPlayerFlower(i, 0)
        end
    end
end

function MJGameController:clearPlayerBanker()
    local playerManager = self._baseGameScene:getPlayerManager()
    for i = 1, self:getTableChairCount() do
        if self:getMyDrawIndex() == i then
            self:showSelfBanker(false)
        end

        if playerManager then
            playerManager:clearBanker()
        end
    end
end

function MJGameController:getBaseScore()
    local baseScore = 0
    if self._baseGameUtilsInfoManager then
        baseScore = self._baseGameUtilsInfoManager:getBaseScore()
    end
    return baseScore
end

function MJGameController:getBaseDeposit()
    local baseDeposit = 0
    if self._baseGameUtilsInfoManager then
        baseDeposit = self._baseGameUtilsInfoManager:getBaseDeposit()
    end
    return baseDeposit
end

function MJGameController:getBanker()
    local banker = 1
    if self._baseGameUtilsInfoManager then
        banker = self._baseGameUtilsInfoManager:getBanker()
    end
    return banker
end

function MJGameController:getJokerID()
    if self._baseGameUtilsInfoManager then
        return self._baseGameUtilsInfoManager:getJokerID()
    end
    return -1
end

function MJGameController:getJokerID2()
    if self._baseGameUtilsInfoManager then
        return self._baseGameUtilsInfoManager:getJokerID2()
    end
    return -1
end

function MJGameController:getGameFlags()
    return 0
end

-- For test
--function MJGameController:onStartGame()
--    self:ope_ThrowDices()
--end

function MJGameController:ope_GameStart()
    --self:hideOperationBtns()
    self:hideGameTools()
    self:hidePlayerInfo()

    self:ope_MovePlayer(0.5)

    MJGameController.super.ope_GameStart(self)
end

function MJGameController:hideOperationBtns()
    
end

function MJGameController:hideGameTools()
    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:hideTools()
    end
end

function MJGameController:hidePlayerInfo()
    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:hidePlayerInfo()
    end
end

function MJGameController:ope_MovePlayer(duration)
    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        local function onMovePlayerInterval(dt)
            self:onMovePlayerFinished()
        end
        if self.movePlayerTimerID then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.movePlayerTimerID)
            self.movePlayerTimerID = nil
        end
        self.movePlayerTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onMovePlayerInterval, duration, false)

        playerManager:ope_MovePlayer(duration)
    end
end

function MJGameController:onMovePlayerFinished()
    if self.movePlayerTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.movePlayerTimerID)
        self.movePlayerTimerID = nil
    end

    self:ope_ThrowDices({6, 4})
end

function MJGameController:ope_ThrowDices()
    local dicesPoint = {1, 1}
    if self._baseGameUtilsInfoManager then
        local dices = self._baseGameUtilsInfoManager:getDices()
        if dices then
            dicesPoint = {dices[1], dices[2]}
        end
    end
    self._baseGameScene:ope_ThrowDices(dicesPoint)
    self:playGamePublicSound("Snd_Dice")
end

function MJGameController:onThrowDicesFinished()
    self:showBanker()
    self:ope_DealCard()

    self._baseGameScene:cleanDices()
end

function MJGameController:showBanker()
    local drawIndex = self:rul_GetDrawIndexByChairNO(self:getBanker())
    if self:getMyDrawIndex() == drawIndex then
        self:showSelfBanker(true)
    else
        local playerManager = self._baseGameScene:getPlayerManager()
        if playerManager and 0 < drawIndex then
            playerManager:showBanker(drawIndex)
        end
    end
end

function MJGameController:ope_DealCard()
    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        MJHandCardsManager:ope_DealCard()
    end
end

function MJGameController:onDealCardFinished()
    self:ope_SortCards()
end

function MJGameController:ope_SortCards()
    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        MJHandCardsManager:ope_SortCards()
        self:playGamePublicSound("Snd_Sort")
    end
end

function MJGameController:ope_SortSelfHandCards()
    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        MJHandCardsManager:ope_SortSelfHandCards()
--        MJHandCardsManager:ope_resetSelfCardsPos()
--        MJHandCardsManager:ope_resetSelfCardsState()
    end
end

function MJGameController:onSortCardsFinished(bFirstSort)
    if bFirstSort then
        self:ope_StartPlay()
    end
end

function MJGameController:ope_StartPlay()
    local drawIndex = self:getMyDrawIndex()
    local throwWait = 0
    if self._baseGameUtilsInfoManager then
        drawIndex = self:rul_GetDrawIndexByChairNO(self:getBanker())
        throwWait = self._baseGameUtilsInfoManager:getThrowWait()
    end
    local clock = self._baseGameScene:getClock()
    if clock then
        if 0 < drawIndex then
            clock:setDrawIndex(drawIndex)
        end
        if throwWait then
            clock:start(throwWait)
        end
    end

    self:ope_ShowFlowers()
    self:ope_ShowGameInfo(true)

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameUtilsInfoManager then
        MJPGCHManager:setCurrentFlags(self._baseGameUtilsInfoManager:getCurrentFlags())
    end

    if drawIndex == self:getMyDrawIndex() and self:isClockPointToSelf() then
        self:ope_JudgeOperation()
    end

    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        MJHandCardsManager:setEnableTouch(true)
    end
end

function MJGameController:ope_ShowFlowers()end

function MJGameController:onGameExit()
    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        MJHandCardsManager:onGameExit()
    end

    if self.quickCatchTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.quickCatchTimerID)
        self.quickCatchTimerID = nil
    end
    if self.movePlayerTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.movePlayerTimerID)
        self.movePlayerTimerID = nil
    end

    MJGameController.super.onGameExit(self)
end

function MJGameController:autoPlay()
    if true then
        return
    end

    if not self:isGameRunning() then return end
    if not self:isAutoPlay() then return end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if not self:isClockPointToSelf() then
        if MJPGCHManager then
            if not MJPGCHManager:isGuoBtnVisible() then
                return
            end
        end
    end

    self._autoWaitTimes = self._autoWaitTimes + 1
    if self._autoWaitTimes < self._minWaitTimes then
        return
    end

    self._autoWaitTimes = 0

    if MJPGCHManager then
        if MJPGCHManager:isHuBtnVisible() then
            self:onHu()
            return
        end

        if MJPGCHManager:isGuoBtnVisible() then
            self:onGuo()
            return
        end
    end

    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        if MJHandCardsManager:isNeedThrow(self:getMyDrawIndex()) then
            self:onThrowCard(self:getUselessCardID())
        end
    end
end

function MJGameController:onClockStop()
    if self._baseGameConnect then
        self._baseGameConnect:sendMsgToServer(MJGameDef.MJ_SYSMSG_GAME_CLOCK_STOP)
    end
end

function MJGameController:onGameClockZero()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()
    end
    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    if MJPGCHManager then
        if MJPGCHManager:getWaitingOperation() == MJGameDef.MJ_WAITING_PENG_CARDS then
            MJPGCHManager:clearWaitingOperation()

            local cardChair, cardID, baseIDs = MJPGCHManager:getReqPengCardInfo()
            self._baseGameConnect:reqPengCard(cardChair, cardID, baseIDs)

            return
        end

        if MJPGCHManager:getWaitingOperation() == MJGameDef.MJ_WAITING_MNGANG_CARDS then
            MJPGCHManager:clearWaitingOperation()

            local cardChair, cardID, baseIDs = MJPGCHManager:getReqMnGangCardInfo()
            self._baseGameConnect:reqMnGangCard(cardChair, cardID, baseIDs)

            return
        end

        if MJPGCHManager:getWaitingOperation() == MJGameDef.MJ_WAITING_PNGANG_CARDS then
            MJPGCHManager:clearWaitingOperation()

            local cardChair, cardID, baseIDs = MJPGCHManager:getReqPnGangCardInfo()
            self._baseGameConnect:reqPnGangCard(cardChair, cardID, baseIDs)

            return
        end

        if MJPGCHManager:getWaitingOperation() == MJGameDef.MJ_WAITING_HU_CARDS then
            MJPGCHManager:clearWaitingOperation()

            self:onHu()

            return
        end

        if MJPGCHManager:getWaitingOperation() == MJGameDef.MJ_WAITING_CHI_CARDS then
            MJPGCHManager:clearWaitingOperation()

            local clock = self._baseGameScene:getClock()
            if clock then
                local throwWait = 15
                if self._baseGameUtilsInfoManager then
                    throwWait = self._baseGameUtilsInfoManager:getThrowWait()
                end
                clock:start(throwWait)
            end
            self:onCatchCard()

            return
        end
    end

    if MJPGCHManager then
        if MJPGCHManager:isHuBtnVisible() then
            self:onHu()
            return
        end
    end

    if self:isClockPointToSelf() then
        local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
        if MJHandCardsManager then
            MJPGCHManager:clearWaitingOperation()

            if MJHandCardsManager:isNeedThrow(self:getMyDrawIndex()) then
                self:onThrowCard(self:getUselessCardID())
                --self:ope_AutoPlay(true)
            else
                self:onCatchCard()
            end

            return
        end
    end
end

function MJGameController:getUselessCardID()
    local uselessCardID = -1
    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        local myHandCards = MJHandCardsManager:getMJHandCards(self:getMyDrawIndex())
        if myHandCards then
            local card = myHandCards:getMJCardHand(1)
            if card then
                uselessCardID = card:getMJID()
            end
        end
    end
    return uselessCardID
end

function MJGameController:getTableChairCount()
    return MJGameDef.MJ_TOTAL_PLAYERS
end

function MJGameController:getChairCardsCount()
    return MJGameDef.MJ_PLAYER_CARDS
end

function MJGameController:getChairCastoffCardsCount()
    return MJGameDef.MJ_PLAYER_CASTOFF_CARDS
end

function MJGameController:getOnceDealCount()
    return MJGameDef.MJ_ONCE_DEAL_COUNT
end

function MJGameController:onThrowCard(id)
    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager:isNeedThrow(self:getMyDrawIndex()) then
        if self._baseGameConnect then
            local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
            if MJPGCHManager then
                MJPGCHManager:reqThrowCardInfo(id)

                if MJCalculator:MJ_IsHuaEx(id, self:getJokerID(), self:getJokerID2(), self:getGameFlags()) then
                    self._baseGameConnect:reqHuaCard(id)
                else
                    self._baseGameConnect:reqThrowCard(id)
                end
            end
        end
    end
end

function MJGameController:onCatchCard()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()
    end

    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if not MJHandCardsManager:isNeedThrow(self:getMyDrawIndex()) then
        if self._baseGameConnect then
            self._baseGameConnect:reqCatchCard()
        end
    end
end

function MJGameController:onPeng()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()

        if self._baseGameConnect then
            local cardChair = MJPGCHManager:getThrownChair()
            local cardID = MJPGCHManager:getThrownCardID()
            local selfHandCardIDs = nil
            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                selfHandCardIDs = handCardsManager:getSelfHandCardIDs()
            end
            local pengCardIDs = MJPGCHManager:getPengCardIDs(selfHandCardIDs)
            local baseIDs = {pengCardIDs[1], pengCardIDs[2], -1}
            self:reqPengCard(cardChair, cardID, baseIDs)
        end
    end
end

function MJGameController:reqPengCard(cardChair, cardID, baseIDs)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        MJPGCHManager:reqPengCardInfo(cardChair, cardID, baseIDs)
        self._baseGameConnect:reqPrePengCard(cardChair, cardID, baseIDs)
        self._baseGameConnect:reqPengCard(cardChair, cardID, baseIDs)

        self:playOperationEffectByName("Peng", self:getPlayerNickSexByIndex(self:getMyDrawIndex()))
    end
end

function MJGameController:onGang()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()

        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if self:isClockPointToSelf() and handCardsManager and handCardsManager:isNeedThrow(self:getMyDrawIndex()) then
            self:onAnPnGang()
        else
            self:onMnGang()
        end
    end
end

function MJGameController:onAnPnGang()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        -- angang
        local selfHandCardIDs = nil
        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            selfHandCardIDs = handCardsManager:getSelfHandCardIDs()
        end
        local anGangCardIDs = MJPGCHManager:getAnGangCardIDs(selfHandCardIDs)
        local anGangUnit = self:getUsefulGangUnit(anGangCardIDs)

        -- pngang
        local selfPengCardIDs = nil
        local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
        if PGCCardsManager then
            selfPengCardIDs = PGCCardsManager:getSelfPengCardIDs()
        end
        local pnGangCardIDs = MJPGCHManager:getPnGangCardIDs(selfPengCardIDs, selfHandCardIDs)
        local pnGangUnit = self:getUsefulGangUnit(pnGangCardIDs)

        if 4 == #anGangUnit + #pnGangUnit then
            local cardChair = 0
            local playerInfoManager = self:getPlayerInfoManager()
            if playerInfoManager then
                cardChair = playerInfoManager:getSelfChairNO()
            end

            if 4 == #anGangUnit then
                local cardID = anGangUnit[4]
                local baseIDs = {anGangUnit[1], anGangUnit[2], anGangUnit[3]}
                self:reqAnGangCard(cardChair, cardID, baseIDs)
            elseif 4 == #pnGangUnit then
                local cardID = pnGangUnit[4]
                local baseIDs = {pnGangUnit[1], pnGangUnit[2], pnGangUnit[3]}
                self:reqPnGangCard(cardChair, cardID, baseIDs)
            end
        else
            self:showGangUnit(anGangUnit, pnGangUnit)
        end
    end
end

function MJGameController:reqAnGangCard(cardChair, cardID, baseIDs)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        MJPGCHManager:reqAnGangCardInfo(cardChair, cardID, baseIDs)
        self._baseGameConnect:reqPreGangCard(cardChair, cardID, baseIDs, MJGameDef.MJ_GANG_AN)
        self._baseGameConnect:reqAnGangCard(cardChair, cardID, baseIDs)

        self:playOperationEffectByName("Gang", self:getPlayerNickSexByIndex(self:getMyDrawIndex()))
    end
end

function MJGameController:reqPnGangCard(cardChair, cardID, baseIDs)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        MJPGCHManager:reqPnGangCardInfo(cardChair, cardID, baseIDs)
        self._baseGameConnect:reqPreGangCard(cardChair, cardID, baseIDs, MJGameDef.MJ_GANG_PN)
        self._baseGameConnect:reqPnGangCard(cardChair, cardID, baseIDs)

        self:playOperationEffectByName("Gang", self:getPlayerNickSexByIndex(self:getMyDrawIndex()))
    end
end

function MJGameController:getUsefulGangUnit(gangCardIDs)
    local index = 1
    local gangUnit = {}
    for i = 1, #gangCardIDs, 4 do
        if not gangCardIDs[i] or -1 == gangCardIDs[i] then
            break
        end

        gangUnit[index]     = gangCardIDs[i]
        gangUnit[index + 1] = gangCardIDs[i + 1]
        gangUnit[index + 2] = gangCardIDs[i + 2]
        gangUnit[index + 3] = gangCardIDs[i + 3]

        index = index + 4
    end
    return gangUnit
end

function MJGameController:showGangUnit(anGangUnit, pnGangUnit)
    if 0 ~= (#anGangUnit + #pnGangUnit) % 4 or 12 < #anGangUnit + #pnGangUnit or 4 > #anGangUnit + #pnGangUnit then return end

    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:showGangUnit(anGangUnit, pnGangUnit)
    end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:ope_showGuoBtn()
    end
end

function MJGameController:choseAnGangCards(baseIDs, cardID)
    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    if self._baseGameConnect then
        local cardChair = 0
        local playerInfoManager = self:getPlayerInfoManager()
        if playerInfoManager then
            cardChair = playerInfoManager:getSelfChairNO()
        end
        self:reqAnGangCard(cardChair, cardID, baseIDs)
    end
end

function MJGameController:chosePnGangCards(baseIDs, cardID)
    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    if self._baseGameConnect then
        local cardChair = 0
        local playerInfoManager = self:getPlayerInfoManager()
        if playerInfoManager then
            cardChair = playerInfoManager:getSelfChairNO()
        end
        self:reqPnGangCard(cardChair, cardID, baseIDs)
    end
end

function MJGameController:onMnGang()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        local cardChair = MJPGCHManager:getThrownChair()
        local cardID = MJPGCHManager:getThrownCardID()
        local selfHandCardIDs = nil
        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            selfHandCardIDs = handCardsManager:getSelfHandCardIDs()
        end
        local gangCardIDs = MJPGCHManager:getMnGangCardIDs(selfHandCardIDs)
        local baseIDs = {gangCardIDs[1], gangCardIDs[2], gangCardIDs[3]}
        self:reqMnGangCard(cardChair, cardID, baseIDs)
    end
end

function MJGameController:reqMnGangCard(cardChair, cardID, baseIDs)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        MJPGCHManager:reqMnGangCardInfo(cardChair, cardID, baseIDs)
        self._baseGameConnect:reqPreGangCard(cardChair, cardID, baseIDs, MJGameDef.MJ_GANG_MN)
        self._baseGameConnect:reqMnGangCard(cardChair, cardID, baseIDs)

        self:playOperationEffectByName("Gang", self:getPlayerNickSexByIndex(self:getMyDrawIndex()))
    end
end

function MJGameController:onChi()
    if not self:isClockPointToSelf() then return end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()

        if self._baseGameConnect then
            local cardChair = MJPGCHManager:getThrownChair()
            local cardID = MJPGCHManager:getThrownCardID()
            local selfHandCardIDs = nil
            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                selfHandCardIDs = handCardsManager:getSelfHandCardIDs()
            end
            local chiCardIDs = MJPGCHManager:getChiCardIDs(selfHandCardIDs)
            local chiUnit = self:getUsefulChiUnit(chiCardIDs)
            if 2 == #chiUnit then
                local baseIDs = {chiUnit[1], chiUnit[2], -1}
                self:reqChiCard(cardChair, cardID, baseIDs)
            else
                self:showChiUnit(chiUnit, cardID)
            end
        end
    end
end

function MJGameController:getUsefulChiUnit(chiCardIDs)
    local index = 1
    local chiUnit = {}
    for i = 1, #chiCardIDs, 2 do
        if not chiCardIDs[i] or -1 == chiCardIDs[i] then
            break
        end

        local bUnitRepeat = false
        for j = 1, #chiUnit, 2 do
            if MJCalculator:MJ_IsSameCard(chiUnit[j], chiCardIDs[i], self:getGameFlags()) and
               MJCalculator:MJ_IsSameCard(chiUnit[j + 1], chiCardIDs[i + 1], self:getGameFlags()) then
                bUnitRepeat = true
                break
            end
        end

        if not bUnitRepeat then
            chiUnit[index] = chiCardIDs[i]
            chiUnit[index + 1] = chiCardIDs[i + 1]
            index = index + 2
        end
    end
    return chiUnit
end

function MJGameController:showChiUnit(chiUnit, cardID)
    if 1 == #chiUnit % 2 or 6 < #chiUnit or 2 > #chiUnit then return end

    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:showChiUnit(chiUnit, cardID)
    end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:ope_showGuoBtn()
    end
end

function MJGameController:choseChiCards(baseIDs, cardID)
    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        local cardChair = MJPGCHManager:getThrownChair()
        self:reqChiCard(cardChair, cardID, baseIDs)
    end
end

function MJGameController:reqChiCard(cardChair, cardID, baseIDs)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        MJPGCHManager:reqChiCardInfo(cardChair, cardID, baseIDs)
        self._baseGameConnect:reqPreChiCard(cardChair, cardID, baseIDs)
        self._baseGameConnect:reqChiCard(cardChair, cardID, baseIDs)

        self:playOperationEffectByName("Chi", self:getPlayerNickSexByIndex(self:getMyDrawIndex()))
    end
end

function MJGameController:onHu()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()

        if self._baseGameConnect then
            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if self:isClockPointToSelf() and handCardsManager and handCardsManager:isNeedThrow(self:getMyDrawIndex()) then
                self:onZiMoHu()
            else
                self:onFangChongHu()
            end
        end
    end
end

function MJGameController:onZiMoHu()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        local cardChair = -1
        local playerInfoManager = self:getPlayerInfoManager()
        if playerInfoManager then
            cardChair = playerInfoManager:getSelfChairNO()
        end
        local cardID = MJPGCHManager:getCaughtCardID()
        if -1 == cardID then
            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                cardID = handCardsManager:getSelfFirstHandCardID()
            end
        end
        local huFlags = MJGameDef.MJ_HU_ZIMO
        self._baseGameConnect:reqHuCard(cardChair, cardID, huFlags, 0)
    end
end

function MJGameController:onFangChongHu()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager and self._baseGameConnect then
        local cardChair = MJPGCHManager:getThrownChair()
        local cardID = MJPGCHManager:getThrownCardID()
        local huFlags = MJGameDef.MJ_HU_FANG
        local subFlags = 0
        local qiangGangFlags, qiangGangCardID, gangCardChair = MJPGCHManager:getQiangGangInfo()
        if qiangGangFlags and 0 < qiangGangFlags then
            huFlags = MJGameDef.MJ_HU_QGNG
            subFlags = qiangGangFlags
            cardID = qiangGangCardID
            cardChair = gangCardChair
        end
        self._baseGameConnect:reqHuCard(cardChair, cardID, huFlags, subFlags)
    end
end

function MJGameController:onGuo()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()
    end
    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    if self._baseGameConnect then
        self._baseGameConnect:reqGuoCard()
    end
end

function MJGameController:clearGameTable()
    local handCardsManager = self._baseGameScene:getMJHandCardsManager()
    if handCardsManager then
        handCardsManager:resetHandCardsManager()
    end

    local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
    if thrownCardsManager then
        thrownCardsManager:resetHandCardsManager()
    end

    local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
    if PGCCardsManager then
        PGCCardsManager:resetPGCCardsManager()
    end

    local castoffCardsManager = self._baseGameScene:getMJCastoffCardsManager()
    if castoffCardsManager then
        castoffCardsManager:resetCastoffCardsManager()
    end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:resetMJPGCHManager()
    end

    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    local showDownCardsManager = self._baseGameScene:getMJShowDownCardsManager()
    if showDownCardsManager then
        showDownCardsManager:resetShowDownCardsManager()
    end

    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:onGameWin()
    end

    --self:ope_AutoPlay(false)

    self:clearPlayerFlower()
    self:clearPlayerBanker()

    self:ope_ShowGameInfo(false)
    self:hideGameResultInfo()

    MJGameController.super.clearGameTable(self)
end

function MJGameController:onGameStartSolo(data)
    self:onGameStart(data)
end

function MJGameController:onEnterGameDXXW(data)
    self:parseGameTableInfoData(data)

    MJGameController.super.onEnterGameDXXW(self, data)
end

function MJGameController:onGetTableInfo(data)
    self:parseGameTableInfoData(data)

    self:setResume(false)
    self:onDXXW()
end

function MJGameController:parseGameTableInfoData(data)
    local startInfo = nil
    local playInfo = nil
    local tableInfo = nil
    local soloPlayers = nil
    if self._baseGameData then
        startInfo, playInfo, tableInfo, soloPlayers = self._baseGameData:getTableInfo(data)
    end

    if soloPlayers and 0 < #soloPlayers then
        if self._baseGamePlayerInfoManager then
            self._baseGamePlayerInfoManager:clearPlayersInfo()
        end
        local playerManager = self._baseGameScene:getPlayerManager()
        if playerManager then
            playerManager:clearPlayers()
        end

        for i = 1, #soloPlayers do
            self:setSoloPlayer(soloPlayers[i])
        end
    end

    if self._baseGameUtilsInfoManager then
        if tableInfo then
            self._baseGameUtilsInfoManager:setTableInfo(tableInfo)
        end
        if startInfo then
            self._baseGameUtilsInfoManager:setStartInfo(startInfo)
            if tableInfo then
                self._baseGameUtilsInfoManager:setStartInfoFromTableInfo(tableInfo)
            end
        end
        if playInfo then
            self._baseGameUtilsInfoManager:setPlayInfo(playInfo)
        end
    end
end

function MJGameController:onDXXW()
    if self._baseGameConnect then
        self._baseGameConnect:sendMsgToServer(MJGameDef.MJ_SYSMSG_PLAYER_ONLINE)
    end

    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:onGameStart()
    end

    self._baseGameScene:cleanDices()
    

    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
    if MJHandCardsManager then
        MJHandCardsManager:resetHandCardsManager()
    end
    --self:ope_AutoPlay(false)

    if self._baseGameUtilsInfoManager then
        local status = self._baseGameUtilsInfoManager:getStatus()
        if 0 == status then
            self:gameStop()
            self:clearGameTable()

            if self:isRandomRoom() then
                if self:isWaitArrangeTableShow() then
                    local gameTools = self._baseGameScene:getTools()
                    if gameTools then
                        gameTools:disableSafeBox()
                    end
                end
            else
                local selfInfo = self._baseGameScene:getSelfInfo()
                if selfInfo then
                    if selfInfo:isSelfReadyShow() then
                        local gameTools = self._baseGameScene:getTools()
                        if gameTools then
                            gameTools:disableSafeBox()
                        end
                    end
                end
            end
        else
            if self:IS_BIT_SET(status, BaseGameDef.BASEGAME_TS_PLAYING_GAME) then
                self:gameRun()
            end

            if self:isGameRunning() and self._baseGameUtilsInfoManager then
                local bWaitingThrow = self:IS_BIT_SET(status, BaseGameDef.BASEGAME_TS_WAITING_THROW)

                self:hideGameResultInfo()
                self:hidePlayerInfo()

                local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
                if MJPGCHManager then
                    MJPGCHManager:hidePGCHBtns()
                end

                local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
                if MJChoseCardsManager then
                    MJChoseCardsManager:resetMJChoseCardsManager()
                end

                local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
                if MJHandCardsManager and self._baseGamePlayerInfoManager then
                    MJHandCardsManager:resetHandCardsManager()

                    local cardsCounts = self._baseGameUtilsInfoManager:getCardsCount()

                    for i = 1, self:getTableChairCount() do
                        local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                        if 0 < drawIndex then
                            MJHandCardsManager:setHandCardsCount(drawIndex, cardsCounts[i])
                            if drawIndex == self:getMyDrawIndex() then
                                local chairCards = self._baseGameUtilsInfoManager:getChairCards()
                                MJHandCardsManager:setSelfHandCards(chairCards)
                            end

                            if i == self._baseGameUtilsInfoManager:getCurrentChair() + 1 then
                                if bWaitingThrow then
                                    MJHandCardsManager:setNeedThrow(drawIndex, true)
                                end
                            end
                            self:ope_SortSelfHandCards()
                            MJHandCardsManager:updateHandCards(drawIndex)
                            MJHandCardsManager:setEnableTouch(true)
                        end
                    end
                end

                local castoffCards, castoffCardsCount = self._baseGameUtilsInfoManager:getCastoffCards()
                if castoffCards and castoffCardsCount then
                    local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
                    if thrownCardsManager then
                        thrownCardsManager:resetHandCardsManager()

                        if not bWaitingThrow then
                            local currentChair = self._baseGameUtilsInfoManager:getCurrentChair()
                            local thrownChair = self:getPreChair(currentChair)
                            local thrownCard = castoffCards[thrownChair + 1][castoffCardsCount[thrownChair + 1]]
                            castoffCardsCount[thrownChair + 1] = castoffCardsCount[thrownChair + 1] - 1

                            local drawIndex = self:rul_GetDrawIndexByChairNO(thrownChair)
                            if 0 < drawIndex then
                                thrownCardsManager:onCardsThrow(drawIndex, thrownCard)
                            end
                        end
                    end

                    local castoffCardsManager = self._baseGameScene:getMJCastoffCardsManager()
                    if castoffCardsManager then
                        castoffCardsManager:resetCastoffCardsManager()

                        for i = 1, self:getTableChairCount() do
                            local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                            if 0 < drawIndex then
                                castoffCardsManager:castoffCards(drawIndex, castoffCards[i], castoffCardsCount[i])
                            end
                        end
                    end
                end

                local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
                if PGCCardsManager then
                    PGCCardsManager:resetPGCCardsManager()

                    local pengCards, pengCardsCount = self._baseGameUtilsInfoManager:getPengCards()
                    local chiCards, chiCardsCount = self._baseGameUtilsInfoManager:getChiCards()
                    local mnGangCards, mnGangCardsCount = self._baseGameUtilsInfoManager:getMnGangCards()
                    local pnGangCards, pnGangCardsCount = self._baseGameUtilsInfoManager:getPnGangCards()
                    local anGangCards, anGangCardsCount = self._baseGameUtilsInfoManager:getAnGangCards()

                    for i = 1, self:getTableChairCount() do
                        local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                        if 0 < drawIndex then
                            if pengCards[i] and pengCardsCount[i] then
                                PGCCardsManager:onCardPengs(drawIndex, pengCards[i], pengCardsCount[i])
                            end

                            if chiCards[i] and chiCardsCount[i] then
                                PGCCardsManager:onCardChis(drawIndex, chiCards[i], chiCardsCount[i])
                            end

                            if mnGangCards[i] and mnGangCardsCount[i] then
                                PGCCardsManager:onCardMnGangs(drawIndex, mnGangCards[i], mnGangCardsCount[i])
                            end

                            if pnGangCards[i] and pnGangCardsCount[i] then
                                PGCCardsManager:onCardPnGangs(drawIndex, pnGangCards[i], pnGangCardsCount[i])
                            end

                            if anGangCards[i] and anGangCardsCount[i] then
                                PGCCardsManager:onCardAnGangs(drawIndex, anGangCards[i], anGangCardsCount[i])
                            end
                        end
                    end
                end

                local huaCards, huaCardsCount = self._baseGameUtilsInfoManager:getHuaCards()
                if huaCardsCount then
                    for i = 1, self:getTableChairCount() do
                        local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                        if 0 < drawIndex then
                            self:setPlayerFlower(drawIndex, huaCardsCount[i])
                        end
                    end
                end

                local clock = self._baseGameScene:getClock()
                local currentIndex = self:rul_GetDrawIndexByChairNO(self._baseGameUtilsInfoManager:getCurrentChair())
                if clock and 0 < currentIndex then
                    local throwWait = 0
                    if bWaitingThrow then
                        throwWait = self._baseGameUtilsInfoManager:getThrowWait()
                    else
                        throwWait = self._baseGameUtilsInfoManager:getPGCHWait()
                    end
                    clock:start(throwWait)
                    clock:setDrawIndex(currentIndex)
                end

                local playerManager = self._baseGameScene:getPlayerManager()
                if playerManager then
                    playerManager:ope_MovePlayerImmediately()
                end

                local gameInfo = self._baseGameScene:getGameInfo()
                if gameInfo then
                    local lastCount = 0
                    if self._baseGameUtilsInfoManager then
                        lastCount = self._baseGameUtilsInfoManager:getBeginNO() -
                        self._baseGameUtilsInfoManager:getCurrentCatch() - 
                        self._baseGameUtilsInfoManager:getTailTaken()
                        if 0 > lastCount then
                            lastCount = lastCount + self:getMJTotalCards()
                        end
                    end
                    gameInfo:setLastCardsCount(lastCount)
                end
                self:ope_ShowGameInfo(true)
            end
        end
    end

    MJGameController.super.onDXXW(self)
end

function MJGameController:onGameStart(data)
    self:gameRun()

    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:onGameStart()
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:onGameStart()
    end

    local gameStart = nil
    if self._baseGameData then
        gameStart = self._baseGameData:getGameStartInfo(data)
    end

    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:onGameStart()
    end

    local gameInfo = self._baseGameScene:getGameInfo()
    if gameInfo then
        gameInfo:onGameStart()
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:onHidePlayerInfo()
    end

    local safeBox = self._baseGameScene:getSafeBox()
    if safeBox then
        safeBox:showSafeBox(false)
    end

    local chat = self._baseGameScene:getChat()
    if chat and chat:isVisible() then
        chat:showChat(false)
    end

    local setting = self._baseGameScene:getSetting()
    if setting and setting:isVisible() then
        setting:showSetting(false)
    end

    --self:ope_AutoPlay(false)

    if gameStart then
        if self._baseGameUtilsInfoManager then
            self._baseGameUtilsInfoManager:setStartInfo(gameStart)
        end
    end

    if self._baseGameUtilsInfoManager then
        local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
        if MJHandCardsManager then
            local bankerIndex  = self:rul_GetDrawIndexByChairNO(self._baseGameUtilsInfoManager:getBanker())
            if 0 < bankerIndex then
                MJHandCardsManager:setStartIndex(bankerIndex)
            end

            if self._baseGamePlayerInfoManager then
                local cardsCounts = self._baseGameUtilsInfoManager:getCardsCount()

                for i = 1, self:getTableChairCount() do
                    local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                    if 0 < drawIndex then
                        MJHandCardsManager:setHandCardsCount(drawIndex, cardsCounts[i])
                        if drawIndex == self:getMyDrawIndex() then
                            local chairCards = self._baseGameUtilsInfoManager:getChairCards()
                            MJHandCardsManager:setSelfHandCards(chairCards)
                        end
                    end
                end
            end
        end
    end

    if gameStart then
        -- do sth.
        self:ope_GameStart()
    end
end

function MJGameController:isCardsThrowResponse(data)
    local bCardsThrowResponse = false

    local cardsThrow = nil
    if self._baseGameData then
        cardsThrow = self._baseGameData:getCardsThrowInfo(data)
    end

    if cardsThrow then
        local playerInfoManager = self:getPlayerInfoManager()
        if playerInfoManager then
            bCardsThrowResponse = (playerInfoManager:getSelfChairNO() == cardsThrow.nChairNO)
        end
    end

    return bCardsThrowResponse
end

function MJGameController:onCardsThrow(data)
    local cardsThrow = nil
    if self._baseGameData then
        cardsThrow = self._baseGameData:getCardsThrowInfo(data)
    end

    if cardsThrow then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardsThrow.nChairNO)
        if 0 < drawIndex then
            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if drawIndex == self:getMyDrawIndex() then
                local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
                if MJPGCHManager then
                    MJPGCHManager:hidePGCHBtns()
                end

                local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
                if MJChoseCardsManager then
                    MJChoseCardsManager:resetMJChoseCardsManager()
                end

                if handCardsManager and not handCardsManager:isNeedThrow(drawIndex) then
                    -- 
                    return
                end
            end

            self:playGamePublicSound("Snd_Throw")
            self:playCardEffectByID(cardsThrow.nCardIDs[1], self:getPlayerNickSexByUserID(cardsThrow.nUserID))

            -- Hide clock
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            -- Deal with hand cards
            if handCardsManager then
                handCardsManager:onCardsThrow(drawIndex, cardsThrow.nCardIDs[1])

                if self:getNextIndex(drawIndex) == self:getMyDrawIndex() then
                    local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
                    if MJHandCardsManager then
--                        MJHandCardsManager:ope_resetSelfCardsPos()
--                        MJHandCardsManager:ope_resetSelfCardsState()
                    end
                end
            end

            -- Deal with thrown card
            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                thrownCardsManager:onCardsThrow(drawIndex, cardsThrow.nCardIDs[1])
            end

            -- Deal with clock
            local pgchWait = 5
            if self._baseGameUtilsInfoManager then
                pgchWait = self._baseGameUtilsInfoManager:getPGCHWait()
            end
            if clock then
                clock:start(pgchWait)
                local nextIndex = self:getNextIndex(drawIndex)
                clock:moveClockHandTo(nextIndex)
            end

            local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
            if MJHandCardsManager then
                MJHandCardsManager:setEnableTouch(true)
            end

            self:afterCardsThrow(cardsThrow)
        end
    end
end

function MJGameController:afterCardsThrow(cardsThrow, drawIndex)
    if not cardsThrow then return end
    if self:rul_GetDrawIndexByChairNO(cardsThrow.nChairNO) == self:getMyDrawIndex() then return end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:setCardsThrow(cardsThrow)

        if self:isClockPointToSelf() and MJPGCHManager:canCatchCardAfterThrow() then
            self:startQuickCatch()
            return
        end

        MJPGCHManager:showPGCHBtns()
    end
end

function MJGameController:startQuickCatch()
    local function onQuickCatchInterval(dt)
        self:onQuickCatch()
    end
    if self.quickCatchTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.quickCatchTimerID)
        self.quickCatchTimerID = nil
    end
    self.quickCatchTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onQuickCatchInterval, 2.0, false)
end

function MJGameController:onQuickCatch()
    if self.quickCatchTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.quickCatchTimerID)
        self.quickCatchTimerID = nil
    end

    local MJThrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
    if MJThrownCardsManager then
        local preIndex = self:getPreIndex(self:getMyDrawIndex())
        if MJThrownCardsManager:isThrownCardVisible(preIndex) then
            local throwWait = 15
            if self._baseGameUtilsInfoManager then
                throwWait = self._baseGameUtilsInfoManager:getThrowWait()
            end
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:start(throwWait)
            end

            self:onCatchCard()
        end
    end
end

function MJGameController:isClockPointToSelf()
    local bClockPointToSelf = false

    local clock = self._baseGameScene:getClock()
    if clock then
        bClockPointToSelf = (clock:getDrawIndex() == self:getMyDrawIndex())
    end

    return bClockPointToSelf
end

function MJGameController:isCardCaughtResponse(data)
    local bCardCaughtResponse = false

    local cardCaught = nil
    if self._baseGameData then
        cardCaught = self._baseGameData:getCardCaughtInfo(data)
    end

    if cardCaught then
        local playerInfoManager = self:getPlayerInfoManager()
        if playerInfoManager then
            bCardCaughtResponse = (playerInfoManager:getSelfChairNO() == cardCaught.nChairNO)
        end
    end

    return bCardCaughtResponse
end

function MJGameController:onCardCaught(data)
    local cardCaught = nil
    if self._baseGameData then
        cardCaught = self._baseGameData:getCardCaughtInfo(data)
    end

    if cardCaught then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardCaught.nChairNO)
        if 0 < drawIndex then
            if drawIndex == self:getMyDrawIndex() then
                local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
                if MJPGCHManager then
                    MJPGCHManager:hidePGCHBtns()
                end
            end

            local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
            if MJChoseCardsManager then
                MJChoseCardsManager:resetMJChoseCardsManager()
            end

            self:playGamePublicSound("Snd_Catch")

            -- Hide clock
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            -- Deal with thrown card
            local lastThrownCardID = nil
            local preIndex = self:getPreIndex(drawIndex)
            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                lastThrownCardID = thrownCardsManager:getLastThrownCardID(preIndex)
                thrownCardsManager:clearThrownCard(preIndex)
            end

            -- Deal with castoff card
            local castoffCardsManager = self._baseGameScene:getMJCastoffCardsManager()
            if castoffCardsManager and -1 < lastThrownCardID then
                castoffCardsManager:castoffCard(preIndex, lastThrownCardID)
            end

            -- Deal with hand cards
            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardCaught(drawIndex, cardCaught.nCardID)
            end

            local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
            if MJPGCHManager then
                MJPGCHManager:setCardCaught(cardCaught)
            end

            -- Deal with clock
            local throwWait = 10
            if self._baseGameUtilsInfoManager then
                throwWait = self._baseGameUtilsInfoManager:getThrowWait()
            end
            if clock then
                clock:start(throwWait)
            end

            local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
            if MJHandCardsManager then
                MJHandCardsManager:setEnableTouch(true)
            end
        end
    end
end

function MJGameController:onCatchCardFinished(drawIndex, cardID)
    if drawIndex == self:getMyDrawIndex() and self:isClockPointToSelf() then
        if MJCalculator:MJ_IsHuaEx(cardID, self:getJokerID(), self:getJokerID2(), self:getGameFlags()) then
            self:onThrowCard(cardID)
        else
            self:ope_JudgeOperation()
        end
    end

    local gameInfo = self._baseGameScene:getGameInfo()
    if gameInfo then
        gameInfo:onCatchOneCard()
    end
end

function MJGameController:ope_JudgeOperation()
    self:ope_JudgeGangSelf()
    self:ope_JudgeZiMoHuSelf()
end

function MJGameController:ope_JudgeGangSelf()
    local canGang = false
    local handCardsManager = self._baseGameScene:getMJHandCardsManager()
    if not handCardsManager or not handCardsManager:isNeedThrow(self:getMyDrawIndex()) then
        return false
    end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        local selfHandCardIDs = nil
        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            selfHandCardIDs = handCardsManager:getSelfHandCardIDs()
        end

        local selfPengCardIDs = nil
        local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
        if PGCCardsManager then
            selfPengCardIDs = PGCCardsManager:getSelfPengCardIDs()
        end

        if selfHandCardIDs and selfPengCardIDs then
            local startIndex = #selfHandCardIDs
            for i = 1, #selfPengCardIDs do
                selfHandCardIDs[startIndex + i] = selfPengCardIDs[i]
            end
        end

        if selfHandCardIDs and "table" == type(selfHandCardIDs) then
            local gangCardIDs= {}
            if MJCalculator:MJ_CanGangSelfEx(selfHandCardIDs, MJGameDef.MJ_CHAIR_CARDS, self:getJokerID(), self:getJokerID2(), self:getGameFlags(), gangCardIDs) then
                MJPGCHManager:ope_showGangBtn()
                canGang = true
            end
        end
    end
    return canGang
end

function MJGameController:ope_JudgeZiMoHuSelf()
    local canHuZiMo = false
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        if self:IS_BIT_SET(MJPGCHManager:getCurrentFlags(), MJGameDef.MJ_HU) then
            MJPGCHManager:ope_showHuBtn()
            canHuZiMo = true
        end
    end
    return canHuZiMo
end

function MJGameController:isCardHuaResponse(data)
    local bCardHuaResponse = false

    local cardHua = nil
    if self._baseGameData then
        cardHua = self._baseGameData:getCardHuaInfo(data)
    end

    if cardHua then
        local playerInfoManager = self:getPlayerInfoManager()
        if playerInfoManager then
            bCardHuaResponse = (playerInfoManager:getSelfChairNO() == cardHua.nChairNO)
        end
    end

    return bCardHuaResponse
end

function MJGameController:onCardHua(data)
    local cardHua = nil
    if self._baseGameData then
        cardHua = self._baseGameData:getCardHuaInfo(data)
    end

    if cardHua then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardHua.nChairNO)
        if 0 < drawIndex then
            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardHua(drawIndex, cardHua.nCardID, cardHua.nCardGot)
            end

            self:addPlayerFlower(drawIndex)
            self:playOperationEffectByName("Hua", self:getPlayerNickSexByIndex(drawIndex))
            self:playGamePublicSound("Snd_Catch")
        end
    end
end

function MJGameController:onCardPeng(data)
    local cardPeng = nil
    if self._baseGameData then
        cardPeng = self._baseGameData:getCardPGCInfo(data)
    end

    if cardPeng then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardPeng.nChairNO)
        if 0 < drawIndex then
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardPeng(drawIndex, cardPeng.nBaseIDs)
            end

            local sourceIndex = 1
            local pengIndex = self:rul_GetDrawIndexByChairNO(cardPeng.nCardChair)
            if pengIndex > 0 then
                sourceIndex = pengIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardPeng(drawIndex, sourceIndex, cardPeng.nBaseIDs, cardPeng.nCardID)
            end

            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                thrownCardsManager:clearThrownCard(sourceIndex)
            end

            if clock then
                local throwWait = 15
                if self._baseGameUtilsInfoManager then
                    throwWait = self._baseGameUtilsInfoManager:getThrowWait()
                end
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:onCardMnGang(data)
    local cardMnGang = nil
    if self._baseGameData then
        cardMnGang = self._baseGameData:getCardPGCInfo(data)
    end

    if cardMnGang then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardMnGang.nChairNO)
        if 0 < drawIndex then
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardMnGang(drawIndex, cardMnGang.nBaseIDs, cardMnGang.nCardGot)
            end

            local sourceIndex = 1
            local gangIndex = self:rul_GetDrawIndexByChairNO(cardMnGang.nCardChair)
            if gangIndex > 0 then
                sourceIndex = gangIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardMnGang(drawIndex, sourceIndex, cardMnGang.nBaseIDs, cardMnGang.nCardID)
            end

            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                thrownCardsManager:clearThrownCard(sourceIndex)
            end

            if clock then
                local throwWait = 15
                if self._baseGameUtilsInfoManager then
                    throwWait = self._baseGameUtilsInfoManager:getThrowWait()
                end
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:onCardAnGang(data)
    local cardAnGang = nil
    if self._baseGameData then
        cardAnGang = self._baseGameData:getCardPGCInfo(data)
    end

    if cardAnGang then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardAnGang.nChairNO)
        if 0 < drawIndex then
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
            if MJChoseCardsManager then
                MJChoseCardsManager:resetMJChoseCardsManager()
            end

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardAnGang(drawIndex, cardAnGang.nBaseIDs, cardAnGang.nCardID, cardAnGang.nCardGot)
            end

            local sourceIndex = 1
            local gangIndex = self:rul_GetDrawIndexByChairNO(cardAnGang.nCardChair)
            if gangIndex > 0 then
                sourceIndex = gangIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardAnGang(drawIndex, sourceIndex, cardAnGang.nBaseIDs, cardAnGang.nCardID)
            end

            if clock then
                local throwWait = clock:getDigit() + MJGameDef.MJ_ADD_SECOND_AFTER_GANG
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:onCardPnGang(data)
    local cardPnGang = nil
    if self._baseGameData then
        cardPnGang = self._baseGameData:getCardPGCInfo(data)
    end

    if cardPnGang then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardPnGang.nChairNO)
        if 0 < drawIndex then
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
            if MJChoseCardsManager then
                MJChoseCardsManager:resetMJChoseCardsManager()
            end

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardPnGang(drawIndex, cardPnGang.nCardID, cardPnGang.nCardGot)
            end

            local sourceIndex = 1
            local gangIndex = self:rul_GetDrawIndexByChairNO(cardPnGang.nCardChair)
            if gangIndex > 0 then
                sourceIndex = gangIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardPnGang(drawIndex, sourceIndex, cardPnGang.nBaseIDs, cardPnGang.nCardID)
            end

            if clock then
                local throwWait = clock:getDigit() + MJGameDef.MJ_ADD_SECOND_AFTER_GANG
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:onCardChi(data)
    local cardChi = nil
    if self._baseGameData then
        cardChi = self._baseGameData:getCardPGCInfo(data)
    end

    if cardChi then
        local drawIndex = self:rul_GetDrawIndexByChairNO(cardChi.nChairNO)
        if 0 < drawIndex then
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
            if MJChoseCardsManager then
                MJChoseCardsManager:resetMJChoseCardsManager()
            end

            self:playOperationEffectByName("Chi", self:getPlayerNickSexByIndex(drawIndex))

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardChi(drawIndex, cardChi.nBaseIDs)
            end

            local sourceIndex = 1
            local chiIndex = self:rul_GetDrawIndexByChairNO(cardChi.nCardChair)
            if chiIndex > 0 then
                sourceIndex = chiIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardChi(drawIndex, sourceIndex, cardChi.nBaseIDs, cardChi.nCardID)
            end

            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                thrownCardsManager:clearThrownCard(sourceIndex)
            end

            if clock then
                local throwWait = 15
                if self._baseGameUtilsInfoManager then
                    throwWait = self._baseGameUtilsInfoManager:getThrowWait()
                end
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:onCardGuo()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()
    end
    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    self:onGameClockZero()
end

function MJGameController:onGameWin(data)
    self:stopResponseTimer()
    self:gameStop()

    if not self:isResume() then
        self:setResponse(self:getResWaitingNothing())
    end

    local clock = self._baseGameScene:getClock()
    if clock then
        clock:resetClock()
    end

    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:onGameWin()
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:onHidePlayerInfo()
    end

    local safeBox = self._baseGameScene:getSafeBox()
    if safeBox then
        safeBox:showSafeBox(false)
    end

    local chat = self._baseGameScene:getChat()
    if chat and chat:isVisible() then
        chat:showChat(false)
    end

    local setting = self._baseGameScene:getSetting()
    if setting and setting:isVisible() then
        setting:showSetting(false)
    end

    --self:ope_AutoPlay(false)

    local gameWin = nil
    if self._baseGameData then
        gameWin = self._baseGameData:getGameWinInfo(data)
    end
    if gameWin then
        for i = 1, self:getTableChairCount() do
            local deposit = gameWin.nDepositDiffs[i]
            local score = gameWin.nScoreDiffs[i]
            local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
            if 0 < drawIndex then
                self:addPlayerDeposit(drawIndex, deposit)
                self:addPlayerScore(drawIndex, score)
                self:addPlayerBoutInfo(drawIndex, deposit)
            end
        end

        self:showGameResultInfo(gameWin)
    end
end

function MJGameController:showGameResultInfo(gameWin)
    self._baseGameScene:showResultLayer(gameWin)
end

function MJGameController:hideGameResultInfo()
    self._baseGameScene:closeResultLayer()
end

function MJGameController:onCloseResultLayer()
    self:hideGameResultInfo()
    self:ope_ShowStart(true)
end

function MJGameController:onShareResult()
end

function MJGameController:onRestart()
    self:onCloseResultLayer()
    self:onStartGame()
end

function MJGameController:rspCardsThrow(data)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:clearWaitingOperation()
        MJPGCHManager:clearQiangGangInfo()
        MJPGCHManager:hidePGCHBtns()

        local cardID = MJPGCHManager:getReqThrowCardInfo()
        local drawIndex = self:getMyDrawIndex()

        self:playGamePublicSound("Snd_Throw")
        self:playCardEffectByID(cardID, self:getPlayerNickSexByIndex(drawIndex))

        -- Hide clock
        local clock = self._baseGameScene:getClock()
        if clock then
            clock:hideClock()
        end

        -- Deal with hand cards
        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            handCardsManager:onCardsThrow(drawIndex, cardID)
        end

        -- Deal with thrown card
        local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
        if thrownCardsManager then
            thrownCardsManager:onCardsThrow(drawIndex, cardID)
        end

        -- Deal with clock
        local pgchWait = 5
        if self._baseGameUtilsInfoManager then
            pgchWait = self._baseGameUtilsInfoManager:getPGCHWait()
        end
        if clock then
            clock:start(pgchWait)
            local nextIndex = self:getNextIndex(drawIndex)
            clock:moveClockHandTo(nextIndex)
        end
    end
end

function MJGameController:rspCardPeng(data)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:clearWaitingOperation()
        MJPGCHManager:clearQiangGangInfo()
        MJPGCHManager:hidePGCHBtns()

        local cardChair, cardID, baseIDs = MJPGCHManager:getReqPengCardInfo()
        local drawIndex = self:getMyDrawIndex()

        local clock = self._baseGameScene:getClock()
        if clock then
            clock:hideClock()
        end

        local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
        if thrownCardsManager then
            thrownCardsManager:clearThrownCards()
        end

        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            handCardsManager:onCardPeng(drawIndex, baseIDs)
            handCardsManager:ope_resetSelfCardsPos()
            handCardsManager:ope_resetSelfCardsState()
        end

        local sourceIndex = 1
        local pengIndex = self:rul_GetDrawIndexByChairNO(cardChair)
        if pengIndex > 0 then
            sourceIndex = pengIndex
        end
        local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
        if PGCCardsManager then
            PGCCardsManager:onCardPeng(drawIndex, sourceIndex, baseIDs, cardID)
        end

        if clock then
            local throwWait = 15
            if self._baseGameUtilsInfoManager then
                throwWait = self._baseGameUtilsInfoManager:getThrowWait()
            end
            clock:start(throwWait)
        end
    end
end

function MJGameController:rspCardMnGang(data)
    local cardCaught = nil
    if self._baseGameData then
        cardCaught = self._baseGameData:getCardCaughtInfo(data)
    end

    if cardCaught then
        local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
        if MJPGCHManager then
            MJPGCHManager:clearWaitingOperation()
            MJPGCHManager:clearQiangGangInfo()
            MJPGCHManager:hidePGCHBtns()

            local cardChair, cardID, baseIDs = MJPGCHManager:getReqMnGangCardInfo()
            local drawIndex = self:getMyDrawIndex()

            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                thrownCardsManager:clearThrownCards()
            end

            local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
            if MJChoseCardsManager then
                MJChoseCardsManager:resetMJChoseCardsManager()
            end

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardMnGang(drawIndex, baseIDs, cardCaught.nCardID)
                handCardsManager:ope_resetSelfCardsPos()
                handCardsManager:ope_resetSelfCardsState()
            end

            if MJPGCHManager then
                MJPGCHManager:setCardCaught(cardCaught)
            end

            local sourceIndex = 1
            local gangIndex = self:rul_GetDrawIndexByChairNO(cardChair)
            if gangIndex > 0 then
                sourceIndex = gangIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardMnGang(drawIndex, sourceIndex, baseIDs, cardID)
            end

            if clock then
                local throwWait = 15
                if self._baseGameUtilsInfoManager then
                    throwWait = self._baseGameUtilsInfoManager:getThrowWait()
                end
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:rspCardAnGang(data)
    local cardCaught = nil
    if self._baseGameData then
        cardCaught = self._baseGameData:getCardCaughtInfo(data)
    end

    if cardCaught then
        local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
        if MJPGCHManager then
            MJPGCHManager:clearWaitingOperation()
            MJPGCHManager:clearQiangGangInfo()
            MJPGCHManager:hidePGCHBtns()

            local cardChair, cardID, baseIDs = MJPGCHManager:getReqAnGangCardInfo()
            local drawIndex = self:getMyDrawIndex()

            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                thrownCardsManager:clearThrownCards()
            end

            local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
            if MJChoseCardsManager then
                MJChoseCardsManager:resetMJChoseCardsManager()
            end

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardAnGang(drawIndex, baseIDs, cardID, cardCaught.nCardID)
--                handCardsManager:ope_resetSelfCardsPos()
--                handCardsManager:ope_resetSelfCardsState()
            end

            if MJPGCHManager then
                MJPGCHManager:setCardCaught(cardCaught)
            end

            local sourceIndex = 1
            local gangIndex = self:rul_GetDrawIndexByChairNO(cardChair)
            if gangIndex > 0 then
                sourceIndex = gangIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardAnGang(drawIndex, sourceIndex, baseIDs, cardID)
            end

            if clock then
                local throwWait = clock:getDigit() + MJGameDef.MJ_ADD_SECOND_AFTER_GANG
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:rspCardPnGang(data)
    local cardCaught = nil
    if self._baseGameData then
        cardCaught = self._baseGameData:getCardCaughtInfo(data)
    end

    if cardCaught then
        local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
        if MJPGCHManager then
            MJPGCHManager:clearWaitingOperation()
            MJPGCHManager:clearQiangGangInfo()
            MJPGCHManager:hidePGCHBtns()

            local cardChair, cardID, baseIDs = MJPGCHManager:getReqPnGangCardInfo()
            local drawIndex = self:getMyDrawIndex()

            local clock = self._baseGameScene:getClock()
            if clock then
                clock:hideClock()
            end

            local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
            if thrownCardsManager then
                thrownCardsManager:clearThrownCards()
            end

            local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
            if MJChoseCardsManager then
                MJChoseCardsManager:resetMJChoseCardsManager()
            end

            local handCardsManager = self._baseGameScene:getMJHandCardsManager()
            if handCardsManager then
                handCardsManager:onCardPnGang(drawIndex, cardID, cardCaught.nCardID)
--                handCardsManager:ope_resetSelfCardsPos()
--                handCardsManager:ope_resetSelfCardsState()
            end

            if MJPGCHManager then
                MJPGCHManager:setCardCaught(cardCaught)
            end

            local sourceIndex = 1
            local gangIndex = self:rul_GetDrawIndexByChairNO(cardChair)
            if gangIndex > 0 then
                sourceIndex = gangIndex
            end
            local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
            if PGCCardsManager then
                PGCCardsManager:onCardPnGang(drawIndex, sourceIndex, baseIDs, cardID)
            end

            if clock then
                local throwWait = clock:getDigit() + MJGameDef.MJ_ADD_SECOND_AFTER_GANG
                clock:start(throwWait)
            end
        end
    end
end

function MJGameController:rspCardChi(data)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:clearWaitingOperation()
        MJPGCHManager:clearQiangGangInfo()
        MJPGCHManager:hidePGCHBtns()

        local cardChair, cardID, baseIDs = MJPGCHManager:getReqChiCardInfo()
        local drawIndex = self:getMyDrawIndex()

        local clock = self._baseGameScene:getClock()
        if clock then
            clock:hideClock()
        end

        local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
        if thrownCardsManager then
            thrownCardsManager:clearThrownCards()
        end

        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            handCardsManager:onCardChi(drawIndex, baseIDs)
--            handCardsManager:ope_resetSelfCardsPos()
--            handCardsManager:ope_resetSelfCardsState()
        end

        local sourceIndex = 1
        local chiIndex = self:rul_GetDrawIndexByChairNO(cardChair)
        if chiIndex > 0 then
            sourceIndex = chiIndex
        end
        local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
        if PGCCardsManager then
            PGCCardsManager:onCardChi(drawIndex, sourceIndex, baseIDs, cardID)
        end

        if clock then
            local throwWait = 15
            if self._baseGameUtilsInfoManager then
                throwWait = self._baseGameUtilsInfoManager:getThrowWait()
            end
            clock:start(throwWait)
        end
    end
end

function MJGameController:rspCardHua(data)
    local cardCaught = nil
    if self._baseGameData then
        cardCaught = self._baseGameData:getCardCaughtInfo(data)
    end

    if cardCaught then
        local cardID = -1
        local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
        if MJPGCHManager then
            cardID = MJPGCHManager:getReqThrowCardInfo()
            MJPGCHManager:hidePGCHBtns()
        end
        local drawIndex = self:getMyDrawIndex()

        self:playOperationEffectByName("Hua", self:getPlayerNickSexByIndex(drawIndex))

        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            handCardsManager:onCardHua(drawIndex, cardID, cardCaught.nCardID)
--            handCardsManager:ope_resetSelfCardsPos()
--            handCardsManager:ope_resetSelfCardsState()
        end

        if MJPGCHManager then
            MJPGCHManager:setCardCaught(cardCaught)
        end

        self:addPlayerFlower(drawIndex)
    end
end

function MJGameController:rspCardCaught(data)
    local cardCaught = nil
    if self._baseGameData then
        cardCaught = self._baseGameData:getCardCaughtInfo(data)
    end

    if cardCaught then
        local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
        if MJPGCHManager then
            MJPGCHManager:hidePGCHBtns()
        end

        local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
        if MJChoseCardsManager then
            MJChoseCardsManager:resetMJChoseCardsManager()
        end

        self:playGamePublicSound("Snd_Catch")

        -- Hide clock
        local clock = self._baseGameScene:getClock()
        if clock then
            clock:hideClock()
        end
        local drawIndex = self:getMyDrawIndex()

        -- Deal with thrown card
        local lastThrownCardID = nil
        local preIndex = self:getPreIndex(drawIndex)
        local thrownCardsManager = self._baseGameScene:getMJThrownCardsManager()
        if thrownCardsManager then
            lastThrownCardID = thrownCardsManager:getLastThrownCardID(preIndex)
            thrownCardsManager:clearThrownCard(preIndex)
        end

        -- Deal with castoff card
        local castoffCardsManager = self._baseGameScene:getMJCastoffCardsManager()
        if castoffCardsManager and -1 < lastThrownCardID then
            castoffCardsManager:castoffCard(preIndex, lastThrownCardID)
        end

        -- Deal with hand cards
        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            handCardsManager:onCardCaught(self:getMyDrawIndex(), cardCaught.nCardID)
        end

        local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
        if MJPGCHManager then
            MJPGCHManager:setCardCaught(cardCaught)
        end

        -- Deal with clock
        local throwWait = 10
        if self._baseGameUtilsInfoManager then
            throwWait = self._baseGameUtilsInfoManager:getThrowWait()
        end
        if clock then
            clock:start(throwWait)
        end

        local MJHandCardsManager = self._baseGameScene:getMJHandCardsManager()
        if MJHandCardsManager then
            MJHandCardsManager:setEnableTouch(true)
        end
    end

    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:clearWaitingOperation()
        MJPGCHManager:clearQiangGangInfo()
        MJPGCHManager:setCardCaught(cardCaught)
    end
end

function MJGameController:onCardPrePeng(data)
    local cardPeng = nil
    if self._baseGameData then
        cardPeng = self._baseGameData:getCardPGCInfo(data)
    end

    if cardPeng then
        self:playOperationEffectByName("PrePeng", self:getPlayerNickSexByUserID(cardPeng.nUserID))
    end
end

function MJGameController:onCardPreChi(data)
    local cardChi = nil
    if self._baseGameData then
        cardChi = self._baseGameData:getCardPGCInfo(data)
    end

    if cardChi then
        self:playOperationEffectByName("PreChi", self:getPlayerNickSexByUserID(cardChi.nUserID))
    end
end

function MJGameController:onCardPreGangOK(data)
    local cardPreGangOK = nil
    if self._baseGameData then
        cardPreGangOK = self._baseGameData:getCardPreGangOKInfo(data)
    end

    if cardPreGangOK then
        self:playOperationEffectByName("PreGang", self:getPlayerNickSexByUserID(cardPreGangOK.nUserID))

        if cardPreGangOK.dwFlags == MJGameDef.MJ_GANG_PN then
            local pgchWait = 5
            if self._baseGameUtilsInfoManager then
                pgchWait = self._baseGameUtilsInfoManager:getPGCHWait()
            end
            local clock = self._baseGameScene:getClock()
            if clock then
                clock:start(pgchWait)
            end
        end

        local playerInfoManager = self:getPlayerInfoManager()
        if playerInfoManager then
            if self:IS_BIT_SET(cardPreGangOK.dwResults[playerInfoManager:getSelfChairNO() + 1], MJGameDef.MJ_HU) then
                local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
                if MJPGCHManager and self._baseGameUtilsInfoManager then
                    MJPGCHManager:setQiangGangInfo(cardPreGangOK.dwFlags, cardPreGangOK.nCardID, cardPreGangOK.nCardChair)
                    MJPGCHManager:ope_showHuBtn()
                end
            end
        end
    end
end

function MJGameController:onMJOperationFailed(response)
    local switchAction = {
        [MJGameDef.MJ_WAITING_THROW_CARDS]  = function(response) self:tipMessageByGBStr("throw card failed!") end,
        [MJGameDef.MJ_WAITING_CATCH_CARDS]  = function(response) self:tipMessageByGBStr("catch card failed!") end,
        [MJGameDef.MJ_WAITING_PENG_CARDS]   = function(response) self:tipMessageByGBStr("peng card failed!") end,
        [MJGameDef.MJ_WAITING_MNGANG_CARDS] = function(response) self:tipMessageByGBStr("mngang card failed!") end,
        [MJGameDef.MJ_WAITING_ANGANG_CARDS] = function(response) self:tipMessageByGBStr("angang card failed!") end,
        [MJGameDef.MJ_WAITING_PNGANG_CARDS] = function(response) self:tipMessageByGBStr("penggang card failed!") end,
        [MJGameDef.MJ_WAITING_CHI_CARDS]    = function(response) self:tipMessageByGBStr("chi card failed!") end,
        [MJGameDef.MJ_WAITING_HU_CARDS]     = function(response) self:tipMessageByGBStr("hu card failed!") end,
        [MJGameDef.MJ_WAITING_HUA_CARDS]    = function(response) self:tipMessageByGBStr("hua card failed!") end,
    }
    if switchAction[response] then
        if 0 < DEBUG then
            switchAction[response](response)
        end
    end

    if self._baseGameConnect then
        self._baseGameConnect:gc_GetTableInfo()
    end
end

function MJGameController:rspCardOperationWait(response)
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if not MJPGCHManager then return end

    local switchAction = {
        [MJGameDef.MJ_WAITING_PENG_CARDS]       = function()
        end,
        [MJGameDef.MJ_WAITING_MNGANG_CARDS]     = function()
        end,
        [MJGameDef.MJ_WAITING_PNGANG_CARDS]     = function()
            local clock = self._baseGameScene:getClock()
            if clock then
                local pgchWait = 5
                if self._baseGameUtilsInfoManager then
                    pgchWait = self._baseGameUtilsInfoManager:getPGCHWait()
                end
                clock:start(pgchWait)
            end
        end,
        [MJGameDef.MJ_WAITING_CHI_CARDS]        = function()
        end,
        [MJGameDef.MJ_WAITING_HU_CARDS]         = function()
            
        end,
    }

    if switchAction[response] then
        switchAction[response]()

        MJPGCHManager:setWaitingOperation(response)
        MJPGCHManager:hidePGCHBtns()
    end
end

function MJGameController:playCardEffectByID(cardID, nickSex)
    local sexFolderName = "MaleSound/"
    if 1 == nickSex then
        sexFolderName = "FemaleSound/"
    end

    local soundName = tostring(MJCalculator:MJ_CalcIndexByID(cardID, 0))

    self:playEffect(sexFolderName .. "cardSound_" ..soundName .. ".ogg")
end

function MJGameController:playOperationEffectByName(name, nickSex)
    local sexFolderName = "MaleSound/"
    if 1 == nickSex then
        sexFolderName = "FemaleSound/"
    end

    self:playEffect(sexFolderName .. "operation" ..name .. ".ogg")
end

function MJGameController:playDealCardEffect()
    self:playGamePublicSound("Snd_Throw")
end

function MJGameController:playWinEffectByName(name, nickSex)
    local sexFolderName = "MaleSound/"
    if 1 == nickSex then
        sexFolderName = "FemaleSound/"
    end

    self:playEffect(sexFolderName .. "winSound_" ..name .. ".ogg")
end

function MJGameController:getPlayerNickSexByUserID(userID)
    local nickSex = 0
    local playerInfoManager = self:getPlayerInfoManager()
    if playerInfoManager then
        nickSex = playerInfoManager:getPlayerNickSexByUserID(userID)
    end
    return nickSex
end

function MJGameController:getPlayerNickSexByIndex(drawIndex)
    local nickSex = 0
    local playerInfoManager = self:getPlayerInfoManager()
    if playerInfoManager then
        nickSex = playerInfoManager:getPlayerNickSexByIndex(drawIndex)
    end
    return nickSex
end

return MJGameController
