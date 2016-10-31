
local GameFrameScene = import("src.app.Game.mGameFrame.GameFrameScene")
local BaseGameScene = class("BaseGameScene", GameFrameScene)

local BaseGameDef               = import("src.app.Game.mBaseGame.BaseGameDef")
local BaseGameController        = import("src.app.Game.mBaseGame.BaseGameController")

local CanvasLayer               = import("src.app.Game.mCommon.CanvasLayer")
local BaseGameLoadingPanel      = import("src.app.Game.mBaseGame.BaseGameLoadingPanel")
local BaseGameClock             = import("src.app.Game.mBaseGame.BaseGameClock")
local BaseGamePlayerManager     = import("src.app.Game.mBaseGame.BaseGamePlayerManager")
local BaseGameTools             = import("src.app.Game.mBaseGame.BaseGameTools")
local BaseGameInfo              = import("src.app.Game.mBaseGame.BaseGameInfo")
local BaseGameSysInfoPanel      = import("src.app.Game.mBaseGame.BaseGameSysInfoPanel")
local BaseGamePlayer            = import("src.app.Game.mBaseGame.BaseGamePlayer")
local BaseGameStart             = import("src.app.Game.mBaseGame.BaseGameStart")
local BaseGameSelfInfo          = import("src.app.Game.mBaseGame.BaseGameSelfInfo")
local BaseGameChat              = import("src.app.Game.mBaseGame.BaseGameChat")
local BaseGameSafeBox           = import("src.app.Game.mBaseGame.BaseGameSafeBox")
local BaseGameSetting           = import("src.app.Game.mBaseGame.BaseGameSetting")

BaseGameScene.GameTags          = {
    BASEGAMETAGS_BEGIN          = 20000,
    GAMETAGS_GAMELAYER          = 20001,
    GAMETAGS_SYSINFOLAYER       = 20002,
    GAMETAGS_LOADINGLAYER       = 20003
}

BaseGameScene.GameLayerZIndex   = {
    GAMELAYER                   = 0,
    SYSINFOLAYER                = 1,
    LOADINGLAYER                = 2,
}

local windowSize = cc.Director:getInstance():getWinSize()

function BaseGameScene:ctor(app, name)
    self._gameController        = nil

    self._baseLayer             = nil
    self._gameNode              = nil
    self._clock                 = nil
    self._playerManager         = nil 
    self._tools                 = nil
    self._gameInfo              = nil
    self._sysInfoNode           = nil
    self._start                 = nil
    self._selfInfo              = nil

    self._loadingLayer          = nil
    self._loadingNode           = nil

    self._autoPlayPanel         = nil

    self._chat                  = nil
    self._safeBox               = nil
    self._setting               = nil

    BaseGameScene.super.ctor(self, app, name)
end

function BaseGameScene:onCreate()
    self:setControllerDelegate()
    self:initGameController()

    BaseGameScene.super.onCreate(self)
end

function BaseGameScene:init()
    BaseGameScene.super.init(self)

    self:setTouched()
    self:setKeypad()

    self:createNetwork()
end

function BaseGameScene:setControllerDelegate()
    if not BaseGameController then printError("BaseGameController is nil!!!") return end
    self._gameController = BaseGameController
end

function BaseGameScene:getGameController()
    return self._gameController
end

function BaseGameScene:initGameController()
    if self._gameController then
        self._gameController:initGameController(self)
    end
end

function BaseGameScene:createBaseLayer()
    self._baseLayer = cc.Layer:create()
    if self._baseLayer then
        self:addChild(self._baseLayer)
    end

    BaseGameScene.super.createBaseLayer(self)
end

function BaseGameScene:createGameLayer()
    local gameLayer = cc.Layer:create()
    if gameLayer and self._baseLayer then
        self._baseLayer:addChild(gameLayer, self.GameLayerZIndex.GAMELAYER, self.GameTags.GAMETAGS_GAMELAYER)
        self:addGameNode()
    end

    BaseGameScene.super.createGameLayer(self)
end

function BaseGameScene:createSysInfoLayer()
    local sysInfoLayer = cc.Layer:create()
    if sysInfoLayer and self._baseLayer then
        self._baseLayer:addChild(sysInfoLayer, self.GameLayerZIndex.SYSINFOLAYER, self.GameTags.GAMETAGS_SYSINFOLAYER)
        self:addSysInfoNode()
    end

    BaseGameScene.super.createSysInfoLayer(self)
end

