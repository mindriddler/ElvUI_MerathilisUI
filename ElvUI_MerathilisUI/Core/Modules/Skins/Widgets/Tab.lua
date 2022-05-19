local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local LSM = E.Libs.LSM
local S = E.Skins

local _G = _G
local unpack = unpack

local RaiseFrameLevel = RaiseFrameLevel
local LowerFrameLevel = LowerFrameLevel

function module:HandleTab(_, tab, noBackdrop, template)
	if noBackdrop then
		return
	end

	if not tab or tab.MERSkin then
		return
	end

	if not E.private.mui.skins.widgets.tab.enable then
		return
	end

	local db = E.private.mui.skins.widgets.tab

	if db.text.enable then
		local text = tab.Text or tab.GetName and tab:GetName() and _G[tab:GetName() .. "Text"]
		if text and text.GetTextColor then
			F.SetFontDB(text, db.text.font)
			tab.windWidgetText = text
		end
	end

	if db.backdrop.enable and (tab.template or tab.backdrop) then
		local parentFrame = tab.backdrop or tab

		-- Create background
		local bg = parentFrame:CreateTexture()
		bg:SetInside(parentFrame, 1, 1)
		bg:SetAlpha(0)
		bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

		if parentFrame.Center then
			local layer, subLayer = parentFrame.Center:GetDrawLayer()
			subLayer = subLayer and subLayer + 1 or 0
			bg:SetDrawLayer(layer, subLayer)
		end

		F.SetVertexColorDB(bg, db.backdrop.classColor and module.ClassColor or db.backdrop.color)

		local group, onEnter, onLeave = self.Animation(bg, db.backdrop.animationType, db.backdrop.animationDuration, db.backdrop.alpha)
		tab.windAnimation = {
			bg = bg,
			group = group,
			onEnter = onEnter,
			onLeave = onLeave
		}

		self:SecureHookScript(tab, "OnEnter", onEnter)
		self:SecureHookScript(tab, "OnLeave", onLeave)

		-- Avoid the hook is flushed
		self:SecureHook(tab, "SetScript", function(frame, scriptType)
			if scriptType == "OnEnter" then
				self:Unhook(frame, "OnEnter")
				self:SecureHookScript(frame, "OnEnter", onEnter)
			elseif scriptType == "OnLeave" then
				self:Unhook(frame, "OnLeave")
				self:SecureHookScript(frame, "OnLeave", onLeave)
			end
		end)
	end
	--MER:CreateBackdropShadow(tab)

	tab.MERSkin = true
end

do
	S.Ace3_TabSetSelected_Changed = S.Ace3_TabSetSelected
	function S.Ace3_TabSetSelected(tab, selected)
		if not tab or not tab.backdrop then
			return
		end

		if not E.private.mui.skins.widgets.tab.enable then
			return
		end

		local db = E.private.mui.skins.widgets.tab

		if db.text.enable and tab.windWidgetText then
			local color
			if selected then
				color = db.text.selectedClassColor and module.ClassColor or db.text.selectedColor
			else
				color = db.text.normalClassColor and module.ClassColor or db.text.normalColor
			end
			tab.windWidgetText:SetTextColor(color.r, color.g, color.b)
		end

		if not db.selected.enable then
			S.Ace3_TabSetSelected_Changed(tab, selected)
			return
		end

		local borderColor = db.selected.borderClassColor and module.ClassColor or db.selected.borderColor
		local backdropColor = db.selected.backdropClassColor and module.ClassColor or db.selected.backdropColor
		if selected then
			tab.backdrop.Center:SetTexture(LSM:Fetch("statusbar", db.selected.texture) or E.media.glossTex)
			tab.backdrop:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
			tab.backdrop:SetBackdropColor(backdropColor.r, backdropColor.g, backdropColor.b, backdropColor.a)

			if not tab.wasRaised then
				RaiseFrameLevel(tab)
				tab.wasRaised = true
			end
		else
			tab.backdrop.Center:SetTexture(E.media.glossTex)
			local r, g, b = unpack(E.media.bordercolor)
			tab.backdrop:SetBackdropBorderColor(r, g, b, 1)
			r, g, b = unpack(E.media.backdropcolor)
			tab.backdrop:SetBackdropColor(r, g, b, 1)

			if tab.wasRaised then
				LowerFrameLevel(tab)
				tab.wasRaised = nil
			end
		end
	end
end

module:SecureHook(S, 'HandleTab')
module:SecureHook(S, 'Ace3_SkinTab', 'HandleTab')