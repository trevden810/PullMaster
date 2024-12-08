-- Deadmines Data
PullMaster.dungeons = PullMaster.dungeons or {}

PullMaster.dungeons.deadmines = {
    name = "The Deadmines",
    minLevel = 15,
    maxLevel = 25,
    patrols = {
        {
            id = "pat1",
            name = "Defias Watchman",
            route = {{x = 100, y = 100}, {x = 150, y = 100}},
            respawnTime = 300
        }
    },
    bosses = {
        {
            id = "boss1",
            name = "Captain Greenskin",
            position = {x = 200, y = 200},
            notes = "Test boss data"
        }
    }
}