local assets=
{
	Asset("ANIM", "anim/boards.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")
    
    inst.AnimState:SetBank("boards")
    inst.AnimState:SetBuild("boards")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 15
    
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    inst.components.burnable:MakeDragonflyBait(3)
    
    inst:AddComponent("inventoryitem")
    
	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "wood"
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_BOARDS_HEALTH
    
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL
    
    return inst
end

return Prefab( "common/inventory/boards", fn, assets) 
