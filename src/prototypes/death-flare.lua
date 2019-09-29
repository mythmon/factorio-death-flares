if settings.startup["DeathFlares_requireItems"].value then
  data:extend{
    {
      type = "item",
      name = "death-flare",
      icons = {
        {
          icon = "__DeathFlares__/graphics/icons/death-flare-1.png",
          icon_size = 176,
          scale  = 32/176,
        },
        {
          icon = "__DeathFlares__/graphics/icons/death-flare-2.png",
          icon_size = 500,
          scale  = 32/500 * .65,
          shift = {7.5,7.5},
        }
      },
      --flags = {},
      subgroup = "tool",
      order = "z[mining]-z[shovel]",
      stack_size = 1
    },

    {
      type = "recipe",
      name = "death-flare",
      enabled = false,
      ingredients =
      {
        {type="item", name="electronic-circuit", amount=5},
        {type="item", name="small-lamp", amount=5},
        {type="item", name="grenade", amount=1}
      },
      energy_required = 5,
      result= "death-flare",
      result_count = 1
    },

    {
      type = "technology",
      name = "death-flare",
      prerequisites = {"military-2"},
      icon = "__DeathFlares__/graphics/technology/death-flare.png",
      icon_size = 64,
      unit =
      {
        count = 100,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"military-science-pack", 1},
        },
        time = 20
      },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "death-flare"
        }
      },
      order = "b-d"
    },
  }
end

data:extend{
  {
    type = "smoke-with-trigger",
    name = "flare-cloud",
    flags = {"not-on-map", "placeable-off-grid", },
    show_when_smoke_off = true,
    animation =
    {
      filename = "__DeathFlares__/graphics/entity/death-flare.png",
      flags = { "compressed" },
      priority = "low",
      width = 256,
      height = 256,
      frame_count = 4,
      animation_speed = 0.1,
      line_length = 4,
      scale = 1,
    },
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = data.raw["character-corpse"]["character-corpse"].time_to_live,
    spread_duration = 10,
    --color = { r = 0.675, g = 0.078, b = 0.455 },
    color = { r = 0.824, g = 0.496, b = 0.703 },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = 0,
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 0, type = "physical"}
              }
            }
          }
        }
      }
    },
  },
}
