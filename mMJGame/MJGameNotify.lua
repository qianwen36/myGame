
local BaseGameNotify = import("src.app.Game.mBaseGame.BaseGameNotify")
local MJGameNotify = class("MJGameNotify", BaseGameNotify)

local BaseGameDef                           = import("src.app.Game.mBaseGame.BaseGameDef")
local MJGameDef                             = import("src.app.Game.mMJGame.MJGameDef")

function MJGameNotify:onNotifyReceived(request, msgType, session, data)
    if self:discardOutDateNotify(request) then return end

    local switchAction = {
        [MJGameDef.MJ_GR_GAME_START]        = function(data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            self:onGameStart(data)
        end,

        [MJGameDef.MJ_GR_CARDS_THROW]       = function(data)
            self:onCardsThrow(data)
        end,

        [MJGameDef.MJ_GR_CARD_CAUGHT]       = function(data)
            self:onCardCaught(data)
        end,

        [MJGameDef.MJ_GR_CARD_HUA]          = function(data)
            self:onCardHua(data)
        end,

        [MJGameDef.MJ_GR_CARD_PREPENG]      = function(data)
            self:onCardPrePeng(data)
        end,

        [MJGameDef.MJ_GR_CARD_PENG]         = function(data)
            self:onCardPeng(data)
        end,

        [MJGameDef.MJ_GR_CARD_PRECHI]       = function(data)
            self:onCardPreChi(data)
        end,

        [MJGameDef.MJ_GR_CARD_CHI]          = function(data)
            self:onCardChi(data)
        end,

        [MJGameDef.MJ_GR_PREGANG_OK]        = function(data)
            self:onCardPreGangOK(data)
        end,

        [MJGameDef.MJ_GR_CARD_MN_GANG]      = function(data)
            self:onCardMnGang(data)
        end,

        [MJGameDef.MJ_GR_CARD_AN_GANG]      = function(data)
            self:onCardAnGang(data)
        end,

        [MJGameDef.MJ_GR_CARD_PN_GANG]      = function(data)
            self:onCardPnGang(data)
        end,

        [MJGameDef.MJ_GR_CARD_GUO]          = function(data)
            self:onCardGuo(data)
        end,

        [MJGameDef.MJ_GR_GAME_WIN]          = function(data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            self:onGameWin(data)
        end,

        [MJGameDef.MJ_GR_GAMEDATA_ERROR]    = function(data)
            if self._gameController:getSession() == session then
                local ret = self:handleFailedResponse(request, msgType, session, data)
                if not ret then
                    self:operationFailed(self._gameController:getResponse())
                end
            end
        end,

        [MJGameDef.MJ_GR_NO_CARD_CATCH]     = function(data)
            if self._gameController:getSession() == session then
                self:handleEndResponse(self._gameController:getResponse())
                self._gameController:onResponse()
            end
        end,
    }

    if switchAction[request] then
        switchAction[request](data)
    else
        MJGameNotify.super.onNotifyReceived(self, request, msgType, session, data)
    end
end

function MJGameNotify:handleResponse(response, data)
    local switchAction = {
        [MJGameDef.MJ_WAITING_THROW_CARDS]      = function(data)
            self:rspCardsThrow(data)
        end,
        [MJGameDef.MJ_WAITING_CATCH_CARDS]      = function(data)
            self:rspCardCaught(data)
        end,
        [MJGameDef.MJ_WAITING_PENG_CARDS]       = function(data)
            self:rspCardPeng(data)
        end,
        [MJGameDef.MJ_WAITING_MNGANG_CARDS]     = function(data)
            self:rspCardMnGang(data)
        end,
        [MJGameDef.MJ_WAITING_ANGANG_CARDS]     = function(data)
            self:rspCardAnGang(data)
        end,
        [MJGameDef.MJ_WAITING_PNGANG_CARDS]     = function(data)
            self:rspCardPnGang(data)
        end,
        [MJGameDef.MJ_WAITING_CHI_CARDS]        = function(data)
            self:rspCardChi(data)
        end,
        [MJGameDef.MJ_WAITING_HU_CARDS]         = function()
        end,
        [MJGameDef.MJ_WAITING_HUA_CARDS]        = function(data)
            self:rspCardHua(data)
        end,
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response](data)
    else
        MJGameNotify.super.handleResponse(self, response, data)
    end
end

function MJGameNotify:handleWaitResponse(response)
    local switchAction = {
        [MJGameDef.MJ_WAITING_PENG_CARDS]       = function() self:rspCardOperationWait(response)    end,
        [MJGameDef.MJ_WAITING_MNGANG_CARDS]     = function() self:rspCardOperationWait(response)    end,
        [MJGameDef.MJ_WAITING_PNGANG_CARDS]     = function() self:rspCardOperationWait(response)    end,
        [MJGameDef.MJ_WAITING_CHI_CARDS]        = function() self:rspCardOperationWait(response)    end,
        [MJGameDef.MJ_WAITING_HU_CARDS]         = function() self:rspCardOperationWait(response)    end,
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response]()
    end
end

function MJGameNotify:handleEndResponse(response)
    local switchAction = {
        [MJGameDef.MJ_WAITING_CATCH_CARDS]      = function()    end,
        [MJGameDef.MJ_WAITING_MNGANG_CARDS]     = function()    end,
        [MJGameDef.MJ_WAITING_ANGANG_CARDS]     = function()    end,
        [MJGameDef.MJ_WAITING_PNGANG_CARDS]     = function()    end,
        [MJGameDef.MJ_WAITING_HUA_CARDS]        = function()    end,
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response]()
    end
end

function MJGameNotify:handleFailedResponse(request, msgType, session, data)
    if msgType == BaseGameDef.BASEGAME_MSG_RESPONSE and session == self._gameController:getSession() then
        local switchAction = {
            [MJGameDef.MJ_WAITING_THROW_CARDS]  = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_CATCH_CARDS]  = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_PENG_CARDS]   = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_MNGANG_CARDS] = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_ANGANG_CARDS] = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_PNGANG_CARDS] = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_CHI_CARDS]    = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_HU_CARDS]     = function(response) self:onMJOperationFailed(response) end,
            [MJGameDef.MJ_WAITING_HUA_CARDS]    = function(response) self:onMJOperationFailed(response) end,
        }

        local response = self._gameController:getResponse()
        if switchAction[response] then
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            switchAction[response](response)
            return true
        else
            return MJGameNotify.super.handleFailedResponse(self, request, msgType, session, data)
        end
    end
    return false
