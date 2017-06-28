function init()
	animator.setParticleEmitterOffsetRegion("l9m2_nefariousparticle", mcontroller.boundBox())
	animator.setParticleEmitterActive("l9m2_nefariousparticle", true)
	effect.setParentDirectives("fade=FF8800=0.2")
  
	script.setUpdateDelta(20)

	self.tickTime = 1
	self.tickTimer = self.tickTime
	self.damage = 10
	playerId = entity.id()

	status.applySelfDamageRequest({
		damageType = "IgnoresDef",
		damage = 10,
		sourceEntityId = entity.id()
		})
end

function update(dt)
	self.tickTimer = self.tickTimer - dt
	if self.tickTimer <= 0 then
		self.tickTimer = self.tickTime
		self.damage = self.damage + (self.damage * .5)
		status.applySelfDamageRequest({
			damageType = "IgnoresDef",
			damage = self.damage,
			sourceEntityId = entity.id()
		})
		if not self.msgsent then
			world.sendEntityMessage(playerId, "queueRadioMessage", {messageId = "l9m2_nefariousstatusmsg", unique= false, text = "You're quickly ^red;desolving!^reset; Exit the liquid immediately!", textSpeed = 70})
			self.msgsent = 1
		end
	end
end

function uninit()
	status.addEphemeralEffect("l9m2_nefariousse")
end
