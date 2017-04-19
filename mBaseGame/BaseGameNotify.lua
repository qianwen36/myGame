
local BaseGameNotify = class("BaseGameNotify")

local BaseGameDef               = import(".BaseGameDef")

function BaseGameNotify:create(gameController)
    return BaseGameNotify.new(gameController)
end

function BaseGameNotify:ctor(gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController
end

function BaseGameNotify:onDataReceived(clientID, msgType, session, request, data)
    print("BaseGameNotify onDataReceived: request=" .. request .. ", clientID=" ..clientID .. ", msgType=" .. msgType .. ", session=" .. session)

    if request == BaseGameDef.BASEGAME_UR_SOCKET_CONNECT then
        self:onSocketConnect()
    elseif request == BaseGameDef.BASEGAME_UR_SOCKET_CLOSE then
        self:onSocketClose()
    elseif request == BaseGameDef.BASEGAME_UR_SOCKET_ERROR then
        self:onSocketError()
    elseif request == BaseGameDef.BASEGAME_UR_SOCKET_GRACEFULLY_ERROR then
        self:onSocketGracefullyError()
    elseif request == BaseGameDef.BASEGAME_UR_RESPONSE_TIMEOUT then
        self:onTimeOut()
    else
        self:onNotifyReceived(request, msgType, session, data)
    end
end

function BaseGameNotify:onSocketClose()
    self._gameController:onSocketClose()
end

function BaseGameNotify:onSocketError()
    self._gameController:onSocketError()
end

function BaseGameNotify:reconnect()
    self._gameController:reconnect()
end

function BaseGameNotify:onSocketGracefullyError()
    self._gameController:onSocketGracefullyError()
end

function BaseGameNotify:onTimeOut()
    self._gameController:onTimeOut()
end

function BaseGameNotify:onSocketConnect()
    self._gameController:onSocketConnect()
end

function BaseGameNotify:onNotifyReceived(request, msgType, session, data)
    if self:discardOutDateNotify(request) then return end

    if self._gameController:getSession() == session then
        self._gameController:onResponse()
    end

    local switchAction = {
        [BaseGameDef.BASEGAME_UR_OPERATE_SUCCEEDED]         = function(data)
            if self._gameController:getSession() == session then
                self:handleResponse(self._gameController:getResponse(), data)
            end
        end,

        [BaseGameDef.BASEGAME_UR_OPERATE_FAILED]            = function(data)
            if self._gameController:getSession() == session then
                local ret = self:handleFailedResponse(request, msgType, session, data)
                if not ret then
                    self:operationFailed(self._gameController:getResponse())
                end
            end
        end,

        [BaseGameDef.BASEGAME_GR_WAIT_FEW_SECONDS]          = function(data)
            if self._gameController:getSession() == session then
                self:handleWaitResponse(self._gameController:getResponse())
            end
        end,

        [BaseGameDef.BASEGAME_GR_RESPONE_ENTER_GAME_OK]     = function(data)
            self:handleResponse(BaseGameDef.BASEGAME_WAITING_ENTER_GAME_OK, data)
        end,

        [BaseGameDef.BASEGAME_GR_RESPONE_ENTER_GAME_DXXW]   = function(data)
            self:handleResponse(BaseGameDef.BASEGAME_WAITING_ENTER_GAME_DXXW, data)
        end,

        [BaseGameDef.BASEGAME_GR_RESPONE_ENTER_GAME_IDLE]   = function(data)
            self:handleResponse(BaseGameDef.BASEGAME_WAITING_ENTER_GAME_IDLE, data)
        end,

        [BaseGameDef.BASEGAME_GR_ROOMTABLECHAIR_MISMATCH]   = function(data)
            self:onRoomTableChairMismatch()
        end,

        [BaseGameDef.BASEGAME_GR_HARDID_MISMATCH]           = function(data)
            self:onHardIDMismatch()
        end,
        [BaseGameDef.BASEGAME_GR_ROOM_TOKENID_MISMATCH]     = function(data)
            self:onHardIDMismatch()
        end,

        [BaseGameDef.BASEGAME_GR_ALL_STANDBY]               = function(data)
            self:onAllStandBy(data)
        end,

        [BaseGameDef.BASEGAME_GR_GAME_ABORT]                = function(data)
            self:onGameAbort(data)
        end,

        [BaseGameDef.BASEGAME_GR_LEAVEGAME_TOOFAST]         = function(data)
            if self._gameController:getResponse() == BaseGameDef.BASEGAME_WAITING_LEAVE_GAME then
                self._gameController:setResponse(self._gameController:getResWaitingNothing())
                self:onLeaveGameTooFast(data)
            end
        end,

        [BaseGameDef.BASEGAME_GR_LEAVEGAME_PLAYING]         = function(data)
            if self._gameController:getResponse() == BaseGameDef.BASEGAME_WAITING_LEAVE_GAME then
                self._gameController:setResponse(self._gameController:getResWaitingNothing())
                self:onLeaveGamePlaying()
            end
        end,

        [BaseGameDef.BASEGAME_GR_CHAT_TO_TABLE]             = function(data)
            self:onChatToTable(data)
        end,

        [BaseGameDef.BASEGAME_GR_PLAYER_ABORT]              = function(data)
            self:onPlayerAbort(data)
        end,

        [BaseGameDef.BASEGAME_GR_PLAYER_ENTER]              = function(data)
            self:onPlayerEnter(data)
        end,

        [BaseGameDef.BASEGAME_GR_PLAYER_START_GAME]         = function(data)
            self:onPlayerStartGame(data)
        end,

        [BaseGameDef.BASEGAME_GR_DEPOSIT_NOT_ENOUGH]        = function(data)
            self:onDepositNotEnough(data)
        end,

        [BaseGameDef.BASEGAME_GR_SCORE_NOT_ENOUGH]          = function(data)
            self:onScoreNotEnough(data)
        end,

        [BaseGameDef.BASEGAME_GR_SCORE_TOO_HIGH]            = function(data)
            self:onScoreTooHigh(data)
        end,

        [BaseGameDef.BASEGAME_GR_USER_BOUT_TOO_HIGH]        = function(data)
            self:onUserBoutTooHigh(data)
        end,

        [BaseGameDef.BASEGAME_GR_TABLE_BOUT_TOO_HIGH]       = function(data)
            self:onTableBoutTooHigh(data)
        end,

        [BaseGameDef.BASEGAME_GR_START_SOLOTABLE]           = function(data)
            self:onStartSoloTable(data)
        end,

        [BaseGameDef.BASEGAME_GR_CHAT_FROM_TALBE]           = function(data)
            self:onChatFromTable(data)
        end,

        [BaseGameDef.BASEGAME_GR_USER_DEPOSIT_EVENT]        = function(data)
            self:onUserDepositEvent(data)
        end,

        [BaseGameDef.BASEGAME_GR_USER_POSITION]             = function(data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            self:onUserPosition(data)
        end,

        [BaseGameDef.BASEGAME_GR_WAIT_NEWTABLE]             = function()
            self:onWaitNewTable()
        end,

        [BaseGameDef.BASEGAME_GR_DEPOSIT_NOTENOUGH]         = function(data)
            self:onSafeBoxFailed(request, self._gameController:getResponse(), data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_RESPONE_DEPOSIT_NOTENOUGH] = function(data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            self:onStartFailedNotEnough(data)
        end,

        [BaseGameDef.BASEGAME_GR_RESPONE_DEPOSIT_TOOHIGH]   = function(data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            self:onStartFailedTooHigh(data)
        end,

        [BaseGameDef.BASEGAME_GR_SAFEBOX_GAME_READY]        = function(data)
            self:onSafeBoxFailed(request, self._gameController:getResponse(), data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_SAFEBOX_GAME_PLAYING]   = function(data)
            self:onSafeBoxFailed(request, self._gameController:getResponse(), data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_SAFEBOX_DEPOSIT_MIN]   = function(data)
            self:onSafeBoxFailed(request, self._gameController:getResponse(), data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_SAFEBOX_DEPOSIT_MAX]   = function(data)
            self:onSafeBoxFailed(request, self._gameController:getResponse(), data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_INPUTLIMIT_MONTHLY]    = function(data)
            self:onSafeBoxFailed(request, self._gameController:getResponse(), data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_INPUTLIMIT_DAILY]      = function(data)
            self:onSafeBoxFailed(request, self._gameController:getResponse(), data)
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_OLD_VER_EXEMAJORVER]   = function()
            self:onCheckVersionOld()
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_OLD_VER_EXEMINORVER]   = function()
            self:onCheckVersionOld()
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_OLD_VER_EXEBUILDNO]   = function()
            self:onCheckVersionOld()
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_NEW_VER_EXEMAJORVER]   = function()
            self:onCheckVersionNew()
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_NEW_VER_EXEMINORVER]   = function()
            self:onCheckVersionNew()
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,

        [BaseGameDef.BASEGAME_GR_NEW_VER_EXEBUILDNO]   = function()
            self:onCheckVersionNew()
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
        end,
    }

    if switchAction[request] then
        switchAction[request](data)
    end
