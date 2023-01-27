local assets =
{
	Asset("ANIM", "anim/meteor_impact.zip"),
}

local function RemoveImpact(inst)
    inst.components.colourtweener:StartTween({0,0,0,0}, 5, inst.Remove)
    inst.persists = false
end

local function ontimerdone(inst, data)
    if data.name == "remove" then
        RemoveImpact(inst)
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	
    anim:SetBank("meteorimpact")
    anim:SetBuild("meteor_impact")
    anim:PlayAnimation("idle_loop")
    
    inst:AddTag("fx")

    anim:SetFinalOffset(-1)
    anim:SetLayer(LAYER_BACKGROUND)
    anim:SetSortOrder(3)
    
    inst:AddComponent("colourtweener")
    inst:AddComponent("timer")

    inst:ListenForEvent("timerdone", ontimerdone)

    return inst
end

return Prefab("common/fx/meteor_impact", fn, assets)