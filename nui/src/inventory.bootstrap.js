class Inventory {
    constructor(config) { 

        this.helper = new InventoryHelper();
        
        if(!this._checkConfig(config)) {
            this.helper.LogError("Woops, config is invalid!");
            return;
        }

        this.controller = new InventoryController(config, this.helper);
    }

    _checkConfig(config) {
        if(this.helper.IsInvalidString(config.name)) {
            this.helper.LogError(`config.name is not a valid string, given: ${config.name}`)
            return false;
        }

        if(this.helper.IsInvalidString(config.element)) {
            this.helper.LogError(`config.element is not a valid string, given: ${config.element}`)
            return false;
        }

        if(this.helper.IsInvalidNumber(config.width, 0, MAX_INVENTORY_SIZE)) {
            this.helper.LogError(`config.width is not a valid interger, given: ${config.width}`)
            return false;
        }

        if(this.helper.IsInvalidNumber(config.height, 0, MAX_INVENTORY_SIZE)) {
            this.helper.LogError(`config.height is not a valid interger, given: ${config.height}`)
            return false;
        }

        return true;
    }

    addItemDefinition(item) {
        this.controller.onAddItemDefinition(item);
    }

    addItemDefinitions(items) {
        this.controller.onAddItemDefinitions(items);
    }

    removeItemDefinition(name) {

    }

    addItem(name, count, x, y) {
        this.controller.onAddItem(name, count, x, y);
    }

    putItem(name, count) {

    }

    removeItem(count, x, y) {

    }

    removeItemByName(name) {

    }
}