end

function BaseGameNotify:discardOutDateNotify(request)
    if self._gameController:isResume() then
        if request == -1 then return true end
        return false
    end
    return false
end

function BaseGameNotify:handleResponse(response, data)
    local switchAction = {
--        [BaseGameDef.BASEGAME_WAITING_CHECK_VERSION]        = function(data)    self:onCheckVersion(data)       end,
        [BaseGameDef.BASEGAME_WAITING_CHECK_VERSION]        = function()        self:onCheckVersion()           end,
        [BaseGameDef.BASEGAME_WAITING_ENTER_GAME_OK]        = function(data)    self:onEnterGameOK(data)        end,
        [BaseGameDef.BASEGAME_WAITING_ENTER_GAME_DXXW]      = function(data)    self:onEnterGameDXXW(data)      end,
        [BaseGameDef.BASEGAME_WAITING_ENTER_GAME_IDLE]      = function(data)    self:onEnterGameIDLE(data)      end,
        [BaseGameDef.BASEGAME_WAITING_LEAVE_GAME]           = function()        self:onLeaveGameOK()            end,
        [BaseGameDef.BASEGAME_WAITING_START_GAME]           = function()        self:rspStartGame()             end,
        [BaseGameDef.BASEGAME_WAITING_ASK_RANDOM_TABLE]     = function()                                        end,
        [BaseGameDef.BASEGAME_WAITING_LOOK_SAFE_DEPOSIT]    = function(data)    self:onLookSafeDeposit(data)    end,
        [BaseGameDef.BASEGAME_WAITING_TAKE_SAFE_DEPOSIT]    = function(data)    self:onTakeSafeDeposit()        end,
        [BaseGameDef.BASEGAME_WAITING_SAVE_SAFE_DEPOSIT]    = function()        self:onSaveSafeDeposit()        end,
        [BaseGameDef.BASEGAME_WAITING_TAKE_SAFE_RNDKEY]     = function(data)    self:onTakeSafeRndkey(data)     end,
        [BaseGameDef.BASEGAME_WAITING_GET_TABLE_INFO]       = function(data)    self:onGetTableInfo(data)       end,
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response](data)
    end
