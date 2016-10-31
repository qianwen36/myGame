
local BaseGameInfo = import("src.app.Game.mBaseGame.BaseGameInfo")
local MJGameInfo = class("MJGameInfo", BaseGameInfo)

function MJGameInfo:ctor(gameInfo, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._lastCardsWord     = nil
    self._lastCards         = nil
    self._feng              = {}

    self._lastCount         = 0

    MJGameInfo.super.ctor(self, gameInfo, gameController)
end

function MJGameInfo:init()
    if not self._gameInfo then return end

    self._lastCardsWord = self._gameInfo:getChildByName("gameinfo_lastcards_word")
    self._lastCards = self._gameInfo:getChildByName("gameinfo_lasecards")
    for i = 1, self._gameController:getTableChairCount() do
        self._feng[i] = self._gameInfo:getChildByName("gameinfo_sp_feng" .. tostring(i))
    end

    MJGameInfo.super.init(self)
end

function MJGameInfo:onGameStart()
    self._lastCount = self._gameController:getMJTotalCards() - (self._gameController:getTableChairCount() * (self._gameController:getChairCardsCount() - 1) + 1)
end

function MJGameInfo:setLastCards(lastCardsCount)
    if "number" ~= type(lastCardsCount) then return end

    if self._lastCards then
        self._lastCards:setVisible(true)
        self._lastCards:setString(lastCardsCount)
    end

    if self._lastCardsWord then
        self._lastCardsWord:setVisible(true)
    end
end

function MJGameInfo:ope_ShowGameInfo(bShow)
    if bShow then
        local baseScore = ""
        if self._gameController:isNeedDeposit() then
            local deposit = self._gameController:getBaseDeposit()
            local msg = string.format(self._gameController:getGameStringByKey("G_DEPOSIT"), deposit)
            baseScore = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
        else
            local score = self._gameController:getBaseScore()
            local msg = string.format(self._gameController:getGameStringByKey("G_SCORE"), score)
            baseScore = MCCharset:getInstance():gb2Utf8String(msg, string.len(msg))
        end

        self:setBaseScore(baseScore)

        self:setLastCards(self._lastCount)
    end

    MJGameInfo.super.ope_ShowGameInfo(self, bShow)
end

function MJGameInfo:onCatchOneCard()
    --self:setLastCardsCount(math.max(self._lastCount - 1, 0))
    --self:updateLastCardsCount()
end

function MJGameInfo:setLastCardsCount(count)
    self._lastCount = count
end

function MJGameInfo:getLastCardsCount()
    return self._lastCount
end

function MJGameInfo:updateLastCardsCount()
    self:setLastCards(self._lastCount)
end

return MJGameInfo
