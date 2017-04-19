
if nil == cc or nil == cc.exports then
    return
end


require("src.cocos.cocos2d.bitExtend")

local BaseGameDef                               = import(".BaseGameDef")

cc.exports.GameController                       = {}
local BaseGameController                        = cc.exports.GameController

local BaseGameData                              = import(".BaseGameData")
local BaseGamePlayerInfoManager                 = import(".BaseGamePlayerInfoManager")
local BaseGameUtilsInfoManager                  = import(".BaseGameUtilsInfoManager")
local BaseGameConnect                           = import(".BaseGameConnect")
local BaseGameNotify                            = import(".BaseGameNotify")

local GamePublicInterface                       = import("..mMyGame.GamePublicInterface")

function BaseGameController:initGameController(baseGameScene, param)
    if not baseGameScene then printError("baseGameScene is nil!!!") return end

    self:resetController()
    self.params_ = param --{enterRoomInfo, playerInfo, tableInfo}
    self._baseGameScene = baseGameScene

    self:createGameData()
    self:createPlayerInfoManager()
    self:createUtilsInfoManager()

    self:preloadBGM()

    self:initManagerAboveBaseGame()

    self:initGamePublicInterface()
end

function BaseGameController:resetController()
    self._baseGameScene               = nil

    self._baseGameData                = nil
    self._baseGamePlayerInfoManager   = nil
    self._baseGameUtilsInfoManager    = nil
    self._baseGameNetworkClient       = nil
    self._baseGameConnect             = nil
    self._baseGameNotify              = nil
    
    self._isResume                    = false
    self._isGameRunning               = false
    self._isConnected                 = false
    self._isDXXW                      = false
    
    self._session                     = -1
    self._response                    = BaseGameDef.BASEGAME_WAITING_NOTHING
    self._connectTimes                = 0
    
    self._bAutoPlay                   = false
    self._autoWaitTimes               = 0
    self._minWaitTimes                = 2

    if GamePublicInterface then
        GamePublicInterface:setGameController(nil)
    end
end

function BaseGameController:createGameData()
    self._baseGameData = BaseGameData:create()
end

function BaseGameController:getGameData()
    return self._baseGameData
end

function BaseGameController:createPlayerInfoManager()
    self._baseGamePlayerInfoManager = BaseGamePlayerInfoManager:create(self)
    self:setSelfInfo()
end

function BaseGameController:getPlayerInfoManager()
    return self._baseGamePlayerInfoManager
end

function BaseGameController:createUtilsInfoManager()
    self._baseGameUtilsInfoManager = BaseGameUtilsInfoManager:create()
    self:setUtilsInfo()
end

function BaseGameController:getUtilsInfoManager()
    return self._baseGameUtilsInfoManager
end

function BaseGameController:getBGMPath()
    return "res/Game/GameSound/BGMusic/BG.mp3"
end

function BaseGameController:preloadBGM()
    audio.preloadMusic(self:getBGMPath())
end

function BaseGameController:playBGM()
    audio.playMusic(self:getBGMPath())
end

function BaseGameController:stopBGM()
    audio.stopMusic(DEBUG == 0)
end

function BaseGameController:initManagerAboveBaseGame() end

function BaseGameController:initGamePublicInterface()
    if GamePublicInterface then
        GamePublicInterface:setGameController(self)
    end
end

function BaseGameController:setSelfInfo()
    if not self._baseGamePlayerInfoManager then return end

    local params = self.params_
    local playerInfo = params.playerInfo
    local playerTableInfo = params.tableInfo.pp

    local selfInfo = {}
    selfInfo.nUserID        = playerInfo.nUserID
    selfInfo.nUserType      = playerInfo.nUserType
    selfInfo.nStatus        = playerInfo.nStatus
    selfInfo.nTableNO       = playerTableInfo.nTableNO
    selfInfo.nChairNO       = playerTableInfo.nChairNO
    selfInfo.nNickSex       = playerInfo.nNickSex
    selfInfo.nPortrait      = playerInfo.nPortrait
    selfInfo.nNetSpeed      = playerInfo.nNetSpeed
    selfInfo.nClothingID    = playerInfo.nClothingID
    selfInfo.szUserName     = playerInfo.szUsername
    selfInfo.szNickName     = playerInfo.szNickName
    selfInfo.nDeposit       = playerInfo.nDeposit
    selfInfo.nPlayerLevel   = playerInfo.nPlayerLevel
    selfInfo.nScore         = playerInfo.nScore
    selfInfo.nBreakOff      = playerInfo.nBreakOff
    selfInfo.nWin           = playerInfo.nWin
    selfInfo.nLoss          = playerInfo.nLoss
    selfInfo.nStandOff      = playerInfo.nStandOff
    selfInfo.nBout          = playerInfo.nBout
    selfInfo.nTimeCost      = playerInfo.nTimeCost
    selfInfo.nGrowthLevel   = playerInfo.nGrowthLevel

    dump(selfInfo)
    self._baseGamePlayerInfoManager:setSelfInfo(selfInfo)
end

function BaseGameController:setUtilsInfo()
    if not self._baseGameUtilsInfoManager then return end

    local params = self.params_
    local playerInfo = params.playerInfo
    local playerEnterGameOK = params.enterRoomInfo
    local RoomInfo = params.roomData

    local utilsInfo = {}
    utilsInfo.szHardID          = params.deviceInfo.szHardID
    utilsInfo.nRoomTokenID      = playerEnterGameOK.nRoomTokenID
    utilsInfo.nMbNetType        = DeviceUtils:getInstance():getNetworkType()
    utilsInfo.bLookOn           = 0
    utilsInfo.nGameID           = RoomInfo.nGameID
    utilsInfo.nRoomID           = RoomInfo.nRoomID
    utilsInfo.nRoomInfo         = RoomInfo

    dump(utilsInfo)
    self._baseGameUtilsInfoManager:setUitlsInfo(utilsInfo)
end

function BaseGameController:createNetwork()
    local params = self.params_
    self._baseGameNetworkClient = MCAgent:getInstance():createClient(params.host, params.port)

    local function onDataReceived(clientid, msgtype, session, request, data)
        self:onDataReceived(clientid, msgtype, session, request, data)
    end
    if self._baseGameNetworkClient then
        self._baseGameNetworkClient:setCallback(onDataReceived)
        self:setConnect()
        self:setNotify()

        -- Connect socket after setting connecttion and setting notification
        self._baseGameNetworkClient:connect()
    end
end

function BaseGameController:onDataReceived(clientid, msgtype, session, request, data)
    if self._baseGameNotify then
        self._baseGameNotify:onDataReceived(clientid, msgtype, session, request, data)
    end
end

function BaseGameController:setConnect()
    self._baseGameConnect = BaseGameConnect:create(self)
end

function BaseGameController:getConnect()
    return self._baseGameConnect
end

function BaseGameController:setNotify()
    self._baseGameNotify = BaseGameNotify:create(self)
end

function BaseGameController:getNetworkClient()
    return self._baseGameNetworkClient
end

function BaseGameController:setBackgroundCallback()
    local callback = function()
        self:onPause()
    end
    AppUtils:getInstance():removePauseCallback("Game_BaseGameController_setBackgroundCallback")
    AppUtils:getInstance():addPauseCallback(callback, "Game_BaseGameController_setBackgroundCallback")
end

function BaseGameController:setForegroundCallback()
    local callback = function()
        self:onResume()
    end
    AppUtils:getInstance():removeResumeCallback("Game_BaseGameController_setForegroundCallback")
    AppUtils:getInstance():addResumeCallback(callback, "Game_BaseGameController_setForegroundCallback")
end

