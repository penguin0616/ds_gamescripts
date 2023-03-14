local assets=
{
	Asset("ANIM", "anim/spear_wathgrithr.zip"),
	Asset("ANIM", "anim/swap_spear_wathgrithr.zip"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear_wathgrithr", "swap_spear_wathgrithr")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")

    anim:SetBank("spear_wathgrithr")
    anim:SetBuild("spear_wathgrithr")
    anim:PlayAnimation("idle")
    
    inst:AddTag("sharp")
    inst:AddTag("spear")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.WATHGRITHR_SPEAR_DAMAGE)
    
    --inst:AddComponent("characterspecific")
    --inst.components.characterspecific:SetOwner("wathgrithr")

    -------
    inst:AddComponent("tradable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.WATHGRITHR_SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.WATHGRITHR_SPEAR_USES)
    
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    
    inst.speartype = "wathgrithr"

    return inst
end

return Prefab( "common/inventory/spear_wathgrithr", fn, assets) 
