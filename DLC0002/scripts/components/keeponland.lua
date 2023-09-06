local KeepOnLand = Class(function(self, inst)
    self.inst = inst

    self.inst:StartUpdatingComponent(self)
end)

function KeepOnLand:OnUpdateSw(dt)
    if (not self.inst.components.driver or not self.inst.components.driver:GetIsDriving()) and
        not self.inst.sg:HasStateTag("busy") and
        not self.inst.components.health:IsDead()
    then
        local pt = self.inst:GetPosition()
        local radius = 1 -- Buffer zone because the walls aren't perfecly along the visual line.
        local result_offset = FindGroundOffset(pt, 0, radius, 12)

        local on_water = result_offset == nil

        if on_water then
            radius = 5
            result_offset = FindGroundOffset(pt, 0, radius, 12)

            if result_offset ~= nil then
                local moveto = pt + result_offset
                self.inst.Transform:SetPosition(moveto:Get())

            elseif self.inst.components.health ~= nil then
                if CHEATS_ENABLED then
                    local boat = SpawnPrefab("rowboat")
                    boat.Transform:SetPosition(pt:Get())

                    self.inst.components.driver:OnMount(boat)
                    boat.components.drivable:OnMounted(self.inst)
                else
                    self.inst.components.health:Kill("drowning")
                end
            end
        end
    end
end

function KeepOnLand:OnUpdateVolcano(dt)
    local world = GetWorld()

    local function testfn(offset)
        local test_point = self.inst:GetPosition() + offset
        local tx, ty = world.Map:GetTileCoordsAtPoint(test_point:Get())
        local actual_tile = world.Map:GetTile(tx, ty)

        return actual_tile ~= GROUND.VOLCANO_LAVA
    end

    if not self.inst.sg:HasStateTag("busy") and not self.inst.components.health:IsDead() then
        local pt = self.inst:GetPosition()
        local radius = 1.75 -- Buffer zone because the walls aren't perfecly along the visual line.

        local result_offset = FindValidPositionByFan(0, radius, 12, testfn)

        local on_lava = result_offset == nil

        if on_lava then
            radius = 5
            result_offset = FindValidPositionByFan(0, radius, 12, testfn)

            if result_offset ~= nil then
                local moveto = pt + result_offset
                self.inst.Transform:SetPosition(moveto:Get())

            elseif self.inst.components.health ~= nil then
                if not CHEATS_ENABLED then
                    self.inst.components.health:Kill("burnt")
                end
            end
        end
    end
end

function KeepOnLand:OnUpdate(dt)
    if GetWorld():IsVolcano() then
        self:OnUpdateVolcano(dt)
    else
        self:OnUpdateSw(dt)
    end
end

function KeepOnLand:ForceStopUpdating()
    self.inst:StopUpdatingComponent(self)
end


return KeepOnLand
