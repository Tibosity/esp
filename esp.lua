local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

if getgenv().HighlightESP then return end
getgenv().HighlightESP = true

-- Constants:
local LocalPlayer = Players.LocalPlayer
local ProtectInstance = syn and syn.protect_gui or function(instance) end

-- Variables:
local ESPs = {}

-- Functions:
local function onPlayerAdded(player: Player)
   -- Creates Highlight:
   local highlight = Instance.new("Highlight")
   highlight.FillColor = player.TeamColor.Color
   highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
   highlight.RobloxLocked = true
   ProtectInstance(highlight)
   ESPs[player] = highlight
   highlight.Parent = CoreGui

   -- Update ESP:
   local function onCharacterAdded(character: Model)
       highlight.Adornee = character
   end

   player.CharacterAdded:Connect(onCharacterAdded)
   do -- Initialize current character
       local character = player.Character
       if character then onCharacterAdded(character) end
   end
end

local function onPlayerRemoving(player: Player)
   -- Destroys Highlight:
   local highlight = ESPs[player]
   highlight:Destroy()
   ESPs[player] = nil
end

-- Listeners:
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Actions:
for i,v in ipairs(Players:GetPlayers()) do
   if v ~= LocalPlayer then
       onPlayerAdded(v)
   end
end
