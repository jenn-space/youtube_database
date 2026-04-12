# 🎵 YouTube Top 100 Songs Analysis (2025)

SQL + Data Analytics Project

✨ TL;DR

Analyzed the Top 100 YouTube songs of 2025 using SQL to uncover what actually drives video performance—finding that artist popularity and virality matter far more than followers or video length.

🚨 Problem

Many assume that more subscribers or longer videos = more views, but it’s unclear what truly drives performance on YouTube music charts.

🎯 Objective

Identify the key drivers of video views and chart success by analyzing top-performing songs and artists.

🛠️ What I Did

📊 Data & Setup

Dataset: Top 100 YouTube songs (2025)

100 records, 13 features (views, artist, duration, tags, subscribers, etc.)

Built and queried data using MySQL

🏗️ Data Modeling

-Designed a relational schema linking:

-Songs

-Channels (artists)

-Videos

-Cleaned and standardized fields for consistent analysis

🔍 Analysis (SQL)

-Ranked top songs per artist

-Identified highest-performing channels

-Measured correlations between:

-Views vs subscribers

-Views vs video duration

-Explored genre and Top 25 trends

📈 Key Insights

⭐ Artist popularity drives performance

ROSÉ, Lady Gaga, Billie Eilish dominate billions of views

📉 Weak correlation with followers (0.11)

More subscribers ≠ more views

⏱️ Weak correlation with video duration (0.10)

Video length has little impact on performance

🌍 Pop & K-pop dominate

Strong global fanbases + social media virality

🔥 Virality > platform metrics

TikTok trends and hype drive engagement more than technical factors

💼 Business Impact

Shifts strategy from:

❌ Focusing on channel size

✅ Investing in viral content + artist branding

Helps:

Artists optimize release strategy

Marketers prioritize social buzz over format tweaks

Platforms improve recommendation logic

🧠 Key Takeaways

Engagement is driven by who the artist is, not platform metrics

Data modeling + SQL can uncover non-obvious performance drivers

Correlation ≠ intuition (followers don’t guarantee views)

🧰 Tech Stack

MySQL • SQL • Data Modeling • Data Cleaning • Analytics
