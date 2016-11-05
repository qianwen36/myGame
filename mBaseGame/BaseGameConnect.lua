
local BaseGameConnect = class("BaseGameConnect")

local treepack                              = cc.load("treepack")

local BaseGameReq                           = import("src.app.Game.mBaseGame.BaseGameReq")
local BaseGameDef                           = import("src.app.Game.mBaseGame.BaseGameDef")

local targetPlatform = cc.Application:getInstance():getTargetPlatform()

function BaseGameConnect:create(gameController)
    return BaseGameConnect.new(gameController)
end

function BaseGameConnect:ctor(gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController                    = gameController
end

function BaseGameConnect:pause()
    local networkClient = self._gameController:getNetworkClient()
    if networkClient then
        --networkClient:pause()
    end
end

function BaseGameConnect:resume()
    local networkClient = self._gameController:getNetworkClient()
    if networkClient then
        --networkClient:resume()
    end
end

function BaseGameConnect:disconnect()
    local networkClient = self._gameController:getNetworkClient()
    if networkClient then
        networkClient:disconnect()
    end
end

function BaseGameConnect:sendRequest(msg_type, msgData, msgDataLength, needResponse)
    local session = -1
    local networkClient = self._gameController:getNetworkClient()
    if networkClient then
        session = networkClient:sendRequest(msg_type, msgData, msgDataLength, needResponse)
        print("sendRequest: request=" .. msg_type .. ", session=" ..session .. ", needResponse=" .. tostring(needResponse))
        if -1 == session then
            print("session is -1???")
        else
            if needResponse then
                self._gameController:setSession(session)
                self._gameController:waitForResponse()
            end
        end
    else
        print("networkClient is nil!!!")
    end
    return session
end

function BaseGameConnect:gc_SendGamePulse()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    if not playerInfoManager then return end

    local GR_GAME_PULSE = BaseGameReq["GAME_PULSE"]
    local data              = {
        nUserID             = playerInfoManager:getSelfUserID(),
    }
    local pData = treepack.alignpack(data, GR_GAME_PULSE)

    self:sendRequest(BaseGameDef.BASEGAME_GR_GAME_PULSE, pData, pData:len(), false)
end

function BaseGameConnect:gc_AppEnterBackground()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local MR_ENTER_BACKGROUND = BaseGameReq["ENTER_BKGFKG"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO()
        }
        local pData = treepack.alignpack(data, MR_ENTER_BACKGROUND)

        self:sendRequest(BaseGameDef.BASEGAME_MR_ENTER_BACKGROUND, pData, pData:len(), false)
        print("GC_AppEnterBackground request sent")
    else
        print("GC_AppEnterBackground error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_AppEnterForeground()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local MR_ENTER_FOREGROUND = BaseGameReq["ENTER_BKGFKG"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO()
        }
        local pData = treepack.alignpack(data, MR_ENTER_FOREGROUND)

        self:sendRequest(BaseGameDef.BASEGAME_MR_ENTER_FOREGROUND, pData, pData:len(), false)
        print("GC_AppEnterForeground request sent")
    else
        print("GC_AppEnterForeground error, waitingResponse = " .. waitingResponse)
    end
end

--[[
function BaseGameConnect:gc_CheckVersion()
    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local MR_GET_VERSION = BaseGameReq["GETVERSION"]

        local gameVersionName = ""
        if cc.PLATFORM_OS_IPHONE == targetPlatform then
            gameVersionName = "IPHONE"
        else
            gameVersionName = "AND"
        end
        local data          = {
            szExeName       = tostring(gameVersionName)
        }
        local pData = treepack.alignpack(data, MR_GET_VERSION)

        self:sendRequest(BaseGameDef.BASEGAME_MR_GET_VERSION, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_CHECK_VERSION)
        print("GC_CheckVersion request sent")
    else
        print("GC_CheckVersion error, waitingResponse = " .. waitingResponse)
    end
end
]]

function BaseGameConnect:gc_CheckVersion()
    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local MR_CHECK_VERSION = BaseGameReq["CHECKVERSION"]

        local gameVersionName = ""
        local majorVer = 0
        local minorVer = 0
        local buildno = 0
        if cc.PLATFORM_OS_IPHONE == targetPlatform then
            gameVersionName = "IPHONE"
        else
            gameVersionName = "AND"
        end
        local gameVersion = self._gameController.getGameVersion()
        local splitArray = string.split(gameVersion, ".")
        if #splitArray == 3 then
            majorVer = tonumber(splitArray[1])
            minorVer = tonumber(splitArray[2])
            buildno = tonumber(splitArray[3])
        end

        local data          = {
            szExeName       = tostring(gameVersionName),
            nExeMajorVer    = majorVer,
            nExeMinorVer    = minorVer,
            nExeBuildno     = buildno
        }
        local pData = treepack.alignpack(data, MR_CHECK_VERSION)

        self:sendRequest(BaseGameDef.BASEGAME_MR_CHECK_VERSION, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_CHECK_VERSION)
        print("GC_CheckVersion request sent")
    else
        print("GC_CheckVersion error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_EnterGame()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_ENTER_GAME_EX = BaseGameReq["ENTER_GAME"]

        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nUserType       = playerInfoManager:getSelfUserType(),
            nGameID         = uitleInfoManager:getGameID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            szHardID        = uitleInfoManager:getHardID(),
            bLookOn         = uitleInfoManager:getLookOn(),
            nRoomTokenID    = uitleInfoManager:getRoomTokenID(),
            nMbNetType      = uitleInfoManager:getMbNetType(),

            nUserID1        = playerInfoManager:getSelfUserID(),
            nUserType1      = playerInfoManager:getSelfUserType(),
            nStatus         = playerInfoManager:getSelfStatus(),
            nTableNO1       = playerInfoManager:getSelfTableNO(),
            nChairNO1       = playerInfoManager:getSelfChairNO(),
            nNickSex        = playerInfoManager:getSelfNickSex(),
            nPortrait       = playerInfoManager:getSelfPortrait(),
            nNetSpeed       = playerInfoManager:getSelfNetSpeed(),
            nClothingID     = playerInfoManager:getSelfClothingID(),
            szUserName      = playerInfoManager:getSelfUserName(),
            szNickName      = playerInfoManager:getSelfNickName(),
            nDeposit        = playerInfoManager:getSelfDeposit(),
            nPlayerLevel    = playerInfoManager:getSelfPlayerLevel(),
            nScore          = playerInfoManager:getSelfScore(),
            nBreakOff       = playerInfoManager:getSelfBreakOff(),
            nWin            = playerInfoManager:getSelfWin(),
            nLoss           = playerInfoManager:getSelfLoss(),
            nStandOff       = playerInfoManager:getSelfStandOff(),
            nBout           = playerInfoManager:getSelfBout(),
            nTimeCost       = playerInfoManager:getSelfTimeCost()
        }

        local pData = treepack.alignpack(data, GR_ENTER_GAME_EX)

        self:sendRequest(BaseGameDef.BASEGAME_GR_ENTER_GAME, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_ENTER_GAME)
        print("GC_EnterGame request sent")
    else
        print("GC_EnterGame error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_LeaveGame()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_LEAVE_GAME = BaseGameReq["LEAVE_GAME"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nSendTable      = playerInfoManager:getSelfTableNO(),
            nSendChair      = playerInfoManager:getSelfChairNO(),
            nSendUser       = playerInfoManager:getSelfUserID(),
            szHardID        = uitleInfoManager:getHardID()
        }
        local pData = treepack.alignpack(data, GR_LEAVE_GAME)

        self:sendRequest(BaseGameDef.BASEGAME_GR_LEAVE_GAME, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_LEAVE_GAME)
        print("GC_LeaveGame request sent")
    else
        print("GC_LeaveGame error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_AskNewTableChair()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_ASK_NEW_TABLECHAIR = BaseGameReq["ASK_NEWTABLECHAIR"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO()
        }
        local pData = treepack.alignpack(data, GR_ASK_NEW_TABLECHAIR)

        self:sendRequest(BaseGameDef.BASEGAME_GR_ASK_NEW_TABLECHAIR, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_ASK_NEW_TABLE)
        print("GC_AskNewTableChair request sent")
    else
        print("GC_AskNewTableChair error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_AskRandomTable()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_ASK_RANDOM_TABLE = BaseGameReq["ASK_NEWTABLECHAIR"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO()
        }
        local pData = treepack.alignpack(data, GR_ASK_RANDOM_TABLE)

        self:sendRequest(BaseGameDef.BASEGAME_GR_ASK_RANDOM_TABLE, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_ASK_RANDOM_TABLE)
        print("GC_AskRandomTable request sent")
    else
        print("GC_AskRandomTable error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_GetTableInfo()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_GET_TABLE_INFO = BaseGameReq["GET_TABLE_INFO"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO()
        }
        local pData = treepack.alignpack(data, GR_GET_TABLE_INFO)

        self:sendRequest(BaseGameDef.BASEGAME_GR_GET_TABLE_INFO, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_GET_TABLE_INFO)
        print("GC_GetTableInfo request sent")
    else
        print("GC_GetTableInfo error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_StartGame()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_START_GAME = BaseGameReq["START_GAME"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO()
        }
        local pData = treepack.alignpack(data, GR_START_GAME)

        self:sendRequest(BaseGameDef.BASEGAME_GR_START_GAME, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_START_GAME)
        print("GC_StartGame request sent")
    else
        print("GC_StartGame error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_LookSafeDeposit()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_LOOK_SAFE_DEPOSIT = BaseGameReq["LOOK_SAFE_DEPOSIT"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nGameID         = uitleInfoManager:getGameID(),
            szHardID        = uitleInfoManager:getHardID()
        }
        local pData = treepack.alignpack(data, GR_LOOK_SAFE_DEPOSIT)

        self:sendRequest(BaseGameDef.BASEGAME_GR_LOOK_SAFE_DEPOSIT, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_LOOK_SAFE_DEPOSIT)
        print("GC_LookSafeDeposit request sent")
    else
        print("GC_LookSafeDeposit error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_SaveDeposit(saveDeposit, gameDeposit)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_SAVE_SAFE_DEPOSIT = BaseGameReq["TAKESAVE_SAFE_DEPOSIT"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nGameID         = uitleInfoManager:getGameID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nDeposit        = saveDeposit,
            nGameDeposit    = gameDeposit,
            dwFlags         = BaseGameDef.BASEGAME_FLAG_SUPPORT_KEEPDEPOSIT_EX,
            szHardID        = uitleInfoManager:getHardID()
        }
        local pData = treepack.alignpack(data, GR_SAVE_SAFE_DEPOSIT)

        self:sendRequest(BaseGameDef.BASEGAME_GR_SAVE_SAFE_DEPOSIT, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_SAVE_SAFE_DEPOSIT)
        print("GC_SaveSafeDeposit request sent")
    else
        print("GC_SaveSafeDeposit error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_TakeDeposit(deposit, keyResult, gameDeposit)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_TAKE_SAFE_DEPOSIT = BaseGameReq["TAKESAVE_SAFE_DEPOSIT"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nGameID         = uitleInfoManager:getGameID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nDeposit        = deposit,
            nKeyResult      = keyResult,
            nGameDeposit    = gameDeposit,
            dwFlags         = BaseGameDef.BASEGAME_FLAG_SUPPORT_MONTHLY_LIMIT_EX,
            szHardID        = uitleInfoManager:getHardID()
        }
        local pData = treepack.alignpack(data, GR_TAKE_SAFE_DEPOSIT)

        self:sendRequest(BaseGameDef.BASEGAME_GR_TAKE_SAFE_DEPOSIT, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_TAKE_SAFE_DEPOSIT)
        print("GC_TakeSafeDeposit request sent")
    else
        print("GC_TakeSafeDeposit error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_TakeRndKey()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_TAKE_SAFE_RNDKEY = BaseGameReq["LOOK_SAFE_DEPOSIT"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nGameID         = uitleInfoManager:getGameID(),
            szHardID        = uitleInfoManager:getHardID()
        }
        local pData = treepack.alignpack(data, GR_TAKE_SAFE_RNDKEY)

        self:sendRequest(BaseGameDef.BASEGAME_GR_TAKE_SAFE_RNDKEY, pData, pData:len(), true)
        self._gameController:setResponse(BaseGameDef.BASEGAME_WAITING_TAKE_SAFE_RNDKEY)
        print("GC_TakeSafeRndKey request sent")
    else
        print("GC_TakeSafeRndKey error, waitingResponse = " .. waitingResponse)
    end
end

function BaseGameConnect:gc_ChatToTable(content)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    if 60 < string.len(content) then
        content = string.sub(content, 1, 60)
    end

    local GR_CHATTOTABLE = BaseGameReq["CHAT_TO_TABLE"]
    local data          = {
        nUserID         = playerInfoManager:getSelfUserID(),
        nRoomID         = uitleInfoManager:getRoomID(),
        nTableNO        = playerInfoManager:getSelfTableNO(),
        nChairNO        = playerInfoManager:getSelfChairNO(),
        szHardID        = uitleInfoManager:getHardID(),
        szChatMsg       = content
    }
    local pData = treepack.alignpack(data, GR_CHATTOTABLE)

    self:sendRequest(BaseGameDef.BASEGAME_GR_CHAT_TO_TABLE, pData, pData:len(), false)
    print("GC_ChatToTable request sent")
end

return BaseGameConnect
