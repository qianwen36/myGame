
local BaseGamePlayer = import("src.app.Game.mBaseGame.BaseGamePlayer")
local MJGamePlayer = class("MJGamePlayer", BaseGamePlayer)

local lbsLabel={}
local lbsInfoTable={}
local headPic={}
local headPathTable={}
local originalHeadPicSize={}
local selfDefineHeadPicSize={}
selfDefineHeadPicSize.width=115
selfDefineHeadPicSize.height=115

function MJGamePlayer:ctor(playerPanel, drawIndex, gameController)
    self._playerFlower              = nil
    self._playerFlowerNum           = nil
    self._playerHead_bg             = nil
    self._playerBanker              = nil
    self._playerInfoBG              = nil
    self._playerSilver              = nil
    
    self._playerLevel               = nil

    self._PGCHAni                   = nil

    self._playerFlowerCount         = 0
    self._nickSex                   = 0
    self._playerUserID              = 0
    MJGamePlayer.super.ctor(self, playerPanel, drawIndex, gameController)
end

function MJGamePlayer:init()
   
    if self._playerPanel then
        self._playerFlower          = self._playerPanel:getChildByName("Player_sp_flower")
        self._playerFlowerNum       = self._playerPanel:getChildByName("Player_num_flower")
        self._playerBanker          = self._playerPanel:getChildByName("Player_sp_banker")
        self._playerHead_bg         = self._playerPanel:getChildByName("Player_head_bg")
        self._playerBtnHead         = self._playerPanel:getChildByName("Player_btn_head")
 
        self._playerLevel           = self._playerPanel:getChildByName("level")
              
        self._playerInfoBG      = self._playerPanel:getChildByName("Player_info_bg")
        self._playerUserName    = self._playerPanel:getChildByName("Player_text_name")
        self._playerSilver      = self._playerPanel:getChildByName("Player_silver")
        self._playerMoney       = self._playerPanel:getChildByName("Player_text_money")

        self._playerReady       = self._playerPanel:getChildByName("Player_sp_ready")
        self._playerChatFrame   = self._playerPanel:getChildByName("panel_chat_bg")
        if self._playerChatFrame then
            self._playerChatStr = self._playerChatFrame:getChildByName("text_chat")
        end

        self._playerInfoPanel   = self._playerPanel:getChildByName("panel_playerinfo")
    end
    
    self:initPlayerPos()
    self:setClickEvent()
    self:initPlayer()

end

function MJGamePlayer:initPlayerPos()
end

function MJGamePlayer:addPlayerFlower()
    self:setPlayerFlower(self._playerFlowerCount + 1)
end

function MJGamePlayer:setPlayerFlower(nFlower)
    if "number" ~= type(nFlower) then return end

    self._playerFlowerCount = nFlower

    if 0 < nFlower then
        if self._playerFlowerNum then
            self._playerFlowerNum:setVisible(true)
            self._playerFlowerNum:setString(tostring(nFlower))
        end
        if self._playerFlower then
            self._playerFlower:setVisible(true)
        end
    else
        if self._playerFlowerNum then
            self._playerFlowerNum:setVisible(false)
        end
        if self._playerFlower then
            self._playerFlower:setVisible(false)
        end
    end
end

function MJGamePlayer:showBanker(bBanker)
    if self._playerBanker then
        self._playerBanker:setVisible(bBanker)
    end
end

function MJGamePlayer:hidePlayerInfo()
    --self:hideUserName()
    --self:hideMoney()
end

function MJGamePlayer:ope_MovePlayer(duration)
    if not self._playerPanel then return end
end

function MJGamePlayer:onMovePlayerCallback()
    
end

function MJGamePlayer:ope_MovePlayerImmediately()
end


function MJGamePlayer:setSoloPlayer(soloPlayer)
    self:setVisible(true)
    self:setPlayerScoreLevel(soloPlayer.nPlayerLevel)
    self:setUserName(soloPlayer.szUserName)
    self:setMoney(soloPlayer.nDeposit)
    self:setNickSex(soloPlayer.nNickSex)
    
