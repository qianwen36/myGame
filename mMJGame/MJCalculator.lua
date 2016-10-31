
if nil == cc or nil == cc.exports then
    return
end


require("src.cocos.cocos2d.bitExtend")

local MJGameDef                                 = import("src.app.Game.mMJGame.MJGameDef")

cc.exports.MJCalculator                         = {}
local MJCalculator                              = cc.exports.MJCalculator




function MJCalculator:IS_BIT_SET(flag, mybit) return (mybit == bit._and(mybit, flag)) end

function MJCalculator:MJ_CalculateCardShap(cardID, gameFlags)
    if 0 <= cardID and 36 > cardID then
        return 0    -- WAN
    elseif 36 <= cardID and 72 > cardID then
        return 1    -- TIAO
    elseif 72 <= cardID and 108 > cardID then
        return 2    -- DONG
    elseif 108 <= cardID and 136 > cardID then
        return 3    -- FENG
    elseif 136 <= cardID and 152 > cardID then
        return 4    -- HUA
    else
        return -1
    end
end

function MJCalculator:MJ_CalculateCardValue(cardID, gameFlags)
    if 0 <= cardID and 108 > cardID then
        return cardID % 9 + 1
    elseif 108 <= cardID and 136 > cardID then
        return (cardID - 108) % 7 + 1
    elseif 136 <= cardID and 152 > cardID then
        return cardID - 136 + 1
    else
        return 0
    end
end

function MJCalculator:MJ_CalculateCardShapEx(cardID)
    return self:MJ_CalculateCardShap(cardID, 0)
end

function MJCalculator:MJ_CalculateCardValueEx(cardID)
    return self:MJ_CalculateCardValue(cardID, 0)
end

function MJCalculator:MJ_CalcIndexByID(cardID, gameFlags)
    return self:MJ_CalculateCardShap(cardID, gameFlags) * MJGameDef.MJ_LAYOUT_MOD + self:MJ_CalculateCardValue(cardID, gameFlags)
end

function MJCalculator:MJ_IsSameCard(cardID1, cardID2, gameFlags)
    return (self:MJ_CalcIndexByID(cardID1, gameFlags) == self:MJ_CalcIndexByID(cardID2, gameFlags))
end

function MJCalculator:MJ_IsHuaEx(cardID, jokerID, jokerID2, gameFlags)
    local index = self:MJ_CalcIndexByID(cardID, gameFlags)
    return self:MJ_IsHua(index, jokerID, jokerID2, gameFlags)
end

function MJCalculator:MJ_IsFengEx(cardID, jokerID, jokerID2, gameFlags)
    local index = self:MJ_CalcIndexByID(cardID, gameFlags)
    return self:MJ_IsFeng(index, jokerID, jokerID2, gameFlags)
end

function MJCalculator:MJ_IsFengDxnbEx(cardID, gameFlags)
    local index = self:MJ_CalcIndexByID(cardID, gameFlags)
    return self:MJ_IsFengDnxb(index, gameFlags)
end

function MJCalculator:MJ_IsFengZfbEx(cardID, gameFlags)
    local index = self:MJ_CalcIndexByID(cardID, gameFlags)
    return self:MJ_IsFengZfb(index, gameFlags)
end

function MJCalculator:MJ_IsBaibanEx(cardID, jokerID, jokerID2, gameFlags)
    local index = self:MJ_CalcIndexByID(cardID, gameFlags)
    return self:MJ_IsBaiban(index, jokerID, jokerID2, gameFlags)
end

function MJCalculator:MJ_IsHua(index, jokerID, jokerID2, gameFlags)
    return index / MJGameDef.MJ_LAYOUT_MOD >= MJGameDef.MJ_CS_HUA
end

function MJCalculator:MJ_IsFeng(index, jokerID, jokerID2, gameFlags)
    return self:MJ_IsFengDnxb(index, gameFlags) or self:MJ_IsFengZfb(index, gameFlags)
end

