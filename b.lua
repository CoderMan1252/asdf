a = function(name,maxsize)
	local target = name
	local maxsize = maxsize
	local targetplr=game:GetService("Players")[target]
	local instancestorage= workspace.Terrain
	local Tool=Instance.new("Tool",targetplr.Backpack)
	Tool.Name="raycast gun"
	Tool.ToolTip="You need to move your character to aim!"
	local Handle=Instance.new("Part")
	Handle.Name="Handle"
	Handle.Massless=true
	Handle.Size=Vector3.new(1,1,2)
	Handle.Parent=Tool
	Tool.GripPos=Vector3.new(0,0,1)
	Tool.Activated:Connect(function()
		if not Handle then return end
		local result = workspace:Raycast(Handle.Position,Handle.CFrame.LookVector.Unit*10000)
		if not result then return end
		if result.Instance.Name=="BasePart" and result.Instance.Size.X>200 then return end
		local a = Instance.new("Explosion")
		a.Position=result.Position
		a.DestroyJointRadiusPercent=a.DestroyJointRadiusPercent/7
		a.BlastPressure=a.BlastPressure*2
		a.Parent=instancestorage
		if result.Instance.Size.X>maxsize*1.5 or result.Instance.Size.Y>maxsize*1.5 or result.Instance.Size.Z>maxsize*1.5 then return end
		if result.Instance:IsA("BasePart") then
			result.Instance.Size=result.Instance.Size*1.5
			task.wait(.1)
			for i=1,35 do task.wait()
				result.Instance.Size=result.Instance.Size/1.15
			end
			task.wait(.1)
		end
		pcall(function()result.Instance:Destroy()end)
	end)
	local Tool=Instance.new("Tool",targetplr.Backpack)
	Tool.Name="weldbreak"
	Tool.ToolTip="Breaks welds and unanchors parts."
	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.new(1,5,5)
	Handle.Parent=Tool
	Handle.Locked=false
	Handle.CanTouch=true
	Tool.GripPos=Vector3.new(0,0,2.5)
	Handle.Touched:Connect(function(part)
		if part.Name=="BasePart" and part:IsA("BasePart") and part.Anchored == true and part.Size.Magnitude > maxsize then return end
		if part.Size.X>maxsize or part.Size.Y>maxsize or part.Size.Z>maxsize then return end
		--if (part.Name=="HumanoidRootPart"or part.Name=="Head"or part.Name=="Torso") and part:IsA("Part") then return end
		part:BreakJoints()
		part.Anchored=false
		for i,v in next,part:GetDescendants()do
			if v.ClassName:match("Weld") then
				v:Destroy()
			end
		end
	end)
	local Shield=Instance.new("Tool",targetplr.Backpack)
	Shield.Name="Shield"
	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.new(8,8,1)
	Handle.Parent=Shield
	Handle.Locked=false
	Handle.CanTouch=true
	Shield.GripPos=Vector3.new(1,-1.25,1)
	Handle.Touched:Connect(function(part)
		if part.Name=="BasePart" and part:IsA("BasePart") and part.Anchored == true and part.Size.Magnitude > maxsize then return end
		if part.Size.X>maxsize*2 or part.Size.Y>maxsize*2 or part.Size.Z>maxsize*2 then return end

		part:Destroy()
	end)
	local Tool=Instance.new("Tool",targetplr.Backpack)
	Tool.Name="PartCreator"
	Tool.ToolTip="Create big gray sticks!"
	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.new(3,15,3) -- 120
	Handle.Parent=Tool
	Handle.Locked=false
	Handle.CanTouch=true
	Tool.GripPos=Vector3.new(0,-4,2) -- -(Handle.Size.Y/2.2)
	Tool.GripUp=Vector3.new(0,1,0)
	local holdingpartcreator = false
	local oldws
	local plrchar
	Tool.Equipped:Connect(function()
		plrchar=Tool.Parent
	end)
	Tool.Activated:Connect(function()
		holdingpartcreator = true
		if plrchar:FindFirstChildWhichIsA("Humanoid") then
			oldws=plrchar:FindFirstChildWhichIsA("Humanoid").WalkSpeed
			plrchar:FindFirstChildWhichIsA("Humanoid").WalkSpeed=oldws*1.5
		end
		while holdingpartcreator do
			task.spawn(function()
				local newpart= Instance.new("Part")
				newpart.Size=Handle.Size
				newpart.CFrame=Handle.CFrame
				newpart.Anchored=true
				newpart.Parent=instancestorage
				--newpart:GetPropertyChangedSignal("Anchored"):Connect(function()if newpart.Anchored==false then newpart.Anchored=true end end)
				wait(10*8)
				newpart:Destroy()
			end)
			task.wait(.01)
		end
	end)
	Tool.Deactivated:Connect(function()
		holdingpartcreator = false
		if plrchar:FindFirstChildWhichIsA("Humanoid") then
			plrchar:FindFirstChildWhichIsA("Humanoid").WalkSpeed=oldws or 16
		end
	end)
	Tool.Unequipped:Connect(function()
		holdingpartcreator = false
		if plrchar:FindFirstChildWhichIsA("Humanoid") then
			plrchar:FindFirstChildWhichIsA("Humanoid").WalkSpeed=oldws or 16
		end
	end)
	
	local Tool=Instance.new("Tool",targetplr.Backpack)
	Tool.Name="ScriptBreaker"
	Tool.ToolTip="Breaks the parts it touches."

	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.new(1,5,25)
	Handle.Locked=false
	Handle.CanTouch=true
	Handle.Parent=Tool

	Tool.GripPos=Vector3.new(0,0,Handle.Size.Z/2)

	local function checkifgameorws(inst)
		local data = pcall(function()return game:GetService(inst)end)
		if inst==game or data then
			return false
		end
		return true
	end

	local broken_list = {}

	local function isBroken(inst)
		return not not table.find(broken_list, inst)
		--return not pcall(function()return (inst:WaitForChild("Speaker",1e-323)or {Name=""}).Name end)
	end

	Handle.Touched:Connect(function(part)
		local hardbreak = true

		if part:FindFirstAncestorOfClass("Model") == targetplr then return end
		if part.Name=="BasePart" and part:IsA(part.Name) and part.Anchored == true and part.Size.Magnitude > maxsize then return end

		local parent = part

		for i=2,#part:GetFullName():split(".") - 1 do parent = parent.Parent end

		local classestobreak={
			"Script","LocalScript","ModuleScript",
			"RemoteEvent","RemoteFunction",
			"BindableEvent","BindableFunction",
			"ScreenGui","TextBox","TextLabel","Frame","ImageLabel"
		}
		local skip_Names = {
			"HumanoidRootPart",
			"Humanoid",
			"Torso"
		}

		for _,v in next, parent:GetDescendants() do
			if table.find(classestobreak, v.ClassName) or v.ClassName:match("Body") or v.ClassName:match("Value") then
				if not (v.Name == "Animate" and v:IsA("LocalScript")) and not (v:FindFirstAncestor("Animate",true) and v:FindFirstAncestor("Animate",true):IsA("LocalScript")) then
					task.defer(v.Destroy,v)
				end
			end

			if hardbreak and not isBroken(v) then
				v.Name = game:GetService("HttpService"):GenerateGUID(false):gsub("%-",""):lower()

				Instance.new("Speaker",v)

				table.insert(broken_list,v)
			end
		end
		if hardbreak and not isBroken(parent) then
			table.insert(broken_list,parent)
			Instance.new("Speaker",parent)

			parent.DescendantAdded:Connect(function(v)
				if table.find(classestobreak, v.ClassName) or v.ClassName:match("Body") or v.ClassName:match("Value") then
					if v:IsA("Script") then
						v.Disabled = true
					end

					v:ClearAllChildren()

					task.defer(v.Destroy,v)
				else
					v.Name = game:GetService("HttpService"):GenerateGUID(false):gsub("%-",""):lower()
				end
			end)
		end

	end)

	local function vmin(vector_1,vector_2,max)
		local function min(startval,limitval,max)
			if startval<limitval then
				local x=math.clamp(limitval,startval-max,startval+max)
				return x
			elseif startval>limitval then
				local x=math.clamp(limitval,startval-max,startval+max)
				return x
			else
				--> the values are same.
				return startval
			end
		end
		local x=min(vector_1.X,vector_2.X,max)
		local y=min(vector_1.Y,vector_2.Y,max)
		local z=min(vector_1.Z,vector_2.Z,max)
		return Vector3.new(x,y,z)
	end
	local function avg(v)
		return (v.X+v.Y+v.Z)/3
	end
	local remoteStickyBomb=Instance.new("Tool",targetplr.Backpack)
	remoteStickyBomb.Name="Sticky Bomb"
	remoteStickyBomb.ToolTip="Attach this to something and wait for it to explode!"
	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.new(2,2,2)
	Handle.Locked=false
	Handle.CanTouch=true
	local oldhandle=Handle:Clone()
	Handle.Parent=remoteStickyBomb
	remoteStickyBomb.GripPos=Vector3.new(0,0,Handle.Size.Z/2)
	local handletouched
	local touchpart = {}
	remoteStickyBomb.Activated:Connect(function()
		if not remoteStickyBomb:FindFirstChildWhichIsA("Part") then print("no handle") return end
		local Handle = remoteStickyBomb:FindFirstChildWhichIsA("Part")
		local part=Handle:GetTouchingParts()[1] or touchpart
		if part==nil then return end
		if part:FindFirstAncestorOfClass("Model")~=nil and part:FindFirstAncestorOfClass("Model")==remoteStickyBomb:FindFirstAncestorOfClass("Model") then print("char") return end
		if part.Name=="BasePart" and part:IsA("BasePart") and math.floor(part.Size.Magnitude)==2986 then print("too big") return end
		--if part.Size.X>maxsize or part.Size.Y>maxsize or part.Size.Z>maxsize then return end
		handletouched:Disconnect()
		Handle:BreakJoints()
		--Handle.Position=vmin(part.Position,Handle.Position,(avg(part.Size)^1.99)/(part.Size.Magnitude))
		Handle.Parent=part
		Handle.CanCollide=true
		local weld=Instance.new("WeldConstraint",Handle)
		weld.Part0=Handle
		weld.Part1=part
		task.spawn(function()
			wait(3)
			for i=1,Handle.Size.Magnitude*10 do task.wait()
				Handle.Size=Handle.Size/1.1
			end
			wait(.5)
			local explosion=Instance.new("Explosion",Handle)
			explosion.ExplosionType=Enum.ExplosionType.CratersAndDebris
			explosion.BlastPressure=1000000
			explosion.BlastRadius=12
			explosion.Position=Handle.Position
			explosion.Hit:Connect(function(part)
				if part.Size.X>maxsize and part.Size.Y>maxsize and part.Size.Z>maxsize then return end
				part.Massless=true
				part:BreakJoints()
				part.Anchored=false
				for i,v in next,part:GetDescendants()do
					if v.ClassName:match("Weld") then
						v:Destroy()
					end
				end
				local fire
				if math.random(3)==3 then
					fire=Instance.new("Fire",part)
					fire.Heat=math.random(5,25)
					fire.Enabled=true
					fire.Size=math.random(5,15)
					wait(math.random(10))
				end
				wait(math.random(10))
				if fire then
					fire.Enabled=false
					wait(2)
					fire:Destroy()
				end
				if math.random(7)~=2 then
					for i=1,part.Size.Magnitude*100 do task.wait()
						part.Size=part.Size/1.01
					end
					wait()
					part:Destroy()
				end
			end)
			task.wait(2)
			explosion:Destroy()
			Handle:Destroy()
		end)
		wait(3)
		touchpart={}
		local newhandle=oldhandle:Clone()
		newhandle.Position=Vector3.zero
		newhandle.Parent=remoteStickyBomb
		handletouched=newhandle.Touched:Connect(function(part)
			touchpart=part
			repeat
				wait()
				if (not part) or (not Handle) then break end
			until (not table.find(Handle:GetTouchingParts(),part))
			if touchpart==part then
				touchpart=nil
			end
		end)
	end)
	handletouched=Handle.Touched:Connect(function(part)
		touchpart=part
		repeat
			wait()
			if (not part) or (not Handle) then break end
		until (not table.find(Handle:GetTouchingParts(),part))
		if touchpart==part then
			touchpart=nil
		end
	end)
	Tool=Instance.new("Tool",targetplr.Backpack)
	Tool.Name="Remote Sticky Bomb"
	Tool.ToolTip="Same as sticky bomb but you explode it whenever you want!"
	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.new(2,2,2)
	Handle.Locked=false
	Handle.CanTouch=true
	local RSBOMB_MODE="Plant"
	local RSBOMB_BOMB=nil
	local oldhandle=Handle:Clone()
	Handle.Parent=Tool
	Tool.GripPos=Vector3.new(0,0,Handle.Size.Z/2)
	local rsbhandletouched
	local rsbtouchpart = nil
	local rsbtool=Tool
	local function newrsbhandle()
		wait(1.5)
		local newhandle=oldhandle:Clone()
		newhandle.Position=Vector3.zero
		newhandle.Parent=rsbtool
		Tool.GripPos=Vector3.new(0,0,Handle.Size.Z/2)
		rsbhandletouched=newhandle.Touched:Connect(function(part)
			rsbtouchpart=part
			repeat
				wait()
				if (not part) or (not newhandle) then break end
			until (not table.find(newhandle:GetTouchingParts(),part))
			if rsbtouchpart==part then
				rsbtouchpart=nil
			end
		end)
	end
	Tool.Activated:Connect(function()
		if RSBOMB_MODE == "Plant" then
			if not Tool:FindFirstChildWhichIsA("Part") then return end
			local Handle = Tool:FindFirstChildWhichIsA("Part")
			local part=rsbtouchpart or Handle:GetTouchingParts()[1]
			if part==nil then
				for i,v in next,Handle:GetTouchingParts() do
					if v~=nil then
						part=v
						break
					end
				end
			end
			if part==nil then return end
			if part:FindFirstAncestorOfClass("Model")==Tool:FindFirstAncestorOfClass("Model") then return end
			if part.Name=="BasePart" and part:IsA("BasePart") and math.floor(part.Size.Magnitude)==2986 then return end
			--if part.Size.X>maxsize or part.Size.Y>maxsize or part.Size.Z>maxsize then return end
			rsbhandletouched:Disconnect()
			Handle:BreakJoints()
			--Handle.Position=vmin(part.Position,Handle.Position,(avg(part.Size)^1.99)/(part.Size.Magnitude))
			Handle.Parent=part
			Handle.CanCollide=true
			local weld=Instance.new("WeldConstraint",Handle)
			weld.Part0=Handle
			weld.Part1=part
			wait(1)
			RSBOMB_BOMB=Handle
			local DetonateHandle=Instance.new("Part",Tool)
			DetonateHandle.Name="Handle"
			DetonateHandle.Color=Color3.new(0.705882, 0, 0)
			DetonateHandle.Size=Vector3.new(1,2,1)
			Tool.GripPos=Vector3.new(0,-.5,DetonateHandle.Size.Z/2)
			RSBOMB_MODE="Remote"
		elseif RSBOMB_MODE=="Remote" then
			Handle=RSBOMB_BOMB
			RSBOMB_MODE="Plant"
			task.spawn(function()
				wait(1.5)
				for i=1,Handle.Size.Magnitude*10 do task.wait()
					Handle.Size=Handle.Size/1.1
				end
				wait(.5)
				local explosion=Instance.new("Explosion",Handle)
				explosion.ExplosionType=Enum.ExplosionType.CratersAndDebris
				explosion.BlastPressure=1000000
				explosion.BlastRadius=12
				explosion.Position=Handle.Position
				explosion.Hit:Connect(function(part)
					if part.Size.X>maxsize and part.Size.Y>maxsize and part.Size.Z>maxsize then return end
					part.Massless=true
					part:BreakJoints()
					part.Anchored=false
					for i,v in next,part:GetDescendants()do
						if v.ClassName:match("Weld") then
							v:Destroy()
						end
					end
					local fire
					if math.random(3)==3 then
						fire=Instance.new("Fire",part)
						fire.Heat=math.random(5,25)
						fire.Enabled=true
						fire.Size=math.random(5,15)
						wait(math.random(10))
					end
					wait(math.random(10))
					if fire then
						fire.Enabled=false
						wait(2)
						fire:Destroy()
					end
					if math.random(7)~=2 then
						for i=1,part.Size.Magnitude*100 do task.wait()
							part.Size=part.Size/1.01
						end
						wait()
						part:Destroy()
					end
				end)
				task.wait(2)
				explosion:Destroy()
				Handle:Destroy()
			end)
			if Tool:FindFirstChildWhichIsA("Part")then
				Tool:FindFirstChildWhichIsA("Part"):Destroy()
			end
			newrsbhandle()
		end
	end)
	rsbhandletouched=Handle.Touched:Connect(function(part)
		rsbtouchpart=part
		repeat
			wait()
			if (not part) or (not Handle) then break end
		until (not table.find(Handle:GetTouchingParts(),part))
		if rsbtouchpart==part then
			rsbtouchpart=nil
		end
	end)
	local Tool=Instance.new("Tool",targetplr.Backpack)
	Tool.Name="Water"
	Tool.ToolTip="inf water wtf!"
	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.new(.5,.5,.5)
	Handle.Locked=false
	Handle.CanTouch=true
	Handle.Parent=Tool
	local holdingwatertool
	Tool.Activated:Connect(function()
		holdingwatertool=true
		while holdingwatertool do
			workspace.Terrain:FillCylinder(Handle.CFrame*CFrame.new(0,2,2),6,6,Enum.Material.Water)
			task.wait(.05/5)
		end
	end)
	Tool.Deactivated:Connect(function()
		holdingwatertool=false
	end)
	Tool.Unequipped:Connect(function()
		holdingwatertool=false
	end)
	local Tool=Instance.new("Tool",targetplr.Backpack)
	Tool.Name="clearterrain"
	local Handle=Instance.new("Part")
	Handle.Massless=true
	Handle.Name="Handle"
	Handle.Size=Vector3.zero --Vector3.new(.5,.5,.5)
	Handle.Locked=false
	Handle.CanTouch=true
	Handle.Parent=Tool
	Tool.Activated:Connect(function()
		workspace.Terrain:Clear()
	end)

	while wait(.2) do
		for i,v in next, workspace:GetDescendants() do
			if v:IsA("BasePart") and v.CanTouch == false then
				v.CanTouch = true
			end
		end
	end
end

return a
