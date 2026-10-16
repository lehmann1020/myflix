-- Seed data: the 24 placeholder titles from front-end/src/data/catalog.js and their genres.
-- Generated from that file; titles and genres are matched by NAME (no hard-coded ids), so it is safe to re-read.
-- poster_url is the app's public path (the images live in front-end/public/posters/).

insert into public.titles (name, type, description, full_description, why_i_like_it, poster_url) values
  ('Iron Meridian', 'movie', 'A courier races across a collapsing orbital highway.', 'When a courier is handed a sealed case on the last shuttle out of a failing orbital ring, every faction on the station wants it. Over one sleepless night she has to cross twelve districts, three blockades and her own past to deliver it before the ring falls.', 'Relentless pacing and practical-feeling stunts. The ring-city worldbuilding is gorgeous.', '/posters/iron-meridian.jpg'),
  ('The Last Bridge', 'movie', 'One engineer, one bridge, and ninety minutes to stop a heist.', 'A retired bridge engineer realizes the "maintenance crew" on her old suspension bridge is really a heist team. With no phone signal and a storm rolling in, she has to stop them using only what she knows about the structure.', 'Clever use of setting; every obstacle is something the hero would really know.', '/posters/last-bridge.jpg'),
  ('Night Courier', 'show', 'A bike messenger gets pulled into a city-wide conspiracy.', 'Across three seasons, a night-shift bike messenger discovers that the packages she carries are connected. Each episode follows one delivery and the people on both ends.', 'Episodic structure with a slow-burn mystery underneath.', '/posters/night-courier.jpg'),
  ('Red Tide Run', 'movie', 'A salvage crew outruns a hurricane with stolen cargo.', 'Four salvage divers take one last job in the path of a hurricane. The cargo is not what the manifest says, and the storm is the least of their problems.', 'Big practical set pieces and a crew you actually root for.', '/posters/red-tide-run.jpg'),
  ('Office of Small Wonders', 'show', 'A dead-end office finds a portal in the supply closet.', 'The staff of a failing paper company discover the supply closet opens onto a different, tinier world each Tuesday. They handle it the way offices handle everything: badly, with a spreadsheet.', 'Absurd premise, warm characters, and a cold open that always lands.', '/posters/office-of-small-wonders.jpg'),
  ('Second Wind', 'movie', 'Two retirees accidentally enter a marathon.', 'A widowed baker and a grumpy retired coach sign up for the wrong race and decide to finish it out of spite. Somewhere around mile nine it turns into something else.', 'Funny, gentle and surprisingly moving by the final stretch.', '/posters/second-wind.jpg'),
  ('House Rules', 'show', 'Four roommates, one lease, and a rulebook that keeps growing.', 'A mismatched house of roommates governs itself by a rulebook that grows every time something goes wrong. Each episode is a new rule and the story behind it.', 'The rulebook gag pays off beautifully in the finale.', '/posters/house-rules.jpg'),
  ('The Understudy', 'movie', 'A stagehand must go on in a role she has never rehearsed.', 'Opening night, the lead collapses, and the stagehand who knows every line has ten minutes to get into costume. What follows is the most chaotic performance in theatre history.', 'Pure feel-good chaos; I rewatch it when I need a lift.', '/posters/the-understudy.jpg'),
  ('Salt and Ash', 'movie', 'A family reunites on the island where they grew up.', 'Three siblings return to a salt-harvesting island to scatter their father''s ashes and find their old grievances waiting on the dock. Over a long weekend, nobody leaves the same.', 'Quiet and patient; the ending stuck with me for days.', '/posters/salt-and-ash.jpg'),
  ('Paper Lanterns', 'show', 'Two strangers write letters through a decade of festivals.', 'Every year at the lantern festival, two strangers swap letters tied to the same lantern. A decade, six cities and a lot of missed connections later, they finally meet.', 'Beautifully shot, patient romance told in annual chapters.', '/posters/paper-lanterns.jpg'),
  ('The Long Winter', 'show', 'A town snowed in for weeks starts keeping secrets.', 'When the only road closes for the season, a mountain town turns inward. Someone is stealing from the food stores, and everyone has a reason to look away.', 'Claustrophobic and character-driven, with a villain you never see coming.', '/posters/the-long-winter.jpg'),
  ('Harbor Lights', 'movie', 'A ferry captain makes one final crossing.', 'On her last day before retirement, a ferry captain carries a boat full of strangers across the bay in worsening fog, and each passenger turns out to be connected to her.', 'A low-key gem. The ensemble is wonderful.', '/posters/harbor-lights.jpg'),
  ('Signal from Kepler', 'movie', 'An astronomer decodes a message that was meant for someone else.', 'A radio astronomer translates a transmission from a distant star and realizes the message is not addressed to Earth, it is a warning meant for a different recipient.', 'Smart, restrained sci-fi. The reveal reframes everything.', '/posters/signal-from-kepler.jpg'),
  ('Terraform Club', 'show', 'Hobbyists on Mars argue over how to green a crater.', 'A volunteer club of Martian settlers is tasked with greening one crater. Meetings run long, the budget is tiny and the moss is staging a coup.', 'Cosy sci-fi with real heart, and the moss subplot is incredible.', '/posters/terraform-club.jpg'),
  ('Echo Drift', 'show', 'A generation ship loses contact with its past.', 'Six generations into a voyage, the crew of a colony ship receives a message from Earth: turn back. Half the ship wants to, half would rather die than.', 'A big idea told through small human conflicts.', '/posters/echo-drift.jpg'),
  ('Quiet Orbit', 'movie', 'A lone astronaut hears someone else on the radio.', 'On a six-month solo mission, an astronaut starts hearing a second voice on a closed channel. Either the ship is haunted or she is not alone out here.', 'Atmospheric and great with the lights off.', '/posters/quiet-orbit.jpg'),
  ('Hollow Hill', 'show', 'A hiking trail that adds an extra mile every night.', 'A group of campers notices the trail back to the car gets a little longer each night. By day four, the woods are very quiet and very watching.', 'Creeping dread rather than jump scares. Genuinely unsettling.', '/posters/hollow-hill.jpg'),
  ('The Guest Room', 'movie', 'A rental property has one room that is never empty.', 'A new host discovers that one room in her short-term rental always has a guest, even when the booking calendar says otherwise. Her reviews keep getting stranger.', 'Clever, funny-scary premise with an excellent last shot.', '/posters/the-guest-room.jpg'),
  ('Static Lullaby', 'movie', 'A baby monitor picks up a station that does not exist.', 'A new parent hears a lullaby coming through the baby monitor on a frequency that should be empty. Tracing it leads somewhere much older than the house.', 'Sound design is the star.', '/posters/static-lullaby.jpg'),
  ('Letters to Lisbon', 'movie', 'A translator falls for the author she has never met.', 'A translator spends a year working on a novel and slowly falls for its reclusive author through the margins of the manuscript. When she finally travels to meet him, the truth is more complicated.', 'Gorgeous locations and a lovely, slow build.', '/posters/letters-to-lisbon.jpg'),
  ('Same Train, Different Day', 'show', 'Commuters keep missing each other on the 7:42.', 'Two commuters keep almost meeting on the same morning train, and the city, the schedule and their own nerves keep getting in the way.', 'Charming and low-stakes; perfect comfort viewing.', '/posters/same-train-different-day.jpg'),
  ('The Midsummer Ledger', 'movie', 'An accountant inherits a seaside inn and its charming rival.', 'An accountant inherits a failing seaside inn and discovers the neighboring inn is run by a rival who is far too charming to hate.', 'Predictable in the best way.', '/posters/midsummer-ledger.jpg'),
  ('Vanishing Point 9', 'show', 'A detective investigates people who step out of the frame.', 'People are disappearing from security footage mid-step. A burned-out detective follows the gaps in the video and discovers the city has a seam.', 'Moody noir with a satisfying puzzle.', '/posters/vanishing-point.jpg'),
  ('Cold Open', 'movie', 'A radio host realizes the caller knows where she lives.', 'During her late-night call-in show, a host realizes one caller is describing her own house in real time. The producers think it is a bit. She does not.', 'Tight, contained and a masterclass in tension.', '/posters/cold-open.jpg');

