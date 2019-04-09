--[[
    Description:
        This create a new inventory in our resource. Each inventory can define
        it's own theme, style, size and owner.

    Flow:
        1) Function gets invoked via public API.
        2) The name will get converted to an unique hash (seeded)
        3) System will check if there is already such hash in the cache (faster than doing the database call first).
            3a) If exists in cache, system will return from the function, logging the event.
        4) System will query the database to check for duplicates.
            4b) If exists in database, system will return from the function, logging the event.
        5) Add the inventory to the database.
        6) Cache the inventory locally.

    Returns:
        The hash of the inventory.

    Usage:
        Each inventory has a name, which will get hashed to avoid collisions.
        Then a table of data. 
            Theme: On a per inventory basis you can set the theme the inventory should use.
            Style: On a per inventory basis you can set the style, single or tetris.
                As where tetris is non-uniform items and single always 1x1 items.
            Dimensions: The size of the inventory.
            Owner: possible owner of the inventory, keep nil if it's a public inventory.
    
    Security:
        - This cannot be invoked by the client via the public interface.
        - Be aware of possible in-direct creation of these inventories, if so, please do the proper checks before hand.
          If this is not the case, this could lead to possible denial of service.
        - DO: Prefer inventory creation on server side without client influence.

    Pitfalls
        - What if theme doesn't exist?
        - What if style doesn't exist?
        - Do a sanity check for dimensions.
        - Is there a way to possibly detect invalid inventories?
          To prevent user with malicious intent to create infinite amount of inventories.
]]
local inventory = Inventory.Server.CreateInventory("trunk-149520", {
    Theme = "default",
    Style = "tetris",
    Dimensions = vector2(8, 8),
    Owner = nil,
});

--[[
    Description:
        RequestInventory allows you to fetch the hash of the inventory.
        It does not return the object, as that would be useless.
        You need to request the hash to manipulate an existing inventory.

    Flow:
        1) Function gets invoked via public API.
        2) The name will get converted to an unique hash (seeded)
        3) Cache will be check the existance for this hash.
            3a) If not in cache, try fetching it from database
                3aa) If not found, return ""
        4) Return the inventory hash.

    Returns:
        The hash of the inventory. Returns an empty string is no hash was found.

    Usage:
        Input the human readable name of the inventory. 
        This will return the hash to the inventory.
    
    Security:
        - This cannot be invoked by the client via the public interface.
        - Keep the hash on the serverside, it being on the client means that any abusers
          can possibly manipulate the inventory.

    Pitfalls
        - What if we have no way of knowing the HR name?
]]
local inventory = Inventory.Server.RequestInventory("some_name");

-- Do we even want this? Seems prone to abuse.
local inventory = Inventory.Server.RemoveInventory("some_name");