
local MJGameDice = class("MJGameDice")

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")

local windowSize = cc.Director:getInstance():getWinSize()

function MJGameDice:create(dicePoints, parentPanel, gameController)
    return MJGameDice.new(dicePoints, parentPanel, gameController)
end

function MJGameDice:ctor(dicePoints, parentPanel, gameController)
    self._gameController        = gameController

    self._dicePoints            = dicePoints
    self._parentPanel           = parentPanel
    self._position              = {}
    self._dices                 = {}
end

function MJGameDice:throwDices()
    if not self._parentPanel then return end
    if #self._dicePoints ~= 2 and #self._dicePoints ~= 4 then return end

    local duration = 0.5

    for i = 1, 2 do
        local dice = cc.Sprite:create()
        self._parentPanel:addChild(dice)
        dice:setPosition(cc.p(windowSize.width / 2 - 150 + i * 100, windowSize.height / 2))

        self._dices[i] = dice

        local animation = cc.Animation:create()
        for j = 1, MJGameDef.MJ_DICES_FRAME_COUNT do
            local path = "res/Game/GamePic/dice/dice" .. self._dicePoints[i] .."_0" .. tostring(i-1) .. "/" .. j .. ".png"
            animation:addSpriteFrameWithFile("res/Game/GamePic/dice/dice" .. self._dicePoints[i] .."_0" .. tostring(i-1) .. "/" .. j .. ".png")
        end
        animation:setDelayPerUnit(duration / MJGameDef.MJ_DICES_FRAME_COUNT)
        --animation:setRestoreOriginalFrame(true)

        local action = cc.Animate:create(animation)
        dice:runAction(cc.Sequence:create(action, cc.DelayTime:create(1.0), cc.CallFunc:create(function()
            if 2 == i then
                self:throwDicesCallback()
            end
        end)))
    end
end

function MJGameDice:throwDicesCallback()
    if self._gameController then
        self._gameController:onThrowDicesFinished()
    end
end

function MJGameDice:resetDices()
    for i = 1, 4 do
        if self._dices[i] then
            self._dices[i]:stopAllActions()
            self._dices[i]:removeFromParent()
        end
    end
end

return MJGameDice
