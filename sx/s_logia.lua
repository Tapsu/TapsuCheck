------------------------------------------
-- 			MUOKATTAVAA!! 				--		
------------------------------------------
-- Rivit 10-13: Laita omat webhookit
-- Rivi: 30: 	Serverin pelaajamäärä

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local CHATLOGI 			= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Nimensä mukaan chat viestit
local CONNECTITLOGI 	= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Nimensä mukaan servulle liittymiset/poistumiset
local KUOLEMATLOGI 		= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Nimensä mukaan kuolemat
local PALVELUAMMATTI	= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Ns. Serverin status, paljonko pelaajia, poliiseja jne
-- Mite luoda oma?
--  local asia = "https://discrodapp.com/api/webhooks/" -- Esimerkki

local D_Nimi 		= "TapsuCheck"							-- Webhookin nimi
local STEAM_KEY 	= ""  									-- Tarvitaan steam kuvan saamiseksi chatlogeissa: https://steamcommunity.com/dev/apikey
local D_Kuva 		= "https://i.imgur.com/8vi3bK4.png"		-- Kuva webhookkiin

PerformHttpRequest(CONNECTITLOGI, function(err, text, headers) end, 'POST', json.encode({username = D_Nimi, content = "TapsuCheck - Käynnissä", avatar_url = D_Kuva}), { ['Content-Type'] = 'application/json' })

Citizen.CreateThread(function()
	Citizen.Wait(200000)
	Serverintilanne()
end)

