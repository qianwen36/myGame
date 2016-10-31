
local MJGameInfo = import("src.app.Game.mMJGame.MJGameInfo")
local MyGameInfo = class("MyGameInfo", MJGameInfo)

function MyGameInfo:ctor(gameInfo, gameController)
    self._quanInfo          = nil
    self._lianzhuang        = false

    MyGameInfo.super.ctor(self, gameInfo, gameController)
end

function MyGameInfo:init()
    if not self._gameInfo then return end

    self._quanInfo = self._gameInfo:getChildByName("gemeinfo_quan")
    self._lianzhuang = self._gameInfo:getChildByName("gameinfo_lian")

    MyGameInfo.super.init(self)
end

function MyGameInfo:setQuan(quanInfo)
    if self._quanInfo then
        self._quanInfo:setVisible(true)
        self._quanInfo:setString(quanInfo)
    end
end

function MyGameInfo:setLian(bLian)
    if self._lianzhuang then
        self._lianzhuang:setVisible(bLian)
    end
end

function MyGameInfo:ope_ShowGameInfo(bShow)
    if bShow then
        local quan = self._gameController:getQuan()
        local index = math.modf(quan % self._gameController:getTableChairCount(), 1)
        local feng = math.modf(math.modf(quan / self._gameController:getTableChairCount(), 1) % 4, 1)

        local quanInfo = self._gameController:getGameStringByKey("G_FENG_" .. tostring(feng)) ..
            self._gameController:getGameStringByKey("G_QUAN_" .. tostring(index)) ..
            self._gameController:getGameStringByKey("G_ROUND")
        local utf8QuanInfo = MCCharset:getInstance():gb2Utf8String(quanInfo, string.len(quanInfo))
        self:setQuan(utf8QuanInfo)

        local bLian = self._gameController:isLian()
        self:setLian(bLian)

        if self._gameController:getBanker() == self._gameController:getMyChairNO() then
            if self._feng[1] then
                local resFrame = self:getSpriteFrame("res/GameCocosStudio/game/gameinfo/gameinfo_sp_east.png")
                if resFrame then
                    self._feng[1]:setSpriteFrame(resFrame)
                    self._feng[1]:setVisible(true)
                end
            end
            if self._feng[2] then
                local resFrame = self:getSpriteFrame("res/GameCocosStudio/game/gameinfo/gameinfo_sp_west.png")
                if resFrame then
                    self._feng[2]:setSpriteFrame(resFrame)
                    self._feng[2]:setVisible(true)
                end
            end
        else
            if self._feng[2] then
                local resFrame = self:getSpriteFrame("res/GameCocosStudio/game/gameinfo/gameinfo_sp_east.png")
                if resFrame then
                    self._feng[2]:setSpriteFrame(resFrame)
                    self._feng[2]:setVisible(true)
                end
            end
            if self._feng[1] then
                local resFrame = self:getSpriteFrame("res/GameCocosStudio/game/gameinfo/gameinfo_sp_west.png")
                if resFrame then
                    self._feng[1]:setSpriteFrame(resFrame)
                    self._feng[1]:setVisible(true)
                end
            end
        end
    end

    MyGameInfo.super.ope_ShowGameInfo(self, bShow)
end

function MyGameInfo:getSpriteFrame(resName)
    local resSprite = cc.Sprite:create(resName)
    if resSprite then
        local rect = cc.rect(0, 0, resSprite:getContentSize().width, resSprite:getContentSize().height)
        local resFrame = cc.SpriteFrame:create(resName, rect)
        if resFrame then
            return resFrame
        end
    end
    return nil
end

return MyGameInfo
