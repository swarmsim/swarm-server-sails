v0.0.10: 2015/04/24
* Kongregate save migrations for players with no save are quieter.

v0.0.9: 2015/04/23
* Stop using Kongregate auth tokens in save keys. (It'll take a day or two for permissions to expire.)

v0.0.8: 2015/04/23
* Invisible infrastructure changes; things should run faster.

v0.0.7: 2015/04/22
* Kongregate online saves work again.

v0.0.6: 2015/04/21
* The database connection now requires SSL.

~~v0.0.5: 2015/04/21~~
* All database urls now check authorization; you can't edit someone else's characters.
* Database operations enabled in production.

v0.0.4: 2015/04/17
* Include hostname in `/about`.

v0.0.3: 2015/04/17
* `/about` and `/` return version and uptime.
* `/healthy` verifies the server's online.
* Fix expiration date for Kongregate save policy.

v0.0.2: 2015/04/17
* Invisible backend changes. Serverside user account/character apis implemented, but disabled in production.

v0.0.1
* Initial release. Replace legacy Rails server. Kongregate S3 policies work.