function Serverintilanne()
	local pelaajia 		= ESX.GetPlayers()
	local pelaajamaara 	= 128				-- ASETA PELAAJAMÄÄRÄ
	local poliisit 		= 0
	local lanssit 		= 0
	local pelaajat		= 0
	local date 			= os.date('*t')
	for i=1, #pelaajia, 1 do
		local xPlayer = ESX.GetPlayerFromId(pelaajia[i])
		pelaajat = pelaajat + 1
		if xPlayer.job.name == 'police' then
			poliisit = poliisit + 1
		end
		if xPlayer.job.name == 'lanssit' then
			lanssit = lanssit + 1
		end
	end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end if date.month < 10 then  	date.month = '0' .. tostring(date.month)  end if date.year < 10 then  	date.year = '0' .. tostring(date.year) end if date.hour < 10 then  	date.hour = '0' .. tostring(date.hour)  end if date.min < 10 then  	date.min = '0' .. tostring(date.min)  end
	PALVELUAON("TapsuCheck - Status",'```Poliiseja: '..poliisit..'  Ensihoitoa: '..lanssit..'  Pelaajia: '..pelaajat..' / ' ..pelaajamaara..' '..'```' .. '' ..date.day.. '.' ..date.month.. '.' ..date.year.. ' - ' ..date.hour.. ':' ..date.min.. ' ' ,  11010819)
	SetTimeout(900000, Serverintilanne) -- Päivitys 15min jälkeen
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	local source 				= source
	local hyvaksytty 			= false
	local Steam 				= nil
	local Rockstar 				= nil
	local Discord 				= nil
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            Steam = v
        end
        if string.sub(v, 1, string.len("license:")) == "license:" then
            Rockstar = v
        end
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            Discord = v
        end
    end
    if Steam == nil then
        Steam = "EI OLE"
    end
    if Rockstar == nil then
        Rockstar = "EI OLE"
    end
	if Discord == nil then
		Discord = "EI OLE"
	end
	local nimi 			= GetPlayerName(source)
	local ip 			= GetPlayerEndpoint(source)
	local kickReason 	= nil
	local date 			= os.date('*t')
	deferrals.defer()
	Citizen.Wait(1000)
	PerformHttpRequest('http://ip2c.org/?ip='..ip, function(statusCode, response, headers) 
		local odotusaika = 5
		while odotusaika > 0 do
			deferrals.update(" Katotaas taustat läpi, odota: "..odotusaika.." sekuntia")
			odotusaika = odotusaika - 1
			Citizen.Wait(1500)
		end

		if response == nil then
			response = "IP ei saatavilla"
		elseif response == '1;FI;FIN;Finland' then			  		   	   		
			response = "Suomi"   
		elseif reponse == '1;FR;FRA;France' then
			response = "Ranska"	     
		elseif 	response == '2;;;UNKNOWN' then			  		   	   		
			response = "Localhost?"    
		end             

		if date.day < 10 then date.day = '0' .. tostring(date.day) end if date.month < 10 then date.month = '0' .. tostring(date.month) end if date.year < 10 then date.year = '0' .. tostring(date.year) end if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end if date.min < 10 then date.min = '0' .. tostring(date.min) end

		YHISTYSSERVILLE("Liittyminen serverille", '```fix\n' .. nimi .. ' yhdistää serville \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord .. ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. '\n```' ..'\n' ..date.day.. '.' ..date.month.. '.' ..date.year.. ' -  **' ..date.hour.. ':' ..date.min.. '** ', 65280)
		deferrals.done()
	end)
end)

AddEventHandler('playerDropped', function(Reason)
	local source 	= source
	local Steam 	= nil
	local Rockstar 	= nil
	local Discord 	= nil
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            Steam = v
        end
        if string.sub(v, 1, string.len("license:")) == "license:" then
            Rockstar = v
        end
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            Discord = v
        end
    end
    if Steam == nil then
        Steam = "EI OLE"
    end
    if Rockstar == nil then
        Rockstar = "EI OLE"
    end
	if Discord == nil then
		Discord = "EI OLE"
	end
	local nimi 		= GetPlayerName(source)
	local syy 		= Reason
	local ip 		= GetPlayerEndpoint(source)
	local Pelaaja 	= ESX.GetPlayerFromId(source)
	local T_Raha1 	= Pelaaja.getMoney()
	local T_Raha2 	= Pelaaja.getAccount('bank').money
	local T_Raha3 	= Pelaaja.getAccount('black_money').money
	local T_JOB 	= Pelaaja.job.name
	local date 		= os.date('*t')

	PerformHttpRequest('http://ip2c.org/?ip='..ip, function(statusCode, response, headers)
		if response == nil then
			response = "EI OLE"
		elseif response == '1;FI;FIN;Finland' then
			response = "Suomi"
		elseif response == '1;FR;FRA;France' then
			response = "Ranska"
		elseif response == '2;;;UNKNOWN' then
			response = "Localhost?"
		end
		if date.day < 10 then date.day = '0' .. tostring(date.day) end if date.month < 10 then date.month = '0' .. tostring(date.month) end if date.year < 10 then date.year = '0' .. tostring(date.year) end if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end if date.min < 10 then date.min = '0' .. tostring(date.min) end

		YHISTYSSERVILLE("Poistuminen serveriltä", '```fix\n' .. nimi .. ' (' .. syy .. ') \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord .. ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. ' \nKäteinen: ' .. T_Raha1 .. ' \nPankki: ' .. T_Raha2 .. '\nLikainen: ' .. T_Raha3.. '\nTyö: ' .. T_JOB ..  '\n```' .. '\n' ..date.day.. '.' ..date.month.. '.' ..date.year.. ' -  **' ..date.hour.. ':' ..date.min.. '** ', 16515072)
	end)
end)

RegisterServerEvent('TapsCheck:PelaajanKuolema')
AddEventHandler('TapsCheck:PelaajanKuolema',function(message, Weapon)
	local date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end if date.month < 10 then date.month = '0' .. tostring(date.month) end if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end if date.min < 10 then date.min = '0' .. tostring(date.min) end if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end if Weapon then message = message .. ' [' .. Weapon .. ']' end
	KUOLEMAT("Kuolema", message ..' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', 16711680)
end)

RegisterServerEvent('TapsCheck:komennot')
AddEventHandler('TapsCheck:komennot', function(Source, Name, Message)
	 MessageSplitted = stringsplit(Message, ' ')
		 local AvatarURL = SteamKuva
		 if GetIDFromSource('steam', Source) then
			 PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
				 local SteamProfileSplitted = stringsplit(Content, '\n')
				 for i, Line in ipairs(SteamProfileSplitted) do
					 if Line:find('<avatarFull>') then
						 AvatarURL = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
						 TriggerEvent('TapsCheck:LogeihiNYT', Webhook, Name .. ' [ID: ' .. Source .. ']', Message, AvatarURL, false, Source, TTS) 
						break
					 end
				 end
			 end)
		 else
		TriggerEvent('TapsCheck:LogeihiNYT', Webhook, Name .. ' [ID: ' .. Source .. ']',  Message, AvatarURL, false, Source, TTS)
	end
