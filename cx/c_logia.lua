local perse = 0
Citizen.CreateThread(function()
	local KuolemanSyy, Killer, DeathCauseHash, Weapon
	while true do
		Citizen.Wait(100)
		if IsEntityDead(PlayerPedId()) then
			Citizen.Wait(500)
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
			Weapon = AseidenNimet[tostring(DeathCauseHash)]
			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end
			if (Killer == PlayerId()) then
				KuolemanSyy = 'committed suicide'
			elseif (Killer == nil) then
				KuolemanSyy = 'died'
			else
				if IsMelee(DeathCauseHash) then
					KuolemanSyy = 'murdered'
				elseif IsTorch(DeathCauseHash) then
					KuolemanSyy = 'torched'
				elseif IsKnife(DeathCauseHash) then
					KuolemanSyy = 'knifed'
				elseif IsPistol(DeathCauseHash) then
					KuolemanSyy = 'pistoled'
				elseif IsSub(DeathCauseHash) then
					KuolemanSyy = 'riddled'
				elseif IsRifle(DeathCauseHash) then
					KuolemanSyy = 'rifled'
				elseif IsLight(DeathCauseHash) then
					KuolemanSyy = 'machine gunned'
				elseif IsShotgun(DeathCauseHash) then
					KuolemanSyy = 'pulverized'
				elseif IsSniper(DeathCauseHash) then
					KuolemanSyy = 'sniped'
				elseif IsHeavy(DeathCauseHash) then
					KuolemanSyy = 'obliterated'
				elseif IsMinigun(DeathCauseHash) then
					KuolemanSyy = 'shredded'
				elseif IsBomb(DeathCauseHash) then
					KuolemanSyy = 'bombed'
				elseif IsVeh(DeathCauseHash) then
					KuolemanSyy = 'mowed over'
				elseif IsVK(DeathCauseHash) then
					KuolemanSyy = 'flattened'
				else
					KuolemanSyy = 'killed'
				end
			end
			if perse == 1 then
				TriggerServerEvent('TapsCheck:PelaajanKuolema', GetPlayerName(PlayerId()) .. ' kirjoitti /die ja menehtyi')
			elseif perse == 2 then
				TriggerServerEvent('TapsCheck:PelaajanKuolema', GetPlayerName(PlayerId()) .. ' on palautettu kuolleeksi automaattisesti')
				Citizen.Wait(30000)
			else
				if KuolemanSyy == 'committed suicide' or KuolemanSyy == 'died' then
					TriggerServerEvent('TapsCheck:PelaajanKuolema', GetPlayerName(PlayerId()) .. ' ' .. KuolemanSyy .. '.', Weapon)
				else
					TriggerServerEvent('TapsCheck:PelaajanKuolema', GetPlayerName(Killer) .. ' ' .. KuolemanSyy .. ' ' .. GetPlayerName(PlayerId()) .. '.', Weapon)
				end
			end
			Killer = nil
			KuolemanSyy = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(0)
		end
	end
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	perse = 1
	Citizen.Wait(1000)
	perse = 0
end)

RegisterNetEvent('esx_ambulancejob:requestDeath')
AddEventHandler('esx_ambulancejob:requestDeath', function()
	perse = 2
	Citizen.Wait(60000)
	perse = 0
end)

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end