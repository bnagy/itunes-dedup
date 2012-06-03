itunes-dedup
============

How I dedup my iTunes. Almost certainly dangerously broken.

It will automatically try and delete what it thinks are exact duplicates - ie
tracks with the same Artist and Title, which are within --fuzzy-seconds seconds
of each other in total duration. There are some cases where this is DANGEROUS,
eg classical music where you probably have a lot of Vivaldi -- Largo etc. You
can try a --dry-run first if you're paranoid. Tracks it can't figure out
automatically it will prompt you for.

The script will NOT actually delete anything, it just moves files to
~/deleted_itunes_tracks. Because it works by parsing the iTunes Music
Library.xml file, any changes you make with this script will be "behind the
back" of iTunes - in other words iTunes will stil show the tracks in your
library, but it won't be able to play them. The best solution I have for that
is to delete iTunes Music Library.xml and reimport your Music directory.

You need a working install of ruby and some gems (nokogiri, trollop). Obviously.
