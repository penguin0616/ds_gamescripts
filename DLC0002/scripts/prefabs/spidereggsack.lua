require "prefabutil"
local assets =
{
	Asset("ANIM", "anim/spider_egg_sac.zip"),
    Asset("SOUND", "sound/spider.fsb"),
}

local function test_ground(inst, pt)
    local basetile = GROUND.DIRT
    if GetWorld():HasTag("shipwrecked") then
        basetile = GROUND.BEACH
    end
    local tile = inst:GetCurrentTileType(pt.x, pt.y, pt.z)

    local ground = GetWorld()
    local onWater = ground.Map:IsWater(tile)
    return not onWater
end

local function ondeploy(inst, pt) 
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
    local tree = SpawnPrefab("spiderden") 
    if tree then 
        tree.Transform:SetPosition(pt.x, pt.y, pt.z) 
        inst.components.stackable:Get():Remove()
    end 
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("spider_egg_sac")
    inst.AnimState:SetBuild("spider_egg_sac")
    inst.AnimState:PlayAnimation("idle")
    
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL
    
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    inst.components.burnable:MakeDragonflyBait(3)
    
    inst:AddComponent("inventoryitem")

    inst:AddTag("cattoy")
    inst:AddComponent("tradable")
    
    inst.components.inventoryitem:SetOnPickupFn(function() inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack") end)
    
    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable.deploydistance = 1.5

    return inst
end

return Prefab( "common/inventory/spidereggsack", fn, assets),
	   MakePlacer( "common/spidereggsack_placer", "spider_cocoon", "spider_cocoon", "cocoon_small" ) 

