
local BaseGameConnect = import("src.app.Game.mBaseGame.BaseGameConnect")
local MJGameConnect = class("MJGameConnect", BaseGameConnect)

local treepack                              = cc.load("treepack")

local MJGameReq                             = import("src.app.Game.mMJGame.MJGameReq")
local MJGameDef                             = import("src.app.Game.mMJGame.MJGameDef")

function MJGameConnect:sendMsgToServer(msgID)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local GR_SENDMSG_TO_SERVER = MJGameReq["GAME_MSG"]
    local data              = {
        nRoomID             = utilsInfoManager:getRoomID(),
        nUserID             = playerInfoManager:getSelfUserID(),
        nMsgID              = msgID
    }
    local pData = treepack.alignpack(data, GR_SENDMSG_TO_SERVER)

    self:sendRequest(MJGameDef.MJ_GR_SENDMSG_TO_SERVER, pData, pData:len(), false)
    print("REQ_MsgToServer request sent")
end

function MJGameConnect:reqThrowCard(id)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_THROW_CARDS = MJGameReq["THROW_CARDS"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nSendTable      = playerInfoManager:getSelfTableNO(),
            nSendChair      = playerInfoManager:getSelfChairNO(),
            nSendUser       = playerInfoManager:getSelfUserID(),
            szHardID        = utilsInfoManager:getHardID(),
            dwCardsType     = 1,
            nCardsCount     = 1,
            nCardIDs        = {id,-1}
        }
        local pData = treepack.alignpack(data, GR_THROW_CARDS)

        self:sendRequest(MJGameDef.MJ_GR_THROW_CARDS, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_THROW_CARDS)
        print("REQ_ThrowCard request sent")
    else
        print("REQ_ThrowCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqCatchCard()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_CATCH_CARD = MJGameReq["CATCH_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nSendTable      = playerInfoManager:getSelfTableNO(),
            nSendChair      = playerInfoManager:getSelfChairNO(),
            nSendUser       = playerInfoManager:getSelfUserID()
        }
        local pData = treepack.alignpack(data, GR_CATCH_CARD)

        self:sendRequest(MJGameDef.MJ_GR_CATCH_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_CATCH_CARDS)
        print("REQ_CatchCard request sent")
    else
        print("REQ_CatchCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqHuaCard(id)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_HUA_CARD = MJGameReq["HUA_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardID         = id
        }
        local pData = treepack.alignpack(data, GR_HUA_CARD)

        self:sendRequest(MJGameDef.MJ_GR_HUA_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_HUA_CARDS)
        print("REQ_HuaCard request sent")
    else
        print("REQ_HuaCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqGuoCard()
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_GUO_CARD = MJGameReq["GUO_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO()
        }
        local pData = treepack.alignpack(data, GR_GUO_CARD)

        self:sendRequest(MJGameDef.MJ_GR_GUO_CARD, pData, pData:len(), false)
        print("REQ_GuoCard request sent")
    else
        print("REQ_GuoCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqPrePengCard(cardChair, cardID, baseIDs)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_PREPENG_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs
        }
        local pData = treepack.alignpack(data, GR_PREPENG_CARD)

        self:sendRequest(MJGameDef.MJ_GR_PREPENG_CARD, pData, pData:len(), false)
        print("REQ_PrePengCard request sent")
    else
        print("REQ_PrePengCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqPengCard(cardChair, cardID, baseIDs)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_PENG_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs
        }
        local pData = treepack.alignpack(data, GR_PENG_CARD)

        self:sendRequest(MJGameDef.MJ_GR_PENG_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_PENG_CARDS)
        print("REQ_PengCard request sent")
    else
        print("REQ_PengCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqPreGangCard(cardChair, cardID, baseIDs, gangFlags)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_PREGANG_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs,
            dwFlags         = gangFlags
        }
        local pData = treepack.alignpack(data, GR_PREGANG_CARD)

        self:sendRequest(MJGameDef.MJ_GR_PREGANG_CARD, pData, pData:len(), false)
        print("REQ_PreGangCard request sent")
    else
        print("REQ_PreGangCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqMnGangCard(cardChair, cardID, baseIDs)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_MNGANG_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs
        }
        local pData = treepack.alignpack(data, GR_MNGANG_CARD)

        self:sendRequest(MJGameDef.MJ_GR_MN_GANG_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_MNGANG_CARDS)
        print("REQ_MnGangCard request sent")
    else
        print("REQ_MnGangCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqAnGangCard(cardChair, cardID, baseIDs)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_ANGANG_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs
        }
        local pData = treepack.alignpack(data, GR_ANGANG_CARD)

        self:sendRequest(MJGameDef.MJ_GR_AN_GANG_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_ANGANG_CARDS)
        print("REQ_AnGangCard request sent")
    else
        print("REQ_AnGangCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqPnGangCard(cardChair, cardID, baseIDs)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_PNGANG_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs
        }
        local pData = treepack.alignpack(data, GR_PNGANG_CARD)

        self:sendRequest(MJGameDef.MJ_GR_PN_GANG_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_PNGANG_CARDS)
        print("REQ_PnGangCard request sent")
    else
        print("REQ_PnGangCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqPreChiCard(cardChair, cardID, baseIDs)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_PRECHI_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs
        }
        local pData = treepack.alignpack(data, GR_PRECHI_CARD)

        self:sendRequest(MJGameDef.MJ_GR_PRECHI_CARD, pData, pData:len(), false)
        print("REQ_PreChiCard request sent")
    else
        print("REQ_PreChiCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqChiCard(cardChair, cardID, baseIDs)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_CHI_CARD = MJGameReq["PGC_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            nBaseIDs        = baseIDs
        }
        local pData = treepack.alignpack(data, GR_CHI_CARD)

        self:sendRequest(MJGameDef.MJ_GR_CHI_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_CHI_CARDS)
        print("REQ_ChiCard request sent")
    else
        print("REQ_ChiCard error, waitingResponse = " .. waitingResponse)
    end
end

function MJGameConnect:reqHuCard(cardChair, cardID, huFlags, subFlags)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local utilsInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not utilsInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_HU_CARD = MJGameReq["HU_CARD"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = utilsInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            nCardChair      = cardChair,
            nCardID         = cardID,
            dwFlags         = huFlags,
            dwSubFlags      = subFlags,
        }
        local pData = treepack.alignpack(data, GR_HU_CARD)

        self:sendRequest(MJGameDef.MJ_GR_HU_CARD, pData, pData:len(), true)
        self._gameController:setResponse(MJGameDef.MJ_WAITING_HU_CARDS)
        print("REQ_HuCard request sent")
    else
        print("REQ_HuCard error, waitingResponse = " .. waitingResponse)
    end
end

return MJGameConnect
