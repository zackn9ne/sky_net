window.SkyNet =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new SkyNet.Routers.Entrys()
    Backbone.history.start()

$(document).ready ->
  SkyNet.initialize()