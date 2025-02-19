local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local select = select
local hooksecurefunc = hooksecurefunc

function module:Blizzard_ArtifactUI()
	if not module:CheckDB("artifact", "artifact") then
		return
	end

	local ArtifactFrame = _G.ArtifactFrame
	module:CreateBackdropShadow(_G.ArtifactFrame)

	for i = 1, 2 do
		module:ReskinTab(_G["ArtifactFrameTab" .. i])
	end

	ArtifactFrame.Background:Hide()
	ArtifactFrame.PerksTab.HeaderBackground:Hide()
	ArtifactFrame.PerksTab.BackgroundBack:Hide()
	ArtifactFrame.PerksTab.TitleContainer.Background:SetAlpha(0)
	ArtifactFrame.PerksTab.Model.BackgroundFront:Hide()
	ArtifactFrame.PerksTab.Model:SetAlpha(0.2)
	ArtifactFrame.PerksTab.AltModel:SetAlpha(0.2)
	ArtifactFrame.BorderFrame:Hide()
	ArtifactFrame.ForgeBadgeFrame.ItemIcon:Hide()
	ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:ClearAllPoints()
	ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:SetPoint("TOPLEFT", _G["ArtifactFrame"])
	ArtifactFrame.AppearancesTab.Background:Hide()

	ArtifactFrame.AppearancesTab:HookScript("OnShow", function(self)
		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			if child and child.appearanceID then
				child:SetTemplate("Transparent")
				child.SwatchTexture:SetTexCoord(0.20, 0.80, 0.20, 0.80)
				child.SwatchTexture:SetInside(child)
				child.Border:SetAlpha(0)
				child.Background:SetAlpha(0)
				child.HighlightTexture:SetAlpha(0)
				child.HighlightTexture.SetAlpha = E.noop
				if child.Selected:IsShown() then
					child:SetBackdropBorderColor(1, 1, 1)
				end
				child.Selected:SetAlpha(0)
				child.Selected.SetAlpha = E.noop
				hooksecurefunc(child.Selected, "SetShown", function(self, isActive)
					if isActive then
						child:SetBackdropBorderColor(1, 1, 1)
					else
						child:SetBackdropBorderColor(0, 0, 0)
					end
				end)
			elseif child and child.DescriptionTooltipArea then
				child:StripTextures()
				child.Name:SetTextColor(1, 1, 1)
				child:SetTemplate("Transparent")
				child:SetBackdropColor(0, 0, 0, 1 / 2)
				local point, anchor, secondaryPoint, x, y = child:GetPoint()
				child:SetPoint(point, anchor, secondaryPoint, x, y + 2)
				hooksecurefunc(child, "SetPoint", function(self, point, anchor, secondaryPoint, x, y)
					if y == -80 or y == 0 then -- Blizz sets these two, maybe not best way for this but eh.
						self:SetPoint(point, anchor, secondaryPoint, x, y + 2)
						if not E.PixelMode then
							child:Point("TOPLEFT", child, "TOPLEFT", -E.Border + 2, E.Border - 3)
							child:Point("BOTTOMRIGHT", child, "BOTTOMRIGHT", E.Border - 2, E.Border + 3)
						end
					end
				end)
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_ArtifactUI")
