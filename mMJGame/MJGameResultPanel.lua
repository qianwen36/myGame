
local MJGameResultPanel = class("MJGameResultPanel", ccui.Layout)

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")

function MJGameResultPanel:ctor(gameWin, gameController)
    if not gameWin then printError("gameWin is nil!!!") return end
    if not gameController then printError("gameController is nil!!!") return end
    self._gameWin               = gameWin
    self._gameController        = gameController

    self._resultPanel           = nil

    if self.onCreate then self:onCreate() end
end

function MJGameResultPanel:onCreate()
    self:init()
end

function MJGameResultPanel:init()
    self:initResultPanel()
end

function MJGameResultPanel:initResultPanel()
    local csbPath = "res/GameCocosStudio/result/PanelResult.csb"
    self._resultPanel = cc.CSLoader:createNode(csbPath)
    if self._resultPanel then
        self:addChild(self._resultPanel)

        local panelWin = self._resultPanel:getChildByName("Panel_win")
        if panelWin then panelWin:setVisible(false) end
        local panelLose = self._resultPanel:getChildByName("Panel_lose")
        if panelLose then panelLose:setVisible(false) end
        local panelPing = self._resultPanel:getChildByName("Panel_ping")
        if panelPing then panelPing:setVisible(false) end

        local result = nil

        if self._gameWin.dwWinFlags == MJGameDef.MJ_GW_STANDOFF then
            result = panelPing
        else
            if 0 < self._gameWin.nDepositDiffs[self._gameController:getMyChairNO() + 1] then
                result = panelWin
            else
                result = panelLose
            end
        end

        if result then
            result:setVisible(true)

            -- button
            local function onClose()
                self:onClose()
            end
            local buttonClose = result:getChildByName("result_btn_close")
            if buttonClose then
                buttonClose:addClickEventListener(onClose)
            end
            local function onShare()
                self:onShare()
            end
            local buttonShare = result:getChildByName("result_btn_share")
            if buttonShare then
                buttonShare:addClickEventListener(onShare)
            end
            local function onRestart()
                self:onRestart()
            end
            local buttonRestart = result:getChildByName("result_btn_restart")
            if buttonRestart then
                buttonRestart:addClickEventListener(onRestart)
            end

            -- name
            for i = 1, self._gameController:getTableChairCount() do
                local nameText = result:getChildByName("result_text_name" .. i)
                if nameText then
                    local szUserName = self._gameController:getPlayerUserNameByDrawIndex(i)
                    if szUserName then
                        local utf8Name = MCCharset:getInstance():gb2Utf8String(szUserName, string.len(szUserName))
                        nameText:setString(utf8Name)
                    end
                end
            end

            -- deposite
            for i = 1, self._gameController:getTableChairCount() do
                local depositeText = result:getChildByName("result_text_deposit" .. i)
                if depositeText then
                    local deposite = self._gameWin.nDepositDiffs[self._gameController:rul_GetChairNOByDrawIndex(i) + 1] +
                        self._gameWin.nWinFees[self._gameController:rul_GetChairNOByDrawIndex(i) + 1]
                    if deposite then
                        local signal = "+"
                        if deposite < 0 then
                            signal = ""
                        end
                        depositeText:setString(signal .. tostring(deposite))

                        if i == self._gameController:getMyDrawIndex() then
                            local digitDeposit = result:getChildByName("result_digit_deposit")
                            if digitDeposit then
                                digitDeposit:setString(tostring(deposite))
                            end
                        end
                    end
                end
            end

            local nBaseDeposit = self._gameWin.nBaseDeposit
            local baseDepositText = result:getChildByName("result_text_basedeposit")
            if baseDepositText then
                local msg = string.format(self._gameController:getGameStringByKey("G_RESULT_BASEDEPOSIT"), nBaseDeposit)
                local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
                baseDepositText:setString(utf8Msg)
            end

            local nWinFee = self._gameWin.nWinFees[self._gameController:getMyChairNO() + 1]
            local winFeeText = result:getChildByName("result_text_costdeposit")
            if winFeeText then
                local msg = string.format(self._gameController:getGameStringByKey("G_RESULT_COSTDEPOSIT"), nWinFee)
                local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
                winFeeText:setString(utf8Msg)
            end
        end
    end
end

function MJGameResultPanel:onClose()
    self._gameController:playBtnPressedEffect()

    self._gameController:onCloseResultLayer()
end

function MJGameResultPanel:onShare()
    self._gameController:playBtnPressedEffect()

    self._gameController:onShareResult()
end

function MJGameResultPanel:onRestart()
    self._gameController:playBtnPressedEffect()

    self._gameController:onRestart()
end

return MJGameResultPanel
