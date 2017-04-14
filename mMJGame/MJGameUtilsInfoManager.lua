
local BaseGameUtilsInfoManager = import("..mBaseGame.BaseGameUtilsInfoManager")
local MJGameUtilsInfoManager = class("BaseGameUtilsInfoManager", BaseGameUtilsInfoManager)

function MJGameUtilsInfoManager:ctor()
    self._utilsStartData                = nil
    self._utilsPlayInfo                 = {}
    self._utilsTableInfo                = nil
    self._utilsWinData                  = nil

    MJGameUtilsInfoManager.super.ctor(self)
end

function MJGameUtilsInfoManager:getBaseScore()      if self._utilsStartData then return self._utilsStartData.nBaseScore         end end
function MJGameUtilsInfoManager:getBaseDeposit()    if self._utilsStartData then return self._utilsStartData.nBaseDeposit       end end
function MJGameUtilsInfoManager:getBoutCount()      if self._utilsStartData then return self._utilsStartData.nBoutCount         end end
function MJGameUtilsInfoManager:getCurrentCatch()   if self._utilsStartData then return self._utilsStartData.nCurrentCatch      end end
function MJGameUtilsInfoManager:getCurrentChair()   if self._utilsStartData then return self._utilsStartData.nCurrentChair      end end
function MJGameUtilsInfoManager:getStatus()         if self._utilsStartData then return self._utilsStartData.dwStatus           end end
function MJGameUtilsInfoManager:getCurrentFlags()   if self._utilsStartData then return self._utilsStartData.dwCurrentFlags     end end
function MJGameUtilsInfoManager:getThrowWait()      if self._utilsStartData then return self._utilsStartData.nThrowWait         end end
function MJGameUtilsInfoManager:getDices()          if self._utilsStartData then return self._utilsStartData.nDices             end end
function MJGameUtilsInfoManager:isAllowChi()        if self._utilsStartData then return self._utilsStartData.bAllowChi == 1     end end
function MJGameUtilsInfoManager:isAnGangShow()      if self._utilsStartData then return self._utilsStartData.bAnGangShow == 1   end end
function MJGameUtilsInfoManager:getCardsCount()     if self._utilsStartData then return self._utilsStartData.nCardsCount        end end
function MJGameUtilsInfoManager:getChairCards()     if self._utilsStartData then return self._utilsStartData.nChairCards        end end
function MJGameUtilsInfoManager:getHuaCards()       if self._utilsStartData then return self._utilsStartData.nHuaCards          end end
function MJGameUtilsInfoManager:getHuaCount()       if self._utilsStartData then return self._utilsStartData.nHuaCount          end end
function MJGameUtilsInfoManager:getPGCHWait()       if self._utilsStartData then return self._utilsStartData.nPGCHWait          end end
function MJGameUtilsInfoManager:getBeginNO()        if self._utilsStartData then return self._utilsStartData.nBeginNO           end end
function MJGameUtilsInfoManager:getJokerNO()        if self._utilsStartData then return self._utilsStartData.nJokerNO           end end
function MJGameUtilsInfoManager:getJokerID()        if self._utilsStartData then return self._utilsStartData.nJokerID           end end
function MJGameUtilsInfoManager:getJokerID2()       if self._utilsStartData then return self._utilsStartData.nJokerID2          end end
function MJGameUtilsInfoManager:getFanPaiID()       if self._utilsStartData then return self._utilsStartData.nFanID             end end
function MJGameUtilsInfoManager:getTailTaken()      if self._utilsStartData then return self._utilsStartData.nTailTaken         end end
function MJGameUtilsInfoManager:getBanker()         if self._utilsStartData then return self._utilsStartData.nBanker            end end
function MJGameUtilsInfoManager:getHuChair()        if self._utilsStartData then return self._utilsStartData.nHuChair           end end
function MJGameUtilsInfoManager:isQuickCatch()      if self._utilsStartData then return self._utilsStartData.bQuickCatch == 1   end end
function MJGameUtilsInfoManager:isFanJoker()        if self._utilsStartData then return self._utilsStartData.nFanID ~= -1       end end
function MJGameUtilsInfoManager:isJokerSortIn()     if self._utilsStartData then return self._utilsStartData.bJokerSortIn == 1  end end
function MJGameUtilsInfoManager:isBaibanNoSort()    if self._utilsStartData then return self._utilsStartData.bBaibanNoSort == 1 end end

