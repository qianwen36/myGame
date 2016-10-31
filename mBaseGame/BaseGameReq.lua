
local BaseGameReq = {
    ASK_NEWTABLECHAIR={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'nReserved'
        },
        formatKey = '<iiiiiiii',
        deformatKey = '<iiiiiiii',
        maxsize = 32
    },

    ENTER_GAME={
        lengthMap = {
            [7] = 32,
            [9] = {maxlen = 3},
            [11] = {maxlen = 3},
            [14] = {maxlen = 3},
            [24] = 32,
            [25] = 16,
            [35] = {maxlen = 4},
            maxlen = 35
        },
        nameMap = {
            'nUserID',
            'nUserType',
            'nGameID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'szHardID',
            'bLookOn',
            'nReserved',
            'dwUserConfigs',
            'nReserved2',
            'nRoomTokenID',
            'nMbNetType',
            'nReserved3',
            'nUserID1',
            'nUserType1',
            'nStatus',
            'nTableNO1',
            'nChairNO1',
            'nNickSex',
            'nPortrait',
            'nNetSpeed',
            'nClothingID',
            'szUserName',
            'szNickName',
            'nDeposit',
            'nPlayerLevel',
            'nScore',
            'nBreakOff',
            'nWin',
            'nLoss',
            'nStandOff',
            'nBout',
            'nTimeCost',
            'nReserved1'
        },
        formatKey = '<iiiiiiAiiiiLiiiiiiiiiiiiiiiiiAAiiiiiiiiiiiii',
        deformatKey = '<iiiiiiA32iiiiLiiiiiiiiiiiiiiiiiA32A16iiiiiiiiiiiii',
        maxsize = 244
    },

    GAME_ABORT={
        lengthMap = {
            [9] = {maxlen = 3},
            maxlen = 9
        },
        nameMap = {
            'nUserID',
            'nChairNO',
            'bForce',
            'nOldScore',
            'nOldDeposit',
            'nScoreDiff',
            'nDepositDfif',
            'nTableNO',
            'nReserved'
        },
        formatKey = '<iiiiiiiiiii',
        deformatKey = '<iiiiiiiiiii',
        maxsize = 44
    },

    GAME_ENTER_INFO={
        lengthMap = {
            [6] = {maxlen = 8},
            [9] = {maxlen = 7},
            maxlen = 9
        },
        nameMap = {
            'nRoomID',
            'nTableNO',
            'nTotalChair',
            'nBaseScore',
            'nBaseDeposit',
            'dwUserStatus',
            'nBout',
            'nKickOffTime',
            'nReserved'
        },
        formatKey = '<iiiiiLLLLLLLLiiiiiiiii',
        deformatKey = '<iiiiiLLLLLLLLiiiiiiiii',
        maxsize = 88
    },

    GETVERSION={
        lengthMap = {
            [1] = 32,
            [2] = {maxlen = 4},
            maxlen = 2
        },
        nameMap = {
            'szExeName',
            'nReserved'
        },
        formatKey = '<Aiiii',
        deformatKey = '<A32iiii',
        maxsize = 48
    },

    CHECKVERSION={
        lengthMap = {
            [1] = 32,
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'szExeName',
            'nExeMajorVer',
            'nExeMinorVer',
            'nExeBuildno',
            'nReserved'
        },
        formatKey = '<Aiiiiiii',
        deformatKey = '<A32iiiiiii',
        maxsize = 60
    },

    LEAVE_GAME={
        lengthMap = {
            [9] = 32,
            [10] = {maxlen = 4},
            [11] = {maxlen = 4},
            maxlen = 11
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'bPassive',
            'nSendTable',
            'nSendChair',
            'nSendUser',
            'szHardID',
            'nReserved',
            'nReserved1'
        },
        formatKey = '<iiiiiiiiAiiiiiiii',
        deformatKey = '<iiiiiiiiA32iiiiiiii',
        maxsize = 96
    },

    SOLOPLAYER_HEAD={
        lengthMap = {
            [4] = {maxlen = 8},
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nRoomID',
            'nTableNO',
            'nPlayerCount',
            'dwUserStatus',
            'nReserved'
        },
        formatKey = '<iiiLLLLLLLLiiii',
        deformatKey = '<iiiLLLLLLLLiiii',
        maxsize = 60
    },

    SOLO_PLAYER={
        lengthMap = {
            [10] = 32,
            [11] = 16,
            [21] = {maxlen = 4},
            maxlen = 21
        },
        nameMap = {
            'nUserID',
            'nUserType',
            'nStatus',
            'nTableNO',
            'nChairNO',
            'nNickSex',
            'nPortrait',
            'nNetSpeed',
            'nClothingID',
            'szUserName',
            'szNickName',
            'nDeposit',
            'nPlayerLevel',
            'nScore',
            'nBreakOff',
            'nWin',
            'nLoss',
            'nStandOff',
            'nBout',
            'nTimeCost',
            'nReserved'
        },
        formatKey = '<iiiiiiiiiAAiiiiiiiiiiiii',
        deformatKey = '<iiiiiiiiiA32A16iiiiiiiiiiiii',
        maxsize = 136
    },

    START_GAME={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'nReserved'
        },
        formatKey = '<iiiiiiii',
        deformatKey = '<iiiiiiii',
        maxsize = 32
    },

    USER_POSITION={
        lengthMap = {
            [6] = {maxlen = 8},
            [9] = {maxlen = 2},
            maxlen = 9
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'nPlayerCount',
            'dwUserStatus',
            'dwTableStatus',
            'nCountdown',
            'nReserved'
        },
        formatKey = '<iiiiiLLLLLLLLLiii',
        deformatKey = '<iiiiiLLLLLLLLLiii',
        maxsize = 68
    },

    GAME_PULSE={
        lengthMap = {
            [4] = {maxlen = 1},
            maxlen = 4
        },
        nameMap = {
            'nUserID',
            'dwAveDelay',
            'dwMaxDelay',
            'nReserved'
        },
        formatKey = '<iLLi',
        deformatKey = '<iLLi',
        maxsize = 16
    },

    VERSION={
        lengthMap = {
            [4] = {maxlen = 4},
            maxlen = 4
        },
        nameMap = {
            'nMajorVer',
            'nMinorVer',
            'nBuildNO',
            'nReserved'
        },
        formatKey = '<iiiiiii',
        deformatKey = '<iiiiiii',
        maxsize = 28
    },
    
    LEAVE_GAME_TOOFAST={
        lengthMap = {
            --,
            maxlen = 1
        },
        nameMap = {
            'nSecond'
        },
        formatKey = '<i',
        deformatKey = '<i',
        maxsize = 4
    },

    CHAT_TO_TABLE={
        lengthMap = {
            [5] = 32,
            [6] = 64,
            [7] = {maxlen = 4},
            maxlen = 7
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'szHardID',
            'szChatMsg',
            'nReserved'
        },
        formatKey = '<iiiiAAiiii',
        deformatKey = '<iiiiA32A64iiii',
        maxsize = 128
    },

    DEPOSIT_NOT_ENOUGH={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nChairNO',
            'nDeposit',
            'nMinDeposit',
            'nReserved'
        },
        formatKey = '<iiiiiiii',
        deformatKey = '<iiiiiiii',
        maxsize = 32
    },

    DEPOSIT_TOO_HIGH={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nChairNO',
            'nDeposit',
            'nMaxDeposit',
            'nReserved'
        },
        formatKey = '<iiiiiiii',
        deformatKey = '<iiiiiiii',
        maxsize = 32
    },

    SCORE_NOT_ENOUGH={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nChairNO',
            'nScore',
            'nMinScore',
            'nReserved'
        },
        formatKey = '<iiiiiiii',
        deformatKey = '<iiiiiiii',
        maxsize = 32
    },

    SCORE_TOO_HIGH={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nChairNO',
            'nScore',
            'nMaxScore',
            'nReserved'
        },
        formatKey = '<iiiiiiii',
        deformatKey = '<iiiiiiii',
        maxsize = 32
    },

    USER_BOUT_TOO_HIGH={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nChairNO',
            'nBout',
            'nMaxBout',
            'nReserved'
        },
        formatKey = '<iiiiiiii',
        deformatKey = '<iiiiiiii',
        maxsize = 32
    },

    TABLE_BOUT_TOO_HIGH={
        lengthMap = {
            [4] = {maxlen = 4},
            maxlen = 4
        },
        nameMap = {
            'nTableNO',
            'nBout',
            'nMaxBout',
            'nReserved'
        },
        formatKey = '<iiiiiii',
        deformatKey = '<iiiiiii',
        maxsize = 28
    },

    USER_DEPOSITEVENT={
        lengthMap = {
            [7] = {maxlen = 4},
            maxlen = 7
        },
        nameMap = {
            'nUserID',
            'nChairNO',
            'nEvent',
            'nDepositDiff',
            'nDeposit',
            'nBaseDeposit',
            'nReserved'
        },
        formatKey = '<iiiiiiiiii',
        deformatKey = '<iiiiiiiiii',
        maxsize = 40
    },

    LOOK_SAFE_DEPOSIT={
        lengthMap = {
            [4] = 32,
            [5] = {maxlen = 8},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nGameID',
            'dwIPAddr',
            'szHardID',
            'nReserved'
        },
        formatKey = '<iiLAiiiiiiii',
        deformatKey = '<iiLA32iiiiiiii',
        maxsize = 76
    },

    SAFE_DEPOSIT_EX={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 5
        },
        nameMap = {
            'nUserID',
            'nDeposit',
            'bHaveSecurePwd',
            'nRemindDeposit',
            'nReserved'
        },
        formatKey = '<iiliiiii',
        deformatKey = '<iiliiiii',
        maxsize = 32
    },

    TAKESAVE_SAFE_DEPOSIT={
        lengthMap = {
            [13] = 32,
            [18] = {maxlen = 2},
            maxlen = 18
        },
        nameMap = {
            'nUserID',
            'nGameID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'nDeposit',
            'nKeyResult',
            'nPlayingGameID',
            'nGameVID',
            'nTransferTotal',
            'nTransferLimit',
            'dwIPAddr',
            'szHardID',
            'nGameDeposit',
            'dwFlags',
            'llMonthTransferTotal',
            'llMonthTransferLimit',
            'nReserved'
        },
        formatKey = '<iiiiiiiiiiiLAiLddii',
        deformatKey = '<iiiiiiiiiiiLA32iLddii',
        maxsize = 112
    },

    SOLO_TABLE={
        lengthMap = {
            [4] = {maxlen = 8},
            [5] = {maxlen = 5},
            maxlen = 5
        },
        nameMap = {
            'nRoomID',
            'nTableNO',
            'nUserCount',
            'nUserIDs',
            'nReserved'
        },
        formatKey = '<iiiiiiiiiiiiiiii',
        deformatKey = '<iiiiiiiiiiiiiiii',
        maxsize = 64
    },

    GET_TABLE_INFO={
        lengthMap = {
            [6] = {maxlen = 3},
            maxlen = 6
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'dwFlags',
            'nReserved'
        },
        formatKey = '<iiiiLiii',
        deformatKey = '<iiiiLiii',
        maxsize = 32
    },

    ENTER_BKGFKG={
        lengthMap = {
            [7] = {maxlen = 4},
            maxlen = 7
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'nTableNO',
            'nChairNO',
            'dwFlag',
            'nRecordTime',
            'nReserved'
        },
        formatKey = '<iiiiLiiiii',
        deformatKey = '<iiiiLiiiii',
        maxsize = 40
    },

    CHAT_FROM_TABLE={
        lengthMap = {
            [5] = {maxlen = 4},
            maxlen = 6
        },
        nameMap = {
            'nUserID',
            'nRoomID',
            'dwFlags',
            'nHeadLen',
            'nReserved',
            'nMsgLen'
        },
        formatKey = '<iiLiiiiii',
        deformatKey = '<iiLiiiiii',
        maxsize = 36
    },

    SAFE_RNDKEY={
        lengthMap = {
            [3] = {maxlen = 4},
            maxlen = 3
        },
        nameMap = {
            'nUserID',
            'nRndKey',
            'nReserved'
        },
        formatKey = '<iiiiii',
        deformatKey = '<iiiiii',
        maxsize = 24
    },
}

local GamePublicInterface = import("src.app.Game.mMyGame.GamePublicInterface")

if GamePublicInterface and GamePublicInterface:IS_FRAME_1() then
end

return BaseGameReq
