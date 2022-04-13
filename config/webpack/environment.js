const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const babelLoaderQuasar = require('./loaders/babel-loader-quasar')
const stylus = require('./loaders/stylus')
const pugConfig = require('./loaders/pug')

environment.loaders.append('stylus', stylus)
environment.loaders.append('js', babelLoaderQuasar)
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.config.merge(pugConfig)
module.exports = environment
