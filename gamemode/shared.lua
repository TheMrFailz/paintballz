GM.Name = "PaintBallz"
GM.Author = "TheMrFailz"
GM.Email = "gettysburg97EON@gmail.com"
GM.Website = ""

DeriveGamemode( "base" )

team.SetUp(1, "PaintSpectator", Color(100, 100, 100))
team.SetUp(2, "PaintRedTeam", Color(255, 0, 0))
team.SetUp(3, "PaintBlueTeam", Color(0, 0, 255))

local Class = {}
	Class.WalkSpeed = 1
	Class.RunSpeed	= 1
	Class.MaxHealth	= 100
	Class.StartHealth = 100
	Class.TeammateNoCollide = true
	Class.JumpPower	= 1
	Class.WeaponLoadout = function(info)
		info.Player:StripWeapons()
		info.Player:SetArmor("100")
		info.Player:GodEnable()
		info.Player:SetModel("models/player/skeleton.mdl")
		info.Player:SetGravity( 1 )
	
	end
player_manager.RegisterClass( "Paint_Spectator", Class, "player_default" )

local Class2 = {}
	Class2.WalkSpeed = 240
	Class2.RunSpeed	= 400
	Class2.MaxHealth	= 4000
	Class2.StartHealth = 100
	Class2.TeammateNoCollide = true
	Class2.JumpPower	= 150
	Class2.WeaponLoadout = function(info2)
		info2.Player:StripWeapons()
		info2.Player:Give("paint_basicmarker")
		
		
	end
player_manager.RegisterClass( "Paintballer_1", Class2, "player_default" )