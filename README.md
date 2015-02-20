#ddns verifier

**Description:** This shell script will periodically (with crontab) analyse the ssh log to verify whether the login ip matches the ddns resolve ip.If the ip doesn't match,the program will send an email to warn you.

**Usage:** ./ddns-verifier &

**Attention:**

- this program must working with crontab and mutt
- you shoud substitude the email and ddns domain to yours.

