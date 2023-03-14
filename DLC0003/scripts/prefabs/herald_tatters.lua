local assets =
{
	Asset("ANIM", "anim/ancient_remnant.zip"),
    Asset("INV_IMAGE", "ancient_remnant"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")
    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)

    inst:AddTag("ancient_remnant")

    inst.AnimState:SetBank("ancient_remnant")
    inst.AnimState:SetBuild("ancient_remnant")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddTag("cattoy")

    inst:AddComponent("inspectable")

    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_LARGE
    
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = "ANCIENT_REMNANT"
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    return inst
end

return Prefab( "common/inventory/ancient_remnant", fn, assets)

