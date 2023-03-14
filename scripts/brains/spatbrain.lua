require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/runaway"

local MAX_CHASE_TIME = 6
local WANDER_DIST_DAY = 20
local WANDER_DIST_NIGHT = 5

local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 9
local START_FACE_DIST = 14
local KEEP_FACE_DIST = 20
local FORCE_MELEE_DIST = 4

local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player",inst, START_FACE_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return target:IsValid() and
        not target:HasTag("notarget") and
        inst:IsNear(target, KEEP_FACE_DIST)
end

local CANT_TAGS =  {'notarget'}
local MUST_ONE_OF_TAGS = {"character", "monster"}

local function ShouldRunAway(inst)
    return FindEntity(inst, RUN_AWAY_DIST, nil, nil, CANT_TAGS, MUST_ONE_OF_TAGS)
end

local function CanMeleeNow(inst)
    local target = inst.components.combat.target
    if target == nil or inst.components.combat:InCooldown() then
        return false
    end
    if target.components.pinnable ~= nil then
        return not target.components.pinnable:IsValidPinTarget()
    end
    return inst:IsNear(target, FORCE_MELEE_DIST)
end

local function EquipMeleeAndResetCooldown(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.combat:ResetCooldown()
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
    end
end

local function EquipMelee(inst)
    if not inst.weaponitems.meleeweapon.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
    end
end

local function CanPhlegmNow(inst)
    local target = inst.components.combat.target
    return target ~= nil and target.components.pinnable and target.components.pinnable:IsValidPinTarget() and not inst.components.combat:InCooldown()
end

local function EquipPhlegm(inst)
    if not inst.weaponitems.snotbomb.components.equippable:IsEquipped() then
        inst.components.inventory:Equip(inst.weaponitems.snotbomb)
    end
end

local Spatbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function Spatbrain:OnStart()

    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        WhileNode(function() return CanMeleeNow(self.inst) end, "Hit Stuck Target or Creature",
            SequenceNode({
                ActionNode(function() EquipMeleeAndResetCooldown(self.inst) end, "Equip melee"),
                ChaseAndAttack(self.inst, MAX_CHASE_TIME) })),
        WhileNode(function() return CanPhlegmNow(self.inst) end, "AttackMomentarily",
            SequenceNode({
                ActionNode(function() EquipPhlegm(self.inst) end, "Equip phlegm"),
                ChaseAndAttack(self.inst, MAX_CHASE_TIME) })),
        RunAway(self.inst, ShouldRunAway, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        -- SequenceNode({ -- This makes Spat chase after non-player targets
        --     ActionNode(function() EquipMelee(self.inst) end, "Equip melee"),
        --     ChaseAndAttack(self.inst, MAX_CHASE_TIME) }),
        Wander(self.inst)
    }, .25)

    self.bt = BT(self.inst, root)
end

return Spatbrain
