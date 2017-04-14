
local MJGameData = import("..mMJGame.MJGameData")
local MyGameData = class("MyGameData", MJGameData)

local treepack          = cc.load("treepack")
local BaseGameReq       = import("..mBaseGame.BaseGameReq")
local MJGameReq         = import("..mMJGame.MJGameReq")
local MyGameReq         = import(".MyGameReq")

function MyGameData:getGameStartInfo(data)
    local info = MyGameReq["GAME_START_INFO"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MyGameData:getGameWinInfo(data)
    if data == nil then return nil end

    local info = MyGameReq["GAME_WIN_RESULT"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MyGameData:getTableInfo(data)
    if data == nil then return nil end

    local startInfo = MJGameReq["MJ_START_DATA"]
    local msgStartInfo = treepack.unpack(data, startInfo)

    local dataPlayInfo = string.sub(data, startInfo.maxsize + 1)
    local playInfo = MJGameReq["MJ_PLAY_DATA"]
    local msgPlayInfo = treepack.unpack(dataPlayInfo, playInfo)

    local gameTableInfo = MyGameReq["GAME_TABLE_INFO"]
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

function MyGameData:getCardCaughtNewInfo(data)
    if data == nil then return nil end

    local info = MyGameReq["CARD_CAUGHTNEW"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

function MyGameData:getCardTingInfo(data)
    if data == nil then return nil end

    local info = MyGameReq["CARD_TINGINFO"]
    local msgInfo = treepack.unpack(data, info)
    return msgInfo
end

return MyGameData