function BaseGameController:onPause()
    self:pause()

    if not self:isGameRunning() then
        if self._baseGameConnect then
            self._baseGameConnect:gc_AppEnterBackground()
        end
    end
end

function BaseGameController:onResume()
    self:resume()
    self:setResume(true)

    self:setResponse(self:getResWaitingNothing())

    if not self:isGameRunning() then
        if self._baseGameConnect then
            self._baseGameConnect:gc_AppEnterForeground()
        end
    end

    if self._baseGameConnect then
        self._baseGameConnect:gc_GetTableInfo()
    end
end

function BaseGameController:pause()
    if self._baseGameConnect then
        self._baseGameConnect:pause()
    end
end

function BaseGameController:resume()
    if self._baseGameConnect then
        self._baseGameConnect:resume()
    end
end

function BaseGameController:disconnect()
    if self._baseGameConnect then
        self._baseGameConnect:disconnect()
        self._baseGameConnect = nil
    end
end

function BaseGameController:setResume(isResume)
    self._isResume = ("boolean" == type(isResume)) and isResume or false
end

function BaseGameController:isResume()
    return self._isResume
end

function BaseGameController:resetResume()
    self:setResume(false)
end

function BaseGameController:isGameRunning()
    return self._isGameRunning
end

function BaseGameController:gameRun()
    self._isGameRunning = true
end

function BaseGameController:gameStop()
    self._isGameRunning = false
end

function BaseGameController:isConnected()
    return self._isConnected
end

function BaseGameController:setDXXW(bDXXW)
    self._isDXXW = bDXXW
end

function BaseGameController:isDXXW()
    return self._isDXXW
end

function BaseGameController:setSession(session)
    self._session = session
end

function BaseGameController:getSession()
    return self._session
end

function BaseGameController:setResponse(response)
    self._response = response
end

function BaseGameController:getResponse()
    return self._response
end

function BaseGameController:getResWaitingNothing()
    return BaseGameDef.BASEGAME_WAITING_NOTHING
end

function BaseGameController:waitForResponse()
    local function onResponseFinished(dt)
        self:onResponseFinished(dt)
    end
    self:stopResponseTimer()
    self.resposeTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onResponseFinished, 5.0, false)
end

function BaseGameController:onResponseFinished(dt)
    self:stopResponseTimer()
    self:onTimeOut()
end

function BaseGameController:stopResponseTimer()
    if self.resposeTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.resposeTimerID)
        self.resposeTimerID = nil
    end
end

function BaseGameController:onResponse()
    self:stopResponseTimer()
end

function BaseGameController:ope_ShowStart(bShow)
    local gameStart = self._baseGameScene:getStart()
    if gameStart then
        gameStart:ope_ShowStart(bShow)
    end
end

function BaseGameController:showWaitArrangeTable(bShow)
    local gameStart = self._baseGameScene:getStart()
    if gameStart then
        gameStart:showWaitArrangeTable(bShow)
    end
end

function BaseGameController:isWaitArrangeTableShow()
    local gameStart = self._baseGameScene:getStart()
    if gameStart then
        return gameStart:isWaitArrangeTableShow()
    end
    return false
end

function BaseGameController:onGameEnter()
end

function BaseGameController:onGameExit()
    self:disconnect()

    self:stopResponseTimer()
    self:stopGamePluse()

    AppUtils:getInstance():removePauseCallback("Game_BaseGameController_setBackgroundCallback")
    AppUtils:getInstance():removeResumeCallback("Game_BaseGameController_setForegroundCallback")

    local clock = self._baseGameScene:getClock()
    if clock then
        clock:onGameExit()
    end

    local sysInfoNode = self._baseGameScene:getSysInfoNode()
    if sysInfoNode then
        sysInfoNode:onGameExit()
    end

    local gameStart = self._baseGameScene:getStart()
    if gameStart then
        gameStart:onGameExit()
    end

    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:onGameExit()
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:onGameExit()
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:onGameExit()
    end

    local loadingNode = self._baseGameScene:getLoadingNode()
    if loadingNode then
        loadingNode:onGameExit()
    end

    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:onGameExit()
    end

    self:stopBGM()

    self:resetController()
end

function BaseGameController:isDarkRoom()
    local isDarkRoom = false
    if self._baseGameUtilsInfoManager then
        isDarkRoom = self:IS_BIT_SET(self._baseGameUtilsInfoManager:getRoomConfigs(), BaseGameDef.RC_DARK_ROOM)
    end
    return isDarkRoom
end

function BaseGameController:isRandomRoom()
    local isRandomRoom = false
    if self._baseGameUtilsInfoManager then
        isRandomRoom = self:IS_BIT_SET(self._baseGameUtilsInfoManager:getRoomConfigs(), BaseGameDef.BASEGAME_RC_RANDOM_ROOM)
    end
    return isRandomRoom
end

function BaseGameController:isSoloRoom()
    local isSoloRoom = false
    if self._baseGameUtilsInfoManager then
        isSoloRoom = self:IS_BIT_SET(self._baseGameUtilsInfoManager:getRoomConfigs(), BaseGameDef.BASEGAME_RC_SOLO_ROOM)
    end
    return isSoloRoom
end

function BaseGameController:isLeaveAloneRoom()
    local isLeaveAloneRoom = false
    if self._baseGameUtilsInfoManager then
        isLeaveAloneRoom = self:IS_BIT_SET(self._baseGameUtilsInfoManager:getRoomConfigs(), BaseGameDef.BASEGAME_RC_LEAVEALONE)
    end
    return isLeaveAloneRoom
end

function BaseGameController:isValidateChairNO(chairNO)
    return chairNO and -1 < chairNO and chairNO < self:getTableChairCount()
end

function BaseGameController:getMyDrawIndex()
    return BaseGameDef.BASEGAME_MYDRAWINDEX
end

function BaseGameController:getMyChairNO()
    local playerInfoManager = self:getPlayerInfoManager()
    if playerInfoManager then
        return playerInfoManager:getSelfChairNO()
    end
    return 0
end

function BaseGameController:getTableChairCount()
    return BaseGameDef.BASEGAME_MAX_PLAYERS
end

function BaseGameController:getChairCardsCount()
    return BaseGameDef.BASEGAME_MAX_CARDS
end

function BaseGameController:rul_GetDrawIndexByChairNO(chairNO)
    if not self:isValidateChairNO(chairNO) then return 0 end

    local index = 0

    local playerInfoManager = self:getPlayerInfoManager()
    if playerInfoManager then
        local selfChairNO = playerInfoManager:getSelfChairNO()
        local tableChairCount = self:getTableChairCount()
        index = self:getMyDrawIndex()

        for i = 1, tableChairCount do
            if selfChairNO == chairNO then
                return index
            else
                index = index + 1
                selfChairNO = (selfChairNO + 1) % tableChairCount
            end
        end
    end

    return index
end

function BaseGameController:rul_GetChairNOByDrawIndex(drawIndex)
    local index = 0

    local playerInfoManager = self:getPlayerInfoManager()
    if playerInfoManager then
        local selfChairNO = playerInfoManager:getSelfChairNO()
        local tableChairCount = self:getTableChairCount()
        index = self:getMyDrawIndex()

        for i = 1, tableChairCount do
            if index == drawIndex then
                return selfChairNO
            else
                index = index + 1
                selfChairNO = (selfChairNO + 1) % tableChairCount
            end
        end
    end

    return index
end

function BaseGameController:getPlayerUserNameByDrawIndex(drawIndex)
    if self._baseGamePlayerInfoManager then
        return self._baseGamePlayerInfoManager:getPlayerUserNameByDrawIndex(drawIndex)
    end
end

