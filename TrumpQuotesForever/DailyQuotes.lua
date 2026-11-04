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
    -- 1016: public-e3b0decc5b0bfaf77921; 2026-10-26
    "It's -- how crazy, how crazy is the world.",
    -- 1017: public-a203ce215dfd84c29aef; 2026-10-29
    "You've been following me for two weeks. I feel perfect. You are disgusting. Put yourself in shape. You look like hell,",
    -- 1018: public-4164f62044a72bb34a36; 2026-10-29
    "New York needs to defeat this radical left loser and elect Anthony Constantino, a phenomenal person, to the House of Representatives.",
    -- 1019: public-0bc6c2bd1c5bef814c35; 2026-10-28
    "It's a crazy thing.",
    -- 1020: public-7e90281ec6b4182e0a82; 2026-10-27
    "It's very close, and they can turn things -- now, I'll be vetoing like crazy, OK?",
    -- 1021: public-ca8db7f3a0efe724fa07; 2026-10-27
    "If some idiot comes in and terminates them, he will stop construction immediately and so will everybody else.",
    -- 1022: public-bb3bd4be98817c2bb890; 2026-10-26
    "Because the way he ran the country, only a stupid person would run the country like that.",
    -- 1023: public-8a2d8fcd2091182b7e81; 2026-10-25
    "And then you have ranked-choice voting, which is crooked as can be.",
    -- 1024: public-67911807c03d1404d004; 2026-10-28
    "We had a tremendous day in Texas.",
    -- 1025: public-3ad9265a8a2107f02e5d; 2026-10-27
    "And the crowds, I hear, are tremendous.",
    -- 1026: public-116d861d860f3d266e27; 2026-10-25
    "That's why I'm campaigning like crazy.",
    -- 1027: public-46830f98b6156be60630; 2026-10-25
    "It's so stupid.",
    -- 1028: public-153716b73aed7c8840aa; 2026-10-29
    "Crazy Bernie -- remember, I used to call him Crazy Bernie.",
    -- 1029: public-8b1597affabee1f1646f; 2026-10-30
    "He signed a lot of dumb deals, but this was a deal, the JCPOA, it was the Iran nuclear deal.",
    -- 1030: public-f42cbd5636adc7051c83; 2026-10-30
    "I said are you stupid?",
    -- 1031: public-006d2852676c9b0e6336; 2026-10-30
    "People, stupid people wanted me to put sanctions on Russia.",
    -- 1032: public-5afc5a572cf0b715e195; 2026-10-29
    "He's way out of shape.",
    -- 1033: public-28a39cbcbf1cfffb6f3a; 2026-10-29
    "Their policies are so dumb.",
    -- 1034: public-154b4a07b6802e7e4ed8; 2026-10-29
    "And that's what has made it probably the greatest economy in history.",
    -- 1035: public-5f66bea02cf0cf3cd98d; 2026-11-01
    "But nobody goes crazy about them, and they're going crazy over this.",
    -- 1036: public-b163b46b40040b69ab22; 2026-11-01
    "And they're dumb because their policy is so stupid.",
    -- 1037: public-d929b7d46b5f4fbd5012; 2026-11-02
    "The whole thing is crazy.",
    -- 1038: public-ffbf35cf5720839c255e; 2026-11-02
    "These are the crazy people that want to defund the police, get rid of prisons and all of the other things they want to do.",
    -- 1039: public-c50a7aef9987ffd8eed5; 2026-11-01
    "You think a good president, whether it's a, as I call them Dumocrats, because they are dumb as hell with their policy.",
    -- 1040: public-7793ecbde578712d0d81; 2026-10-31
    "Why would you ask such a stupid question?",
    -- 1041: public-4367b783bd8ab50cb91b; 2026-10-31
    "All he wants to do is taxi out of business and he's being bankrolled by his former boss, crazy Nancy Pelosi.",
    -- 1042: public-01722577d9ab5a071293; 2026-10-31
    "This is a radical left lunatic.",
    -- 1043: public-077fc98bfcb2df8b725c; 2026-10-31
    "She wants to have men in women's sports, which is crazy.",
    -- 1044: public-5f1be36c2d13d97b37cf; 2026-10-31
    "He's been a loser from day one.",
    -- 1045: public-61455d84a7cf00644891; 2026-11-01
    "We have a tremendous crowd.",
    -- 1046: public-35183f689f1893db2a04; 2026-11-02
    "We were laughed at as being just -- just a stupid, stupid, foolish country that was not going to make it even.",
    -- 1047: public-bf18afccddfbd89d72b9; 2026-11-03
    "That's gone; we moved out 5,000 hardcore criminals, most of whom who came in during the Biden -- you know, through that stupid open border.",
    -- 1048: public-f65e06d1da2ec56721ce; 2026-11-02
    "I call it Dumocrat because their policy is so bad, so dumb.",
    -- 1049: public-1c42798a3c53b891e5c7; 2026-11-02
    "Cove Road, I could talk about Cove Road, which was crazy.",
    -- 1050: public-8337910edebc45e06131; 2026-11-02
    "And now she's running to save you from a radical left lunatic named Tranny Annie Andrews.",
    -- 1051: public-d9f0e4a29bc8d637f569; 2026-11-02
    "For four years, we were laughed at like we were stupid people.",
    -- 1052: public-ead52c23852e2daac4bb; 2026-11-02
    "We put our people -- we put people there, and we have, you know, tremendous oil.",
}

for _, quote in ipairs(additions) do
    ns.quotes[#ns.quotes + 1] = quote
end
