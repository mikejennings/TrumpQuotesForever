local _, ns = ...
local Core = {}
ns.Core = Core

function Core.Range(low, high)
    low, high = tonumber(low), tonumber(high)
    if not low or not high or low ~= low or high ~= high
        or low < 1 or high > 1440 or low > high then
        return nil, "Use minutes from 1 to 1440, with minimum <= maximum."
    end
    return math.floor(low * 60), math.floor(high * 60)
end

function Core.Pick(quotes, previous, random)
    if #quotes == 0 then return nil end
    if #quotes == 1 then return 1 end
    if not previous or previous < 1 or previous > #quotes then
        return random(1, #quotes)
    end
    local index = random(1, #quotes - 1)
    if index >= previous then index = index + 1 end
    return index
end

function Core.Message(quote)
    if type(quote) ~= "string" or quote == "" or quote:find("[\r\n|]") then
        return nil
    end
    local message = '"' .. quote .. '" - Donald Trump'
    if #message > 255 then return nil end
    return message
end

-- GetChannelList returns triples: local ID, name, disabled.
-- Match the base name, never a remembered channel number (which can change).
function Core.Channel(name, ...)
    local channels = {...}
    for i = 1, #channels, 3 do
        if type(channels[i + 1]) == "string"
            and channels[i + 1]:lower() == name:lower()
            and not channels[i + 2] then
            return channels[i], channels[i + 1]
        end
    end
end
