--L9M2: I'll prefix my comments with "l9m2"
-- HEAVILY Copied from Frackin Universes basictilegroundeffects
-- Modified to not include things such as softness,
-- bounciness, or other unneeded things; Just only apply a status effect.
-- Most credit goes to Sayter for this!

--Note: Brittle tiles not included

function init()				 --l9m2
  tileMaterials()			 --what blocks get a special effect, see bottom of lua
  self.airJumpModifier = 1	 --Seems to check if the player is in air and jumped off said block
  sb.logInfo("DING!") 		 --Debugging
end

function update(dt)
  if not mcontroller.onGround() and self.airJumpModifier ~= 1 then
    mcontroller.controlModifiers({airJumpModifier = self.airJumpModifier})
  end
  local softness = 1    
  if mcontroller.onGround() then
    self.airJumpModifier = 1
    local groundMat = groundContact()
    if self.matCheck[groundMat] then
      applyTileEffects(self.matCheck[groundMat])
    end
  end
end

--l9m2: Does any blocks in FU even apply multiple ephemeral effects at once?
-- Or does it mean if I was standing of two different tiles that apply an effect?
function applyTileEffects(groundMat)
  -- sb.logInfo("groundMat: %s", groundMat)
  for i, effect in ipairs(groundMat[1]) do -- so multiple Ephemeral Effects possible from a tile
    -- sb.logInfo("looking at %s / %s", i, effect)
    status.addEphemeralEffects({effect})
  end
end


--l9m2:
-- Hell, I don't even think I *can't* exclude this without it breaking
-- checks if the player stands on blocks (and possibly within them?)
-- good if the player is standing and not in a "falling" state.

function groundContact()
  local mpos = mcontroller.position()
  local position = {mpos[1],math.floor(mpos[2])}
  local groundMat = world.material(vec2.add({position[1],position[2]}, {0,-2.5}), "foreground")
  local offset = 0
  if groundMat == false then
    if mpos[1] - math.floor(mpos[1]) < 0.5 then
      groundMat = world.material(vec2.add(position, {-1,-2.5}), "foreground")
      offset = -1
    else
      groundMat = world.material(vec2.add(position, {1,-2.5}), "foreground")
      offset = 1
    end
  end
  if groundMat == false then
    local stoodOnObject = world.objectQuery(vec2.add({position[1],position[2]}, {0,-2.5}), 0.1, {order = "nearest"})
    if stoodOnObject == false then
      if mpos[1] - math.floor(mpos[1]) < 0.5 then
        stoodOnObject = world.objectQuery(vec2.add(position, {-1,-2.5}), 0.1, {order = "nearest"})
        offset = -1
      else
        stoodOnObject = world.objectQuery(vec2.add(position, {1,-2.5}), 0.1, {order = "nearest"})
        offset = 1
      end
    end
    if #stoodOnObject >= 1 then
      stoodOn = tostring(world.entityName(stoodOnObject[1]))
    end
  else
  end
  return groundMat, offset, stoodOn or false
end

function tileMaterials()
--L9M2: Now this is where my code differs from Sayters vastly, as instead of checking all the nonsense
-- for how bouncy or how much friction the block has, all I need is just the status effect.
-- Example is taking the original block for mud:
--   ["mud"] = 	     		{{"someeffect"},  0.8, 1,   1,   14,   101, 0.25,    0,  1.75, 0}
-- And turning it into this:
--   ["mud"] = 	     		{{"someeffect"}}
  self.matCheck = { 
  ["l9m2_nefarious"] = {{"l9m2_nefariousse"}}
  }
end





















