
local BaseGameScene = import("..mBaseGame.BaseGameScene")
local MJGameScene = class("MJGameScene", BaseGameScene)


local MJGameDef                     = import(".MJGameDef")
local MJGameController              = import(".MJGameController")

local CanvasLayer                   = import("..mCommon.CanvasLayer")
local MJGameClock                   = import(".MJGameClock")
local MJGamePlayerManager           = import(".MJGamePlayerManager")
local BaseGameTools                 = import("..mBaseGame.BaseGameTools")
local MJGameGameInfo                = import(".MJGameInfo")
local MJGamePlayer                  = import(".MJGamePlayer")
local MJGameDice                    = import(".MJGameDice")
local MJHandCards                   = import(".MJHandCards")
local MJHandCardsManager            = import(".MJHandCardsManager")
local MJThrownCardsManager          = import(".MJThrownCardsManager")
local MJCastoffCards                = import(".MJCastoffCards")
local MJCastoffCardsManager         = import(".MJCastoffCardsManager")
local MJPGCCards                    = import(".MJPGCCards")
local MJPGCCardsManager             = import(".MJPGCCardsManager")
local MJPGCHManager                 = import(".MJPGCHManager")
local MJChoseCardsManager           = import(".MJChoseCardsManager")
local MJShowDownCards               = import(".MJShowDownCards")
local MJShowDownCardsManager        = import(".MJShowDownCardsManager")
local MJGameSelfInfo                = import(".MJGameSelfInfo")
local MJGameResultPanel             = import(".MJGameResultPanel")

local windowSize = cc.Director:getInstance():getWinSize()

function MJGameScene:ctor(app, name, param)
    self._resultLayer               = nil
    self._resultPanel               = nil

    self._MJGameDice                = nil

    self._MJHandCardsManager        = nil
    self._MJThrownCardsManager      = nil
    self._MJCastoffCardsManager     = nil
    self._MJPGCCardsManager         = nil
    self._MJChoseCardsManager       = nil
    self._MJShowDownCardsManager    = nil

    self._PGCHManager               = nil

    MJGameScene.super.ctor(self, app, name, param)
end

function MJGameScene:init()
    MJGameScene.super.init(self)
end

function MJGameScene:setControllerDelegate()
    if not MJGameController then printError("MJGameController is nil!!!") return end
    self._gameController = MJGameController
end

function MJGameScene:setClock()
    if not self._gameNode then return end

    local clockPanel = self._gameNode:getChildByName("Panel_Clock")
    if clockPanel then
        self._clock = MJGameClock:create(clockPanel, self._gameController)
    end
end

function MJGameScene:setPlayers()
    if not self._gameNode then return end
    if not self._gameController then return end

    local players = {}
    for i = 1, self._gameController:getTableChairCount() do
        local playerPanel = self._gameNode:getChildByName("Panel_Player" .. tostring(i))
        if playerPanel then
            players[i] = MJGamePlayer:create(playerPanel, i, self._gameController)
        end
    end

    self._playerManager = MJGamePlayerManager:create(players, self._gameController)
end

function MJGameScene:setGameInfo()
    if not self._gameNode then return end

    local gameInfo = self._gameNode:getChildByName("Panel_GameInfo")
    if gameInfo then
        self._gameInfo = MJGameGameInfo:create(gameInfo, self._gameController)
    end
end

function MJGameScene:setTools()
    if not self._gameNode then return end

    local toolsPanel = self._gameNode:getChildByName("Panel_Tools")
    if toolsPanel then
        self._tools = BaseGameTools:create(toolsPanel, false, self._gameController)
    end
end

function MJGameScene:setSelfInfo()
    if not self._gameNode then return end

    local selfInfoPanel = self._gameNode:getChildByName("Panel_SelfInfo")
    if selfInfoPanel then
        self._selfInfo = MJGameSelfInfo:create(selfInfoPanel)
    end
end

function MJGameScene:setGameCtrlsAboveBaseGame()
    self:setMJCards()
    self:setPGCH()

    self:setGameCtrlsAboveMJGame()
end

function MJGameScene:setMJCards()
    self:setHandCards()
    self:setThrownCards()
    self:setCastoffCards()
    self:setPGCCards()
    self:setChoseCards()
    self:setShowDownCards()
end

function MJGameScene:setHandCards()
    if not self._gameNode then return end

    local handCards = {}
    for i = 1, self._gameController:getTableChairCount() do
        local handCardsPanel = self._gameNode:getChildByName("Panel_HandCards" .. tostring(i))
        if handCardsPanel then
            handCards[i] = MJHandCards:create(handCardsPanel, i, self._gameController)
        end
    end

    self._MJHandCardsManager = MJHandCardsManager:create(handCards, self._gameController)
end

