
local BaseGamePlayerManager = import("..mBaseGame.BaseGamePlayerManager")
local MJGamePlayerManager = class("MJGamePlayerManager", BaseGamePlayerManager)

function MJGamePlayerManager:ctor(players, gameController)
    MJGamePlayerManager.super.ctor(self, players, gameController)
end

function MJGamePlayerManager:addPlayerFlower(drawIndex)
    if self._players[drawIndex] then
        self._players[drawIndex]:addPlayerFlower()
    end
end

function MJGamePlayerManager:setPlayerFlower(drawIndex, count)
    if self._players[drawIndex] then
        self._players[drawIndex]:setPlayerFlower(count)
    end
end

function MJGamePlayerManager:showBanker(drawIndex)
    if self._players[drawIndex] then
        self._players[drawIndex]:showBanker(true)
    end
end

function MJGamePlayerManager:clearBanker()
    for i = 1, self._gameController:getTableChairCount() do
        if self._players[i] then
            self._players[i]:showBanker(false)
        end
    end
end

function MJGamePlayerManager:hidePlayerInfo()
    for i = 1, self._gameController:getTableChairCount() do
        if self._players[i] then
            self._players[i]:hidePlayerInfo()
        end
    end
end

function MJGamePlayerManager:ope_MovePlayer(duration)
    for i = 1, self._gameController:getTableChairCount() do
        if self._players[i] then
            self._players[i]:ope_MovePlayer(duration)
        end
    end
end

function MJGamePlayerManager:ope_MovePlayerImmediately()
    for i = 1, self._gameController:getTableChairCount() do
        if self._players[i] then
            self._players[i]:ope_MovePlayerImmediately()
        end
    end
end

return MJGamePlayerManager
