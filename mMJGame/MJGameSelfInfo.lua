
local BaseGameSelfInfo = import("src.app.Game.mBaseGame.BaseGameSelfInfo")
local MJGameSelfInfo = class("MJGameSelfInfo", BaseGameSelfInfo)

function MJGameSelfInfo:ctor(selfInfoPanel)
    self._selfInfoFlower        = nil
    self._selfInfoFlowerNum     = nil

    self._selfInfoFlowerCount   = 0

    MJGameSelfInfo.super.ctor(self, selfInfoPanel)
end

function MJGameSelfInfo:init()
    self._selfInfoFlower = self._selfInfoPanel:getChildByName("SelfInfo_sp_flower")
    self._selfInfoFlowerNum = self._selfInfoPanel:getChildByName("SelfInfo_num_flower")

    MJGameSelfInfo.super.init(self)
end

function MJGameSelfInfo:addSelfFlower()
    self:setSelfFlower(self._selfInfoFlowerCount + 1)
end

function MJGameSelfInfo:setSelfFlower(nFlower)
    if "number" ~= type(nFlower) then return end

    self._selfInfoFlowerCount = nFlower

    if 0 < nFlower then
        if self._selfInfoFlowerNum then
            self._selfInfoFlowerNum:setVisible(true)
            self._selfInfoFlowerNum:setString(tostring(nFlower))
        end
        if self._selfInfoFlower then
            self._selfInfoFlower:setVisible(true)
        end
    else
        if self._selfInfoFlowerNum then
            self._selfInfoFlowerNum:setVisible(false)
        end
        if self._selfInfoFlower then
            self._selfInfoFlower:setVisible(false)
        end
    end
end

return MJGameSelfInfo
