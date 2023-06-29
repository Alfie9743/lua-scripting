local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage:WaitForChild('RemoteEvent').OnClientEvent:Connect(function(types, message)
	if types == 'crash' then
		--crash
		while true do
			for var = 1, math.huge do
				print(math.huge)
				print(math.huge)
				print(math.huge)
				print(math.huge)
			end
		end
	elseif types == 'announce' then
		game:GetService('StarterGui'):SetCore('SendNotification', {
			Title = 'Announcement',
			Text = message,
			Duration = 10,
			Button1 = 'Okay'
		})
	end
end)
