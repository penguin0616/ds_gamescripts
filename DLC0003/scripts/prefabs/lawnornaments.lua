
local prefabs = {
    "ash",
    "collapse_small",
}

local function onHammered(inst, worker)	
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    if not inst.components.fixable then
        inst.components.lootdropper:DropLoot()
    end
    inst:Remove()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
end
        
local function onHit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onBuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/lawnornaments/repair")
end

local function MakeLawnornament(n)
    local assets = {
        Asset("ANIM", "anim/topiary0"..n..".zip"),
        Asset("MINIMAP_IMAGE", "lawnornaments_"..n),
        Asset("INV_IMAGE", "lawnornament_"..n),
    }

    local function fn(Sim)
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState() 
     
        MakeObstaclePhysics(inst, .5)

        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon( "lawnornament_"..n..".png" )

        inst.entity:AddSoundEmitter()
        inst:AddTag("structure")

        anim:SetBank("topiary0".. n)
        anim:SetBuild("topiary0".. n)

        anim:PlayAnimation("idle")

        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(2)
        inst.components.workable:SetOnFinishCallback(onHammered)
        inst.components.workable:SetOnWorkCallback(onHit)
        
        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = "lawnornament"
        
        MakeSnowCovered(inst)

        inst:ListenForEvent( "onbuilt", onBuilt)

        inst:AddComponent("fixable")
        inst.components.fixable:AddRecinstructionStageData("burnt", "topiary0".. n, "topiary0".. n)

        MakeSmallBurnable(inst, nil, nil, true)
        MakeSmallPropagator(inst)

        inst:AddComponent("gridnudger")

        inst:ListenForEvent("burntup", inst.Remove)

        return inst
    end

    return Prefab("lawnornament_"..n, fn, assets, prefabs)
end

local function MakeLawnornamentPlacer(n)
    return MakePlacer("common/lawnornament_"..n.."_placer", "topiary0"..n, "topiary0"..n, "idle")
end

local ret = {}

for i=1, 7 do
    table.insert(ret, MakeLawnornament(i))
    table.insert(ret, MakeLawnornamentPlacer(i))
end

return unpack(ret)