function BaseGameController:getPlayerUserNameByUserID(userID)
    if self._baseGamePlayerInfoManager then
        return self._baseGamePlayerInfoManager:getPlayerUserNameByUserID(userID)
    end
end

function BaseGameController:IS_BIT_SET(flag, mybit) return (mybit == bit._and(mybit, flag)) end

function BaseGameController:setSelfUserName(szUserName)
    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:setSelfUserName(szUserName)
    end
end

function BaseGameController:setSelfMoney(nDeposit)
    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:setSelfMoney(nDeposit)
    end
end

function BaseGameController:showSelfReady()
    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:showSelfReady(true)
    end
end

function BaseGameController:hideSelfReady()
    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:showSelfReady(false)
    end
end

function BaseGameController:clearPlayerReady()
    local playerManager = self._baseGameScene:getPlayerManager()
    for i = 1, self:getTableChairCount() do
        if self:getMyDrawIndex() == i then
            self:hideSelfReady()
        end

        if playerManager then
            playerManager:clearPlayerReady()
        end
    end
end

function BaseGameController:addPlayerBoutInfo(drawIndex, deposit)
    if self._baseGamePlayerInfoManager then
        if 0 < deposit then
            self._baseGamePlayerInfoManager:addPlayerWinBout(drawIndex)
        elseif 0 > deposit then
            self._baseGamePlayerInfoManager:addPlayerLossBout(drawIndex)
        else
            self._baseGamePlayerInfoManager:addPlayerStandOffBout(drawIndex)
        end

        if drawIndex == self:getMyDrawIndex() then
            self:syncPlayerBoutInfo()
        end
    end
end

function BaseGameController:syncPlayerBoutInfo()
    if self._baseGamePlayerInfoManager then
        local playerInfo = mymodel("hallext.PlayerModel"):getInstance()
        if playerInfo then
            local dataMap = {
                nWin = self._baseGamePlayerInfoManager:getSelfWin(),
                nLoss = self._baseGamePlayerInfoManager:getSelfLoss(),
                nStandOff = self._baseGamePlayerInfoManager:getSelfStandOff()
            }
            playerInfo:mergeUserData(dataMap)
        end
    end
end

function BaseGameController:addPlayerDeposit(drawIndex, deposit)
    local currentDeposit = 0
    if self._baseGamePlayerInfoManager then
        currentDeposit = self._baseGamePlayerInfoManager:getPlayerDeposit(drawIndex)
        currentDeposit = currentDeposit + deposit
        self:setPlayerDeposit(drawIndex, currentDeposit)
    end
end

function BaseGameController:setPlayerDeposit(drawIndex, deposit)
    if self._baseGamePlayerInfoManager then
        self._baseGamePlayerInfoManager:setPlayerDeposit(drawIndex, deposit)
    end

    if self:getMyDrawIndex() == drawIndex then
        self:setSelfMoney(deposit)

        self:syncPlayerDeposit(deposit)
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:setMoney(drawIndex, deposit)
    end
end

function BaseGameController:syncPlayerDeposit(deposit)
    local playerInfo = mymodel("hallext.PlayerModel"):getInstance()
    if playerInfo then
        local dataMap = {
            nDeposit = deposit
        }
        playerInfo:mergeUserData(dataMap)
    end
end

function BaseGameController:addPlayerScore(drawIndex, score)
    local currentScore = 0
    if self._baseGamePlayerInfoManager then
        currentScore = self._baseGamePlayerInfoManager:getPlayerScore(drawIndex)
        currentScore = currentScore + score
        self:setPlayerScore(drawIndex, currentScore)
    end
end

function BaseGameController:setPlayerScore(drawIndex, score)
    if self._baseGamePlayerInfoManager then
        self._baseGamePlayerInfoManager:setPlayerScore(drawIndex, score)
    end

    if self:getMyDrawIndex() == drawIndex then
        self:syncPlayerScore(score)
    end
end

function BaseGameController:syncPlayerScore(score)
    local playerInfo = mymodel("hallext.PlayerModel"):getInstance()
    if playerInfo then
        local dataMap = {
            nScore = score
        }
        playerInfo:mergeUserData(dataMap)
    end
end

function BaseGameController:showPlayerReady(drawIndex)
    if self:getMyDrawIndex() == drawIndex then
        self:showSelfReady()
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:setReady(drawIndex, true)
    end
end

function BaseGameController:tipChatContent(drawIndex, content)
    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:tipChatContent(drawIndex, content)
    end
end

function BaseGameController:onRemoveLoadingLayer()
    local loadingNode = self._baseGameScene:getLoadingNode()
    if loadingNode then
        loadingNode:finishLoading()
        self._baseGameScene:cleanLoadingNode()
    end

    local loadingLayer = self._baseGameScene:getLoadingLayer()
    if loadingLayer then
        loadingLayer:removeSelf()
        self._baseGameScene:cleanLoadingLayer()
    end

    self:setBackgroundCallback()
    self:setForegroundCallback()

    self:playBGM()
end

function BaseGameController:setSoloPlayer(soloPlayer)
    if self:getMyDrawIndex() == self:rul_GetDrawIndexByChairNO(soloPlayer.nChairNO) then
        self:setSelfUserName(soloPlayer.szUserName)
        self:setSelfMoney(soloPlayer.nDeposit)
        --[[
        考虑到修改性别之后，玩家进入游戏时从服务器获取的性别信息并不是最新的，所以此时以selfInfo中的信息为准。
        ]]
        soloPlayer.nNickSex = self._baseGamePlayerInfoManager:getSelfInfo().nNickSex
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        local drawIndex = self:rul_GetDrawIndexByChairNO(soloPlayer.nChairNO)
        if 0 < drawIndex then
            playerManager:setSoloPlayer(drawIndex, soloPlayer)
        end
    end

    if self._baseGamePlayerInfoManager then
        local drawIndex = self:rul_GetDrawIndexByChairNO(soloPlayer.nChairNO)
        if 0 < drawIndex then
            self._baseGamePlayerInfoManager:setPlayerInfo(drawIndex, soloPlayer)
        end
    end
end

function BaseGameController:playerAbort(drawIndex)
    if self:getMyDrawIndex() ~= drawIndex then
        local playerManager = self._baseGameScene:getPlayerManager()
        if playerManager then
            playerManager:playerAbort(drawIndex)
        end
    end
end

function BaseGameController:onStartGame()
    if self._baseGameConnect then
        self._baseGameConnect:gc_StartGame()
    end
end

function BaseGameController:onChangeTable()
    if not self:isGameRunning() then
        if self._baseGameConnect then
            self._baseGameConnect:gc_AskNewTableChair()
        end
    end
end

function BaseGameController:onRandomTable()
    if not self:isGameRunning() then
        if self._baseGameConnect then
            self._baseGameConnect:gc_AskRandomTable()
        end
    end
end

function BaseGameController:onTouchBegan(x, y)
    local chat = self._baseGameScene:getChat()
    if chat and chat:isVisible() then
        if not chat:containsTouchLocation(x, y) then
            chat:showChat(false)
        end
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:onHidePlayerInfo()
    end
end

function BaseGameController:onKeyBack()
    self:onQuit()
end

function BaseGameController:onQuit()
    local safeBox = self._baseGameScene:getSafeBox()
    if safeBox and safeBox:isVisible() then
        safeBox:showSafeBox(false)
        return
    end

    local setting = self._baseGameScene:getSetting()
    if setting and setting:isVisible() then
        setting:showSetting(false)
        return
    end

    local chat = self._baseGameScene:getChat()
    if chat and chat:isVisible() then
        chat:showChat(false)
        return
    end

    if self:isConnected() and self._baseGameConnect then
        local gameTools = self._baseGameScene:getTools()
        if gameTools and gameTools:isQuitBtnEnabled() then
            self._baseGameConnect:gc_LeaveGame()
        end
    else
        self:gotoHallScene()
    end
