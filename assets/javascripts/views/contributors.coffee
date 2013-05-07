Leaderboard = @Leaderboard

class @Leaderboard.Views.Contributors extends Backbone.View
  initialize: ->
    @listenTo @collection, 'add', @addOne

  addOne: (model) ->
    view = new Leaderboard.Views.Contributor(collection: @collection, model: model)
    @$el.append view.render()
    @$el
