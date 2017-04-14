
local MJGameUtilsInfoManager = import("..mMJGame.MJGameUtilsInfoManager")
local MyGameUtilsInfoManager = class("MyGameUtilsInfoManager", MJGameUtilsInfoManager)

function MyGameUtilsInfoManager:getQuan()       if self._utilsStartData then return self._utilsStartData.nQuan      end end
function MyGameUtilsInfoManager:isLian()        if self._utilsStartData then return self._utilsStartData.bLian == 1 end end

function MyGameUtilsInfoManager:setStartInfoFromTableInfo(tableInfo)
    self._utilsStartData.nQuan = tableInfo.nQuan
    self._utilsStartData.bLian = tableInfo.bLian

    MyGameUtilsInfoManager.super.setStartInfoFromTableInfo(self, tableInfo)
end

return MyGameUtilsInfoManager
