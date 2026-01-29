BalatroTCG.BalancePatchObject = SMODS.GameObject:extend{
    
    description_override = {
        balanced = true,
        none = true,
    },

    register = function(self)
        if self.obj_table[self.key_override] then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key_override), self.set)
            return
        end
        self.obj_table[self.key_override] = self
        self.obj_buffer[#self.obj_buffer] = self
        self.order = #self.obj_buffer
        self.registered = true
    end,
    modify = function(self, balanced)
        
    end,
    ai_calculate = function(self, context, balanced)
        
    end
}

BalatroTCG.DeckDataTable = {}
BalatroTCG.DeckData = BalatroTCG.BalancePatchObject:extend{
    obj_table = BalatroTCG.DeckDataTable,
    obj_buffer = {},
    set = 'DeckData',
    required_params = {
        'key_override',
        'background',
        'ui',
        'icon_pos',
    },
    icon_atlas = 'tcgb_player_blinds',

    tcg_back_cost = 0,

    get = function(name)
        return BalatroTCG.DeckDataTable[name] or BalatroTCG.DeckDataTable['unknown']
    end,
    loc_vars = function(self)
        
    end,
    get_cost = function(self) return 0 end,
    get_params = function(self, default_params, full_list)
        
    end,
    get_limits = function(self, default_limits)
        
    end,
}
BalatroTCG.JokerMods = {}
BalatroTCG.JokerMod = BalatroTCG.BalancePatchObject:extend{
    obj_table = BalatroTCG.JokerMods,
    obj_buffer = {},
    set = 'JokerMod',
    required_params = {
        'key_override',
    },

    --[[
    calculate_context = function(self, context, balanced)

    end,
    loc_vars = function(card, balance)
        
    end,
    ]]
    get_cost = function(original, balanced) return original end,
}
BalatroTCG.ConsumeableMods = {}
BalatroTCG.ConsumeableMod = BalatroTCG.BalancePatchObject:extend{
    obj_table = BalatroTCG.ConsumeableMods,
    obj_buffer = {},
    set = 'ConsumeableMod',
    required_params = {
        'key_override',
    },

    use_consumeable = function(card, area, copier, balanced, original_func)
        original_func(card, area, copier)
    end,
    --[[
    loc_vars = function(card, balance)
        
    end,
    ]]
    get_cost = function(original, balanced) return original end,
}
BalatroTCG.EnahncementMods = {}
BalatroTCG.EnahncementMod = BalatroTCG.BalancePatchObject:extend{
    obj_table = BalatroTCG.EnahncementMods,
    obj_buffer = {},
    set = 'EnahncementMod',
    required_params = {
        'key_override',
    },

    use_consumeable = function(card, area, copier, balanced, original_func)
        original_func(card, area, copier)
    end,
    --[[
    loc_vars = function(card, balance)
        
    end,
    ]]
    get_cost = function(original, balanced) return original end,
}
BalatroTCG.VoucherMods = {}
BalatroTCG.VoucherMod = BalatroTCG.BalancePatchObject:extend{
    obj_table = BalatroTCG.VoucherMods,
    obj_buffer = {},
    set = 'VoucherMod',
    required_params = {
        'key_override',
    },

    redeem = function(card, balanced, original_func)
        original_func(card)
    end,
    --[[
    loc_vars = function(card, balance)
        
    end,
    ]]
    get_cost = function(original, balanced) return original end,
}
BalatroTCG.SealMods = {}
BalatroTCG.SealMod = BalatroTCG.BalancePatchObject:extend{
    obj_table = BalatroTCG.SealMods,
    obj_buffer = {},
    set = 'SealMod',
    required_params = {
        'key_override',
    },

    --[[
    calculate_context = function(self, context, balanced)

    end,
    loc_vars = function(card, balance)
        
    end,
    ]]
}