---------[ HOX ]---------
--    Muokkaa rivit:   --
--		 15 & 27	   --
-------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-- Webhookit --
local CHATLOGI 			= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Discordissa: #Tekstit
local ITEMILOGI 		= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Discordissa: #Tavarat-rahat
local CONNECTITLOGI 	= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Discordissa: #Connectit
local KUOLEMATLOGI 		= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Discordissa: #Kuolemat
local PALVELUAMMATTI	= "https://discordapp.com/api/webhooks/665258612536377394/0wuPH5sPG200G9MVSYPeWF-W-Es2_wbN4hQUdUlcQpPDfxrn32VbX5IwkCYsp4ZdmXTq" -- Discordissa: #Palveluammatit
-- Tiedot --
local DISCORD_NAME 		= "TapsCheck"							-- Webhookin nimi
local STEAM_KEY 		= "010C27BA4587AD82E34E6A91AF623B89"  	-- Tarvitaan steam kuvan saamiseksi chatlogeissa: https://steamcommunity.com/dev/apikey
local DISCORD_IMAGE 	= "https://i.imgur.com/a83t8Fj.png"		-- Kuva webhookkiin

PerformHttpRequest(CONNECTITLOGI, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, content = "TapsCheck - Käynnissä -> **Logit toiminnassa**", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })

Citizen.CreateThread(function()
	Citizen.Wait(300000)
	Serverintilanne()
end)

