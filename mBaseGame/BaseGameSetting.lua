
local BaseGameSetting = class("BaseGameSetting")

function BaseGameSetting:ctor(settingPanel, gameController)
    if not gameController then printError("gameController is nil!!!") return end
    self._gameController        = gameController

    self._settingPanel          = settingPanel

    self._musicToggle           = nil
    self._effectToggle          = nil

    self._btnSelSingleClk       = nil
    self._btnSelDoubleClk       = nil

    self._initMusicVolume       = 0
    self._initEffectVolume      = 0

    self._musicOnPosX           = 0
    self._musicOffPosX          = 0

    self._effectOnPosX          = 0
    self._effectOffPosX         = 0

    self._bMusicOn              = true
    self._bEffectOn             = true

    self._bSelCardBySingleClk   = true
    self._bSoundForbbiden       = false

    self._settingData           = nil

    self:init()
end

function BaseGameSetting:init()
    if not self._settingPanel then return end

    self:setVisible(false)

    self:initSelCardMode(true)

    self._settingData = self:getSetting()
    if true ==  self._settingData.isSoundForbbiden then
        self._bSoundForbbiden = true
    elseif false == self._settingData.isSoundForbbiden then
        self._bSoundForbbiden = false
    end

    if true == self._settingData.singleClk then
        self._bSelCardBySingleClk = true
    elseif false == self._settingData.singleClk then
        self._bSelCardBySingleClk = false
    end

    if self._settingData.musicVolume then
        self._initMusicVolume = self._settingData.musicVolume / 100
    end
    if self._settingData.soundsVolume then
        self._initEffectVolume = self._settingData.soundsVolume / 100
    end

    if self._bSoundForbbiden then
        self._initMusicVolume = 0
        self._initEffectVolume = 0
    end

    if 0 == self._initMusicVolume then
        self._initMusicVolume = 0.5
        self._bMusicOn = false
    end
    if 0 == self._initEffectVolume then
        self._initEffectVolume = 0.5 
        self._bEffectOn = false
    end

    if self._bMusicOn then
        audio.setMusicVolume(self._initMusicVolume)
    else
        audio.setMusicVolume(0)
    end
    if self._bEffectOn then
        audio.setSoundsVolume(self._initEffectVolume)
    else
        audio.setSoundsVolume(0)
    end

    local function onClose()
        self:onClose()
    end
    local buttonClose = self._settingPanel:getChildByName("setting_btn_close")
    if buttonClose then
        buttonClose:addClickEventListener(onClose)
    end

    local function onSelSingleClk()
        self:onSelSingleClk()
    end
    self._btnSelSingleClk = self._settingPanel:getChildByName("setting_btn_click")
    if self._btnSelSingleClk then
        self._btnSelSingleClk:addClickEventListener(onSelSingleClk)

        if self._bSelCardBySingleClk then
            self._btnSelSingleClk:setTouchEnabled(false)
            self._btnSelSingleClk:setBright(false)
        end
    end

    local function onSelDoubleClk()
        self:onSelDoubleClk()
    end
    self._btnSelDoubleClk = self._settingPanel:getChildByName("setting_btn_doubleclk")
    if self._btnSelDoubleClk then
        self._btnSelDoubleClk:addClickEventListener(onSelDoubleClk)

        if not self._bSelCardBySingleClk then
            self._btnSelDoubleClk:setTouchEnabled(false)
            self._btnSelDoubleClk:setBright(false)
        end
    end

    local btnMusic = self._settingPanel:getChildByName("Button_Music")
    if btnMusic then
        self._musicToggle = btnMusic:getChildByName("sp_toggle")
        if self._musicToggle then
            local function onMusicToggleClk()
                self:onMusicToggleClk()
            end
            btnMusic:addClickEventListener(onMusicToggleClk)

            self._musicOnPosX = self._musicToggle:getPositionX()
            self._musicOffPosX = self._musicToggle:getPositionX() + self._musicToggle:getContentSize().width

            if not self._bMusicOn then
                self:toggleMusicBtn(false)
            end
        end
    end

    local btnEffect = self._settingPanel:getChildByName("Button_Effect")
    if btnEffect then
        self._effectToggle = btnEffect:getChildByName("sp_toggle")
        if self._effectToggle then
            local function onEffectToggleClk()
                self:onEffectToggleClk()
            end
            btnEffect:addClickEventListener(onEffectToggleClk)

            self._effectOnPosX = self._effectToggle:getPositionX()
            self._effectOffPosX = self._effectToggle:getPositionX() + self._effectToggle:getContentSize().width

            if not self._bEffectOn then
                self:toggleEffectBtn(false)
            end
        end
    end
