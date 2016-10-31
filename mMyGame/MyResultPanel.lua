
local MyResultPanel = class("MyResultPanel")

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")

function MyResultPanel:create(resutPanel, gameController)
    return MyResultPanel.new(resutPanel, gameController)
end

function MyResultPanel:ctor(resutPanel, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._resutPanel            = resutPanel
    self._childPanel            = nil
    self._resultBG              = nil

    self:init()
end

function MyResultPanel:init()
    self._childPanel = self._resutPanel:getChildByName("Panel_result")
    if self._childPanel then
        self._resultBG = self._childPanel:getChildByName("result_bg")
    end
    self:setVisible(false)
end

function MyResultPanel:setVisible(visible)
    if self._childPanel then
        self._childPanel:setVisible(visible)
        if self._resultBG then
            self._resultBG:setVisible(visible)
        end
    end
end

function MyResultPanel:hideResultPanel()
    self:setVisible(false)
end

function MyResultPanel:hideAllChildren()
    if not self._childPanel then return end

    local resultChildren = self._childPanel:getChildren()
    for i = 1, self._childPanel:getChildrenCount() do
        local child = resultChildren[i]
        if child then
            child:setVisible(false)
        end
    end
end

function MyResultPanel:resetResultPanel()
    self:hideAllChildren()
end

function MyResultPanel:showResultPanel(gameWin)
    self:resetResultPanel()

    if self._childPanel then
        if gameWin.dwWinFlags == MJGameDef.MJ_GW_STANDOFF then
            local standoff = self._childPanel:getChildByName("text_standoff")
            if standoff then
                standoff:setVisible(true)
            end
        else
            local deposit = self._childPanel:getChildByName("text_deposit")
            if deposit then
                local chairNoIndex = self._gameController:rul_GetChairNOByDrawIndex(self._gameController:getMyDrawIndex()) + 1
                local winDeposit = gameWin.nDepositDiffs[chairNoIndex] + gameWin.nWinFees[chairNoIndex]
                local msg = string.format(self._gameController:getGameStringByKey("G_GAMERESULT_WIN"), winDeposit)
                if winDeposit < 0 then
                    msg = string.format(self._gameController:getGameStringByKey("G_GAMERESULT_LOSE"), -winDeposit)
                end
                local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
                deposit:setString(utf8Msg)
                deposit:setVisible(true)
            end

            local maxType = 100

            local fan = self._childPanel:getChildByName("text_fan")
            if fan then
                local nTotalFan = 0
                local nBaseTotalFan = 0

                for i = 1, maxType do
                    nBaseTotalFan = nBaseTotalFan + gameWin.nHuFanType[i]
                end
                if 0 < gameWin.nGiveUpHuGain then
                    nTotalFan = nTotalFan + (nBaseTotalFan + 2 * gameWin.nGiveUpHuGain) * math.pow(2, gameWin.nGiveUpHuGain)
                else
                    nTotalFan = nBaseTotalFan
                end

                local msg = string.format(self._gameController:getGameStringByKey("G_GAMERESULT_FAN"), nTotalFan)
                local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
                fan:setString(utf8Msg)
                fan:setVisible(true)
            end

            local double = self._childPanel:getChildByName("text_double")
            if double then
                local msg = string.format(self._gameController:getGameStringByKey("G_GAMERESULT_DOUBLE"), gameWin.nGiveUpHuGain)
                local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
                double:setString(utf8Msg)
                double:setVisible(true)
            end

            local huDetialIndex = 1
            for i = 1, maxType do
                if 0 < gameWin.nHuFanType[i] then
                    local huName = self._childPanel:getChildByName("text_name_" .. tostring(huDetialIndex))
                    if huName then
                        local huDetial = self._gameController:getGameStringByKey("G_GAMERESULT_GAINTEXT_" .. i)
                        local msg = string.format(self._gameController:getGameStringByKey("G_GAMERESULT_HUDETIAL"), huDetial, gameWin.nHuFanType[i])
                        local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
                        huName:setString(utf8Msg)
                        huName:setVisible(true)
                        huDetialIndex = huDetialIndex + 1
                    else
                        break
                    end
                end
            end
        end

        self:setVisible(true)
    end
end

function MyResultPanel:hideGameResultInfo()
    self:setVisible(false)
end

return MyResultPanel
