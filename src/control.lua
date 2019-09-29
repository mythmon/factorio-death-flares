DeathFlares = {}

function DeathFlares.init(self)
  if not self.inited then
    self.inited = true
    self.flares = {}
  end
end

function DeathFlares.onPrePlayerDied(self, playerId, deathTick)
  local shouldCreateFlare = false

  if settings.startup["DeathFlares_requireItems"].value then
    -- Check if the player has the required item
    local player = game.players[playerId]
    local playerInventory = player.get_main_inventory()
    if playerInventory then
      local playerInventoryContent = playerInventory.get_contents()

      if playerInventoryContent and playerInventoryContent["death-flare"] and playerInventoryContent["death-flare"] > 0 then
        playerInventory.remove{name="death-flare", count=1}
        self:createNewFlare(playerId, deathTick)
      end
    end
  else -- Don't require the item
    shouldCreateFlare = true
  end

  if shouldCreateFlare then
    self:createNewFlare(playerId, deathTick)
  end
end

function DeathFlares.createNewFlare(self, playerId, deathTick)
  local player = game.players[playerId]
  local flare = player.surface.create_entity{
    name="flare-cloud",
    position = {
      x = player.position.x + 3.25,
      y = player.position.y - 2.5,
    },
    force = 'enemy',  -- So it can't be mined?
    speed = 0.15,
  }
  table.insert(self.flares, {
    flare = flare,
    playerId = playerId,
    deathTick = deathTick
  })
end

function DeathFlares.removeFlare(self, playerId, deathTick)
  local player = game.players[playerId]
  if not player then
    return
  end

  for _, flareMeta in ipairs(self.flares) do
    if flareMeta.playerId == playerId and flareMeta.deathTick == deathTick then
      flareMeta.flare.destroy()
      table.remove(self.flares, flare)
      return
    end
  end
end

function DeathFlares.onEntityMined(self, event)
  if event.entity.valid and event.entity.name == 'character-corpse' then
    DeathFlares:removeFlare(event.entity.character_corpse_player_index, event.entity.character_corpse_tick_of_death)
  end
end

-- on load game for first time
script.on_init(function(event)
  DeathFlares:init()
end)

-- called every time a player dies
script.on_event(defines.events.on_pre_player_died, function(event)
  DeathFlares:onPrePlayerDied(event.player_index, event.tick)
end)

-- called when any character corpse expires naturally
script.on_event(defines.events.on_character_corpse_expired, function(event)
  DeathFlares:removeFlare(event.corpse.character_corpse_player_index, event.corpse.character_corpse_tick_of_death)
end)

-- called when any entity is mined
script.on_event(defines.events.on_player_mined_entity, function (event)
  DeathFlares:onEntityMined(event)
end)