end)

AddEventHandler('chatMessage', function(Source, Name, Message)
	MessageSplitted = stringsplit(Message, ' ')
		local AvatarURL = SteamKuva
		local date 		= os.date('*t')
		if GetIDFromSource('steam', Source) then
			PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
				local SteamProfileSplitted = stringsplit(Content, '\n')
				for i, Line in ipairs(SteamProfileSplitted) do
					if Line:find('<avatarFull>') then
						if date.day < 10 then date.day = '0' .. tostring(date.day) end if date.month < 10 then date.month = '0' .. tostring(date.month) end if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end if date.min < 10 then date.min = '0' .. tostring(date.min) end if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
						AvatarURL = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
						TriggerEvent('TapsCheck:LogeihiNYT', Webhook, Name .. ' [ID: ' .. Source .. '] - Klo: ' ..date.hour.. ':' ..date.min.. '', Message, AvatarURL, false, Source, TTS)
						break
					end
				end
			end)
		else
		TriggerEvent('TapsCheck:LogeihiNYT', Webhook, Name .. ' [ID: ' .. Source .. '] - Klo: ' ..date.hour.. ':' ..date.min.. '', Message, AvatarURL, false, Source, TTS) 
	end
end)

RegisterServerEvent('TapsCheck:LogeihiNYT')
AddEventHandler('TapsCheck:LogeihiNYT', function(WebHook, Name, Message, Image, External, Source, TTS)
	if Message == nil or Message == '' then
		return nil
	end
	if External then
		if Image:lower() == 'steam' then
			Image = SteamKuva
			if GetIDFromSource('steam', Source) then
				PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
					local SteamProfileSplitted = stringsplit(Content, '\n')
					for i, Line in ipairs(SteamProfileSplitted) do
						if Line:find('<avatarFull>') then
							Image = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
							return PerformHttpRequest(CHATLOGI, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
						end
					end
				end)
			end
		elseif Image:lower() == 'user' then
			Image = SteamKuva
		else
			Image = SystemAvatar
		end
	end
	PerformHttpRequest(CHATLOGI, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
end)

function GetIDFromSource(Type, ID) 
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	local t={} ; i=1
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	return t
end

function KUOLEMAT(name, message, color)
  local connect = { { ["color"] = color, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
  PerformHttpRequest(KUOLEMATLOGI, function(err, text, headers) end, 'POST', json.encode({username = D_Nimi, embeds = connect, avatar_url = D_Kuva}), { ['Content-Type'] = 'application/json' })
end

function YHISTYSSERVILLE(name, message, color)
	local connect = { { ["color"] = color, 	["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(CONNECTITLOGI, function(err, text, headers) end, 'POST', json.encode({username = D_Nimi, embeds = connect, avatar_url = D_Kuva}), { ['Content-Type'] = 'application/json' })
end

function CHATTIF8LOGI(name, message, color)
	local _source = source local xPlayer = ESX.GetPlayerFromId(_source)
	local connect = { { ["color"] = color, ["title"] = "".. xPlayer.name .. name.." ", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(CHATLOGI, function(err, text, headers) end, 'POST', json.encode({username = D_Nimi, embeds = connect, avatar_url = D_Kuva}), { ['Content-Type'] = 'application/json' })
end

function ITEMITRAHATLOGI(name, message, color)
	local connect = {  { ["color"] = color, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(ITEMILOGI, function(err, text, headers) end, 'POST', json.encode({username = D_Nimi, embeds = connect, avatar_url = D_Kuva}), { ['Content-Type'] = 'application/json' })
end

function PALVELUAON(name, message, color)
	local connect = {  { ["color"] = color, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(PALVELUAMMATTI, function(err, text, headers) end, 'POST', json.encode({username = D_Nimi, embeds = connect, avatar_url = D_Kuva}), { ['Content-Type'] = 'application/json' })
end


	-- LOGITTETTAVAT ASIAT --
	-- [ Esimerkki ] --

--[[ 
RegisterServerEvent("esx:giveitemalert")
AddEventHandler("esx:giveitemalert", function(name,nametarget,itemname,amount)
	ITEMITRAHATLOGI("Tavaran anto", name.." -> "..nametarget.." Tavara: ["..itemname.." x "..amount.."]", 15130112)
end) 
]]