insert into public.title_genres (title_id, genre_id)
select t.id, g.id
from (values
  ('movie', 'Iron Meridian', 'Action'),
  ('movie', 'Iron Meridian', 'Sci-Fi'),
  ('movie', 'The Last Bridge', 'Action'),
  ('movie', 'The Last Bridge', 'Thriller'),
  ('show', 'Night Courier', 'Action'),
  ('show', 'Night Courier', 'Drama'),
  ('movie', 'Red Tide Run', 'Action'),
  ('show', 'Office of Small Wonders', 'Comedy'),
  ('movie', 'Second Wind', 'Comedy'),
  ('movie', 'Second Wind', 'Romance'),
  ('show', 'House Rules', 'Comedy'),
  ('show', 'House Rules', 'Drama'),
  ('movie', 'The Understudy', 'Comedy'),
  ('movie', 'Salt and Ash', 'Drama'),
  ('show', 'Paper Lanterns', 'Drama'),
  ('show', 'Paper Lanterns', 'Romance'),
  ('show', 'The Long Winter', 'Drama'),
  ('show', 'The Long Winter', 'Thriller'),
  ('movie', 'Harbor Lights', 'Drama'),
  ('movie', 'Signal from Kepler', 'Sci-Fi'),
  ('movie', 'Signal from Kepler', 'Thriller'),
  ('show', 'Terraform Club', 'Sci-Fi'),
  ('show', 'Terraform Club', 'Comedy'),
  ('show', 'Echo Drift', 'Sci-Fi'),
  ('show', 'Echo Drift', 'Drama'),
  ('movie', 'Quiet Orbit', 'Sci-Fi'),
  ('show', 'Hollow Hill', 'Horror'),
  ('show', 'Hollow Hill', 'Thriller'),
  ('movie', 'The Guest Room', 'Horror'),
  ('movie', 'Static Lullaby', 'Horror'),
  ('movie', 'Static Lullaby', 'Sci-Fi'),
  ('movie', 'Letters to Lisbon', 'Romance'),
  ('movie', 'Letters to Lisbon', 'Drama'),
  ('show', 'Same Train, Different Day', 'Romance'),
  ('show', 'Same Train, Different Day', 'Comedy'),
  ('movie', 'The Midsummer Ledger', 'Romance'),
  ('show', 'Vanishing Point 9', 'Thriller'),
  ('show', 'Vanishing Point 9', 'Sci-Fi'),
  ('movie', 'Cold Open', 'Thriller')
) as v(type, title_name, genre_name)
join public.titles t on t.type = v.type and t.name = v.title_name
join public.genres g on g.name = v.genre_name;

