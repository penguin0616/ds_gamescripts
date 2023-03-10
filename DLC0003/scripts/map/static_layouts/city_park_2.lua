return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 20,
  height = 20,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../../tools/tiled/dont_starve/tiles.png",
      imagewidth = 512,
      imageheight = 448,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 56, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 56, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 56, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "hedge_layered",
          shape = "rectangle",
          x = 199,
          y = 56,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hedge_layered",
          shape = "rectangle",
          x = 56,
          y = 56,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hedge_layered",
          shape = "rectangle",
          x = 56,
          y = 264,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hedge_layered",
          shape = "rectangle",
          x = 200,
          y = 264,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "pig_shop_spawner",
          shape = "rectangle",
          x = 256,
          y = 65,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "pig_shop_spawner",
          shape = "rectangle",
          x = 256,
          y = 257,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "pig_shop_spawner",
          shape = "rectangle",
          x = 256,
          y = 161,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "lawnornament_6",
          shape = "rectangle",
          x = 128,
          y = 96,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "lawnornament_6",
          shape = "rectangle",
          x = 128,
          y = 128,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "lawnornament_6",
          shape = "rectangle",
          x = 128,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "lawnornament_6",
          shape = "rectangle",
          x = 128,
          y = 192,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "lawnornament_6",
          shape = "rectangle",
          x = 128,
          y = 224,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