function MJCalculator:MJ_IsFengDnxb(index, gameFlags)
    if index == MJGameDef.MJ_INDEX_DONGFENG     or
        index == MJGameDef.MJ_INDEX_NANFENG     or
        index == MJGameDef.MJ_INDEX_XIFENG      or
        index == MJGameDef.MJ_INDEX_BEIFENG     then
        return true
    end
    return false
end

function MJCalculator:MJ_IsFengZfb(index, gameFlags)
    if index == MJGameDef.MJ_INDEX_HONGZHONG    or
        index == MJGameDef.MJ_INDEX_FACAI       or
        index == MJGameDef.MJ_INDEX_BAIBAN      then
        return true
    end
    return false
end

function MJCalculator:MJ_IsBaiban(index, jokerID, jokerID2, gameFlags)
    if self:MJ_GetBaibanEx(jokerID, jokerID2, gameFlags) == index then
        return true
    end
    return false
end

function MJCalculator:MJ_IsJokerEx(cardID, jokerID, jokerID2, gameFlags)
    if cardID < 0 then return false end

    local index = self:MJ_CalcIndexByID(cardID, gameFlags)
    return self:MJ_IsJoker(index, jokerID, jokerID2, gameFlags)
end

function MJCalculator:MJ_IsJoker(index, jokerID, jokerID2, gameFlags)
    if index <= 0 then return false end

    if not self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER) or MJGameDef.MJ_INVALID_OBJECT_ID == jokerID then
        return false
    end

    local shape = index / MJGameDef.MJ_LAYOUT_MOD
    local value = index % MJGameDef.MJ_LAYOUT_MOD

    local j_shape = self:MJ_CalculateCardShap(jokerID, gameFlags)
    local j_value = self:MJ_CalculateCardValue(jokerID, gameFlags)

    local j_shape2 = self:MJ_CalculateCardShap(jokerID2, gameFlags)
    local j_value2 = self:MJ_CalculateCardValue(jokerID2, gameFlags)

    if jokerID > -1 and shape == j_shape and value == j_value then
        return true
    end

    if jokerID2 > -1 and shape == j_shape2 and value == j_value2 then
        return true
    end

    return false
end

function MJCalculator:XygInitChairCards(cardIDs, cardsLen)
    for i = 1, cardsLen do
        cardIDs[i] = MJGameDef.MJ_INVALID_OBJECT_ID
    end
end

function MJCalculator:XygZeroLays(lay, len)
    for i = 1, len do
        lay[i] = 0
    end
end

function MJCalculator:XygCopyLays(layFrom, len, layTo)
    for i = 1, len do
        if layFrom[i] then
            layTo[i] = layFrom[i]
        end
    end
end

function MJCalculator:MJ_LayCards(cardIDs, cardsLen, cardsLay, gameFlags)
    local layCardsCount = 0
    for i = 1, cardsLen do
        if not cardIDs[i] then break end

        if cardIDs[i] > -1 then
            local shape = self:MJ_CalculateCardShap(cardIDs[i], gameFlags)
            local value = self:MJ_CalculateCardValue(cardIDs[i], gameFlags)
            local lay = cardsLay[shape * MJGameDef.MJ_LAYOUT_MOD + value]
            cardsLay[shape * MJGameDef.MJ_LAYOUT_MOD + value] = lay + 1

            layCardsCount = layCardsCount + 1
        end
    end
    return layCardsCount
end

function MJCalculator:MJ_DrawSameCards(cardIDs, cardsLen, cardID, resultIDs, count, gameFlags)
    local sameCardsCount = 0
    for i = 1, cardsLen do
        if not cardIDs[i] then break end

        if cardIDs[i] > -1 then
            if self:MJ_IsSameCard(cardIDs[i], cardID, gameFlags) then
                sameCardsCount = sameCardsCount + 1
                resultIDs[sameCardsCount] = cardIDs[i]

                if sameCardsCount >= count then
                    break
                end
            end
        end
    end
    return sameCardsCount
end

