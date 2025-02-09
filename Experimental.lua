
local CHPU = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    if card.ability_UIBox_table then
        local AUT = card.ability_UIBox_table
        if AUT.namelines == nil then return CHPU(card) end
        local debuffed = card.debuff
        local card_type_colour = get_type_colour(card.config.center or card.config, card)
        local card_type_background = 
            (AUT.card_type == 'Locked' and G.C.BLACK) or 
            ((AUT.card_type == 'Undiscovered') and darken(G.C.JOKER_GREY, 0.3)) or 
            (AUT.card_type == 'Enhanced' or AUT.card_type == 'Default') and darken(G.C.BLACK, 0.1) or
            (debuffed and darken(G.C.BLACK, 0.1)) or 
            (card_type_colour and darken(G.C.BLACK, 0.1)) or
            G.C.SET[AUT.card_type] or
            {0, 1, 1, 1}

        local outer_padding = 0.05
        local card_type = localize('k_'..string.lower(AUT.card_type))

        if AUT.card_type == 'Joker' or (AUT.badges and AUT.badges.force_rarity) then card_type = ({localize('k_common'), localize('k_uncommon'), localize('k_rare'), localize('k_legendary')})[card.config.center.rarity] end
        if AUT.card_type == 'Enhanced' then card_type = localize{type = 'name_text', key = card.config.center.key, set = 'Enhanced'} end
        card_type = (debuffed and AUT.card_type ~= 'Enhanced') and localize('k_debuffed') or card_type

        local info_boxes = {}
        local badges = {}

        if AUT.badges.card_type or AUT.badges.force_rarity then
            badges[#badges + 1] = create_badge(((card.ability.name == 'Pluto' or card.ability.name == 'Ceres' or card.ability.name == 'Eris') and localize('k_dwarf_planet')) or (card.ability.name == 'Planet X' and localize('k_planet_q') or card_type),card_type_colour, nil, 1.2)
        end
        if AUT.badges then
            for k, v in ipairs(AUT.badges) do
            if v == 'negative_consumable' then v = 'negative' end
            badges[#badges + 1] = create_badge(localize(v, "labels"), get_badge_colour(v))
            end
        end

        if AUT.info then
            for k, v in ipairs(AUT.info) do
                info_boxes[#info_boxes+1] = {
                    n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
                            info_tip_from_rows(v, v.name),
                    }}
                }}
            end
        end

        local main_nodes = {}
        for _,nameline in ipairs(AUT.namelines)do
            main_nodes[#main_nodes+1] = {n=G.UIT.O, config={
                object = DynaText({string = {nameline},
                    colours = {G.C.UI.TEXT_LIGHT},
                    bump = true,
                    silent = true,
                    pop_in = 0,
                    pop_in_rate = 4,
                    maxw = 5,
                    shadow = true,
                    y_offset = -0.6,
                    spacing = math.max(0, 0.32*(17 - #nameline)),
                    scale =  0.55 - 0.004*#nameline
                })
            }}
        end
        main_nodes[#main_nodes+1] = desc_from_rows(AUT.main)
        main_nodes[#main_nodes+1] = badges[1] and {n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=badges} or nil
        return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
            {n=G.UIT.C, config={align = "cm", func = 'show_infotip',object = Moveable(),ref_table = next(info_boxes) and info_boxes or nil}, nodes={
                {n=G.UIT.R, config={padding = outer_padding, r = 0.12, colour = lighten(G.C.JOKER_GREY, 0.5), emboss = 0.07}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = adjust_alpha(card_type_background, 0.8)}, nodes=main_nodes}
                }}
            }},
        }}
    end
end