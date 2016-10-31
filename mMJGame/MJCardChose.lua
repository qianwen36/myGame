
local MJCardBase = import("src.app.Game.mMJGame.MJCardBase")
local MJCardChose = class("MJCardChose", MJCardBase)

function MJCardChose:ctor(MJCardNode, drawIndex, cardDelegate)    
    self._MJMask                = nil
    self._bMask                 = false

    MJCardChose.super.ctor(self, MJCardNode, drawIndex, cardDelegate)
end

function MJCardChose:init()

    MJCardChose.super.init(self)
    
    self._MJMask        = self._MJCardSprite:getChildByName("mask")
    self:setMask(false)
end
   
function MJCardChose:setMask(bMask)
    self._bMask = bMask
    if self._MJMask then
        self._MJMask:setVisible(bMask)
    end
end

function MJCardChose:getCardResName(resIndex)
    return     "res/GameCocosStudio/game/card/images/" .. self._resIndex.. ".png"
end

return MJCardChose
