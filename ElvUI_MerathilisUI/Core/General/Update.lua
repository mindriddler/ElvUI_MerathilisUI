
local MER, F, E, L, V, P, G = unpack(select(2, ...))

local print, tonumber, type = print, tonumber, type
local format = string.format

local isFirstLine = true

local DONE_ICON = format(" |T%s:0|t", MER.Media.Icons.accept)

local function UpdateMessage(text, from)
	if isFirstLine then
		isFirstLine = false
		F.PrintGradientLine()
		F.Print(L["Update"])
	end

	print(text .. format("(|cff00a8ff%.2f|r -> |cff00a8ff%s|r)...", from, MER.Version) .. DONE_ICON)
end

function MER:ForPreReleaseUser()
end

function MER:UpdateScripts() -- DB Convert
	MER:ForPreReleaseUser()

	local db = E.db.mui
	local private = E.private.mui

	local currentVersion = tonumber(MER.Version) -- Installed MerathilisUI Version
	local globalVersion = tonumber(E.global.mui.version or "0") -- Version in ElvUI Global
	local profileVersion = tonumber(E.db.mui.version or globalVersion) -- Version in ElvUI Profile
	local privateVersion = tonumber(E.private.mui.version or globalVersion) -- Version in ElvUI Private

	-- changelog display
	if globalVersion == 0 or globalVersion ~= currentVersion then
		self.showChangeLog = true
	end

	if globalVersion == currentVersion and profileVersion == currentVersion and privateVersion == currentVersion then
		return
	end

	isFirstLine = true

	if profileVersion <= 5.00 then
		if db.general.style then
			db.general.style = nil
		end

		if db.general.shadowOverlay then
			db.general.shadowOverlay = nil
		end

		if db.general.shadow and type(db.general.shadow) == 'table' then
			db.general.shadow = nil
		end

		if not private.skins or type(private.skins) ~= 'table' then
			private.skins = {}
		end

		if not private.skins.shadow or type(private.skins.shadow) ~= 'table' then
			private.skins.shadow = {}
		end

		UpdateMessage(L["Core"] .. " - " .. L["Update Database"], profileVersion)
	end

	if not isFirstLine then
		F.PrintGradientLine()
	end

	E.global.mui.version = MER.Version
	E.db.mui.version = MER.Version
	E.private.mui.version = MER.Version
end