function MJGameScene:setThrownCards()
    if not self._gameNode then return end

    local thrownCardsPanel = self._gameNode:getChildByName("Panel_ThrowCards")
    if thrownCardsPanel then
        self._MJThrownCardsManager = MJThrownCardsManager:create(thrownCardsPanel, self._gameController)
    end
end

function MJGameScene:setCastoffCards()
    if not self._gameNode then return end

    local castoffCards = {}
    for i = 1, self._gameController:getTableChairCount() do
        local castoffCardsPanel = self._gameNode:getChildByName("Panel_CastoffCards" .. tostring(i))
        if castoffCardsPanel then
            castoffCards[i] = MJCastoffCards:create(castoffCardsPanel, i, self._gameController)
        end
    end

    self._MJCastoffCardsManager = MJCastoffCardsManager:create(castoffCards, self._gameController)
end

function MJGameScene:setPGCCards()
    if not self._gameNode then return end

    local PGCCards = {}
    for i = 1, self._gameController:getTableChairCount() do
        local PGCCardsPanel = self._gameNode:getChildByName("Panel_PGCCards" .. tostring(i))
        if PGCCardsPanel then
            PGCCards[i] = MJPGCCards:create(PGCCardsPanel, i, self._gameController)
        end
    end

    self._MJPGCCardsManager = MJPGCCardsManager:create(PGCCards, self._gameController)
end

function MJGameScene:setPGCH()
    if not self._gameNode then return end

    local PGCHPanel = self._gameNode:getChildByName("Panel_PGCH")
    if PGCHPanel then
        self._MJPGCHManager = MJPGCHManager:create(PGCHPanel, self._gameController)
    end
end

function MJGameScene:setChoseCards()
    if not self._gameNode then return end

    local choseCardsPanel = self._gameNode:getChildByName("Panel_ChoseCards")
    if choseCardsPanel then
        self._MJChoseCardsManager = MJChoseCardsManager:create(choseCardsPanel, self._gameController)
    end
end

function MJGameScene:setShowDownCards()
    if not self._gameNode then return end

    local showDownCards = {}
    for i = 1, self._gameController:getTableChairCount() do
        local showDownCardsPanel = self._gameNode:getChildByName("Panel_ShowDownCards" .. tostring(i))
        if showDownCardsPanel then
            showDownCards[i] = MJShowDownCards:create(showDownCardsPanel, i, self._gameController)
        end
    end

    self._MJShowDownCardsManager = MJShowDownCardsManager:create(showDownCards, self._gameController)
end

function MJGameScene:setGameCtrlsAboveMJGame() end

function MJGameScene:ope_ThrowDices(dicesPoint)
    self._MJGameDice = MJGameDice:create(dicesPoint, self._gameNode, self._gameController)
    if self._MJGameDice then
        self._MJGameDice:throwDices()
    end
end

function MJGameScene:cleanDices()
    if self._MJGameDice then
        self._MJGameDice:resetDices()
        self._MJGameDice = nil
    end
end

function MJGameScene:createResultLayer(gameWin)
    self._resultLayer = CanvasLayer:create(cc.c4b(0, 0, 0, 127), windowSize.width, windowSize.height)
    if self._resultLayer then
        self:addChild(self._resultLayer, 100)
        self:addResultNode(gameWin)
    end
end

function MJGameScene:addResultNode(gameWin)
    if not self._resultLayer then return end

    self._resultNode = MJGameResultPanel:create(gameWin, self._gameController)
    if self._resultNode then
        self._resultLayer:addChild(self._resultNode)
        self._resultNode:setPosition(cc.p(windowSize.width / 2, windowSize.height / 2))
    end
end

function MJGameScene:showResultLayer(gameWin)
    self:closeResultLayer()

    local resultLayer = self:getResultLayer()
    if not resultLayer then
        self:createResultLayer(gameWin)
    end
end

function MJGameScene:closeResultLayer()
    if self._resultLayer then
        self._resultLayer:removeSelf()
        self._resultLayer = nil
    end
end

function MJGameScene:getMJGameDices()               return self._MJGameDice                 end
function MJGameScene:getMJHandCardsManager()        return self._MJHandCardsManager         end
function MJGameScene:getMJThrownCardsManager()      return self._MJThrownCardsManager       end
function MJGameScene:getMJCastoffCardsManager()     return self._MJCastoffCardsManager      end
function MJGameScene:getMJPGCCardsManager()         return self._MJPGCCardsManager          end
function MJGameScene:getMJPGCHManager()             return self._MJPGCHManager              end
function MJGameScene:getMJChoseCardsManager()       return self._MJChoseCardsManager        end
function MJGameScene:getMJShowDownCardsManager()    return self._MJShowDownCardsManager     end
function MJGameScene:getResultLayer()               return self._resultLayer                end

return MJGameScene
