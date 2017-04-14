
local BaseGamePlayer = import("..mBaseGame.BaseGamePlayer")
local MJGamePlayer = class("MJGamePlayer", BaseGamePlayer)

function MJGamePlayer:ctor(playerPanel, drawIndex, gameController)
    self._playerFlower              = nil
    self._playerFlowerNum           = nil
    self._playerBanker              = nil

    self._playerSourcePos           = nil
    self._playerDestPos             = nil

    self._playerFlowerCount         = 0

    MJGamePlayer.super.ctor(self, playerPanel, drawIndex, gameController)
end

function MJGamePlayer:init()
    if self._playerPanel then
        self._playerFlower          = self._playerPanel:getChildByName("Player_sp_flower")
        self._playerFlowerNum       = self._playerPanel:getChildByName("Player_num_flower")
        self._playerBanker          = self._playerPanel:getChildByName("Player_sp_banker")
    end

    self:initPlayerPos()

    MJGamePlayer.super.init(self)
end

function MJGamePlayer:initPlayerPos()
    if self._playerPanel then
        self._playerSourcePos = cc.p(self._playerPanel:getPositionX(), self._playerPanel:getPositionY())
        local destPosPanel = self._playerPanel:getChildByName("Player_destpospanel")
        if destPosPanel then
            self._playerDestPos = cc.p(self._playerPanel:getPositionX() + destPosPanel:getPositionX(),
                self._playerPanel:getPositionY() + destPosPanel:getPositionY())
        end
    end
end

function MJGamePlayer:addPlayerFlower()
    self:setPlayerFlower(self._playerFlowerCount + 1)
end

function MJGamePlayer:setPlayerFlower(nFlower)
    if "number" ~= type(nFlower) then return end

    self._playerFlowerCount = nFlower

    if 0 < nFlower then
        if self._playerFlowerNum then
            self._playerFlowerNum:setVisible(true)
            self._playerFlowerNum:setString(tostring(nFlower))
        end
        if self._playerFlower then
            self._playerFlower:setVisible(true)
        end
    else
        if self._playerFlowerNum then
            self._playerFlowerNum:setVisible(false)
        end
        if self._playerFlower then
            self._playerFlower:setVisible(false)
        end
    end
end

function MJGamePlayer:showBanker(bBanker)
    if self._playerBanker then
        self._playerBanker:setVisible(bBanker)
    end
end

function MJGamePlayer:hidePlayerInfo()
    self:hideUserName()
    --self:hideMoney()
end

function MJGamePlayer:ope_MovePlayer(duration)
    if not self._playerPanel then return end

    if self._playerDestPos then
        local dealAction = cc.MoveTo:create(duration, self._playerDestPos)
        if dealAction then
            self._playerPanel:runAction(cc.Sequence:create(dealAction, cc.CallFunc:create(function()
                self:onMovePlayerCallback()
            end)))
        end
    else
        self._playerPanel:setVisible(false)
        self:onMovePlayerCallback()
    end
end

function MJGamePlayer:onMovePlayerCallback()
    
end

function MJGamePlayer:ope_MovePlayerImmediately()
    if not self._playerPanel then return end

    if self._playerDestPos then
        self._playerPanel:setPosition(self._playerDestPos)
    else
        self._playerPanel:setVisible(false)
    end
end

return MJGamePlayer
