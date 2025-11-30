local cardTypes = require("src.game.constants.card_types")

local CharacterCards = { data = {
    {
        NAME = "cowboy",
        FILE_NAME = "cowboy",
        TYPE = cardTypes.CHARACTER
    },
    {
        NAME = "saloon_girl",
        FILE_NAME = "saloon_girl",
        TYPE = cardTypes.CHARACTER
    },
    {
        NAME = "lowly_outlaw",
        FILE_NAME = "lowly_outlaw",
        TYPE = cardTypes.CHARACTER
    }
}}

return CharacterCards
