AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.AddNetworkString("twin")
util.AddNetworkString("Team_2")
util.AddNetworkString("Team_3")

function GM:Initialize()
	
	print("PaintBallz initialized.")
	print("WARNING: Due to extremely limited development time")
	print("(5 days of allotted 9.), This gamemode may have")
	print("numerous mild to severe bugs (Probably not game breaking)")
	print("simply because I didn't have time to bugtest it fully.")
	print("NOTICE: Due to a lack of development time, this gamemode")
	print("is currently only set up for (1) 6 minute round. After")
	print("Five minutes, the gamemode will switch to the next one.")
end

local humans = {
	"models/player/Group03/Male_01.mdl",
	"models/player/Group03/Male_02.mdl",
	"models/player/Group03/Male_03.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/Male_06.mdl",
	"models/player/Group03/Male_07.mdl",
	"models/player/Group03/Male_08.mdl",
	"models/player/Group03/Male_09.mdl",
	"models/player/Group03/Female_01.mdl",
	"models/player/Group03/Female_02.mdl",
	"models/player/Group03/Female_03.mdl",
	"models/player/Group03/Female_04.mdl",
	"models/player/Group03/Female_06.mdl",

	}

local combine = {
	"models/player/Police.mdl",
	"models/player/Combine_Soldier.mdl",
	"models/player/Combine_Soldier_PrisonGuard.mdl",
	}
	
local roundtime = 9999999
local startround = 0
local endn = 0
local endb = 0
	
local team3pos = {
	Vector(-1560.539307, 2761.671875, 76.031250),
	Vector(-2048.787598, 2833.774414, 76.031250),
	Vector(-2812.201172, 2830.887207, 76.031250)
	}
	
local team2pos = {
	Vector(-2550.992676, 311.682373, 76.031250),
	Vector(-2038.134155, 259.927917, 76.031250),
	Vector(-1344.957886, 249.984940, 76.031250)
	}
	

function GM:PlayerSpawn( ply )
    self.BaseClass:PlayerSpawn( ply )   
	ply:GodEnable()
	resetgod(ply)
    ply:SetWalkSpeed( 240 )  
    ply:SetRunSpeed ( 400 )
	
	if ply:Team() == 2 then
		player_manager.SetPlayerClass( ply, "Paintballer_1" )
		player_manager.OnPlayerSpawn( ply )
		player_manager.RunClass( ply, "WeaponLoadout" )
		ply:SetModel(table.Random(humans))
		ply:SetPos(table.Random(team2pos))
		ply:SetAngles(Angle(0,-90,0))
	end
	
	if ply:Team() == 3 then
		player_manager.SetPlayerClass( ply, "Paintballer_1" )
		player_manager.OnPlayerSpawn( ply )
		player_manager.RunClass( ply, "WeaponLoadout" )
		ply:SetModel(table.Random(combine))
		ply:SetPos(table.Random(team3pos))
		ply:SetAngles(Angle(0,90,0))
	end
	
end

function resetgod(ply)
	timer.Simple(3, function() 
		ply:GodDisable()
	end)

end

function GM:PlayerLoadout( ply )
	
end

function GM:PlayerInitialSpawn( ply )
	ply:PrintMessage( HUD_PRINTTALK, "Welcome, " .. ply:Name() .. "!" )
	player_manager.SetPlayerClass( ply, "Paint_Spectator" )
	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "WeaponLoadout" )
	ply:SetPos(Vector(-2153.867432, -202.852097, 96.031250))
	ply:ConCommand("Menu")
	
end

function GM:PlayerDeath( corpse, weapon, killer )
	if killer:IsPlayer() == true then
		corpse:PrintMessage( HUD_PRINTCENTER, "Hit by: " .. killer:Name()  )
		killer:PrintMessage( HUD_PRINTCENTER, "Killed: " .. corpse:Name()  )
	end
end



function GM:PlayerShouldTakeDamage( vic, att )
		if att:IsPlayer(true) then
			if att:Team() == vic:Team() then
				return false
			else
				return true
			end
		else
			if att:GetClass() == "prop_physics" then
				return false
			else
				return true
			end
		end
end