--about remark name
    local tcyFriendPlugin = plugin.AgentManager:getInstance():getTcyFriendPlugin()
    if tcyFriendPlugin then
       if(tcyFriendPlugin:isFriend(soloPlayer.nUserID))then
           local remark = tcyFriendPlugin:getRemarkName(soloPlayer.nUserID)
           if(remark~="")then
                self:setUserName(remark)
           end
       end
    end


--create lbs label
    local playerLbs = cc.LabelTTF:create("","Marker Felt",18,cc.size(0,0),cc.TEXT_ALIGNMENT_LEFT)
    self._playerMoney:removeAllChildren()
    self._playerMoney:addChild(playerLbs)
    playerLbs:setAnchorPoint(0,0)
    playerLbs:setPosition(-28,-20)
    lbsLabel[soloPlayer.nUserID]=playerLbs
    if(lbsInfoTable[soloPlayer.nUserID])then
        playerLbs:setString(lbsInfoTable[soloPlayer.nUserID])
    end

--create head pic
    self._playerBtnHead:removeAllChildren()
    local picImage=ccui.ImageView:create()
    self._playerBtnHead:addChild(picImage)
    headPic[soloPlayer.nUserID]=picImage

    picImage:setAnchorPoint(0,0)
    picImage:setPosition(0,3)
    picImage:ignoreContentAdaptWithSize(false)

    if(headPathTable[soloPlayer.nUserID])then

            picImage:loadTexture(headPathTable[soloPlayer.nUserID])
            picImage:setVisible(true)
            picImage:setContentSize(selfDefineHeadPicSize)

    else
            picImage:setVisible(false)
    end

--create add friend button
    self._playerUserID=soloPlayer.nUserID
    local bg = self._playerInfoPanel:getChildByName("playerinfo_bg")
    bg:removeAllChildren()
        local json = cc.load("json").json
        local ofile = MCFileUtils:getInstance():getStringFromFile("res/Game/GameDes/FriendDes.json")
        if( ofile == "")then
            printf("~~~~~~~~~~no FriendDes~~~~~~~~~~~")
            return
        end
        local des = json.decode(ofile)
        local addDes=des["addInChartered"]
        local title=des["add"]
        ofile = MCFileUtils:getInstance():getStringFromFile("AppConfig.json")
        if( ofile == "")then
            printf("~~~~~~~~~~no FriendDes~~~~~~~~~~~")
            return
        end
        des = json.decode(ofile)
        addDes=string.format(addDes,des["name"])

        bg:loadTexture("res/GameCocosStudio/game/playerinfo/playerinfo_frame.png")
        bg:setContentSize(228,353)
        bg:setPositionY(113)
        local custom_button = ccui.Button:create("res/GameCocosStudio/CharteredRoom/button/apply.png", "res/GameCocosStudio/CharteredRoom/button/apply.png")
        bg:addChild(custom_button)
        custom_button:setName("add_btn")
        custom_button:setPosition(115,45)
        custom_button:onTouch(function(e)
            if(e.name=='began')then
                e.target:setScale(cc.exports.GetButtonScale(e.target))
                audio.playSound(cc.FileUtils:getInstance():fullPathForFilename('res/Hall/Sounds/KeypressStandard.ogg'),false)
            elseif(e.name=='ended')then
                e.target:setScale(1.0)

                    self._gameController:addFriend(soloPlayer.nUserID,addDes)
                    self._playerInfoPanel:setVisible(false)

            elseif(e.name=='cancelled')then
                e.target:setScale(1.0)
            elseif(e.name=='moved')then

            end
        end)

        local label = cc.LabelTTF:create(title,"Marker Felt",20,cc.size(0,0),cc.TEXT_ALIGNMENT_CENTER)
        custom_button:addChild(label)
        label:setAnchorPoint(0.5,0.5)
        label:setPosition(60,25)
        if(cc.exports.IsSocialSupportted()==0)then
            custom_button:removeSelf()
        end
