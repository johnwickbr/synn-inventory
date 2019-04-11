resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- IMPORT // Import the definitions, don't touch this.
server_scripts {
    "lib/inventory.lua",
    "src/shared/sha256.lua",
    "src/server/inv.server-def.lua",
}

-- DATABASE // Configure your database connector stuff, read the wiki first though.
dependency "mesh_database"

database_files "" {
    "sql/inventory.sql"
}

server_scripts {
    "@mesh_lib/def.lua",
    "@mesh_lib/server/database.lua",
    "src/adapters/database-mdb.lua"
}

-- CORE // Inventory system files, probably don't touch this. Unless you are Chuck Norris.
server_scripts {
    "src/server/inv.server-cache.lua",
    "src/server/inv.server.lua"
}

server_exports {
    "CreateInventory"
}