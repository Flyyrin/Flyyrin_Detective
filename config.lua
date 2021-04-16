Config = {
        MenuLanguage = 'en',	
}

    Config.inspectDuration = 10 --seconds
    Config.searchDuration = 5 --seconds

    Config.KeybindKeys = {
        ['Q'] = 44,
        ['G'] = 47,
        ['X'] = 73,
        ['E'] = 38,
        ['H'] = 104,
        ['num9'] = 118
    }
    
Config.Languages = {
    ['en'] = {
        ['not_dead'] = 'Player is not dead.',

        --Causes 
        ['unknown'] = 'Unknown cause.',
        ['fall'] = 'Player fell.',
        ['car'] = 'Playr got hit by a car.',
        ['drown'] = 'Player drowned.',
        ['keys_message'] = 'Press ~INPUT_PICKUP~ to inspect body or ~INPUT_VEH_SHUFFLE~ to search where the damage occured.',
    },

    ['fr'] = {
        ['server_start'] = 'fr',
        ['fall'] = 'Je mappelle fale!',
    },

    ['de'] = {
        ['server_start'] = 'de',
    },

    ['sv'] = {
        ['server_start'] = 'sv',
    },

    ['es'] = {
        ['server_start'] = "es",
    }
}