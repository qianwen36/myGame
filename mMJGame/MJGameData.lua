
local BaseGameData = import("..mBaseGame.BaseGameData")
local MJGameData = class("MJGameData", BaseGameData)

local treepack          = cc.load("treepack")
local BaseGameReq       = import("..mBaseGame.BaseGameReq")
local MJGameReq         = import(".MJGameReq")

function MJGameData:getEnterGameOKInfo(data)
    if data == nil then return nil end

    local gameEnterInfo = MJGameReq["MJ_ENTER_INFO"]
    local msgGameEnterInfo = treepack.unpack(data, gameEnterInfo)

    local dataSoloPlayerHead = string.sub(data, gameEnterInfo.maxsize + 1)
    local soloPlayerHead = BaseGameReq["SOLOPLAYER_HEAD"]
    local msgSoloPlayerHead = treepack.unpack(dataSoloPlayerHead, soloPlayerHead)

    local msgSoloPlayers = {}
    local dataSoloPlayerStart = string.sub(dataSoloPlayerHead, soloPlayerHead.maxsize + 1)
    if dataSoloPlayerStart and msgSoloPlayerHead.nPlayerCount then
        for i = 1, msgSoloPlayerHead.nPlayerCount do
            local soloPlayer = BaseGameReq["SOLO_PLAYER"]
            msgSoloPlayers[i] = treepack.unpack(dataSoloPlayerStart, soloPlayer)

            dataSoloPlayerStart = string.sub(dataSoloPlayerStart, soloPlayer.maxsize + 1)
        end
    end

    return msgGameEnterInfo, msgSoloPlayers
end

function MJGameData:getGameStartInfo(data)
    if data == nil then return nil end

    local info = MJGameReq["MJ_START_DATA"]
    local msgGameStart = treepack.unpack(data, info)
    return msgGameStart
end

function MJGameData:getCardsThrowInfo(data)
    if data == nil then return nil end

    local info = MJGameReq["CARDS_THROW"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MJGameData:getCardCaughtInfo(data)
    if data == nil then return nil end

    local info = MJGameReq["CARD_CAUGHT"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MJGameData:getCardHuaInfo(data)
    if data == nil then return nil end

    local info = MJGameReq["CARD_HUA"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MJGameData:getCardPGCInfo(data)
    if data == nil then return nil end

    local info = MJGameReq["PGC_CARD"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MJGameData:getCardPreGangOKInfo(data)
    if data == nil then return nil end

    local info = MJGameReq["PREGANG_OK"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MJGameData:getGameWinInfo(data)
    if data == nil then return nil end

    local info = MJGameReq["GAME_WIN_MJ"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MJGameData:getTableInfo(data)
    if data == nil then return nil end

    local startInfo = MJGameReq["MJ_START_DATA"]
    local msgStartInfo = treepack.unpack(data, startInfo)

    local dataPlayInfo = string.sub(data, startInfo.maxsize + 1)
    local playInfo = MJGameReq["MJ_PLAY_DATA"]
    local msgPlayInfo = treepack.unpack(dataPlayInfo, playInfo)

    local gameTableInfo = MJGameReq["GAME_TABLE_INFO"]
    local msgGameTableInfo = treepack.unpack(data, gameTableInfo)

    local dataSoloPlayerHead = string.sub(data, gameTableInfo.maxsize + 1)
    local soloPlayerHead = BaseGameReq["SOLOPLAYER_HEAD"]
    local msgSoloPlayerHead = treepack.unpack(dataSoloPlayerHead, soloPlayerHead)

    local msgSoloPlayers = {}
    local dataSoloPlayerStart = string.sub(dataSoloPlayerHead, soloPlayerHead.maxsize + 1)
    if dataSoloPlayerStart and msgSoloPlayerHead.nPlayerCount then
        for i = 1, msgSoloPlayerHead.nPlayerCount do
            local soloPlayer = BaseGameReq["SOLO_PLAYER"]
            msgSoloPlayers[i] = treepack.unpack(dataSoloPlayerStart, soloPlayer)

            dataSoloPlayerStart = string.sub(dataSoloPlayerStart, soloPlayer.maxsize + 1)
        end
    end

    return msgStartInfo, msgPlayInfo, msgGameTableInfo, msgSoloPlayers
end

return MJGameData
