resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

--Setup database and the database adapter.
dependency "mesh_database"
server_scripts {
    "@mesh_lib/def.lua",
    "@mesh_lib/server/database.lua",
    "src/adapters/database-mdb.lua"
}

--If you want to use mysql-async:
-- dependency "mysql-async"
-- server_script {
--     "@mysql-async/lib/MySQL.lua"
--     "src/adapters/database-mysql.lua"
-- }

server_scripts {
    "lib/inventory.lua", -- Load all the definitions.
    "src/shared/sha256.lua",
    "src/server/inv.server-def.lua",

    "src/server/inv.server-cache.lua",
    "src/server/inv.server.lua"
}

server_exports {
    "CreateInventory"
}