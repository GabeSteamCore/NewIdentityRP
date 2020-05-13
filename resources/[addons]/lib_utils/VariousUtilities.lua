function isInTable(table, elements)
    local found = false

    if #table > 0 then
        for i=1, #table, 1 do
            for j=1, #elements, 1 do
                if table[i] == elements[j] then
                    found = true
                end
            end
        end
    end

    return found
end