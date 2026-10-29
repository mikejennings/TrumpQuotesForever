local _, ns = ...

-- Generated from data/daily_quotes.json. Review source/context before merging.
-- Source matching does not establish the truth of an accusation.
local additions = {
    -- 1013: truth-117520691710779974; 2026-10-28
    "Can you imagine if a Republican stole money like Governor Tim Walz stole from Minnesota? They’d give you the electric chair!",
}

for _, quote in ipairs(additions) do
    ns.quotes[#ns.quotes + 1] = quote
end
