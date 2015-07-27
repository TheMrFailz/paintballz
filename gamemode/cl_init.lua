include( 'shared.lua' )
local ply = LocalPlayer()
local teamc = ""

function GM:Initialize()
	scoreboard2()
	main3:SetVisible(false)

end


local scores = vgui.Create( "DFrame" )
scores:SetPos( ScrW()/2 - 128, 0 ) 
scores:SetSize( 256, 64 )
scores:SetTitle( "" )
scores:SetVisible( true )
scores:SetDraggable( false )
scores:ShowCloseButton( false )
scores.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 75 ) )
end

local sc = vgui.Create( "RichText", scores )
sc:SetPos(50,30)
sc:SetSize( 256, 32)
sc:SetText( "Red Frags: " .. team.TotalFrags(2) .. "     Blue Frags: " .. team.TotalFrags(3) )


function GM:Think()
	sc:SetText( "Red Frags: " .. team.TotalFrags(2) .. "     Blue Frags: " .. team.TotalFrags(3) )
end

function spawnmenu()
local main = vgui.Create( "DFrame" )
main:SetPos( (0), 0 ) 
main:SetSize( ScrW(), ScrH() )
main:SetTitle( "" )
main:SetVisible( true )
main:SetDraggable( false )
main:ShowCloseButton( false )
main:MakePopup()
main.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 75 ) )
end

function main_close()
	main:SetVisible(false)
	
end

local logo = vgui.Create( "DImage", main )
logo:SetPos( ScrW()/2 - 256, ScrH()/10 )
logo:SetSize( 512, 128 )
logo:SetImage( "vgui/hud/paintballzscoreboard.png" )


local team_1_button = vgui.Create( "DButton", main )
team_1_button:SetPos( ((ScrW()/4)-60), (ScrH()/2 + 90) )
team_1_button:SetText( "Join Red Team" )
team_1_button:SetSize( 240, 60 )
team_1_button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 230, 230, 230 ) )
end
team_1_button.DoClick = function()
	Team2()
	main_close()
end

local team_2_button = vgui.Create( "DButton", main )
team_2_button:SetPos( (((ScrW()/4)*3)-180), (ScrH()/2 + 90) )
team_2_button:SetText( "Join Blue Team" )
team_2_button:SetSize( 240, 60 )
team_2_button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 230, 230, 230 ) )
end
team_2_button.DoClick = function()
	Team3()
	main_close()
end
end
concommand.Add( "Menu", spawnmenu )

function Team2()
	net.Start("Team_2")
		net.WriteString( teamc )
	net.SendToServer()
end

function Team3()
	net.Start("Team_3")
		net.WriteString( teamc )
	net.SendToServer()
end

net.Receive("twin", function( len, ply )
	ttwin = net.ReadString()
	--ply:SetHands( "models/weapons/c_arms_refugee.mdl" )
end)

function endroundscreen2()
local main2 = vgui.Create( "DFrame" )
main2:SetPos( 0 + (ScrW()/4), 0 ) 
main2:SetSize( ScrW()/2, ScrH()/2 )
main2:SetTitle( "" )
main2:SetVisible( true )
main2:SetDraggable( false )
main2:ShowCloseButton( false )
main2.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 230 ) )
end

function main_close()
	main2:SetVisible(false)
end

local logo = vgui.Create( "DImage", main2 )
logo:SetPos( 100, 0 )
logo:SetSize( 512, 256 )
logo:SetImage( "vgui/hud/" .. ttwin .. "win.png")

local facts = vgui.Create( "DListView", main2 )
facts:SetMultiSelect( false )
facts:SetPos( 20, 255 )
facts:SetSize( ScrW()/2-40, 105 )
facts:AddColumn( "Name" )
facts:AddColumn( "Achievement" )
facts.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 150, 150, 220 ) )
end

local playerkills = {}
local nameplayers = {}
local playerdeaths = {}
local allplayers = player.GetAll()
local num = 0
local ki = 0

for k, v in pairs( player.GetAll() ) do
	table.insert(playerkills, v:Frags())
	table.insert(nameplayers, v:Nick())
	table.insert(playerdeaths, v:Deaths())
end

local bestkill = table.GetWinningKey(playerkills)
local bestdeath = table.GetWinningKey(playerdeaths)