end

function MJGamePlayer:setPlayerScoreLevel(nPlayerLevel)
    if self._playerLevel then
        self._playerLevel:setVisible(true)
    end

    if self._playerLevel then
        local resPath = "res/GameCocosStudio/game/player/level" .. tostring(nPlayerLevel+1) .. ".png"
        local manFrameRect = cc.Sprite:create(resPath)
        local rect = cc.rect(0, 0, manFrameRect:getContentSize().width, manFrameRect:getContentSize().height)                          
        local manFrame = cc.SpriteFrame:create(resPath, rect)
        if manFrame then
            self._playerLevel:setSpriteFrame(manFrame)
            self._playerLevel:setVisible(true)
        end
    end
end

function MJGamePlayer:setUserName(szUserName)  
    if self._playerInfoBG then
        self._playerInfoBG:setVisible(true)
    end
    if self._playerUserName then
        self._playerUserName:setVisible(true)
        local utf8name
        if string.len(szUserName) > 10 then
            szUserName = string.sub(szUserName,1,8)
            utf8name = MCCharset:getInstance():gb2Utf8String(szUserName, string.len(szUserName))
            utf8name = utf8name .. "..."
        else
            utf8name = MCCharset:getInstance():gb2Utf8String(szUserName, string.len(szUserName))
        end

       
        self._playerUserName:setString(utf8name)
    end
end

function MJGamePlayer:hideUserName()
    if self._playerInfoBG then
        self._playerInfoBG:setVisible(false)
    end
    if self._playerUserName then
        self._playerUserName:setVisible(false)
    end
end

function MJGamePlayer:setMoney(nDeposit)
    if self._playerSilver then
        self._playerSilver:setVisible(true)
    end
    if self._playerMoney then
        self._playerMoney:setVisible(true)
        self._playerMoney:setString(nDeposit)
    end
end

function MJGamePlayer:hideMoney()
    if self._playerSilver then
        self._playerSilver:setVisible(false)
    end
    if self._playerMoney then
        self._playerMoney:setVisible(false)
    end
end

function MJGamePlayer:setNickSex(nNickSex)

    self._nickSex = nNickSex
    
    if not self._playerBtnHead then  return end
    self._playerBtnHead:setVisible(true)

    if self._playerHead_bg  then
        self._playerHead_bg:setVisible(true)
    end
    if self._playerBtnHead then
        self._playerBtnHead:setVisible(true)
        if 1 == nNickSex then
            self._playerBtnHead:loadTextureNormal("res/GameCocosStudio/game/player/player_head_woman_happy.png")
            self._playerBtnHead:loadTexturePressed("res/GameCocosStudio/game/player/player_head_woman_happy.png")
        else
            self._playerBtnHead:loadTextureNormal("res/GameCocosStudio/game/player/player_head_boy_happy.png")
            self._playerBtnHead:loadTexturePressed("res/GameCocosStudio/game/player/player_head_boy_happy.png")
        end
    end
end

