upgrade = class({})

function upgrade:GetGoldCost()
    local unitName = self:GetCaster():GetUnitName()
    local cost = GetKeyValue(unitName, "UpgradeCost")
    return cost
end 

function upgrade:OnSpellStart()
    local caster = self:GetCaster()
    local newBuilding = BuildingHelper:UpgradeBuilding(caster)
end

if not KeyValues then
    KeyValues = {}
end

local split = function(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function LoadGameKeyValues()
    local scriptPath ="scripts/npc/"
    local override = LoadKeyValues(scriptPath.."npc_abilities_override.txt")
    local files = { AbilityKV = {base="npc_abilities",custom="npc_abilities_custom"},
                    ItemKV = {base="items",custom="npc_items_custom"},
                    UnitKV = {base="npc_units",custom="npc_units_custom"},
                    HeroKV = {base="npc_heroes",custom="npc_heroes_custom"}
                  }
    for k,v in pairs(files) do
        local file = {}
        if LOAD_BASE_FILES then
            file = LoadKeyValues(scriptPath..v.base..".txt")
        end
        for k,v in pairs(override) do
            if file[k] then
                file[k] = v
            end
        end

        local custom_file = LoadKeyValues(scriptPath..v.custom..".txt")
        if custom_file then
            for k,v in pairs(custom_file) do
                file[k] = v
            end
        else
            print("[KeyValues] Critical Error on "..v.custom..".txt")
            return
        end
        
        GameRules[k] = file --backwards compatibility
        KeyValues[k] = file
    end   

    -- Merge All KVs
    KeyValues.All = {}
    for name,path in pairs(files) do
        for key,value in pairs(KeyValues[name]) do
            if not KeyValues.All[key] then
                KeyValues.All[key] = value
            end
        end
    end
    -- Merge units and heroes (due to them sharing the same class CDOTA_BaseNPC)
    for key,value in pairs(KeyValues.HeroKV) do
        if not KeyValues.UnitKV[key] then
            KeyValues.UnitKV[key] = value
        else
            if type(KeyValues.All[key]) == "table" then
                print("[KeyValues] Warning: Duplicated unit/hero entry for "..key)
            end
        end
    end
    -- merge all includes
    for key, value in pairs(KeyValues.All) do
        if type(value) == "table" and value["include_keys_from"] then
            local includeKey = value["include_keys_from"]
            for k1, v1 in pairs(KeyValues.All[includeKey]) do
                if not value[k1] then
                    value[k1] = v1    
                end
            end
        end
    end
end

function GetKeyValue(name, key, level, tbl)
    local t = tbl or KeyValues.All[name]
    if key and t then
        if t[key] and level then
            local s = split(t[key])
            if s[level] then return tonumber(s[level]) or s[level] -- Try to cast to number
            else return tonumber(s[#s]) or s[#s] end
        else return t[key] end
    else return t end
end

if not KeyValues.All then LoadGameKeyValues() end