end

function BaseGameController:onSetting()
    local setting = self._baseGameScene:getSetting()
    if setting then
        setting:showSetting(true)
    end
end

function BaseGameController:onAutoPlay()
    local autoPlayPanel = self._baseGameScene:getAutoPlayPanel()
    if autoPlayPanel then
        if self:isGameRunning() then
            self._bAutoPlay = not self._bAutoPlay
        end
        autoPlayPanel:setVisible(self._bAutoPlay)
    end
end

function BaseGameController:ope_AutoPlay(bAutoPlay)
    self._bAutoPlay = bAutoPlay
    local autoPlayPanel = self._baseGameScene:getAutoPlayPanel()
    if autoPlayPanel then
        autoPlayPanel:setVisible(self._bAutoPlay)
    end
end

function BaseGameController:isAutoPlay()
    return self._bAutoPlay
end

function BaseGameController:clockStep(dt)
--    if self:isAutoPlay() then
--        self:autoPlay()
--    end
end

function BaseGameController:autoPlay()
end

function BaseGameController:onSafeBox()
    local safeBox = self._baseGameScene:getSafeBox()
    if safeBox then
        safeBox:showSafeBox(true)
        if self._baseGamePlayerInfoManager then
            local gameDeposit = self._baseGamePlayerInfoManager:getSelfDeposit()
            if gameDeposit then
                safeBox:setGameDeposit(gameDeposit)
            end
        end
        self:onUpdateSafeBox()
    end
end

function BaseGameController:onChat()
    local chat = self._baseGameScene:getChat()
    if chat then
        chat:showChat(true)
    end
end

function BaseGameController:onChatSend(content)
    if 0 < string.len(content) and 250 > string.len(content) then
        if self._baseGameConnect then
            self._baseGameConnect:gc_ChatToTable(content)
        end
        --self:tipChatContent(self:getMyDrawIndex(), content)
    end
end

function BaseGameController:onSocketClose()
    self:onSocketError()
end

function BaseGameController:onSocketGracefullyError()
    self:onSocketError()
end

function BaseGameController:gameString( keyStr, ... )
    local str = self:getGameStringByKey(keyStr)
	return string.format(str, ...)
end
function BaseGameController:alert2HallScene(keyStr, ...)
    local msg = self:gameString(keyStr, ...)
    local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, #msg)--string.len(msg)
    self:popSureDialog(utf8Msg, "", "", handler(self, self.gotoHallScene), false)
end
function BaseGameController:alert(keyStr, ...)
    local msg = self:gameString(keyStr, ...)
    local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, #msg)
    self:popSureDialog(utf8Msg, "", "", nil, false)
end
function BaseGameController:onSocketError()
    self._isConnected = false
    if self._offroom then return end

    if self:isGameRunning() then
        self:reconnect()
    else
    	self:alert2HallScene("G_DISCONNECTION_NOPLAYING")
    end
end

function BaseGameController:onTimeOut()
    self:alert2HallScene("G_NETWORKSPEED_SLOW")
end

function BaseGameController:reconnect()
    if self._connectTimes >= 2 then
        self:reconnectionFailed()
    else
        self:reconnection(self._connectTimes)

        self._connectTimes = self._connectTimes + 1
    end
end

function BaseGameController:onSocketConnect()
    self._isResume = false
    self._session = -1
    self._connectTimes = 0
    self:setResponse(self:getResWaitingNothing())
    self._isConnected = true

    self:sendGamePulse()


    if self._baseGameConnect then
        self._baseGameConnect:gc_CheckVersion()
    end
end

function BaseGameController:reconnection(connectTimes)
    if 0 == connectTimes then
        local loadingLayer = self._baseGameScene:getLoadingLayer()
        if loadingLayer and loadingLayer:isVisible() then
            
        else
            self:tipMessageByKey("G_RECONNECTING")
        end
    end

    if self._baseGameNetworkClient then
        self._baseGameNetworkClient:reconnection()
    end
end

function BaseGameController:reconnectionFailed()
    local loadingLayer = self._baseGameScene:getLoadingLayer()
    if loadingLayer and loadingLayer:isVisible() then
        self:tipMessageByKey("G_CANNOTCONNECT")
    else
        self:onQuitFromRoom()
    end
end

function BaseGameController:sendGamePulse()
    local function onPulseInterval(dt)
        if self._baseGameConnect then
            self._baseGameConnect:gc_SendGamePulse()
        end
    end
    self:stopGamePluse()
    self.pulseTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onPulseInterval, 60.0, false)
end

function BaseGameController:stopGamePluse()
    if self.pulseTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.pulseTimerID)
        self.pulseTimerID = nil
    end
end

function BaseGameController:onCheckVersion()
    if self._baseGameConnect then
        self._baseGameConnect:gc_EnterGame()
    end
end

function BaseGameController:onCheckVersionOld()
    self._baseGameScene:showToast('BaseGameController:onCheckVersionOld()')
end

function BaseGameController:onCheckVersionNew()
    local loadingLayer = self._baseGameScene:getLoadingLayer()
    if loadingLayer and loadingLayer:isVisible() then
        self:tipMessageByKey("G_CHECKVERSION_NEW")
    else
        self:alert2HallScene("G_CHECKVERSION_NEW")
    end
end

function BaseGameController:split(s, delim)
    if type(delim) ~= "string" or string.len(delim) <= 0 then
        return
    end

    local start = 1
    local t = {}
    while true do
        local pos = string.find (s, delim, start, true) -- plain find
        if not pos then
            break
        end

        table.insert (t, string.sub (s, start, pos - 1))
        start = pos + string.len (delim)
    end
    table.insert (t, string.sub (s, start))

    return t
end

function BaseGameController:onEnterGameOK(data)
    self:setDXXW(false)
    self:setResume(false)

    local loadingNode = self._baseGameScene:getLoadingNode()
    if loadingNode then
        loadingNode:onEnterGameOK()
    end

    local gameEnterInfo = nil
    local soloPlayers = nil
    if self._baseGameData then
        gameEnterInfo, soloPlayers = self._baseGameData:getEnterGameOKInfo(data)
    end

    if soloPlayers then
        for i = 1, #soloPlayers do
            self:setSoloPlayer(soloPlayers[i])
        end
    end

    if gameEnterInfo then
        for i = 1, self:getTableChairCount() do
            if self:IS_BIT_SET(gameEnterInfo.dwUserStatus[i], BaseGameDef.BASEGAME_US_GAME_STARTED) then
                local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                if 0 < drawIndex then
                    self:showPlayerReady(drawIndex)
                end
            end
        end
    end

    self:ope_ShowStart(true)
    if self:isRandomRoom() then
        self:showWaitArrangeTable(true)

        local gameTools = self._baseGameScene:getTools()
        if gameTools then
            gameTools:onEnterRandomGame()
        end
    end
end

function BaseGameController:onEnterGameDXXW(data)
    self:setDXXW(true)
    self:setResume(false)
    self:gameRun()

    self:onDXXW()

    local loadingNode = self._baseGameScene:getLoadingNode()
    if loadingNode then
        loadingNode:onEnterGameOK()
    end
end

function BaseGameController:onEnterGameIDLE(data)
    self:setDXXW(false)
    self:setResume(false)
    self:gameRun()

    local loadingNode = self._baseGameScene:getLoadingNode()
    if loadingNode then
        loadingNode:onEnterGameOK()
    end
end

function BaseGameController:onDXXW()
    
end

function BaseGameController:onLeaveGameOK()
    self:gotoHallScene()
end

