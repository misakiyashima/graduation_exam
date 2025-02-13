const { environment } = require('@rails/webpacker')

environment.config.set('entry', {
  application: './app/javascript/application.js'
});

module.exports = environment
