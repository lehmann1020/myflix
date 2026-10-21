-- Seed data: 40 real titles (20 movies, 20 shows) from TMDB, fetched by the tmdb-titles edge function.
-- Replaces the old placeholder catalog. Posters are TMDB image URLs. Genres are matched by NAME.
-- Run order: delete placeholders (cascades to title_genres), insert titles, then link genres.

delete from public.titles;

insert into public.titles (name, type, description, full_description, poster_url, release_year) values
  ('Spider-Man: Brand New Day', 'movie', 'Fighting crime full-time as Spider-Man in a world that doesn''t remember him—and the pressure of seeing his old friends move on without...', 'Fighting crime full-time as Spider-Man in a world that doesn''t remember him—and the pressure of seeing his old friends move on without him—sparks a change in Peter Parker he may not have the power to control. But that transformation might also be the only thing that can stop a shocking new threat to the city and those he loves - a powerful villain no one can even see.', 'https://image.tmdb.org/t/p/w500/bjiS5ipwxb9JFy3XRRN4OAilSeX.jpg', 2026),
  ('Runner', 'movie', 'A former soldier is thrown into a brutal race against time when a critical medical delivery makes him and his unlikely partner the...', 'A former soldier is thrown into a brutal race against time when a critical medical delivery makes him and his unlikely partner the targets of a ruthless cartel. As the mission spirals into a deadly manhunt, every detour, delay, and bullet pushes them closer to failure. With betrayal closing in from every side, they must survive the chase and deliver their cargo to save the life of a little girl.', 'https://image.tmdb.org/t/p/w500/yBKMAIj7clP42UkFejhGDBBoTpb.jpg', 2026),
  ('Animals', 'movie', 'When the son of an L.A. mayoral candidate is kidnapped, he and his wife have a few hours to come up with the ransom payment. With most...', 'When the son of an L.A. mayoral candidate is kidnapped, he and his wife have a few hours to come up with the ransom payment. With most of their money spent on his political campaign, they have to get their hands dirty and expose a side of their lives they never intended to see the light of day.', 'https://image.tmdb.org/t/p/w500/iISM36voS1E8gX9BM0DVK0kgi3E.jpg', 2026),
  ('Insidious: Out of the Further', 'movie', 'Gemma, a young mother raising her daughter in the house she grew up in, discovers she can travel into The Further, where she possesses...', 'Gemma, a young mother raising her daughter in the house she grew up in, discovers she can travel into The Further, where she possesses an ability to bring what lives there back to the real world.', 'https://image.tmdb.org/t/p/w500/4tTrW9dXCByS5wt2pXVWb58zNjz.jpg', 2026),
  ('Corpse Bride', 'movie', 'In a 19th-century European village, a young man about to be married is whisked away to the underworld and wed to a mysterious corpse...', 'In a 19th-century European village, a young man about to be married is whisked away to the underworld and wed to a mysterious corpse bride, while his real bride waits bereft in the land of the living.', 'https://image.tmdb.org/t/p/w500/3RAoVTxUk1OzZClscAsynuu670p.jpg', 2005),
  ('The Odyssey', 'movie', 'Odysseus, the legendary King of Ithaca, embarks on a long and perilous journey home following the Trojan War. Throughout his voyage, he...', 'Odysseus, the legendary King of Ithaca, embarks on a long and perilous journey home following the Trojan War. Throughout his voyage, he is forced to confront the whims of gods, mythological monsters, and trials that stretch both his cunning and his humanity to the breaking point.', 'https://image.tmdb.org/t/p/w500/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg', 2026),
  ('Toy Story 5', 'movie', 'When Bonnie receives a Lilypad tablet as a gift and becomes obsessed, Buzz, Woody, Jessie and the rest of the gang''s jobs become...', 'When Bonnie receives a Lilypad tablet as a gift and becomes obsessed, Buzz, Woody, Jessie and the rest of the gang''s jobs become exponentially harder when they have to go head to head with the all-new threat to playtime.', 'https://image.tmdb.org/t/p/w500/sfQtVlIHljToOwYjhe21KPGzZWK.jpg', 2026),
  ('Interstellar', 'movie', 'The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and...', 'The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.', 'https://image.tmdb.org/t/p/w500/yQvGrMoipbRoddT0ZR8tPoR7NfX.jpg', 2014),
  ('Resident Evil', 'movie', 'Medical courier Bryan unwittingly finds himself fighting for survival as one fateful, horrifying night collapses around him in chaos.', 'Medical courier Bryan unwittingly finds himself fighting for survival as one fateful, horrifying night collapses around him in chaos.', 'https://image.tmdb.org/t/p/w500/i7UyjfPio0VFHB9rBUZSFyhOoM8.jpg', 2026),
  ('The Love Hypothesis', 'movie', 'Olive Smith, a biology PhD candidate, and Dr. Adam Carlsen, a hotshot professor and well-known tyrant, enter into a fake relationship,...', 'Olive Smith, a biology PhD candidate, and Dr. Adam Carlsen, a hotshot professor and well-known tyrant, enter into a fake relationship, seeing each of their carefully calculated theories on love get thrown into chaos.', 'https://image.tmdb.org/t/p/w500/vfZxVHextAGC70zrNhS8lsROqP1.jpg', 2026),
  ('Fall 2: Deadpoint', 'movie', 'On a perilous climb across Thailand''s Mount Kwan, two climbers become trapped thousands of feet above the ground, where vertigo-inducing...', 'On a perilous climb across Thailand''s Mount Kwan, two climbers become trapped thousands of feet above the ground, where vertigo-inducing heights, sheer exposure, and impossible odds turn every moment into a fight for survival.', 'https://image.tmdb.org/t/p/w500/fgSm5ylwiXbIHn8UbUXDjk9RRu4.jpg', 2026),
  ('Clue', 'movie', 'Clue finds six colorful dinner guests gathered at the mansion of their host, Mr. Boddy -- who turns up dead after his secret is exposed:...', 'Clue finds six colorful dinner guests gathered at the mansion of their host, Mr. Boddy -- who turns up dead after his secret is exposed: He was blackmailing all of them. With the killer among them, the guests and Boddy''s chatty butler must suss out the culprit before the body count rises.', 'https://image.tmdb.org/t/p/w500/aRxbYOYHS8T73nzR8hsLousoplR.jpg', 1985),
  ('Top Gun: Maverick', 'movie', 'After more than thirty years of service as one of the Navy’s top aviators, and dodging the advancement in rank that would ground him,...', 'After more than thirty years of service as one of the Navy’s top aviators, and dodging the advancement in rank that would ground him, Pete “Maverick” Mitchell finds himself training a detachment of TOP GUN graduates for a specialized mission the likes of which no living pilot has ever seen.', 'https://image.tmdb.org/t/p/w500/n0YuM4f5lvGAP6MAW2kBIzugXnc.jpg', 2022),
  ('Resident Evil: Welcome to Raccoon City', 'movie', 'Once the booming home of pharmaceutical giant Umbrella Corporation, Raccoon City is now a dying Midwestern town. The company’s exodus...', 'Once the booming home of pharmaceutical giant Umbrella Corporation, Raccoon City is now a dying Midwestern town. The company’s exodus left the city a wasteland…with great evil brewing below the surface. When that evil is unleashed, the townspeople are forever…changed…and a small group of survivors must work together to uncover the truth behind Umbrella and make it through the night.', 'https://image.tmdb.org/t/p/w500/bArhvjRHl535XMaSh9VjInF2mSZ.jpg', 2021),
  ('Titanic', 'movie', '101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic, 84 years later. A young Rose boards the ship with her...', '101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic, 84 years later. A young Rose boards the ship with her mother and fiancé. Meanwhile, Jack Dawson and Fabrizio De Rossi win third-class tickets aboard the ship. Rose tells the whole story from Titanic''s departure through to its death—on its first and last voyage—on April 15, 1912.', 'https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg', 1997),
  ('The End of Oak Street', 'movie', 'After a mysterious cosmic event rips Oak Street from suburbia and transports their neighborhood to someplace unknown, the Platt family...', 'After a mysterious cosmic event rips Oak Street from suburbia and transports their neighborhood to someplace unknown, the Platt family soon discovers that their very survival depends on them sticking together as they navigate their now unrecognizable surroundings.', 'https://image.tmdb.org/t/p/w500/hkPxuAMEqIqo1HCtIi4sqx0GRuP.jpg', 2026),
  ('Coyote vs. Acme', 'movie', 'After Acme products fail him one too many times in his dogged pursuit of the Roadrunner, Wile E. Coyote decides to hire a billboard...', 'After Acme products fail him one too many times in his dogged pursuit of the Roadrunner, Wile E. Coyote decides to hire a billboard lawyer to sue the Acme Corporation.', 'https://image.tmdb.org/t/p/w500/kYDCl2y0VPvhT5eYWbMRInPoB03.jpg', 2026),
  ('Oppenheimer', 'movie', 'The story of J. Robert Oppenheimer''s role in the development of the atomic bomb during World War II.', 'The story of J. Robert Oppenheimer''s role in the development of the atomic bomb during World War II.', 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', 2023),
  ('Obsession', 'movie', 'After breaking the mysterious "One Wish Willow" to win his crush''s heart, a hopeless romantic finds himself getting exactly what he...', 'After breaking the mysterious "One Wish Willow" to win his crush''s heart, a hopeless romantic finds himself getting exactly what he asked for but soon discovers that some desires come at a dark, sinister price.', 'https://image.tmdb.org/t/p/w500/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg', 2026),
  ('Wicked: For Good', 'movie', 'As an angry mob rises against the Wicked Witch, Glinda and Elphaba must unite one last time with honesty and empathy to fulfill their...', 'As an angry mob rises against the Wicked Witch, Glinda and Elphaba must unite one last time with honesty and empathy to fulfill their shared destiny and change the fate of Oz forever.', 'https://image.tmdb.org/t/p/w500/si9tolnefLSUKaqQEGz1bWArOaL.jpg', 2025),
  ('Torchwood', 'show', 'The exploits of a team of people whose job is to investigate the unusual, the strange and the extraterrestrial.', 'The exploits of a team of people whose job is to investigate the unusual, the strange and the extraterrestrial.', 'https://image.tmdb.org/t/p/w500/bv7C5r7QyXGsaMxvU40FVY7SvrD.jpg', 2006),
  ('South Park', 'show', 'Follow the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.', 'Follow the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.', 'https://image.tmdb.org/t/p/w500/k7n2EVge7G77eMr3brztRGG1fFU.jpg', 1997),
  ('Breaking Bad', 'show', 'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live....', 'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family''s financial future at any cost as he enters the dangerous world of drugs and crime.', 'https://image.tmdb.org/t/p/w500/anFx9aTOOYqgS3v7x3R84Kz67ly.jpg', 2008),
  ('Reacher', 'show', 'Jack Reacher, a veteran military police investigator, has just recently entered civilian life. Reacher is a drifter, carrying no phone...', 'Jack Reacher, a veteran military police investigator, has just recently entered civilian life. Reacher is a drifter, carrying no phone and the barest of essentials as he travels the country and explores the nation he once served.', 'https://image.tmdb.org/t/p/w500/f1VCQIG2iCyOookdgOzwtUpwWC0.jpg', 2022),
  ('The Bear', 'show', 'Carmy, a young fine-dining chef, comes home to Chicago to run his family sandwich shop. As he fights to transform the shop and himself,...', 'Carmy, a young fine-dining chef, comes home to Chicago to run his family sandwich shop. As he fights to transform the shop and himself, he works alongside a rough-around-the-edges crew that ultimately reveal themselves as his chosen family.', 'https://image.tmdb.org/t/p/w500/eKfVzzEazSIjJMrw9ADa2x8ksLz.jpg', 2022),
  ('Law & Order', 'show', 'In cases ripped from the headlines, police investigate serious and often deadly crimes, weighing the evidence and questioning the...', 'In cases ripped from the headlines, police investigate serious and often deadly crimes, weighing the evidence and questioning the suspects until someone is taken into custody. The district attorney''s office then builds a case to convict the perpetrator by proving the person guilty beyond a reasonable doubt. Working together, these expert teams navigate all sides of the complex criminal justice system to make New York a safer place.', 'https://image.tmdb.org/t/p/w500/hmd2tEtjolLWpNLCTvXS2PO5VCi.jpg', 1990),
  ('Supernatural', 'show', 'When they were boys, Sam and Dean Winchester lost their mother to a mysterious and demonic supernatural force. Subsequently, their...', 'When they were boys, Sam and Dean Winchester lost their mother to a mysterious and demonic supernatural force. Subsequently, their father raised them to be soldiers. He taught them about the paranormal evil that lives in the dark corners and on the back roads of America ... and he taught them how to kill it. Now, the Winchester brothers crisscross the country in their ''67 Chevy Impala, battling every kind of supernatural threat they encounter along the way. ', 'https://image.tmdb.org/t/p/w500/8iixmfGx5EIFPdpNvB2JvI3VIqX.jpg', 2005),
  ('NCIS', 'show', 'From murder and espionage to terrorism and stolen submarines, a team of special agents investigates any crime that has any connection to...', 'From murder and espionage to terrorism and stolen submarines, a team of special agents investigates any crime that has any connection to Navy and Marine Corps personnel, regardless of rank or position.', 'https://image.tmdb.org/t/p/w500/y4fGncqELtnvRQuwSpuH8LncZqU.jpg', 2003),
  ('The Simpsons', 'show', 'Set in Springfield, the average American town, the show focuses on the antics and everyday adventures of the Simpson family; Homer,...', 'Set in Springfield, the average American town, the show focuses on the antics and everyday adventures of the Simpson family; Homer, Marge, Bart, Lisa and Maggie, as well as a virtual cast of thousands. Since the beginning, the series has been a pop culture icon, attracting hundreds of celebrities to guest star. The show has also made name for itself in its fearless satirical take on politics, media and American life in general.', 'https://image.tmdb.org/t/p/w500/tf0CUEynk6GfmrlHIQKQ5mfFP5P.jpg', 1989),
  ('Game of Thrones', 'show', 'Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while...', 'Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night''s Watch, is all that stands between the realms of men and icy horrors beyond.', 'https://image.tmdb.org/t/p/w500/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg', 2011),
  ('Law & Order: Special Victims Unit', 'show', 'In the criminal justice system, sexually-based offenses are considered especially heinous. In New York City, the dedicated detectives...', 'In the criminal justice system, sexually-based offenses are considered especially heinous. In New York City, the dedicated detectives who investigate these vicious felonies are members of an elite squad known as the Special Victims Unit. These are their stories.', 'https://image.tmdb.org/t/p/w500/pHNhUwSXuDQ9jPZOCb8SgJaQZsc.jpg', 1999),
  ('The Daily Show', 'show', 'The World''s Fakest News Team tackle the biggest stories in news, politics and pop culture.', 'The World''s Fakest News Team tackle the biggest stories in news, politics and pop culture.', 'https://image.tmdb.org/t/p/w500/ixcfyK7it6FjRM36Te4OdblAq4X.jpg', 1996),
  ('American Horror Story', 'show', 'An anthology horror drama series centering on different characters and locations, including a house with a murderous past, an asylum, a...', 'An anthology horror drama series centering on different characters and locations, including a house with a murderous past, an asylum, a witch coven, a freak show, a hotel, a farmhouse in Roanoke, a cult, the apocalypse and a summer camp.', 'https://image.tmdb.org/t/p/w500/yCkPLQ10qKIUgRBXmQVVMF1h96d.jpg', 2011),
  ('Rick and Morty', 'show', 'Follows a sociopathic genius scientist who drags his inherently timid grandson on adventures across the universe.', 'Follows a sociopathic genius scientist who drags his inherently timid grandson on adventures across the universe.', 'https://image.tmdb.org/t/p/w500/owhkU6KRqdXoUQpjV8uyZGPtX58.jpg', 2013),
  ('Family Guy', 'show', 'Sick, twisted, politically incorrect and Freakin'' Sweet animated series featuring the adventures of the dysfunctional Griffin family....', 'Sick, twisted, politically incorrect and Freakin'' Sweet animated series featuring the adventures of the dysfunctional Griffin family. Bumbling Peter and long-suffering Lois have three kids. Stewie (a brilliant but sadistic baby bent on killing his mother and taking over the world), Meg (the oldest, and is the most unpopular girl in town) and Chris (the middle kid, he''s not very bright but has a passion for movies). The final member of the family is Brian - a talking dog and much more than a pet, he keeps Stewie in check whilst sipping Martinis and sorting through his own life issues.', 'https://image.tmdb.org/t/p/w500/3PFsEuAiyLkWsP4GG6dIV37Q6gu.jpg', 1999),
  ('Doctor Who', 'show', 'The Doctor is a Time Lord: a 900 year old alien with 2 hearts, part of a gifted civilization who mastered time travel. The Doctor saves...', 'The Doctor is a Time Lord: a 900 year old alien with 2 hearts, part of a gifted civilization who mastered time travel. The Doctor saves planets for a living—more of a hobby actually, and the Doctor''s very, very good at it.', 'https://image.tmdb.org/t/p/w500/lHfmc6d8pOVFrD0eOKPiDbjeucG.jpg', 2005),
  ('The Office', 'show', 'The everyday lives of office employees in the Scranton, Pennsylvania branch of the fictional Dunder Mifflin Paper Company.', 'The everyday lives of office employees in the Scranton, Pennsylvania branch of the fictional Dunder Mifflin Paper Company.', 'https://image.tmdb.org/t/p/w500/7DJKHzAi83BmQrWLrYYOqcoKfhR.jpg', 2005),
  ('The Mentalist', 'show', 'Patrick Jane, a former celebrity psychic medium, uses his razor sharp skills of observation and expertise at "reading" people to solve...', 'Patrick Jane, a former celebrity psychic medium, uses his razor sharp skills of observation and expertise at "reading" people to solve serious crimes with the California Bureau of Investigation.', 'https://image.tmdb.org/t/p/w500/acYXu4KaDj1NIkMgObnhe4C4a0T.jpg', 2008),
  ('Smallville', 'show', 'The origins of the world’s greatest hero–from Krypton refugee Kal-el’s arrival on Earth through his tumultuous teen years to Clark...', 'The origins of the world’s greatest hero–from Krypton refugee Kal-el’s arrival on Earth through his tumultuous teen years to Clark Kent’s final steps toward embracing his destiny as the Man of Steel.', 'https://image.tmdb.org/t/p/w500/pUhJGETy2sec4vEkiqJ9eGeIywc.jpg', 2001),
  ('The Rookie', 'show', 'Starting over isn''t easy, especially for small-town guy John Nolan who, after a life-altering incident, is pursuing his dream of being...', 'Starting over isn''t easy, especially for small-town guy John Nolan who, after a life-altering incident, is pursuing his dream of being an LAPD officer. As the force''s oldest rookie, he''s met with skepticism from some higher-ups who see him as just a walking midlife crisis.', 'https://image.tmdb.org/t/p/w500/70kTz0OmjjZe7zHvIDrq2iKW7PJ.jpg', 2018);

insert into public.title_genres (title_id, genre_id)
select t.id, g.id from public.titles t join public.genres g on (t.type, t.name, g.name) in (
  ('movie', 'Spider-Man: Brand New Day', 'Action'),
  ('movie', 'Spider-Man: Brand New Day', 'Sci-Fi'),
  ('movie', 'Runner', 'Action'),
  ('movie', 'Runner', 'Comedy'),
  ('movie', 'Animals', 'Drama'),
  ('movie', 'Animals', 'Thriller'),
  ('movie', 'Insidious: Out of the Further', 'Horror'),
  ('movie', 'Insidious: Out of the Further', 'Thriller'),
  ('movie', 'Corpse Bride', 'Romance'),
  ('movie', 'The Odyssey', 'Action'),
  ('movie', 'Toy Story 5', 'Comedy'),
  ('movie', 'Interstellar', 'Drama'),
  ('movie', 'Interstellar', 'Sci-Fi'),
  ('movie', 'Resident Evil', 'Horror'),
  ('movie', 'Resident Evil', 'Sci-Fi'),
  ('movie', 'The Love Hypothesis', 'Comedy'),
  ('movie', 'The Love Hypothesis', 'Romance'),
  ('movie', 'Fall 2: Deadpoint', 'Thriller'),
  ('movie', 'Clue', 'Comedy'),
  ('movie', 'Top Gun: Maverick', 'Action'),
  ('movie', 'Top Gun: Maverick', 'Drama'),
  ('movie', 'Resident Evil: Welcome to Raccoon City', 'Action'),
  ('movie', 'Resident Evil: Welcome to Raccoon City', 'Horror'),
  ('movie', 'Resident Evil: Welcome to Raccoon City', 'Sci-Fi'),
  ('movie', 'Titanic', 'Drama'),
  ('movie', 'Titanic', 'Romance'),
  ('movie', 'The End of Oak Street', 'Sci-Fi'),
  ('movie', 'The End of Oak Street', 'Thriller'),
  ('movie', 'Coyote vs. Acme', 'Comedy'),
  ('movie', 'Oppenheimer', 'Drama'),
  ('movie', 'Obsession', 'Horror'),
  ('movie', 'Obsession', 'Thriller'),
  ('movie', 'Wicked: For Good', 'Romance'),
  ('show', 'Torchwood', 'Action'),
  ('show', 'Torchwood', 'Drama'),
  ('show', 'Torchwood', 'Sci-Fi'),
  ('show', 'South Park', 'Comedy'),
  ('show', 'Breaking Bad', 'Drama'),
  ('show', 'Breaking Bad', 'Thriller'),
  ('show', 'Reacher', 'Action'),
  ('show', 'Reacher', 'Thriller'),
  ('show', 'The Bear', 'Comedy'),
  ('show', 'The Bear', 'Drama'),
  ('show', 'Law & Order', 'Drama'),
  ('show', 'Law & Order', 'Thriller'),
  ('show', 'Supernatural', 'Drama'),
  ('show', 'Supernatural', 'Sci-Fi'),
  ('show', 'Supernatural', 'Thriller'),
  ('show', 'NCIS', 'Action'),
  ('show', 'NCIS', 'Drama'),
  ('show', 'NCIS', 'Thriller'),
  ('show', 'The Simpsons', 'Comedy'),
  ('show', 'Game of Thrones', 'Action'),
  ('show', 'Game of Thrones', 'Drama'),
  ('show', 'Game of Thrones', 'Sci-Fi'),
  ('show', 'Law & Order: Special Victims Unit', 'Drama'),
  ('show', 'Law & Order: Special Victims Unit', 'Thriller'),
  ('show', 'The Daily Show', 'Comedy'),
  ('show', 'American Horror Story', 'Drama'),
  ('show', 'American Horror Story', 'Sci-Fi'),
  ('show', 'American Horror Story', 'Thriller'),
  ('show', 'Rick and Morty', 'Action'),
  ('show', 'Rick and Morty', 'Comedy'),
  ('show', 'Rick and Morty', 'Sci-Fi'),
  ('show', 'Family Guy', 'Comedy'),
  ('show', 'Doctor Who', 'Action'),
  ('show', 'Doctor Who', 'Drama'),
  ('show', 'Doctor Who', 'Sci-Fi'),
  ('show', 'The Office', 'Comedy'),
  ('show', 'The Mentalist', 'Drama'),
  ('show', 'The Mentalist', 'Thriller'),
  ('show', 'Smallville', 'Action'),
  ('show', 'Smallville', 'Drama'),
  ('show', 'Smallville', 'Sci-Fi'),
  ('show', 'The Rookie', 'Comedy'),
  ('show', 'The Rookie', 'Drama'),
  ('show', 'The Rookie', 'Thriller')
);

-- Season 1 episodes for every show, from TMDB (fetched by the tmdb-season edge function).
-- Matched to titles by NAME. Summaries are trimmed to 140 characters.
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Everything Changes', 'WPC Gwen Cooper is at the scene of a brutal murder, when the "special ops," known only as Torchwood, arrive. After witnessing the group...', 52, '2006-10-22'::date),
  (2, 'Day One', 'It''s Gwen''s first day on the job, and it''s not going very well. After accidentally releasing a mysterious gas from a comet that landed,...', 48, '2006-10-22'::date),
  (3, 'Ghost Machine', 'Whilst chasing a man, Gwen retrieves an unusual machine that allows the user to see back into the past. It is considered dangerous, and...', 49, '2006-10-29'::date),
  (4, 'Cyberwoman', 'A Ianto themed episode Ianto Jones hides a very big secret at Torchwood - his half-converted girlfriend from the Canary Wharf Battle -...', 50, '2006-11-05'::date),
  (5, 'Small Worlds', 'Jack catches up with a very old friend of his, who is investigating fairy sightings in the local wood. After having visited her,...', 47, '2006-11-12'::date),
  (6, 'Countrycide', 'Whilst investigating a group of unexplainable deaths in a village, the Torchwood team are separated. Discovering further, Jack, Gwen and...', 47, '2006-11-19'::date),
  (7, 'Greeks Bearing Gifts', 'A Toshiko themed episode Tosh meets an unusual woman, Mary, at a bar, who gives her a strange pendant. She is upset, yet amazed by what...', 50, '2006-11-26'::date),
  (8, 'They Keep Killing Suzie', 'A Suzie themed episode Using the Resurrection Gauntlet that former Torchwood member Suzie Costello originally had, the team are able to...', 53, '2006-12-03'::date),
  (9, 'Random Shoes', 'Eugene Jones wakes up, finding himself lying on the middle of a road. He then discovers that he has been the victim of a hit-and-run...', 50, '2006-12-10'::date),
  (10, 'Out of Time', 'Three passengers from 1953 arrive in modern day Cardiff, when their plane flies through the Rift. With no means of travelling back, each...', 50, '2006-12-17'::date),
  (11, 'Combat', 'An Owen themed episode Weevils are appearing all over the streets of Cardiff, and then disappearing again - but not by alien forces....', 48, '2006-12-24'::date),
  (12, 'Captain Jack Harkness', 'A Jack themed episode Whilst investigating an old, derelict dance hall, Jack and Tosh are transported back to the 1940s, during the...', 49, '2007-01-01'::date),
  (13, 'End of Days', 'With the Rift having been opened, people and objects throughout time are falling through it, and being spread across the world. "The...', 47, '2007-01-01'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Torchwood';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Cartman Gets an Anal Probe', 'While the boys are waiting for the school bus, Cartman explains the odd nightmare he had the previous night involving alien visitors...', 23, '1997-08-13'::date),
  (2, 'Volcano', 'The boys get together with Stan''s Uncle Jimbo and Jimbo''s war-buddy Ned for a hunting trip in the nearby mountains. After Cartman''s mom...', 23, '1997-08-20'::date),
  (3, 'Weight Gain 4000', 'Mr. Garrison starts the day off with a special announcement; one of South Park''s own has won a national essay contest. Everyone is...', 23, '1997-08-27'::date),
  (4, 'Big Gay Al''s Big Gay Boat Ride', 'Stan''s got a new dog named Sparky. Stan proclaims his pet to be the toughest dog on the mountain. Though while Stan thinks his dog is...', 23, '1997-09-03'::date),
  (5, 'An Elephant Makes Love to a Pig', 'Stan notices a new addition in their bus stop crew, an elephant standing alongside Kyle. At school, class lessons for the day involve...', 23, '1997-09-10'::date),
  (6, 'Death', '"Happy Birthday" to Stan''s Grandpa Marsh who just turned 102. How does the wizened Mr. Marsh feel about his birthday? He sums it up in...', 23, '1997-09-17'::date),
  (7, 'Pinkeye', 'The first Halloween episode starts off with the failure of the Mir Space Station, which crashes right on Kenny. An ambulance comes and...', 23, '1997-10-29'::date),
  (8, 'Starvin'' Marvin', 'The four boys are at Cartman''s house watching the "Terrance & Philip Thanksgiving Special" on television. During a break from the show,...', 23, '1997-11-19'::date),
  (9, 'Mr. Hankey, the Christmas Poo', 'South Park Elementary is on stage rehearsing for the schools play. Kyle begins to sing a song about Mr. Hankey, the Christmas Poo. Of...', 23, '1997-12-17'::date),
  (10, 'Damien', 'Eric is handing out invitations to his birthday party at school. Mr. Garrison informs them all that there is a new student joining the...', 23, '1998-02-04'::date),
  (11, 'Tom''s Rhinoplasty', 'Mr. Garrison deserts the class for a visit to Tom''s Rhinoplasty. All the boys compete for the attention of their beautiful substitute...', 23, '1998-02-11'::date),
  (12, 'Mecha-Streisand', 'The boys meet up with Barbara Streisand who wants to take over the world with Kyle''s discovery at an archaeological dig. Leonard Maltin,...', 23, '1998-02-18'::date),
  (13, 'Cartman''s Mom Is a Dirty Slut', 'Cartman needs to find out who his father is but his mom is no help. Learning that his father could be one of the many people that his...', 23, '1998-02-25'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'South Park';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'When an unassuming high school chemistry teacher discovers he has a rare form of lung cancer, he decides to team up with a former...', 59, '2008-01-20'::date),
  (2, 'Cat''s in the Bag...', 'Walt and Jesse attempt to tie up loose ends. The desperate situation gets more complicated with the flip of a coin. Walt''s wife, Skyler,...', 49, '2008-01-27'::date),
  (3, '...And the Bag''s in the River', 'Walter fights with Jesse over his drug use, causing him to leave Walter alone with their captive, Krazy-8. Meanwhile, Hank has a scared...', 49, '2008-02-10'::date),
  (4, 'Cancer Man', 'Walter finally tells his family that he has been stricken with cancer. Meanwhile, the DEA believes Albuquerque has a new, big time...', 49, '2008-02-17'::date),
  (5, 'Gray Matter', 'Walter and Skyler attend a former colleague''s party. Jesse tries to free himself from the drugs, while Skyler organizes an intervention.', 49, '2008-02-24'::date),
  (6, 'Crazy Handful of Nothin''', 'The side effects of chemo begin to plague Walt. Meanwhile, the DEA rounds up suspected dealers.', 49, '2008-03-02'::date),
  (7, 'A No Rough Stuff Type Deal', 'Walter accepts his new identity as a drug dealer after a PTA meeting. Elsewhere, Jesse decides to put his aunt''s house on the market and...', 48, '2008-03-09'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Breaking Bad';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Welcome to Margrave', 'Reacher is wrongly accused of murder while visiting the small town of Margrave, GA.', 54, '2022-02-03'::date),
  (2, 'First Dance', 'When more victims are discovered, Reacher attempts to get answers but is set up. Roscoe receives a threatening message.', 53, '2022-02-03'::date),
  (3, 'Spoonful', 'Reacher and Finlay’s investigation into the missing Spivey leads them into a confrontation with Kliner Sr. Roscoe learns unsettling news...', 47, '2022-02-03'::date),
  (4, 'In a Tree', 'As the danger increases, Reacher and Roscoe grow closer and they make plans to meet with their contact from Homeland Security.', 46, '2022-02-03'::date),
  (5, 'No Apologies', 'As the mystery deepens, Reacher teams up with an old colleague and Finlay makes a shocking discovery.', 49, '2022-02-03'::date),
  (6, 'Papier', 'As the town is rocked by another murder, Reacher heads to New York and learns the truth about the illegal business in Margrave while...', 49, '2022-02-03'::date),
  (7, 'Reacher Said Nothing', 'Reacher springs a trap and then gets trapped himself.', 42, '2022-02-03'::date),
  (8, 'Pie', 'Reacher leads a rescue mission at the warehouse that ends in a showdown.', 52, '2022-02-03'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Reacher';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'System', 'Carmy attempts to retrain the employees of The Original Beef of Chicagoland, but is faced with resistance; in need of back-up, he brings...', 28, '2022-06-23'::date),
  (2, 'Hands', 'A surprise health inspection reveals the cracks in the restaurant''s foundation. Carmy goes head-to-head with Richie.', 32, '2022-06-23'::date),
  (3, 'Brigade', 'Carmy attends Al-Anon. Sydney struggles to gain the respect of the staff.', 30, '2022-06-23'::date),
  (4, 'Dogs', 'Carmy and Richie cater a kid''s birthday party. Tina and Sydney work together while Marcus makes donuts.', 31, '2022-06-23'::date),
  (5, 'Sheridan', 'Things go wrong in the kitchen. Sydney finds solutions.', 26, '2022-06-23'::date),
  (6, 'Ceres', 'Richie notices the neighborhood is changing. Sugar and Carmy clean up the office.', 31, '2022-06-23'::date),
  (7, 'Review', 'A bad day in the kitchen causes tensions to rise.', 21, '2022-06-23'::date),
  (8, 'Braciole', 'Things get out of control. Carmy is faced with a decision.', 48, '2022-06-23'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'The Bear';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Prescription for Death', 'When a young woman dies during a hectic emergency room night shift, her father claims the hospital was negligent, and an investigation...', 48, '1990-09-13'::date),
  (2, 'Subterranean Homeboy Blues', 'The shooting of two black men by a white woman in a crowded subway initially appears to be a case of self-defense, but further...', 47, '1990-09-20'::date),
  (3, 'The Reaper''s Helper', 'The death of a man with AIDS appears to be the work of a serial killer who may have been motivated by mercy.', 46, '1990-10-04'::date),
  (4, 'Kiss the Girls and Make Them Die', 'Stone has difficulty prosecuting a privileged preppie with a history of abusing his girlfriends after one of them dies at his hands.', 47, '1990-10-11'::date),
  (5, 'Happily Ever After', 'Greevey and Logan have a hunch that robbery is a cover for the real motive in the death of a millionaire in a parking garage.', 48, '1990-10-23'::date),
  (6, 'Everybody''s Favorite Bagman', 'The mugging of a councilman leads the detectives to arrest a mobster, who in turn leads Stone and Robinette to corrupt city officials.', 45, '1990-10-30'::date),
  (7, 'By Hooker, By Crook', 'When Logan and Greevey investigate how a family man came to be found unconscious in Central Park, they uncover a very high-class call...', 47, '1990-11-13'::date),
  (8, 'Poison Ivy', 'The shooting of a black honors student stirs up racial tensions, especially after it becomes apparent that the cop responsible for the...', 47, '1990-11-20'::date),
  (9, 'Indifference', 'During the investigation into the death of a little girl in a respectable, middle-class family, Greevey and Logan uncover a myriad of...', 48, '1990-11-27'::date),
  (10, 'Prisoner of Love', 'A city arts commissioner and a socialite come under investigation when an artist noted for his sadomasochistic themes is found dead...', 46, '1990-12-04'::date),
  (11, 'Out of the Half-Light', 'Greevey and Logan''s investigation into a black teenager''s claim that she was raped by white policemen is hampered by a publicity hungry,...', 47, '1990-12-11'::date),
  (12, 'Life Choice', 'Stone faces pressure from the public and from Schiff as he prepares to prosecute the person accused of bombing an abortion clinic.', 48, '1991-01-08'::date),
  (13, 'A Death in the Family', 'Police start a citywide manhunt for a man suspected of killing a cop during a rooftop pursuit.', 46, '1991-01-15'::date),
  (14, 'The Violence of Summer', 'Greevey and Logan reopen an investigation to help Stone and Robinette build a stronger case against three boys accused of gang-raping a...', 47, '1991-02-05'::date),
  (15, 'The Torrents of Greed (1)', 'An assault on a candy storeowner leads Stone and Robinette to build a case against a powerful mafia don.', 48, '1991-02-12'::date),
  (16, 'The Torrents of Greed (2)', 'Stone tries to salvage his prosecution of the Masucci family when Beigel faces bribery charges and seems willing to turn against his...', 47, '1991-02-19'::date),
  (17, 'Mushrooms', 'The accidental shooting of two children by a 14-year-old hired killer leads to a drug dealer and a real estate agent.', 48, '1991-02-26'::date),
  (18, 'The Secret Sharers', 'Stone faces a flashy Texas lawyer and a hostile community as he tries to prosecute a young man accused of killing a drug dealer.', 48, '1991-03-12'::date),
  (19, 'The Serpent''s Tooth', 'Two brothers appear to be the logical suspects in the murder of their wealthy parents.', 48, '1991-03-19'::date),
  (20, 'The Troubles', 'Logan is forced to face his cultural biases when both a Cuban drug dealer and an Irish terrorist are suspected of killing a Lebanese...', 47, '1991-03-26'::date),
  (21, 'Sonata for Solo Organ', 'Stone and Robinette prosecute a surgeon and the wealthy father of a transplant patient for illegally obtaining a kidney.', 47, '1991-04-02'::date),
  (22, 'The Blue Wall', 'Cragen comes under suspicion when his mentor in the department is investigated for laundering drug money.', 48, '1991-06-09'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Law & Order';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'Two brothers, Sam and Dean Winchester, witness their mother''s paranormal death as children and grow up trained to fight by a distraught...', 46, '2005-09-13'::date),
  (2, 'Wendigo', 'Sam and Dean follow the coordinates left in their father''s journal and land in the middle of the woods where they investigate the...', 43, '2005-09-20'::date),
  (3, 'Dead in the Water', 'Sam and Dean investigate a series of mysterious drownings written off as suicides. They discover the spirit is an angry little boy with...', 44, '2005-09-27'::date),
  (4, 'Phantom Traveler', 'On TransNational flight 2485, a man possessed by the spirit of the Phantom Traveler causes the plane to crash, leaving only five...', 42, '2005-10-04'::date),
  (5, 'Bloody Mary', 'In suburban Nebraska, a group of partying high school teens jokingly dare their friend Charlie to look into the mirror and repeat...', 43, '2005-10-11'::date),
  (6, 'Skin', 'Sam and Dean come to the aid of Sam''s old college buddy after he is accused of a murder he swears he didn''t commit. The brothers...', 42, '2005-10-18'::date),
  (7, 'Hook Man', 'The infamous "Hook Man," a vengeful spirit who kills his victims with a shiny hook that serves as his hand, terrorizes a small college...', 41, '2005-10-25'::date),
  (8, 'Bugs', 'After a construction worker is killed by insects burrowing into his brain, Sam and Dean investigate the town''s history and find that the...', 44, '2005-11-08'::date),
  (9, 'Home', 'Sam is haunted by a vision of a woman trapped in his childhood house and convinces a reluctant Dean that they need to go home. Upon...', 43, '2005-11-15'::date),
  (10, 'Asylum', 'Sam and Dean investigate an abandoned sanitarium and discover that when the hospital was open, the patients held a revolt against the...', 43, '2005-11-22'::date),
  (11, 'Scarecrow', 'Sam and Dean finally make contact with their father, but he tells them to stop looking for him and sends them on another ghost-hunting...', 43, '2006-01-10'::date),
  (12, 'Faith', 'While battling a demon, Dean is electrocuted, resulting in permanent damage to his heart and leaving him with only a couple of months to...', 44, '2006-01-17'::date),
  (13, 'Route 666', 'Dean is contacted by his first love Cassie, an African-America girl, who asks him to come to Mississippi to investigate a string of...', 41, '2006-01-31'::date),
  (14, 'Nightmare', 'Sam has a premonition in which a man is killed, but the murder is made to look like a suicide. Sam convinces Dean that they must...', 43, '2006-02-07'::date),
  (15, 'The Benders', 'Sam and Dean head to Minnesota where a young boy witnesses a man vanish into thin air. Upon searching for clues, Sam is abducted by what...', 43, '2006-02-14'::date),
  (16, 'Shadow', 'Sam has a reunion with a girl he once met, Meg, but it turns out that she is using the brothers to lure their father John to his doom.', 42, '2006-02-28'::date),
  (17, 'Hell House', 'Sam and Dean investigate the case of a maniacal ghost inhabiting a long abandoned Texas farmhouse known as "Hell House." They believe...', 41, '2006-03-30'::date),
  (18, 'Something Wicked', 'Sam and Dean battle a Shtriga, a witch that sneaks into childrens'' bedrooms and sucks the lives out of them. Dean must relive his...', 42, '2006-04-06'::date),
  (19, 'Provenance', 'The Winchesters must deal with a dangerous spirit bound to an old family portrait that brings misfortune and death to anyone who buys it.', 44, '2006-04-13'::date),
  (20, 'Dead Man''s Blood', 'To obtain a mystic gun capable of destroying the demon that killed their mother, Sam and Dean must team up with their father John and...', 42, '2006-04-20'::date),
  (21, 'Salvation', 'John has realized where the demon will strike next and the Winchesters head there to stop the next killing. But Meg begins killing...', 41, '2006-04-27'::date),
  (22, 'Devil''s Trap', 'When Meg boasts that John is her prisoner, the boys visit a friend of their father''s to get information about demonic possessions and...', 43, '2006-05-04'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Supernatural';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Yankee White', 'While on Air Force One, a Navy commanding officer dies. Agents from the Navy NCIS decide to take the investigation into their own hands...', 45, '2003-09-23'::date),
  (2, 'Hung Out to Dry', 'During a training exercise, a Marine''s parachute fails to open and he crashes into a parked car. The NCIS team head to the scene and...', 44, '2003-09-30'::date),
  (3, 'Seadog', 'When a Navy commander''s body washes up on shore along with the bodies of two drug runners, Gibbs refuses to believe that the sailor who...', 43, '2003-10-07'::date),
  (4, 'The Immortals', 'The NCIS team investigate when a seaman''s body is found at the bottom of the sea in his dress whites, with a ceremonial sword. They...', 44, '2003-10-14'::date),
  (5, 'The Curse', 'A Navy Lieutenant who was reported missing nearly ten years ago has been found by a deer hunter. When the NCIS team arrive at the scene...', 43, '2003-10-28'::date),
  (6, 'High Seas', 'An NCIS agent who used to work under Gibbs asks for the team''s help investigating a case where sailors on an aircraft carrier are dying...', 44, '2003-11-04'::date),
  (7, 'Sub Rosa', 'A decomposed body is discovered in a tub of acid at a Naval base and Ducky and Abby learn that the victim was a submariner. However,...', 44, '2003-11-18'::date),
  (8, 'Minimum Security', 'The NCIS team head to Cuba to investigate a Navy translator''s connection to smuggling at a detention center after he suddenly dies at...', 44, '2003-11-25'::date),
  (9, 'Marine Down', 'After a Marine widow receives a call from her dead husband, the NCIS team take on the case and have to exhume the body to deduce whether...', 44, '2003-12-16'::date),
  (10, 'Left for Dead', 'After being buried alive, a woman comes out of the grave with amnesia and the only thing she remembers is that there is a bomb aboard a...', 44, '2004-01-06'::date),
  (11, 'Eye Spy', 'When a Navy commander, who was a technical advisor to a civilian contractor for a Navy weapon, is found dead on the beach, the NCIS team...', 44, '2004-01-13'::date),
  (12, 'My Other Left Foot', 'The NCIS team are called in when a severed leg bearing a Marine tattoo is found in a trash bin, leading them to a small town where a...', 44, '2004-02-03'::date),
  (13, 'One Shot, One Kill', 'The team investigate when a Marine recruitment officer is found shot to death by a sniper with a grudge, who leaves a white feather behind.', 42, '2004-02-10'::date),
  (14, 'The Good Samaritan', 'A Navy dentist stops near a parked car to help a stranded motorist who pulls out a gun. The team investigate a murder with the help from...', 44, '2004-02-17'::date),
  (15, 'Enigma', 'Gibbs risks his career when his former commanding officer is accused of stealing funds.', 44, '2004-02-24'::date),
  (16, 'Bête Noire', 'A terrorist holds Ducky, Gerald, and Kate hostage while NCIS investigate how exactly the terror organization member got a job at a Navy...', 44, '2004-03-02'::date),
  (17, 'The Truth Is Out There', 'When the body of a sailor is found after a party in an illegal night club, the team investigate a number of possible leads - including...', 43, '2004-03-16'::date),
  (18, 'UnSEALed', 'The team are looking for an ex-SEAL who escaped from prison in search of revenge. He is determined to find the real murderer of his wife.', 44, '2004-04-06'::date),
  (19, 'Dead Man Talking', 'An NCIS agent has been murdered while investigating a case and the team''s job is to find out what happened.', 45, '2004-04-27'::date),
  (20, 'Missing', 'A Marine goes missing after a date with a reporter. During the investigation, the team discover that three former members of his unit...', 45, '2004-05-04'::date),
  (21, 'Split Decision', 'When a body of a murdered Marine is found in the forest, the investigation leads to the local militia and a weapon deal gone wrong.', 44, '2004-05-11'::date),
  (22, 'A Weak Link', 'Gibbs'' team investigate the death of a SEAL during a training exercise, and come to suspect that it wasn''t an accident, but a murder.', 43, '2004-05-18'::date),
  (23, 'Reveille', 'The terrorist from Bête Noire returns with a plan to attack the President. Gibbs and his team follow the clues to reveal his identity...', 44, '2004-05-25'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'NCIS';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Simpsons Roasting on an Open Fire', 'Homer''s Christmas bonus is canceled and the rainy-day funds are needed to pay for Bart''s tattoo removal.', 24, '1989-12-17'::date),
  (2, 'Bart the Genius', 'Bart''s labeled a genius and sent to a school for the gifted.', 24, '1990-01-14'::date),
  (3, 'Homer''s Odyssey', 'After being fired from the nuclear power plant for negligence, Homer becomes a safety activist.', 24, '1990-01-21'::date),
  (4, 'There''s No Disgrace Like Home', 'After seeing families being nice to each other at a company picnic, Homer orders the Simpsons to a family therapist.', 23, '1990-01-28'::date),
  (5, 'Bart the General', 'Terrorized by the school bully, Bart seeks counsel from Grandpa Simpson, who takes him to a warfare expert for basic training.', 23, '1990-02-04'::date),
  (6, 'Moaning Lisa', 'The meaning of life and second grade have Lisa playing the blues solo, until she jams with a kindred spirit; Homer seeks tutelage to...', 24, '1990-02-11'::date),
  (7, 'The Call of the Simpsons', 'The Simpsons put the wild back in the wilderness when their RV goes over a cliff and Homer and Bart go for help, get lost and lose their...', 24, '1990-02-18'::date),
  (8, 'The Telltale Head', 'Bart pulls a stunt that shocks the entire town, including the new friends he was trying to impress.', 23, '1990-02-25'::date),
  (9, 'Life on the Fast Lane', 'Homer''s bowling-ball gift "for Marge" prompts her to take up the sport, and maybe also a handsome instructor who offers to teach her...', 24, '1990-03-18'::date),
  (10, 'Homer''s Night Out', 'Shutterbug Bart captures Homer with a sexy entertainer at a bachelor party.', 24, '1990-03-25'::date),
  (11, 'The Crepes of Wrath', 'A little story about how Bart saves France after blowing up Principal Skinner''s mom with a cherry bomb.', 24, '1990-04-15'::date),
  (12, 'Krusty Gets Busted', 'Bart''s TV hero Krusty the Clown is arrested for a convenience-store robbery, and witness Homer must testify against the clown.', 24, '1990-04-29'::date),
  (13, 'Some Enchanted Evening', 'Homer takes Marge out for a romantic night, leaving the kids with a sitter, who''s profiled on "America''s Most Armed and Dangerous."', 23, '1990-05-13'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'The Simpsons';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Winter Is Coming', 'Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon''s place....', 62, '2011-04-17'::date),
  (2, 'The Kingsroad', 'While Bran recovers from his fall, Ned takes only his daughters to Kings Landing. Jon Snow goes with his uncle Benjen to The Wall....', 56, '2011-04-24'::date),
  (3, 'Lord Snow', 'Lord Stark and his daughters arrive at King''s Landing to discover the intrigues of the king''s realm.', 58, '2011-05-01'::date),
  (4, 'Cripples, Bastards, and Broken Things', 'Eddard investigates Jon Arryn''s murder. Jon befriends Samwell Tarly, a coward who has come to join the Night''s Watch.', 56, '2011-05-08'::date),
  (5, 'The Wolf and the Lion', 'Catelyn has captured Tyrion and plans to bring him to her sister, Lysa Arryn, at The Vale, to be tried for his, supposed, crimes against...', 55, '2011-05-15'::date),
  (6, 'A Golden Crown', 'While recovering from his battle with Jamie, Eddard is forced to run the kingdom while Robert goes hunting. Tyrion demands a trial by...', 53, '2011-05-22'::date),
  (7, 'You Win or You Die', 'Robert has been injured while hunting and is dying. Jon and the others finally take their vows to the Night''s Watch. A man, sent by...', 58, '2011-05-29'::date),
  (8, 'The Pointy End', 'Eddard and his men are betrayed and captured by the Lannisters. When word reaches Robb, he plans to go to war to rescue them. The White...', 59, '2011-06-05'::date),
  (9, 'Baelor', 'Robb goes to war against the Lannisters. Jon finds himself struggling on deciding if his place is with Robb or the Night''s Watch. Drogo...', 57, '2011-06-12'::date),
  (10, 'Fire and Blood', 'With Ned dead, Robb vows to get revenge on the Lannisters. Jon must officially decide if his place is with Robb or the Night''s Watch....', 53, '2011-06-19'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Game of Thrones';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Payback', 'Detectives Stabler and Benson investigate the murder and dismemberment of a taxi driver; the team discovers that he may have been a...', 44, '1999-09-20'::date),
  (2, 'A Single Life', 'Benson and Stabler run into multiple dead ends while investigating the case of a woman who plummeted six stories to her death clad only...', 43, '1999-09-27'::date),
  (3, '...Or Just Look Like One', 'When a teen model is murdered and another is left for dead at a hospital emergency room, the team uncovers an insidious drug and sex...', 43, '1999-10-04'::date),
  (4, 'Hysteria', 'When a young African-American woman is found dead, she is initially believed to be a prostitute and the latest in a long line of...', 43, '1999-10-11'::date),
  (5, 'Wanderlust', 'When a world-traveling author is found dead in a room he rented from an alcoholic woman and her precocious 14-year-old daughter, the...', 44, '1999-10-18'::date),
  (6, 'Sophomore Jinx', 'A female student at an upper-class university is raped and murdered, and two of the college''s basketball stars are suspected. However,...', 43, '1999-10-25'::date),
  (7, 'Uncivilized', 'When a young boy is found raped and murdered in a field, suspicion leads detectives to a recently paroled child molester who lives in...', 44, '1999-11-15'::date),
  (8, 'Stalked', 'When an assistant district attorney is found raped and murdered in Central Park, the Special Victims Unit learn that she''d been stalked...', 44, '1999-11-22'::date),
  (9, 'Stocks & Bondage', 'An investment analyst is found hanged in her bedroom, and the Special Victims Unit explores her sordid sexual past to uncover her...', 44, '1999-11-29'::date),
  (10, 'Closure', 'When a woman is raped, she turns to the Special Victims Unit for help, but lack of evidence prevents them from apprehending the...', 44, '2000-01-07'::date),
  (11, 'Bad Blood', 'A moral coalition leader''s gay son is found murdered on the roof of his apartment building. Initially, Benson and Stabler investigate...', 44, '2000-01-14'::date),
  (12, 'Russian Love Poem', 'When a multi-millionaire is found strangled in his home, Benson and Stabler turn their suspicion to his long list of lovers, which...', 44, '2000-01-21'::date),
  (13, 'Disrobed', 'A judge who fought for the rights of abused women is found shot in his car under sordid circumstances, and the detectives uncover a case...', 44, '2000-02-04'::date),
  (14, 'Limitations', 'At the request of a victim, the police commissioner comes to Cragen with a special request -- close the five-year-old case of a serial...', 44, '2000-02-11'::date),
  (15, 'Entitled (I)', 'After a salesman is murdered, the detectives turn their attention to the youngest daughter of a well-known family with some deep...', 44, '2000-02-18'::date),
  (16, 'The Third Guy', 'An elderly woman is found tied up and sexually assaulted in her apartment, and suspicion is initially on the young men that had broken...', 44, '2000-02-25'::date),
  (17, 'Misleader', 'The pregnant daughter-in-law of a Christian College president is murdered in her hotel room, and the detectives discover that the man...', 44, '2000-03-31'::date),
  (18, 'Chat Room', 'When a teenage girl comes into the squad room to tell the detectives that she was raped by a man she met on the Internet, the...', 43, '2000-04-14'::date),
  (19, 'Contact', 'After seven young women in a six month time span are raped by a flash and dash assailant on the city subways, the brass calls in a...', 42, '2000-04-28'::date),
  (20, 'Remorse', 'A female television news reporter decides to go public with her story when she attacked and raped by two men, but the decision proves to...', 44, '2000-05-05'::date),
  (21, 'Nocturne', 'After a pharmacy turns over some disturbing photos of a young boy, a beloved neighborhood piano teacher is suspected of being a sexual...', 43, '2000-05-12'::date),
  (22, 'Slaves', 'A Romanian immigrant is being held as a psychological prisoner by her abusive employer and his wife, who is also traumatized by years of...', 44, '2000-05-21'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Law & Order: Special Victims Unit';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Premier Episode', NULL, NULL, '1996-07-22'::date),
  (2, 'David Cross & Bob Odenkirk', NULL, NULL, '1996-11-14'::date),
  (3, 'James Doohan', 'Tonight, James Doohan, otherwise known as Scotty from Star Trek.', NULL, '1996-11-20'::date),
  (4, 'Bruce Davison', NULL, NULL, '1996-12-09'::date),
  (5, 'Richard Lewis', NULL, NULL, '1996-12-11'::date),
  (6, 'Wes Craven', NULL, NULL, '1996-12-12'::date),
  (56, 'Tom Bergeron', NULL, 21, '1996-12-04'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'The Daily Show';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'A therapist and his family move across the country to escape their troubled past but quickly discover that their new home comes with its...', 52, '2011-10-05'::date),
  (2, 'Home Invasion', 'Vivien and Violet get themselves caught in a dangerous situation. Meanwhile, Ben goes back to Boston to fix a mistake that he made.', 43, '2011-10-12'::date),
  (3, 'Murder House', 'Vivien learns the horrific truth about the house''s first residents and Ben''s visitor causes him to further unravel about what really...', 43, '2011-10-19'::date),
  (4, 'Halloween (1)', 'The line between the living and the dead blurs on Halloween. Two of the house''s previous residents give the Harmons decorating advice.', 40, '2011-10-26'::date),
  (5, 'Halloween (2)', 'Tate comes face to face with his past, and Ben and Vivien are haunted by a new houseguest before Halloween night comes to an end.', 42, '2011-11-02'::date),
  (6, 'Piggy, Piggy', 'Constance enlists Violet''s assistance with Tate. Ben helps a new patient confront his fears.', 45, '2011-11-09'::date),
  (7, 'Open House', 'Moira persuades a buyer to make an offer while Constance and Larry work against her efforts.', 41, '2011-11-16'::date),
  (8, 'Rubber Man', 'The man in the rubber suit is revealed.', 44, '2011-11-23'::date),
  (9, 'Spooky Little Girl', 'One of history''s most famous murder victims pays the house a visit. Constance discovers more of Tate''s bad behavior.', 41, '2011-11-30'::date),
  (10, 'Smoldering Children', 'Violet learns about the rules of the house. The truth about Larry''s condition is explained. Constance is interrogated by the police.', 43, '2011-12-07'::date),
  (11, 'Birth', 'Vivien gives birth. Tate and Violet attempt to rid the house of some of its ghosts for good.', 42, '2011-12-14'::date),
  (12, 'Afterbirth', 'In the aftermath of family tragedy, Ben tries to take his child out of the Murder House. Meanwhile, Violet and Vivien accustom...', 53, '2011-12-21'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'American Horror Story';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'Rick moves in with his daughter''s family and establishes himself as a bad influence on his grandson, Morty.', 22, '2013-12-02'::date),
  (2, 'Lawnmower Dog', 'Rick and Morty try to incept Morty''s math teacher into giving Morty an ''A''. Meanwhile, Rick gives Jerry a device to train their dog,...', 22, '2013-12-09'::date),
  (3, 'Anatomy Park', 'Christmas day, Rick''s friend, Reuben, comes over for his annual medical checkup. Meanwhile Jerry learns his parents have a new friend.', 22, '2013-12-16'::date),
  (4, 'M. Night Shaym-Aliens!', 'Rick and Morty try to get to the bottom of a mystery in this M. Night Shyamalan style twistaroony of an episode!', 21, '2014-01-13'::date),
  (5, 'Meeseeks and Destroy', 'When Morty thinks Rick''s adventures are too dangerous, he challenges Rick to let him lead one instead.', 21, '2014-01-20'::date),
  (6, 'Rick Potion #9', 'Rick provides Morty with a love potion to get his dream girl, only for the serum to backfire and create a living Cronenberg nightmare.', 22, '2014-01-27'::date),
  (7, 'Raising Gazorpazorp', 'Morty convinces Rick to buy him a sexy robot. Later Rick and Summer spend some quality time together.', 22, '2014-03-10'::date),
  (8, 'Rixty Minutes', 'Rick hacks the cable box, but the family are distracted by another one of his inventions.', 23, '2014-03-17'::date),
  (9, 'Something Ricked This Way Comes', 'Rick battles the devil and upsets Summer. Meanwhile, Jerry and Morty hang out.', 23, '2014-03-24'::date),
  (10, 'Close Rick-Counters of the Rick Kind', 'Rick and Morty have a falling out when Rick is approached by some familiar associates.', 23, '2014-04-07'::date),
  (11, 'Ricksy Business', 'Beth and Jerry go away on a trip, so Rick decides to throw a party.', 23, '2014-04-14'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Rick and Morty';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Death Has a Shadow', 'After Peter heavily drinks at a bachelor party, even though he told Lois he would not, he gets fired from his job at the Happy-go-Lucky...', 23, '1999-01-31'::date),
  (2, 'I Never Met the Dead Man', 'While teaching Meg to drive, Peter crashes into the town satellite dish, which knocks out the city''s cable. He promises Meg that if she...', 23, '1999-04-11'::date),
  (3, 'Chitty Chitty Death Bang', 'Peter Allows Meg to go to a party with her new friend. This angers Lois because its the same day as Stewie''s birthday. What Meg doesn''t...', 23, '1999-04-18'::date),
  (4, 'Mind Over Murder', 'At Chris'' soccer game, Peter gets into a fight with a woman, that he thought was a man, and punches her in the face. After being placed...', 23, '1999-04-25'::date),
  (5, 'A Hero Sits Next Door', 'When the Griffin Family gets new neighbors that move in next door, Lois quickly becomes friends with Bonnie, Meg soon becomes attracted...', 23, '1999-05-01'::date),
  (6, 'The Son Also Draws', 'Chris loses interest in being a youth scout, as he would rather pursue drawing and art instead. The Scout Master then kicks Chris out of...', 23, '1999-05-02'::date),
  (7, 'Brian: Portrait of a Dog', 'When a heat wave hits Quahog, Peter gets Brian to enter a dog show to win $500 so that the family can get a new air conditioner. When...', 23, '1999-05-15'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Family Guy';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Rose', 'Rose Tyler meets a mysterious stranger called the Doctor, and realises Earth is in danger.', 47, '2005-03-26'::date),
  (2, 'The End of the World', 'The Doctor takes Rose on her first voyage through time: to the year five billion, when the Sun is about to expand and swallow the Earth....', 47, '2005-04-02'::date),
  (3, 'The Unquiet Dead', 'Charles Dickens and the Doctor team up as corpses stalk the streets of Victorian Cardiff.', 47, '2005-04-09'::date),
  (4, 'Aliens of London (1)', 'Rose is taken home, but a spaceship crashes in the Thames and London is closed off... Enter the Slitheen!', 45, '2005-04-16'::date),
  (5, 'World War Three (2)', 'Time is running out for the Doctor as Downing Street announces mankind''s first Interplanetary War.', 43, '2005-04-23'::date),
  (6, 'Dalek', 'The Doctor is shattered and Earth is in danger as he and Rose discover the Time Lords'' deadliest enemy beneath Utah.', 48, '2005-04-30'::date),
  (7, 'The Long Game', 'Adam catches a glimpse of the wonders of travelling in the Tardis, as they head to a future, where Satellite 5 broadcasts to the entire...', 45, '2005-05-07'::date),
  (8, 'Father''s Day', 'Rose requests a trip back to the day her father, Pete Tyler, died. Reluctantly, the Doctor agrees, but he realises he has made a...', 43, '2005-05-14'::date),
  (9, 'The Empty Child (1)', 'After chasing an unexplained capsule through time, the TARDIS lands in London, during an air raid. Rose investigates when a small child...', 42, '2005-05-21'::date),
  (10, 'The Doctor Dances (2)', 'After narrowly escaping the gas mask monsters, The Doctor, Rose, and Captain Jack try to stop the mutated people from infecting other...', 43, '2005-05-28'::date),
  (11, 'Boom Town', 'The Doctor, Rose and Captain Jack stop off in present-day Cardiff to recharge the TARDIS on the Rift they formerly encountered in 1869....', 43, '2005-06-04'::date),
  (12, 'Bad Wolf (1)', 'In a seemingly futuristic world, the Doctor wakes up in the Big Brother house during an eviction, Rose wakes up on the Weakest Link with...', 43, '2005-06-11'::date),
  (13, 'The Parting of the Ways (2)', 'The fate of the Universe is hanging in the balance as the Dalek fleet begin their invasion of Earth. The Doctor must decide whether to...', 48, '2005-06-18'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Doctor Who';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'A documentary crew arrives at the offices of Dunder Mifflin to observe the employees and learn about modern management. Manager Michael...', 24, '2005-03-24'::date),
  (2, 'Diversity Day', 'A consultant arrives to teach the staff about tolerance and diversity but Michael insists on imparting his own knowledge. Meanwhile, Jim...', 22, '2005-03-29'::date),
  (3, 'Health Care', 'Michael doesn''t want to upset the staff so he gets Dwight to pass on news about the company''s reduced health provisions. Fed up with his...', 23, '2005-04-05'::date),
  (4, 'The Alliance', 'Michael arranges a morale-boosting birthday party for Meredith and is determined to come up with the funniest message in her card....', 22, '2005-04-12'::date),
  (5, 'Basketball', 'The office staff play a basketball game against the warehouse workers in which Jim shows off to impress Pam and upstage her fiancee who...', 23, '2005-04-19'::date),
  (6, 'Hot Girl', 'A woman who comes to the office to sell purses gets the male members of staff excited. She rejects Dwight''s advances, but Michael...', 23, '2005-04-26'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'The Office';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'CBI consultant Patrick Jane, Senior Agent Teresa Lisbon and her team investigate the double murder in Palm Springs of a pro golfer''s...', 45, '2008-09-23'::date),
  (2, 'Red Hair and Silver Tape', 'While Lisbon and her team investigate the murder of a young waitress in the Napa Valley, Jane goes behind Lisbon''s back to orchestrate...', 43, '2008-09-30'::date),
  (3, 'Red Tide', 'When a high school girl''s body washes up on the beach, Patrick Jane sets a mentalist trap in order to get her surfing friends to turn on...', 43, '2008-10-14'::date),
  (4, 'Ladies in Red', 'When the team learns that a wealthy investment banker found murdered inside his locked safe room was living a dual life and skimming...', 43, '2008-10-21'::date),
  (5, 'Redwood', 'When a girl is found covered in blood and holding the murder weapon that killed her best friend, she becomes an obvious suspect, though...', 44, '2008-10-28'::date),
  (6, 'Red Handed', 'While investigating the case of a murdered casino owner, Patrick Jane uses his mentalist skills to ultimately entrap the killer, and win...', 44, '2008-11-11'::date),
  (7, 'Seeing Red', 'Patrick Jane goes head-to-head with a "psychic" he suspects of murder. Intent on proving the so-called psychic is a fraud -- as well as...', 44, '2008-11-18'::date),
  (8, 'The Thin Red Line', 'While the police suspect a drug dealer on trial is behind the murders of the State''s witness in his case, as well as his girlfriend,...', 42, '2008-11-25'::date),
  (9, 'Flame Red', 'Patrick Jane suspects the only surviving member of a National Guard unit of murdering his friends - and goes undercover to prove it.', 44, '2008-12-02'::date),
  (10, 'Red Brick and Ivy', 'When a leading scientific researcher is killed by poisoning, Patrick Jane takes a personal interest in the case when he learns the prime...', 42, '2008-12-16'::date),
  (11, 'Red John''s Friends', 'Enticed by the promise from a convicted murder that he''ll reveal information about Red John upon his release, Patrick Jane becomes...', 44, '2009-01-06'::date),
  (12, 'Red Rum', 'Patrick Jane sets a mentalist trap to find out who is responsible for the murder of a high school boy who antagonized the local...', 42, '2009-01-13'::date),
  (13, 'Paint It Red', 'While it appears obvious that a business tycoon''s son-in-law was in on the robbery of a $50 million painting since his body is found...', 43, '2009-01-18'::date),
  (14, 'Crimson Casanova', 'With Patrick Jane''s help, Cho goes undercover as a sweet-talking ladies man with all the right moves in order to catch a pick-up artist...', 44, '2009-02-10'::date),
  (15, 'Scarlett Fever', 'As Jane and the team investigate the poisoning death of the "queen bee" in a country club, they discover that the community is full of...', 44, '2009-02-17'::date),
  (16, 'Bloodshot', 'Patrick Jane must rely on his other senses during the murder investigation of a financial advisor when he loses his sight as a result of...', 44, '2009-03-17'::date),
  (17, 'Carnelian Inc.', 'A story of greed and betrayal pits Patrick Jane against a group of financiers when the CBI investigates a series of murders at a...', 42, '2009-03-24'::date),
  (18, 'Russet Potatoes', 'Patrick Jane and the CBI team track down a mastermind who hypnotizes people into doing their bidding.', 43, '2009-03-31'::date),
  (19, 'A Dozen Red Roses', 'Patrick Jane and the team go to Hollywood when they investigate the murder of a movie producer.', 43, '2009-04-07'::date),
  (20, 'Red Sauce', 'Patrick Jane and the CBI team investigate the murder of a mobster who was in the witness protection program.', 43, '2009-04-28'::date),
  (21, 'Miss Red', 'Patrick Jane uses his mentalist skills to play suspects off each other in order to solve the case of a wealthy software company CEO...', 44, '2009-05-05'::date),
  (22, 'Blood Brothers', 'Patrick Jane must find a clever way to convince the troubled kids in a wilderness program to confide in him about what really happened...', 44, '2009-05-12'::date),
  (23, 'Red John''s Footsteps', 'Lisbon fears that the serial killer Red John is drawing Patrick Jane into a trap when the CBI team investigates the murder of a young...', 44, '2009-05-19'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'The Mentalist';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'The first episode tells the story of the meteor shower that hit Smallville and changed life in the Kansas town forever. Clark Kent meets...', 45, '2001-10-16'::date),
  (2, 'Metamorphosis', 'Clark must deal with Greg, a nerdish bug collector with a crush on Lana who gains the ability of various insects and uses them to lash...', 45, '2001-10-23'::date),
  (3, 'Hothead', 'An abusive and hot-tempered football coach gains the ability to control and project fire.', 44, '2001-10-30'::date),
  (4, 'X-Ray', 'Clark begins experiencing "vision problems" as his x-ray vision begins manifesting. Meanwhile a mysterious shapeshifter is going about...', 44, '2001-11-06'::date),
  (5, 'Cool', 'A jock named Sean gains the ability to absorb heat from everything and everyone around him, and begins preying on people to gain the...', 43, '2001-11-13'::date),
  (6, 'Hourglass', 'An old man uses green meteor rock to reverse the aging process, then gain vengeance on the children of the jury that put him away...', 44, '2001-11-20'::date),
  (7, 'Craving', 'A weight-obsessed teen dieting on kryptonite-infected vegetables gains her fondest dream...but must feed on the fat of others to...', 43, '2001-11-27'::date),
  (8, 'Jitters', 'An experiment at the Luthor fertilizer plant makes an old friend of the Kents literally shake and jitter, and he seeks vengeance against...', 41, '2001-12-11'::date),
  (9, 'Rogue', 'Clark visits Metropolis, and does a secret good deed - a police detective witnesses this and decides to look into it.', 44, '2002-01-15'::date),
  (10, 'Shimmer', 'Lex and Victoria are victims of a suspected household poltergeist. As the disturbances become more violent, suspicion lands on Amy, the...', 44, '2002-01-29'::date),
  (11, 'Hug', 'A guy in charge of a rival fertilizer firm to LuthorCorp''s arrives in Metropolis. He is intent on buying up the Kent farm and using the...', 44, '2002-02-05'::date),
  (12, 'Leech', 'Clark''s powers are transferred into a classmate during a freak juxtaposition of meteor and storm. Clark must deal with being normal for...', 43, '2002-02-12'::date),
  (13, 'Kinetic', 'Whitney falls in with some former jocks who have kryptonite tattoos that give them the power to walk through walls. Meanwhile, Chloe is...', 43, '2002-02-26'::date),
  (14, 'Zero', 'A man from Lex''s past stalks him in conjunction with a mysterious death at Club Zero that Lex may have been responsible for. Meanwhile...', 41, '2002-03-12'::date),
  (15, 'Nicodemus', 'A flower that comes from a reopened "Level Three" of the fertilizer plant brings strange reactions from several people, including...', 44, '2002-03-19'::date),
  (16, 'Stray', 'A young runaway, Ryan, has the power to read minds and flees his abusive stepparents. The Kents take him in and Clark soon discovers the...', 43, '2002-04-16'::date),
  (17, 'Reaper', 'Tyler gains the power to destroy organic matter with a touch, and resolves to put the dying out of their misery...and Whitney''s father...', 44, '2002-04-23'::date),
  (18, 'Drone', 'Clark gets into a class election and one of his opponents is a krypto-mutant who can control bees. Meanwhile a reporter from Metropolis...', 42, '2002-04-30'::date),
  (19, 'Crush', 'Former Smallville High cartoonist Justin returns to Smallville after he loses the use of his hands in a hit and run accident. Meanwhile,...', 43, '2002-05-07'::date),
  (20, 'Obscura', 'After an explosion Lana finds herself getting visions of a serial killer...and his next target is Chloe. Meanwhile Lex and Roger look...', 43, '2002-05-14'::date),
  (21, 'Tempest', 'Lex is hit with a surprise by his father. Clark prepares for his date with Chloe, but Mother Nature has other plans.', 43, '2002-05-21'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'Smallville';
insert into public.episodes (title_id, season, episode_number, name, overview, runtime_minutes, air_date)
select t.id, 1, v.n, v.name, v.ov, v.rt, v.ad from public.titles t,
(values
  (1, 'Pilot', 'Starting over isn''t easy, especially for small-town guy John Nolan who, after a life-altering incident, is pursuing his dream of being a...', 43, '2018-10-16'::date),
  (2, 'Crash Course', 'Talia forces Nolan to confront his personal moral instincts in order to be a good cop after he encounters a kidnapping victim. Lucy is...', 43, '2018-10-23'::date),
  (3, 'The Good, the Bad and the Ugly', 'After Nolan and Talia lose control of a crime scene, they begin to debate whether people are fundamentally good or bad and what that...', 43, '2018-10-30'::date),
  (4, 'The Switch', 'The rookies are temporarily paired with new training officers, and Nolan is paired with Lopez. When Nolan and Lopez track down an...', 43, '2018-11-13'::date),
  (5, 'The Roundup', 'Nolan, the rookies and their training officers get involved in a competition that pits them against each other. Chen notices Bradford is...', 41, '2018-11-20'::date),
  (6, 'The Hawke', 'Nolan and the team must help capture a cop and his former mentor from the academy after he becomes a fugitive following an assault....', 43, '2018-11-27'::date),
  (7, 'The Ride Along', 'Grey informs Nolan and Bishop that they are going to have a movie director as a ride-along during their patrol after a fun afternoon...', 42, '2018-12-04'::date),
  (8, 'Time of Death', 'Nolan and Bishop respond to a silent alarm call at a local convenience store where two men are attempting to rob the place. Bishop helps...', 42, '2018-12-11'::date),
  (9, 'Standoff', 'Officer Bradford’s wife, Isabel, is found shot but alive and he vows to track down the man responsible. Meanwhile, Officer Nolan must...', 43, '2019-01-08'::date),
  (10, 'Flesh and Blood', 'On Captain Andersen’s orders, Officer Nolan and Sergeant Grey are paired up for the day on patrol. Additionally, Nolan’s son and Grey’s...', 42, '2019-01-15'::date),
  (11, 'Redwood', 'An unscheduled visit by the vice president of the United States puts the station on high alert. The secret service tasks Officer Nolan...', 43, '2019-01-22'::date),
  (12, 'Heartbreak', 'The most dangerous day of the year – Valentine’s Day – has the team on high alert, and Officer Nolan invites everyone over for a party...', 43, '2019-02-12'::date),
  (13, 'Caught Stealing', 'The rookies become the prime suspects after it is discovered a large sum of money used in a drug bust has gone missing.', 43, '2019-02-19'::date),
  (14, 'Plain Clothes Day', 'The rookies are really put to the test when their training officers accompany them out of uniform for Plain Clothes Day, which forces...', 43, '2019-02-26'::date),
  (15, 'Manhunt', 'When a prison bus crashes, all units must respond as some inmates face severe injuries while others seek an opportunity to flee. In the...', 43, '2019-03-05'::date),
  (16, 'Greenlight', 'Officer Nolan gets a lesson in respect after his arrest of a gang member leads to a free-for-all on his life. Meanwhile, Officer Chen...', 43, '2019-03-19'::date),
  (17, 'The Shake Up', 'A massive earthquake rocks the city and throws everyone’s patrols and its citizens into chaos. Meanwhile, agent Russo recommends Officer...', 42, '2019-03-26'::date),
  (18, 'Homefront', 'When one of their colleagues is arrested by Internal Affairs for lying on the witness stand, it leads to the release of three felons...', 43, '2019-04-02'::date),
  (19, 'The Checklist', 'Sergeant Gray informs the rookies that they must track down a specific set of crimes in a 48-hour period in order to qualify for their...', 43, '2019-04-09'::date),
  (20, 'Free Fall', 'As the rookies prepare for a big exam to see who moves on to the next stage of training, Officer Nolan and Officer Bishop are called to...', 43, '2019-04-16'::date)
) as v(n, name, ov, rt, ad)
where t.type = 'show' and t.name = 'The Rookie';
