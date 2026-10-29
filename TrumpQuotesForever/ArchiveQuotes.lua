local _, ns = ...

-- Short excerpts from original posts; provenance in ARCHIVE_SOURCES.md/.json.
-- Accusations and insults are quoted, not endorsed or factually validated.
local excerpts = {
    -- 201: 2011-10-20
    "Bob Beckel, a commentator for FOX is bad for the @FoxNews brand: @BobBeckel is close to incompetent.",
    -- 202: 2011-12-14
    "I feel sorry for Rosie 's new partner in love whose parents are devastated at the thought of their daughter being with @Rosie--a true loser.",
    -- 203: 2012-02-03
    "Sleepy eyed @chucktodd thinks Las Vegas is a state--see @todayshow this morning.",
    -- 204: 2012-03-19
    "Rosie O'Donnell has failed again.",
    -- 205: 2012-04-09
    "Vanity Fair Magazine, which used to be one of my favorites, is failing badly.",
    -- 206: 2012-05-10
    "Like @Rosie O'Donnell, a total loser!",
    -- 207: 2012-05-11
    "@Cher should stop with the bad plastic surgery and nasty statements about good people running for office.",
    -- 208: 2012-05-27
    "George Will may be the dumbest(and most overrated) political commentator of all time.",
    -- 209: 2012-05-29
    "Losers such as George Will and @Rosie use me to get publicity for themselves.",
    -- 210: 2012-07-19
    "Some really dumb blogger for failing @VanityFair, a magazine whose ads are down almost 18% this year, said I wear a hairpiece --- I DON'T!",
    -- 211: 2012-08-16
    "The Huffington Post is such a loser--it will die just as AOL is dying, What a stupid deal AOL made to buy it!",
    -- 212: 2012-09-10
    "George Will is a pathetic columnist.",
    -- 213: 2012-09-12
    "Obama is a disaster at foreign policy.",
    -- 214: 2012-09-12
    "Obama will go down as the worst President in history on many topics but especially foreign policy.",
    -- 215: 2012-09-13
    "Obama's foreign policy is a complete and total disaster--the worst President we have ever had.",
    -- 216: 2012-09-18
    "None of Romney's leaked comments change the fact that Obama is a complete disaster.",
    -- 217: 2012-09-19
    "Obama killed over 100k jobs by not approving Keystone XL pipeline and Canada is now selling the oil to China--very dumb!",
    -- 218: 2012-09-24
    "The attack on our Libyan consulate was the worst attack on the US since 9/11. Time for Obama to come clean.",
    -- 219: 2012-09-27
    "Someone must be fired at @AOL for that stupid deal they made buying Huffington Post.",
    -- 220: 2012-10-08
    "It's great that sleepy eyes @ chucktodd gets no traction.",
    -- 221: 2012-10-08
    "Sleepy eyes @chucktodd is an absolute joke of a reporter.",
    -- 222: 2012-10-09
    "Sleepy eyes @chucktodd -- whenever you mention me unfairly I will likewise mention you.",
    -- 223: 2012-10-09
    "George Will is a political moron.",
    -- 224: 2012-10-16
    "Because Obama was so pathetic in the first debate, tonight's audience will be humongous--people want to see if he is for real.",
    -- 225: 2012-10-17
    "Obama is looking rhetorical and weak. @MittRomney is looking strong and sharp.",
    -- 226: 2012-10-17
    "Such long rhetorical and boring answers from Obama.",
    -- 227: 2012-10-17
    "Stupid George Will gave @MittRomney no chance 3 months ago.",
    -- 228: 2012-10-19
    ".@VanityFair's terrible piece on Mitt's faith is a new low, even for them.",
    -- 229: 2012-10-22
    "Sleepy Eyes @ chucktodd owes @ jack_welch an apology.",
    -- 230: 2012-10-22
    "Gas prices are at crazy levels--fire Obama!",
    -- 231: 2012-10-22
    "Obama should stop talking about wind turbines--they are a disaster for a country or community & are very expensive & unreliable.",
    -- 232: 2012-10-23
    "The debate was pretty even but I thought Mitt should have been much more aggressive on Obama's failed foreign policy-- and I mean much more.",
    -- 233: 2012-10-26
    "What a dumb mistake AOL made buying the @huffingtonpost.",
    -- 234: 2012-10-28
    ".@BetteMidler talks about my hair but I'm not allowed to talk about her ugly face or body --- so I won't.",
    -- 235: 2012-10-31
    "How does a dummy like @billmaher get a television show--& his ratings stink.",
    -- 236: 2012-11-01
    "Obama is a terrible negotiator.",
    -- 237: 2012-11-02
    "Interestingly, the hurricane may now be a disaster for Obama's reelection because of his grandstanding.",
    -- 238: 2012-11-04
    "Like @ conedison, Obama is incompetent!",
    -- 239: 2012-11-05
    "Dummy @mcuban is at it again trying to use me to get publicity for himself!",
    -- 240: 2012-11-05
    ".@mcuban When Apprentice became the #1 show on tv you tried copying me with The Benefactor- a complete and total ratings disaster for @ABC.",
    -- 241: 2012-11-20
    "I was nice to loser @rosie and she attacked me--it just shows never let up with a bully.",
    -- 242: 2012-12-19
    "Worst ever issue of @VanityFair magazine--bad food Graydon Carter should be fired!",
    -- 243: 2012-12-19
    ".@VanityFair looks like a dying magazine! Really really boring, really really thin!",
    -- 244: 2012-12-21
    "Dopey @Rosie--I never went bankrupt--ABC already apologized to me for your stupid statement in the past--they didn't want a lawsuit.",
    -- 245: 2013-01-14
    "Is @billmaher the dumbest man on television?--I think so.",
    -- 246: 2013-01-17
    "Dumbass @BillMaher has still not given me the 5 million he committed to charity--- we just presented him with a demand notice.",
    -- 247: 2013-01-24
    ".@gretawire Greta--you're wrong, Kirsten Powers is a dummy--wasn't she Anthony Weiner's girlfriend?",
    -- 248: 2013-02-07
    "Karl Rove is a total loser.",
    -- 249: 2013-02-07
    "Karl Rove's strategy and commercials were the worst I have ever seen.",
    -- 250: 2013-02-08
    "Is @karlrove incompetent? 400 million dollars down the drain and not 1 victory!",
    -- 251: 2013-02-09
    "Dummy @BillMaher forgot to say that he made an absolute offer which I accepted.",
    -- 252: 2013-02-12
    "I don't know what will happen with the lawsuit against dummy @billmaher but have an obligation to charity to bring it.",
    -- 253: 2013-02-12
    "Check @billmaher's background & you will find he is not a smart guy--he just wants people to think he is--just call him dummy.",
    -- 254: 2013-02-13
    "When will people realize that @billmaher is not an intellectual, but actually a rather dumb guy--just look at his past.",
    -- 255: 2013-02-19
    "Idiot @billmaher always forgets to mention that I am suing him to collect the $5M for charity, that he expressly offered.",
    -- 256: 2013-02-26
    "The ruling @GOP consultant class of losers like @KarlRove have no respect for the Tea Party.",
    -- 257: 2013-02-26
    "Dopey @billmaher still owes me $5M for charity. I hope he pays up before @hbo fires him--which will happen!",
    -- 258: 2013-02-27
    "Ashley Judd has just thanked Karl Rove for all the attention he has given her--unreal!--how stupid can we get?",
    -- 259: 2013-02-27
    "Karl Rove's stupid ad made Ashley Judd hot--now everybody is talking about her.",
    -- 260: 2013-02-27
    "Karl Rove's ads are the worst in political history!",
    -- 261: 2013-02-28
    "One good aspect of the Obama depression is that it will separate the winners from the losers.",
    -- 262: 2013-03-02
    "Everyone should cancel HBO until they fire low life dummy Bill Maher! Get going now and feel good about yourself!",
    -- 263: 2013-03-02
    "Remember, Bill Maher praised the animals who took down the World Trade Center and was fired by ABC. DROP@HBO until dopey Bill is canned!",
    -- 264: 2013-03-03
    "Losers and haters,even you, as low and dumb as you are, can learn from watching Apprentice and checking out my tweets-you can still succeed!",
    -- 265: 2013-03-12
    "Our economy has had worst recovery under Obama since the Depression.",
    -- 266: 2013-03-14
    "Dummy @mcuban made up a story about a visit to Mar-a-Lago last night on Leno.",
    -- 267: 2013-03-14
    "I love watching dummy @mcuban promote on ok show named Shark Tank--but he is just a small part of that show.",
    -- 268: 2013-03-15
    "@jheil at @NYMag is such a pathetic reporter who doesn't want to know the truth. A total Obama flunky & hack.",
    -- 269: 2013-03-19
    ".@hardball_chris is a really dumb guy(and I know him well)--that's why he works swimmingly with our leaders in Washington.",
    -- 270: 2013-03-19
    ".@ErinBurnett's @OutFrontCNN ratings are so pathetic, she even loses to @hardball_chris at 7PM which is replay of 5PM",
    -- 271: 2013-03-19
    "Sorry folks, but Donald Trump is far richer and much better looking than dopey @mcuban!",
    -- 272: 2013-03-19
    "Why do shows have @ananavarro--Ntl Hispanic Chair for the losing McCain '08 & Huntsman '12. She's a loser who doesn't deliver votes.",
    -- 273: 2013-03-19
    "Does anyone remember the fight @mcuban had w/ the referee--he was weak & pathetic--a non-athlete trying to live life thru his players.",
    -- 274: 2013-03-20
    ".@hardball_chris' very small audience is shrinking rapidly because people finally understand that he is very very dumb!",
    -- 275: 2013-03-28
    "Rambling and stumbling @hardball_chris is as dumb as a rock!",
    -- 276: 2013-04-16
    "I've known @hardball_chris for a long time & sadly, he gets dumber each & every year--& started from a very low base.",
    -- 277: 2013-05-09
    "Sorry losers and haters, but my I.Q. is one of the highest -and you all know it!",
    -- 278: 2013-05-23
    "@markwonderful Sorry, Graydon Carter is a major loser, just ask his wife!",
    -- 279: 2013-06-07
    "Newsstand sales for @VanityFair, run by sleepy Graydon Carter, are down almost 20%.",
    -- 280: 2013-07-04
    "Sharks are last on my list - other than perhaps the losers and haters of the World!",
    -- 281: 2013-07-09
    "With Spitzer & Anthony Weiner running for office, New York is pervert central! Pathetic",
    -- 282: 2013-07-31
    "Now with the Danger-Weiner campaign dead, time to focus on crazy Eliot Spitzer.",
    -- 283: 2013-08-09
    "Sleepy eyes @chucktodd--one of the dumbest voices in politics-- is angry that I'm doing @ThisWeekABC.",
    -- 284: 2013-08-09
    "Doesn't dummy @chucktodd realize that when I considered running for president, I filed financial papers showing unbelievable numbers.",
    -- 285: 2013-08-13
    "The failing @HuffingtonPost and dopey @ariannahuff are writing so much false junk about me-they just can't get enough!",
    -- 286: 2013-08-13
    "@ariannahuff, I would love to represent your husband-you would end up with nothing! And please don't call Tim Armstrong stupid and weak?",
    -- 287: 2013-08-13
    "Congrats to @mboyle1 of @BreitbartNews for exposing Jason Linkins of @HuffingtonPost as a lightweight dope who gives false information.",
    -- 288: 2013-08-16
    "Obama' ststement on Egypt was terrible and dumb-now being used by military as a rallying cry-our foreign policy is worst in U.S. history.",
    -- 289: 2013-08-25
    "What did our very stupid & ineffective A.G. Eric Schneidean, during his trips to MY office, tell me about President Obama & Governor Cuomo?",
    -- 290: 2013-08-26
    "Lightweight hack Schneiderman meets with Obama on Thursday, then brings frivolous suit on Saturday.",
    -- 291: 2013-08-30
    "In that @TimeWarner has @HBO with really dumb racist Bryant Gumbel(and I mean dumb), and no CBS (which fired Bryant), I am switching bldgs.",
    -- 292: 2013-08-30
    "Pervert Weiner is dead in his race for mayor of NYC but WOW, Eliot Spitzer has dropped way down in recent poll for comptroller. SLEAZE!",
    -- 293: 2013-08-30
    "The ratings of The Cycle on MSNBC, a sad and pathetic show, are way down.",
    -- 294: 2013-08-31
    "Did anyone notice that Obama failed to get a coalition of other countries to go along with us.",
    -- 295: 2013-09-04
    "I hear this moron @billmaher said nasty things about me (hair etc--boring) on the terminated @jayleno show.",
    -- 296: 2013-09-05
    "The only reason President Obama wants to attack Syria is to save face over his very dumb RED LINE statement.",
    -- 297: 2013-09-10
    "Red line statement was a disaster for President Obama.",
    -- 298: 2013-09-11
    "Spitzer and Weiner lost, lightweight Eric Schneiderman will be next - he will be challenged in the PRIMARY.",
    -- 299: 2013-09-19
    "Lightweight Schneiderman's suit was filed on a Saturday (unheard of) against a school with a 98% approval rating right after Obama meeting.",
    -- 300: 2013-10-26
    "At this point the legacy of the Obama Administration will be, sadly, that of THE GANG THAT COULDN'T SHOOT STRAIGHT - what a pathetic mess!",
    -- 301: 2013-10-29
    "Maybe if Obama knew too much about the spying it would be worse than knowing nothing - but either way it is just another disaster!",
    -- 302: 2013-10-29
    "I hear @billmaher really bombed in Springfield--people were leaving show way early--stupid guy!",
    -- 303: 2013-10-31
    "It's Thursday. @billmaher is still a very dumb guy--just look at his past.",
    -- 304: 2013-11-27
    "Why doesn't President Obama simply apologize for telling a big fat lie, announce that ObamaCare was a mistake, and deal a really great plan!",
    -- 305: 2013-12-04
    "Sleazebag @BashirLive has just been forced to resign from @msnbc.",
    -- 306: 2013-12-09
    "Graydon Carter, whose reign over failing @VanityFair has been a disaster, has acted in two movies--both bombed & got bad reviews.",
    -- 307: 2013-12-10
    "If Graydon Carter's very dumb bosses would fire him for his terrible circulation numbers at failing Vanity Fair-his bad food restaurants die",
    -- 308: 2013-12-14
    "@VanityFair I love to see garbage properly disposed of which is why I like watching the dismal circulation numbers of Vanity Fair-IT'S DEAD",
    -- 309: 2013-12-15
    "President Obama and other world leaders don't know how close they were to being seriously injured (or worse) standing next to psycho in SA.",
    -- 310: 2014-01-16
    "Lightweight @AGSchneiderman is fighting with @NYGovCuomo -Cuomo wins that one easily.",
    -- 311: 2014-01-30
    "Failing comedian Bill Maher, who I got an accidental glimpse of the other night, is really a dumb guy, just look at his past!",
    -- 312: 2014-03-15
    "Frumpy and very dumb Gail Collins, an editorial writer at The New York Times, is so lucky to even have a job.",
    -- 313: 2014-03-20
    "President Obama was able to fool the Americans by getting elected, but not able to fool Vladimir Putin.",
    -- 314: 2014-03-21
    "I don't hate Obama at all, I just think he is an absolutely terrible president, maybe the worst in our history!",
    -- 315: 2014-03-26
    "By Obama mentioning Manhattan yesterday in his response, he has singlehandedly made it target #1. How totally stupid is this guy?",
    -- 316: 2014-03-31
    "Because of President Obama's failed leadership, we have put Vladimir Putin & Russia back on the world stage!",
    -- 317: 2014-04-29
    "Dopey @ariannahuff should force her reporters to be accurate--if she has that power.",
    -- 318: 2014-05-02
    "Graydon Carter is a loser with bad food restaurants!",
    -- 319: 2014-05-02
    "With @VanityFair circulation and advertising revenue doing so badly, rumor has it that dopey Graydon Carter is going to resign?",
    -- 320: 2014-06-04
    "Obama never consulted with Congress about a prisoner exchange. HE BROKE THE LAW AND SHOULD BE TRIED. OUR PRESIDENT IS A TOTAL DISASTER!",
    -- 321: 2014-06-06
    "Obama is, without question, the WORST EVER president. I predict he will now do something really bad and totally stupid to show manhood!",
    -- 322: 2014-06-10
    "Bush was terrible, Obama is worse!",
    -- 323: 2014-07-15
    "The @Washingtonpost reported about the closing hotels in Atlantic City but knowingly failed to report that I am not involved, left years ago",
    -- 324: 2014-09-13
    "For losers and haters, I NEVER went bankrupt.",
    -- 325: 2014-09-20
    "Why are we sending thousands of ill-trained soldiers into Ebola infested areas of Africa! Bring the plague back to U.S.? Obama is so stupid.",
    -- 326: 2014-09-22
    "Obama's rollout of his ISIS war plan is another unmitigated disaster.",
    -- 327: 2014-10-04
    "Can you believe that President Obama still hasn't stopped the flights and people pouring into the U.S. from West Africa. TERRIBLE PRESIDENT!",
    -- 328: 2014-10-05
    "What the hell is Obama doing in allowing all of these potentially very sick people to continue entering the U.S.! Is he stupid or arrogant?",
    -- 329: 2014-10-08
    "Obama is looking like an incompetent fool in the handling of the war against.ISIS!",
    -- 330: 2014-10-11
    "Michelle Obama made a terrible mistake in Iowa.",
    -- 331: 2014-10-12
    "I don't know if President Obama isn't stopping the flights from Ebola torn West Africa because he is stubborn, stupid, or just doesn't care!",
    -- 332: 2014-10-16
    "I watched Russell Brand @rustyrockets on the @jimmyfallon show the other night--what the hell do people see in Russell--a major loser!",
    -- 333: 2014-10-16
    ".@katyperry Katy, what the hell were you thinking when you married loser Russell Brand.",
    -- 334: 2014-10-17
    "I love seeing that Graydon Carter and @VanityFair are failing so badly.",
    -- 335: 2014-10-24
    "President Obama, you are a complete and total disaster, but you have a chance to do something great and important: STOP THE FLIGHTS!",
    -- 336: 2014-11-05
    "One year ago I started calling President Obama INCOMPETENT and people thought it was too tough.",
    -- 337: 2014-12-01
    "Rosie O'Donnell went after me again on The View in order to stir up her failing ratings.",
    -- 338: 2014-12-09
    "Sorry, @Rosie is a mentally sick woman, a bully, a dummy and, above all, a loser.",
    -- 339: 2014-12-24
    "Dummy Bill Maher did an advertisement for the failing New York Times where the picture of him is very sad-he looks pathetic, bloated & gone!",
    -- 340: 2015-01-25
    "Word is that @NBCNews is firing sleepy eyes Chuck Todd in that his ratings on Meet the Press are setting record lows.",
    -- 341: 2015-01-26
    "Why do people give @KarlRove contributions when they know he is a loser who has no idea how to win?",
    -- 342: 2015-01-27
    "If I hosted Meet the Press instead of Sleepy Eyes,a smash!",
    -- 343: 2015-02-07
    "Word is that Sleepy Eyes Chuck Todd, who has failed so badly with Meet the Press, will be taking over for now irrelevant Brian Williams!",
    -- 344: 2015-02-19
    "President Obama and our negotiators are failed checker players playing against Grand Master Chess champions.",
    -- 345: 2015-02-23
    "Obama has no idea what he is doing - incompetent!",
    -- 346: 2015-04-07
    "As dishonest as @RollingStone is I say @HuffingtonPost is worse.",
    -- 347: 2015-04-17
    ".@BretBaier Why do you have George Will on your show - he's exhausted, boring and not even a little relevant!",
    -- 348: 2015-05-12
    "One of the dumber and least respected of the political pundits is Chris Cillizza of the Washington Post @TheFix.",
    -- 349: 2015-05-31
    "While Jon Stewart is a joke, not very bright and totally overrated, some losers and haters will miss him and his dumb clown humor.",
    -- 350: 2015-06-05
    "Dummy political pundit @krauthammer constantly pressed the crazy war in Iraq.",
    -- 351: 2015-06-19
    "Goofy political pundit George Will spoke at Mar-a-Lago years ago. I didn't attend because he's boring & often wrong--a total dope!",
    -- 352: 2015-06-19
    "George Will was a big Iraq fool. $2 trillion, thousands of lives lost -- & we got nothing! Dummy.",
    -- 353: 2015-07-05
    "Rick Perry failed at the border.",
    -- 354: 2015-07-09
    "Do you believe that highly overrated political pundit @krauthammer said this is the best Republican field in 35 years.",
    -- 355: 2015-07-13
    "I hear that sleepy eyes @chucktodd will be fired like a dog from ratings starved Meet The Press?",
    -- 356: 2015-07-15
    "Why do people listen to clown @KarlRove on @FoxNews? Spent $430M & lost all races--a Bushy!",
    -- 357: 2015-07-16
    ".@FoxNews You shouldn't have @KarlRove on the air--he's a clown with zero credibility--a Bushy!",
    -- 358: 2015-07-16
    ".@KarlRove wasted $400 million + and didn't win one race--a total loser. @FoxNews",
    -- 359: 2015-07-18
    "It's driving @ariannahuff & the money losing @HuffingtonPost post crazy that I am #1 in their poll and they only write bad stories about me!",
    -- 360: 2015-07-23
    "What a waste of time being interviewed by @andersoncooper when he puts on really stupid talking heads likeTim O'Brien-dumb guy with no clue!",
    -- 361: 2015-07-23
    ".@BillKristol Bill, your small and slightly failing magazine will be a giant success when you finally back Trump.",
    -- 362: 2015-07-29
    ".CNN & @CNNPolitics Lawyer Elizabeth Beck did a terrible job against me, she lost (I even got legal fees).",
    -- 363: 2015-08-07
    "The hatred that clown @krauthammer has for me is unbelievable - causes him to lie when many others say Trump easily won debate.",
    -- 364: 2015-08-25
    ".@megynkelly must have had a terrible vacation, she is really off her game.",
    -- 365: 2015-09-02
    "Every Poll has me winning BIG.If you listen to dopey Karl Rove, a Trump hater, on @oreillyfactor, you would think I'm doing poorly.",
    -- 366: 2015-09-21
    "Carly Fiorina is terrible at business--the last thing our country needs!",
    -- 367: 2015-09-23
    "Do you ever notice that lightweight @megynkelly constantly goes after me but when I hit back it is totally sexist.",
    -- 368: 2015-09-24
    "Incompetent @RichLowry lost it tonight on @FoxNews.",
    -- 369: 2015-09-25
    "Dishonest @politico just called to say that none of the polls including Fox, NBC, CNN, Zogby, & Morning Consult matter.",
    -- 370: 2015-09-26
    "Lightweight Senator Marco Rubio is VERY weak on immigration, knows nothing about finance and would be incapable of making great trade deals!",
    -- 371: 2015-09-26
    "Marco Rubio is a member of the Gang Of Eight or, very weak on stopping illegal immigration.",
    -- 372: 2015-09-30
    "I watched lightweight Senator Marco Rubio, who is all talk and no action, defend his WEAK position on illegal immigration.",
    -- 373: 2015-10-05
    "Political strategist Stuart Stevens,who led Romney down the tubes in what should have been an easy victory,has terrible political instincts!",
    -- 374: 2015-10-07
    ".@stuartpstevens made some of the dumbest political decisions of all time in helping Romney to get destroyed by Obama.",
    -- 375: 2015-10-12
    "President Obama was terrible on @60Minutes tonight.",
    -- 376: 2015-10-13
    "The arrogant young woman who questioned me in such a nasty fashion at No Labels yesterday was a Jeb staffer!",
    -- 377: 2015-10-16
    "Megyn Kelly has two really dumb puppets, Chris Stirewalt & Marc Threaten (a Bushy) who do exactly what she says.",
    -- 378: 2015-10-17
    "No @JebBush, you're pathetic for saying nothing happened during your brother's term when the World Trade Center was attacked and came down.",
    -- 379: 2015-10-25
    "Remember that Carson, Bush and Rubio are VERY weak on illegal immigration.",
    -- 380: 2015-10-26
    "Dopey @BillKristol, who has lost all credibility with so many dumb statements and picks, said last week on @Morning_Joe that Biden was in.",
    -- 381: 2015-10-31
    "John Kasich doesn't have a clue - weak!",
    -- 382: 2015-11-01
    "John Kasich has really failed on the campaign trail.",
    -- 383: 2015-11-07
    "One of the dumbest political pundits on television is Chris Stirewalt of @FoxNews.",
    -- 384: 2015-11-10
    "Marco Rubio is a total lightweight who I wouldn't hire to run one of my smaller companies - a highly overrated politician!",
    -- 385: 2015-11-10
    "Marco Rubio is totally weak on illegal immigration & in favor of easy amnesty. A lightweight choker - bad for #USA!",
    -- 386: 2015-11-12
    ".@KarlRove is a biased dope who wrote falsely about me re China and TPP. This moron wasted $430 million on political campaigns and lost 100%",
    -- 387: 2015-11-12
    ".@WSJ and dopey Karl Rove made a mistake and purposely mischaracterized my statement on the terrible TPP deal.",
    -- 388: 2015-11-12
    "Total fool @KarlRove is part of the Republican Establishment problem.",
    -- 389: 2015-11-12
    "Wow, pres. candidate Ben Carson, who is very weak on illegal Immigration, just said he likes amnesty and a pathway to citizenship.",
    -- 390: 2015-11-13
    ".@CarlyFiorina had to inject herself into my factual statements concerning Ben Carson in order to breathe life into her failing campaign!",
    -- 391: 2015-11-15
    "Hillary and Sanders are not doing well, but what is the failed former Mayor of Baltimore doing on that stage? O'Malley is a clown.",
    -- 392: 2015-11-15
    "I have watched sloppy Graydon Carter fail and close Spy Magazine and now am watching him fail at @VanityFair Magazine.",
    -- 393: 2015-11-20
    "Governor Kasich, whose failed campaign & debating skills have brought him way down in the polls, is going to spend $2.5 million against me.",
    -- 394: 2015-11-20
    "John Kasich should focus his special interest money on building up his failed image, not negative ads on me.",
    -- 395: 2015-11-22
    "Hillary Clinton is weak on illegal immigration, among many other things.",
    -- 396: 2015-11-23
    "Going to Ohio, home of one of the worst presidential candidates in history--Kasich.",
    -- 397: 2015-11-24
    "Republicans must stop relying on losers like @KarlRove if they want to start winning presidential elections.",
    -- 398: 2015-11-26
    "The failing @nytimes should be focused on good reporting and the papers financial survival and not with constant hits on Donald Trump!",
    -- 399: 2015-11-26
    "The dopes at the @nytimes bought the Boston Globe for $1.3 billion and sold it for $1.00. Their great old headquarters-gave it away! So dumb",
    -- 400: 2015-11-26
    "The failing @nytimes should focus on fair and balanced reporting rather than constant hit jobs on me.",
    -- 401: 2015-11-30
    "You made kooky Cokie Roberts and @BillKristol look even dumber than they are.",
    -- 402: 2015-12-04
    ".@JRubinBlogger one of the dumber bloggers @washingtonpost only writes purposely inaccurate pieces on me.",
    -- 403: 2015-12-07
    "Gee, @meetthepress with @chucktodd was getting terrible ratings then, with me, he set records - I saved his job, but Chuck still not nice!",
    -- 404: 2015-12-08
    "Change your false story failing @nytimes.",
    -- 405: 2015-12-10
    ".@secupp, who can't believe that her candidate has bombed so badly, is one of the dumber pundits on T.V. Hard to watch, zero talent! @CNN",
    -- 406: 2015-12-10
    "Why does @CNN bore their audience with people like @secupp, a totally biased loser who doesn't have a clue.",
    -- 407: 2015-12-10
    "Dummy @KarlRove continues to make and write false statements.",
    -- 408: 2015-12-10
    "Establishment flunky @KarlRove is going crazy with the just released CBS poll that has me way ahead.",
    -- 409: 2015-12-13
    "Something must be done with dopey @KarlRove - he is pushing Republicans down the same old path of defeat.",
    -- 410: 2015-12-13
    "People that have read it tell me that @KarlRove book is terrible (and boring).",
    -- 411: 2015-12-15
    "@oreillyfactor, horrible defense of me against highly overrated @krauthammer. I will bring more people into the party & easily beat Hillary!",
    -- 412: 2015-12-15
    ".@megynkelly, the most overrated anchor at @FoxNews, worked hard to explain away the new Monmouth poll 41 to 14 or 27 pt lead.",
    -- 413: 2015-12-15
    "Between Iraq war monger @krauthammer, dummy @KarlRove, deadpan @GeorgezWill, highly overrated @megynkelly, among others, @FoxNews not fair!",
    -- 414: 2015-12-15
    "Too bad dopey @megynkelly lies!",
    -- 415: 2015-12-16
    "Hillary Clinton is weak and ineffective - no strength, no stamina.",
    -- 416: 2015-12-18
    "I have an idea for @JebBush whose campaign is a disaster.",
    -- 417: 2015-12-18
    "Weak & ineffective @JebBush is doing ads where he shows his statement in the debate but not my response.",
    -- 418: 2015-12-18
    ".@JebBush has embarrassed himself & his family with his incompetent campaign for President.",
    -- 419: 2015-12-19
    "See, Sanders backed Hillary on E-mails at the debate, hurting himself, and then she threw him under the bus (but failed).",
    -- 420: 2015-12-20
    ".@JebBush was terrible on Face The Nation today.",
    -- 421: 2015-12-21
    "I demand an apology from Hillary Clinton for the disgusting story she made up about me for purposes of the debate.",
    -- 422: 2015-12-22
    "Weak and low energy @JebBush, whose campaign is a disaster, is now doing ads against me where he tries to look like a tough guy.",
    -- 423: 2015-12-22
    ".@JebBush's opening and closing in the debate were said by all to be terrible--fumbled around, incoherent.",
    -- 424: 2015-12-23
    "The Hillary Clinton staged event yesterday was pathetic.",
    -- 425: 2015-12-23
    "The @washingtonpost, which is the lobbyist (power) for not imposing taxes on #Amazon, today did a nasty cartoon attacking @tedcruz kids.",
    -- 426: 2015-12-24
    "Third rate reporters Amy Chozick and Maggie Haberman of the failing @nytimes are totally in the Hillary circle of bias.",
    -- 427: 2015-12-24
    ".@meetthepress and @chucktodd very dishonest in not showing the new @CNN Poll where I am at 39%, 21points higher than Cruz.",
    -- 428: 2015-12-25
    ".@HallieJackson Why didn't you report Hillary lying about the ISIS video.",
    -- 429: 2015-12-25
    "Remember when failed candidate @JebBush said that illegals came across the border as AN ACT OF LOVE?",
    -- 430: 2015-12-28
    "If Hillary thinks she can unleash her husband, with his terrible record of women abuse, while playing the women's card on me, she's wrong!",
    -- 431: 2015-12-28
    "Strange, but I see wacko Bernie Sanders allies coming over to me because I'm lowering taxes, while he will double & triple them, a disaster!",
    -- 432: 2015-12-29
    "Remember that Bill Clinton was brought in to help Hillary against Obama in 2008. He was terrible, failed badly, and was called a racist!",
    -- 433: 2015-12-29
    "I hope @TGowdySC does better for Rubio than he did at the #Benghazi hearings, which were a total disaster for Republicans & America!",
    -- 434: 2016-01-03
    "The worst thing Hillary could do is have her husband campaign for her.",
    -- 435: 2016-01-14
    "Why does @CNN & @andersoncooper waste airtime by putting failed campaign strategist, Stuart Stevens - who lost BIG for Romney - on the show?",
    -- 436: 2016-01-15
    "Lindsey Graham embarrassed himself with his failed run for President and now further embarrasses himself with endorsement of Bush.",
    -- 437: 2016-01-16
    ".@oreillyfactor please explain to the very dumb and failing @glennbeck that I supported John McCain big league in 2008, not Obama!",
    -- 438: 2016-01-19
    "Wow, new polls just out have Trump up and Cruz down - he is a nervous wreck!",
    -- 439: 2016-01-19
    "Dope Frank Bruni said I called many people, including Karl Rove, losers-true! I never called my friend @HowardStern a loser- he's a winner!",
    -- 440: 2016-01-19
    "Really disgusting that the failing New York Times allows dishonest writers to totally fabricate stories.",
    -- 441: 2016-01-21
    "Low energy candidate @JebBush has wasted $80 million on his failed presidential campaign.",
    -- 442: 2016-01-25
    "Ted Cruz is a nervous wreck.",
    -- 443: 2016-01-26
    "Pathetic attempt by @foxnews to try and build up ratings for the #GOPDebate.",
    -- 444: 2016-01-29
    "The new e-mail release is a disaster for Hillary Clinton.",
    -- 445: 2016-01-31
    "Wow, just saw an ad - Cruz is lying on so many levels.",
    -- 446: 2016-02-03
    "Many people voted for Cruz over Carson because of this Cruz fraud.",
    -- 447: 2016-02-03
    "Based on the fraud committed by Senator Ted Cruz during the Iowa Caucus, either a new election should take place or Cruz results nullified.",
    -- 448: 2016-02-03
    "The State of Iowa should disqualify Ted Cruz from the most recent election on the basis that he cheated- a total fraud!",
    -- 449: 2016-02-06
    "Wow, Jeb Bush, whose campaign is a total disaster, had to bring in mommy to take a slap at me.",
    -- 450: 2016-02-08
    "Everybody is laughing at Jeb Bush-spent $100 million and is at bottom of pack. A pathetic figure!",
    -- 451: 2016-02-12
    "Weak JEB getting thrown out by management during speech.",
    -- 452: 2016-02-12
    "How can Ted Cruz be an Evangelical Christian when he lies so much and is so dishonest?",
    -- 453: 2016-02-12
    "Lightweight @JebBush is spending a fortune of special interest against me in SC. False advertising- desperate and sad!",
    -- 454: 2016-02-12
    "Millions of $'s of false ads, paid for by lobbyists-special interests of cheater @SenTedCruz and sleepy @JebBush, are now running in S.C.",
    -- 455: 2016-02-14
    "Lightweight @JebBush said tonight he didn't know his family used private eminent domain in Texas- Lie!",
    -- 456: 2016-02-14
    "Dopey Charles Krauthammer still nasty.",
    -- 457: 2016-02-17
    ".@FoxNews is so biased it is disgusting.",
    -- 458: 2016-02-17
    "Just out Nevada poll shows Jeb Bush at 1%, he should take his dumb mouthpiece, @LindseyGrahamSC, and just go home.",
    -- 459: 2016-02-18
    "I agree with Marco Rubio that Ted Cruz is a liar!",
    -- 460: 2016-02-20
    "Lying #Ted Cruz just (on election day) came out with a sneak and sleazy Robocall.",
    -- 461: 2016-02-20
    "Remember that Marco Rubio is very weak on illegal immigration.",
    -- 462: 2016-02-22
    "The reason that Ted Cruz lost the Evangelicals in S.C. is because he is a world class LIAR, and Evangelicals do not like liars!",
    -- 463: 2016-02-22
    "Ted Cruz has now apologized to Marco Rubio and Ben Carson for fraud and dirty tricks.",
    -- 464: 2016-02-23
    "Just watched the very incompetent Mitt Romney Campaign Strategist, Stuart Stevens.",
    -- 465: 2016-02-24
    "In all of television- the only one who said anything bad about last nights landslide victory-- was dopey @KarlRove.",
    -- 466: 2016-02-25
    "Ted Cruz is lying again.",
    -- 467: 2016-02-25
    "Mitt Romney, who was one of the dumbest and worst candidates in the history of Republican politics, is now pushing me on tax returns.",
    -- 468: 2016-02-26
    "Failed presidential candidate @MittRomney was made to look like a fool by Senator Harry Reid & didn't release his tax returns until 9/21/12.",
    -- 469: 2016-02-26
    "Cruz is a nasty guy, not one Senate endorsement and, despite talk, gets nothing done.",
    -- 470: 2016-02-26
    "Lying Ted Cruz and lightweight choker Marco Rubio teamed up last night in a last ditch effort to stop our great movement.",
    -- 471: 2016-02-26
    "Lightweight choker Marco Rubio looks like a little boy on stage.",
    -- 472: 2016-02-27
    "I am self-funding my campaign and am therefore not controlled by the lobbyists and special interests like lightweight Rubio or Ted Cruz!",
    -- 473: 2016-02-27
    "I only wish my wonderful father, Fred, gave me $200 million to start my business like lightweight Rubio says.",
    -- 474: 2016-02-28
    "While I hear the Koch brothers are in big financial trouble (oil), word is they have chosen little Marco Rubio, the lightweight from Florida",
    -- 475: 2016-02-28
    "Lightweight Senator Marco Rubio is polling very poorly in Florida.",
    -- 476: 2016-03-02
    "Why would anyone in Florida vote for lightweight Senator Marco Rubio.",
    -- 477: 2016-03-02
    "Interesting how my numbers have gone so far up since lightweight Marco Rubio has turned nasty.",
    -- 478: 2016-03-03
    "Looks like two-time failed candidate Mitt Romney is going to be telling Republicans how to get elected.",
    -- 479: 2016-03-05
    ".@MittRomney was a disaster candidate who had no guts and choked! Romney is a total joke, and everyone knows it!",
    -- 480: 2016-03-05
    "Romney's failed advisors, like campaign mgr Stuart Stevens are all over TV telling people how to win.",
    -- 481: 2016-03-05
    "I am watching two clown announcers on @FoxNews as they try to build up failed presidential candidate #LittleMarco.",
    -- 482: 2016-03-06
    ".@FoxNews is devastated that lightweight Senator Marco Rubio got trounced tonight and is the big loser.",
    -- 483: 2016-03-06
    "David Brooks, of the New York Times, is closing in on being the dumbest of them all.",
    -- 484: 2016-03-07
    "Failed presidential candidate Lindsey Graham should respect me.",
    -- 485: 2016-03-07
    "We cannot let the failing REPUBLICAN ESTABLISHMENT, who could not stop Obama (twice), ruin the MOVEMENT with millions of $'s in false ads!",
    -- 486: 2016-03-07
    "Don't believe the millions of dollars of phony television ads by lightweight Rubio and the R establishment.",
    -- 487: 2016-03-10
    "Wow, you are all correct about @FoxNews - totally biased and disgusting reporting.",
    -- 488: 2016-03-12
    "Absentee Governor Kasich voted for NAFTA and NAFTA devastated Ohio - a disaster from which it never recovered.",
    -- 489: 2016-03-12
    "Governor Kasich in favor of TPP fraud!",
    -- 490: 2016-03-12
    "We are asking law enforcement to check for dishonest early voting in Florida- on behalf of little Marco Rubio.",
    -- 491: 2016-03-13
    "Bernie Sanders is lying when he says his disruptors aren't told to go to my events.",
    -- 492: 2016-03-13
    "The failing @nytimes is truly one of the worst newspapers.",
    -- 493: 2016-03-15
    "Kasich voted for NAFTA, a disaster for Ohio, and now wants the even worse TPP approved.",
    -- 494: 2016-03-15
    "Rubio is weak on illegal immigration, with the worst voting record in the U.S. Senate in many years.",
    -- 495: 2016-03-15
    "Kasich is weak on illegal immigration.",
    -- 496: 2016-03-16
    "Can't watch Crazy Megyn anymore.",
    -- 497: 2016-03-17
    "Stuart Stevens, the failed campaign manager of Mitt Romney's historic loss, is now telling the Republican Party what to do with Trump.",
    -- 498: 2016-03-17
    "Crazy @megynkelly supposedly had lyin' Ted Cruz on her show last night.",
    -- 499: 2016-03-17
    "Highly overrated & crazy @megynkelly is always complaining about Trump and yet she devotes her shows to me.",
    -- 500: 2016-03-18
    "Lyin' Ted Cruz lost all five races on Tuesday-and he was just given the jinx - a Lindsey Graham endorsement.",
    -- 501: 2016-03-18
    "Failed Presidential Candidate Mitt Romney was campaigning with John Kasich & Marco Rubio, and now he is endorsing Ted Cruz.",
    -- 502: 2016-03-19
    "Reading @nytdavidbrooks of the NY Times is a total waste of time, he is a clown with no awareness of the world around him- dummy!",
    -- 503: 2016-03-19
    "Crazy @megynkelly says I don't (won't) go on her show and she still gets good ratings.",
    -- 504: 2016-03-19
    "If crazy @megynkelly didn't cover me so much on her terrible show, her ratings would totally tank.",
    -- 505: 2016-03-22
    "Obama, and all others, have been so weak, and so politically correct, that terror groups are forming and getting stronger!",
    -- 506: 2016-03-23
    "Incompetent Hillary, despite the horrible attack in Brussels today, wants borders to be weak and open-and let the Muslims flow in.",
    -- 507: 2016-03-23
    "Lyin' Ted Cruz steals foreign policy from me, and lines from Michael Douglas-- just another dishonest politician.",
    -- 508: 2016-03-23
    "I'm the only one that was right from the beginning, & now Lyin' Ted & others are copying me.",
    -- 509: 2016-03-23
    "I think having Jeb's endorsement hurts Lyin' Ted.",
    -- 510: 2016-03-24
    ".@LindseyGrahamSC and Lyin' Ted Cruz are two politicians who are very much alike - ALL TALK AND NO ACTION!",
    -- 511: 2016-03-24
    "I didn't start the fight with Lyin'Ted Cruz over the GQ cover pic of Melania, he did.",
    -- 512: 2016-03-26
    "Lyin' Ted Cruz is now trying to convince prople that his problems with The National Enq.were caused by me.",
    -- 513: 2016-03-27
    "Wow, sleepy eyes @chucktodd is at it again.",
    -- 514: 2016-03-27
    "See Lyin' Ted, even the @DailyBeast (no fan of mine) says this story came from Rubio, not Trump!",
    -- 515: 2016-03-29
    "Lyin'Ted Cruz is weak & losing big, so now he wants to debate again.",
    -- 516: 2016-03-29
    "Lyin' Ted, I have already beaten you in all debates, and am way ahead of you in votes and delegates.",
    -- 517: 2016-04-17
    "Lyin' Ted Cruz will never be able to beat Hillary.",
    -- 518: 2016-04-17
    "Lyin' Ted Cruz can't get votes (I am millions ahead of him) so he has to get his delegates from the Republican bosses.",
    -- 519: 2016-04-18
    "Lyin' Ted Cruz can't win with the voters so he has to sell himself to the bosses-I am millions of VOTES ahead!",
    -- 520: 2016-04-18
    "Lyin' Ted Cruz even voted against Superstorm Sandy aid and September 11th help.",
    -- 521: 2016-04-21
    "Cruz said Kasich should leave because he couldn't get to 1237. Now he can't get to 1237. Drop out LYIN' Ted.",
    -- 522: 2016-04-24
    "As soon as John Kasich is hit with negative ads, he will drop like a rock in the polls against Crooked Hillary Clinton.",
    -- 523: 2016-04-25
    "Wow, just announced that Lyin' Ted and Kasich are going to collude in order to keep me from getting the Republican nomination.",
    -- 524: 2016-04-25
    "Lyin' Ted and Kasich are mathematically dead and totally desperate.",
    -- 525: 2016-04-29
    "Wow, the ridiculous deal made between Lyin'Ted Cruz and 1 for 42 John Kasich has just blown up.",
    -- 526: 2016-04-29
    "Crooked Hillary Clinton, perhaps the most dishonest person to have ever run for the presidency, is also one of the all time great enablers!",
    -- 527: 2016-05-01
    ".@KarlRove is a failed Jeb Bushy.",
    -- 528: 2016-05-03
    "Wow, Lyin' Ted Cruz really went wacko today.",
    -- 529: 2016-05-04
    "I would rather run against Crooked Hillary Clinton than Bernie Sanders and that will happen because the books are cooked against Bernie!",
    -- 530: 2016-05-06
    "Unlike crooked Hillary Clinton, who wants to destroy all miners, I want wages to go up in America.",
    -- 531: 2016-05-06
    "Crooked Hillary has ZERO leadership ability.",
    -- 532: 2016-05-06
    "I hope corrupt Hillary Clinton chooses goofy Elizabeth Warren as her running mate. I will defeat them both.",
    -- 533: 2016-05-06
    "Let's properly check goofy Elizabeth Warren's records to see if she is Native American. I say she's a fraud!",
    -- 534: 2016-05-07
    "Crooked Hillary Clinton wants completely open borders.",
    -- 535: 2016-05-07
    "Goofy Elizabeth Warren is weak and ineffective.",
    -- 536: 2016-05-07
    "Crooked Hillary has no clue!",
    -- 537: 2016-05-07
    "Remember when the two failed presidential candidates, Lindsey Graham and Jeb Bush, signed a binding PLEDGE?",
    -- 538: 2016-05-08
    "Crooked Hillary just can't close the deal with Bernie.",
    -- 539: 2016-05-10
    "Why does the media, with a strong push from Crooked Hillary, keep pushing the false narrative that I want to raise taxes.",
    -- 540: 2016-05-10
    "The Clintons spend millions on negative ads on me & I can't tell the truth about her husband? Don't feel sorry for crooked Hillary!",
    -- 541: 2016-05-11
    "Get ready for November - Crooked Hillary, who is looking very bad against Crazy Bernie, will lose!",
    -- 542: 2016-05-11
    "I don't want to hit Crazy Bernie Sanders too hard yet because I love watching what he is doing to Crooked Hillary.",
    -- 543: 2016-05-11
    "Isn't it funny when a failed Senator like goofy Elizabeth Warren can spend a whole day tweeting about Trump & gets nothing done in Senate?",
    -- 544: 2016-05-15
    "The failing @nytimes wrote yet another hit piece on me.",
    -- 545: 2016-05-15
    "Why doesn't the failing @nytimes write the real story on the Clintons and women? The media is TOTALLY dishonest!",
    -- 546: 2016-05-15
    "Wow, I have had so many calls from high ranking people laughing at the stupidity of the failing @nytimes piece.",
    -- 547: 2016-05-16
    "The @nytimes is so dishonest.",
    -- 548: 2016-05-16
    "Wow, Rowanne Brewer, the most prominently depicted woman in the failing @nytimes story yesterday, was on @foxandfriends saying Times lied",
    -- 549: 2016-05-16
    "With the coming forward today of the woman central to the failing @nytimes hit piece on me, we have exposed the article as a fraud!",
    -- 550: 2016-05-16
    "The failing @nytimes is greatly embarrassed by the totally dishonest story they did on my relationship with women.",
    -- 551: 2016-05-16
    "No wonder the @nytimes is failing--who can believe what they write after the false, malicious & libelous story they did on me.",
    -- 552: 2016-05-17
    "Wow, 30,000 e-mails were deleted by Crooked Hillary Clinton.",
    -- 553: 2016-05-17
    "Crooked Hillary Clinton put out an ad where I am misquoted on women.",
    -- 554: 2016-05-17
    "How can Crooked Hillary put her husband in charge of the economy when he was responsible for NAFTA, the worst economic deal in U.S. history?",
    -- 555: 2016-05-17
    "Do you think Crooked Hillary will finally close the deal?",
    -- 556: 2016-05-17
    "Wall Street paid for ad is a fraud, just like Crooked Hillary!",
    -- 557: 2016-05-18
    "Paul Begala, the dopey @CNN flunky and head of the Pro-Hillary Clinton Super PAC, has knowingly committed fraud in his first ad against me.",
    -- 558: 2016-05-18
    "Why did Clinton supporter @AlisonForKY declare Crooked Hillary winner in KY when AP hasn't even called the race?",
    -- 559: 2016-05-19
    "How quality a woman is Rowanne Brewer Lane to have exposed the @nytimes as a disgusting fraud?",
    -- 560: 2016-05-20
    "Crooked Hillary has zero imagination and even less stamina.",
    -- 561: 2016-05-20
    "Crooked Hillary Clinton looks presidential? I don't think so! Four more years of Obama and our country will never come back. ISIS LAUGHS!",
    -- 562: 2016-05-20
    "Crooked Hillary can't even close the deal with Bernie - and the Dems have it rigged in favor of Hillary.",
    -- 563: 2016-05-20
    "Failing @NYTimes will always take a good story about me and make it bad.",
    -- 564: 2016-05-21
    "Crooked Hillary Clinton wants to essentially abolish the 2nd Amendment.",
    -- 565: 2016-05-21
    "Crooked Hillary wants to get rid of all guns and yet she is surrounded by bodyguards who are fully armed.",
    -- 566: 2016-05-21
    "Crooked Hillary Clintons foreign interventions unleashed ISIS in Syria, Iraq and Libya.",
    -- 567: 2016-05-22
    "Why do the networks continue to put dopey @BillKristol on panels when he has called every single shot about me wrong for 2 yrs?",
    -- 568: 2016-05-22
    "How can Crooked Hillary say she cares about women when she is silent on radical Islam, which horribly oppresses women?",
    -- 569: 2016-05-22
    "Crooked Hillary wants a radical 500% increase in Syrian refugees.",
    -- 570: 2016-05-22
    "Bernie Sanders is continuing his quest because he believes that Crooked Hillary Clinton will be forced out of the race - e-mail scandal!",
    -- 571: 2016-05-24
    "Crooked Hillary Clinton overregulates, overtaxes and doesn't care about jobs.",
    -- 572: 2016-05-25
    "After raising, w/ no obligation, almost $6M for Vets, I couldn't believe protesters formed @ Trump Tower. JUST OUT- SENT BY CROOKED HILLARY!",
    -- 573: 2016-05-25
    "@elizabethforma Goofy Elizabeth Warren, sometimes referred to as Pocahontas because she faked the fact she is native American, is a lowlife!",
    -- 574: 2016-05-25
    "@elizabethforma Goofy Elizabeth Warren, sometimes known as Pocahontas, bought foreclosed housing and made a quick killing.",
    -- 575: 2016-05-26
    "The Inspector General's report on Crooked Hillary Clinton is a disaster.",
    -- 576: 2016-05-26
    "I find it offensive that Goofy Elizabeth Warren, sometimes referred to as Pocahontas, pretended to be Native American to get in Harvard.",
    -- 577: 2016-05-28
    "I am always on the front page of the failing @nytimes, but when I won the GOP nomination, I'm in the back of the paper.",
    -- 578: 2016-05-29
    "Bill Kristol has been wrong for 2yrs-an embarrassed loser, but if the GOP can't control their own, then they are not a party.",
    -- 579: 2016-05-30
    "I would have had millions of votes more in the primaries (than Crooked Hillary) if I only had one opponent, instead of sixteen.",
    -- 580: 2016-05-31
    "Crooked Hillary should be admonished for not having a press conference in 179 days.",
    -- 581: 2016-06-01
    "Crooked Hillary Clinton is a fraud who has put the public and country at risk by her illegal and very stupid use of e-mails.",
    -- 582: 2016-06-02
    "Crooked Hillary Clinton has zero natural talent - she should not be president.",
    -- 583: 2016-06-02
    "Bernie Sanders was right when he said that Crooked Hillary Clinton was not qualified to be president because she suffers from BAD judgement!",
    -- 584: 2016-06-02
    "With all of the Crooked Hillary Clinton's foreign policy experience, she has made so many mistakes - and I mean real monsters!",
    -- 585: 2016-06-02
    "Crooked Hillary Clinton, who I would love to call Lyin' Hillary, is getting ready to totally misrepresent my foreign policy positions.",
    -- 586: 2016-06-02
    "Crooked Hillary no longer has credibility - too much failure in office.",
    -- 587: 2016-06-02
    "Bad performance by Crooked Hillary Clinton! Reading poorly from the telepromter! She doesn't even look presidential!",
    -- 588: 2016-06-03
    "In Crooked Hillary's telepromter speech yesterday, she made up things that I said or believe but have no basis in fact.",
    -- 589: 2016-06-06
    "Crooked Hillary Clinton has not held a news conference in more than 7 months.",
    -- 590: 2016-06-06
    "Crooked Hillary is being badly criticized (for a Wall Street paid for ad) by PolitiFact for a false ad on me on women.",
    -- 591: 2016-06-09
    "I would have had many millions of votes more than Crooked Hillary Clinton except for the fact that I had 16 opponents, she had one!",
    -- 592: 2016-06-09
    "Bernie Sanders must really dislike Crooked Hillary after the way she played him.",
    -- 593: 2016-06-09
    "Crooked Hillary Clinton will be a disaster on jobs, the economy, trade, healthcare, the military, guns and just about all else.",
    -- 594: 2016-06-10
    "Goofy Elizabeth Warren, one of the least productive U.S. Senators, has a nasty mouth.",
    -- 595: 2016-06-11
    "Goofy Elizabeth Warren, sometimes referred to as Pocahontas, pretended to be a Native American in order to advance her career.",
    -- 596: 2016-06-17
    "People very unhappy with Crooked Hillary and Obama on JOBS and SAFETY!",
    -- 597: 2016-06-19
    "Yesterday's failing @NYTimes fraudulently shows an empty room prior to my speech, when in fact, it was packed!",
    -- 598: 2016-06-21
    "Crooked Hillary Clinton is totally unfit to be our president-really bad judgement and a temperament, according to new book, which is a mess!",
    -- 599: 2016-06-22
    "Crooked Hillary refuses to say that she will be raising taxes beyond belief! She will be a disaster for jobs and the economy!",
    -- 600: 2016-06-24
    "Crooked Hillary called it totally wrong on BREXIT - she went with Obama - and now she is saying we need her to lead.",
    -- 601: 2016-06-26
    "Crooked Hillary Clinton, who called BREXIT 100% wrong (along with Obama), is now spending Wall Street money on an ad on my correct call.",
    -- 602: 2016-06-26
    "People in our country want borders, and without them the old line pols like Crooked Hillary will not win.",
    -- 603: 2016-06-26
    "Crooked Hillary Clinton got Brexit wrong.",
    -- 604: 2016-06-27
    "Crooked Hillary is wheeling out one of the least productive senators in the U.S. Senate, goofy Elizabeth Warren, who lied on heritage.",
    -- 605: 2016-06-30
    "Why would college graduates want Crooked Hillary as their President? She will destroy them!",
    -- 606: 2016-06-30
    "The very dishonest @NBCNews refuses to accept the fact that I have forgiven my $50 million loan to my campaign.",
    -- 607: 2016-07-03
    "Only a fool would believe that the meeting between Bill Clinton and the U.S.A.G. was not arranged or that Crooked Hillary did not know.",
    -- 608: 2016-07-04
    "Crooked Hillary will NEVER be able to handle the complexities and danger of ISIS - it will just go on forever.",
    -- 609: 2016-07-06
    "Crooked Hillary Clinton is unfit to serve as President of the U.S. Her temperament is weak and her opponents are strong.",
    -- 610: 2016-07-06
    "Crooked Hillary has once again been proven to be a person who is dishonest, incompetent and of very bad judgement.",
    -- 611: 2016-07-06
    "Crooked Hillary Clinton lied to the FBI and to the people of our country.",
    -- 612: 2016-07-08
    "After today, Crooked Hillary can officially be called Lyin' Crooked Hillary.",
    -- 613: 2016-07-10
    "Look what is happening to our country under the WEAK leadership of Obama and people like Crooked Hillary Clinton.",
    -- 614: 2016-07-12
    "Bernie Sanders, who has lost most of his leverage, has totally sold out to Crooked Hillary Clinton.",
    -- 615: 2016-07-12
    "Bernie Sanders endorsing Crooked Hillary Clinton is like Occupy Wall Street endorsing Goldman Sachs.",
    -- 616: 2016-07-12
    "Bernie sanders has abandoned his supporters by endorsing pro-war pro-TPP pro-Wall Street Crooked Hillary Clinton.",
    -- 617: 2016-07-13
    "Voters understand that Crooked Hillary's negative ads are not true- just like her email lies and her other fraudulent activity.",
    -- 618: 2016-07-14
    "Crooked Hillary will sell us out, just like her husband did with NAFTA.",
    -- 619: 2016-07-15
    "Four more years of weakness with a Crooked Hillary Administration is not acceptable.",
    -- 620: 2016-07-16
    "Crooked Hillary, who embarrassed herself and the country with her e-mail lies, has been a DISASTER on foreign policy.",
    -- 621: 2016-07-16
    "Crooked Hillary Clinton is bought and paid for by Wall Street, lobbyists and special interests.",
    -- 622: 2016-07-17
    "Goofy Elizabeth Warren, who may be the least productive Senator in the U.S. Senate, must prove she is not a fraud.",
    -- 623: 2016-07-17
    "I hope that Crooked Hillary picks Goofy Elizabeth Warren, sometimes referred to as Pocahontas, as her V.P. Then we can litigate her fraud!",
    -- 624: 2016-07-17
    "If Goofy Elizabeth Warren, a very weak Senator, didn't lie about her heritage (being Native American) she would be nothing today.",
    -- 625: 2016-07-23
    "Pocahontas wanted V.P. slot so badly but wasn't chosen because she has done nothing in the Senate.",
    -- 626: 2016-07-23
    "Crooked Hillary Clinton has destroyed jobs and manufacturing in Pennsylvania.",
    -- 627: 2016-07-24
    "The Crooked Hillary V.P. choice is VERY disrespectful to Bernie Sanders and all of his supporters.",
    -- 628: 2016-07-24
    "Bernie Sanders started off strong, but with the selection of Kaine for V.P., is ending really weak.",
    -- 629: 2016-07-24
    "Crooked Hillary Clinton was not at all loyal to the person in her rigged system that pushed her over the top, DWS.",
    -- 630: 2016-07-24
    "Even though Bernie Sanders has lost his energy and his strength, I don't believe that his supporters will let Crooked Hillary off the hook!",
    -- 631: 2016-07-24
    "The highly neurotic Debbie Wasserman Schultz is angry that, after stealing and cheating her way to a Crooked Hillary victory, she's out!",
    -- 632: 2016-07-25
    "How much BAD JUDGEMENT was on display by the people in DNC in writing those really dumb e-mails, using even religion, against Bernie!",
    -- 633: 2016-07-25
    "The State of Florida is so embarrassed by the antics of Crooked Hillary Clinton and Debbie Wasserman Schultz that they will vote for CHANGE!",
    -- 634: 2016-07-25
    "People don't want another four years of Obama, and Crooked Hillary would be even worse.",
    -- 635: 2016-07-26
    "Elizabeth Warren, often referred to as Pocahontas, just misrepresented me and spoke glowingly about Crooked Hillary, who she always hated!",
    -- 636: 2016-07-26
    "Bernie Sanders totally sold out to Crooked Hillary Clinton.",
    -- 637: 2016-07-27
    "Just like I have warned from the beginning, Crooked Hillary Clinton will betray you on the TPP.",
    -- 638: 2016-07-27
    "Crooked Hillary Clinton wants to flood our country with Syrian immigrants that we know little or nothing about.",
    -- 639: 2016-07-29
    "Crooked Hillary Clinton mentioned me 22 times in her very long and very boring speech.",
    -- 640: 2016-07-29
    "The dishonest media didn't mention that Bernie Sanders was very angry looking during Crooked's speech.",
    -- 641: 2016-07-30
    "We are suffering through the worst long-term unemployment in the last 70 years. I want change - Crooked Hillary Clinton does not.",
    -- 642: 2016-07-30
    "Crooked Hillary Clinton is soft on crime, supports open borders, and wants massive tax hikes. A formula for disaster!",
    -- 643: 2016-07-30
    "Word is that Crooked Hillary has very small and unenthusiastic crowds in Pennsylvania.",
    -- 644: 2016-07-31
    "The dishonest media is fawning over the Democratic Convention. I wonder why, then, my speech had millions of more viewers than Crooked H?",
    -- 645: 2016-08-01
    "The failing @nytimes is a joke.",
    -- 646: 2016-08-01
    "CNN anchors are completely out of touch with everyday people worried about rising crime, failing schools and vanishing jobs.",
    -- 647: 2016-08-01
    "Crooked Hillary Clinton is 100% owned by her donors. #ImWithYou #MAGA",
    -- 648: 2016-08-02
    "The Washington Post calls out #CrookedHillary for what she REALLY is. A PATHOLOGICAL LIAR! Watch that nose grow!",
    -- 649: 2016-08-02
    "President Obama will go down as perhaps the worst president in the history of the United States!",
    -- 650: 2016-08-03
    "Our incompetent Secretary of State, Hillary Clinton, was the one who started talks to give 400 million dollars, in cash, to Iran.",
    -- 651: 2016-08-05
    "Obama's disastrous judgment gave us ISIS, rise of Iran, and the worst economic numbers since the Great Depression!",
    -- 652: 2016-08-07
    "I am not just running against Crooked Hillary Clinton, I am running against the very dishonest and totally biased media - but I will win!",
    -- 653: 2016-08-11
    "Constant phony reporting from failing @CNN turns everyone off.",
    -- 654: 2016-08-12
    "A massive tax increase will be necessary to fund Crooked Hillary Clinton's agenda.",
    -- 655: 2016-08-13
    "The failing @nytimes has become a newspaper of fiction.",
    -- 656: 2016-08-13
    "We now have confirmation as to one reason Crooked H wanted to be sure that nobody saw her e-mails - PAY-FOR-PLAY.",
    -- 657: 2016-08-14
    "The failing @nytimes talks about anonymous sources and meetings that never happened.",
    -- 658: 2016-08-14
    "The failing @nytimes, which never spoke to me, keeps saying that I am saying to advisers that I will change.",
    -- 659: 2016-08-14
    "Crooked Hillary Clinton is being protected by the media.",
    -- 660: 2016-08-14
    "I am not only fighting Crooked Hillary, I am fighting the dishonest and corrupt media and her government protection process.",
    -- 661: 2016-08-19
    "The reporting at the failing @nytimes gets worse and worse by the day.",
    -- 662: 2016-08-22
    "Crooked Hillary is flooding the airwaves with false and misleading ads - all paid for by her bosses on Wall Street.",
    -- 663: 2016-08-22
    "Tried watching low-rated @Morning_Joe this morning, unwatchable! @morningmika is off the wall, a neurotic and not very bright mess!",
    -- 664: 2016-08-25
    "Hillary Clinton's short speech is pandering to the worst instincts in our society.",
    -- 665: 2016-08-26
    "Crooked Hillary will NEVER be able to solve the problems of poverty, education and safety within the African-American & Hispanic communities",
    -- 666: 2016-08-26
    "Wonderful @pastormarkburns was attacked viciously and unfairly on @MSNBC by crazy @morningmika on low ratings @Morning_Joe.",
    -- 667: 2016-09-02
    "Just heard that crazy and very dumb @morningmika had a mental breakdown while talking about me on the low ratings @Morning_Joe.",
    -- 668: 2016-09-03
    ".@CNN is so disgusting in their bias, but they are having a hard time promoting Crooked Hillary in light of the new e-mail scandals.",
    -- 669: 2016-09-04
    "Wow, the failing @nytimes has not reported properly on Crooked's FBI release.",
    -- 670: 2016-09-04
    "The Republican Party needs strong and committed leaders, not weak people such as @JeffFlake, if it is going to stop illegal immigration.",
    -- 671: 2016-09-04
    "The Great State of Arizona, where I just had a massive rally (amazing people), has a very weak and ineffective Senator, Jeff Flake.",
    -- 672: 2016-09-09
    "Jeff Zucker failed @NBC and he is now failing @CNN.",
    -- 673: 2016-09-09
    "Governor of South Carolina who endorsed me, beat failed @CNN announcer Bakari Sellers, so badly.",
    -- 674: 2016-09-11
    "The seriously failing @nytimes, despite so much winning and poll numbers that will soon put me in first place, only writes dishonest hits!",
    -- 675: 2016-09-17
    "Crooked Hillary wants to take your 2nd Amendment rights away.",
    -- 676: 2016-09-17
    "Crazy Maureen Dowd, the wacky columnist for the failing @nytimes, pretends she knows me well--wrong!",
    -- 677: 2016-09-17
    "The failing @nytimes has gone nuts that Crooked Hillary is doing so badly.",
    -- 678: 2016-09-17
    "My lawyers want to sue the failing @nytimes so badly for irresponsible intent.",
    -- 679: 2016-09-20
    "Crooked Hillary has been fighting ISIS, or whatever she has been doing, for years.",
    -- 680: 2016-09-24
    "Crooked Hillary's bad judgement forced her to announce that she would go to Charlotte on Saturday to grandstand.",
    -- 681: 2016-09-24
    "If dopey Mark Cuban of failed Benefactor fame wants to sit in the front row, perhaps I will put Gennifer Flowers right alongside of him!",
    -- 682: 2016-09-27
    "Hillary's been failing for 30 years in not getting the job done - it will never change.",
    -- 683: 2016-09-30
    "Using Alicia M in the debate as a paragon of virtue just shows that Crooked Hillary suffers from BAD JUDGEMENT!",
    -- 684: 2016-09-30
    "Did Crooked Hillary help disgusting (check out sex tape and past) Alicia M become a U.S. citizen so she could use her in the debate?",
    -- 685: 2016-10-01
    "Crooked H is nasty to Sanders supporters behind closed doors.",
    -- 686: 2016-10-02
    "I know our complex tax laws better than anyone who has ever run for president and am the only one who can fix them. #failing@nytimes",
    -- 687: 2016-10-02
    "Bernie should pull his endorsement of Crooked Hillary after she decieved him and then attacked him and his supporters.",
    -- 688: 2016-10-10
    "CNN is the worst - fortunately they have bad ratings because everyone knows they are biased.",
    -- 689: 2016-10-11
    "Disloyal R's are far more difficult than Crooked Hillary.",
    -- 690: 2016-10-11
    "Wow, @CNN Town Hall questions were given to Crooked Hillary Clinton in advance of big debates against Bernie Sanders.",
    -- 691: 2016-10-13
    "The phony story in the failing @nytimes is a TOTAL FABRICATION.",
    -- 692: 2016-10-15
    "The failing @nytimes reporters don't even call us anymore, they just write whatever they want to write, making up sources along the way!",
    -- 693: 2016-10-16
    "A country that Crooked Hillary says has funded ISIS also gave Wild Bill $1 million for his birthday? SO CORRUPT!",
    -- 694: 2016-10-16
    "The election is absolutely being rigged by the dishonest and distorted media pushing Crooked Hillary - but also at many polling places - SAD",
    -- 695: 2016-10-16
    "The Democrats have a corrupt political machine pushing crooked Hillary Clinton.",
    -- 696: 2016-10-16
    "Paul Ryan, a man who doesn't know how to win (including failed run four years ago), must start focusing on the budget, military, vets etc.",
    -- 697: 2016-10-17
    "Crooked Hillary Clinton even got the questions to a debate, and nobody says a word.",
    -- 698: 2016-10-17
    "Crooked Hillary colluded w/FBI and DOJ and media is covering up to protect her.",
    -- 699: 2016-10-19
    "Hillary is the most corrupt person to ever run for the presidency of the United States.",
    -- 700: 2016-10-20
    "Crooked Hillary has never created a job in her life.",
    -- 701: 2016-10-20
    "Why didn't Hillary Clinton announce that she was inappropriately given the debate questions - she secretly used them! Crooked Hillary.",
    -- 702: 2016-10-20
    "Want access to Crooked Hillary? Don't forget - it's going to cost you! #DrainTheSwamp #PayToPlay",
    -- 703: 2016-10-20
    "Crooked Hillary promised 200k jobs in NY and FAILED. We'll create 25M jobs when I'm president, and I will DELIVER!",
    -- 704: 2016-10-24
    "Wow, just came out on secret tape that Crooked Hillary wants to take in as many Syrians as possible.",
    -- 705: 2016-11-01
    "Look at the way Crooked Hillary is handling the e-mail case and the total mess she is in.",
    -- 706: 2016-11-01
    "Crooked Hillary should not be allowed to run for president.",
    -- 707: 2016-11-02
    "Crooked Hillary Clinton deleted 33,000 e-mails AFTER they were subpoenaed by the United States Congress.",
    -- 708: 2016-11-02
    "After decades of lies and scandal, Crooked Hillary's corruption is closing in. #DrainTheSwamp!",
    -- 709: 2016-11-16
    "The failing @nytimes story is so totally wrong on transition.",
    -- 710: 2016-11-16
    "I have recieved and taken calls from many foreign leaders despite what the failing @nytimes said.",
    -- 711: 2016-11-22
    "The failing @nytimes just announced that complaints about them are at a 15 year high.",
    -- 712: 2016-11-29
    "I thought that @CNN would get better after they failed so badly in their support of Hillary Clinton however, since election, they are worse!",
    -- 713: 2016-12-10
    "Reports by @CNN that I will be working on The Apprentice during my Presidency, even part time, are ridiculous & untrue - FAKE NEWS!",
    -- 714: 2016-12-30
    "Russians are playing @CNN and @NBCNews for such fools - funny to watch, they don't have a clue!",
    -- 715: 2017-01-05
    "The Democrats, lead by head clown Chuck Schumer, know how bad ObamaCare is and what a mess they are in.",
    -- 716: 2017-01-12
    ".@CNN is in a total meltdown with their FAKE NEWS because their ratings are tanking since election and their credibility will soon be gone!",
    -- 717: 2017-01-15
    ".@NBCNews is bad but Saturday Night Live is the worst of NBC.",
    -- 718: 2017-01-26
    "Ungrateful TRAITOR Chelsea Manning, who should never have been released from prison, is now calling President Obama a weak leader.",
    -- 719: 2017-01-28
    "The failing @nytimes has been wrong about me from the very beginning.",
    -- 720: 2017-01-29
    "Somebody with aptitude and conviction should buy the FAKE NEWS and failing @nytimes and either run it correctly or let it fold with dignity!",
    -- 721: 2017-01-29
    "The joint statement of former presidential candidates John McCain & Lindsey Graham is wrong - they are sadly weak on immigration.",
    -- 722: 2017-02-04
    "After being forced to apologize for its bad and inaccurate coverage of me after winning the election, the FAKE NEWS @nytimes is still lost!",
    -- 723: 2017-02-06
    "Any negative polls are fake news, just like the CNN, ABC, NBC polls in the election.",
    -- 724: 2017-02-06
    "The failing @nytimes writes total fiction concerning me.",
    -- 725: 2017-02-07
    "The failing @nytimes was forced to apologize to its subscribers for the poor reporting it did on my election win.",
    -- 726: 2017-02-15
    "The fake news media is going crazy with their conspiracy theories and blind hatred. @MSNBC & @CNN are unwatchable. @foxandfriends is great!",
    -- 727: 2017-02-16
    "Failing @nytimes (and others) must apologize!",
    -- 728: 2017-02-17
    "The FAKE NEWS media (failing @nytimes, @NBCNews, @ABC, @CBS, @CNN) is not my enemy, it is the enemy of the American People!",
    -- 729: 2017-02-25
    "The failing @nytimes has become a joke.",
    -- 730: 2017-02-26
    "For first time the failing @nytimes will take an ad (a bad one) to help save its failing reputation.",
    -- 731: 2017-03-03
    "I hearby demand a second investigation, after Schumer, of Pelosi for her close ties to Russia, and lying about it.",
    -- 732: 2017-03-15
    "Can you imagine what the outcry would be if @SnoopDogg, failing career and all, had aimed and fired the gun at President Obama?",
    -- 733: 2017-03-20
    "Just heard Fake News CNN is doing polls again despite the fact that their election polls were a WAY OFF disaster.",
    -- 734: 2017-03-23
    "Just watched the totally biased and fake news reports of the so-called Russia story on NBC and ABC.",
    -- 735: 2017-03-28
    "The failing @NYTimes would do much better if they were honest!",
    -- 736: 2017-03-28
    "Why doesn't Fake News talk about Podesta ties to Russia as covered by @FoxNews or money from Russia to Clinton - sale of Uranium?",
    -- 737: 2017-03-29
    "Remember when the failing @nytimes apologized to its subscribers, right after the election, because their coverage was so wrong.",
    -- 738: 2017-03-30
    "The failing @nytimes has disgraced the media world.",
    -- 739: 2017-04-01
    "When will Sleepy Eyes Chuck Todd and @NBCNews start talking about the Obama SURVEILLANCE SCANDAL and stop with the Fake Trump/Russia story?",
    -- 740: 2017-04-20
    "Failing @nytimes, which has been calling me wrong for two years, just got caught in a big lie concerning New England Patriots visit to W.H.",
    -- 741: 2017-05-10
    "The Roger Stone report on @CNN is false - Fake News.",
    -- 742: 2017-06-01
    "Crooked Hillary Clinton now blames everybody but herself, refuses to say she was a terrible candidate.",
    -- 743: 2017-06-15
    "Crooked H destroyed phones w/ hammer, 'bleached' emails, & had husband meet w/AG days before she was cleared- & they talk about obstruction?",
    -- 744: 2017-06-25
    "Hillary Clinton colluded with the Democratic Party in order to beat Crazy Bernie Sanders.",
    -- 745: 2017-06-27
    "Fake News CNN is looking at big management changes now that they got caught falsely pushing their phony Russian stories.",
    -- 746: 2017-06-28
    "The failing @nytimes writes false story after false story about me.",
    -- 747: 2017-07-01
    "I am extremely pleased to see that @CNN has finally been exposed as #FakeNews and garbage journalism.",
    -- 748: 2017-07-22
    "My son Donald openly gave his e-mails to the media & authorities whereas Crooked Hillary Clinton deleted (& acid washed) her 33,000 e-mails!",
    -- 749: 2017-07-23
    "It's hard to read the Failing New York Times or the Amazon Washington Post because every story/opinion, even if should be positive, is bad!",
    -- 750: 2017-07-25
    "Is Fake News Washington Post being used as a lobbyist weapon against Congress to keep Politicians from looking into Amazon no-tax monopoly?",
    -- 751: 2017-07-25
    "Attorney General Jeff Sessions has taken a VERY weak position on Hillary Clinton crimes (where are E-mails & DNC server) & Intel leakers!",
    -- 752: 2017-08-07
    "The failing @nytimes, which has made every wrong prediction about me including my big election win (apologized), is totally inept!",
    -- 753: 2017-08-24
    "James Clapper, who famously got caught lying to Congress, is now an authority on Donald Trump.",
    -- 754: 2017-09-14
    "Crooked Hillary Clinton blames everybody (and every thing) but herself for her election loss.",
    -- 755: 2017-09-20
    "After allowing North Korea to research and build Nukes while Secretary of State (Bill C also), Crooked Hillary now criticizes.",
    -- 756: 2017-10-01
    "Clinton failed, Bush failed, and Obama failed.",
    -- 757: 2017-10-04
    "NBC news is #FakeNews and more dishonest than even CNN.",
    -- 758: 2017-10-11
    "With all of the Fake News coming out of NBC and the Networks, at what point is it appropriate to challenge their License?",
    -- 759: 2017-10-13
    "People are just now starting to find out how dishonest and disgusting (FakeNews) @NBCNews is.",
    -- 760: 2017-10-19
    "Uranium deal to Russia, with Clinton help and Obama Administration knowledge, is the biggest story that Fake Media doesn't want to follow!",
    -- 761: 2017-10-24
    "Isn't it sad that lightweight Senator Bob Corker, who couldn't get re-elected in the Great State of Tennessee, will now fight Tax Cuts plus!",
    -- 762: 2017-10-24
    "People like liddle' Bob Corker have set the U.S. way back.",
    -- 763: 2017-11-03
    "James Comey's leadership was a disaster!",
    -- 764: 2017-11-03
    "Crooked Hillary bought the DNC & then stole the Democratic Primary from Crazy Bernie!",
    -- 765: 2017-11-03
    "Pocahontas just stated that the Democrats, lead by the legendary Crooked Hillary Clinton, rigged the Primaries!",
    -- 766: 2017-11-03
    "Bernie Sanders supporters have every right to be apoplectic of the complete theft of the Dem primary by Crooked Hillary!",
    -- 767: 2017-11-03
    "I always felt I would be running and winning against Bernie Sanders, not Crooked H, without cheating, I was right.",
    -- 768: 2017-11-18
    "Crooked Hillary Clinton is the worst (and biggest) loser of all time.",
    -- 769: 2017-11-29
    "Great, and we should boycott Fake News CNN. Dealing with them is a total waste of time!",
    -- 770: 2017-11-30
    "The Failing @nytimes, the pipe organ for the Democrat Party, has become a virtual lobbyist for them with regard to our massive Tax Cut Bill.",
    -- 771: 2017-12-01
    "The Schumer/Pelosi Democrats are so weak on Crime that they will pay a big price in the 2018 and 2020 Elections.",
    -- 772: 2017-12-01
    "The media has been speculating that I fired Rex Tillerson or that he would be leaving soon - FAKE NEWS!",
    -- 773: 2017-12-03
    "After years of Comey, with the phony and dishonest Clinton investigation (and more), running the FBI, its reputation is in Tatters - worst in History!",
    -- 774: 2017-12-09
    "There are many outlets that are far more trusted than Fake News CNN.",
    -- 775: 2017-12-31
    "If the Dems (Crooked Hillary) got elected, your stocks would be down 50% from values on Election Day.",
    -- 776: 2018-01-01
    "Iran is failing at every level despite the terrible deal made with them by the Obama Administration.",
    -- 777: 2018-01-05
    "The Mercer Family recently dumped the leaker known as Sloppy Steve Bannon.",
    -- 778: 2018-01-07
    "Jake Tapper of Fake News CNN just got destroyed in his interview with Stephen Miller of the Trump Administration.",
    -- 779: 2018-01-24
    "Cryin' Chuck Schumer fully understands, especially after his humiliating defeat, that if there is no Wall, there is no DACA.",
    -- 780: 2018-03-11
    "The only Collusion was that done by the DNC, the Democrats and Crooked Hillary.",
    -- 781: 2018-03-25
    "Besides, there was NO COLLUSION with Russia, except by Crooked Hillary and the Dems!",
    -- 782: 2018-04-02
    "Sinclair is far superior to CNN and even more Fake NBC, which is a total joke.",
    -- 783: 2018-04-08
    "If President Obama had crossed his stated Red Line In The Sand, the Syrian disaster would have ended long ago!",
    -- 784: 2018-04-11
    "The Failing New York Times wrote another phony story.",
    -- 785: 2018-04-13
    "James Comey is a proven LEAKER & LIAR.",
    -- 786: 2018-04-13
    "DOJ just issued the McCabe report - which is a total disaster.",
    -- 787: 2018-04-15
    "Unbelievably, James Comey states that Polls, where Crooked Hillary was leading, were a factor in the handling (stupidly) of the Clinton Email probe.",
    -- 788: 2018-05-27
    "Why didn't the 13 Angry Democrats investigate the campaign of Crooked Hillary Clinton, many crimes, much Collusion with Russia?",
    -- 789: 2018-05-29
    "Why aren't the 13 Angry and heavily conflicted Democrats investigating the totally Crooked Campaign of totally Crooked Hillary Clinton.",
    -- 790: 2018-06-02
    "Real @FoxNews is doing great, Fake News CNN is dead!",
    -- 791: 2018-06-06
    "Wow, Strzok-Page, the incompetent & corrupt FBI lovers, have texts referring to a counter-intelligence operation into the Trump Campaign dating way back to December, 2015.",
    -- 792: 2018-06-08
    "Schumer failed with North Korea and Iran, we don't need his advice!",
    -- 793: 2018-06-15
    "The IG Report is a total disaster for Comey, his minions and sadly, the FBI.",
    -- 794: 2018-06-23
    "It's very sad that Nancy Pelosi and her sidekick, Cryin' Chuck Schumer, want to protect illegal immigrants far more than the citizens of our country.",
    -- 795: 2018-06-27
    "Congratulations to Maxine Waters, whose crazy rants have made her, together with Nancy Pelosi, the unhinged FACE of the Democrat Party.",
    -- 796: 2018-07-03
    "Just out that the Obama Administration granted citizenship, during the terrible Iran Deal negotiation, to 2,500 Iranians - including to government officials.",
    -- 797: 2018-07-31
    "Collusion is not a crime, but that doesn't matter because there was No Collusion (except by Crooked Hillary and the Democrats)!",
    -- 798: 2018-08-02
    "Morning Joe is a dead show with very few people watching and sadly, Fake News CNN is also doing poorly.",
    -- 799: 2018-08-13
    "Just fired Agent Strzok, formerly of the FBI, was in charge of the Crooked Hillary Clinton sham investigation.",
    -- 800: 2018-08-14
    "Fired FBI Agent Peter Strzok is a fraud, as is the rigged investigation he started.",
    -- 801: 2018-08-20
    "I hope John Brennan, the worst CIA Director in our country's history, brings a lawsuit.",
    -- 802: 2018-08-21
    "Maybe Clapper is being nice to me so he doesn't lose his Security Clearance for lying to Congress!",
    -- 803: 2018-08-25
    "Big story out that the FBI ignored tens of thousands of Crooked Hillary Emails, many of which are REALLY BAD.",
    -- 804: 2018-08-30
    "What's going on at @CNN is happening, to different degrees, at other networks - with @NBCNews being the worst.",
    -- 805: 2018-10-10
    "Don't worry, the Failing New York Times didn't even put the Brett Kavanaugh victory on the Front Page yesterday-A17!",
    -- 806: 2018-10-13
    "Opponent Lamb a Pelosi puppet-weak on crime.",
    -- 807: 2018-10-16
    "Thank you to the Cherokee Nation for revealing that Elizabeth Warren, sometimes referred to as Pocahontas, is a complete and total Fraud!",
    -- 808: 2018-12-09
    "Leakin' James Comey must have set a record for who lied the most to Congress in one day.",
    -- 809: 2019-01-05
    "Washington Post and NBC reporting of events, including Fake sources, has been very inaccurate (to put it mildly)!",
    -- 810: 2019-01-07
    "The Failing New York Times has knowingly written a very inaccurate story on my intentions on Syria.",
    -- 811: 2019-01-31
    "Schumer and the Democrats are big fans of being weak and passive with Iran.",
    -- 812: 2019-02-17
    "Nothing funny about tired Saturday Night Live on Fake News NBC!",
    -- 813: 2019-02-19
    "Remember this, Andrew McCabe didn't go to the bathroom without the approval of Leakin' James Comey!",
    -- 814: 2019-02-25
    "Former Senator Harry Reid (he got thrown out) is working hard to put a good spin on his failed career.",
    -- 815: 2019-03-03
    "The brand new manuscript for a new book by failed lawyer Michael Cohen shows his testimony was a total lie!",
    -- 816: 2019-03-13
    "The just revealed FBI Agent Lisa Page transcripts make the Obama Justice Department look exactly like it was, a broken and corrupt machine.",
    -- 817: 2019-03-28
    "Congressman Adam Schiff, who spent two years knowingly and unlawfully lying and leaking, should be forced to resign from Congress!",
    -- 818: 2019-04-02
    "There is no amount of testimony or document production that can satisfy Jerry Nadler or Shifty Adam Schiff.",
    -- 819: 2019-04-05
    "The Crazed and Dishonest Washington Post again purposely got it wrong.",
    -- 820: 2019-04-06
    "There was No Collusion and in fact the Phony Dossier was a Con Job that was paid for by Crooked Hillary and the DNC.",
    -- 821: 2019-04-19
    "The Washington Post and New York Times are, in my opinion, two of the most dishonest media outlets around.",
    -- 822: 2019-04-23
    "CNN has been a proven and long term ratings and beyond disaster.",
    -- 823: 2019-04-25
    "Welcome to the race Sleepy Joe.",
    -- 824: 2019-05-10
    "James Comey is a disgrace to the FBI & will go down as the worst Director in its long and once proud history.",
    -- 825: 2019-05-10
    "Looks to me like it's going to be SleepyCreepy Joe over Crazy Bernie.",
    -- 826: 2019-05-12
    "China is DREAMING that Sleepy Joe Biden, or any of the others, gets elected in 2020.",
    -- 827: 2019-05-20
    "Why are the Democrats not looking into all of the crimes committed by Crooked Hillary and the phony Russia Investigation?",
    -- 828: 2019-05-20
    "China wants Sleepy Joe BADLY!",
    -- 829: 2019-06-05
    "Can you imagine Cryin' Chuck Schumer saying out loud, for all to hear, that I am bluffing with respect to putting Tariffs on Mexico.",
    -- 830: 2019-06-05
    "Plagiarism charge against Sleepy Joe Biden on his ridiculous Climate Change Plan is a big problem, but the Corrupt Media will save him.",
    -- 831: 2019-06-08
    "Nervous Nancy Pelosi & the Democrat House are getting nothing done.",
    -- 832: 2019-06-09
    "The Failing @nytimes, & ratings challenged @CNN, will do anything possible to see our Country fail!",
    -- 833: 2019-06-09
    "The Dems were devastated - after all this time and money spent ($40,000,000), the Mueller Report was a disaster for them.",
    -- 834: 2019-06-16
    "A poll should be done on which is the more dishonest and deceitful newspaper, the Failing New York Times or the Amazon (lobbyist) Washington Post!",
    -- 835: 2019-06-18
    "The story in the @nytimes about the U.S. escalating attacks on Russia's power grid is Fake News, and the Failing New York Times knows it.",
    -- 836: 2019-06-21
    "Just revealed that the Failing and Desperate New York Times was feeding false stories about me, & those associated with me, to the FBI.",
    -- 837: 2019-06-21
    "President Obama made a desperate and terrible deal with Iran - Gave them 150 Billion Dollars plus I.8 Billion Dollars in CASH!",
    -- 838: 2019-07-07
    "The Fake News Media, in particular the Failing @nytimes, is writing phony and exaggerated accounts of the Border Detention Centers.",
    -- 839: 2019-07-14
    "Failing @nytimes story was FAKE!",
    -- 840: 2019-07-21
    "The Washington Post Story, about my speech in North Carolina and tweet, with its phony sources who do not exist, is Fake News.",
    -- 841: 2019-07-26
    "Now new Fox Polls, which have always been terrible to me (they had me losing BIG to Crooked Hillary), have me down to Sleepy Joe.",
    -- 842: 2019-07-27
    "The Dems are now coming out of shock from the terrible Mueller performance, and are starting to spin impeachment all over again.",
    -- 843: 2019-07-28
    "Speaking of failing badly, has anyone seen what is happening to Nancy Pelosi's district in San Francisco.",
    -- 844: 2019-08-07
    "Watching Fake News CNN is better than watching Shepard Smith, the lowest rated show on @FoxNews.",
    -- 845: 2019-08-24
    "Such a sad and pathetic fall for @CNN and Jeff Z!",
    -- 846: 2019-08-31
    "I was right about Comey, CROOKED COP!",
    -- 847: 2019-09-02
    "If you followed the advice of the Failing New York Times columnist, Paul Krugman, you'd be doing VERY poorly - you'd be angry and hurt.",
    -- 848: 2019-09-03
    "The incompetent Mayor of London, Sadiq Khan, was bothered that I played a very fast round of golf yesterday.",
    -- 849: 2019-09-10
    "ABC/Washington Post Poll was the worst and most inaccurate poll of any taken prior to the 2016 Election.",
    -- 850: 2019-09-21
    "Nothing was said that was in any way wrong, but Biden's demand, on the other hand, was a complete and total disaster.",
    -- 851: 2019-09-22
    "Justice Kavanaugh should sue The Failing New York Times for all they are worth!",
    -- 852: 2019-09-27
    "To show you how dishonest the LameStream Media is, I used the word Liddle', not Liddle, in discribing Corrupt Congressman Liddle' Adam Schiff.",
    -- 853: 2019-10-03
    "Schiff is a lying disaster for our Country.",
    -- 854: 2019-10-03
    "Schiff is a lowlife who should resign (at least!).",
    -- 855: 2019-10-15
    "Tomorrow they will ask softball questions to Sleepy Joe Biden's son, Hunter, like why did Ukraine & China pay you millions when you knew nothing?",
    -- 856: 2019-10-15
    "Hunter Biden was really bad on @GMA. Now Sleepy Joe has real problems! Reminds me of Crooked Hillary and her 33,000 deleted Emails, not recoverable!",
    -- 857: 2019-10-15
    "Now that we have found out that @CNN is a virtual fraud, rumor has it that Jeff Zucker will be resigining momentarily?",
    -- 858: 2019-10-19
    "Susan Rice, who was a disaster to President Obama as National Security Advisor, is now telling us her opinion on what to do in Syria.",
    -- 859: 2019-10-19
    "Just another FAKE SUPPRESSION POLL, this time from @FoxNews, of course!",
    -- 860: 2019-10-21
    "Adam Schiff is a Corrupt Politician!",
    -- 861: 2019-10-21
    "Censure (at least) Corrupt Adam Schiff!",
    -- 862: 2019-10-25
    "My lawyers should sue the Democrats and Shifty Adam Schiff for fraud!",
    -- 863: 2019-10-26
    "Even Shifty Schiff got caught cheating when he made up what I said on the call!",
    -- 864: 2019-10-26
    "The Fake Washington Post keeps doing phony stories, with zero sources, that I am concerned with the Impeachment scam.",
    -- 865: 2019-10-29
    "Just read the Transcript, everything else is made up garbage by Shifty Schiff and the Never Trumpers!",
    -- 866: 2019-10-29
    "Nervous Nancy Pelosi is doing everything possible to destroy the Republican Party.",
    -- 867: 2019-11-01
    "Corrupt politicians, Pelosi and Schiff, are trying to take down the Republican Party.",
    -- 868: 2019-11-01
    "The Dems are a mess under the corrupt leadership of Nervous Nancy Pelosi and Shifty Adam Schiff!",
    -- 869: 2019-11-11
    "Shifty Adam Schiff will only release doctored transcripts.",
    -- 870: 2019-12-08
    "Schiff is a corrupt politician and a criminal!",
    -- 871: 2019-12-08
    ".CNN is a ratings disaster.",
    -- 872: 2019-12-10
    "Shifty Schiff, a totally corrupt politician, made up a horrible and fraudulent statement, read it to Congress, and said those words came from me.",
    -- 873: 2019-12-13
    "CNN and MSNBC have totally tanked, their ratings are terrible.",
    -- 874: 2019-12-15
    "Both Commiecast MSNBC & Fake News CNN are watching their Ratings TANK.",
    -- 875: 2019-12-15
    "Crazy Nancy is finding defending Shifty Schiff harder than she thought!",
    -- 876: 2019-12-26
    "Nancy Pelosi's District in California has rapidly become one of the worst anywhere in the U.S. when it come to the homeless & crime.",
    -- 877: 2019-12-28
    "Crazy Nancy Pelosi should spend more time in her her decaying city and less time on the Impeachment Hoax!",
    -- 878: 2020-01-11
    "Nancy Pelosi will go down as the absolute worst Speaker of the House in U.S. history!",
    -- 879: 2020-01-12
    "Why did Nervous Nancy allow corrupt politician Shifty Schiff to lie before Congress?",
    -- 880: 2020-01-13
    "Mini Mike Bloomberg is spending a lot of money on False Advertising.",
    -- 881: 2020-01-17
    "Mini Mike Bloomberg ads are purposely wrong - A vanity project for him to get into the game.",
    -- 882: 2020-01-23
    "Will Sleepy Joe be able to stumble across the finish line?",
    -- 883: 2020-01-26
    "Shifty Adam Schiff is a CORRUPT POLITICIAN, and probably a very sick man.",
    -- 884: 2020-01-28
    "Chris Wallace and others should be on Fake News CNN or MSDNC.",
    -- 885: 2020-01-31
    "Nadler ripped final argument away from Schiff, thinks Shifty did a terrible job.",
    -- 886: 2020-02-02
    "Mini Mike is part of the Fake News.",
    -- 887: 2020-02-03
    "Why did Corrupt politician Schiff MAKE UP my conversation with the Ukrainian President???",
    -- 888: 2020-02-11
    "Mini Mike is a short ball (very) hitter.",
    -- 889: 2020-02-12
    "A very bad night for Mini Mike!",
    -- 890: 2020-02-18
    "The Crooked DNC is working overtime to take the Democrat Nomination away from Bernie, AGAIN!",
    -- 891: 2020-02-18
    "Mini Mike, Major Party Nominations are not for sale!",
    -- 892: 2020-02-20
    "Mini Mike Bloomberg's debate performance tonight was perhaps the worst in the history of debates, and there have been some really bad ones.",
    -- 893: 2020-02-22
    "It's all rigged, again, against Crazy Bernie Sanders!",
    -- 894: 2020-02-25
    "Cryin' Chuck Schumer is complaining, for publicity purposes only, that I should be asking for more money than $2.5 Billion to prepare for Coronavirus.",
    -- 895: 2020-02-26
    "Fake News said Biden did well, even though he said half of our population was shot to death.",
    -- 896: 2020-02-28
    "Word is that Mini Mike Bloomberg performed so poorly in the two debates, that he is thinking about dropping out of the Democrat Primary.",
    -- 897: 2020-03-01
    "Sleepy Joe Biden's victory in the South Carolina Democrat Primary should be the end of Mini Mike Bloomberg's Joke of a campaign.",
    -- 898: 2020-03-01
    "Democrats are working hard to destroy the name and reputation of Crazy Bernie Sanders, and take the nomination away from him!",
    -- 899: 2020-03-01
    "People are disgusted and embarrassed by the Fake News Media, as headed by the @nytimes, @washingtonpost, @comcast & MSDNC, @ABC, @CBSNews and more.",
    -- 900: 2020-03-02
    "Mini Mike Bloomberg didn't bring NYC back, as he said in his fake ad.",
    -- 901: 2020-03-02
    "The Black community brilliantly turned their backs on Mini Mike because they know he is a pandering phony who never did right by them!",
    -- 902: 2020-03-02
    "Sleepy Eyes Chuck Todd is not at the top of his game! Thank you.",
    -- 903: 2020-03-03
    "Sleepy Joe doesn't know where he is, or what he's doing.",
    -- 904: 2020-03-03
    "Mini Mike Bloomberg can never recover from his incompetent debate performances.",
    -- 905: 2020-03-04
    "Mini Mike, don't lick your dirty fingers.",
    -- 906: 2020-03-04
    "Mini Mike Bloomberg will now FIRE Tim O'Brien, and all of the fools and truly dumb people who got him into this MESS.",
    -- 907: 2020-03-04
    "Pandering Mini Mike Bloomberg, along with his wacky friend, Tom Steyer, have found out the hard way that you can't buy the election!",
    -- 908: 2020-03-09
    "The Obama/Biden Administration is the most corrupt Administration in the history of our Country!",
    -- 909: 2020-03-11
    "Pocahontas, working in conjunction with the Democrat Party, totally destroyed the campaign of Bernie Sanders.",
    -- 910: 2020-03-13
    "Sleepy Joe Biden was in charge of the H1N1 Swine Flu epidemic which killed thousands of people.",
    -- 911: 2020-03-28
    "Such Fake reporting by the @nytimes, @washingtonpost, @CNN & others.",
    -- 912: 2020-04-02
    "Somebody please explain to Cryin' Chuck Schumer that we do have a military man in charge of distributing goods, a very talented Admiral, in fact.",
    -- 913: 2020-04-26
    "Chris Wallace is nastier to Republicans than even Deface the Nation or Sleepy Eyes.",
    -- 914: 2020-04-29
    "The Failing @nytimes & @washingtonpost never correct their Fake Reporting!",
    -- 915: 2020-04-30
    "Just told that Fake News @CNN is falsely reporting that I was recently shouting at my campaign manager over made up nonsense.",
    -- 916: 2020-04-30
    "Lyin' Brian Williams of MSDNC, a Concast Scam Company, wouldn't know the truth if it was nailed to his wooden forehead.",
    -- 917: 2020-05-01
    "Concast (@NBCNews) and Fake News @CNN are going out of their way to say GREAT things about China.",
    -- 918: 2020-05-02
    "Crazy Nancy gets Nothing Done, that's why she got thrown out as Speaker the first time.",
    -- 919: 2020-05-02
    "Now Wallace is a 3rd rate lapdog for Fake News MSDNC (Concast).",
    -- 920: 2020-05-04
    "MSDNC and FAKE NEWS CNN are going wild trying to protect China!",
    -- 921: 2020-05-05
    "I don't know what Kellyanne did to her deranged loser of a husband, Moonface, but it must have been really bad.",
    -- 922: 2020-05-12
    "Crazy Nancy would be a total disaster, and the USA will never be a Communist Country!",
    -- 923: 2020-05-12
    "When will they open a Cold Case on the Psycho Joe Scarborough matter in Florida.",
    -- 924: 2020-05-12
    "We will win against a tired, exhausted man, Sleepy Joe Biden, in November.",
    -- 925: 2020-05-15
    "Fake News @CNN and Concast's own MSDNC are only trying to make their 3 year Con Job just go away.",
    -- 926: 2020-05-17
    "The Obama Administration is turning out to be one of the most corrupt and incompetent in U.S. history.",
    -- 927: 2020-05-20
    "@FoxNews And guys like Low Ratings Psycho Joe Scarborough are allowed to walk the streets?",
    -- 928: 2020-05-22
    ".@FoxNews should fire their Fake Pollster.",
    -- 929: 2020-05-23
    "Sleepy Joe cannot bring us to greatness.",
    -- 930: 2020-05-24
    "SLEEPY JOE WILL NEVER GET YOU THERE.",
    -- 931: 2020-05-25
    "Connor Lamm has proven to be an American fraud, and a puppet for Crazy Nancy Pelosi.",
    -- 932: 2020-05-25
    "Nobody in 50 years has been WEAKER on China than Sleepy Joe Biden.",
    -- 933: 2020-05-30
    "Fake News @CNN is blaming RUSSIA, RUSSIA, RUSSIA.",
    -- 934: 2020-06-02
    "Sleepy Joe has been in politics for 40 years, and did nothing.",
    -- 935: 2020-06-03
    "Really sick to watch the Fake and totally Slanted News(?) coming out of MSDNC and CNN.",
    -- 936: 2020-06-05
    "Sleepy Joe Biden's 1994 Crime Bill was a total disaster.",
    -- 937: 2020-06-07
    "Not only will Sleepy Joe Biden DEFUND THE POLICE, but he will DEFUND OUR MILITARY!",
    -- 938: 2020-06-07
    "The New York Times is Fake News!!!",
    -- 939: 2020-06-08
    "CNN Polls are as Fake as their Reporting.",
    -- 940: 2020-06-10
    "Sleepy Joe Biden will be (already is) pulled all the way Left.",
    -- 941: 2020-06-15
    "Biden has been a part of every failed decision for decades.",
    -- 942: 2020-06-18
    "Bolton's book, which is getting terrible reviews, is a compilation of lies and made up stories, all intended to make me look bad.",
    -- 943: 2020-06-23
    "Washed up Creepster John Bolton is a lowlife who should be in jail, money seized, for disseminating, for profit, highly Classified information.",
    -- 944: 2020-06-28
    "Funny to see Corrupt Joe Biden reading a statement on Russia, which was obviously written by his handlers.",
    -- 945: 2020-06-28
    "Nobody wants a Low IQ person in charge of our Country, and Sleepy Joe is definitely a Low IQ person!",
    -- 946: 2020-06-29
    "Corrupt Joe Biden's team is running false ads.",
    -- 947: 2020-06-29
    "Just like 2016, the @nytimes Polls are Fake!",
    -- 948: 2020-07-01
    "Morning Joke, staring Psycho Joe Scarborough on MSDNC, a Concast Company, was a disaster.",
    -- 949: 2020-07-01
    "Under Corrupt Joe Biden and his MASSIVE Tax and Regulation increases, Markets, and your 401k's, will PLUNGE!",
    -- 950: 2020-07-04
    "The @nytimes is a very corrupt and dishonest media outlet that suffers TDS at a level rarely seen.",
    -- 951: 2020-07-06
    "Corrupt Joe Biden and the Democrats don't want to open schools in the Fall for political reasons, not for health reasons!",
    -- 952: 2020-07-11
    "Jeff Sessions is a disaster who has let us all down.",
    -- 953: 2020-07-15
    "@DougJones is a terrible Senator who is just a Super Liberal puppet for Schumer & Pelosi.",
    -- 954: 2020-07-18
    "Corrupt Joe Biden wants to defund our police.",
    -- 955: 2020-07-26
    "The Obama/Biden Administration is the most corrupt in history.",
    -- 956: 2020-07-29
    "Sleepy Joe Biden is just a Trojan Horse for the Radical Left Agenda.",
    -- 957: 2020-08-01
    "We beat Obama 4 years ago, he worked harder than Crooked Hillary, and we'll do it again!",
    -- 958: 2020-08-07
    "After yesterday's statement, Sleepy Joe Biden is no longer worthy of the Black Vote!",
    -- 959: 2020-08-15
    "Sleepy Joe never takes questions.",
    -- 960: 2020-08-18
    "The Bernie/Biden/AOC Green New Deal plan would take California's failed policies to every American!",
    -- 961: 2020-09-02
    "The Beauty Parlor owner must really dislike Crazy Nancy Pelosi.",
    -- 962: 2020-09-03
    "Sleepy Joe Hiden' was acknowledged by his own people to have done a terrible job on a much easier situation, H1N1 Swine Flu.",
    -- 963: 2020-09-03
    ".@FoxNews Polls are, as in the past, Fake News.",
    -- 964: 2020-09-03
    "Do you notice that any time Fake News Suppression Polls are put out, like @FoxNews, the Stock Market goes DOWN.",
    -- 965: 2020-09-07
    ".@CNN IS FAKE NEWS, and all smart people know that!",
    -- 966: 2020-09-07
    "The Fake News knows that Sleepy Joe doesn't have a clue, and they want to protect his Radical Left Democrat enablers.",
    -- 967: 2020-09-08
    "Sleepy Joe Biden has pledged to ABOLISH Suburban Communites as they currently exist by reinstating Obama's radical AFFH Regulation.",
    -- 968: 2020-09-11
    "Sleepy Joe Biden will do the opposite, he will raise your taxes and DESTROY our Country!",
    -- 969: 2020-09-11
    "Sleepy Joe Biden has vowed to remove those Tariffs and allow China to resume its pillaging.",
    -- 970: 2020-09-13
    "I did more in 47 months as President than Sleepy Joe Biden did in 47 years!",
    -- 971: 2020-09-13
    "Sleepy Joe Biden has spent 47 years in politics being terrible to Hispanics.",
    -- 972: 2020-09-14
    "Actually, I think, based on Crowds and Enthusiasm (of which Sleepy Joe has none!), that we are MUCH higher than 51%.",
    -- 973: 2020-09-20
    "Sleepy Joe wants to quadruple your taxes and go to socialized healthcare.",
    -- 974: 2020-09-27
    "I will be strongly demanding a Drug Test of Sleepy Joe Biden prior to, or after, the Debate on Tuesday night.",
    -- 975: 2020-09-27
    "Wow, nobody realized how far Mini Mike Bloomberg went in bribing ex-prisoners to go out and vote for Sleepy Joe.",
    -- 976: 2020-09-30
    "Nobody wants Sleepy Joe as a leader, including the Radical Left (which he lost last night!). He disrespected Bernie, effectively calling him a loser!",
    -- 977: 2020-10-01
    "The whole nation saw the truth -- Joe Biden is too weak to lead this Country!",
    -- 978: 2020-10-01
    "Comey is a disaster who cheated and lied.",
    -- 979: 2020-10-06
    "How does Biden lead in Pennsylvania Polls when he is against Fracking (JOBS!), 2nd Amendment and Religion? Fake Polls. I will win Pennsylvania!",
    -- 980: 2020-10-07
    "BIDEN, OBAMA AND CROOKED HILLARY LED THIS TREASONOUS PLOT!!!",
    -- 981: 2020-10-08
    "Obama, Biden, Crooked Hillary and many others got caught in a Treasonous Act of Spying and Government Overthrow, a Criminal Act.",
    -- 982: 2020-10-08
    "Crazy Nancy is the one who should be under observation.",
    -- 983: 2020-10-10
    "Joe Biden is a PUPPET of CASTRO-CHAVISTAS like Crazy Bernie, AOC and Castro-lover Karen Bass.",
    -- 984: 2020-10-12
    "With Sleepy Joe comes Tax Increases, jobs losses and DEPRESSION like never seen before!!!",
    -- 985: 2020-10-12
    "Sleepy Joe wants to quadruple your Taxes.",
    -- 986: 2020-10-12
    "STOCK MARKET UP ANOTHER 300 POINTS - GREATEST LEADING INDICATOR OF THEM ALL!!! DON'T RUIN IT WITH SLEEPY JOE!!!",
    -- 987: 2020-10-17
    "SLEEPY JOE BIDEN IS PROPOSING THE BIGGEST TAX HIKE IN OUR COUNTRY'S HISTORY! CAN ANYBODY REALLY VOTE FOR THIS?",
    -- 988: 2020-10-18
    "Joe Biden is the living embodiment of the corrupt political class that enriched itself while draining the economic life and soul from our Country.",
    -- 989: 2020-10-18
    "Joe Biden is a corrupt politician -- and the Biden family is a criminal enterprise.",
    -- 990: 2020-10-18
    "Joe Biden is a corrupt politician, and everybody knows it.",
    -- 991: 2020-10-18
    "By the way, is this the same job hopping Tim O'Brien that headed Mini Mike Bloomberg's humiliating 2 Billion Dollar Presidential run?",
    -- 992: 2020-10-18
    "Corrupt politician Joe Biden makes Crooked Hillary look like an amateur!",
    -- 993: 2020-10-22
    "I am not just running against Biden, I am running against the Corrupt Media, the Big Tech Giants, and the Washington Swamp.",
    -- 994: 2020-10-24
    "Joe Biden is a corrupt politician and he's COMPROMISED.",
    -- 995: 2020-10-26
    "I have plenty to say about the dishonesty of the Media and Sleepy Joe.",
    -- 996: 2020-10-27
    "Joe Biden FAILED BADLY with the Swine Flu Epidemic.",
    -- 997: 2020-10-27
    "Joe Biden is a corrupt politician.",
    -- 998: 2020-10-29
    "Joe Biden is a corrupt politician--If Biden Wins, China Wins.",
    -- 999: 2020-10-30
    "Joe Biden is a corrupt politician--the Biden family is looking more & more like a crime family.",
    -- 1000: 2020-10-31
    "Sleepy Joe would BAN fracking and destroy American energy jobs!",
    -- 1001: 2020-11-01
    "Joe Biden has been a disaster for African Americans and Hispanic Americans--I am fighting for citizens of every race, color and creed.",
    -- 1002: 2020-11-01
    "People are forgetting that if Sleepy Joe Biden and the Radical Left Dems win, you will vey quickly lose your Second Amendment!",
    -- 1003: 2020-11-02
    "Joe Biden is a corrupt politician who is bought and paid for by China!",
    -- 1004: 2020-11-02
    "For 47 years, Sleepy Joe Biden betrayed Hispanic-Americans.",
    -- 1005: 2020-11-02
    "Biden was a pathetic laughing stock all over Washington for the horrible way he handled the H1N1 Swine Flu.",
    -- 1006: 2020-11-02
    "Joe Biden is a corrupt politician who SOLD OUT Pennsylvania to CHINA!",
    -- 1007: 2020-11-03
    "Sleepy Joe Biden has vowed to ABOLISH the American oil and natural gas industries, and BAN fracking.",
    -- 1008: 2020-11-03
    "Biden is a corrupt politician who SOLD OUT Michigan to CHINA.",
    -- 1009: 2020-12-05
    "I read the Fake News Washington Post as little as possible!",
    -- 1010: 2020-12-18
    "Check out last in his class John McCain, one of the most overrated people in D.C.",
    -- 1011: 2020-12-29
    "Biden failed with Swine Flu!",
    -- 1012: 2021-01-06
    "Sleepy Eyes Chuck Todd is so happy with the fake voter tabulation process that he can't even get the words out straight.",
}

for _, quote in ipairs(excerpts) do
    ns.quotes[#ns.quotes + 1] = quote
end
