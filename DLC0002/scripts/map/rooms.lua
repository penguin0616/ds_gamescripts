

function MakeSetpieceBlockerRoom(blocker_name)
	return	{
				colour={r=0.2,g=0.0,b=0.2,a=0.3},
				value = GROUND.IMPASSABLE,
				tags = {"ForceConnected", "RoadPoison"},
				contents =  {
								countstaticlayouts= {
									[blocker_name]=1,
								}, 
							}
			}
end

require ("map/room_functions")


local rooms = {}
function AddRoom(name, data)
	--print("AddRoom "..name)
	rooms[name] = data
end

-- "Special" rooms
require("map/rooms/test")
require("map/rooms/pigs")
require("map/rooms/merms")
require("map/rooms/chess")
require("map/rooms/spider")
require("map/rooms/walrus")
require("map/rooms/wormhole")
require("map/rooms/beefalo")
require("map/rooms/graveyard")
require("map/rooms/tallbird")
require("map/rooms/bee")
require("map/rooms/mandrake")

require("map/rooms/caves")
require("map/rooms/ruins")

require("map/rooms/blockers")
require("map/rooms/starts")

-- "Background" rooms

require("map/rooms/terrain_dirt")
require("map/rooms/terrain_forest")
require("map/rooms/terrain_grass")
require("map/rooms/terrain_impassable")
require("map/rooms/terrain_marsh")
require("map/rooms/terrain_noise")
require("map/rooms/terrain_rocky")
require("map/rooms/terrain_savanna")

require("map/rooms/terrain_sinkhole")
require("map/rooms/terrain_fungus")
require("map/rooms/terrain_cave")
require("map/rooms/terrain_mazes")

require("map/rooms/terrain_beach")
require("map/rooms/terrain_island")
require("map/rooms/terrain_jungle")
require("map/rooms/terrain_ocean")
require("map/rooms/terrain_tidalmarsh")
require("map/rooms/terrain_magmafield")
require("map/rooms/terrain_meadow")
require("map/rooms/terrain_mangrove")
require("map/rooms/shipwrecked_rooms")
require("map/rooms/water_content")
require("map/rooms/volcano")


require("map/rooms/DLCrooms")

------------------------------------------------------------------------------------
-- EXIT ROOM -----------------------------------------------------------------------
------------------------------------------------------------------------------------
AddRoom("Exit", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.FOREST, 
					contents =  {
					                countprefabs= {
					                	teleportato_base = 1,
					                    spiderden = function () return 5 + math.random(3) end,
					                    gravestone = function () return 4 + math.random(4) end,
					                    mound = function () return 4 + math.random(4) end
					                }
					            }
					})


return rooms