concommand.Add("debug_move_team2_bot", function(ply)
	local rply = table.Random(player.GetAll())
	if rply:Team() == 0 then
		rply:Kill()
		rply:PrintMessage( HUD_PRINTCENTER, "Balancing Teams... Sorry for the inconvenience."  )
		rply:SetTeam(2)
	end
end)

concommand.Add("debug_move_team3_bot", function(ply)
	local rply = table.Random(player.GetAll())
	if rply:Team() == 0 then
		rply:Kill()
		rply:PrintMessage( HUD_PRINTCENTER, "Balancing Teams... Sorry for the inconvenience."  )
		rply:SetTeam(3)
	end
end)


function round()
	roundtime = CurTime() + 360
	endb = 1
end
	
function GM:Think()
	
	if team.NumPlayers(2) >= (team.NumPlayers(3)+2) then
		local rply = table.Random(player.GetAll())
			if rply:Team() == 2 then
				rply:Kill()
				rply:PrintMessage( HUD_PRINTCENTER, "Balancing Teams... Sorry for the inconvenience."  )
				rply:SetTeam(3)
			end
	end
	if team.NumPlayers(3) >= (team.NumPlayers(2)+2) then
		local rply = table.Random(player.GetAll())
			if rply:Team() == 3 then
				rply:Kill()
				rply:PrintMessage( HUD_PRINTCENTER, "Balancing Teams... Sorry for the inconvenience."  )
				rply:SetTeam(2)
			end
	end
	
	if team.NumPlayers(2) >= 1 and team.NumPlayers(3) >= 1 and startround == 0 then
		round()
		startround = 1
		local allplayers = player.GetAll()
		for k, v in pairs( player.GetAll() ) do
			v:ConCommand("roundstartmusic")
			v:SetFrags(0)
			v:SetDeaths(0)
		end
	end
	
	if roundtime <= CurTime() and endn == 0 then
		--print("done!")
		endn = 1
		local allplayers = player.GetAll()
		local winners = ""
		if team.TotalFrags(2) > team.TotalFrags(3) then
			winners = "Red Team has won!"
			twin = "red"
			for _,ply in pairs(team.GetPlayers(3)) do
				ply:ConCommand("roundlosemusic")
				ply:ConCommand("EndRound2")
			end
			Teamwin1()
			for _,ply in pairs(team.GetPlayers(2)) do
				ply:ConCommand("roundwinmusic")
				ply:ConCommand("EndRound2")
			end
		end
		if team.TotalFrags(2) < team.TotalFrags(3) then
			winners = "Blue Team has won!"
			twin = "blue"
			for _,ply in pairs(team.GetPlayers(2)) do
				ply:ConCommand("roundlosemusic")
				ply:ConCommand("EndRound2")
			end
			Teamwin1()
			for _,ply in pairs(team.GetPlayers(3)) do
				ply:ConCommand("roundwinmusic")
				ply:ConCommand("EndRound2")
			end
		end
		if team.TotalFrags(2) == team.TotalFrags(3) then
			winners = "Tie!"
			for k, v in pairs( player.GetAll() ) do
				v:ConCommand("roundstalemusic")
				v:ConCommand("EndRound2")
			end
		end
		
		
		
		--allplayers:Kill()
		
		--v:PrintMessage( HUD_PRINTCENTER, winners )
		--v:ConCommand("EndRound2")
		print("!")
		timer.Simple( 20, function()
			if endn == 1 and endb == 1 then
				print("Switching...")
				hook.Call("wgcc_fin_nextgamemode")
			end
		end)
		for k, v in pairs( player.GetAll() ) do
			v:PrintMessage( HUD_PRINTCENTER, winners )
			--v:ConCommand("EndRound2")
			v:ChatPrint("Changing gamemode in 20 seconds.")
		end
		
	end
end

function Teamwin1()
	for k, v in pairs( player.GetAll() ) do
		net.Start("twin")
			net.WriteString( twin )
		net.Send(v)
	end
end
	
net.Receive("Team_2", function( len, ply )
	ply:SetTeam(2)
	ply:Kill()
	--ply:SetHands( "models/weapons/c_arms_refugee.mdl" )
end)

net.Receive("Team_3", function( len, ply )
	ply:SetTeam(3)
	ply:Kill()
	--ply:SetHands( "models/weapons/c_arms_combine.mdl" )

end)