function MJGameUtilsInfoManager:setStartInfo(gameStart)
    self._utilsStartData = gameStart
end

function MJGameUtilsInfoManager:getStartInfo()
    return self._utilsStartData
end

function MJGameUtilsInfoManager:setTableInfo(tableInfo)
    self._utilsTableInfo = tableInfo
end

function MJGameUtilsInfoManager:setStartInfoFromTableInfo(tableInfo)
    self._utilsStartData.nChairCards = tableInfo.nChairCards
    self._utilsStartData.nCardsCount = tableInfo.nCardsCount
    self._utilsStartData.nHuaCount = tableInfo.nHuaCount
end

function MJGameUtilsInfoManager:setPlayInfo(playInfo)
    local nPengCards = {
        {
            {playInfo.nPengCardIDs11, playInfo.nPengCardChair11, playInfo.nPengReserved11},
            {playInfo.nPengCardIDs12, playInfo.nPengCardChair12, playInfo.nPengReserved12},
            {playInfo.nPengCardIDs13, playInfo.nPengCardChair13, playInfo.nPengReserved13},
            {playInfo.nPengCardIDs14, playInfo.nPengCardChair14, playInfo.nPengReserved14},
            {playInfo.nPengCardIDs15, playInfo.nPengCardChair15, playInfo.nPengReserved15},
            {playInfo.nPengCardIDs16, playInfo.nPengCardChair16, playInfo.nPengReserved16},
        },
        {
            {playInfo.nPengCardIDs21, playInfo.nPengCardChair21, playInfo.nPengReserved21},
            {playInfo.nPengCardIDs22, playInfo.nPengCardChair22, playInfo.nPengReserved22},
            {playInfo.nPengCardIDs23, playInfo.nPengCardChair23, playInfo.nPengReserved23},
            {playInfo.nPengCardIDs24, playInfo.nPengCardChair24, playInfo.nPengReserved24},
            {playInfo.nPengCardIDs25, playInfo.nPengCardChair25, playInfo.nPengReserved25},
            {playInfo.nPengCardIDs26, playInfo.nPengCardChair26, playInfo.nPengReserved26},
        },
        {
            {playInfo.nPengCardIDs31, playInfo.nPengCardChair31, playInfo.nPengReserved41},
            {playInfo.nPengCardIDs32, playInfo.nPengCardChair32, playInfo.nPengReserved42},
            {playInfo.nPengCardIDs33, playInfo.nPengCardChair33, playInfo.nPengReserved43},
            {playInfo.nPengCardIDs34, playInfo.nPengCardChair34, playInfo.nPengReserved44},
            {playInfo.nPengCardIDs35, playInfo.nPengCardChair35, playInfo.nPengReserved45},
            {playInfo.nPengCardIDs36, playInfo.nPengCardChair36, playInfo.nPengReserved46},
        },
        {
            {playInfo.nPengCardIDs41, playInfo.nPengCardChair41, playInfo.nPengReserved41},
            {playInfo.nPengCardIDs42, playInfo.nPengCardChair42, playInfo.nPengReserved42},
            {playInfo.nPengCardIDs43, playInfo.nPengCardChair43, playInfo.nPengReserved43},
            {playInfo.nPengCardIDs44, playInfo.nPengCardChair44, playInfo.nPengReserved44},
            {playInfo.nPengCardIDs45, playInfo.nPengCardChair45, playInfo.nPengReserved45},
            {playInfo.nPengCardIDs46, playInfo.nPengCardChair46, playInfo.nPengReserved46},
        },
    }
    self._utilsPlayInfo.nPengCards = nPengCards
    self._utilsPlayInfo.nPengCount = playInfo.nPengCount

    local nChiCards = {
        {
            {playInfo.nChiCardIDs11, playInfo.nChiCardChair11, playInfo.nChiReserved11},
            {playInfo.nChiCardIDs12, playInfo.nChiCardChair12, playInfo.nChiReserved12},
            {playInfo.nChiCardIDs13, playInfo.nChiCardChair13, playInfo.nChiReserved13},
            {playInfo.nChiCardIDs14, playInfo.nChiCardChair14, playInfo.nChiReserved14},
            {playInfo.nChiCardIDs15, playInfo.nChiCardChair15, playInfo.nChiReserved15},
            {playInfo.nChiCardIDs16, playInfo.nChiCardChair16, playInfo.nChiReserved16},
        },
        {
            {playInfo.nChiCardIDs21, playInfo.nChiCardChair21, playInfo.nChiReserved21},
            {playInfo.nChiCardIDs22, playInfo.nChiCardChair22, playInfo.nChiReserved22},
            {playInfo.nChiCardIDs23, playInfo.nChiCardChair23, playInfo.nChiReserved23},
            {playInfo.nChiCardIDs24, playInfo.nChiCardChair24, playInfo.nChiReserved24},
            {playInfo.nChiCardIDs25, playInfo.nChiCardChair25, playInfo.nChiReserved25},
            {playInfo.nChiCardIDs26, playInfo.nChiCardChair26, playInfo.nChiReserved26},
        },
        {
            {playInfo.nChiCardIDs31, playInfo.nChiCardChair31, playInfo.nChiReserved41},
            {playInfo.nChiCardIDs32, playInfo.nChiCardChair32, playInfo.nChiReserved42},
            {playInfo.nChiCardIDs33, playInfo.nChiCardChair33, playInfo.nChiReserved43},
            {playInfo.nChiCardIDs34, playInfo.nChiCardChair34, playInfo.nChiReserved44},
            {playInfo.nChiCardIDs35, playInfo.nChiCardChair35, playInfo.nChiReserved45},
            {playInfo.nChiCardIDs36, playInfo.nChiCardChair36, playInfo.nChiReserved46},
        },
        {
            {playInfo.nChiCardIDs41, playInfo.nChiCardChair41, playInfo.nChiReserved41},
            {playInfo.nChiCardIDs42, playInfo.nChiCardChair42, playInfo.nChiReserved42},
            {playInfo.nChiCardIDs43, playInfo.nChiCardChair43, playInfo.nChiReserved43},
            {playInfo.nChiCardIDs44, playInfo.nChiCardChair44, playInfo.nChiReserved44},
            {playInfo.nChiCardIDs45, playInfo.nChiCardChair45, playInfo.nChiReserved45},
            {playInfo.nChiCardIDs46, playInfo.nChiCardChair46, playInfo.nChiReserved46},
        },
    }
    self._utilsPlayInfo.nChiCards = nChiCards
    self._utilsPlayInfo.nChiCount = playInfo.nChiCount

    local nMnGangCards = {
        {
            {playInfo.nMnGangCardIDs11, playInfo.nMnGangCardChair11, playInfo.nMnGangReserved11},
            {playInfo.nMnGangCardIDs12, playInfo.nMnGangCardChair12, playInfo.nMnGangReserved12},
            {playInfo.nMnGangCardIDs13, playInfo.nMnGangCardChair13, playInfo.nMnGangReserved13},
            {playInfo.nMnGangCardIDs14, playInfo.nMnGangCardChair14, playInfo.nMnGangReserved14},
            {playInfo.nMnGangCardIDs15, playInfo.nMnGangCardChair15, playInfo.nMnGangReserved15},
            {playInfo.nMnGangCardIDs16, playInfo.nMnGangCardChair16, playInfo.nMnGangReserved16},
        },
        {
            {playInfo.nMnGangCardIDs21, playInfo.nMnGangCardChair21, playInfo.nMnGangReserved21},
            {playInfo.nMnGangCardIDs22, playInfo.nMnGangCardChair22, playInfo.nMnGangReserved22},
            {playInfo.nMnGangCardIDs23, playInfo.nMnGangCardChair23, playInfo.nMnGangReserved23},
            {playInfo.nMnGangCardIDs24, playInfo.nMnGangCardChair24, playInfo.nMnGangReserved24},
            {playInfo.nMnGangCardIDs25, playInfo.nMnGangCardChair25, playInfo.nMnGangReserved25},
            {playInfo.nMnGangCardIDs26, playInfo.nMnGangCardChair26, playInfo.nMnGangReserved26},
        },
        {
            {playInfo.nMnGangCardIDs31, playInfo.nMnGangCardChair31, playInfo.nMnGangReserved41},
            {playInfo.nMnGangCardIDs32, playInfo.nMnGangCardChair32, playInfo.nMnGangReserved42},
            {playInfo.nMnGangCardIDs33, playInfo.nMnGangCardChair33, playInfo.nMnGangReserved43},
            {playInfo.nMnGangCardIDs34, playInfo.nMnGangCardChair34, playInfo.nMnGangReserved44},
            {playInfo.nMnGangCardIDs35, playInfo.nMnGangCardChair35, playInfo.nMnGangReserved45},
            {playInfo.nMnGangCardIDs36, playInfo.nMnGangCardChair36, playInfo.nMnGangReserved46},
        },
        {
            {playInfo.nMnGangCardIDs41, playInfo.nMnGangCardChair41, playInfo.nMnGangReserved41},
            {playInfo.nMnGangCardIDs42, playInfo.nMnGangCardChair42, playInfo.nMnGangReserved42},
            {playInfo.nMnGangCardIDs43, playInfo.nMnGangCardChair43, playInfo.nMnGangReserved43},
            {playInfo.nMnGangCardIDs44, playInfo.nMnGangCardChair44, playInfo.nMnGangReserved44},
            {playInfo.nMnGangCardIDs45, playInfo.nMnGangCardChair45, playInfo.nMnGangReserved45},
            {playInfo.nMnGangCardIDs46, playInfo.nMnGangCardChair46, playInfo.nMnGangReserved46},
        },
    }
    self._utilsPlayInfo.nMnGangCards = nMnGangCards
    self._utilsPlayInfo.nMnGangCount = playInfo.nMnGangCount

    local nAnGangCards = {
        {
            {playInfo.nAnGangCardIDs11, playInfo.nAnGangCardChair11, playInfo.nAnGangReserved11},
            {playInfo.nAnGangCardIDs12, playInfo.nAnGangCardChair12, playInfo.nAnGangReserved12},
            {playInfo.nAnGangCardIDs13, playInfo.nAnGangCardChair13, playInfo.nAnGangReserved13},
            {playInfo.nAnGangCardIDs14, playInfo.nAnGangCardChair14, playInfo.nAnGangReserved14},
            {playInfo.nAnGangCardIDs15, playInfo.nAnGangCardChair15, playInfo.nAnGangReserved15},
            {playInfo.nAnGangCardIDs16, playInfo.nAnGangCardChair16, playInfo.nAnGangReserved16},
        },
        {
            {playInfo.nAnGangCardIDs21, playInfo.nAnGangCardChair21, playInfo.nAnGangReserved21},
            {playInfo.nAnGangCardIDs22, playInfo.nAnGangCardChair22, playInfo.nAnGangReserved22},
            {playInfo.nAnGangCardIDs23, playInfo.nAnGangCardChair23, playInfo.nAnGangReserved23},
            {playInfo.nAnGangCardIDs24, playInfo.nAnGangCardChair24, playInfo.nAnGangReserved24},
            {playInfo.nAnGangCardIDs25, playInfo.nAnGangCardChair25, playInfo.nAnGangReserved25},
            {playInfo.nAnGangCardIDs26, playInfo.nAnGangCardChair26, playInfo.nAnGangReserved26},
        },
        {
            {playInfo.nAnGangCardIDs31, playInfo.nAnGangCardChair31, playInfo.nAnGangReserved41},
            {playInfo.nAnGangCardIDs32, playInfo.nAnGangCardChair32, playInfo.nAnGangReserved42},
            {playInfo.nAnGangCardIDs33, playInfo.nAnGangCardChair33, playInfo.nAnGangReserved43},
            {playInfo.nAnGangCardIDs34, playInfo.nAnGangCardChair34, playInfo.nAnGangReserved44},
            {playInfo.nAnGangCardIDs35, playInfo.nAnGangCardChair35, playInfo.nAnGangReserved45},
            {playInfo.nAnGangCardIDs36, playInfo.nAnGangCardChair36, playInfo.nAnGangReserved46},
        },
        {
            {playInfo.nAnGangCardIDs41, playInfo.nAnGangCardChair41, playInfo.nAnGangReserved41},
            {playInfo.nAnGangCardIDs42, playInfo.nAnGangCardChair42, playInfo.nAnGangReserved42},
            {playInfo.nAnGangCardIDs43, playInfo.nAnGangCardChair43, playInfo.nAnGangReserved43},
            {playInfo.nAnGangCardIDs44, playInfo.nAnGangCardChair44, playInfo.nAnGangReserved44},
            {playInfo.nAnGangCardIDs45, playInfo.nAnGangCardChair45, playInfo.nAnGangReserved45},
            {playInfo.nAnGangCardIDs46, playInfo.nAnGangCardChair46, playInfo.nAnGangReserved46},
        },
    }
    self._utilsPlayInfo.nAnGangCards = nAnGangCards
    self._utilsPlayInfo.nAnGangCount = playInfo.nAnGangCount

    local nPnGangCards = {
        {
            {playInfo.nPnGangCardIDs11, playInfo.nPnGangCardChair11, playInfo.nPnGangReserved11},
            {playInfo.nPnGangCardIDs12, playInfo.nPnGangCardChair12, playInfo.nPnGangReserved12},
            {playInfo.nPnGangCardIDs13, playInfo.nPnGangCardChair13, playInfo.nPnGangReserved13},
            {playInfo.nPnGangCardIDs14, playInfo.nPnGangCardChair14, playInfo.nPnGangReserved14},
            {playInfo.nPnGangCardIDs15, playInfo.nPnGangCardChair15, playInfo.nPnGangReserved15},
            {playInfo.nPnGangCardIDs16, playInfo.nPnGangCardChair16, playInfo.nPnGangReserved16},
        },
        {
            {playInfo.nPnGangCardIDs21, playInfo.nPnGangCardChair21, playInfo.nPnGangReserved21},
            {playInfo.nPnGangCardIDs22, playInfo.nPnGangCardChair22, playInfo.nPnGangReserved22},
            {playInfo.nPnGangCardIDs23, playInfo.nPnGangCardChair23, playInfo.nPnGangReserved23},
            {playInfo.nPnGangCardIDs24, playInfo.nPnGangCardChair24, playInfo.nPnGangReserved24},
            {playInfo.nPnGangCardIDs25, playInfo.nPnGangCardChair25, playInfo.nPnGangReserved25},
            {playInfo.nPnGangCardIDs26, playInfo.nPnGangCardChair26, playInfo.nPnGangReserved26},
        },
        {
            {playInfo.nPnGangCardIDs31, playInfo.nPnGangCardChair31, playInfo.nPnGangReserved41},
            {playInfo.nPnGangCardIDs32, playInfo.nPnGangCardChair32, playInfo.nPnGangReserved42},
            {playInfo.nPnGangCardIDs33, playInfo.nPnGangCardChair33, playInfo.nPnGangReserved43},
            {playInfo.nPnGangCardIDs34, playInfo.nPnGangCardChair34, playInfo.nPnGangReserved44},
            {playInfo.nPnGangCardIDs35, playInfo.nPnGangCardChair35, playInfo.nPnGangReserved45},
            {playInfo.nPnGangCardIDs36, playInfo.nPnGangCardChair36, playInfo.nPnGangReserved46},
        },
        {
            {playInfo.nPnGangCardIDs41, playInfo.nPnGangCardChair41, playInfo.nPnGangReserved41},
            {playInfo.nPnGangCardIDs42, playInfo.nPnGangCardChair42, playInfo.nPnGangReserved42},
            {playInfo.nPnGangCardIDs43, playInfo.nPnGangCardChair43, playInfo.nPnGangReserved43},
            {playInfo.nPnGangCardIDs44, playInfo.nPnGangCardChair44, playInfo.nPnGangReserved44},
            {playInfo.nPnGangCardIDs45, playInfo.nPnGangCardChair45, playInfo.nPnGangReserved45},
            {playInfo.nPnGangCardIDs46, playInfo.nPnGangCardChair46, playInfo.nPnGangReserved46},
        },
    }
    self._utilsPlayInfo.nPnGangCards = nPnGangCards
    self._utilsPlayInfo.nPnGangCount = playInfo.nPnGangCount

    local nPnGangCards = {
        {
            {playInfo.nPnGangCardIDs11, playInfo.nPnGangCardChair11, playInfo.nPnGangReserved11},
            {playInfo.nPnGangCardIDs12, playInfo.nPnGangCardChair12, playInfo.nPnGangReserved12},
            {playInfo.nPnGangCardIDs13, playInfo.nPnGangCardChair13, playInfo.nPnGangReserved13},
            {playInfo.nPnGangCardIDs14, playInfo.nPnGangCardChair14, playInfo.nPnGangReserved14},
            {playInfo.nPnGangCardIDs15, playInfo.nPnGangCardChair15, playInfo.nPnGangReserved15},
            {playInfo.nPnGangCardIDs16, playInfo.nPnGangCardChair16, playInfo.nPnGangReserved16},
        },
        {
            {playInfo.nPnGangCardIDs21, playInfo.nPnGangCardChair21, playInfo.nPnGangReserved21},
            {playInfo.nPnGangCardIDs22, playInfo.nPnGangCardChair22, playInfo.nPnGangReserved22},
            {playInfo.nPnGangCardIDs23, playInfo.nPnGangCardChair23, playInfo.nPnGangReserved23},
            {playInfo.nPnGangCardIDs24, playInfo.nPnGangCardChair24, playInfo.nPnGangReserved24},
            {playInfo.nPnGangCardIDs25, playInfo.nPnGangCardChair25, playInfo.nPnGangReserved25},
            {playInfo.nPnGangCardIDs26, playInfo.nPnGangCardChair26, playInfo.nPnGangReserved26},
        },
        {
            {playInfo.nPnGangCardIDs31, playInfo.nPnGangCardChair31, playInfo.nPnGangReserved41},
            {playInfo.nPnGangCardIDs32, playInfo.nPnGangCardChair32, playInfo.nPnGangReserved42},
            {playInfo.nPnGangCardIDs33, playInfo.nPnGangCardChair33, playInfo.nPnGangReserved43},
            {playInfo.nPnGangCardIDs34, playInfo.nPnGangCardChair34, playInfo.nPnGangReserved44},
            {playInfo.nPnGangCardIDs35, playInfo.nPnGangCardChair35, playInfo.nPnGangReserved45},
            {playInfo.nPnGangCardIDs36, playInfo.nPnGangCardChair36, playInfo.nPnGangReserved46},
        },
        {
            {playInfo.nPnGangCardIDs41, playInfo.nPnGangCardChair41, playInfo.nPnGangReserved41},
            {playInfo.nPnGangCardIDs42, playInfo.nPnGangCardChair42, playInfo.nPnGangReserved42},
            {playInfo.nPnGangCardIDs43, playInfo.nPnGangCardChair43, playInfo.nPnGangReserved43},
            {playInfo.nPnGangCardIDs44, playInfo.nPnGangCardChair44, playInfo.nPnGangReserved44},
            {playInfo.nPnGangCardIDs45, playInfo.nPnGangCardChair45, playInfo.nPnGangReserved45},
            {playInfo.nPnGangCardIDs46, playInfo.nPnGangCardChair46, playInfo.nPnGangReserved46},
        },
    }
    self._utilsPlayInfo.nPnGangCards = nPnGangCards
    self._utilsPlayInfo.nPnGangCount = playInfo.nPnGangCount

    self._utilsPlayInfo.nOutCards = playInfo.nOutCards
    self._utilsPlayInfo.nOutCount = playInfo.nOutCount

    self._utilsPlayInfo.nHuaCards = playInfo.nHuaCards
    self._utilsPlayInfo.nHuaCount = playInfo.nHuaCount

    self._utilsPlayInfo.nReserved = playInfo.nReserved