for k, v in pairs( nameplayers ) do
	if k == bestkill then
		daname = v	
	end
end

for k, v in pairs( nameplayers ) do
	if k == bestdeath then
		daname1 = v	
	end
end

facts:AddLine( daname, "Most Kills." )
facts:AddLine( daname1, "Most deaths." )
facts:AddLine( "Chairman Pao (Ellen Pao)", "Worst CEO" )
facts:AddLine( "Shia LaBeouf", "Most team buffs." )
facts:AddLine( "postal", "Finest ass fur." )

end
concommand.Add( "EndRound2", endroundscreen2 )



function scoreboard2()
main3 = vgui.Create( "DFrame" )
main3:SetPos( 0 + (ScrW()/4), (ScrH()/20) ) 
main3:SetSize( ScrW()/2, (ScrH()/20)*18 )
main3:SetTitle( "" )
main3:SetVisible( true )
main3:SetDraggable( false )
main3:ShowCloseButton( false )
main3:SetBackgroundBlur( false )
main3.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 150 ) )
end

local logo = vgui.Create( "DImage", main3 )
logo:SetPos( 10, 35 )
logo:SetSize( 256, 64 )
logo:SetImage( "vgui/hud/paintballzscoreboard.png" )


local names = vgui.Create( "DListLayout", main3 )
names:SetSize( ScrW()/3 - 20, ScrH())
names:SetPos( 10 , 120 )
names:SetDrawBackground( true )
names:SetBackgroundColor( Color( 100, 100, 100, 210 ) )
names:MakeDroppable( "names1" )

local name = vgui.Create( "RichText", names )
name:SetPos(0,0)
name:InsertColorChange( 192, 192, 192, 255 )
name:AppendText( "Team: Player:" )

local allplayers = player.GetAll()
for k, v in pairs( player.GetAll() ) do
		local tem = ""
		if v:Team() == 0 then
			tem = "[Spectator]"
		end
		if v:Team() == 2 then
			tem = "[Red]"
		end
		if v:Team() == 3 then
			tem = "[Blue]"
		end
		
		names:Add( Label( k .. " " .. tem .. " " .. v:Nick() ) )
end

local frags = vgui.Create( "DListLayout", main3 )
frags:SetSize( ScrW()/9 - 50, ScrH())
frags:SetPos( ScrW()/3 - 0 , 120 )
frags:SetDrawBackground( true )
frags:SetBackgroundColor( Color( 100, 100, 100, 150 ) )
frags:MakeDroppable( "frags1" )

local kill = vgui.Create( "RichText", frags )
kill:SetPos(0,0)
kill:InsertColorChange( 192, 192, 192, 255 )
kill:AppendText( "Frags:" )

for k, v in pairs( player.GetAll() ) do
		frags:Add( Label( v:Frags() ) )
end

local deaths = vgui.Create( "DListLayout", main3 )
deaths:SetSize( ScrW()/9 - 50, ScrH())
deaths:SetPos( ScrW()/3 + 110 , 120 )
deaths:SetDrawBackground( true )
deaths:SetBackgroundColor( Color( 100, 100, 100, 150 ) )
deaths:MakeDroppable( "deaths1" )

local death = vgui.Create( "RichText", deaths )
death:SetPos(0,0)
death:InsertColorChange( 192, 192, 192, 255 )
death:AppendText( "Deaths:" )

for k, v in pairs( player.GetAll() ) do
		deaths:Add( Label( v:Deaths() ) )
end
end
concommand.Add( "board", scoreboard2 )



function GM:ScoreboardShow()
	scoreboard2()
	main3:SetVisible( true )
end

function GM:ScoreboardHide()
	main3:SetVisible( false )
end

function roundstartmusic()
	LocalPlayer():EmitSound("vo/announcer_am_roundstart04.mp3")
end
concommand.Add( "roundstartmusic", roundstartmusic )

function roundwinmusic()
	LocalPlayer():EmitSound("misc/your_team_won.wav")
end
concommand.Add( "roundwinmusic", roundwinmusic )

function roundlosemusic()
	LocalPlayer():EmitSound("misc/your_team_lost.wav")
end
concommand.Add( "roundlosemusic", roundlosemusic )

function roundstalemusic()
	LocalPlayer():EmitSound("misc/your_team_stalemate.wav")
end
concommand.Add( "roundstalemusic", roundstalemusic )