end

function BaseGameSetting:initSelCardMode(bSelCardBySingleClk)
    self._bSelCardBySingleClk = bSelCardBySingleClk
end

function BaseGameSetting:onClose()
    self._gameController:playBtnPressedEffect()
    print("onClose")
    self:setVisible(false)
end

function BaseGameSetting:onSelSingleClk()
    self._gameController:playBtnPressedEffect()
    print("onSelSingleClk")
    self._bSelCardBySingleClk = true

    if self._btnSelDoubleClk then
        self._btnSelDoubleClk:setTouchEnabled(true)
        self._btnSelDoubleClk:setBright(true)
    end

    if self._btnSelSingleClk then
        self._btnSelSingleClk:setTouchEnabled(false)
        self._btnSelSingleClk:setBright(false)
    end

    self:saveSetting()
end

function BaseGameSetting:onSelDoubleClk()
    self._gameController:playBtnPressedEffect()
    print("onSelDoubleClk")
    self._bSelCardBySingleClk = false

    if self._btnSelDoubleClk then
        self._btnSelDoubleClk:setTouchEnabled(false)
        self._btnSelDoubleClk:setBright(false)
    end

    if self._btnSelSingleClk then
        self._btnSelSingleClk:setTouchEnabled(true)
        self._btnSelSingleClk:setBright(true)
    end

    self:saveSetting()
end

function BaseGameSetting:isSelCardBySingleClk()
    return self._bSelCardBySingleClk
end

function BaseGameSetting:setVisible(bVisible)
    if self._settingPanel then
        self._settingPanel:setVisible(bVisible)
    end
end

function BaseGameSetting:isVisible()
    if self._settingPanel then
        return self._settingPanel:isVisible()
    end
    return false
end

function BaseGameSetting:showSetting(bShow)
    self:setVisible(bShow)
end

function BaseGameSetting:toggleMusicBtn(bOn)
    if self._musicToggle then
        if bOn then
            self._bSoundForbbiden = false
            self._musicToggle:setPositionX(self._musicOnPosX)
        else
            self._musicToggle:setPositionX(self._musicOffPosX)
        end
    end
end

function BaseGameSetting:toggleEffectBtn(bOn)
    if self._effectToggle then
        if bOn then
            self._bSoundForbbiden = false
            self._effectToggle:setPositionX(self._effectOnPosX)
        else
            self._effectToggle:setPositionX(self._effectOffPosX)
        end
    end
end

function BaseGameSetting:onMusicToggleClk()
    if self._bMusicOn then
        audio.setMusicVolume(0)
    else
        audio.setMusicVolume(self._initMusicVolume)
    end
    self._bMusicOn = not self._bMusicOn
    self:toggleMusicBtn(self._bMusicOn)

    self:saveSetting()
end

function BaseGameSetting:onEffectToggleClk()
    if self._bEffectOn then
        audio.setSoundsVolume(0)
    else
        audio.setSoundsVolume(self._initEffectVolume)
    end
    self._bEffectOn = not self._bEffectOn
    self:toggleEffectBtn(self._bEffectOn)

    self:saveSetting()
end

function BaseGameSetting:saveSetting()
    self._settingData.musicVolume = self._initMusicVolume * 100
    if not self._bMusicOn then
        self._settingData.musicVolume = 0
    end
    self._settingData.soundsVolume = self._initEffectVolume * 100
    if not self._bEffectOn then
        self._settingData.soundsVolume = 0
    end
    self._settingData.isSoundForbbiden = self._bSoundForbbiden
    self._settingData.singleClk = self._bSelCardBySingleClk
    my.saveCache("SettingsData.xml", self._settingData)
end

function BaseGameSetting:getSetting()
    return my.readCache("SettingsData.xml")
end

return BaseGameSetting
