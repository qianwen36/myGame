
if nil == cc or nil == cc.exports then
    return
end


require("src.cocos.cocos2d.bitExtend")

cc.exports.GamePublicInterface                  = {}
local GamePublicInterface                       = cc.exports.GamePublicInterface

GamePublicInterface.OFFLINE_ROOM_ID             = -2000
GamePublicInterface.ROOM_OPT_NEEDDEPOSIT        = 0x00000004
GamePublicInterface.ROOM_CFG_RANDOM             = 0x00000002
GamePublicInterface.ROOM_CFG_CLOAKING           = 0x00000008

GamePublicInterface._gameString                 = nil
GamePublicInterface._gameController             = nil

function GamePublicInterface:IS_FRAME_1()
    return false
end

function GamePublicInterface:IS_BIT_SET(flag, mybit) return (mybit == bit._and(mybit, flag)) end

function GamePublicInterface:getQuickStartRoomID(rooms)
    local quickStartRoomID = self.OFFLINE_ROOM_ID

    for i = 1, #rooms do
        local roomImpl = rooms[i].original
        if roomImpl then
            if self.OFFLINE_ROOM_ID ~= roomImpl.nRoomID
                and GamePublicInterface:IS_BIT_SET(roomImpl.dwConfigs, self.ROOM_CFG_RANDOM) then
                quickStartRoomID = roomImpl.nRoomID
                break
            end
        end
    end

    for i = 1, #rooms do
        local roomImpl = rooms[i].original
        if roomImpl then
            if self.OFFLINE_ROOM_ID ~= roomImpl.nRoomID then
                quickStartRoomID = roomImpl.nRoomID
                break
            end
        end
    end

    return quickStartRoomID
end

function GamePublicInterface:getGameString(key)
    if not self._gameString then
        local jsonGameString = cc.FileUtils:getInstance():getStringFromFile("src/app/Game/mMyGame/GameString.json")
        self._gameString = json.decode(jsonGameString)
    end
    if self._gameString then
        return self._gameString[key]
    end
    return nil
end

function GamePublicInterface:setGameController(gameController)
    self._gameController = gameController
end

function GamePublicInterface:onNotifyAdminMsgToRoom(msg)
    if self._gameController then
    --self._gameController:onNotifyAdminMsgToRoom(msg)
    end
end

function GamePublicInterface:onNotifyKickedOffByAdmin()
    if self._gameController then
        self._gameController:onNotifyKickedOffByAdmin()
    end
end

function GamePublicInterface:onNotifyKickedOffByLogonAgain()
    if self._gameController then
        self._gameController:onNotifyKickedOffByLogonAgain()
    end
end

function GamePublicInterface:onNotifyKickedOffByRoomPlayer()
    if self._gameController then
        self._gameController:onNotifyKickedOffByAdmin()
    end
end

function GamePublicInterface:onQuitFromRoom()
    if self._gameController then
        self._gameController:onQuitFromRoom()
    end
end


return GamePublicInterface