function BaseGameScene:createLoadingLayer()
    self._loadingLayer = CanvasLayer:create(cc.c4b(192, 85, 20, 0), windowSize.width, windowSize.height)
    if self._loadingLayer then
        self._baseLayer:addChild(self._loadingLayer, self.GameLayerZIndex.LOADINGLAYER)
        self:addLoadingNode()
    end

    BaseGameScene.super.createLoadingLayer(self)
end

function BaseGameScene:createNetwork()
    if self._gameController then
        self._gameController:createNetwork()
    end
end

function BaseGameScene:setTouched()
    if self._baseLayer then
        self._baseLayer:setTouchEnabled(true)

        local listener = function(eventType, x, y)
            if eventType == "began" then
                self:onTouchBegan(x, y)
                return true
            elseif eventType == "moved" then
            elseif eventType == "ended" then
            end
        end
        self._baseLayer:registerScriptTouchHandler(listener, false, -1, false)
    end
end

function BaseGameScene:onTouchBegan(x, y)
    if self._gameController then
        self._gameController:onTouchBegan(x, y)
    end
end

function BaseGameScene:setKeypad()
    if not self._baseLayer then return end

    local function onKeyboardReleased(keyCode, event)
        self:onKeyboardReleased(keyCode, event)
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyboardReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self._baseLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._baseLayer)
end

function BaseGameScene:onKeyboardReleased(keyCode, event)
    if keyCode == cc.KeyCode.KEY_BACK then
        self:onKeyBack()
    elseif keyCode == cc.KeyCode.KEY_ALT then
        -- do sth.
    end
end

function BaseGameScene:onKeyBack()
    if self._gameController then
        self._gameController:onKeyBack()
    end
end

function BaseGameScene:addGameNode()
    if not self._baseLayer then return end

    local gameLayer = self._baseLayer:getChildByTag(self.GameTags.GAMETAGS_GAMELAYER)
    if gameLayer then
        local csbPath = "res/GameCocosStudio/game/GameScene.csb"
        self._gameNode = cc.CSLoader:createNode(csbPath)
        if self._gameNode then
            self._gameNode:setContentSize(cc.Director:getInstance():getVisibleSize())
            ccui.Helper:doLayout(self._gameNode)
            gameLayer:addChild(self._gameNode)
        end
    end

    self:setClock()
    self:setPlayers()
    self:setGameInfo()
    self:setTools()
    self:setChatBtn()
    self:setStart()
    self:setSelfInfo()
    self:setAutoPlay()
    self:setChat()
    self:setSafeBox()
    self:setSetting()

    self:setGameCtrlsAboveBaseGame()
end

function BaseGameScene:setClock()
    if not self._gameNode then return end

    local clockPanel = self._gameNode:getChildByName("Panel_Clock")
    if clockPanel then
        self._clock = BaseGameClock:create(clockPanel, self._gameController)
    end
end

function BaseGameScene:setPlayers()
    if not self._gameNode then return end

    local players = {}
    for i = 1, self._gameController:getTableChairCount() do
        local playerPanel = self._gameNode:getChildByName("Panel_Player" .. tostring(i))
        if playerPanel then
            players[i] = BaseGamePlayer:create(playerPanel, i, self._gameController)
        end
    end

    self._playerManager = BaseGamePlayerManager:create(players, self._gameController)
end

function BaseGameScene:setGameInfo()
    if not self._gameNode then return end

    local gameInfo = self._gameNode:getChildByName("Panel_GameInfo")
    if gameInfo then
        self._gameInfo = BaseGameInfo:create(gameInfo, self._gameController)
    end
end

function BaseGameScene:setTools()
    if not self._gameNode then return end

    local toolsPanel = self._gameNode:getChildByName("Panel_Tools")
    if toolsPanel then
        self._tools = BaseGameTools:create(toolsPanel, true, self._gameController)
    end
end

function BaseGameScene:setChatBtn()
    if not self._gameNode then return end

    local function onChat()
        self._gameController:playBtnPressedEffect()
        print("onChat")
        self._gameController:onChat()
    end
    local buttonChat = self._gameNode:getChildByName("button_chat")
    if buttonChat then
        buttonChat:addClickEventListener(onChat)
    end
end

function BaseGameScene:setStart()
    if not self._gameNode then return end

    local startPanel = self._gameNode:getChildByName("Panel_Start")
    if startPanel then
        self._start = BaseGameStart:create(startPanel, self._gameController)
    end
end

