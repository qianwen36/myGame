
local MJGameNotify = import("..mMJGame.MJGameNotify")
local MyGameNotify = class("MyGameNotify", MJGameNotify)

local BaseGameDef                               = import("..mBaseGame.BaseGameDef")
local MyGameDef                                 = import(".MyGameDef")

function MyGameNotify:onNotifyReceived(request, msgType, session, data)
    if self:discardOutDateNotify(request) then return end
   	
    if self._gameController:getSession() == session then
        self._gameController:onResponse()
    end

    local switchAction = {
        [MyGameDef.MY_GR_GIVEUP_HU]             = function(data)
            self:onGiveUpHu(data)
        end,

        [MyGameDef.MY_GR_TING_MJ_OTHER]         = function(data)
            self:onPlayerTing(data)
        end,
    }

    if switchAction[request] then
        switchAction[request](data)
    else
        MyGameNotify.super.onNotifyReceived(self, request, msgType, session, data)
    end
end

function MyGameNotify:handleResponse(response, data)
    local switchAction = {
        [MyGameDef.MY_WAITING_GIVEUP_HU]        = function()
            self:rspGiveUpHu()
        end,

        [MyGameDef.MY_WAITING_MJ_TING]          = function()
            self:rspPlayerTing()
        end,
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response](data)
    else
        MyGameNotify.super.handleResponse(self, response, data)
    end
end

function MyGameNotify:handleFailedResponse(request, msgType, session, data)
    if msgType == BaseGameDef.BASEGAME_MSG_RESPONSE and session == self._gameController:getSession() then
        local switchAction = {
            [MyGameDef.MY_WAITING_GIVEUP_HU]    = function()
                self:onGiveUpHuFailed()
            end,

            [MyGameDef.MY_WAITING_MJ_TING]      = function()
                self:onPlayerTingFailed()
            end,
        }

        local response = self._gameController:getResponse()
        if switchAction[response] then
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            switchAction[response]()
            return true
        else
            return MyGameNotify.super.handleFailedResponse(self, request, msgType, session, data)
        end
    end
    return false
end

function MyGameNotify:onGiveUpHu(data)
    print("onGiveUpHu")
    self._gameController:onGiveUpHu(data)
end

function MyGameNotify:rspGiveUpHu()
    print("rspGiveUpHu")
    self._gameController:rspGiveUpHu()
end

function MyGameNotify:onGiveUpHuFailed()
    print("onGiveUpHuFailed")
    self._gameController:onGiveUpHuFailed()
end

function MyGameNotify:onPlayerTing(data)
    print("onPlayerTing")
    --self._gameController:onPlayerTing(data)
end

function MyGameNotify:rspPlayerTing()
    print("rspPlayerTing")
    --self._gameController:rspPlayerTing()
end

function MyGameNotify:onPlayerTingFailed()
    print("onPlayerTingFailed")
    --self._gameController:onPlayerTingFailed()
end

return MyGameNotify
