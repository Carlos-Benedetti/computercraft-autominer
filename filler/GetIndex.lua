local function GetIndex(item, tabel)
    local index = {}
    for k, v in pairs(tabel) do
        index[v] = k
    end
    return index[item]
end
return GetIndex