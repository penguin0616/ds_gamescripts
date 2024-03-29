local assets =
{
    Asset("ANIM", "anim/doydoy_nest.zip"),
}

local prefabs =
{
    "doydoyegg",
    "doydoybaby",
}

local function TrackInSpawner(inst)
    local ground = GetWorld()
    if ground and ground.components.doydoyspawner then
        ground.components.doydoyspawner:StartTracking(inst)
    end
end

local function StopTrackingInSpawner(inst)
    local ground = GetWorld()
    if ground and ground.components.doydoyspawner then
        local doydoyspawner = ground.components.doydoyspawner
        if doydoyspawner:IsTracking(inst) then
            doydoyspawner:StopTracking(inst)
        end
    end
end

local function onmakeempty(inst)
    inst.AnimState:PlayAnimation("idle_nest_empty")
    inst.components.childspawner.noregen = true
    inst:RemoveTag('fullnest')
    inst.components.trader.enabled = true
    inst.components.childspawner:StopSpawning()
end

local function onpicked(inst, picker)
    onmakeempty(inst)
    StopTrackingInSpawner(inst)
end

local function onregrow(inst)
    inst.AnimState:PlayAnimation("idle_nest")
    inst.components.childspawner.noregen = false
    inst:AddTag('fullnest')
    inst.components.trader.enabled = false
    inst.components.childspawner:StartSpawning(TUNING.DOYDOY_EGG_HATCH_TIMER)
    TrackInSpawner(inst)
end

local function onvacate(inst, child)
    if inst.components.pickable then
        inst.components.pickable:MakeEmpty()
        child.sg:GoToState("hatch")
    end
    inst:Remove()
end

local function onhammered(inst)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end

    if inst.components.pickable.canbepicked then
        inst.components.lootdropper:SpawnLootPrefab("doydoyegg")
    end

    inst.components.lootdropper:DropLoot()

    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")

    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst:HasTag("fullnest") then
            inst.AnimState:PlayAnimation("hit_nest")
            inst.AnimState:PushAnimation("idle_nest")
        else
            inst.AnimState:PlayAnimation("hit_nest_empty")
            inst.AnimState:PushAnimation("idle_nest_empty")
        end
    end
end

local function itemtest(inst, item)
    return not inst.components.pickable:CanBePicked() and item:HasTag("doydoyegg")
end

local function itemget(inst, giver, item)
    inst.components.pickable:Regen()
    item:Remove()
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "doydoynest.png" )

    anim:SetBuild("doydoy_nest")
    anim:SetBank("doydoy_nest")
    anim:PlayAnimation("idle_nest", false)

    MakeObstaclePhysics(inst, 0.25)

    inst:AddTag('doydoy')
    inst:AddTag('doydoynest')
    inst:AddTag('fullnest')

    inst:AddComponent("pickable")
    --inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable:SetUp("doydoyegg", nil)
    inst.components.pickable:SetOnPickedFn(onpicked)
    inst.components.pickable:SetOnRegenFn(onregrow)
    inst.components.pickable:SetMakeEmptyFn(onmakeempty)

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    -------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "doydoybaby"
    inst.components.childspawner.spawnoffscreen = false
    inst.components.childspawner:SetRegenPeriod(10000)
    inst.components.childspawner:StopRegen()
    inst.components.childspawner:SetSpawnPeriod(0)
    inst.components.childspawner:SetSpawnedFn(onvacate)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning(TUNING.DOYDOY_EGG_HATCH_TIMER)
    inst.components.childspawner.nooffset = true

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"cutgrass", "twigs", "twigs", "doydoyfeather"})

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    TrackInSpawner(inst)
    inst:ListenForEvent("onremove", StopTrackingInSpawner)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(itemtest)
    inst.components.trader.onaccept = itemget
    inst.components.trader.enabled = false

    inst:ListenForEvent("onbuilt", function (inst)
        inst.components.pickable:MakeEmpty()
    end)

    return inst
end

return Prefab("common/objects/doydoynest", fn, assets, prefabs),
        MakePlacer("common/objects/doydoynest_placer", "doydoy_nest", "doydoy_nest", "idle_nest")