function MJCalculator:MJ_DrawCardsByIndex(cardIDs, cardsLen, index, resultIDs, count, gameFlags)
    local sameCardsCount = 0
    for i = 1, cardsLen do
        if not cardIDs[i] then break end

        if cardIDs[i] > -1 then
            if index == self:MJ_CalcIndexByID(cardIDs[i], gameFlags) then
                sameCardsCount = sameCardsCount + 1
                resultIDs[sameCardsCount] = cardIDs[i]

                if sameCardsCount >= count then
                    break
                end
            end
        end
    end
    return sameCardsCount
end

function MJCalculator:MJ_JoinCard(lay, cardID, jokerID, jokerID2, gameFlags, to_revert_joker)
    local shape = self:MJ_CalculateCardShap(cardID, gameFlags)
    local value = self:MJ_CalculateCardValue(cardID, gameFlags)

    local j_index, j_index2 = self:MJ_GetJokerIndex(jokerID, jokerID2, gameFlags)

    local addpos = 0
    if MJGameDef.INVALID_OBJECT_ID ~= shape and 0 ~= value then
        addpos = shape * MJGameDef.MJ_LAYOUT_MOD + value
        lay[addpos] = lay[addpos] + 1
    end

    local jokernum = 0
    local jokernum2 = 0

    if self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER) then
        if not self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_JOKER_REVERT) or not to_revert_joker then
            if jokerID >= 0 then
                jokernum = jokernum + lay[j_index]
                lay[j_index] = 0
            end
            if jokerID2 >= 0 then
                jokernum2 = jokernum2 + lay[j_index2]
                lay[j_index2] = 0
            end
        end
        if self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_BAIBAN_JOKER) then
            local baiban_idx = self:MJ_GetBaibanEx(jokerID, jokerID2, gameFlags)
            local baiban_num = lay[baiban_idx]
            lay[j_index] = baiban_num
            lay[baiban_idx] = 0
        end
    end

    return jokernum, jokernum2, addpos
end

function MJCalculator:MJ_GetBaibanEx(jokerID, jokerID2, gameFlags)
    local j_shape = self:MJ_CalculateCardShap(jokerID, gameFlags)
    local j_value = self:MJ_CalculateCardValue(jokerID, gameFlags)

    local j_shape2 = self:MJ_CalculateCardShap(jokerID2, gameFlags)
    local j_value2 = self:MJ_CalculateCardValue(jokerID2, gameFlags)

    local jokeridx = 0
    if j_shape >= 0 and j_value > 0 then
        jokeridx = j_shape * MJGameDef.MJ_LAYOUT_MOD + j_value
    end
    local jokeridx2 = 0
    if j_shape2 >= 0 and j_value2 > 0 then
        jokeridx2 = j_shape2 * MJGameDef.MJ_LAYOUT_MOD + j_value2
    end

    return self:MJ_GetBaiban(jokerID, jokerID2, gameFlags)
end

function MJCalculator:MJ_GetBaiban(jokerID, jokerID2, gameFlags)
    return MJGameDef.MJ_INDEX_BAIBAN
end

function MJCalculator:MJ_CanShunAsJoined(lay, addpos, jokerID, jokerID2, gameFlags)
    if self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_BAIBAN_JOKER) then
        if addpos == self:MJ_GetBaibanEx(jokerID, jokerID2, gameFlags) then
            local j_shape = self:MJ_CalculateCardShap(jokerID, gameFlags)
            local j_value = self:MJ_CalculateCardValue(jokerID, gameFlags)
            addpos = self:MJ_CalcJokerIndex(j_shape, j_value)
        end
    end
    if not self:MJ_IsFeng(addpos, jokerID, jokerID2, gameFlags) then
        return  self:MJ_CanShunAsJoined_Normal(lay, addpos, jokerID, jokerID2, gameFlags)
    elseif self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_FENG_CHI) then
        return  self:MJ_CanShunAsJoined_Feng(lay, addpos, jokerID, jokerID2, gameFlags)
    end
    return 0
end

