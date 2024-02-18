
if game_mode == nil then
	game_mode = class({})
end

function game_mode:InitGameMode()
	GameRules:SetStartingGold(10000)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1)
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0)
    GameRules:SetUseUniversalShopMode(true)							
    GameRules:SetStrategyTime(0.0)
    GameRules:SetShowcaseTime(0.0)
	GameRules:SetSameHeroSelectionEnabled(true)

    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'GameStateChange'), self)
end

function game_mode:GameStateChange(data)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:StartGame() 
	end 
end

function game_mode:StartGame()
	--Срабатывает в 00:00
end