function Serverintilanne()
	local pelaajia 		= ESX.GetPlayers()
	local pelaajamaara 	= 128	-- ASETA PELAAJAMÄÄRÄ
	local poliisit 		= 0
	local lanssit 		= 0
	local mekaanikot 	= 0
	local taksit 		= 0
	local pelaajat		= 0
	for i=1, #pelaajia, 1 do
		local xPlayer = ESX.GetPlayerFromId(pelaajia[i])
		pelaajat = pelaajat + 1
		
		if xPlayer.job.name == 'police' then
			poliisit = poliisit + 1
		end
		if xPlayer.job.name == 'lanssit' then
			lanssit = lanssit + 1
		end
		if xPlayer.job.name == 'mecano' then
			mekaanikot = mekaanikot + 1
		end
		if xPlayer.job.name == 'taxi' then
			taksit = taksit + 1
		end
	end
	if poliisit >= 8 then
		poliisit = '8+'
	elseif poliisit >= 6 then
		poliisit = '6+'
	elseif poliisit >= 1 then
		poliisit = '1+'
	else 
		poliisit = '0'
	end
	PALVELUAON("TapsuCheck - Status",'```Poliiseja: '..poliisit..'  Ensihoitoa: '..lanssit..'  Mekaanikkoja: '..mekaanikot..'  Takseja: '..taksit..'  Pelaajia: '..pelaajat..' / ' ..pelaajamaara..' '..'```', 11010819)
	SetTimeout(900000, Serverintilanne) -- Päivitys 15min jälkeen
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	local source 				= source
	local hyvaksytty 			= false
	local Steam 		= nil
	local Rockstar 		= nil
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
	local nimi 			= GetPlayerName(source)
	local ip 			= GetPlayerEndpoint(source)
	local whitelisted 	= false
	local kickReason 	= nil
	deferrals.defer()
	Citizen.Wait(1000)
	PerformHttpRequest('http://ip2c.org/?ip='..ip, function(statusCode, response, headers) 
		local odotusaika = 10
		if #WhiteList == 0 then
			kickReason = 'Whitelist ei ole vielä latautunut - yritä liittyä uudelleen!'
		elseif Steam == "EI OLE" then
			kickReason = 'Käynnistä steam ennen kuin liityt!'
		else
			for i = 1, #WhiteList, 1 do
				if tostring(WhiteList[i]) == tostring(Steam) then
					whitelisted = true
					break
				end
			end
			if not whitelisted then
				kickReason = 'Sinua ei ole whitelistattu - Hae whitelistausta discordista!'
			end
		end
		while odotusaika > 0 do
			deferrals.update(" Minkähä tyyppinen mikkihiiri sieltä tulee no oota kummiski: "..odotusaika.." sekuntia")
			odotusaika = odotusaika - 1
			Citizen.Wait(1500)
		end
		if response == nil then
			response = "EI OLE"
		end
		if nimi:match("^[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789öäåÖÄÅ @!#&=?,;.:_-]*$") == nil then
			if response == '1;FI;FIN;Finland' then
				response = "Suomi"
			end	
			deferrals.done('TapsCheck: Poista steam nimimerkistäsi erikoismerkit ja käynnistä pelisi uudelleen')
			YHISTYSSERVILLE("Estetty pääsy nimimerkin takia", '```css\n' .. nimi .. ' pääsy estetty nimimerkin takia \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord .. ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. '\n```', 65280)
			return
		end

		if response == '1;FI;FIN;Finland' or response == 'EI OLE'
		or response == '1;FR;FRA;France'  then    
			hyvaksytty = true										   	   
			if response == '1;FI;FIN;Finland' then			  		   	   
				response = "Suomi"                                         
			end                                                            
		else
			Citizen.Wait(1000)
			local poikkeuslistalla, kickReason, steamID = false, nil, GetPlayerIdentifiers(source)[1]
			for i = 1, #Poikkeusluvat, 1 do
				if tostring(Poikkeusluvat[i]) == tostring(steamID) then
					poikkeuslistalla = true
					YHISTYSSERVILLE("Yhdistää serverille", '```css\n' .. nimi .. ' yhdistää serville \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord ..  ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. '\n```', 65280)
					deferrals.done()
					break
				end
			end

			if not poikkeuslistalla then 
				deferrals.done('Hyväksymme vain yhteydet suomesta, mikäli tarvitset poikkeuslupaa voit hakea sitä ylläpidolta discordissa #Apua kanavalla. https://discord.me/hellcityrp || This server is for finnish people only, thanks for your interest towards our server anyway and have a nice day! #SuomiFinlandPerkele')
				YHISTYSSERVILLE("Estetty ip takia #poikkeuslupa", '```css\n' .. nimi .. ' pääsy evätty \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord .. ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. '\n```', 65280)
			end
		end
		
		if hyvaksytty == true or poikkeuslistalla == true then	

			-- Whitelistaa pelaajan yhdistäessä serverille automaattisesti !!!!!!
		--[[ 
					if identifierSteam ~= "EI OLE" then
						MySQL.Async.fetchAll('SELECT * FROM whitelist WHERE identifier = @identifier', {
							['@identifier'] = identifierSteam
						}, function(result)
							if result[1] == nil then
								MySQL.Async.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', {
									['@identifier'] = identifierSteam
								}, function (rowsChanged)
									print(identifierSteam.." whitelisttu automaattisesti")
								end)
							end
						end)
					end
		 ]]
		
					if whitelisted then
				YHISTYSSERVILLE("Yhdistää serverille", '```css\n' .. nimi .. ' yhdistää serville \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord .. ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. '\n```', 65280)
				deferrals.done()
			else
				YHISTYSSERVILLE("Yhdistää mutta ei whitelistiä", '```css\n' .. nimi .. ' pääsy estetty (ei whitelisted) \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord .. ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. '\n```', 65280)
				deferrals.done(kickReason)
			end
		end
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
	local nimi = GetPlayerName(source)
	local syy = Reason
	local ip = GetPlayerEndpoint(source)
		
	PerformHttpRequest('http://ip2c.org/?ip='..ip, function(statusCode, response, headers)
		if response == nil then
			response = "EI OLE"
		elseif response == '1;FI;FIN;Finland' then
			response = "Suomi"
		end
		YHISTYSSERVILLE("Poistui serveriltä", '```fix\n' .. nimi .. ' (' .. syy .. ') \nIP: ' .. ip .. ' \nMaa: ' .. response .. ' \nDiscordID: ' .. Discord .. ' \nHex: ' .. Steam .. ' \nLisenssi: ' .. Rockstar .. '\n```', 16515072)
	end)
end)

RegisterServerEvent('TapsCheck:PelaajanKuolema')
AddEventHandler('TapsCheck:PelaajanKuolema',function(message, Weapon)
	local date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	if Weapon then message = message .. ' [' .. Weapon .. ']' end
	KUOLEMAT("Kuolema", message ..' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', 16711680)
end)

RegisterServerEvent('TapsCheck:komennot')
AddEventHandler('TapsCheck:komennot', function(Source, Name, Message)
	 MessageSplitted = stringsplit(Message, ' ')
		 local AvatarURL = UserAvatar
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
		TriggerEvent('TapsCheck:LogeihiNYT', Webhook, Name .. ' [ID: ' .. Source .. ']', Message, AvatarURL, false, Source, TTS)
	end
end)

AddEventHandler('chatMessage', function(Source, Name, Message)
	if Message == '/panicbutton' or Message == "/killmenu" then
		return
	end
	MessageSplitted = stringsplit(Message, ' ')
		local AvatarURL = UserAvatar
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
		TriggerEvent('TapsCheck:LogeihiNYT', Webhook, Name .. ' [ID: ' .. Source .. ']', Message, AvatarURL, false, Source, TTS) 
	end
end)

RegisterServerEvent('TapsCheck:LogeihiNYT')
AddEventHandler('TapsCheck:LogeihiNYT', function(WebHook, Name, Message, Image, External, Source, TTS)
	if Message == nil or Message == '' then
		return nil
	end
	if External then
		if Image:lower() == 'steam' then
			Image = UserAvatar
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
			Image = UserAvatar
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

Poikkeusluvat = {}
function lataaPoikkeusLuvat(cb)
	Poikkeusluvat = {}
	MySQL.Async.fetchAll('SELECT * FROM Poikkeusluvat', {}, function (identifiers)
		for i=1, #identifiers, 1 do
			table.insert(Poikkeusluvat, tostring(identifiers[i].identifier):lower())
		end
		if cb ~= nil then
			cb()
		end
	end)
end
WhiteList = {}
function loadWhiteList(cb)
	Whitelist = {}
	MySQL.Async.fetchAll('SELECT * FROM whitelist', {}, function (identifiers)
		for i=1, #identifiers, 1 do
			table.insert(WhiteList, tostring(identifiers[i].identifier):lower())
		end
		if cb ~= nil then
			cb()
		end
	end)
end

MySQL.ready(function()
	lataaPoikkeusLuvat()
	loadWhiteList()
end) 

function KUOLEMAT(name, message, color)
  local connect = { { ["color"] = color, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
  PerformHttpRequest(KUOLEMATLOGI, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function YHISTYSSERVILLE(name, message, color)
	local connect = { { ["color"] = color, 	["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(CONNECTITLOGI, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function CHATTIF8LOGI(name, message, color)
	local _source = source local xPlayer = ESX.GetPlayerFromId(_source)
	local connect = { { ["color"] = color, ["title"] = "".. xPlayer.name .. name.." ", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(CHATLOGI, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function ITEMITRAHATLOGI(name, message, color)
	local connect = {  { ["color"] = color, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(ITEMILOGI, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function PALVELUAON(name, message, color)
	local connect = {  { ["color"] = color, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(PALVELUAMMATTI, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

-- LOGITTETTAVAT ASIAT --


-- Esimerkki 

--[[ RegisterServerEvent("esx:giveitemalert")
AddEventHandler("esx:giveitemalert", function(name,nametarget,itemname,amount)
	ITEMITRAHATLOGI("Tavaran anto", name.." -> "..nametarget.." Tavara: ["..itemname.." x "..amount.."]", 15130112)
end) ]]







-- KOMENNOT --
TriggerEvent('es:addGroupCommand', 'wlpaivitys', 'admin', function (source, args, user)
	loadWhiteList(function()
		TriggerEvent('esx_whitelist:sendMessage', source, 'Whitelist ', 'Whitelist päivitetty!')
	end)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficienct permissions!' } })
end, { help = 'help_whitelist_load' })

TriggerEvent('es:addGroupCommand', 'wllisaa', 'admin', function (source, args, user)
	local steamID = 'steam:' .. args[1]:lower()
	if string.len(steamID) ~= 21 then
		TriggerEvent('esx_whitelist:sendMessage', source, '^1SYSTEM', 'Invalid steam ID length!')
		return
	end
	MySQL.Async.fetchAll('SELECT * FROM whitelist WHERE identifier = @identifier', {
		['@identifier'] = steamID
	}, function(result)
		if result[1] ~= nil then
			TriggerEvent('esx_whitelist:sendMessage', source, '^1SYSTEM', 'The player is already whitelisted on this server!')
		else
			MySQL.Async.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', {
				['@identifier'] = steamID
			}, function (rowsChanged)
				table.insert(WhiteList, steamID)
				TriggerEvent('esx_whitelist:sendMessage', source, 'Whitelist ', 'Pelaaja on whitelistattu!')
			end)
		end
	end)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficienct permissions!' } })
end, { help = 'help_whitelist_add', params = { steam = 'SteamID', help = 'SteamID formated to hex, begins with 11' }})

AddEventHandler('esx_whitelist:sendMessage', function(source, title, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { title, message } })
	else
		print('Whitelist: ' .. message)
	end
end)

AddEventHandler("rconCommand", function(command, args)
    if command == "whitelist_paivitys" then
        print("==WHITELIST PÄIVITETTY==")
		loadWhiteList()
	elseif command == "whitelistlisaa" then
		local steamID = 'steam:' .. args[1]:lower()
		if string.len(steamID) ~= 21 then
			print("VIRHESTEAMIDSSÄ")
			return
		end
		MySQL.Async.fetchAll('SELECT * FROM whitelist WHERE identifier = @identifier', {
			['@identifier'] = steamID
		}, function(result)
			if result[1] ~= nil then
				print("KAVERI ON JO WHITELISTATTU")
			else
				MySQL.Async.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', {
					['@identifier'] = steamID
				}, function (rowsChanged)
					table.insert(WhiteList, steamID)
					print("PELAAJA ON WHITELISTATTU")
				end)
			end
		end)
	end
end)

TriggerEvent('es:addGroupCommand', 'poikkeuslupapaivitys', 'admin', function (source, args, user)
	lataaPoikkeusLuvat(function()
		TriggerEvent('Taps_poikkeuslupa:sendMessage', source, 'Poikkeusluvat', 'Poikkeusluvat päivitetty.')
	end)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Ei oikeuksia.' } })
end, { help = 'Anna poikkeuslupa pelaajalle' })

TriggerEvent('es:addGroupCommand', 'poikkeuslupa', 'admin', function (source, args, user)
	local steamID = 'steam:' .. args[1]:lower()

	if string.len(steamID) ~= 21 then
		TriggerEvent('Taps_poikkeuslupa:sendMessage', source, '^1SYSTEM', 'ID ei ole oikean pituinen!')
		return
	end

	MySQL.Async.fetchAll('SELECT * FROM poikkeusluvat WHERE identifier = @identifier', {
		['@identifier'] = steamID
	}, function(result)
		if result[1] ~= nil then
			TriggerEvent('Taps_poikkeuslupa:sendMessage', source, '^1SYSTEM', 'Tämä pelaaja on jo poikkeuslistalla!')
		else
			MySQL.Async.execute('INSERT INTO poikkeusluvat (identifier) VALUES (@identifier)', {
				['@identifier'] = steamID
			}, function (rowsChanged)
				table.insert(poikkeusluvat, steamID)
				TriggerEvent('Taps_poikkeuslupa:sendMessage', source, 'Poikkeusluvat', 'Pelaajalle on myönnettu poikkeuslupa.')
			end)
		end
	end)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Ei oikeuksia.' } })
end, { help = 'Anna poikkeuslupa pelaajalle', params = { steam = 'SteamID', help = 'En saatana jaksa suomentaa -> SteamID formated to hex, begins with 11' }})

AddEventHandler('Taps_poikkeuslupa:sendMessage', function(source, title, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { title, message } })
	else
		print('Poikkeusluvat: ' .. message)
	end
end)