function MJCalculator:MJ_CanShunAsJoined_Normal(lay, addpos, jokerID, jokerID2, gameFlags)
    if addpos % MJGameDef.MJ_LAYOUT_MOD == 1 then
        if 0 < lay[addpos] and 0 < lay[addpos + 1] and 0 < lay[addpos + 2] then
            return MJGameDef.MJ_CT_SHUN
        end
    elseif addpos % MJGameDef.MJ_LAYOUT_MOD == 2 then
        if 0 < lay[addpos - 1] and 0 < lay[addpos] and 0 < lay[addpos + 1] then
            return MJGameDef.MJ_CT_SHUN
        elseif 0 < lay[addpos] and 0 < lay[addpos + 1] and 0 < lay[addpos + 2] then
            return MJGameDef.MJ_CT_SHUN
        end
    elseif addpos % MJGameDef.MJ_LAYOUT_MOD == 8 then
        if 0 < lay[addpos - 1] and 0 < lay[addpos] and 0 < lay[addpos + 1] then
            return MJGameDef.MJ_CT_SHUN
        elseif 0 < lay[addpos - 2] and 0 < lay[addpos - 1] and 0 < lay[addpos] then
            return MJGameDef.MJ_CT_SHUN
        end
    elseif addpos % MJGameDef.MJ_LAYOUT_MOD == 9 then
        if 0 < lay[addpos - 2] and 0 < lay[addpos - 1] and 0 < lay[addpos] then
            return MJGameDef.MJ_CT_SHUN
        end
    else
        if 0 < lay[addpos - 2] and 0 < lay[addpos - 1] and 0 < lay[addpos] then
            return MJGameDef.MJ_CT_SHUN
        elseif 0 < lay[addpos - 1] and 0 < lay[addpos] and 0 < lay[addpos + 1] then
            return MJGameDef.MJ_CT_SHUN
        elseif 0 < lay[addpos] and 0 < lay[addpos + 1] and 0 < lay[addpos + 2] then
            return MJGameDef.MJ_CT_SHUN
        end
    end
    return 0
end

function MJCalculator:MJ_CanShunAsJoined_Feng(lay, addpos, jokerID, jokerID2, gameFlags)
    if MJGameDef.IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_FENG_CHI) then
        local layCards = {}
        self:XygZeroLays(layCards, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)

        local startIndex = 0
        local endIndex = 0
        if addpos >= MJGameDef.MJ_INDEX_DONGFENG and addpos <= MJGameDef.MJ_INDEX_BEIFENG then
            startIndex = MJGameDef.MJ_INDEX_DONGFENG
            endIndex = MJGameDef.MJ_INDEX_BEIFENG
        else
            startIndex = MJGameDef.MJ_INDEX_HONGZHONG
            endIndex = MJGameDef.MJ_INDEX_BAIBAN
        end

        for i = startIndex, endIndex do
            if i ~= addpos then
                if lay[i] then
                    layCards[i] = 1
                end
            end
        end
        if self:XygCardRemains(layCards) >= 2 then
            return MJGameDef.MJ_CT_SHUN
        end
    end
    return 0
end

function MJCalculator:XygCardRemains(lay, layLen)
    local sum = 0
    for i = 1, layLen do
        sum = sum + lay[i]
    end
    return sum
end

function MJCalculator:MJ_GetJokerIndex(jokerID, jokerID2, gameFlags)
    local jokeridx = 0
    local jokeridx2 = 0
    local count = 0
    if jokerID > -1 then
        local j_shape = self:MJ_CalculateCardShap(jokerID, gameFlags)
        local j_value = self:MJ_CalculateCardValue(jokerID, gameFlags)
        jokeridx = self:MJ_CalcJokerIndex(j_shape, j_value)
        count = count + 1
    end
    if jokerID2 >= 0 then
        local j_shape2 = self:MJ_CalculateCardShap(jokerID2, gameFlags)
        local j_value2 = self:MJ_CalculateCardValue(jokerID2, gameFlags)
        jokeridx2 = self:MJ_CalcJokerIndex(j_shape2, j_value2)
        count = count + 1
    end
    return count, jokeridx, jokeridx2
