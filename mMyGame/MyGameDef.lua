
if nil == cc or nil == cc.exports then
    return
end


cc.exports.MyGameDef                        = {
    MY_TOTAL_PLAYERS                        = 2,
    MY_CHAIR_CARDS                          = 32,
    MY_TOTAL_CARDS                          = 72,

    MY_PGCH_DOUBLE                          = 6,

    MY_WAITING_GIVEUP_HU                    = 1000,
    MY_WAITING_MJ_TING                      = 1001,

    --request (from game clients)
    MY_GR_MJ_TING                           = 229610,
    MY_GR_GIVEUP_HU                         = 229619,

    -- nofication (to game client)
    MY_GR_TING_MJ                           = 229611,
    MY_GR_TING_MJ_OTHER                     = 229614,
    
}

return cc.exports.MyGameDef