local _, ns = ...

-- Entries 121-200. Sources, original post IDs, and targets are recorded in
-- INSULT_SOURCES.md and INSULT_SOURCES.json. Last 20 entries are nickname fragments.
-- Posted accusations and insults are quoted, not endorsed or factually validated.
local insults = {
    -- 121: Marco; 2016-02-28
    "Little Marco Rubio, the lightweight no show Senator from Florida is just another Washington politician.",
    -- 122: Marco; 2016-03-12
    "Little Marco, his State Chairman, & their minions are working overtime-trying to rig the vote.",
    -- 123: Ted Cruz; 2016-03-18
    "Lyin' Ted Cruz should not be allowed to win there - Mormons don't like LIARS!",
    -- 124: Jeb; 2016-02-08
    "Jeb Bush is desperate - strongly in favor of #CommonCore and very weak on illegal immigration.",
    -- 125: Jeb; 2016-02-12
    "Last time lightweight @JebBush tried to knock off @marcorubio he made a total fool of himself.",
    -- 126: Hillary; 2016-05-21
    "Crooked Hillary is spending tremendous amounts of Wall Street money on false ads against me.",
    -- 127: Biden; 2018-03-22
    "Crazy Joe Biden is trying to act like a tough guy.",
    -- 128: Bloomberg; 2016-07-29
    "\"Little\" Michael Bloomberg, who never had the guts to run for president, knows nothing about me.",
    -- 129: Bannon; 2018-01-06
    "He used Sloppy Steve Bannon, who cried when he got fired and begged for his job.",
    -- 130: Warren; 2016-05-11
    "Goofy Elizabeth Warren lied when she says I want to abolish the Federal Minimum Wage.",
    -- 131: Warren; 2016-05-11
    "Goofy Elizabeth Warren is now using the woman's card like her friend crooked Hillary.",
    -- 132: Corker; 2017-10-10
    "The Failing @nytimes set Liddle' Bob Corker up by recording his conversation.",
    -- 133: Corker; 2017-10-24
    "Corker is the incompetent head of the Foreign Relations Committee, & look how poorly the U.S. has done.",
    -- 134: Durbin; 2018-01-15
    "Senator Dicky Durbin totally misrepresented what was said at the DACA meeting.",
    -- 135: Flake; 2017-08-23
    "Not a fan of Jeff Flake, weak on crime & border!",
    -- 136: Comey; 2018-05-24
    "Comey was a terrible and corrupt leader who inflicted great pain on the FBI!",
    -- 137: Chuck Todd; 2015-01-27
    "I am convinced that sleepy eyes Chuck Todd was only a placeholder for someone else at Meet the Press.",
    -- 138: Schiff; 2018-02-18
    "Finally, Liddle' Adam Schiff, the leakin' monster of no control, is now blaming the Obama Administration for Russian meddling in the 2016 Election.",
    -- 139: Omarosa; 2018-08-13
    "Wacky Omarosa, who got fired 3 times on the Apprentice, now got fired for the last time.",
    -- 140: Don Lemon; 2018-08-04
    "Lebron James was just interviewed by the dumbest man on television, Don Lemon.",
    -- 141: Scarborough; 2017-07-01
    "Crazy Joe Scarborough and dumb as a rock Mika are not bad people, but their low rated show is dominated by their NBC bosses.",
    -- 142: Romney; 2016-06-11
    "Mitt Romney had his chance to beat a failed president but he choked like a dog.",
    -- 143: Tillerson; 2017-10-01
    "I told Rex Tillerson, our wonderful Secretary of State, that he is wasting his time trying to negotiate with Little Rocket Man...",
    -- 144: Bolton; 2020-12-20
    "What would Bolton, one of the dumbest people in Washington, know?",
    -- 145: Baldwin; 2018-03-02
    "Alec Baldwin, whose dying mediocre career was saved by his terrible impersonation of me on SNL, now says playing me was agony.",
    -- 146: Rosie; 2014-07-11
    "Rosie is crude, rude, obnoxious and dumb - other than that I like her very much!",
    -- 147: Maher; 2013-01-14
    "Dopey @billmaher is in for a lot of trouble--I hope he has $5 million (for charity).",
    -- 148: Huffington; 2015-07-18
    "The liberal clown  @ariannahuff told her minions at the money losing @HuffingtonPost to cover me as enterainment.",
    -- 149: Megyn; 2016-04-02
    "Is it possible for @megynkelly to cover anyone but Donald Trump on her terrible show.",
    -- 150: Schwarzenegger; 2017-03-04
    "Arnold Schwarzenegger isn't voluntarily leaving the Apprentice, he was fired by his bad (pathetic) ratings, not by me.",
    -- 151: Rove; 2015-07-16
    "Irrelevant clown @KarlRove sweats and shakes nervously on @FoxNews as he talks \"bull\" about me.",
    -- 152: Krauthammer; 2015-06-05
    "One of the worst and most boring political pundits on television is @krauthammer.",
    -- 153: George Will; 2016-06-26
    "George Will, one of the most overrated political pundits (who lost his way long ago), has left the Republican Party.He's made many bad calls",
    -- 154: Graydon; 2013-12-11
    "Why does Conde Nast allow dopey Graydon Carter to run bad food restaurants while running failing @VanityFair magazine?",
    -- 155: Kristol; 2016-05-29
    "If dummy Bill Kristol actually does get a spoiler to run as an Independent, say good bye to the Supreme Court!",
    -- 156: Graham; 2016-03-07
    "Lindsey Graham is all over T.V., much like failed 47% candidate Mitt Romney.",
    -- 157: Paul Ryan; 2016-10-11
    "Our very weak and ineffective leader, Paul Ryan, had a bad conference call where his members went wild at his disloyalty.",
    -- 158: Bill de Blasio; 2019-05-16
    "Bill de Blasio of NYC, considered the worst mayor in the U.S., will supposedly be making an announcement for president today.",
    -- 159: Heidi Cruz; 2016-03-23
    "Be careful, Lyin' Ted, or I will spill the beans on your wife!",
    -- 160: Jeb Bush / Ted Cruz; 2016-03-23
    "Low energy Jeb Bush just endorsed a man he truly hates, Lyin' Ted Cruz.",
    -- 161: Bernie Sanders; 2020-05-20
    "Crazy Bernie Sanders is not a fighter. He gives up too easy!",
    -- 162: Chuck Schumer; 2020-01-24
    "Cryin' Chuck never had what it takes, and never will!",
    -- 163: Nancy Pelosi; 2019-12-26
    "Crazy Nancy should clean up her filthy dirty District & help the homeless there.",
    -- 164: Nancy Pelosi; 2020-04-19
    "Nervous Nancy is an inherently \"dumb\" person.",
    -- 165: Michael Bloomberg; 2020-02-28
    "Mini Mike is getting slammed.",
    -- 166: Elizabeth Warren; 2016-07-26
    "Pocahontas bombed last night!",
    -- 167: Stormy Daniels; 2018-10-16
    "Great, now I can go after Horseface and her 3rd rate lawyer in the Great State of Texas.",
    -- 168: Adam Schiff; 2018-11-18
    "So funny to see little Adam Schitt (D-CA)",
    -- 169: Meryl Streep; 2017-01-09
    "Meryl Streep, one of the most over-rated actresses in Hollywood, doesn't know me but attacked last night at the Golden Globes.",
    -- 170: Robert De Niro; 2018-06-12
    "Robert De Niro, a very Low IQ individual, has received to many shots to the head by real boxers in movies.",
    -- 171: Bette Midler; 2014-03-03
    "Bette Midler sucked!",
    -- 172: Kathy Griffin; 2017-05-31
    "Kathy Griffin should be ashamed of herself.",
    -- 173: Don Lemon; 2016-08-10
    "Don Lemon is a lightweight - dumb as a rock",
    -- 174: Ted Cruz; 2016-04-01
    "Does anybody like Lyin' Ted?",
    -- 175: General insults; 2013-02-19
    "The many losers and haters never have the brains or stamina to become truly successful!",
    -- 176: Marco Rubio; 2016-02-27
    "Just watched lightweight Marco Rubio lying to a small crowd about my past record.",
    -- 177: Marco Rubio; 2016-03-07
    "I will be using Facebook and Twitter to expose dishonest lightweight Senator Marco Rubio.",
    -- 178: John McCain; 2015-07-18
    "He's a war hero because he was captured. I like people that weren't captured.",
    -- 179: Carly Fiorina; Published 2015-09-09
    "Look at that face. Would anyone vote for that?",
    -- 180: Chris Christie; 2024-01-12
    "Chris is desperately seeking a TV job, but sadly, no one wants him.",
    -- 181: Marco Rubio; 2016-02-28
    "Little Marco",
    -- 182: Ted Cruz; 2016-03-18
    "Lyin' Ted",
    -- 183: Jeb Bush; 2016-03-23
    "Low energy Jeb Bush",
    -- 184: Hillary Clinton; 2016-05-21
    "Crooked Hillary",
    -- 185: Joe Biden; 2018-03-22
    "Crazy Joe Biden",
    -- 186: Michael Bloomberg; 2016-07-29
    "\"Little\" Michael Bloomberg",
    -- 187: Steve Bannon; 2018-01-06
    "Sloppy Steve Bannon",
    -- 188: Elizabeth Warren; 2016-05-11
    "Goofy Elizabeth Warren",
    -- 189: Bob Corker; 2017-10-10
    "Liddle' Bob Corker",
    -- 190: Dick Durbin; 2018-01-15
    "Senator Dicky Durbin",
    -- 191: Chuck Todd; 2015-01-27
    "sleepy eyes Chuck Todd",
    -- 192: Omarosa Manigault Newman; 2018-08-13
    "Wacky Omarosa",
    -- 193: Nancy Pelosi; 2019-12-26
    "Crazy Nancy",
    -- 194: Nancy Pelosi; 2020-04-19
    "Nervous Nancy",
    -- 195: Michael Bloomberg; 2020-02-28
    "Mini Mike",
    -- 196: Elizabeth Warren; 2016-07-26
    "Pocahontas",
    -- 197: Kim Jong Un; 2017-10-01
    "Little Rocket Man",
    -- 198: James Comey; 2018-12-07
    "Lyin' James Comey",
    -- 199: Ron DeSantis; 2024-01-12
    "Ron DeSanctimonious",
    -- 200: Nikki Haley; 2024-01-12
    "Birdbrain",
}

for _, quote in ipairs(insults) do
    ns.quotes[#ns.quotes + 1] = quote
end
