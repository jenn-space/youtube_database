CREATE DATABASE youtube_db;
USE youtube_db;


CREATE TABLE Song (
    title VARCHAR(255) PRIMARY KEY,
    full_title VARCHAR(500),
    description TEXT
);

CREATE TABLE Channel (
    channel VARCHAR(255) PRIMARY KEY,
    channel_url VARCHAR(500),
    channel_followers INT
);

CREATE TABLE Video (
    title VARCHAR(255),
    channel VARCHAR(255),
    full_title VARCHAR(500),
    description TEXT,
    view_count BIGINT,
    duration INT,
    duration_string VARCHAR(50),
    live_status VARCHAR(50),
    thumbnail VARCHAR(500),
    PRIMARY KEY (title , channel),
    FOREIGN KEY (title)
        REFERENCES Song (title),
    FOREIGN KEY (channel)
        REFERENCES Channel (channel)
);

CREATE TABLE VideoCategory (
    title VARCHAR(255),
    channel VARCHAR(255),
    category VARCHAR(255),
    PRIMARY KEY (title, channel, category),
    FOREIGN KEY (title, channel) REFERENCES Video(title, channel)
);

CREATE TABLE VideoTags (
    title VARCHAR(255),
    channel VARCHAR(255),
    tag VARCHAR(255),
    PRIMARY KEY (title, channel, tag),
    FOREIGN KEY (title, channel) REFERENCES Video(title, channel)
);

CREATE TABLE VideoSong (
    video_title VARCHAR(255),
    song_title VARCHAR(255),
    video_channel VARCHAR(255),
    PRIMARY KEY (video_title, video_channel, song_title),
    FOREIGN KEY (video_title, video_channel) REFERENCES Video(title, channel),
    FOREIGN KEY (song_title) REFERENCES Song(title)
);


/* Temp table */
CREATE TABLE temp_import (
    title VARCHAR(500),
    fulltitle VARCHAR(1000),
    description TEXT,
    view_count BIGINT,
    categories VARCHAR(500),
    tags VARCHAR(1000),
    duration INT,
    duration_string VARCHAR(50),
    live_status VARCHAR(50),
    thumbnail VARCHAR(1000),
    channel VARCHAR(255),
    channel_url VARCHAR(1000),
    channel_follower_count BIGINT
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE '/Users/caitlynmaung/Davis/MSBA/BAX 421/youtube-top-100-songs-2025 (2).csv'
INTO TABLE temp_import
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;



Select * from temp_import;


INSERT IGNORE INTO Song (title, full_title, description)
SELECT title, fulltitle, description
FROM temp_import;

Select * FROM Song;


INSERT IGNORE INTO Channel (channel, channel_url, channel_followers)
SELECT channel, channel_url, channel_follower_count
FROM temp_import;

Select * FROM Channel;

INSERT IGNORE INTO Video (title, channel, full_title, description, view_count, duration, duration_string, live_status, thumbnail)
SELECT title, channel, fulltitle, description, view_count, duration, duration_string, live_status, thumbnail
FROM temp_import;

Select * FROM Video;

INSERT IGNORE INTO VideoCategory (title, channel, category)
SELECT title, channel, categories
FROM temp_import;

SELECT * FROM VideoCategory;

INSERT IGNORE INTO VideoTags (title, channel, tag)
SELECT title, channel, tags
FROM temp_import;

Select * FROM VideoTags;


INSERT IGNORE INTO VideoSong (video_title, video_channel, song_title)
SELECT title, channel, title
FROM temp_import;

Select * FROM VideoSong;


# BUSINESS QUESTIONS

# 1. For each channel, what are the top 3 songs of 2025?
SELECT channel, title, FORMAT(view_count, 0) AS view_count
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY channel
            ORDER BY view_count DESC
        ) AS rn
    FROM Video
) ranked
WHERE rn <= 3;

# 2. Which channels dominate the Top 100?
# 3. Which channels generate the highest total view counts?
SELECT channel, view_count
FROM Video
ORDER BY view_count DESC
LIMIT 20;

# 4. How strongly do channel follower counts correlate with video views and video performance?

SELECT
    (COUNT(*) * SUM(v.view_count * c.channel_followers)		# Calculate correlation of followers and views
        - SUM(v.view_count) * SUM(c.channel_followers))
    /
    SQRT(
        (COUNT(*) * SUM(v.view_count * v.view_count)
            - POWER(SUM(v.view_count), 2))
        *
        (COUNT(*) * SUM(c.channel_followers * c.channel_followers)
            - POWER(SUM(c.channel_followers), 2))
    ) AS correlation
FROM Video v
JOIN Channel c
    ON v.channel = c.channel;

# Validate
SELECT c.channel,
c.channel_followers,
v.view_count
FROM Video v
JOIN Channel c
    ON v.channel = c.channel
ORDER BY c.channel_followers DESC;
    
# There is a correlation of only 0.11. For example, Justin Bieber has the highest number of followers (76,200,000) but Billie Eilish's
# videos surpassed his videos in number of views. For example, her most popular video of 2025 got about 558 million views while Justin Bieber got
# only about 24 million views. This means that views don't always come from followers.

# 5. Does video duration influence audience engagement or performance? 

SELECT
    (COUNT(*) * SUM(v.duration * v.view_count) 		# Calculate correlation of duration and views
        - SUM(v.duration) * SUM(v.view_count))
    /
    SQRT(
        (COUNT(*) * SUM(v.duration * v.duration)
            - POWER(SUM(v.duration), 2))
        *
        (COUNT(*) * SUM(v.view_count * v.view_count)
            - POWER(SUM(v.view_count), 2))
    ) AS correlation_duration_views
FROM Video v;


# Video duration does not strongly correlate with video views and performance.

# Validation
SELECT 
  v.title,
  v.duration,
  FORMAT(v.view_count, 0) AS view_count
FROM Video v
ORDER BY v.view_count DESC;