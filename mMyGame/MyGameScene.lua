
local Base = import("..mMJGame.MJGameScene")
local MyGameScene = class("MyGameScene", Base)


local MyGameController              = import(".MyGameController")

local MyGameClock                   = import(".MyGameClock")
local MyGameInfo                    = import(".MyGameInfo")
local MyPGCCards                    = import(".MyPGCCards")
local MJPGCCardsManager             = import("..mMJGame.MJPGCCardsManager")
local MyCastoffCards                = import(".MyCastoffCards")
local MJCastoffCardsManager         = import("..mMJGame.MJCastoffCardsManager")
local MyShowDownCards               = import(".MyShowDownCards")
local MJShowDownCardsManager        = import("..mMJGame.MJShowDownCardsManager")
local MyResultPanel                 = import(".MyResultPanel")
local MyPGCHManager                 = import(".MyPGCHManager")

function MyGameScene:ctor(app, name, param)
    print("Hello Game!")

    self._resutPanel                = nil

    Base.ctor(self, app, name, param)
end

function MyGameScene:setControllerDelegate()
    self._gameController = MyGameController
end

function MyGameScene:setClock()
    if not self._gameNode then return end

    local clockPanel = self._gameNode:getChildByName("Panel_Clock")
    if clockPanel then
        self._clock = MyGameClock:create(clockPanel, self._gameController)
    end
end

function MyGameScene:setGameInfo()
    if not self._gameNode then return end

    local gameInfo = self._gameNode:getChildByName("Panel_GameInfo")
    if gameInfo then
        self._gameInfo = MyGameInfo:create(gameInfo, self._gameController)
    end
end

function MyGameScene:setPGCCards()
    if not self._gameNode then return end

    local PGCCards = {}
    for i = 1, self._gameController:getTableChairCount() do
        local PGCCardsPanel = self._gameNode:getChildByName("Panel_PGCCards" .. tostring(i))
        if PGCCardsPanel then
            PGCCards[i] = MyPGCCards:create(PGCCardsPanel, i, self._gameController)
        end
    end

    self._MJPGCCardsManager = MJPGCCardsManager:create(PGCCards, self._gameController)
end

function MJGameScene:setPGCH()
    if not self._gameNode then return end

    local PGCHPanel = self._gameNode:getChildByName("Panel_PGCH")
    if PGCHPanel then
        self._MJPGCHManager = MyPGCHManager:create(PGCHPanel, self._gameController)
    end
end

function MyGameScene:setCastoffCards()
    if not self._gameNode then return end

    local castoffCards = {}
    for i = 1, self._gameController:getTableChairCount() do
        local castoffCardsPanel = self._gameNode:getChildByName("Panel_CastoffCards" .. tostring(i))
        if castoffCardsPanel then
            castoffCards[i] = MyCastoffCards:create(castoffCardsPanel, i, self._gameController)
        end
    end

    self._MJCastoffCardsManager = MJCastoffCardsManager:create(castoffCards, self._gameController)
end

function MyGameScene:setShowDownCards()
    if not self._gameNode then return end

    local showDownCards = {}
    for i = 1, self._gameController:getTableChairCount() do
        local showDownCardsPanel = self._gameNode:getChildByName("Panel_ShowDownCards" .. tostring(i))
        if showDownCardsPanel then
            showDownCards[i] = MyShowDownCards:create(showDownCardsPanel, i, self._gameController)
        end
    end

    self._MJShowDownCardsManager = MJShowDownCardsManager:create(showDownCards, self._gameController)
end

function MyGameScene:setGameCtrlsAboveMJGame()
    self:setResultPanel()
end

function MyGameScene:setResultPanel()
    if not self._gameNode then return end

    local resutPanel = self._gameNode:getChildByName("Panel_Result")
    if resutPanel then
        self._resutPanel = MyResultPanel:create(resutPanel, self._gameController)
    end
end

function MyGameScene:getResultPanel()           return self._resutPanel         end

return MyGameScene
