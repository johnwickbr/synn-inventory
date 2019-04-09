class InventoryController {
    constructor(config, helper) { 
        this.config = config;
        this.helper = helper;
        this.model = new InventoryModel(config, helper, this);

        this.self = this;
        this.dragStart = {};
    }

    onAddItemDefinition(item) {
        this.model.addItemDefinition(item);
    }

    onAddItemDefinitions(items) {
        items.forEach(e => {
            this.onAddItemDefinition(e);
        });
    }

    onAddItem(name, count, x, y) {
        this.model.addItem(name, count, x, y);
    }

    onPutItem(name, count) {
        this.model.putItem(name, count);
    }

    onDragAction(dragX, dragY) {
        this.dragStart = { x: dragX, y: dragY };
    }

    onDropAction(dropX, dropY) {
        let dragEnd =  { x: dropX, y: dropY };
        this.model.moveItem(this.dragStart, dragEnd)
    }

    onClickAction(x, y) {
        this.model.viewItem(x, y);
    }
}