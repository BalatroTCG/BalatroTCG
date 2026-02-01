BalatroTCG.ConsumeableMod {
    key_override = 'c_immolate',
    
    modify = function(self, balanced)
        if balanced then
            self.config.extra.dollars = 0
        end
    end
}