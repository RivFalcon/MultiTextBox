----
SMODS.Atlas({
    key = "modicon",
    path = "modicon.png",
    px = 32,
    py = 32
})

local DFR = desc_from_rows
function desc_from_rows(desc_nodes, empty, maxw, _c)
    if _c == nil then return DFR(desc_nodes, empty, maxw) end
    if _c.ability_UIBox_table.card_type == 'Locked' then return DFR(desc_nodes, empty, maxw) end
    if _c.ability_UIBox_table.card_type == 'Undiscovered' then return DFR(desc_nodes, empty, maxw) end
    if type(desc_nodes) ~= 'table' then return DFR(desc_nodes, empty, maxw) end

    local loc_target = G.localization.descriptions[_c.set][_c.key]
    if loc_target == nil then return DFR(desc_nodes, empty, maxw) end
    if type(loc_target.boxes) ~= 'table' then return DFR(desc_nodes, empty, maxw) end

    local total_line_numbers = 0
    for _, box_line_number in ipairs(loc_target.boxes) do
        total_line_numbers = total_line_numbers + box_line_number
    end
    if total_line_numbers ~= #loc_target.text then
        sendDebugMessage("Warning: Sum of ".._c.key..".loc_txt.boxes does not match with #".._c.key..".loc_txt.text!")
        return DFR(desc_nodes, empty, maxw)
    end

    local box = {}
    local last_line_number = 0
    for _, box_line_number in ipairs(loc_target.boxes) do
        local t = {}
        for current_subline_number=1, box_line_number do
            t[#t+1] = {
                n=G.UIT.R,
                config={
                    align = "cm"
                },
                nodes = desc_nodes[last_line_number + current_subline_number]
            }
        end
        box[#box+1]={
            n=G.UIT.R,
            config={
                align = "cm",
                colour = G.C.UI.BACKGROUND_WHITE,
                r = 0.05,
                padding = 0.03
            },
            nodes=t
        }
        last_line_number = last_line_number + box_line_number
    end
    return {
        n=G.UIT.R,
        config={
            align = "cm",
            padding = 0.04,
            minh = 0.8,
            emboss = not empty and 0.05 or nil,
            filler = true
        },
        nodes=box
    }
end
----