function BaseGameController:onRoomTableChairMismatch()
    self:getFinished()
    self:hardIDMismatch()
end

function BaseGameController:onHardIDMismatch()
    self:hardIDMismatch()
end

function BaseGameController:hardIDMismatch()
    self:disconnect()

    local function pop()
        self:alert2HallScene("G_ENTERGAME_HARDIDMISMATCH")
    end
    self._baseGameScene:nextSchedule(pop, 1)
end

function BaseGameController:onAllStandBy(data)
end

function BaseGameController:onGameAbort(data)
    local gameAbortInfo = nil
    if self._baseGameData then
        gameAbortInfo = self._baseGameData:getGameAbortInfo(data)
    end
    if gameAbortInfo then
        if self:getMyDrawIndex() ~= self:rul_GetDrawIndexByChairNO(gameAbortInfo.nChairNO) then
            self:gameStop()
            self:disconnect()

            local content = ""
            local userName = self:getPlayerUserNameByUserID(gameAbortInfo.nUserID)
            if gameAbortInfo.bForce then
                self:alert2HallScene("G_GAMEABORT_FORCE", userName, gameAbortInfo.nDepositDfif, gameAbortInfo.nScoreDiff)
            else
                self:alert2HallScene("G_GAMEABORT", userName)
            end
        end
    end
end

function BaseGameController:onLeaveGamePlaying()
    self:onLeaveGameFailed()
end

function BaseGameController:onGameTooFast(data)
    self:onLeaveGameFailed()

    local leaveGameTooFast = nil
    if self._baseGameData then
        leaveGameTooFast = self._baseGameData:getLeaveGameTooFastInfo(data)
    end
    if leaveGameTooFast then
        self:alert("G_NEED_WAIT_FOR_RANDOM", leaveGameTooFast.nSecond)
    end
end

function BaseGameController:onChatToTable(data)
    local chatToTable = nil
    if self._baseGameData then
        chatToTable = self._baseGameData:getChatToTableInfo(data)
    end
    if chatToTable then
    end
end

function BaseGameController:onChatFromTable(data)
    local chatFromTable = nil
    local chatMsg = nil
    if self._baseGameData then
        chatFromTable, chatMsg = self._baseGameData:getChatFromTableInfo(data)
    end
    if chatFromTable then
        local tableChatContent = chatMsg
        local contentBegin = string.find(chatMsg, ">")
        if contentBegin then
            tableChatContent = string.sub(chatMsg, contentBegin + 1, 128)
        end

        local contentEnd = string.find(tableChatContent, "\r")
        if contentEnd then
            tableChatContent = string.sub(tableChatContent, 1, contentEnd - 1)
        end

        if chatFromTable.dwFlags == BaseGameDef.BASEGAME_FLAG_CHAT_SYSNOTIFY then
            self:tipMessageByGBStr(tableChatContent)
        elseif chatFromTable.dwFlags == BaseGameDef.BASEGAME_FLAG_CHAT_PLAYERMSG then
            local chatPlayerInfo = self._baseGamePlayerInfoManager:getPlayerInfoByUserID(chatFromTable.nUserID)
            if chatPlayerInfo then
                local drawIndex = self:rul_GetDrawIndexByChairNO(chatPlayerInfo.nChairNO)
                if 0 < drawIndex then
                    self:tipChatContent(drawIndex, tableChatContent)
                end
            end
        end
    end
end

function BaseGameController:onPlayerAbort(data)
    if self:isGameRunning() then
        return
    end

    self:resetResume()

    local gameAbort = nil
    if self._baseGameData then
        gameAbort = self._baseGameData:getPlayerAbortInfo(data)
    end

    if gameAbort and self._baseGamePlayerInfoManager then
        if gameAbort.nUserID == self._baseGamePlayerInfoManager:getSelfUserID() then
            return
        end

        local abortPlayerInfo = self._baseGamePlayerInfoManager:getPlayerInfoByUserID(gameAbort.nUserID)
        if abortPlayerInfo then
            if abortPlayerInfo.nTableNO ~= gameAbort.nTableNO then
                return
            end

            if abortPlayerInfo.nChairNO ~= gameAbort.nChairNO then
                return
            end

            if abortPlayerInfo.bLookOn then
                return
            end
        end

        local playerManager = self._baseGameScene:getPlayerManager()
        if playerManager then
            local drawIndex = self:rul_GetDrawIndexByChairNO(gameAbort.nChairNO)
            if 0 < drawIndex then
                if playerManager:isPlayerEnter(drawIndex) then
                    self:playerAbort(drawIndex)
                end
            end
        end

        if self._baseGameUtilsInfoManager then
            local currentTablePlayerCount = math.max(self._baseGameUtilsInfoManager:getTablePlayerCount() - 1, 0)
            self._baseGameUtilsInfoManager:setTablePlayerCount(currentTablePlayerCount)
        end

        if self._baseGamePlayerInfoManager then
            local drawIndex = self:rul_GetDrawIndexByChairNO(gameAbort.nChairNO)
            if 0 < drawIndex then
                self._baseGamePlayerInfoManager:playerAbort(drawIndex)
            end
        end
    end
end

function BaseGameController:onPlayerEnter(data)
    if self:isGameRunning() then
        return
    end

    local soloPlayer = nil
    if self._baseGameData then
        soloPlayer = self._baseGameData:getPlayerEnterInfo(data)
    end

    if not soloPlayer or soloPlayer.nUserID <= 0 then
        return
    end

    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        local drawIndex = self:rul_GetDrawIndexByChairNO(soloPlayer.nChairNO)
        if not playerManager:isPlayerEnter(drawIndex) then
            if self._baseGameUtilsInfoManager then
                local currentTablePlayerCount = math.min(self._baseGameUtilsInfoManager:getTablePlayerCount() + 1, self:getTableChairCount())
                self._baseGameUtilsInfoManager:setTablePlayerCount(currentTablePlayerCount)
            end
        end
    end

    self:setSoloPlayer(soloPlayer)
end

function BaseGameController:onDepositNotEnough(data)
    local depositNotEnough = nil
    if self._baseGameData then
        depositNotEnough = self._baseGameData:getDepositNotEnoughInfo(data)
    end

    if not depositNotEnough or depositNotEnough.nUserID <= 0 then
        return
    end

    local userName = self:getPlayerUserNameByUserID(depositNotEnough.nUserID)
    self:alert("G_DEPOSIT_NOTENOUGH", userName)
end

function BaseGameController:onScoreNotEnough(data)
    local scoreNotEnough = nil
    if self._baseGameData then
        scoreNotEnough = self._baseGameData:getScoreNotEnoughInfo(data)
    end

    if not scoreNotEnough or scoreNotEnough.nUserID <= 0 then
        return
    end

    local userName = self:getPlayerUserNameByUserID(scoreNotEnough.nUserID)
    self:alert("G_SCORE_NOTENOUGH", userName)
end

function BaseGameController:onScoreTooHigh(data)
    local scoreTooHigh = nil
    if self._baseGameData then
        scoreTooHigh = self._baseGameData:getScoreTooHighInfo(data)
    end

    if not scoreTooHigh or scoreTooHigh.nUserID <= 0 then
        return
    end

    local userName = self:getPlayerUserNameByUserID(scoreTooHigh.nUserID)
    self:alert("G_SCORE_TOOHIGH", userName)
end

function BaseGameController:onUserBoutTooHigh(data)
    local userBoutTooHigh = nil
    if self._baseGameData then
        userBoutTooHigh = self._baseGameData:getUserBoutTooHighInfo(data)
    end

    if not userBoutTooHigh or userBoutTooHigh.nUserID <= 0 then
        return
    end

    local userName = self:getPlayerUserNameByUserID(userBoutTooHigh.nUserID)
    self:alert("G_USERBOUT_TOOHIGH", userName, userBoutTooHigh.nMaxBout)
