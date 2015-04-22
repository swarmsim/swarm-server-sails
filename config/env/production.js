/**
 * Production environment settings
 *
 * This file can include shared settings for a production environment,
 * such as API keys or remote database passwords.  If you're using
 * a version control solution for your Sails app, this file will
 * be committed to your repository unless you add it to your .gitignore
 * file.  If your repository will be publicly viewable, don't add
 * any private information to this file!
 *
 */

module.exports = {

  models: {
    migrate: 'safe',
  },

  // Try not to hardcode stuff for production; instead use /secrets/prod/env.sh. Environment variable changes are easy and fast to release; code changes take longer.

  /***************************************************************************
   * Set the port in the production environment to 80                        *
   ***************************************************************************/

  // port: 80,

  /***************************************************************************
   * Set the log level in production environment to "silent"                 *
   ***************************************************************************/

  // log: {
  //   level: "silent"
  // }

};

// Allow sails-migrations to access the db without requiring it for the entire prod deployment.
if (process.env.SAILS_MIGRATIONS && !process.env.DB_ADAPTER) {
  module.exports.models.connection = 'postgres';
}
