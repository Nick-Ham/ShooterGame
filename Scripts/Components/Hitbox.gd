extends Area3D
class_name Hitbox

var shieldImpacts : Array[Impact]

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

func _ready() -> void:
	var shieldHealth : OvershieldHealth = Util.getChildOfType(owningCharacter, OvershieldHealth)
	if shieldHealth:
		Util.safeConnect(shieldHealth.health_depleted, on_shield_depleted)

func on_shield_depleted(_inHealth : Health) -> void:
	for impact : Impact in shieldImpacts:
		if is_instance_valid(impact):
			impact.queue_free()

	shieldImpacts.clear()

func addImpact(inHitPosition : Vector3, inHitNormal : Vector3) -> void:
	var shieldHealth : OvershieldHealth = Util.getChildOfType(owningCharacter, OvershieldHealth)
	if shieldHealth and !shieldHealth.isHealthDepleted:
		shieldImpacts.append(ImpactHelper.createShieldImpact(self, inHitPosition, inHitNormal))
		return

	ImpactHelper.createMetalImpact(self, inHitPosition, inHitNormal)


static func getHitboxes(inParent : Node) -> Array[Hitbox]:
	var allChildren : Array[Node] = Util.getChildrenRecursive(inParent)
	var hitboxes : Array[Hitbox] = []

	for child : Node in allChildren:
		var childAsHitbox : Hitbox = child as Hitbox
		if !childAsHitbox:
			continue

		hitboxes.append(child)

	return hitboxes

static func getHitboxRIDs(inHitboxes : Array[Hitbox]) -> Array[RID]:
	var hitboxRIDs : Array[RID] = []

	for hitbox : Hitbox in inHitboxes:
		hitboxRIDs.append(hitbox.get_rid())

	return hitboxRIDs