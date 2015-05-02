/**
 * Development environment settings
 *
 * This file can include shared settings for a development team,
 * such as API keys or remote database passwords.  If you're using
 * a version control solution for your Sails app, this file will
 * be committed to your repository unless you add it to your .gitignore
 * file.  If your repository will be publicly viewable, don't add
 * any private information to this file!
 *
 */

module.exports = {
  proxyHost: process.env.BASEURL,

  /***************************************************************************
   * Set the default database connection for models in the development       *
   * environment (see config/connections.js and config/models.js )           *
   ***************************************************************************/

  //models: {
  //  connection: 'localDiskDb',
  //  migrate: 'alter'
  //}
  models: {
    connection: process.env.DB_ADAPTER || 'localDiskDb',
    //migrate: 'alter'
    migrate: 'safe'
  }

};