end

function MJCalculator:MJ_CalcJokerIndex(j_shape, j_value)
    if j_shape >=0 and j_value > 0 then
        return j_shape * MJGameDef.MJ_LAYOUT_MOD + j_value
    else
        return 0
    end
end

function MJCalculator:MJ_CanPengEx(cardIDs, cardsLen, cardID ,jokerID, jokerID2, gameFlags, resultIDs)
    self:XygInitChairCards(resultIDs, cardsLen)

    local lay = {}
    self:XygZeroLays(lay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)

    self:MJ_LayCards(cardIDs, cardsLen, lay, gameFlags)

    local dwResult = self:MJ_CanPeng(lay, cardID, jokerID, jokerID2, gameFlags)
    if 0 < dwResult then
        self:MJ_DrawSameCards(cardIDs, cardsLen, cardID, resultIDs, 2, gameFlags)
    end
    return dwResult
end

function MJCalculator:MJ_CanPeng(cardsLay, cardID, jokerID, jokerID2, gameFlags)
    if self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER) then
        if self:MJ_IsJokerEx(cardID, jokerID, jokerID2, gameFlags) then
            if not self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_JOKER_REVERT) then
                return 0
            end
        end
    end

    local shape = self:MJ_CalculateCardShap(cardID, gameFlags)
    local value = self:MJ_CalculateCardValue(cardID, gameFlags)
    if cardsLay[shape * MJGameDef.MJ_LAYOUT_MOD + value] >= 2 then
        return MJGameDef.MJ_PENG
    end
    return 0
end

function MJCalculator:MJ_CanChiEx(cardIDs, cardsLen, cardID ,jokerID, jokerID2, gameFlags, resultIDs)
    self:XygInitChairCards(resultIDs, cardsLen)

    local lay = {}
    self:XygZeroLays(lay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)

    self:MJ_LayCards(cardIDs, cardsLen, lay, gameFlags)

    local dwResult = self:MJ_CanChi(lay, cardID, jokerID, jokerID2, gameFlags)
    if 0 < dwResult then
        local count = 1
        for i = 1, cardsLen do
            if cardIDs[i] and cardIDs[i] > -1 then
                for j = i + 1, cardsLen do
                    if cardIDs[j] and cardIDs[j] > -1 then
                        local id1 = cardIDs[i]
                        local id2 = cardIDs[j]

                        self:XygZeroLays(lay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)
                        local index1 = self:MJ_CalcIndexByID(id1, gameFlags)
                        local index2 = self:MJ_CalcIndexByID(id2, gameFlags)
                        lay[self:MJ_CalcIndexByID(id1, gameFlags)] = lay[self:MJ_CalcIndexByID(id1, gameFlags)] + 1
                        lay[self:MJ_CalcIndexByID(id2, gameFlags)] = lay[self:MJ_CalcIndexByID(id2, gameFlags)] + 1

                        if 0 < self:MJ_CanChi(lay, cardID, jokerID, jokerID2, gameFlags) then
                            resultIDs[count] = id1
                            resultIDs[count + 1] = id2
                            count = count + 2
                        end
                    end
                end
            end
        end
    end

    return dwResult
end