function BaseGameScene:setSelfInfo()
    if not self._gameNode then return end

    local selfInfoPanel = self._gameNode:getChildByName("Panel_SelfInfo")
    if selfInfoPanel then
        self._selfInfo = BaseGameSelfInfo:create(selfInfoPanel)
    end
end

function BaseGameScene:setAutoPlay()
    if not self._gameNode then return end

    self._autoPlayPanel = self._gameNode:getChildByName("Panel_AutoPlay")

    local csbPath = "res/GameCocosStudio/autoplay/AutoPlayNode.csb"
    local action = cc.CSLoader:createTimeline(csbPath)
    if action and self._autoPlayPanel then
        self._autoPlayPanel:runAction(action)
        action:gotoFrameAndPlay(0, 120, true)
    end
end

function BaseGameScene:setChat()
    if not self._gameNode then return end

    local chatPanel = self._gameNode:getChildByName("Panel_Chat")
    if chatPanel then
        self._chat = BaseGameChat:create(chatPanel, self._gameController)
    end
end

function BaseGameScene:setSafeBox()
    if not self._gameNode then return end

    local safeBoxPanel = self._gameNode:getChildByName("Panel_SafeBox")
    if safeBoxPanel then
        self._safeBox = BaseGameSafeBox:create(safeBoxPanel, self._gameController)
    end
end

function BaseGameScene:setSetting()
    if not self._gameNode then return end

    local settingPanel = self._gameNode:getChildByName("Panel_Setting")
    if settingPanel then
        self._setting = BaseGameSetting:create(settingPanel, self._gameController)
    end
end

function BaseGameScene:setGameCtrlsAboveBaseGame() end

function BaseGameScene:calcSysInfoPos()
    local sysInfoPos = cc.p(windowSize.width - 150, 15)
    if self._gameNode and self._sysInfoNode then
        local selfInfo = self._gameNode:getChildByName("Panel_SelfInfo")
        if selfInfo then
            sysInfoPos.x = selfInfo:getPositionX() + selfInfo:getContentSize().width / 2 - self._sysInfoNode:getContentSize().width - 30
            sysInfoPos.y = selfInfo:getPositionY()
        end
    end
    return sysInfoPos
end

function BaseGameScene:addSysInfoNode()
    if not self._baseLayer then return end

    local sysInfoLayer = self._baseLayer:getChildByTag(self.GameTags.GAMETAGS_SYSINFOLAYER)
    if sysInfoLayer then
        self._sysInfoNode = BaseGameSysInfoPanel:create()
        self._sysInfoNode:setAnchorPoint(cc.p(0.0, 0.5))
        sysInfoLayer:addChild(self._sysInfoNode)
        self._sysInfoNode:setPosition(self:calcSysInfoPos())
    end
end

function BaseGameScene:addLoadingNode()
    if not self._loadingLayer then return end

    self._loadingNode = BaseGameLoadingPanel:create(self._gameController)
    if self._loadingNode then
        self._loadingLayer:addChild(self._loadingNode)
        self._loadingNode:setPosition(cc.p(windowSize.width / 2, windowSize.height / 2))
    end
end

function BaseGameScene:cleanLoadingNode()   self._loadingNode = nil         end
function BaseGameScene:cleanLoadingLayer()  self._loadingLayer = nil        end

function BaseGameScene:getClock()           return self._clock              end
function BaseGameScene:getPlayerManager()   return self._playerManager      end
function BaseGameScene:getTools()           return self._tools              end
function BaseGameScene:getGameInfo()        return self._gameInfo           end
function BaseGameScene:getStart()           return self._start              end
function BaseGameScene:getSelfInfo()        return self._selfInfo           end
function BaseGameScene:getSysInfoNode()     return self._sysInfoNode        end
function BaseGameScene:getLoadingLayer()    return self._loadingLayer       end
function BaseGameScene:getLoadingNode()     return self._loadingNode        end
function BaseGameScene:getAutoPlayPanel()   return self._autoPlayPanel      end
function BaseGameScene:getSafeBox()         return self._safeBox            end
function BaseGameScene:getChat()            return self._chat               end
function BaseGameScene:getSetting()         return self._setting            end

function BaseGameScene:onEnter()
    BaseGameScene.super.onEnter(self)

    if self._gameController then
        self._gameController:onGameEnter()
    end
end

function BaseGameScene:onExit()
    if self._gameController then
        self._gameController:onGameExit()
    end
end

return BaseGameScene
