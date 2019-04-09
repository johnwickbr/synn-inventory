
class InventoryView {
    constructor(config, helper, controller) {
        this.config = config;
        this.helper = helper;
        this.controller = controller

        this.element = document.getElementById(this.config.element);

        this.details = {
            header: document.getElementById("item-info-header"),
            image: document.getElementById("item-info-image"),
            description: document.getElementById("item-info-desc")
        }

        if(this.helper.IsInvalidObject(this.element)) {
            this.helper.LogError("Could not find element to bind inventory to")
            return;
        }

        this.slots = [];
        this.createInventory();
    }

    _createSlot(width, margin, x, y, cbDragStart, cbDragEnd, cbClick) {
        let slot = document.createElement("div");
        slot.classList.add("slot");
        slot.classList.add("slot-bg");
        slot.style.width = width + "%" 
        slot.style.paddingBottom = width + "%";
        slot.style.margin = margin + "%";
        slot.style.backgroundImage = "url(assets/theme/slot.png)";
        slot.style.userSelect = "none";

        let slotContent = document.createElement("div");
        slotContent.classList.add("slot-content");
        slotContent.style.userSelect = "none";

        let slotDesc = document.createElement("span");
        slotDesc.classList.add("slot-desc");
        slotDesc.innerHTML = ""
        slotDesc.style.userSelect = "none";

        let slotImage = document.createElement("img");
        slotImage.classList.add("slot-img");
        slotImage.classList.add("hide");
        slotImage.style.userSelect = "none";

        let slotDragDrop = document.createElement("div");
        slotDragDrop.id = `${x}-${y}`
        slotDragDrop.classList.add("slot-drag-drop");
        slotDragDrop.draggable = true;
        slotDragDrop.style.userSelect = "none";

        slotDragDrop.addEventListener("dragstart", (event) => { 
            event.stopPropagation();

            //Set an empty image when dragging
            var img = new Image();
            img.src = 'data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=';
            event.dataTransfer.setDragImage(img, 0, 0);
            cbDragStart(x, y);
        });

        slotDragDrop.addEventListener("dragover", (event) => { 
            event.preventDefault();
         });
        
        slotDragDrop.addEventListener("drop", (event) => { 
            let tokens = event.target.id.split("-");
            cbDragEnd(parseInt(tokens[0]), parseInt(tokens[1]));
        });

        slotDragDrop.addEventListener("click", (event) => {
            let tokens = event.target.id.split("-");
            cbClick(parseInt(tokens[0]), parseInt(tokens[1]));
        });

        slotContent.appendChild(slotDesc);
        slotContent.appendChild(slotImage);
        slotContent.appendChild(slotDragDrop);
        slot.appendChild(slotContent);

        return {
            slot: slot,
            content: slotContent,
            desc: slotDesc,
            img: slotImage
        };
    }

    createInventory() {
        let itemMargin = 0.15;
        let itemWidth = (100.0 / this.config.width) - (itemMargin * 2.0);
        
        for(let x = 0; x < this.config.width; x++) {
            for(let y = 0; y < this.config.height; y++) {

                //NOTE: These all need to use arrow syntax.
                //      Otherwise to loose reference to "this".
                let dragCallback = (x, y) => { 
                    this.controller.onDragAction(x, y); 
                }

                let dropCallback = (x, y) => { 
                    this.controller.onDropAction(x, y); 
                }

                let clickCallback = (x, y) => {
                    this.controller.onClickAction(x, y);
                }

                let slotElements = this._createSlot(
                    itemWidth, itemMargin, 
                    x, y, 
                    dragCallback,
                    dropCallback,
                    clickCallback
                );
                
                let index = this.helper.ToContiguousIndex(this.config.width, x, y); 
                this.slots[index] = slotElements;

                this.element.appendChild(slotElements.slot);
            }
        }
    }

    setSlot(data, count, x, y) {
        let index = this.helper.ToContiguousIndex(this.config.width, x, y);
        let slot = this.slots[index];

        if(slot.img.classList.contains("hide")) {
            slot.img.classList.remove("hide");
        }

        slot.img.src = `assets/img/${data.image}.png`;
        slot.img.onerror = () => {
            slot.img.src = `assets/img/ic_undefined.png`;
        }

        slot.desc.innerHTML = count + "x";
    }

    clearSlot(x, y) {
        let index = this.helper.ToContiguousIndex(this.config.width, x, y);
        let slot = this.slots[index];

        if(!slot.img.classList.contains("hide")) {
            slot.img.classList.add("hide");
        }

        slot.img.src = `assets/img/ic_undefined.png`;

        slot.img.onerror = () => {
            slot.img.src = "";
        }

        slot.desc.innerHTML = "";
    }

    viewItem(data, count) {
        let name = count > 1 ? 
            data.namePlural : 
            data.name;

        if(count > 1) {
            this.details.header.innerHTML = `${name} (${count}x)`;
        }
        else {
            this.details.header.innerHTML = `${name}`;
        }

        this.details.image.src = `assets/img/${data.image}.png`;
        this.details.description.innerHTML = data.description;
    }

    clearViewItem() {
        this.details.header.innerHTML = "";
        this.details.image.src = "";
        this.details.description.innerHTML = "";
    }
}