end

function BaseGameController:onTableBoutTooHigh(data)
    local tableBoutTooHigh = nil
    if self._baseGameData then
        tableBoutTooHigh = self._baseGameData:getTableBoutTooHighInfo(data)
    end

    if not tableBoutTooHigh then
        return
    end
    self:alert("G_TABLEBOUT_TOOHIGH", tableBoutTooHigh.nMaxBout)
end

function BaseGameController:onStartSoloTable(data)
    local soloTable = nil
    local soloPlayers = nil
    local startInfo = nil
    local chairNO = 0
    if self._baseGameData then
        soloTable, soloPlayers, startInfo = self._baseGameData:getSoloTableInfo(data)
    end

    if soloTable then
        if self._baseGameUtilsInfoManager then
            self._baseGameUtilsInfoManager:setTablePlayerCount(soloTable.nUserCount)
        end

        if self._baseGamePlayerInfoManager then
            self._baseGamePlayerInfoManager:setSelfTableNO(soloTable.nTableNO)
            local selfChairNO = 0
            for i = 1, soloTable.nUserCount do
                if self._baseGamePlayerInfoManager:getSelfUserID() == soloTable.nUserIDs[i] then
                    self._baseGamePlayerInfoManager:setSelfChairNO(i - 1)
                end
            end

            self._baseGamePlayerInfoManager:clearPlayersInfo()
        end

        local playerManager = self._baseGameScene:getPlayerManager()
        if playerManager then
            playerManager:clearPlayers()
        end
        if soloPlayers then
            for i = 1, soloTable.nUserCount do
                self:setSoloPlayer(soloPlayers[i])
            end
        end
    end

    if startInfo then
        self:onGameStartSolo(startInfo)
    end
end

function BaseGameController:onGameStartSolo(data)end

function BaseGameController:onUserDepositEvent(data)
    local userDepositEvent = nil
    if self._baseGameData then
        userDepositEvent = self._baseGameData:getUserDepositEventInfo(data)
    end

    if userDepositEvent then
        if userDepositEvent.nChairNO ~= self:getMyChairNO() and userDepositEvent.nEvent ~= BaseGameDef.BASEGAME_USER_LOOK_SAFE_DEPOSIT then
            local drawIndex = self:rul_GetDrawIndexByChairNO(userDepositEvent.nChairNO)
            if 0 < drawIndex then
                self:setPlayerDeposit(drawIndex, userDepositEvent.nDeposit)
            end
        end
    end
end

function BaseGameController:onUserPosition(data)
    local userPos = nil
    local soloPlayers = nil
    if self._baseGameData then
        userPos, soloPlayers = self._baseGameData:getUserPosInfo(data)
    end

    if userPos then
        self:clearGameTable()

        if self._baseGameUtilsInfoManager then
            self._baseGameUtilsInfoManager:setTablePlayerCount(userPos.nPlayerCount)
        end

        if self._baseGamePlayerInfoManager then
            self._baseGamePlayerInfoManager:setSelfTableNO(userPos.nTableNO)
            self._baseGamePlayerInfoManager:setSelfChairNO(userPos.nChairNO)

            self._baseGamePlayerInfoManager:clearPlayersInfo()
        end

        local msg = self:gameString("G_CHANGETABLE_OK", userPos.nTableNO + 1)
        self:tipMessageByGBStr(msg)

        local playerManager = self._baseGameScene:getPlayerManager()
        if playerManager then
            playerManager:clearPlayers()
        end
        if soloPlayers then
            for i = 1, userPos.nPlayerCount do
                self:setSoloPlayer(soloPlayers[i])
            end
        end

        for i = 1, self:getTableChairCount() do
            if self:IS_BIT_SET(userPos.dwUserStatus[i], BaseGameDef.BASEGAME_US_GAME_STARTED) then
                local drawIndex = self:rul_GetDrawIndexByChairNO(i - 1)
                if 0 < drawIndex then
                    self:showPlayerReady(drawIndex)
                end
            end
        end

        local gameStart = self._baseGameScene:getStart()
        if gameStart then
            gameStart:onUserPosition()
        end
        local selfInfo = self._baseGameScene:getSelfInfo()
        if selfInfo then
            selfInfo:showSelfReady(false)
        end
    end
end

function BaseGameController:rspStartGame()
    local gameStart = self._baseGameScene:getStart()
    if gameStart then
        gameStart:rspStartGame()
    end

    self:clearGameTable()

    if not self:isWaitArrangeTableShow() then
        self:showPlayerReady(self:getMyDrawIndex())
    end

    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:disableSafeBox()
    end
end

function BaseGameController:ope_GameStart()
    self:ope_ShowStart(false)
end

function BaseGameController:clearGameTable()
--    local selfInfo = self._baseGameScene:getSelfInfo()
--    if selfInfo then
--        selfInfo:showSelfReady(false)
--    end
end

function BaseGameController:onLookSafeDeposit(data)
    local safeBoxDeposit = nil
    if self._baseGameData then
        safeBoxDeposit = self._baseGameData:getSafeBoxDepositInfo(data)
    end

    if safeBoxDeposit then
        local safeBox = self._baseGameScene:getSafeBox()
        if safeBox then
            safeBox:onLookSafeDeposit(safeBoxDeposit.nDeposit, 0 < safeBoxDeposit.bHaveSecurePwd)
        end
    end
end

function BaseGameController:onTakeSafeDeposit()
    local safeBox = self._baseGameScene:getSafeBox()
    if safeBox then
        local takeDeposit = safeBox:getTransferDeposit()
        self:addPlayerDeposit(self:getMyDrawIndex(), takeDeposit)

        safeBox:onTakeSafeDepositSucceed()

        self:tipMessageByKey("G_SAFEBOX_TAKESUCCEED")
    end
end

function BaseGameController:onSaveSafeDeposit()
    local safeBox = self._baseGameScene:getSafeBox()
    if safeBox then
        local saveDeposit = safeBox:getTransferDeposit()
        self:addPlayerDeposit(self:getMyDrawIndex(), -saveDeposit)

        safeBox:onSaveSafeDepositSucceed()

        self:tipMessageByKey("G_SAFEBOX_SAVESUCCEED")
    end
end

function BaseGameController:onTakeSafeRndkey(data)
    local safeRndKey = nil
    if self._baseGameData then
        safeRndKey = self._baseGameData:getRndKeyInfo(data)
    end

    if safeRndKey then
        local safeBox = self._baseGameScene:getSafeBox()
        if safeBox then
            safeBox:onTakeSafeRndkey(safeRndKey.nRndKey)
        end
    end
end