end

function BaseGameNotify:handleWaitResponse(response)
    local switchAction = {
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response]()
    end
end

function BaseGameNotify:operationFailed(response)
    local switchAction = {
        [BaseGameDef.BASEGAME_WAITING_ENTER_GAME]           = function() self:onEnterGameFailed()               end,
        [BaseGameDef.BASEGAME_WAITING_LEAVE_GAME]           = function() self:onLeaveGameFailed()               end,
        [BaseGameDef.BASEGAME_WAITING_ASK_RANDOM_TABLE]     = function()                                        end,
        [BaseGameDef.BASEGAME_WAITING_GET_WELFARE_CONFIG]   = function()                                        end,
        [BaseGameDef.BASEGAME_WAITING_APPLY_WELFARE]        = function()                                        end,
    }

    if switchAction[response] then
        self._gameController:setResponse(self._gameController:getResWaitingNothing())
        switchAction[response]()
    end
end

function BaseGameNotify:handleFailedResponse(request, msgType, session, data)
    if msgType == BaseGameDef.BASEGAME_MSG_RESPONSE and session == self._gameController:getSession() then
        local switchAction = {
            [BaseGameDef.BASEGAME_WAITING_LOOK_SAFE_DEPOSIT]    = function(response) self:onSafeBoxFailed(request, response, data)  end,
            [BaseGameDef.BASEGAME_WAITING_LOOK_BACK_DEPOSIT]    = function(response) self:onSafeBoxFailed(request, response, data)  end,
            [BaseGameDef.BASEGAME_WAITING_TAKE_SAFE_DEPOSIT]    = function(response) self:onSafeBoxFailed(request, response, data)  end,
            [BaseGameDef.BASEGAME_WAITING_TAKE_BACK_DEPOSIT]    = function(response) self:onSafeBoxFailed(request, response, data)  end,
            [BaseGameDef.BASEGAME_WAITING_SAVE_SAFE_DEPOSIT]    = function(response) self:onSafeBoxFailed(request, response, data)  end,
            [BaseGameDef.BASEGAME_WAITING_SAVE_BACK_DEPOSIT]    = function(response) self:onSafeBoxFailed(request, response, data)  end,
            [BaseGameDef.BASEGAME_WAITING_TAKE_SAFE_RNDKEY]     = function(response) self:onSafeBoxFailed(request, response, data)  end,
            [BaseGameDef.BASEGAME_WAITING_GET_WELFARE_CONFIG]   = function(response)                                                end,
            [BaseGameDef.BASEGAME_WAITING_APPLY_WELFARE]        = function(response)                                                end,
            [BaseGameDef.BASEGAME_WAITING_ASK_NEW_TABLE]        = function(response)                                                end,
            [BaseGameDef.BASEGAME_WAITING_GET_TABLE_INFO]       = function(response) self:onGetTableInfoFailed(data)                end,
        }

        local response = self._gameController:getResponse()
        if switchAction[response] then
            self._gameController:setResponse(self._gameController:getResWaitingNothing())
            switchAction[response](response)
            return true
        end
    end
    return false
