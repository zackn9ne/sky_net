class SkyNet.Routers.Entries extends Backbone.Router
  routes:
    '': 'index'
    'entries/:id': 'show'

  index: ->
    alert "home page"

  show: ->
    alert "Entry #{id}"