function BaseGameController:onSafeBoxFailed(request, response, data)
    local msg = self:getGameStringByKey("G_SAFEBOX_OPERATE_FAILD")

    local switchAction = {
        [BaseGameDef.BASEGAME_GR_SERVICE_BUSY]          = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_SERVICE_BUSY")
        end,
        [BaseGameDef.BASEGAME_GR_DEPOSIT_NOTENOUGH]     = function(msg)
            if BaseGameDef.BASEGAME_WAITING_SAVE_SAFE_DEPOSIT == response then
                return self:getGameStringByKey("G_SAFEBOX_SAVE_NOTENOUGH")
            elseif BaseGameDef.BASEGAME_WAITING_TAKE_SAFE_DEPOSIT == response then
                return self:getGameStringByKey("G_SAFEBOX_TAKE_NOTENOUGH")
            end
            return msg
        end,
        [BaseGameDef.BASEGAME_GR_NO_THIS_FUNCTION]      = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_NO_THIS_FUNCTION")
        end,
        [BaseGameDef.BASEGAME_GR_SYSTEM_LOCKED]         = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_SYSTEM_LOCKED")
        end,
        [BaseGameDef.BASEGAME_GR_TOKENID_MISMATCH]      = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_TOKENID_MISMATCH")
        end,
        [BaseGameDef.BASEGAME_GR_HARDID_MISMATCHEX]     = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_HARDID_MISMATCHEX")
        end,
        [BaseGameDef.BASEGAME_GR_CONTINUE_PWDWRONG]     = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_CONTINUE_SECUREPWDERROR_TAKEDEPOSIT")
        end,
        [BaseGameDef.BASEGAME_GR_ERROR_INFOMATION]      = function(msg)
            return msg
        end,
        [BaseGameDef.BASEGAME_GR_PWDLEN_INVALID]        = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_PWDLEN_INVALID")
        end,
        [BaseGameDef.BASEGAME_GR_NEED_LOGON]            = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_NEED_LOGON")
        end,
        [BaseGameDef.BASEGAME_GR_ROOM_NOT_EXIST]        = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_ROOM_NOT_EXIST")
        end,
        [BaseGameDef.BASEGAME_GR_NODEPOSIT_GAME]        = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_NODEPOSIT_GAME")
        end,
        [BaseGameDef.BASEGAME_GR_ROOM_CLOSED]           = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_ROOM_CLOSED")
        end,
        [BaseGameDef.BASEGAME_GR_BOUT_NOTENOUGH]        = function(msg)
            local _, bout = string.unpack(data, '<i')
            return self:gameString("G_SAFEBOX_OUTPUT_BOUT_NOTENOUGH", bout)
        end,
        [BaseGameDef.BASEGAME_GR_TIMECOST_NOTENOUGH]    = function(msg)
            local _, minute = string.unpack(data, '<i')
            return self:gameString("G_SAFEBOX_OUTPUT_TIMECOST_NOTENOUGH", minute)
        end,
        [BaseGameDef.BASEGAME_GR_ROOM_NOT_OPENED]       = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_ROOM_NOT_OPENED")
        end,
        [BaseGameDef.BASEGAME_GR_NEED_PLAYING]          = function(msg)
            return msg
        end,
        [BaseGameDef.BASEGAME_GR_NO_MOBILEUSER]         = function(msg)
            return msg
        end,
        [BaseGameDef.BASEGAME_GR_INPUTLIMIT_DAILY]      = function(msg)
            local _, nTransferTotal, nTransferLimit = string.unpack(data, '<ii')
            if 0 < nTransferTotal - nTransferLimit then
                return self:gameString("G_SAFEBOX_INPUTLIMIT_DAILY", nTransferLimit, nTransferTotal - nTransferLimit)
            else
                return self:gameString("G_SAFEBOX_INPUTLIMIT_TOMORROW", nTransferLimit)
            end
        end,
        [BaseGameDef.BASEGAME_GR_KEEPDEPOSIT_LIMIT]     = function(msg)
            local _, nGameDeposit, nKeepDeposit = string.unpack(data, '<ii')
        end,
        [BaseGameDef.BASEGAME_GR_INPUTLIMIT_MONTHLY]    = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_INPUTLIMIT_MONTHLY")
        end,
        [BaseGameDef.BASEGAME_GR_USER_FORBIDDEN]        = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_USER_FORBIDDEN")
        end,
        [BaseGameDef.BASEGAME_GR_SAFEBOX_GAME_READY]    = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_GAME_USER_START")
        end,
        [BaseGameDef.BASEGAME_GR_SAFEBOX_GAME_PLAYING]  = function(msg)
            return self:getGameStringByKey("G_SAFEBOX_PLAYING_GAME_NOTTRANS")
        end,
        [BaseGameDef.BASEGAME_GR_SAFEBOX_DEPOSIT_MIN]   = function(msg)
            if self._baseGameUtilsInfoManager then
                return self:gameString("G_SAFEBOX_MIN_DEPOSIT", self._baseGameUtilsInfoManager:getRoomMinDeposit())
            else
                return msg
            end
        end,
        [BaseGameDef.BASEGAME_GR_SAFEBOX_DEPOSIT_MAX]   = function(msg)
            if self._baseGameUtilsInfoManager then
                return self:gameString("G_SAFEBOX_MAX_DEPOSIT", self._baseGameUtilsInfoManager:getRoomMaxDeposit())
            else
                return msg
            end
        end,
    }

    if switchAction[request] then
        msg = switchAction[request](msg)
    end
    self:tipMessageByGBStr(msg)
end

function BaseGameController:onWaitNewTable()
    self:clearGameTable()

    self:clearPlayerReady()

    local selfInfo = self._baseGameScene:getSelfInfo()
    if selfInfo then
        selfInfo:showSelfReady(false)
    end
    local gameTools = self._baseGameScene:getTools()
    if gameTools then
        gameTools:disableSafeBox()
    end

    self:showWaitArrangeTable(true)
end

function BaseGameController:onGetTableInfo(data)
    self:parseGameTableInfoData(data)

    self:setResume(false)
    self:onDXXW()
end

function BaseGameController:parseGameTableInfoData(data)end

function BaseGameController:onGetTableInfoFailed()
    self:alert2HallScene("G_NETWORKSPEED_SLOW")
end

function BaseGameController:onPlayerStartGame(data)
    if not self._baseGameScene then return end

    local playerStartGame = nil
    if self._baseGameData then
        playerStartGame = self._baseGameData:getPlayerStartGameInfo(data)
    end

    if playerStartGame then
        local playerManager = self._baseGameScene:getPlayerManager()
        if playerManager then
            local drawIndex = self:rul_GetDrawIndexByChairNO(playerStartGame.nChairNO)
            if 0 < drawIndex and drawIndex ~= self:getMyDrawIndex() then
                self:showPlayerReady(drawIndex)
            end
        end
    end
end

function BaseGameController:onEnterGameFailed()
    self:disconnect()

    local loadingNode = self._baseGameScene:getLoadingNode()
    if loadingNode then
        --loadingNode:stopLoadingTimer()
    end
    function keyStr(alter)
        if alter then
            return "G_ENTERGAME_FAILED_PLAYING"
        else
            return "G_ENTERGAME_FAILED"
        end
    end
    local alter = self:isGameRunning()
    local function pop()
        self:alert2HallScene(keyStr(alter))
    end
    self._baseGameScene:nextSchedule(pop, 1)
end

function BaseGameController:onLeaveGameFailed()
    if  self:isGameRunning() then
        self:alert("G_LEAVEGAME_FAILED_PLAYING")
    else
        local content = self:getGameStringByKey("G_LEAVEGAME_FAILED")
        self:tipMessageByGBStr(content)
    end
end

function BaseGameController:alert2Safebox(keyStr, dep)
    local msg = self:gameString(keyStr, dep)
    local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, #msg)
    self:popSureDialog(utf8Msg, "", "", handler(self, self.onSafeBox), false)
end
function BaseGameController:onStartFailedNotEnough(data)
    if not self._baseGameScene then return end

    local startFailedNotEnough = nil
    if self._baseGameData then
        startFailedNotEnough = self._baseGameData:getStartFailedNotEnoughInfo(data)
    end

    if startFailedNotEnough then
        local dep = startFailedNotEnough.nMinDeposit - startFailedNotEnough.nDeposit
        self:alert2Safebox("G_MOVEDEPOSIT_NOTENOUGH", dep)
    end
end

