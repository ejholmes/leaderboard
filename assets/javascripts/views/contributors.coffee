Leaderboard = @Leaderboard

class @Leaderboard.Views.Contributors extends Backbone.View
  spinner:
    color: '#c9c9c3'

  initialize: ->
    _.bindAll this, 'addOne'

    @listenTo @collection, 'add',            @addOne
    @listenTo @collection, 'sort',           @render
    @listenTo @collection, 'fetch:start',    @addSpinner
    @listenTo @collection, 'fetch:complete', @removeSpinner

  addOne: (model) ->
    view = new Leaderboard.Views.Contributor(collection: @collection, model: model)
    @$el.append view.render()
    @$el

  addSpinner: ->
    @spinner = new Spinner(@spinner).spin()
    @$el.before @spinner.el

  removeSpinner: ->
    @spinner.stop()
