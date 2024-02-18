modifier_building = class({})

function modifier_building:IsPurgable() return false end
function modifier_building:IsHidden() return true end

function modifier_building:CheckState() 
    local state = {
        [MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
        [MODIFIER_STATE_NO_TEAM_SELECT] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_SILENCED] = true,  
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
    return state
end