ESX = nil
local lastJob = nil
local lastJob2 = nil
local isAmmoboxShown = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
  Citizen.Wait(3000)
  if PlayerData == nil or PlayerData.job == nil or PlayerData.job2 == nil then
	  	PlayerData = ESX.GetPlayerData()
	end
	SendNUIMessage({
		action = 'initGUI',
		data = { whiteMode = Config.enableWhiteBackgroundMode, enableAmmo = Config.enableAmmoBox, colorInvert = Config.disableIconColorInvert }
	})
end)

local dugamapa = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  SetRadarBigmapEnabled(false, false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
  PlayerData.job2 = job2
end)

function showAlert(message, time, color)
	SendNUIMessage({
		action = 'showAlert',
		message = message,
		time = time,
		color = color
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
			ESX.TriggerServerCallback('poggu_hud:retrieveData', function(data)
			SendNUIMessage({
				action = 'setMoney',
				cash = data.cash,
				bank = data.bank,
				black_money = data.black_money,
				society = data.society
			})
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if(PlayerData ~= nil) then
			local jobName = PlayerData.job.label..' - '..PlayerData.job.grade_label
			if(lastJob ~= jobName) then
				lastJob = jobName
				SendNUIMessage({
					action = 'setJob',
					data = jobName
				})
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if(PlayerData ~= nil) then
			local jobName = PlayerData.job2.label..' - '..PlayerData.job2.grade_label
			if(lastJob2 ~= jobName) then
				lastJob2 = jobName
				SendNUIMessage({
					action = 'setJob2',
					data = jobName
				})
			end
		end
	end
end)

Citizen.CreateThread(function()
 while true do
		Citizen.Wait(300)
		if Config.enableAmmoBox then
			local playerPed = PlayerPedId()
			local weapon, hash = GetCurrentPedWeapon(playerPed, 1)
			if(weapon) then
				isAmmoboxShown = true
				local _,ammoInClip = GetAmmoInClip(playerPed, hash)
				SendNUIMessage({
						action = 'setAmmo',
						data = ammoInClip..'/'.. GetAmmoInPedWeapon(playerPed, hash) - ammoInClip
				})
			else
				if isAmmoboxShown then
					isAmmoboxShown = false
					SendNUIMessage({
						action = 'hideAmmobox'
					})
				end
			end
		end
	end
end)

local isMenuPaused = false

function menuPaused()
	SendNUIMessage({
		action = 'disableHud',
		data = isMenuPaused
	})
end

local UserSakrio = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if not UserSakrio then

			if IsPauseMenuActive() then
				if not isMenuPaused then
					isMenuPaused = true
					menuPaused()
				end
			elseif isMenuPaused then
				isMenuPaused = false
				menuPaused()
			end

		else
			Wait(1000)
		end
	end
end)

RegisterCommand("hud", function(source, data)
	UserSakrio = not UserSakrio
	isMenuPaused = not isMenuPaused
	menuPaused()
end)

local isMenuPaused2 = false

function menuPaused2()
	if isMenuPaused2 then
		DisplayRadar(true)
	else
		DisplayRadar(false)
	end
	SendNUIMessage({
		action = 'cinema',
		data = isMenuPaused2
	})
end

local UserSakrio2 = true
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if not UserSakrio2 then

			if IsPauseMenuActive() then
				if not isMenuPaused2 then
					isMenuPaused2 = true
					menuPaused2()
				end
			elseif isMenuPaused2 then
				isMenuPaused2 = false
				menuPaused2()
			end

		else
			Wait(1000)
		end
	end
end)

RegisterCommand("cinema", function(source, data)
	UserSakrio2 = not UserSakrio2
	isMenuPaused2 = not isMenuPaused2
	menuPaused2()
end)

exports("cinema", function(state)

	if state and (state == true or state == false) then 
		UserSakrio2 = state
		isMenuPaused2 = state
	else
		UserSakrio2 = not UserSakrio2
		isMenuPaused2 = not isMenuPaused2
	end

	menuPaused2()
end)

local vitesse = 0
local lastVehicle = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= 0 and vehicle ~= nil then
			lastVehicle = vehicle
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= 0 and vehicle ~= nil then
			local speed = GetEntitySpeed(vehicle) * 3.6
			if speed >= 0 then
				vitesse = math.floor(speed)
				SendNUIMessage({
					action = 'setVitesse',
					data = vitesse
				})
			else
				vitesse = 0
			end
		else
			SendNUIMessage({
				action = 'setVitessedisplay'
			})
			vitesse = 0
		end
	end
end)

local lastFuel = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= 0 and vehicle ~= nil then
			lastFuel = vehicle
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= 0 and vehicle ~= nil then
			local fuel = GetVehicleFuelLevel(vehicle)
			if fuel > 1 then
				fuel = math.floor(fuel)
				SendNUIMessage({
					action = 'setFuel',
					data = fuel
				})
			else
				fuel = 0
			end
		else
			SendNUIMessage({
				action = 'setFueldisplay'
			})
			fuel = 0
		end
	end
end)

-- etat du vehicule
local enginehealt = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= 0 and vehicle ~= nil then
			enginehealt = vehicle
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= 0 and vehicle ~= nil then
			local engine = GetVehicleEngineHealth(vehicle)
			if engine > 1 then
				engine = math.floor(engine)
				engine = engine / 10
				SendNUIMessage({
					action = 'setEngine',
					data = engine
				})
			else
				engine = 0
			end
		else
			SendNUIMessage({
				action = 'setEnginedisplay'
			})
			engine = 0
		end
	end
end)