end

--function BaseGameNotify:onCheckVersion(data)
--    print("onCheckVersion")
--    self._gameController:onCheckVersion(data)
--end

function BaseGameNotify:onCheckVersion()
    print("onCheckVersion")
    self._gameController:onCheckVersion()
end

function BaseGameNotify:onCheckVersionOld()
    print("onCheckVersionOld")
    self._gameController:onCheckVersionOld()
end

function BaseGameNotify:onCheckVersionNew()
    print("onCheckVersionNew")
    self._gameController:onCheckVersionNew()
end

function BaseGameNotify:onEnterGameOK(data)
    print("onEnterGameOK")
    self._gameController:onEnterGameOK(data)
end

function BaseGameNotify:onEnterGameDXXW(data)
    print("onEnterGameDXXW")
    self._gameController:onEnterGameDXXW(data)
end

function BaseGameNotify:onEnterGameIDLE(data)
    print("onEnterGameIDLE")
    self._gameController:onEnterGameIDLE(data)
end

function BaseGameNotify:onEnterGameFailed()
    print("onEnterGameFailed")
    self._gameController:onEnterGameFailed()
end

function BaseGameNotify:onLeaveGameOK()
    print("onLeaveGameOK")
    self._gameController:onLeaveGameOK()
end

function BaseGameNotify:onLeaveGameFailed()
    print("onLeaveGameFailed")
    self._gameController:onLeaveGameFailed()
end

function BaseGameNotify:onRoomTableChairMismatch()
    print("onRoomTableChairMismatch")
    self._gameController:onRoomTableChairMismatch()
end

function BaseGameNotify:onHardIDMismatch()
    print("onHardIDMismatch")
    self._gameController:onHardIDMismatch()
end

