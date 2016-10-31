
local BaseGameLoadingPanel = class("BaseGameLoadingPanel", ccui.Layout)

function BaseGameLoadingPanel:ctor(gameController)
    self._gameController        = gameController

    self._loadingPanel          = nil
    self._bLoading              = false
    self._bEnterRoomOK          = false

    if self.onCreate then self:onCreate() end
end

function BaseGameLoadingPanel:onCreate()
    self:init()
end

function BaseGameLoadingPanel:init()
    self:initLoadingPanel()
    self:initLoadingTimer()
end

function BaseGameLoadingPanel:initLoadingPanel()
    local csbPath = "res/GameCocosStudio/loading/LoadingNode.csb"
    self._loadingPanel = cc.CSLoader:createNode(csbPath)
    if self._loadingPanel then
        self:addChild(self._loadingPanel)
        local action = cc.CSLoader:createTimeline(csbPath)
        if action then
            self._loadingPanel:runAction(action)
            action:gotoFrameAndPlay(0, 60, true)
        end
    end
end

function BaseGameLoadingPanel:initLoadingTimer()
    local function onLoadingInterval(dt)
        self:onLoadingInterval()
    end
    self.loadingTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onLoadingInterval, 1.0, false)
    self._bLoading = true
end

function BaseGameLoadingPanel:onLoadingInterval()
    self._bLoading = false
    if self.loadingTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.loadingTimerID)
        self.loadingTimerID = nil
    end

    if self._bEnterRoomOK then
        if self._gameController then
            self._gameController:onRemoveLoadingLayer()
        end
    else
        local function onLoadingTimeout(dt)
            self:onLoadingTimeout()
        end
        self.loadingTimeoutTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onLoadingTimeout, 5.0, false)
    end
end

function BaseGameLoadingPanel:onLoadingTimeout()
    if self.loadingTimeoutTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.loadingTimeoutTimerID)
        self.loadingTimeoutTimerID = nil
    end

    if self._gameController then
        self._gameController:onLeaveGameOK()
    end
end

function BaseGameLoadingPanel:onEnterGameOK()
    self._bEnterRoomOK = true

    --if not self._bLoading then
        if self._gameController then
            self._gameController:onRemoveLoadingLayer()
        end
    --end
end

function BaseGameLoadingPanel:stopLoadingTimer()
    if self.loadingTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.loadingTimerID)
        self.loadingTimerID = nil
    end
    if self.loadingTimeoutTimerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.loadingTimeoutTimerID)
        self.loadingTimeoutTimerID = nil
    end
end

function BaseGameLoadingPanel:finishLoading()
    self:setVisible(false)

    self:stopLoadingTimer()
end

function BaseGameLoadingPanel:onGameExit()
    self:stopLoadingTimer()
end

return BaseGameLoadingPanel
