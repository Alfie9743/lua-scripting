local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local banned = game:GetService('DataStoreService'):GetDataStore('banned')

local admins = {}

game.Players.PlayerAdded:Connect(function(plr) 
	local is_admin = false
	for _, admin in ipairs(admins) do
		if admin == plr.UserId then
			is_admin = true
		end
	end
	plr.Chatted:Connect(function(message)
		if not is_admin then return end
		local split_message = message:split(' ')
		
		if split_message[1] == ':day' then
			TweenService:Create(game.Lighting, TweenInfo.new(1), {ClockTime = 12}):Play()
		end
		
		if split_message[1] == ':night' then
			TweenService:Create(game.Lighting, TweenInfo.new(1), {ClockTime = 0}):Play()
		end
		
		if split_message[1] == ':announce' then
			local message = message:sub(9)
			ReplicatedStorage:WaitForChild('RemoteEvent'):FireAllClients('announce', message)
		end
		
		if split_message[1] == ':kick' and split_message[2] == 'all' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				player:Kick('Kicked.')
			end
		end
		
		if split_message[1] == ':kick' and split_message[2] == 'others' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player == plr then continue end
				player:Kick('Kicked')
			end
		end
		
		if split_message[1] == ':kill' and split_message[2] == 'all' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				local character = player.Character or player.CharacterAdded:Wait()
				local humanoid = character:WaitForChild("Humanoid")
				humanoid:TakeDamage(math.huge)
			end
		end
		
		if split_message[1] == ':kill' and split_message[2] == 'others' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				local character = player.Character or player.CharacterAdded:Wait()
				local humanoid = character:WaitForChild("Humanoid")
				if player == plr then
					humanoid:TakeDamage()
				end
			end
		end
		
		if split_message[1] == ':crash' and split_message[2] == 'others' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player == plr then continue end
				ReplicatedStorage:WaitForChild('RemoteEvent'):FireClient(player, 'crash')
			end
		end
		
		if split_message[1] == ':crash' and split_message[2] == 'all' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				ReplicatedStorage:WaitForChild('RemoteEvent'):FireAllClients('crash')
			end
		end
		
		if split_message[1] == ':ban' and split_message[2] == 'others' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player == plr then continue end
				local s, e = pcall(function()
					banned:SetAsync(player.UserId, true)
				end)
				if e then
					warn('There was an error while setting ban status for '..player.Name..' | Reason: '..e)
				end
				if s then
					print('Successfully banned: '..player.Name)
				end
			end
		end
		
		if split_message[1] == ':ban' and split_message[2] == 'all' then
			for _, player in ipairs(game.Players:GetPlayers()) do
				local s, e = pcall(function()
					banned:SetAsync(player.UserId, true)
				end)
				if e then
					warn('There was an error while setting ban status for '..player.Name..' | Reason: '..e)
				end
				if s then
					print('Successfully banned: '..player.Name)
				end
			end
		end
		
		if split_message[1] == 'damage' and split_message[2] == 'all' and split_message[3] ~= nil then
			for _, player in ipairs(game.Players:GetPlayers()) do
				local s,e = pcall(function()
					player.Humanoid:TakeDamage(tonumber(split_message[3]))
				end)
				if e then
					warn('Error while taking damage on '..player.Name..' | Reason: '..e)
				end
				if s then
					print('Successfully damaged '..player.Name)
				end
			end
		end
	end)
end)

game.Players.PlayerAdded:Connect(function(player) 
	local data
	local s,e = pcall(function()
		data = banned:GetAsync(player.UserId)
	end)
	if data then
		if data == true then
			player:Kick('You have been banned from '..game.Name)
		end
	end
end)
