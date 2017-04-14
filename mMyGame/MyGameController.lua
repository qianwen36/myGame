
if nil == cc or nil == cc.exports then
    return
end


local MJGameDef                                 = import("..mMJGame.MJGameDef")
local MyGameDef                                 = import(".MyGameDef")
local MJGameController                          = import("..mMJGame.MJGameController")

cc.exports.MyGameController                     = {}
local MyGameController                          = cc.exports.MyGameController

local MyGameData                                = import(".MyGameData")
local MyGameUtilsInfoManager                    = import(".MyGameUtilsInfoManager")
local MyGameConnect                             = import(".MyGameConnect")
local MyGameNotify                              = import(".MyGameNotify")

local MJCalculator                              = import("..mMJGame.MJCalculator")

MyGameController.super = MJGameController
setmetatable(MyGameController, {__index = MyGameController.super})


function MyGameController:createGameData()
    self._baseGameData = MyGameData:create()
end

function MyGameController:createUtilsInfoManager()
    self._baseGameUtilsInfoManager = MyGameUtilsInfoManager:create()
    self:setUtilsInfo()
end

function MyGameController:setConnect()
    self._baseGameConnect = MyGameConnect:create(self)
end

function MyGameController:setNotify()
    self._baseGameNotify = MyGameNotify:create(self)
end

-- For test
function MyGameController:getTableChairCount()
    return MyGameDef.MY_TOTAL_PLAYERS
end

function MyGameController:getMJTotalCards()
    return MyGameDef.MY_TOTAL_CARDS
end

function MyGameController:getGameFlags()
    return 0
end

function MyGameController:getQuan()
    if self._baseGameUtilsInfoManager then
        return self._baseGameUtilsInfoManager:getQuan()
    end
    return 1
end

function MyGameController:isLian()
    if self._baseGameUtilsInfoManager then
        return self._baseGameUtilsInfoManager:isLian()
    end
    return false
end

function MyGameController:ope_ShowFlowers()
    if self._baseGameUtilsInfoManager then
        local startInfo = self._baseGameUtilsInfoManager:getStartInfo()
        if startInfo then
            for i = 1, self:getTableChairCount() do
                local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                if 0 < drawIndex and startInfo.nHuaCount[i] then
                    self:setPlayerFlower(drawIndex, startInfo.nHuaCount[i])
                end
            end
        end
    end
end

function MyGameController:ope_StartPlay()
    local gameInfo = self._baseGameScene:getGameInfo()
    if gameInfo then
        gameInfo:setLastCardsCount(gameInfo:getLastCardsCount() - self:getStartHuaCount())
    end

    MyGameController.super.ope_StartPlay(self)
end

function MyGameController:getStartHuaCount()
    local huaCount = 0
    if self._baseGameUtilsInfoManager then
        local startInfo = self._baseGameUtilsInfoManager:getStartInfo()
        if startInfo then
            for i = 1, self:getTableChairCount() do
                if startInfo.nHuaCount[i] then
                    huaCount = huaCount + startInfo.nHuaCount[i]
                end
            end
        end
    end
    return huaCount
end

function MyGameController:onDouble()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:hidePGCHBtns()

        MJPGCHManager:setDouble(true)
    end
    local MJChoseCardsManager = self._baseGameScene:getMJChoseCardsManager()
    if MJChoseCardsManager then
        MJChoseCardsManager:resetMJChoseCardsManager()
    end

    if self._baseGameConnect then
        local huFang = 0
        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            if not handCardsManager:needThrow(self:getMyDrawIndex()) then
                huFang = 1
            end
        end
        self._baseGameConnect:reqDouble(huFang)
    end
end

function MyGameController:ope_JudgeOperation()
    if not self:ope_JudgeZiMoHuSelf() then
        self:ope_JudgeGangSelf()
    end
end

function MyGameController:clearGameTable()
    self:hideGameResultInfo()

    MyGameController.super.clearGameTable(self)
end

function MyGameController:onGameStart(data)
    MyGameController.super.onGameStart(self, data)