function MJCalculator:MJ_CanChi(cardsLay, cardID, jokerID, jokerID2, gameFlags)
    if self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_CHI_FORBIDDEN) then return 0 end

    if self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER) then
        if self:MJ_IsJokerEx(cardID, jokerID, jokerID2, gameFlags) then
            if not self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_JOKER_REVERT) then
                return 0
            end
        end
    end

    local shape = self:MJ_CalculateCardShap(cardID, gameFlags)
    local value = self:MJ_CalculateCardValue(cardID, gameFlags)

    local use_joker = self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER)
    local baiban_joker = self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_BAIBAN_JOKER)
    local joker_revert = self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_JOKER_REVERT)
    local feng_chi = self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_FENG_CHI)

    local lay = {}
    self:XygCopyLays(cardsLay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM, lay)

    if not feng_chi and not joker_revert and not baiban_joker and not use_joker then    -- 0000
    elseif not feng_chi and not joker_revert and not baiban_joker and use_joker then    -- 0001
    elseif not feng_chi and not joker_revert and baiban_joker and not use_joker then    -- 0010
        return 0
    elseif not feng_chi and not joker_revert and baiban_joker and use_joker then        -- 0011
    elseif not feng_chi and joker_revert and not baiban_joker and not use_joker then    -- 0100
        return 0
    elseif not feng_chi and joker_revert and not baiban_joker and use_joker then        -- 0101
    elseif not feng_chi and joker_revert and baiban_joker and not use_joker then        -- 0110
        return 0
    elseif not feng_chi and joker_revert and baiban_joker and use_joker then            -- 0111
    elseif feng_chi and not joker_revert and not baiban_joker and not use_joker then    -- 1000
    elseif feng_chi and not joker_revert and not baiban_joker and use_joker then        -- 1001
    elseif feng_chi and not joker_revert and baiban_joker and not use_joker then        -- 1010
        return 0
    elseif feng_chi and not joker_revert and baiban_joker and use_joker then            -- 1011
        return 0
    elseif feng_chi and joker_revert and not baiban_joker and not use_joker then        -- 1100
        return 0
    elseif feng_chi and joker_revert and not baiban_joker and use_joker then            -- 1101
    elseif feng_chi and joker_revert and baiban_joker and not use_joker then            -- 1110
        return 0
    elseif feng_chi and joker_revert and baiban_joker and use_joker then                -- 1111
        return 0
    end

    local joker_num, joker_num2, addpos = self:MJ_JoinCard(lay, cardID, jokerID, jokerID2, gameFlags, true)
    if 0 < self:MJ_CanShunAsJoined(lay, addpos, jokerID, jokerID2, gameFlags) then
        return MJGameDef.MJ_CHI
    end
    return 0
end

function MJCalculator:MJ_CanMnGangEx(cardIDs, cardsLen, cardID ,jokerID, jokerID2, gameFlags, resultIDs)
    self:XygInitChairCards(resultIDs, cardsLen)

    local lay = {}
    self:XygZeroLays(lay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)

    self:MJ_LayCards(cardIDs, cardsLen, lay, gameFlags)

    local dwResult = self:MJ_CanMnGang(lay, cardID, jokerID, jokerID2, gameFlags)
    if 0 < dwResult then
        self:MJ_DrawSameCards(cardIDs, cardsLen, cardID, resultIDs, 3, gameFlags)
    end
    return dwResult
end

function MJCalculator:MJ_CanMnGang(cardsLay, cardID, jokerID, jokerID2, gameFlags)
    if self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER) then
        if self:MJ_IsJokerEx(cardID, jokerID, jokerID2, gameFlags) then
            if not self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_JOKER_REVERT) then
                return 0
            end
        end
    end

    local shape = self:MJ_CalculateCardShap(cardID, gameFlags)
    local value = self:MJ_CalculateCardValue(cardID, gameFlags)
    if cardsLay[shape * MJGameDef.MJ_LAYOUT_MOD + value] >= 3 then
        return MJGameDef.MJ_GANG
    end
    return 0
end

function MJCalculator:MJ_CanGangSelfEx(cardIDs, cardsLen ,jokerID, jokerID2, gameFlags, resultIDs)
    return 0 < self:MJ_CanAnGangEx(cardIDs, cardsLen, -1, jokerID, jokerID2, gameFlags, resultIDs)
end