end

function MJGameUtilsInfoManager:getPlayInfo()
    return self._utilsPlayInfo
end

function MJGameUtilsInfoManager:getCastoffCards()
    return self._utilsPlayInfo.nOutCards, self._utilsPlayInfo.nOutCount
end

function MJGameUtilsInfoManager:getPengCards()
    return self._utilsPlayInfo.nPengCards, self._utilsPlayInfo.nPengCount
end

function MJGameUtilsInfoManager:getChiCards()
    return self._utilsPlayInfo.nChiCards, self._utilsPlayInfo.nChiCount
end

function MJGameUtilsInfoManager:getMnGangCards()
    return self._utilsPlayInfo.nMnGangCards, self._utilsPlayInfo.nMnGangCount
end

function MJGameUtilsInfoManager:getPnGangCards()
    return self._utilsPlayInfo.nPnGangCards, self._utilsPlayInfo.nPnGangCount
end

function MJGameUtilsInfoManager:getAnGangCards()
    return self._utilsPlayInfo.nAnGangCards, self._utilsPlayInfo.nAnGangCount
end

function MJGameUtilsInfoManager:getHuaCards()
    return self._utilsPlayInfo.nHuaCards, self._utilsPlayInfo.nHuaCount
end

return MJGameUtilsInfoManager
