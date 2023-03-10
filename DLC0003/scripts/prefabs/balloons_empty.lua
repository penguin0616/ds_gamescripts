local assets =
{
	Asset("ANIM", "anim/balloons_empty.zip"),
	--Asset("SOUND", "sound/common.fsb"),
}
 
local prefabs =
{
	"balloon",
}    

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    anim:SetBank("balloons_empty")
    anim:SetBuild("balloons_empty")
    anim:PlayAnimation("idle")
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "balloons_empty.png" )
    
    
    inst:AddComponent("inventoryitem")
    -----------------------------------

    inst:AddComponent("characterspecific")
    inst.components.characterspecific:SetOwner("wes")

    inst:AddTag("cattoy")
    inst:AddComponent("tradable")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("balloonmaker")

    return inst
end

return Prefab( "common/balloons_empty", fn, assets, prefabs) 
