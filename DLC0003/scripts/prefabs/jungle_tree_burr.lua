require "prefabutil"
local assets =
{
	Asset("ANIM", "anim/burr.zip"),
}

local function growtree(inst)
	print ("GROWTREE")
    inst.growtask = nil
    inst.growtime = nil
    
    local ground = GetWorld()
    local x,y,z = inst.Transform:GetWorldPosition()
    local treetype = "rainforesttree_short"

    if ground.Map and ground.Map:GetTileAtPoint(x, y, z) == GROUND.GASJUNGLE then
        treetype = "rainforesttree_rot_short"
    end

    local tree = SpawnPrefab(treetype) 

    if tree then 
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition() ) 
        tree:growfromseed()--PushEvent("growfromseed")
        inst:Remove()
	end
end

local function plant(inst, growtime)
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("locomotor")
    RemovePhysicsColliders(inst)
    RemoveBlowInHurricane(inst)    
    inst.AnimState:PlayAnimation("sprout")
    inst.AnimState:PushAnimation("idle_planted")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
    inst.growtime = GetTime() + growtime
    print ("PLANT", growtime)
    inst.growtask = inst:DoTaskInTime(growtime, growtree)
end


local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
	local ground_OK = inst:GetIsOnLand(pt.x, pt.y, pt.z)
    local tiletype = GetGroundTypeAtPosition(pt)
    ground_OK = ground_OK and
						tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and tiletype ~= GROUND.INTERIOR and
                        tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
                        tiletype ~= GROUND.FOUNDATION and tiletype ~= GROUND.COBBLEROAD and 
                        tiletype ~= GROUND.LAWN and tiletype ~= GROUND.FIELDS and 
                        tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function ondeploy (inst, pt) 
    inst = inst.components.stackable:Get()
    inst.Transform:SetPosition(pt:Get() )
    local timeToGrow = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
    plant(inst, timeToGrow)	
    inst:AddTag("jungletree")
end

local function hatchtree(inst) 
    local pt = inst:GetPosition() 
    local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 20, {"jungletree"},{"stump"})
    if #ents < 4 and test_ground(inst, pt) then
        ondeploy (inst, pt)
    else
        if inst:GetIsOnWater() then
            inst.AnimState:PlayAnimation("disappear_water")
        else
            inst.AnimState:PlayAnimation("disappear")
        end
        inst.persists = false
        inst:ListenForEvent("animover", inst.Remove)
        inst:ListenForEvent("entitysleep", inst.Remove)
    end
end

local function stopgrowing(inst)
    if inst.growtask then
        inst.growtask:Cancel()
        inst.growtask = nil
    end
    inst.growtime = nil
end

local function restartgrowing(inst)
    if inst and not inst.growtask and not inst.components.inventoryitem then -- It won't have inventoryitem component if it's already a sapling.
        local growtime = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
        inst.growtime = GetTime() + growtime
        inst.growtask = inst:DoTaskInTime(growtime, growtree)
    end
end



local function describe(inst)
    if inst.growtime then
        return "PLANTED"
    end
end

local function displaynamefn(inst)
    if inst.growtime then
        return STRINGS.NAMES.BURR_SAPLING
    end
    return STRINGS.NAMES.BURR
end

local function OnSave(inst, data)
    if inst.growtime then
        data.growtime = inst.growtime - GetTime()
    end

    if inst.taskgrowinfo then
        data.taskgrow = inst:TimeRemainingInTask(inst.taskgrowinfo)
    end
end

local function OnLoad(inst, data)
    if data and data.growtime then
        plant(inst, data.growtime)
    end

    if data and data.taskgrow then
        if inst.taskgrow then inst.taskgrow:Cancel() inst.taskgrow = nil end
        inst.taskgrowinfo = nil
        inst.taskgrow, inst.taskgrowinfo = inst:ResumeTask(data.taskgrow, function() hatchtree(inst)  end)
    end  
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)

    inst.AnimState:SetBank("burr")
    inst.AnimState:SetBuild("burr")
    inst.AnimState:PlayAnimation("idle")
    

    MakeInventoryFloatable(inst, "idle_water", "idle")
    inst:AddTag("plant")
    inst:AddTag("cattoy")
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = describe
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL
    
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	inst:ListenForEvent("onignite", stopgrowing)
    inst:ListenForEvent("onextinguish", restartgrowing)
    MakeSmallPropagator(inst)
    inst.components.burnable:MakeDragonflyBait(3)
    
    inst:AddComponent("inventoryitem")
    
    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = ondeploy
    
    inst.displaynamefn = displaynamefn

    inst:ListenForEvent("seasonChange", function(it, data) 
            if data.season ~= SEASONS.LUSH and not inst:HasTag("jungletree") then
                inst.taskgrow, inst.taskgrowinfo = inst:ResumeTask( math.random()* TUNING.TOTAL_DAY_TIME/2,function()
                    hatchtree(inst)
                end)
            end
        end, GetWorld())

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab( "common/inventory/burr", fn, assets),
	   MakePlacer( "common/burr_placer", "burr", "burr", "idle_planted" ) 