function MJCalculator:MJ_CanAnGangEx(cardIDs, cardsLen, cardID ,jokerID, jokerID2, gameFlags, resultIDs)
    self:XygInitChairCards(resultIDs, cardsLen)

    local lay = {}
    self:XygZeroLays(lay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)

    self:MJ_LayCards(cardIDs, cardsLen, lay, gameFlags)

    local dwResult = self:MJ_CanAnGang(lay, cardID, jokerID, jokerID2, gameFlags)
    if 0 < dwResult then
        local anGangCount = 0
        local anGangIndexList = {}
        for i = 1, cardsLen do
            if cardIDs[i] and cardIDs[i] > -1 then
                local cardIndex = self:MJ_CalcIndexByID(cardIDs[i], gameFlags)
                local bCardIndexExist = false
                for j = 1, anGangCount do
                    if anGangIndexList[j] == cardIndex then
                        bCardIndexExist = true
                        break
                    end
                end

                if not bCardIndexExist then
                    local sameIDs = {}
                    local sameCardsCount = self:MJ_DrawCardsByIndex(cardIDs, cardsLen, cardIndex, sameIDs, 4, gameFlags)
                    if 4 <= sameCardsCount then
                        for k = 1, 4 do
                            resultIDs[anGangCount * 4 + k] = sameIDs[k]
                        end

                        anGangCount = anGangCount + 1
                        anGangIndexList[anGangCount] = cardIndex
                    end
                end
            end
        end
    end
    return dwResult
end

function MJCalculator:MJ_CanAnGang(cardsLay, cardID, jokerID, jokerID2, gameFlags)
    for i = 1, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM do
        if 4 == cardsLay[i] then
            if not self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER) or
               self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_JOKER_REVERT) or
               self:MJ_IsJoker(i, jokerID, jokerID2, gameFlags) then
                return MJGameDef.MJ_GANG
            end
        end
    end
    return 0
end

function MJCalculator:MJ_CanPnGangEx(pengCardIDs, cardsLen, handCardIDs ,jokerID, jokerID2, gameFlags, resultIDs)
    self:XygInitChairCards(resultIDs, cardsLen)

    local dwResult = 0
    for i = 1, #pengCardIDs, 3 do
        local lay = {}
        self:XygZeroLays(lay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)
        lay[self:MJ_CalcIndexByID(pengCardIDs[i], gameFlags)] = 3

        for j = 1, cardsLen do
            if handCardIDs[j] and handCardIDs[j] > -1 then
                dwResult = self:MJ_CanPnGang(lay, handCardIDs[j], jokerID, jokerID2, gameFlags)
                if 0 < dwResult then
                    break
                end
            end
        end

        if 0 < dwResult then
            break
        end
    end
    
    if 0 < dwResult then
        local resultIndex = 1

        for i = 1, #pengCardIDs, 3 do
            local lay = {}
            self:XygZeroLays(lay, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM)
            lay[self:MJ_CalcIndexByID(pengCardIDs[i], gameFlags)] = 3

            for j = 1, cardsLen do
                if handCardIDs[j] and handCardIDs[j] > -1 then
                    if 0 < self:MJ_CanPnGang(lay, handCardIDs[j], jokerID, jokerID2, gameFlags) then
                        resultIDs[resultIndex] = pengCardIDs[i]
                        resultIDs[resultIndex + 1] = pengCardIDs[i + 1]
                        resultIDs[resultIndex + 2] = pengCardIDs[i + 2]
                        resultIDs[resultIndex + 3] = handCardIDs[j]
                        resultIndex = resultIndex + 4
                    end
                end
            end
        end
    end

    return dwResult
end

function MJCalculator:MJ_CanPnGang(cardsLay, cardID, jokerID, jokerID2, gameFlags)
    for i = 1, MJGameDef.MJ_MAX_CARDS_LAYOUT_NUM do
        if 3 == cardsLay[i] and i == self:MJ_CalcIndexByID(cardID, gameFlags) then
            if not self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_USE_JOKER) or
                self:IS_BIT_SET(gameFlags, MJGameDef.MJ_GF_JOKER_REVERT) or
                self:MJ_IsJoker(i, jokerID, jokerID2, gameFlags) then
                return MJGameDef.MJ_GANG
            end
        end
    end
    return 0
end

return MJCalculator
