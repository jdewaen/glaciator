Glaciator Backup

Features:
- Scan directory and find files which have not been backed up yet by comparing hash
    - Full scan: check hash of each file
    - Quick scan: only hash new files and files with different modified date
- Upload files to S3 under sha1 hash as name
    - Configurable bucket
    - Configurable storage tier
    - Must be easy to add other parameters
- Upload index with data for full restoration. Minimum:
    - file structure
    - modified date
    - moved/deleted files (for selective recovery)
- When killed: gracefully recover and continue after restart

Use cases
- Daily or more: run backup with quick scan
- Weekly or less: run backup with full scan




Glaciator Restore

Features:
- Compare (sub)directory against index, detect missing/modified files
    - Use index on S3
- Download available files to correct location, apply correct metadata
    - Use index on S3 for metadata
- Request restoration for files in Glacier storage classes
    - Configurable retention duration
- Recover previously deleted files
    - List files that were moved or deleted in directory and/or time period
    - select any (potentially large) number of files to restore
- When killed: gracefully recover and continue after restart

Use cases:
- After catastrophic drive failure: full restore of all data
- Immediately after accidental data loss: restore individual directory/directories
- Some time period after accidental data loss: list files that were moved/deleted from directory in time period, select one or more files to restore