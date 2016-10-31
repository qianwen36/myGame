
local MJPGCHManager = import("src.app.Game.mMJGame.MJPGCHManager")
local MyPGCHManager = class("MyPGCHManager", MJPGCHManager)

local MJGameDef                 = import("src.app.Game.mMJGame.MJGameDef")
local MyGameDef                 = import("src.app.Game.mMyGame.MyGameDef")

local MY_PGCH_FLAG              = {MJGameDef.MJ_PENG, MJGameDef.MJ_GANG, MJGameDef.MJ_CHI, MJGameDef.MJ_HU, MJGameDef.MJ_GUO}
local MY_PGCH_SORT              = {MJGameDef.MJ_PGCH_GANG, MJGameDef.MJ_PGCH_PENG, MJGameDef.MJ_PGCH_CHI, MJGameDef.MJ_PGCH_GUO}

function MyPGCHManager:ctor(PGCHPanel, gameController)
    self._bDouble               = false

    MyPGCHManager.super.ctor(self, PGCHPanel, gameController)
end

function MyPGCHManager:setPGCHBtns()
    if self._PGCHPanel then
        local function onDouble()
            self:onDouble()
        end
        local buttonDouble = self._PGCHPanel:getChildByName("Button_double")
        if buttonDouble then
            buttonDouble:addClickEventListener(onDouble)

            self._PGCHBtns[MyGameDef.MY_PGCH_DOUBLE] = buttonDouble
            self._btnpos[MyGameDef.MY_PGCH_DOUBLE] = cc.p(buttonDouble:getPositionX(), buttonDouble:getPositionY())
        end
    end

    MyPGCHManager.super.setPGCHBtns(self)
end

function MyPGCHManager:needWaitHu(flags, drawIndex)
    for i = 1, self._gameController:getTableChairCount() do
        if drawIndex ~= self._gameController:rul_GetDrawIndexByChairNO(i) and drawIndex ~= self._gameController:getMyDrawIndex() then
            if MJGameDef.MJ_HU == flags[i] then
                return true
            end
        end
    end
    return false
end

function MyPGCHManager:onDouble()
    self._gameController:playBtnPressedEffect()
    self._gameController:onDouble()
end

function MyPGCHManager:showPGCHBtns()
    if not self._cardsThrow then return false end

    if not self._bDouble and self:canHu(self._cardsThrow.dwFlags[self._gameController:getMyChairNO() + 1]) then
        self:ope_showHuBtn()
    else
        local myChairNO = self._gameController:getMyChairNO()
        local count = 0
        for i = 1, #MY_PGCH_FLAG do
            if self._gameController:IS_BIT_SET(self._cardsThrow.dwFlags[myChairNO + 1], MY_PGCH_FLAG[i]) then
                if self._PGCHBtns[i] and i ~= MJGameDef.MJ_PGCH_HU then
                    self._PGCHBtns[i]:setVisible(true)
                    count = count + 1
                end
            end
        end

        if 1 == count and self._PGCHBtns[MJGameDef.MJ_PGCH_GUO] and self._PGCHBtns[MJGameDef.MJ_PGCH_GUO]:isVisible() then
            self._gameController:onGuo()
        end
    end

    self:adjustPGCHBtnPos()
end

function MyPGCHManager:canHu(flags)
    return self._gameController:IS_BIT_SET(flags, MJGameDef.MJ_HU)
end

function MyPGCHManager:adjustPGCHBtnPos()
    local sortIndex = 1
    for i = 1, #MY_PGCH_SORT do
        local sortBtn = self._PGCHBtns[MY_PGCH_SORT[i]]
        if sortBtn and sortBtn:isVisible() then
            if self._btnpos[MY_PGCH_SORT[sortIndex]] then
                sortBtn:setPosition(self._btnpos[MY_PGCH_SORT[sortIndex]])
                sortIndex = sortIndex + 1
            end
        end
    end
end

function MyPGCHManager:hidePGCHBtns()
    for i = 1, 6 do
        if self._PGCHBtns[i] then
            self._PGCHBtns[i]:setVisible(false)
        end
    end
end

function MyPGCHManager:ope_showHuBtn()
    self:hidePGCHBtns()
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_HU)
    self:ope_EnableOperate(MyGameDef.MY_PGCH_DOUBLE)
end

function MyPGCHManager:ope_showGangBtn()
    self:hidePGCHBtns()
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_GANG)
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_GUO)
    self:adjustPGCHBtnPos()
end

function MyPGCHManager:ope_showGuoBtn()
    self:hidePGCHBtns()
    self:ope_EnableOperate(MJGameDef.MJ_PGCH_GUO)
    self:adjustPGCHBtnPos()
end

function MyPGCHManager:setDouble(bDouble)
    self._bDouble = bDouble
end

return MyPGCHManager
