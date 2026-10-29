local _, ns = ...

-- Generated from data/daily_quotes.json. Review source/context before merging.
-- Source matching does not establish the truth of an accusation.
local additions = {
}

for _, quote in ipairs(additions) do
    ns.quotes[#ns.quotes + 1] = quote
end
