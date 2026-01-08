-- luhnox Universal Loader (PUBLIC)
local GAME_MAP = {
    [17577256698] = "https://luhnox.vercel.app/api/hutan", -- Hutan [Voice Chat]
}

local function safeHttpGet(url)
    local ok, res = pcall(function()
        if syn and syn.request then
            return syn.request({ Url = url, Method = "GET" }).Body
        elseif http and http.request then
            return http.request({ Url = url, Method = "GET" }).Body
        elseif request then
            return request({ Url = url, Method = "GET" }).Body
        elseif game.HttpGet then
            return game:HttpGet(url)
        end
    end)
    if ok and res then return res end
    error("Failed to fetch URL: " .. tostring(url))
end

local placeId = game.PlaceId
local target = GAME_MAP[placeId]

if not target then
    warn("[luhnox loader] Game not supported:", placeId)
    return
end

local src = safeHttpGet(target)
assert(type(src) == "string", "Invalid script response")
loadstring(src)()
print("[luhnox loader] Loaded for game:", placeId)