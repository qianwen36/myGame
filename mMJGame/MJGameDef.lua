
if nil == cc or nil == cc.exports then
    return
end


cc.exports.MJGameDef                        = {
    MJ_TOTAL_PLAYERS                        = 4,
    MJ_DICES_FRAME_COUNT                    = 11,
    MJ_MAX_CARDID                           = 144,
    MJ_TOTAL_CARDS                          = 152,
    MJ_CHAIR_CARDS                          = 32,
    MJ_PLAYER_CARDS                         = 14,
    MJ_PLAYER_CASTOFF_CARDS                 = 24,
    MJ_DEAL_CARDS_INTERVAL                  = 0.08,
    MJ_ONCE_DEAL_COUNT                      = 4,

    MJ_PGC_SPACE                            = 5,
    MJ_PGC_HEIGHT_OFFSET                    = 25,
    MJ_CHOSECARDS_SPACE                     = 30,

    MJ_ADD_SECOND_AFTER_GANG                = 3,

    MJ_LAYOUT_MOD                           = 10,
    MJ_MAX_CARDS_LAYOUT_NUM                 = 64,
    MJ_INVALID_OBJECT_ID                    = -1,

    MJ_HU_FANG                              = 0x00000001,
    MJ_HU_ZIMO                              = 0x00000002,
    MJ_HU_QGNG                              = 0x00000004,

    MJ_GW_STANDOFF                          = 0x00000002,
    MJ_GW_FANG                              = 0x01000000,
    MJ_GW_ZIMO                              = 0x02000000,
    MJ_GW_QGNG                              = 0x04000000,
    MJ_GW_MULTI                             = 0x10000000,

    MJ_CT_SHUN                              = 0x00000001,
    MJ_CT_KEZI                              = 0x00000002,
    MJ_CT_DUIZI                             = 0x00000004,
    MJ_CT_GANG                              = 0x00000008,

    MJ_CT_13BK                              = 0x00000020,
    MJ_CT_7FNG                              = 0x00000040,
    MJ_CT_QFNG                              = 0x00000080,
    MJ_CT_258                               = 0x00000100,

    MJ_GF_USE_JOKER                         = 0x00000001,
    MJ_GF_JOKER_PLUS1                       = 0x00000002,
    MJ_GF_BAIBAN_JOKER                      = 0x00000004,
    MJ_GF_JOKER_REVERT                      = 0x00000008,

    MJ_GF_16_CARDS                          = 0x00000010,
    MJ_GF_FENG_CHI                          = 0x00000020,

    MJ_GF_CHI_FORBIDDEN                     = 0x00000100,
    MJ_GF_FANG_FORBIDDEN                    = 0x00000200,
    MJ_GF_QGNG_FORBIDDEN                    = 0x00000400,

    MJ_GF_GANG_MN_ROB                       = 0x00001000,
    MJ_GF_GANG_PN_ROB                       = 0x00002000,
    MJ_GF_NO_GANGROB_BAOTOU                 = 0x00004000,

    MJ_GF_JOKER_SHOWN_SKIP                  = 0x00010000,
    MJ_GF_JOKER_THROWN_PIAO                 = 0x00020000,
    MJ_GF_ONE_THROW_MULTIHU                 = 0x00040000,
    MJ_GF_FEED_UNDERTAKE                    = 0x00080000,

    MJ_GF_7FNG_PURE                         = 0x00400000,

    MJ_GF_JOKER_DIAO_ZIMO                   = 0x01000000,
    MJ_GF_JOKER_DUID_ZIMO                   = 0x02000000,
    MJ_GF_JOKER_QIAN_ZIMO                   = 0x04000000,
    MJ_GF_JOKER_BIAN_ZIMO                   = 0x08000000,

    MJ_GF_DICES_TWICE                       = 0x10000000,
    MJ_GF_ANGANG_SHOW                       = 0x20000000,
    MJ_GF_JOKER_SORTIN                      = 0x40000000,
    MJ_GF_BAIBAN_NOSORT                     = 0x80000000,

    MJ_INDEX_DONGFENG                       = 31,
    MJ_INDEX_NANFENG                        = 32,
    MJ_INDEX_XIFENG                         = 33,
    MJ_INDEX_BEIFENG                        = 34,

    MJ_INDEX_HONGZHONG                      = 35,
    MJ_INDEX_FACAI                          = 36,
    MJ_INDEX_BAIBAN                         = 37,

    MJ_CARD_BACK_ID                         = -2,

    MJ_TYPE_CHI                             = 1,
    MJ_TYPE_ANGANG                          = 2,
    MJ_TYPE_PNGANG                          = 3,
    MJ_TYPE_MNGANG                          = 4,
    MJ_TYPE_PENG                            = 5,

    MJ_CS_WAN                               = 0,
    MJ_CS_TIAO                              = 1,
    MJ_CS_DONG                              = 2,
    MJ_CS_FENG                              = 3,
    MJ_CS_HUA                               = 4,
    MJ_CS_TOTAL                             = 5,

    MJ_PGCH_PENG                            = 1,
    MJ_PGCH_GANG                            = 2,
    MJ_PGCH_CHI                             = 3,
    MJ_PGCH_HU                              = 4,
    MJ_PGCH_GUO                             = 5,

    MJ_PENG                                 = 0x00000001,
    MJ_GANG                                 = 0x00000002,
    MJ_CHI                                  = 0x00000004,
    MJ_HU                                   = 0x00000008,
    MJ_HUA                                  = 0x00000010,
    MJ_GUO                                  = 0x00000020,

    MJ_GANG_MN                              = 0x00000001,
    MJ_GANG_PN                              = 0x00000002,
    MJ_GANG_AN                              = 0x00000004,

    MJ_WAITING_THROW_CARDS                  = 100,
    MJ_WAITING_CATCH_CARDS                  = 101,
    MJ_WAITING_HUA_CARDS                    = 102,
    MJ_WAITING_PENG_CARDS                   = 103,
    MJ_WAITING_MNGANG_CARDS                 = 104,
    MJ_WAITING_PNGANG_CARDS                 = 105,
    MJ_WAITING_ANGANG_CARDS                 = 106,
    MJ_WAITING_CHI_CARDS                    = 107,
    MJ_WAITING_HU_CARDS                     = 108,

    MJ_SYSMSG_BEGIN                         = 19840323,
    MJ_SYSMSG_RETURN_GAME                   = 19840324,
    MJ_SYSMSG_PLAYER_ONLINE                 = 19840325,
    MJ_SYSMSG_GAME_CLOCK_STOP               = 19840327,

    MJ_SYSMSG_RETURN_GAME                   = 1,
    MJ_SYSMSG_PLAYER_OUT_LINE               = 2,

    --request (from game clients)
    MJ_GR_THROW_CARDS                       = 222080,
    MJ_GR_CATCH_CARD                        = 229000,
    MJ_GR_GUO_CARD                          = 229005,
    MJ_GR_PREPENG_CARD                      = 229010,
    MJ_GR_PREGANG_CARD                      = 229015,
    MJ_GR_PRECHI_CARD                       = 229020,

    MJ_GR_PENG_CARD                         = 229025,
    MJ_GR_CHI_CARD                          = 229030,
    MJ_GR_MN_GANG_CARD                      = 229045,
    MJ_GR_AN_GANG_CARD                      = 229047,
    MJ_GR_PN_GANG_CARD                      = 229049,
    MJ_GR_HUA_CARD                          = 229060,

    MJ_GR_HU_CARD                           = 229080,
    MJ_GR_NO_CARD_CATCH                     = 229101,

    MJ_GR_GAMEDATA_ERROR                    = 229450,
    MJ_GR_SYSTEMMSG                         = 229500,
    MJ_GR_SENDMSG_TO_SERVER                 = 229510,

    --response (to game clients)
    MJ_GR_HU_GAINS_LESS                     = 229100,
    MJ_GR_NO_CARD_CATCH                     = 229101,

    -- nofication (to game client)
    MJ_GR_GAME_START                        = 211040,
    MJ_GR_GAME_WIN                          = 211080,

    MJ_GR_CARDS_THROW                       = 222170,
    MJ_GR_CARD_CAUGHT                       = 229160,
    MJ_GR_CARD_GUO                          = 229165,
    MJ_GR_CARD_PREPENG                      = 229170,
    MJ_GR_CARD_PRECHI                       = 229175,
    MJ_GR_PREGANG_OK                        = 229180,
    MJ_GR_CARD_PENG                         = 229185,
    MJ_GR_CARD_CHI                          = 229190,
    MJ_GR_CARD_MN_GANG                      = 229195,
    MJ_GR_CARD_AN_GANG                      = 229197,
    MJ_GR_CARD_PN_GANG                      = 229199,
    MJ_GR_CARD_HUA                          = 229210,
}


local GamePublicInterface = import("..mMyGame.GamePublicInterface")

if GamePublicInterface and GamePublicInterface:IS_FRAME_1() then
    cc.exports.MJGameDef.MJ_GR_THROW_CARDS = 212080
end

return cc.exports.MJGameDef
