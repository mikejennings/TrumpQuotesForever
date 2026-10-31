local _, ns = ...

-- Generated from data/daily_quotes.json. Review source/context before merging.
-- Source matching does not establish the truth of an accusation.
local additions = {
    -- 1013: truth-117520691710779974; 2026-10-28
    "Can you imagine if a Republican stole money like Governor Tim Walz stole from Minnesota? They’d give you the electric chair!",
    -- 1014: truth-117495805131265987; 2026-10-24
    "I NEVER even thought to do such a stupid thing!",
    -- 1015: truth-117513970306136414; 2026-10-27
    "Ken Paxton is the Greatest Attorney General in Texas History.",
}

for _, quote in ipairs(additions) do
    ns.quotes[#ns.quotes + 1] = quote
end
