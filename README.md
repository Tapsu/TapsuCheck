Muokkaa rivit:
-- Rivit 12-15 Omat webhookit
-- Rivi: 33: Pelaajamäärä
-- Rivi: 159: Automaattinen whitelistaus päälle, jos niin haluat
------------------------------
MITEN SAAN LOGITETTAVIA ASIOITA?!

1. Aloitetaan TapsCheckistä
2. s_logia.lua/ ->
3. Teet rivin 15 alle esimerkiksi 
```lua
local TUUNAUSLOGI = "https://discordapp.com/api/webhooks/"
```
4. Siirrytään riville 384 minne tehdään esimerkiksi
```lua
function TUUNAUS(name, message, color)
	local connect = {  { ["color"] = color, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = "", }, } }
	PerformHttpRequest(TUUNAUSLOGI, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end
```
5. Siirrytään riville 385 missä lukee "LOGITETTAVAT ASIAT" minne tehdään esimerkin mukaisesti
```lua
RegisterServerEvent('Tapsu:Tuunaus')
AddEventHandler('Tapsu:Tuunaus',function(autonmalli, rekkari, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TUUNAUS("Mekaanikko tuunaus", "" ..xPlayer.name.."  asensi osan ajoneuvoon:** "..autonmalli.. " **jonka rekisterikilpi on: [** " ..rekkari.. " **]. Osan hinta ajoneuvoon oli: **" ..price.."$**", 4844538)
end)
```
6. Okei nyt valmista, enään pitää tässä tapauksessa saada logitettava tieto esx_lscustomssista tieto TapsCheckkiin. (esx_lscustoms/client/lscustom.lua)
```lua
-- Tässä kaikki tarvittava kyseiseen pätkään

    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local autonmalli = GetEntityModel(vehicle)
    local rekkari = GetVehicleNumberPlateText(vehicle)

	TriggerServerEvent("esx_lscustom:buyMod", price)
	TriggerServerEvent("Tapsu:Tuunaus", GetDisplayNameFromVehicleModel(autonmalli), rekkari, price)
```
------------------------------

KOMENNOT
------------------------------
 Ingame: 
- /wlpaivitys
- /wllisaa 11000010c3cb900 
- /poikkeuslupapaivitys
- /poikkeuslupa 11000010c3cb900
------------------------------
Txadmin/konsoli:
- whitelistlisaa 11000010c3cb900 
- whitelist_paivitys

------------------------------
**Sisältää:**
- Whitelistin (Saa pois käytöstä)
- Poikkeusluvan (Mikäli pelaaja yrittää muualta kuin suomesta niin hänelle pitää myöntää poikkeuslupa)