function BaseGameController:onStartFailedTooHigh(data)
    if not self._baseGameScene then return end

    local startFailedTooHigh = nil
    if self._baseGameData then
        startFailedTooHigh = self._baseGameData:getStartFailedTooHighInfo(data)
    end

    if startFailedTooHigh then
        local dep = startFailedTooHigh.nDeposit - startFailedTooHigh.nMaxDeposit
        self:alert2Safebox("G_MOVEDEPOSIT_TOOHIGHT", dep)
    end
end

function BaseGameController:gotoHallScene()
    print("GoBackToMainScene")
    self:getFinished()
    self._offroom = nil
end

function BaseGameController:getGameStringByKey(key)
    if GamePublicInterface then
        return GamePublicInterface:getGameString(key)
    end
    return "" 
end

function BaseGameController:tipMessageByKey(key)
    local msg = self:getGameStringByKey(key)
    if msg then
        local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
        self:tipMessageByUTF8Str(utf8Msg)
    end
end

function BaseGameController:tipMessageByUTF8Str(msg)
    if self._baseGameScene then
        self._baseGameScene:showToast(msg, 2.5)
    end
end

function BaseGameController:tipMessageByGBStr(msg)
    local utf8Msg = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
    self:tipMessageByUTF8Str(utf8Msg)
end

function BaseGameController:popChoseDialog(content, title, cancelTitle, cancelCallback, okTitle, okCallback, needCloseBtn)
    if self._baseGameScene then
    end
end

function BaseGameController:popSureDialog(content, title, okTitle, okCallback, needCloseBtn)
    if self._baseGameScene then
    end
end

function BaseGameController:onUpdateSafeBox()
    if self._baseGameConnect then
        self._baseGameConnect:gc_LookSafeDeposit()
    end
end

function BaseGameController:onSaveDeposit(deposit)
    if self:canTakeDepositInGame() then
        if self._baseGameConnect then
            local gameDeposit = 0
            if self._baseGamePlayerInfoManager then
                if gameDeposit and self._baseGamePlayerInfoManager then
                    gameDeposit = self._baseGamePlayerInfoManager:getSelfDeposit()
                end
            end
            self._baseGameConnect:gc_SaveDeposit(deposit, gameDeposit)
        end
    else
        self:onSafeBoxFailed(BaseGameDef.BASEGAME_GR_NO_THIS_FUNCTION)
    end
end

function BaseGameController:onTakeDeposit(deposit, keyResult)
    if self:canTakeDepositInGame() then
        if self._baseGameConnect then
            local gameDeposit = 0
            if self._baseGamePlayerInfoManager then
                if gameDeposit and self._baseGamePlayerInfoManager then
                    gameDeposit = self._baseGamePlayerInfoManager:getSelfDeposit()
                end
            end
            self._baseGameConnect:gc_TakeDeposit(deposit, keyResult, gameDeposit)
        end
    else
        self:onSafeBoxFailed(BaseGameDef.BASEGAME_GR_NO_THIS_FUNCTION)
    end
end

function BaseGameController:onGetRndKey()
    if self._baseGameConnect then
        self._baseGameConnect:gc_TakeRndKey()
    end
end

function BaseGameController:canTakeDepositInGame()
    local needDeposit = false
    local takeDepositInGame = false
    if self._baseGameUtilsInfoManager then
        needDeposit = self:isNeedDeposit()
        takeDepositInGame = self:IS_BIT_SET(self._baseGameUtilsInfoManager:getRoomConfigs() ,BaseGameDef.BASEGAME_RC_TAKEDEPOSITINGAME)
    end
    return needDeposit and takeDepositInGame
end

function BaseGameController:isNeedDeposit()
    local bNeedDeposit = false
    if self._baseGameUtilsInfoManager then
        bNeedDeposit = self:IS_BIT_SET(self._baseGameUtilsInfoManager:getRoomOptions() ,BaseGameDef.BASEGAME_RO_NEED_DEPOSIT)
    end
    return bNeedDeposit
end

function BaseGameController:onNotifyAdminMsgToRoom(msg)
    self:tipMessageByGBStr(msg)
end

function BaseGameController:onNotifyKickedOffByAdmin()
    self:alert2HallScene("G_KICKOFFBYADMIN")
end

function BaseGameController:onNotifyKickedOffByLogonAgain()
    self:alert2HallScene("G_KICKOFFBYLOGONAGAIN")
end

function BaseGameController:onQuitFromRoom()
    self._offroom = true
    self:alert2HallScene("G_DISCONNECTION")
end

function BaseGameController:ope_ShowGameInfo(bShow)
    local gameInfo = self._baseGameScene:getGameInfo()
    if gameInfo then
        gameInfo:ope_ShowGameInfo(bShow)
    end
end

function BaseGameController:getFinished()
    local playerInfoManager = self:getPlayerInfoManager()
    local uitleInfoManager  = self:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local params = {
        nChairNO    = playerInfoManager:getSelfChairNO(),
        nGameID     = uitleInfoManager:getGameID(),
        nRoomID     = uitleInfoManager:getRoomID(),
        nAreaID     = uitleInfoManager:getAreaID(),
        nTableNO    = playerInfoManager:getSelfTableNO(),
        nUserID     = playerInfoManager:getSelfUserID(),
        szHardID    = uitleInfoManager:getHardID()
    }
    self._baseGameScene:goBack(params)
end

function BaseGameController:playEffect(fileName)
    local soundPath = "res/Game/GameSound/"
    audio.playSound(soundPath .. fileName)
end

function BaseGameController:playGamePublicSound(fileName)
    local soundPath = "PublicSound/"
    self:playEffect(soundPath .. fileName .. ".ogg")
end

function BaseGameController:playGamePublicEffect(fileName)
    local soundPath = "PublicSound/"
    self:playEffect(soundPath .. fileName .. ".mp3")
end

function BaseGameController:playBtnPressedEffect()
    self:playGamePublicEffect("KeypressStandard")
end

function BaseGameController:onClickPlayerHead(drawIndex)
    local playerManager = self._baseGameScene:getPlayerManager()
    if playerManager then
        playerManager:onClickPlayerHead(drawIndex)
    end
end

function BaseGameController:getDepositLevel(deposit)
    local nlevel = 0
    if deposit >= 26214400 then
        nlevel = 20
    elseif deposit >= 13107200 then
        nlevel = 19
    elseif deposit >= 6553600 then
        nlevel = 18
    elseif deposit >= 3276800 then
        nlevel = 17
    elseif deposit >= 1638400 then
        nlevel = 16
    elseif deposit >= 819200 then
        nlevel = 15
    elseif deposit >= 409600 then
        nlevel = 14
    elseif deposit >= 204800 then
        nlevel = 13
    elseif deposit >= 102400 then
        nlevel = 12
    elseif deposit >= 51200 then
        nlevel = 11
    elseif deposit >= 25600 then
        nlevel = 10
    elseif deposit >= 12800 then
        nlevel = 9
    elseif deposit >= 6400 then
        nlevel = 8
    elseif deposit >= 3200 then
        nlevel = 7
    elseif deposit >= 1600 then
        nlevel = 6
    elseif deposit >= 800 then
        nlevel = 5
    elseif deposit >= 400 then
        nlevel = 4
    elseif deposit >= 200 then
        nlevel = 3
    elseif deposit >= 100 then
        nlevel = 2
    elseif deposit >= 0 then
        nlevel = 1
    end

    return self:getGameStringByKey("G_DEPOSIT_LEVEL_" .. tostring(nlevel))
end

function BaseGameController:isSingleClk()
    local setting = self._baseGameScene:getSetting()
    if setting then
        return setting:isSelCardBySingleClk()
    end
    return true
end

function BaseGameController:getGameVersion()
    return self._baseGameScene:getApp():getConfig('app').version
end

return BaseGameController
