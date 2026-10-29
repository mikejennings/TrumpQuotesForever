local _, ns = ...

-- Further documented excerpts. Numbering continues from Quotes.lua.
-- See QUOTE_SOURCES.md for original dates, source links, and context.
-- Typography and punctuation are normalized; partial sentences stay excerpts.
local more = {
    -- 30-31: Jon Husted remarks, clip broadcast October 24, 2026.
    "I'm studying his body. I've never studied the body of a man before.",
    "His ass is -- it's like a pile of muscle.",

    -- 32-33: Husted remarks, clip broadcast October 26, 2026.
    "I looked at his ass, and I've never done that with a man before.",
    "Off the record, women yes, men no, OK?",

    -- 34: Arnold Palmer story, October 19, 2024; a mid-sentence excerpt.
    "when he took showers with the other pros, they came out there, they said, 'Oh my God, that's unbelievable.'",

    -- 35-36: Access Hollywood recording, September 2005.
    "Grab them by the pussy. You can do anything.",
    "And when you're a star, they let you do it.",

    -- 37: Sioux Center, Iowa, January 23, 2016.
    "I could stand in the middle of Fifth Avenue and shoot somebody, and I wouldn't lose any voters.",

    -- 38: Wildwood, New Jersey, May 11, 2024.
    "The late, great Hannibal Lecter is a wonderful man.",

    -- 39: October 7, 2019 tweet, excerpt.
    "if Turkey does anything that I, in my great and unmatched wisdom, consider to be off limits, I will totally destroy and obliterate the Economy of Turkey (I've done before!).",

    -- 40: August 21, 2019 remarks about the China trade conflict.
    "I am the chosen one.",

    -- 41: October 15, 2016 tweet.
    "Nobody has more respect for women than me!",

    -- 42-44: September 4, 2019 Hurricane Dorian briefing.
    "Well, it's -- again, I guess you would call it a British protectorate.",
    "China has paid for most of that, and I say paid for all of it.",
    "Texas had something similar, where the water was tremendous -- the water dump was tremendous.",

    -- 45-54: March 6, 2020 CDC visit.
    "Anybody that wants a test can get a test. That's what the bottom line is.",
    "And the tests are beautiful.",
    "and the tests are all perfect, like the letter was perfect.",
    "I didn't know people died from the flu -- 36,000 people died.",
    "I don't need to have the numbers double because of one ship.",
    "I like this stuff. I really get it. People are surprised that I understand it.",
    "Every one of these doctors said, 'How do you know so much about this?'",
    "Maybe I have a natural ability. Maybe I should have done that instead of running for President.",
    "He was a great super genius. Dr. John Trump.",
    "It doesn't bother me at all and it doesn't bother them at all.",

    -- 55-65: March 2, 2019 CPAC speech.
    "When the wind stops blowing, that's the end of your electric.",
    "Darling, is the wind blowing today? I'd like to watch television, darling.",
    "I have one of the great inventions in history. It's called TiVo.",
    "I think it's actually better than television, because television is practically useless without TiVo, right?",
    "And, all of a sudden, they're trying to take you out with bullshit. Okay?",
    "Then, in 1913, they ended tariffs, okay? They ended tariffs.",
    "Somebody got stupid and they ended tariffs.",
    "Of the 25 points, we've paid for 4 points, and China has paid for 21 points.",
    "New York City would have to rip down buildings and rebuild them again.",
    "The crazy female senator from the state of Ohio, the state of Hawaii.",
    "See, I don't have white hair.",

    -- 66-75: July 11, 2019 Presidential Social Media Summit.
    "I call Twitter a 'typewriter.'",
    "I'm actually a good speller.",
    "But everyone said, 'The fingers aren't as good as the brain.'",
    "I say I haven't had a good story in two and a half years.",
    "You know, I'm a very greedy person.",
    "Hey, I live better than all of them.",
    "They live like in the basement of their mom's home.",
    "The weather was just -- it was beautiful, in one way.",
    "They learned it was my real hair that day",
    "I ran, and they learned it's my hair, because I've been through every windstorm, sandstorm.",

    -- 76-84: December 6, 2019 small-business/red-tape roundtable.
    "right now, the cars are made out of papier-mâché.",
    "And ours are actually -- we allow steel content.",
    "Of course, being a vain person, that's very important to me.",
    "It's like a -- it gives you an orange look. I don't want an orange look.",
    "You turn on the faucet; you don't get any water.",
    "They take a shower and water comes dripping out.",
    "It's dripping out -- very quietly dripping out.",
    "you have many states where they have so much water that it comes down -- it's called rain",
    "You can't wash your hands, practically, there's so little water comes out of the faucet.",

    -- 85-94: November 5, 2020 election remarks; false/unsupported allegations.
    "If you count the legal votes, I easily win.",
    "If you count the illegal votes, they can try to steal the election from us.",
    "And the pollsters got it knowingly wrong.",
    "But instead, there was a big red wave.",
    "We kept the Senate, despite having twice as many seats to defend as Democrats.",
    "I won the largest share of non-white voters of any Republican in 60 years",
    "As everyone now recognizes, media polling was election interference, in the truest sense of that word, by powerful special interests.",
    "The election apparatus in Georgia is run by Democrats.",
    "Our campaign has been denied access to observe any counting in Detroit.",
    "Instead, they're trying, obviously, to commit fraud. There's no question about that.",

    -- 95: November 12, 2015 campaign speech.
    "I know more about ISIS than the generals do, believe me.",

    -- 96: May 13, 2016 interview about taxes.
    "I think nobody knows more about taxes than I do, maybe in the history of the world.",

    -- 97: February 6, 2016 Republican debate.
    "I actually think I have the best temperament.",

    -- 98: October 22, 2020 presidential debate.
    "I'm the least racist person in this room.",

    -- 99: June 2019 ABC interview; claim about presidential authority.
    "But more importantly, Article II allows me to do whatever I want.",

    -- 100: May 17, 2017 Coast Guard Academy commencement.
    "No politician in history -- and I say this with great surety -- has been treated worse or more unfairly.",

    -- 101: Catherine Lucey, aboard Air Force One, November 14, 2025.
    "Quiet. Quiet, piggy.",

    -- 102-104: Mary Bruce, Oval Office, November 18, 2025.
    "You're a terrible person and a terrible reporter.",
    "You ought to go back and learn how to be a reporter.",
    "No more questions from you.",

    -- 105-109: November 7, 2018 press conference; Acosta/Alcindor exchanges.
    "CNN should be ashamed of itself having you working for them.",
    "You are a rude, terrible person.",
    "You shouldn't be working for CNN.",
    "When you report fake news, which CNN does a lot, you are the enemy of the people.",
    "That's such a racist question.",

    -- 110-113: Peter Alexander, March 20, 2020 coronavirus briefing.
    "I say that you're a terrible reporter. That's what I say.",
    "I think it's a very nasty question",
    "You ought to be ashamed of yourself.",
    "I don't call it 'Comcast,' I call it 'Con-cast.'",

    -- 114-115: Abby Phillip, November 9, 2018.
    "What a stupid question that is. What a stupid question.",
    "But I watch you a lot. You ask a lot of stupid questions.",

    -- 116: Kaitlan Collins, CNN town hall, May 10, 2023.
    "You are a nasty person, I'll tell you that.",

    -- 117: Cecilia Vega, October 1, 2018.
    "I know you're not thinking. You never do.",

    -- 118-120: Paula Reid exchange, April 13, 2020 coronavirus briefing.
    "You're so disgraceful. It's so disgraceful the way you say that.",
    "Look. Look, you know you're a fake. You know that.",
    "Your whole network -- the way you cover it -- is fake.",
}

for _, quote in ipairs(more) do
    ns.quotes[#ns.quotes + 1] = quote
end
