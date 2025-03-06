const { environment } = require('@rails/webpacker');

environment.config.set('entry', {
  application: './app/javascript/packs/application.js',
});

module.exports = environment;
