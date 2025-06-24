---------------------------------------------
-- Replaces UI textures of containers with gore-y graphics (corpses, spiders, etc.)
---------------------------------------------

-- Determines inventory texture and sounds.
---@enum InventoryType
INVENTORY_TYPES = {
    BARREL = 1,
    CRATE = 2,
    BASKET = 3,
    CHEST = 4,
    SACK = 5,
    BEE_HIVE = 6,
    SKELETON = 7, -- "DOS2_Corpse"
    CORPSE = 8,
    WOOD = 9, -- Wooden box
    VASE = 10,
    BACKPACK = 11,
    BLOODSTONE = 12, -- Tomb-like
    DUNG = 13,
    HOLE = 14,
    NEST = 15,
    TREE_TRUNK = 16,
    SPIDER_CORPSE = 17,
    WEB_CORPSE = 18,
    STONE = 19, -- Tomb
    SHEEP = 20,
    FISH_RACK = 21,
    FISH_PILE = 22,
    ORANGE = 23,
    ROUND_BASKET = 24,
    CUPBOARD = 25,
    BOOK = 26,
    BOOK_ROW = 27,
    PICKPOCKET = 28,
    CUPBOARD_RICH = 29,
}

---Maps container type to texture resource.
---@type table<InventoryType, GUID>
INVENTORY_TEXTURES = {
    [INVENTORY_TYPES.BARREL] = "90b7c544-5561-4855-9ac4-c00d6386e36b",
    [INVENTORY_TYPES.CRATE] = "5928120b-f12b-45d8-9d61-9e2139bc3b51",
    [INVENTORY_TYPES.BASKET] = "b5b1d87b-c065-4f19-8a3d-2dddc168d014",
    [INVENTORY_TYPES.CHEST] = "eac52c43-95f0-4932-8787-fc5d4a58ada1",
    [INVENTORY_TYPES.SACK] = "95e38cfb-c043-4480-a944-90573d16eb87",
    [INVENTORY_TYPES.BEE_HIVE] = "eaa1f45f-e9fa-41ee-bb2e-a4a35318e184",
    [INVENTORY_TYPES.SKELETON] = "c1b9d991-cec7-4566-84c7-bbcc64a8f088",
    [INVENTORY_TYPES.CORPSE] = "f62927ec-d3c9-4561-850f-58b21456761f", -- 
    [INVENTORY_TYPES.WOOD] = "b674661f-55e8-46a3-a8f6-40943166f9a5",
    [INVENTORY_TYPES.VASE] = "8ce8f11c-7f94-4cbf-8c01-c1038ad4ce20",
    [INVENTORY_TYPES.BACKPACK] = "8f55a912-bd8a-490f-9bb4-96a5ef0b93b9",
    [INVENTORY_TYPES.BLOODSTONE] = "1e76fa0d-ecaf-4b0d-b818-8b85f6b0052c",
    [INVENTORY_TYPES.DUNG] = "70979410-7456-44ef-b01a-3a3040db0364",
    [INVENTORY_TYPES.HOLE] = "ef3155df-10ab-4d09-95ce-51a1b81916da",
    [INVENTORY_TYPES.NEST] = "c981936d-fbf9-419e-b943-e054875b28ef",
    [INVENTORY_TYPES.TREE_TRUNK] = "1dd6eb37-b532-473f-96b6-4cc713f640df",
    [INVENTORY_TYPES.SPIDER_CORPSE] = "93ee5bc4-e345-4299-90bb-0ad248bb78e8",
    [INVENTORY_TYPES.WEB_CORPSE] = "a33ef2b9-e20a-4043-be3b-c7b30fb28ca2",
    [INVENTORY_TYPES.STONE] = "6e0486f1-e268-47d9-bb30-28b9230124a2",
    [INVENTORY_TYPES.SHEEP] = "939fcca2-0962-4140-a739-46a61a784443",
    [INVENTORY_TYPES.FISH_RACK] = "9f500c21-8146-467f-8dc0-bd7f1de020b3",
    [INVENTORY_TYPES.FISH_PILE] = "a6ebc983-4419-462c-b2f6-b78e83547ad1",
    [INVENTORY_TYPES.ORANGE] = "d5106a28-93a6-48aa-ae38-9a5cac282fd2",
    [INVENTORY_TYPES.ROUND_BASKET] = "c109006f-cc63-45bd-b81f-c3f4af843e79",
    [INVENTORY_TYPES.CUPBOARD] = "7b022b33-0538-4735-8505-0c8ca62784a2",
    [INVENTORY_TYPES.BOOK] = "226a5c6d-3656-42d4-a59e-cd9994e51836",
    [INVENTORY_TYPES.BOOK_ROW] = "7b5c7153-b0de-4b37-9b23-8e16da565e7d",
    [INVENTORY_TYPES.PICKPOCKET] = "abb0712a-4ae7-4ee0-8144-f9347cae95f5",
    [INVENTORY_TYPES.CUPBOARD_RICH] = "286865dc-c22b-4e1b-a775-bc3522c47d16",
}

-- Remaps offensive inventory types to other ones.
---@type table<InventoryType, InventoryType>
CONTAINER_REMAP = {
    [INVENTORY_TYPES.CORPSE] = INVENTORY_TYPES.PICKPOCKET,
    [INVENTORY_TYPES.SKELETON] = INVENTORY_TYPES.PICKPOCKET,
    [INVENTORY_TYPES.SPIDER_CORPSE] = INVENTORY_TYPES.PICKPOCKET,
    [INVENTORY_TYPES.WEB_CORPSE] = INVENTORY_TYPES.NEST,
    [INVENTORY_TYPES.DUNG] = INVENTORY_TYPES.HOLE,
}

-- Swap container textures.
Ext.Events.UIInvoke:Subscribe(function (ev)
    local ui = ev.UI
    if ui:GetTypeId() == Ext.UI.TypeID.containerInventory.Default and ev.Function == "setContainerType" then
        local containerID = ev.Args[1]

        -- Swap container types.
        local remappedId = CONTAINER_REMAP[containerID]
        if remappedId then
            ev:PreventAction()
            ui:GetRoot().setContainerType(remappedId, INVENTORY_TEXTURES[remappedId]) -- Type ID is used to determine clickbox.
        end
    end
end)