end

function MyGameController:onGameWin(data)
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

    local gameWin = nil
    if self._baseGameData then
        gameWin = self._baseGameData:getGameWinInfo(data)
    end
    if gameWin then
        if 0 == gameWin.nHuCount then
            self:playGamePublicSound("Snd_TanPai")
        else
            local drawIndex = self:rul_GetDrawIndexByChairNO(gameWin.nHuChair)
            if 0 < drawIndex then
                if -1 == gameWin.nLoseChair then
                    self:playWinEffectByName("zimo", self:getPlayerNickSexByIndex(drawIndex))
                else
                    self:playWinEffectByName("hu", self:getPlayerNickSexByIndex(drawIndex))
                end
            end
        end

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

        local showDownCardsManager = self._baseGameScene:getMJShowDownCardsManager()
        if showDownCardsManager then
            showDownCardsManager:resetShowDownCardsManager()

            for i = 1, self:getTableChairCount() do
                local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                if 0 < drawIndex then
                    local needThrow = false
                    local handCardsManager = self._baseGameScene:getMJHandCardsManager()
                    if handCardsManager then
                        needThrow = handCardsManager:needThrow(drawIndex)
                    end
                    if 0 < gameWin.nHuChairs[i] then
                        if self:IS_BIT_SET(gameWin.dwWinFlags, MJGameDef.MJ_GW_ZIMO) then
                            local huIndex = 1
                            for j = 1, gameWin.nCardsCount[i] do
                                if gameWin.nChairCards[i][j] and gameWin.nChairCards[i][j] == gameWin.nHuCard then
                                    huIndex = j
                                    break
                                end
                            end
                            if huIndex < gameWin.nCardsCount[i] then
                                for j = huIndex, gameWin.nCardsCount[i] - 1 do
                                    gameWin.nChairCards[i][j] = gameWin.nChairCards[i][j + 1]
                                end
                                needThrow = false
                                gameWin.nCardsCount[i] = gameWin.nCardsCount[i] - 1
                            end
                        end

                        showDownCardsManager:showDownHuCard(drawIndex, gameWin.nHuCard)
                    else
                    end
                    showDownCardsManager:showDownCards(drawIndex, gameWin.nChairCards[i], gameWin.nCardsCount[i], needThrow)
                end
            end
        end

        local PGCCardsManager = self._baseGameScene:getMJPGCCardsManager()
        if PGCCardsManager then
            PGCCardsManager:onGameWin()
        end

        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            handCardsManager:resetHandCardsManager()
        end

        self:showGameResultInfo(gameWin)
    end

    self:ope_ShowStart(true)
end

function MyGameController:showGameResultInfo(gameWin)
    local resultPanel = self._baseGameScene:getResultPanel()
    if resultPanel then
        resultPanel:showResultPanel(gameWin)
    end
end

function MyGameController:hideGameResultInfo()
    local resultPanel = self._baseGameScene:getResultPanel()
    if resultPanel then
        resultPanel:hideGameResultInfo()
    end
end

function MyGameController:onGiveUpHu(data)
end

function MyGameController:rspGiveUpHu()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:setDouble(true)

        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            if handCardsManager:needThrow(self:getMyDrawIndex()) then
                self:ope_JudgeGangSelf()
            else
                MJPGCHManager:showPGCHBtns()
            end
        end
        MJPGCHManager:setDouble(false)
    end
end

function MyGameController:onGiveUpHuFailed()
    local MJPGCHManager = self._baseGameScene:getMJPGCHManager()
    if MJPGCHManager then
        MJPGCHManager:setDouble(true)

        local handCardsManager = self._baseGameScene:getMJHandCardsManager()
        if handCardsManager then
            if handCardsManager:needThrow(self:getMyDrawIndex()) then
                self:ope_JudgeGangSelf()
            else
                MJPGCHManager:showPGCHBtns()
            end
        end
        MJPGCHManager:setDouble(false)
    end
end

return MyGameController