end

function MJGameNotify:operationFailed(response)
    local switchAction = {
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response]()
    else
        MJGameNotify.super.operationFailed(self, response)
    end
end

function MJGameNotify:discardOutDateNotify(request)
    if self._gameController:isResume() then
        local switchAction = {
            [MJGameDef.MJ_GR_CARDS_THROW]   = function() end,
            [MJGameDef.MJ_GR_CARD_CAUGHT]   = function() end,
            [MJGameDef.MJ_GR_CARD_PREPENG]  = function() end,
            [MJGameDef.MJ_GR_CARD_PENG]     = function() end,
            [MJGameDef.MJ_GR_CARD_PRECHI]   = function() end,
            [MJGameDef.MJ_GR_CARD_CHI]      = function() end,
            [MJGameDef.MJ_GR_CARD_GUO]      = function() end,
            [MJGameDef.MJ_GR_PREGANG_OK]    = function() end,
            [MJGameDef.MJ_GR_CARD_MN_GANG]  = function() end,
            [MJGameDef.MJ_GR_CARD_PN_GANG]  = function() end,
            [MJGameDef.MJ_GR_CARD_AN_GANG]  = function() end,
        }

        if switchAction[request] then
            return true
        else
            return MJGameNotify.super.discardOutDateNotify(self, request)
        end
    end
    return false
end

function MJGameNotify:onGameStart(data)
    print("onGameStart")
    self._gameController:onGameStart(data)
end

function MJGameNotify:onCardsThrow(data)
    if self._gameController:isCardsThrowResponse(data) then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
    end
    print("onCardsThrow")
    self._gameController:onCardsThrow(data)
end

function MJGameNotify:onCardCaught(data)
    print("onCardCaught")
    self._gameController:onCardCaught(data)
end

function MJGameNotify:onCardHua(data)
    print("onCardHua")
    self._gameController:onCardHua(data)
end

function MJGameNotify:onCardPeng(data)
    print("onCardPeng")
    self._gameController:onCardPeng(data)
end

function MJGameNotify:onCardChi(data)
    print("onCardChi")
    self._gameController:onCardChi(data)
end

function MJGameNotify:onCardMnGang(data)
    self._gameController:onCardMnGang(data)
end

function MJGameNotify:onCardAnGang(data)
    print("onCardAnGang")
    self._gameController:onCardAnGang(data)
end

function MJGameNotify:onCardPnGang(data)
    print("onCardPnGang")
    self._gameController:onCardPnGang(data)
end

function MJGameNotify:onCardGuo(data)
    print("onCardGuo")
    self._gameController:onCardGuo(data)
end

function MJGameNotify:onGameWin(data)
    print("onGameWin")
    self._gameController:onGameWin(data)
end

function MJGameNotify:rspCardsThrow(data)
    print("rspCardsThrow")
    self._gameController:rspCardsThrow(data)
end

function MJGameNotify:rspCardCaught(data)
    print("rspCardCaught")
    self._gameController:rspCardCaught(data)
end

function MJGameNotify:rspCardPeng(data)
    print("rspCardPeng")
    self._gameController:rspCardPeng(data)
end

function MJGameNotify:rspCardMnGang(data)
    print("rspCardMnGang")
    self._gameController:rspCardMnGang(data)
end

function MJGameNotify:rspCardAnGang(data)
    print("rspCardAnGang")
    self._gameController:rspCardAnGang(data)
end

function MJGameNotify:rspCardPnGang(data)
    print("rspCardPnGang")
    self._gameController:rspCardPnGang(data)
end

function MJGameNotify:rspCardChi(data)
    print("rspCardChi")
    self._gameController:rspCardChi(data)
end

function MJGameNotify:rspCardHua(data)
    print("rspCardHua")
    self._gameController:rspCardHua(data)
end

function MJGameNotify:onCardPrePeng(data)
    print("onCardPrePeng")
    self._gameController:onCardPrePeng(data)
end

function MJGameNotify:onCardPreChi(data)
    print("onCardPreChi")
    self._gameController:onCardPreChi(data)
end

function MJGameNotify:onCardPreGangOK(data)
    print("onCardPreGangOK")
    self._gameController:onCardPreGangOK(data)
end

function MJGameNotify:rspCardOperationWait(response)
    print("rspCardOperationWait")
    self._gameController:rspCardOperationWait(response)
end

function MJGameNotify:onMJOperationFailed(response)
    print("onMJOperationFailed, %d", response)
    self._gameController:onMJOperationFailed(response)
end

return MJGameNotify