function BaseGameNotify:onAllStandBy(data)
    print("onAllStandBy")
    self._gameController:onAllStandBy(data)
end

function BaseGameNotify:onGameAbort(data)
    print("onGameAbort")
    self._gameController:onGameAbort(data)
end

function BaseGameNotify:onLeaveGamePlaying()
    print("onLeaveGamePlaying")
    self._gameController:onLeaveGamePlaying()
end

function BaseGameNotify:onGameTooFast(data)
    print("onGameTooFast")
    self._gameController:onGameTooFast(data)
end

function BaseGameNotify:onChatToTable(data)
    print("onChatToTable")
    self._gameController:onChatToTable(data)
end

function BaseGameNotify:onPlayerAbort(data)
    print("onPlayerAbort")
    self._gameController:onPlayerAbort(data)
end

function BaseGameNotify:onPlayerEnter(data)
    print("onPlayerEnter")
    self._gameController:onPlayerEnter(data)
end

function BaseGameNotify:onDepositNotEnough(data)
    print("onDepositNotEnough")
    self._gameController:onDepositNotEnough(data)
end

function BaseGameNotify:onScoreNotEnough(data)
    print("onScoreNotEnough")
    self._gameController:onScoreNotEnough(data)
end

function BaseGameNotify:onScoreTooHigh(data)
    print("onScoreTooHigh")
    self._gameController:onScoreTooHigh(data)
end

function BaseGameNotify:onUserBoutTooHigh(data)
    print("onUserBoutTooHigh")
    self._gameController:onUserBoutTooHigh(data)
end

function BaseGameNotify:onTableBoutTooHigh(data)
    print("onTableBoutTooHigh")
    self._gameController:onTableBoutTooHigh(data)
end

function BaseGameNotify:onStartSoloTable(data)
    print("onStartSoloTable")
    self._gameController:onStartSoloTable(data)
end

function BaseGameNotify:onChatFromTable(data)
    print("onChatFromTable")
    self._gameController:onChatFromTable(data)
end

function BaseGameNotify:onUserDepositEvent(data)
    print("onUserDepositEvent")
    self._gameController:onUserDepositEvent(data)
end

function BaseGameNotify:onUserPosition(data)
    print("onUserPosition")
    self._gameController:onUserPosition(data)
end

function BaseGameNotify:rspStartGame()
    print("rspStartGame")
    self._gameController:rspStartGame()
end

function BaseGameNotify:onPlayerStartGame(data)
    print("onPlayerStartGame")
    self._gameController:onPlayerStartGame(data)
end

function BaseGameNotify:onLookSafeDeposit(data)
    print("onLookSafeDeposit")
    self._gameController:onLookSafeDeposit(data)
end

function BaseGameNotify:onTakeSafeDeposit()
    print("onTakeSafeDeposit")
    self._gameController:onTakeSafeDeposit()
end

function BaseGameNotify:onSaveSafeDeposit()
    print("onSaveSafeDeposit")
    self._gameController:onSaveSafeDeposit()
end

function BaseGameNotify:onTakeSafeRndkey(data)
    print("onTakeSafeRndkey")
    self._gameController:onTakeSafeRndkey(data)
end

function BaseGameNotify:onSafeBoxFailed(request, response, data)
    print("onSafeBoxFailed")
    self._gameController:onSafeBoxFailed(request, response, data)
end

function BaseGameNotify:onWaitNewTable()
    print("onWaitNewTable")
    self._gameController:onWaitNewTable()
end

function BaseGameNotify:onGetTableInfo(data)
    print("onGetTableInfo")
    self._gameController:onGetTableInfo(data)
end

function BaseGameNotify:onGetTableInfoFailed()
    print("onGetTableInfoFailed")
    self._gameController:onGetTableInfoFailed()
end

function BaseGameNotify:onStartFailedNotEnough(data)
    print("onStartFailedNotEnough")
    self._gameController:onStartFailedNotEnough(data)
end

function BaseGameNotify:onStartFailedTooHigh(data)
    print("onStartFailedTooHigh")
    self._gameController:onStartFailedTooHigh(data)
end

return BaseGameNotify