function MJGamePlayer:showPlayerInfo(bShow)
    if not self._playerInfoPanel    then return end   
    
    self._playerInfoPanel:setVisible(bShow)    
    if not bShow                    then return end 
          
    local playerInfoManager = self._gameController:getPlayerInfoManager()
    if not playerInfoManager    then return end
    
    local playerInfo = playerInfoManager:getPlayerInfo(self._drawIndex)
    if not playerInfo           then return end
    
    local name = self._playerInfoPanel:getChildByName("text_name")
    if name then
        local userName = playerInfo.szUserName
        if userName then
            local utf8Name = MCCharset:getInstance():gb2Utf8String(userName, string.len(userName))
            name:setString(utf8Name)
        end
    end

    local text_winBount = self._playerInfoPanel:getChildByName("text_sheng")
    if text_winBount then
        local userwinBount = playerInfo.nWin
        if userwinBount then
            text_winBount:setString(tostring(userwinBount))
        end
    end


    local text_loseBount = self._playerInfoPanel:getChildByName("text_shu")
    if text_loseBount then
        local userwinBount = playerInfo.nLoss
        if userwinBount then
            text_loseBount:setString(tostring(userwinBount))
        end
    end

    local deposit = self._playerInfoPanel:getChildByName("text_yinzi")
    if deposit then
        local userDeposit = playerInfo.nDeposit
        if userDeposit then
            deposit:setString(tostring(userDeposit))
        end
    end
    
    local depositlevel = self._playerInfoPanel:getChildByName("text_caifu")
    if depositlevel then
        local depositLevel = self._gameController:getDepositLevel(playerInfo.nDeposit)
        if depositLevel then
            local utf8Name = MCCharset:getInstance():gb2Utf8String(depositLevel, string.len(depositLevel))
            depositlevel:setString(utf8Name)
        end
    end
    

    local score = self._playerInfoPanel:getChildByName("text_jifen")
    if score then
        local userjifen = playerInfo.nScore 
        if userjifen then
            score:setString(tostring(userjifen))
        end
    end
                   
    local scoreLevel = self._playerInfoPanel:getChildByName("text_jibie")
    if scoreLevel then 
        local strscoreLevel = self._gameController:getScoreLevel(playerInfo.nPlayerLevel)
        if strscoreLevel then
            local utf8Name = MCCharset:getInstance():gb2Utf8String(strscoreLevel, string.len(strscoreLevel))
            scoreLevel:setString(utf8Name)
        end
    end

    local addBtn = self._playerInfoPanel:getChildByName("playerinfo_bg"):getChildByName("add_btn")
    local selfID = self._gameController:getPlayerInfoManager():getSelfUserID()
    if(self._playerUserID == selfID)then
        addBtn:setVisible(false)
    else
        if(self._gameController:isFriend(self._playerUserID))then
            addBtn:setVisible(false)
        else
            addBtn:setVisible(true)
        end

    end

end

function MJGamePlayer:playFacial(nodeName,facialName)
    local csbPath = "res/GameCocosStudio/chat/face/"
    local emotion = cc.CSLoader:createNode(csbPath..nodeName)    
    local action = cc.CSLoader:createTimeline(csbPath..nodeName)
    if emotion and action then
        emotion:runAction(action)
        self._playerPanel:addChild(emotion)
        emotion:setPosition(cc.p(self._playerBtnHead:getPositionX() + self._playerBtnHead:getContentSize().width/2,
                                 self._playerBtnHead:getPositionY() + self._playerBtnHead:getContentSize().height/2))           
    end             
    action:play(facialName, false)

    local function callback(frame)
        if frame then 
            local event = frame:getEvent()
            if "callback" == event then
                action:clearFrameEventCallFunc()
                emotion:stopAllActions()
                emotion:removeSelf()
                emotion = nil
            end
        end
    end
    action:setFrameEventCallFunc(callback)
end

function MJGamePlayer:tipChatContent(content)
    if self._playerPanel then
        if content == "#beated" then
            self:playFacial("node_face_1.csb","animation_facial_1")
            return       
        elseif content == "#cool" then
            self:playFacial("node_face_2.csb","animation_facial_2")
            return 
        elseif content == "#cry" then
            self:playFacial("node_face_3.csb","animation_facial_3")
            return 
        elseif content == "#embarrassed" then
            self:playFacial("node_face_4.csb","animation_facial_4")
            return 
        elseif content == "#en" then
            self:playFacial("node_face_5.csb","animation_facial_5")
            return 
        elseif content == "#hurt" then
            self:playFacial("node_face_6.csb","animation_facial_6")
            return 
        elseif content == "#innocent" then
            self:playFacial("node_face_7.csb","animation_facial_7")
            return 
        elseif content == "#loser" then
            self:playFacial("node_face_8.csb","animation_facial_8")
            return 
        elseif content == "#sexy" then
            self:playFacial("node_face_9.csb","animation_facial_9")
            return 
        else
			print("not a facial")
        end
    end
    
    if self._playerChatFrame then
        self._playerChatFrame:setVisible(true)

        if self._playerChatStr then
            local utf8Content = MCCharset:getInstance():gb2Utf8String(content, string.len(content))
            self._playerChatStr:setString(utf8Content)
            self._gameController:playChatEffectByName(utf8Content,self._nickSex)
        end


        local function onAutoHideChatTip(dt)
            self:hideChatTip()
        end
        local duration = 3
        self:stopTipChatTimer()
        self.tipChatTimerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onAutoHideChatTip, duration, false)
    end
