at this flutter app i used fire base and omdbapi as a back end and now i will replace omdbapi with a new api called watchmode i will give you data about this api and you should tell me steps to replace the last api  with the new one api root url (https://api.watchmode.com/v1/) ID Mapping (Watchmode IDs for movies, tv shows and for people (actors, directors, etc) are universally unique and cannot collide with each other. So you don't have to worry that the ID for an actor can collide with the ID for a movie, or that an ID for a TV show can collide with a movie ID and so forth.

When you first integrate your application with the Watchmode API, you may want to import all of the Watchmode IDs for titles and people. To get a list of all Watchmode IDs, and their corresponding IMDB/TMDB ids, you can download the following files (updated daily):

https://api.watchmode.com/datasets/title_id_map.csv

https://api.watchmode.com/datasets/person_id_map.csv) Errors{(200 -- OK -- The request was successful.) , (400 -- Bad request -- Bad request) , (401 -- Unauthorized -- Your API key is invalid.) , (402 -- Over quota -- Over plan quota on this API Key.) , (404 -- Not found -- The resource does not exist.) , (429 -- Too Many Requests -- The rate limit was exceeded.) , (50X -- Internal Server Error --An error occurred with our API.) , -- Error Response

Example error response.

{"success":false,"statusCode":400,"statusMessage":"Please set a valid change type method."}


All errors are returned in the form of JSON with a type and optional message. }  Rate Limiting {You can make up to 120 requests per minute using your API key. How many requests you have remaining (X-RateLimit-Remaining), and how many seconds until your rate limit has reset (Retry-After) are returned in the HTTP headers. Higher rate limits available for enterprise customers. , (Check to see how many requests you have left:

$ curl -i 'https://api.watchmode.com/v1/status/?apiKey=YOUR_API_KEY'

HTTP/1.1 200 OK
Date: Mon, 01 Jul 2014 21:20:00 GMT
Status: 200 OK
X-RateLimit-Limit: 120
X-RateLimit-Remaining: 111
X-Account-Quota: 999999
X-Account-Quota-Used: 93
Retry-After: 19


You can make up to 120 requests per minute using your API key. How many requests you have remaining (X-RateLimit-Remaining), and how many seconds until your rate limit has reset (Retry-After) are returned in the HTTP headers. Higher rate limits available for enterprise customers.

Example rate limit error response.

HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 120
X-RateLimit-Remaining: 0
X-Account-Quota: 999999
X-Account-Quota-Used: 93
Retry-After: 19

Content-Type: application/json
{
"success": false,
"statusCode": 429,
"statusMessage": "The rate limit was exceeded."
}

) }   Configuration APIs ​{The following endpoints (sources, networks, genres, regions) are helpful for initially setting up your application with Watchmode and contain ID mappings of Watchmode values. Typically developers query these once to import the Watchmode numerical values for streaming sources, TV networks, and genres.  , (Sources

Example Request

/v1/sources/

curl -i 'https://api.watchmode.com/v1/sources/?apiKey=YOUR_API_KEY'

Example response

[
{
"id": 203,
"name": "Netflix",
"type": "sub",
"logo_100px": "https://cdn.watchmode.com/provider_logos/netflix_100px.png",
"ios_appstore_url": "http://itunes.apple.com/app/netflix/id363590051",
"android_playstore_url": "https://play.google.com/store/apps/details?id=com.netflix.mediaclient&amp;hl=en",
"android_scheme": "nflx",
"ios_scheme": "nflx",
"regions": ["US", "CA", "GB", "AU"]
},
{
"id": 157,
"name": "Hulu",
"type": "sub",
"logo_100px": "https://cdn.watchmode.com/provider_logos/hulu_100px.png",
"ios_appstore_url": "http://itunes.apple.com/app/hulu-plus/id376510438",
"android_playstore_url": "https://play.google.com/store/apps/details?id=com.hulu.plus",
"android_scheme": "hulu",
"ios_scheme": "hulu",
"regions": ["US"]
}
]


Return a listing of all streaming sources that Watchmode supports. Optionally filter by type of source (subscription, free, etc).) ,(Regions

Example Request

/v1/regions/

curl -i 'https://api.watchmode.com/v1/regions/?apiKey=YOUR_API_KEY'

Example response

[
{
"country": "US",
"name": "USA",
"flag": "https://cdn.watchmode.com/misc_images/icons/usFlag2.png",
"data_tier": 1,
"plan_enabled": true
},
{
"country": "CA",
"name": "Canada",
"flag": "https://cdn.watchmode.com/misc_images/icons/flagCA.png",
"data_tier": 1,
"plan_enabled": true
},
{
"country": "GB",
"name": "Great Britain",
"flag": "https://cdn.watchmode.com/misc_images/icons/flagGB.png",
"data_tier": 1,
"plan_enabled": true
},
{
"country": "AU",
"name": "Australia",
"flag": "https://cdn.watchmode.com/misc_images/icons/flagAU.png",
"data_tier": 1,
"plan_enabled": true
},
{
"country": "AR",
"name": "Argentina",
"flag": "https://cdn.watchmode.com/misc_images/icons/flagAR.png",
"data_tier": 2,
"plan_enabled": false
},
{
"country": "BE",
"name": "Belgium",
"flag": "https://cdn.watchmode.com/misc_images/icons/flagBE.png",
"data_tier": 2,
"plan_enabled": false
}
]


Return a listing of all regions (countries) that Watchmode currently supports.)  ( Networks

Example Request

/v1/networks/

curl -i 'https://api.watchmode.com/v1/networks/?apiKey=YOUR_API_KEY'

Example response

[
{ "id": 1, "name": "HBO", "origin_country": "US", "tmdb_id": 49 },
{ "id": 2, "name": "National Geographic", "origin_country": "US", "tmdb_id": 43 },
{ "id": 3, "name": "YouTube", "origin_country": null, "tmdb_id": 247 },
{ "id": 4, "name": "SBS", "origin_country": "KR", "tmdb_id": 156 },
{ "id": 5, "name": "DC Universe", "origin_country": "US", "tmdb_id": 2243 },
{ "id": 6, "name": "Viceland", "origin_country": "US", "tmdb_id": 1339 },
{ "id": 7, "name": "ABC", "origin_country": "US", "tmdb_id": 2 },
{ "id": 8, "name": "AMC", "origin_country": "US", "tmdb_id": 174 },
{ "id": 9, "name": "PBS", "origin_country": "US", "tmdb_id": 14 }
]

) , (Genres

Example Request

/v1/genres/

curl -i 'https://api.watchmode.com/v1/genres/?apiKey=YOUR_API_KEY'

Example response

[
{ "id": 4, "name": "Comedy", "tmdb_id": 35 },
{ "id": 6, "name": "Documentary", "tmdb_id": 99 },
{ "id": 33, "name": "Anime", "tmdb_id": null }
]

) ,( Search API

Example Request

/v1/search/

curl -i 'https://api.watchmode.com/v1/search/?apiKey=YOUR_API_KEY&search_field=name&search_value=Ed%20Wood'

Example response

{
"title_results": [
{
"id": 1114888,
"name": "Ed Wood",
"type": "movie",
"year": 1994,
"imdb_id": "tt0109707",
"tmdb_id": 522,
"tmdb_type": "movie"
}
],
"people_results": [
{
"id": 710125611,
"name": "Ed Wood",
"main_profession": "cinematographer",
"imdb_id": "nm7903892",
"tmdb_id": 2901757
}
]
}


Search for titles or people using an external ID (IMDB, TheMovieDB.org), or by name. Returns an array of results objects, that can either be a title or a person. Useful for getting the Watchmode IDs for titles and people. For example, you can set the parameters to search_value=Breaking%20Bad and search_field=name to get all of the titles named "Breaking bad", and then use the IDs returned in other endpoints such as /v1/title/

ParameterRequiredDescriptionsearch_fieldrequired ) ,(Autocomplete Search API

Example Request

/v1/autocomplete-search/

curl -i 'https://api.watchmode.com/v1/autocomplete-search/?apiKey=YOUR_API_KEY&search_value=Breaking%20bad&search_type=1'

Example response

{
"results": [
{
"name": "Breaking Bad",
"relevance": 445.23,
"type": "tv_series",
"id": 3173903,
"year": 2008,
"result_type": "title",
"tmdb_id": 1396,
"tmdb_type": "tv",
"image_url": "https://cdn.watchmode.com/posters/03173903_poster_w185.jpg"
},
{
"name": "El Camino: A Breaking Bad Movie",
"relevance": 169.83,
"type": "movie",
"id": 1586594,
"year": 2019,
"result_type": "title",
"tmdb_id": 559969,
"tmdb_type": "movie",
"image_url": "https://cdn.watchmode.com/posters/01586594_poster_w185.jpg"
},
{
"name": "No Half Measures: Creating the Final Season of Breaking Bad",
"relevance": 162.66,
"type": "movie",
"id": 1672293,
"year": 2013,
"result_type": "title",
"tmdb_id": 239459,
"tmdb_type": "movie",
"image_url": "https://cdn.watchmode.com/posters/01672293_poster_w185.jpg"
},
{
"name": "The Road to El Camino: Behind the Scenes of El Camino: A Breaking Bad Movie",
"relevance": 125.46,
"type": "movie",
"id": 539605,
"year": 2019,
"result_type": "title",
"tmdb_id": 934809,
"tmdb_type": "movie",
"image_url": "https://cdn.watchmode.com/posters/0539605_poster_w185.jpg"
},
{
"name": "Breaking Bad Wolf",
"relevance": 82.63,
"type": "tv_movie",
"id": 4146033,
"year": 2018,
"result_type": "title",
"tmdb_id": 635602,
"tmdb_type": "movie",
"image_url": "https://cdn.watchmode.com/posters/04146033_poster_w185.jpg"
}
]
}


Search for titles/and or people by name or a partial name. Useful for building an autocomplete search of titles and/or people. The results include the field result_type to indicate which type of result it is (title or person). For titles, the movie poster will be returned in image_url, for a person a headshot will be returned in image_url.

ParameterRequiredDescriptionsearch_valuerequiredstringThe phrase to search for, can be a full title or person name, or a partial phrase. For example searching for "The sha" will find the movie "The Shawshank Redemption".search_typeoptionalintSet this to 1 to include titles and people in results. Set this to 2 to include titles only. Set this to 3 to include movies only. Set this to 4 to include TV only. Set this to 5 to include people only. By default this is set to 1. )  } {Title Details API

Example Request

curl -i 'https://api.watchmode.com/v1/title/345534/details/?apiKey=YOUR_API_KEY&append_to_response=sources'

Example response (truncated)

{
"id": 3173903,
"title": "Breaking Bad",
"original_title": "Breaking Bad",
"plot_overview": "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
"type": "tv_series",
"runtime_minutes": 45,
"year": 2008,
"end_year": 2013,
"release_date": "2008-01-20",
"imdb_id": "tt0903747",
"tmdb_id": 1396,
"tmdb_type": "tv",
"genres": [7],
"genre_names": ["Drama"],
"user_rating": 9.2,
"critic_score": 85,
"us_rating": "TV-MA",
"poster": "https://cdn.watchmode.com/posters/03173903_poster_w185.jpg",
"backdrop": "https://cdn.watchmode.com/backdrops/03173903_bd_w780.jpg",
"original_language": "en",
"similar_titles": [
316213, 3109684, 335115, 3108093, 350168, 373995, 52048, 312149, 3131957,
3131293, 398260, 3110052
],
"networks": [8],
"network_names": ["AMC"],
"trailer": "https://www.youtube.com/watch?v=XZ8daibM3AE",
"trailer_thumbnail": "https://cdn.watchmode.com/video_thumbnails/536008_pthumbnail_320.jpg",
"relevance_percentile": 98.92,
"sources": [
{
"source_id": 203,
"name": "Netflix",
"type": "sub",
"region": "US",
"ios_url": "nflx://www.netflix.com/title/70143836",
"android_url": "nflx://www.netflix.com/Browse?q=action%3Dplay%26source%3Dmerchweb%26target_url%3Dhttp%3A%2F%2Fmovi.es%2FVoft6",
"web_url": "http://www.netflix.com/title/70143836",
"format": "4K",
"price": null,
"seasons": 5,
"episodes": 62
},
{
"source_id": 349,
"name": "iTunes",
"type": "buy",
"region": "US",
"ios_url": "com.apple.TVShows://product/Pilot,%20Season%201/271382034/tvSeason",
"android_url": null,
"web_url": "https://itunes.apple.com/us/tv-season/pilot/id271383858?i=271866344&amp;uo=4&amp;at=1000l3V2",
"format": "HD",
"price": 1.99,
"seasons": 5,
"episodes": 62
},
{
"source_id": 307,
"name": "VUDU",
"type": "buy",
"region": "US",
"ios_url": "vuduapp://play?contentId=207577",
"android_url": "vuduapp://207577",
"web_url": "https://www.vudu.com/content/movies/details/Breaking-Bad-Pilot/207577",
"format": "HD",
"price": 1.99,
"seasons": 5,
"episodes": 62
}
]
}


(Title Sources

Example Request

curl -i 'https://api.watchmode.com/v1/title/345534/sources/?apiKey=YOUR_API_KEY'

Example response

[
{
"source_id": 349,
"name": "iTunes",
"type": "buy",
"region": "GB",
"ios_url": "https://tv.apple.com/gb/episode/winter-is-coming/umc.cmc.11q7jp45c84lp6d16zdhum6ul?playableId=tvs.sbd.9001%3A477721657&amp;showId=umc.cmc.7htjb4sh74ynzxavta5boxuzq",
"android_url": null,
"web_url": "https://tv.apple.com/gb/episode/winter-is-coming/umc.cmc.11q7jp45c84lp6d16zdhum6ul?playableId=tvs.sbd.9001%3A477721657&amp;showId=umc.cmc.7htjb4sh74ynzxavta5boxuzq",
"format": "HD",
"price": 2.49,
"seasons": 8,
"episodes": 73
},
{
"source_id": 387,
"name": "HBO MAX",
"type": "sub",
"region": "US",
"ios_url": "hbomax://deeplink/eyJjb21ldElkIjoidXJuOmhibzplcGlzb2RlOkdWVTROWWd2UFFsRnZqU29KQWJtTCIsImdvVjJJZCI6InVybjpoYm86ZXBpc29kZTpHVlU0TllndlBRbEZ2alNvSkFibUwifQ==?action=open",
"android_url": "hbomax://urn:hbo:episode:GVU4NYgvPQlFvjSoJAbmL",
"web_url": "https://play.hbomax.com/episode/urn:hbo:episode:GVU4NYgvPQlFvjSoJAbmL",
"format": "HD",
"price": null,
"seasons": 8,
"episodes": 73
},
{
"source_id": 408,
"name": "Sky Go",
"type": "sub",
"region": "GB",
"ios_url": "skygo://vod/6700434",
"android_url": "skygo://vod/6700434",
"web_url": "https://www.sky.com/watch/sky-go/all?uuid=e8899cad-639a-482d-8bcd-731c447dfcc8&amp;videoId=6700434",
"format": "HD",
"price": null,
"seasons": 8,
"episodes": 73
},
{
"source_id": 442,
"name": "DirecTV On Demand",
"type": "sub",
"region": "US",
"ios_url": null,
"android_url": null,
"web_url": "https://www.directv.com/tv/Game-of-Thrones-SHNpWmVyR21jeHM9/Winter-Is-Coming-d2N0d09mMXFtdVFLU2lheTMvWDhLQT09",
"format": "HD",
"price": null,
"seasons": 8,
"episodes": 73
},
{
"source_id": 424,
"name": "Foxtel Now",
"type": "sub",
"region": "AU",
"ios_url": null,
"android_url": null,
"web_url": "https://www.foxtel.com.au/foxtelplay/build/package?execution=e1s1",
"format": "HD",
"price": null,
"seasons": 8,
"episodes": 64
},
{
"source_id": 423,
"name": "BINGE",
"type": "sub",
"region": "AU",
"ios_url": "https://binge.com.au/shows/show-game-of-thrones-memorable-characters!10203",
"android_url": null,
"web_url": "https://binge.com.au/shows/show-game-of-thrones-memorable-characters!10203",
"format": "HD",
"price": null,
"seasons": 8,
"episodes": 73
}
]


) , (Title Cast & Crew

Example Request

curl -i 'https://api.watchmode.com/v1/title/345534/cast-crew/?apiKey=YOUR_API_KEY'

Example response

[
{
"person_id": 673767,
"type": "Crew",
"full_name": "Miguel Sapochnik",
"headshot_url": "https://cdn.watchmode.com/profiles/07673767_profile_185.jpg",
"role": "Executive Producer",
"episode_count": 6,
"order": null
},
{
"person_id": 2528385,
"type": "Cast",
"full_name": "Kit Harington",
"headshot_url": "https://cdn.watchmode.com/profiles/072528385_profile_185.jpg",
"role": "Jon Snow",
"episode_count": 73,
"order": null
}
]


/v1/title/{title_id}/cast-crew/

Return all people associated with the title, the "cast" (actors), and "crew" (directors, writers, cinematographers, etc). For more details on a person, pass the person-id to the /person/ endpoint. Set &append_to_response=cast-crew to the title details endpoint above to get these results added to the title details response. )} {Person

Example Request

/v1/person/{person_id}

curl -i 'https://api.watchmode.com/v1/person/7110004?apiKey=YOUR_API_KEY'

Example response

{
"id": 7110004,
"full_name": "Brad Pitt",
"first_name": "Brad",
"last_name": "Pitt",
"tmdb_id": 287,
"imdb_id": "nm0000093",
"main_profession": "actor",
"secondary_profession": "producer",
"tertiary_profession": "soundtrack",
"date_of_birth": "1963-12-18",
"date_of_death": null,
"place_of_birth": "Shawnee, Oklahoma, USA",
"gender": "m",
"headshot_url": "https://cdn.watchmode.com/profiles/07110004_profile_185.jpg",
"known_for": [1132806, 1336708, 1183315, 1387087],
"relevance_percentile": 100
}


Return details on a specific person (actor, director, etc).} 
{Title Seasons
Example Request

curl -i 'https://api.watchmode.com/v1/title/345534/seasons/?apiKey=YOUR_API_KEY'
Example response

[
{
"id": 40809,
"poster_url": "https://cdn.watchmode.com/posters/0340809_season_poster_342.jpg",
"name": "Season 8",
"overview": "The Great War has come, the Wall has fallen and the Night King's army of the dead marches towards Westeros. The end is here, but who will take the Iron Throne?",
"number": 8,
"air_date": "2019-04-14",
"episode_count": 6
},
{
"id": 8,
"poster_url": "https://cdn.watchmode.com/posters/038_season_poster_342.jpg",
"name": "Season 7",
"overview": "The long winter is here. And with it comes a convergence of armies and attitudes that have been brewing for years.",
"number": 7,
"air_date": "2017-07-16",
"episode_count": 7
},
{
"id": 7,
"poster_url": "https://cdn.watchmode.com/posters/037_season_poster_342.jpg",
"name": "Season 6",
"overview": "Following the shocking developments at the conclusion of season five, survivors from all parts of Westeros and Essos regroup to press forward, inexorably, towards their uncertain individual fates. Familiar faces will forge new alliances to bolster their strategic chances at survival, while new characters will emerge to challenge the balance of power in the east, west, north and south.",
"number": 6,
"air_date": "2016-04-24",
"episode_count": 10
},
{
"id": 6,
"poster_url": "https://cdn.watchmode.com/posters/036_season_poster_342.jpg",
"name": "Season 5",
"overview": "The War of the Five Kings, once thought to be drawing to a close, is instead entering a new and more chaotic phase. Westeros is on the brink of collapse, and many are seizing what they can while the realm implodes, like a corpse making a feast for crows.",
"number": 5,
"air_date": "2015-04-12",
"episode_count": 10
},
{
"id": 5,
"poster_url": "https://cdn.watchmode.com/posters/035_season_poster_342.jpg",
"name": "Season 4",
"overview": "The War of the Five Kings is drawing to a close, but new intrigues and plots are in motion, and the surviving factions must contend with enemies not only outside their ranks, but within.",
"number": 4,
"air_date": "2014-04-06",
"episode_count": 10
},
{
"id": 4,
"poster_url": "https://cdn.watchmode.com/posters/034_season_poster_342.jpg",
"name": "Season 3",
"overview": "Duplicity and treachery...nobility and honor...conquest and triumph...and, of course, dragons. In Season 3, family and loyalty are the overarching themes as many critical storylines from the first two seasons come to a brutal head. Meanwhile, the Lannisters maintain their hold on King's Landing, though stirrings in the North threaten to alter the balance of power; Robb Stark, King of the North, faces a major calamity as he tries to build on his victories; a massive army of wildlings led by Mance Rayder march for the Wall; and Daenerys Targaryen--reunited with her dragons--attempts to raise an army in her quest for the Iron Throne.",
"number": 3,
"air_date": "2013-03-31",
"episode_count": 10
},
{
"id": 3,
"poster_url": "https://cdn.watchmode.com/posters/033_season_poster_342.jpg",
"name": "Season 2",
"overview": "The cold winds of winter are rising in Westeros...war is coming...and five kings continue their savage quest for control of the all-powerful Iron Throne. With winter fast approaching, the coveted Iron Throne is occupied by the cruel Joffrey, counseled by his conniving mother Cersei and uncle Tyrion. But the Lannister hold on the Throne is under assault on many fronts. Meanwhile, a new leader is rising among the wildings outside the Great Wall, adding new perils for Jon Snow and the order of the Night's Watch.",
"number": 2,
"air_date": "2012-04-01",
"episode_count": 10
},
{
"id": 2,
"poster_url": "https://cdn.watchmode.com/posters/032_season_poster_342.jpg",
"name": "Season 1",
"overview": "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.",
"number": 1,
"air_date": "2011-04-17",
"episode_count": 10
},
{
"id": 1,
"poster_url": "https://cdn.watchmode.com/posters/031_season_poster_342.jpg",
"name": "Specials",
"overview": null,
"number": null,
"air_date": "2010-12-05",
"episode_count": 65
}
]
/v1/title/{title_id}/seasons/

Return all of the seasons for a TV show or mini-series.} ,{Title Episodes
Example Request

curl -i 'https://api.watchmode.com/v1/title/345534/episodes/?apiKey=YOUR_API_KEY'
Example response (truncated)

[
{
"id": 6088251,
"name": "Winter Is Coming",
"episode_number": 1,
"season_number": 1,
"season_id": 2,
"tmdb_id": 63056,
"imdb_id": "tt1480055",
"thumbnail_url": "https://cdn.watchmode.com/episode_thumbnails/036088251_thumb_208.jpg",
"release_date": "2011-04-17",
"runtime_minutes": 62,
"overview": "Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.",
"sources": [
{
"source_id": 349,
"name": "iTunes",
"type": "buy",
"region": "US",
"ios_url": "itms://itunes.apple.com/us/tv-season/winter-is-coming/id482730236?i=494877461&amp;at=10laHb",
"android_url": null,
"web_url": "https://tv.apple.com/us/episode/winter-is-coming/umc.cmc.11q7jp45c84lp6d16zdhum6ul?playableId=tvs.sbd.9001%3A494877461&amp;showId=umc.cmc.7htjb4sh74ynzxavta5boxuzq",
"format": "HD",
"price": null
},
{
"source_id": 387,
"name": "HBO MAX",
"type": "free",
"region": "US",
"ios_url": "hbomax://deeplink/eyJjb21ldElkIjoidXJuOmhibzplcGlzb2RlOkdWVTROWWd2UFFsRnZqU29KQWJtTCIsImdvVjJJZCI6InVybjpoYm86ZXBpc29kZTpHVlU0TllndlBRbEZ2alNvSkFibUwifQ==?action=open",
"android_url": "hbomax://urn:hbo:episode:GVU4NYgvPQlFvjSoJAbmL",
"web_url": "https://play.hbomax.com/episode/urn:hbo:episode:GVU4NYgvPQlFvjSoJAbmL",
"format": "HD",
"price": null
},
{
"source_id": 442,
"name": "DirecTV On Demand",
"type": "sub",
"region": "US",
"ios_url": null,
"android_url": null,
"web_url": "https://www.directv.com/tv/Game-of-Thrones-SHNpWmVyR21jeHM9/Winter-Is-Coming-d2N0d09mMXFtdVFLU2lheTMvWDhLQT09",
"format": "HD",
"price": null
},
{
"source_id": 393,
"name": "Crave",
"type": "sub",
"region": "CA",
"ios_url": "onemainstream.HTNJ5TAR://media/open/source_id/c864629",
"android_url": null,
"web_url": "https://www.crave.ca/tv-shows/game-of-thrones/winter-is-coming-s1e1",
"format": "HD",
"price": null
},
{
"source_id": 394,
"name": "Crave Plus",
"type": "sub",
"region": "CA",
"ios_url": "onemainstream.HTNJ5TAR://media/open/source_id/c864629",
"android_url": null,
"web_url": "https://www.crave.ca/tv-shows/game-of-thrones/winter-is-coming-s1e1",
"format": "HD",
"price": null
}
]
},
{
"id": 6088252,
"name": "The Kingsroad",
"episode_number": 2,
"season_number": 1,
"season_id": 2,
"tmdb_id": 63057,
"imdb_id": "tt1668746",
"thumbnail_url": "https://cdn.watchmode.com/episode_thumbnails/036088252_thumb_208.jpg",
"release_date": "2011-04-24",
"runtime_minutes": 56,
"overview": "While Bran recovers from his fall, Ned takes only his daughters to Kings Landing. Jon Snow goes with his uncle Benjen to The Wall. Tyrion joins them.",
"sources": [
{
"source_id": 387,
"name": "HBO MAX",
"type": "sub",
"region": "US",
"ios_url": "hbomax://deeplink/eyJjb21ldElkIjoidXJuOmhibzplcGlzb2RlOkdWVkQ1MkFGdGY4Tm9zU1FKQUFHYiIsImdvVjJJZCI6InVybjpoYm86ZXBpc29kZTpHVlZENTJBRnRmOE5vc1NRSkFBR2IifQ==?action=open",
"android_url": "hbomax://urn:hbo:episode:GVVD52AFtf8NosSQJAAGb",
"web_url": "https://play.hbomax.com/episode/urn:hbo:episode:GVVD52AFtf8NosSQJAAGb",
"format": "HD",
"price": null
},
{
"source_id": 349,
"name": "iTunes",
"type": "buy",
"region": "US",
"ios_url": "itms://itunes.apple.com/us/tv-season/the-kingsroad/id482730236?i=494878760&amp;at=10laHb",
"android_url": null,
"web_url": "https://tv.apple.com/us/episode/the-kingsroad/umc.cmc.2b2padn89h3v41z8a6035r82n?playableId=tvs.sbd.9001%3A494878760&amp;showId=umc.cmc.7htjb4sh74ynzxavta5boxuzq",
"format": "HD",
"price": null
},
{
"source_id": 140,
"name": "Google Play",
"type": "buy",
"region": "US",
"ios_url": null,
"android_url": "https://play.google.com/store/tv/show?id=71Edzxe9gmo&amp;cdid=tvseason-0uaIRlgLkL4&amp;gdid=tvepisode-h4WhiLYER4Y",
"web_url": "https://play.google.com/store/tv/show?amp=&amp;=&amp;cdid=tvseason-0uaIRlgLkL4&amp;gdid=tvepisode-h4WhiLYER4Y&amp;gl=US&amp;hl=en&amp;id=71Edzxe9gmo",
"format": "HD",
"price": null
},
{
"source_id": 307,
"name": "VUDU",
"type": "buy",
"region": "US",
"ios_url": "vuduapp://play?contentId=296658",
"android_url": "vuduapp://296658",
"web_url": "https://www.vudu.com/content/movies/details/Game-of-Thrones-The-Kingsroad/296658",
"format": "HD",
"price": null
},
{
"source_id": 24,
"name": "Amazon",
"type": "buy",
"region": "US",
"ios_url": "aiv://aiv/resume?_encoding=UTF8&amp;asin=B00D2DGVNC&amp;time=0",
"android_url": "intent://watch.amazon.com/watch?asin=B00D2DGVNC&amp;contentType=episode&amp;territory=US&amp;ref_=atv_dp_pb_core#Intent;scheme=https;package=com.amazon.avod.thirdpartyclient;component=com.amazon.avod.thirdpartyclient/com.amazon.avod.thirdpartyclient.ThirdPartyPlaybackActivity;end",
"web_url": "https://watch.amazon.com/detail?gti=amzn1.dv.gti.4ea9f78f-99fb-e3f4-56c6-3f423ba53606",
"format": "HD",
"price": null
},
{
"source_id": 393,
"name": "Crave",
"type": "sub",
"region": "CA",
"ios_url": "onemainstream.HTNJ5TAR://media/open/source_id/c864630",
"android_url": null,
"web_url": "https://www.crave.ca/tv-shows/game-of-thrones/the-kingsroad-s1e2",
"format": "HD",
"price": null
},
{
"source_id": 394,
"name": "Crave Plus",
"type": "sub",
"region": "CA",
"ios_url": "onemainstream.HTNJ5TAR://media/open/source_id/c864630",
"android_url": null,
"web_url": "https://www.crave.ca/tv-shows/game-of-thrones/the-kingsroad-s1e2",
"format": "HD",
"price": null
}
]
}
]
/v1/title/{title_id}/episodes/

Return all of the episodes for a TV series or mini-series, as well as the streaming sources each episode is available on. Set &append_to_response=episodes to the title details endpoint above to get these results added to the title details response.

} ,{List Titles API
Example Request

curl -i 'https://api.watchmode.com/v1/list-titles/?apiKey=YOUR_API_KEY&source_ids=203,57'
Example response

{
"titles": [
{
"id": 1337513,
"title": "Secret in Their Eyes",
"year": 2015,
"imdb_id": "tt1741273",
"tmdb_id": 290751,
"tmdb_type": "movie",
"type": "movie"
},
{
"id": 1247225,
"title": "Spy Cat",
"year": 2018,
"imdb_id": "tt5746054",
"tmdb_id": 509733,
"tmdb_type": "movie",
"type": "movie"
}
],
"page": 1,
"total_results": 4592,
"total_pages": 19
}

/v1/list-titles/

Get a listing of titles that match certain parameters. This powerful endpoint can allow you to find many combinations of titles. For example you could search for something as granular "Horror Movies Streaming on Netflix in the USA" by using the genres, types, source_ids and regions parameters.

Results are paginated, and return 250 pages per query by default. Useful for mapping all Watchmode title IDs in your app, and finding in bulk what titles are available in different countries, different sources or source types.

Parameter	Required	Description
types	optional
string
Filter result to only include certain types of titles. Pass a single type or pass multiple types comma delimited. Possible values: movie, tv_series, tv_special, tv_miniseries, short_film
regions	optional
string
Pass one of the region values (eg. US), or multiple regions comma delimited to only return sources active in those regions. For a full list of supported regions see the: Regions Endpoint
Note: If you populate the source_ids or source_types you can only set a single region, and if you set no region US will be set by default. Each additional region will cost 1 API credit.
languages	optional
string
Pass one 2 character ISO 639 language codes (eg. en), or multiple languages comma delimited to only return titles with the primary language matching your selected languages.
source_types	optional
string
Filter results to only include titles that are available on a specific type(s) of source (such a subscription, or TV Everywhere channel apps, etc). By default all are selected, pass one or multiple (comma delimited) of these values: sub, rent, buy, free, tve
Note: If you populate this you can only set a single region, and if you set no region US will be set by default.
source_ids	optional
string
Pass an individual ID for a source (returned from the /sources/ endpoint) to filter the results to titles available on that source. Pass multiple values comma separated to return titles available on one of the sources you pass in.
Note: If you populate this you can only set a single region, and if you set no region US will be set by default.
genres	optional
string
Filter results to only include certain genre(s). Pass in a single genre id (which you would get from the /v1/genres/ endpoint, or multiple comma separated.
network_ids	optional
string
Pass an individual ID for a TV network (returned from the /networks/ endpoint) to filter the results to titles the originally aired on that TV network. Pass multiple values comma separated to return titles that aired on one of the networks you passed in.
sort_by	optional
string
Sort order of results, possible values: relevance_desc, relevance_asc, popularity_desc, popularity_asc, release_date_desc, release_date_asc, title_desc, title_asc. Default value is: relevance_desc.
release_date_start	optional
int
Set the start of a range for when the title was released (the initial release of the movie or show, not necessarily when it was released on a streaming service). For example, to only include releases on or after January 1, 2001 set this to 20010101
release_date_end	optional
int
Set the end of a range for when the title was released (the initial release of the movie or show, not necessarily when it was released on a streaming service). For example, to only include releases on or before December 11, 2020 set this to 20201211
user_rating_high	optional
int
On a scale of 0-10, this parameter can limit the titles to those with user ratings including or below this number.
user_rating_low	optional
int
On a scale of 0-10, this parameter can limit the titles to those with user ratings including or above this number.
critic_score_high	optional
int
On a scale of 0-100, this parameter can limit the titles to those with critic scores including or below this number.
critic_score_low	optional
int
On a scale of 0-100, this parameter can limit the titles to those with critic scores including or above this number.
page	optional
int
Set the page of results you want to return, if this isn't set you will always get page 1 returned.
limit	opt} , {Streaming Releases API
Example Request

curl -i 'https://api.watchmode.com/v1/releases/?apiKey=YOUR_API_KEY'
Example response

{
"releases": [
{
"id": 3165490,
"title": "Slow Horses",
"type": "tv_series",
"tmdb_id": 95480,
"tmdb_type": "tv",
"imdb_id": "tt5875444",
"season_number": 1,
"poster_url": "https://cdn.watchmode.com/posters/03165490_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 371,
"source_name": "AppleTV+",
"is_original": 1
},
{
"id": 3175997,
"title": "Luxe Listings Sydney",
"type": "tv_series",
"tmdb_id": 128912,
"tmdb_type": "tv",
"imdb_id": "tt14344354",
"season_number": 2,
"poster_url": "https://cdn.watchmode.com/posters/03175997_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 26,
"source_name": "Amazon Prime",
"is_original": 1
},
{
"id": 3179027,
"title": "The Outlaws",
"type": "tv_series",
"tmdb_id": 136044,
"tmdb_type": "tv",
"imdb_id": "tt11646832",
"season_number": 1,
"poster_url": "https://cdn.watchmode.com/posters/03179027_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 26,
"source_name": "Amazon Prime",
"is_original": 0
},
{
"id": 3171741,
"title": "Doug Unplugs",
"type": "tv_series",
"tmdb_id": 112148,
"tmdb_type": "tv",
"imdb_id": "tt11690802",
"season_number": 2,
"poster_url": "https://cdn.watchmode.com/posters/03171741_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 371,
"source_name": "AppleTV+",
"is_original": 1
},
{
"id": 1623745,
"title": "The Bubble",
"type": "movie",
"tmdb_id": 765119,
"tmdb_type": "movie",
"imdb_id": "tt13610562",
"season_number": null,
"poster_url": "https://cdn.watchmode.com/posters/01623745_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 203,
"source_name": "Netflix",
"is_original": 0
},
{
"id": 3175047,
"title": "The Boarding School: Las Cumbres",
"type": "tv_series",
"tmdb_id": 97513,
"tmdb_type": "tv",
"imdb_id": "tt11709206",
"season_number": 2,
"poster_url": "https://cdn.watchmode.com/posters/03175047_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 26,
"source_name": "Amazon Prime",
"is_original": 1
},
{
"id": 1645336,
"title": "Captain Nova",
"type": "movie",
"tmdb_id": 881957,
"tmdb_type": "movie",
"imdb_id": "tt14915608",
"season_number": null,
"poster_url": "https://cdn.watchmode.com/posters/01645336_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 203,
"source_name": "Netflix",
"is_original": 0
},
{
"id": 543512,
"title": "Love Me",
"type": "tv_series",
"tmdb_id": 139628,
"tmdb_type": "tv",
"imdb_id": "tt15233564",
"season_number": 1,
"poster_url": "https://cdn.watchmode.com/posters/0543512_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 157,
"source_name": "Hulu",
"is_original": 0
},
{
"id": 122505,
"title": "All Inclusive",
"type": "movie",
"tmdb_id": 105894,
"tmdb_type": "movie",
"imdb_id": "tt1065290",
"season_number": null,
"poster_url": "https://cdn.watchmode.com/posters/0122505_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 157,
"source_name": "Hulu",
"is_original": 0
},
{
"id": 131232,
"title": "Antz",
"type": "movie",
"tmdb_id": 8916,
"tmdb_type": "movie",
"imdb_id": "tt0120587",
"season_number": null,
"poster_url": "https://cdn.watchmode.com/posters/0131232_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 157,
"source_name": "Hulu",
"is_original": 0
},
{
"id": 133594,
"title": "Armored",
"type": "movie",
"tmdb_id": 4597,
"tmdb_type": "movie",
"imdb_id": "tt0913354",
"season_number": null,
"poster_url": "https://cdn.watchmode.com/posters/0133594_poster_w185.jpg",
"source_release_date": "2022-04-01",
"source_id": 157,
"source_name": "Hulu",
"is_original": 0
}
]
}}