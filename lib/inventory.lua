Inventory = {}

-- Server definition and functions
Inventory.Server = {}
Inventory.Server.RegisterItemDefinition = NotImplemented;
Inventory.Server.UnregisterItemDefinition = NotImplemented;
Inventory.Server.AddItem = NotImplemented;
Inventory.Server.PutItem = NotImplemented;
Inventory.Server.RemoveItem = NotImplemented;

-- Client definition and functions
Inventory.Client = {}
Inventory.Client.OpenInventory = NotImplemented;
Inventory.Client.CloseInventory = NotImplemented;
Inventory.Client.DropItem = NotImplemented;

-- Shared definition and functions
Inventory.Shared = {}


function NotImplemented() {
    --TODO: Remove.
    local debug = true;
    if debug then print("Oof, tried calling an unimplemented function") end

    return
}