end

function MJGamePlayer:ope_playPGCHAni(aniName)
    --²¥·ÅÍæ¼ÒÅö¸Ü³Ôºú¶¯»­
    local csbPath = "res/GameCocosStudio/game/pgch/Pgch_animition/" .. aniName .. ".csb"
    
    if self._PGCHAni then
        self._playerPanel:removeChild(self._PGCHAni,true)
        self._PGCHAni = nil
    end
    self._PGCHAni = cc.CSLoader:createNode(csbPath)
    if self._PGCHAni then
        self._playerPanel:addChild(self._PGCHAni)
        local size = self._PGCHAni:getContentSize()
        if self._drawIndex == 1 then
            self._PGCHAni:setPosition(cc.p( 0,200 - size.height/2))
        elseif self._drawIndex == 2 then
            self._PGCHAni:setPosition(cc.p( 250 - size.width/2,75 - size.height/2))
        elseif  self._drawIndex == 3 then
            self._PGCHAni:setPosition(cc.p( -250 - size.width/2,-100 - size.height/2))
        else
            self._PGCHAni:setPosition(cc.p( -150 - size.width/2,75 - size.height/2))
        end
        
        local action = cc.CSLoader:createTimeline(csbPath)
        
        local function onPGCHFinish(frame)
            self:onPGCHFinish()
        end
        if action then
            self._PGCHAni:runAction(action)
            action:gotoFrameAndPlay(0, 16, false)
            action:setFrameEventCallFunc(onPGCHFinish) 
        end        
    end   
end

function MJGamePlayer:onPGCHFinish()
    if self._PGCHAni then
        self._playerPanel:removeChild(self._PGCHAni,true)
        self._PGCHAni = nil
    end
end

function MJGamePlayer:setLbs(nUserID,lbs)
    local label = lbsLabel[nUserID]
    if(label)then
        label:setString(lbs)
        lbsInfoTable[nUserID]=lbs
    end
end

function MJGamePlayer:setPlayerHead(nUserID,path)
    if(path=="")then
        return
    end
    printf("~~~~~~~~~~~~setPlayerHead id[%d] path[%s]~~~~~~~~~~~~~~~~~~~~~~~~",nUserID,path)
    local pic = headPic[nUserID]
    if(pic)then
        pic:loadTexture(path)
        pic:setContentSize(selfDefineHeadPicSize)
        pic:setVisible(true)
        headPathTable[nUserID]=path
    end
end

function MJGamePlayer:onTouchBegin(x,y)
    if(self._playerInfoPanel:isVisible()==false)then
        return
    end

    local bg = self._playerInfoPanel:getChildByName("playerinfo_bg")
    local addBtn = bg:getChildByName("add_btn")
    if(addBtn==nil)then
        return
    end
    local content = addBtn:getContentSize()
    local rect = cc.rect(0,0,content.width,content.height)
    local touch = addBtn:convertToNodeSpace(cc.p(x, y))

    local b = cc.rectContainsPoint(rect, touch)
    if(b==false)then
        self._playerInfoPanel:setVisible(false)
        return
    end
    MJGamePlayer.super:onTouchBegin(x,y)
end

return MJGamePlayer
