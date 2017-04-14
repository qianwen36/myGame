
local MJGameConnect = import("..mMJGame.MJGameConnect")
local MyGameConnect = class("MyGameConnect", MJGameConnect)

local treepack                              = cc.load("treepack")

local MJGameReq                             = import("..mMJGame.MJGameReq")
local MyGameReq                             = import(".MyGameReq")
local MyGameDef                             = import(".MyGameDef")

function MyGameConnect:reqDouble(bFang)
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
    if not playerInfoManager or not uitleInfoManager then return end

    local waitingResponse = self._gameController:getResponse()
    if waitingResponse == self._gameController:getResWaitingNothing() then
        local GR_GIVEUP_HU = MyGameReq["GIVEUPHU"]
        local data          = {
            nUserID         = playerInfoManager:getSelfUserID(),
            nRoomID         = uitleInfoManager:getRoomID(),
            nTableNO        = playerInfoManager:getSelfTableNO(),
            nChairNO        = playerInfoManager:getSelfChairNO(),
            bFang           = bFang
        }
        local pData = treepack.alignpack(data, GR_GIVEUP_HU)

        self:sendRequest(MyGameDef.MY_GR_GIVEUP_HU, pData, pData:len(), true)
        self._gameController:setResponse(MyGameDef.MY_WAITING_GIVEUP_HU)
        print("REQ_Double request sent")
    else
        print("REQ_Double error, waitingResponse = " .. waitingResponse)
    end
end

--function MyGameConnect:reqTingCard(id)
--    local playerInfoManager = self._gameController:getPlayerInfoManager()
--    local uitleInfoManager  = self._gameController:getUtilsInfoManager()
--    if not playerInfoManager or not uitleInfoManager then return end
--
--    local waitingResponse = self._gameController:getResponse()
--    if waitingResponse == self._gameController:getResWaitingNothing() then
--        local GR_THROW_CARDS = MJGameReq["THROW_CARDS"]
--        local data          = {
--            nUserID         = playerInfoManager:getSelfUserID(),
--            nRoomID         = uitleInfoManager:getRoomID(),
--            nTableNO        = playerInfoManager:getSelfTableNO(),
--            nChairNO        = playerInfoManager:getSelfChairNO(),
--            nSendTable      = playerInfoManager:getSelfTableNO(),
--            nSendChair      = playerInfoManager:getSelfChairNO(),
--            nSendUser       = playerInfoManager:getSelfUserID(),
--            szHardID        = uitleInfoManager:getHardID(),
--            dwCardsType     = 1,
--            nCardsCount     = 1,
--            nCardIDs        = {id}
--        }
--        local pData = treepack.alignpack(data, GR_THROW_CARDS)
--
--        self:sendRequest(MyGameDef.MY_GR_MJ_TING, pData, pData:len(), true)
--        self._gameController:setResponse(MyGameDef.MY_WAITING_MJ_TING)
--        print("REQ_TingCard request sent")
--    else
--        print("REQ_TingCard error, waitingResponse = " .. waitingResponse)
--    end
--end

return MyGameConnect
