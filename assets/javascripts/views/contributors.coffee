Leaderboard = @Leaderboard

class @Leaderboard.Views.Contributors extends Backbone.View
  spinner:
    color: '#c9c9c3'

  initialize: ->
    _.bindAll this, 'addOne'

    @sort = _.throttle @sort, 2000

    @listenTo @collection, 'add',            @addOne
    @listenTo @collection, 'sort',           @sort
    @listenTo @collection, 'fetch:start',    @addSpinner
    @listenTo @collection, 'fetch:complete', @removeSpinner

  sort: ->
    _.delay =>
      $last = null
      for model in @collection.models
        $el = model.view.$el
        $el.removeClass('animated')
        if $last
          $last.after($el)
        else
          $el.prependTo(@$el)
        $last = $el
    , 2000

  addOne: (model) ->
    view = new Leaderboard.Views.Contributor(collection: @collection, model: model)
    @$el.append view.render()
    @$el

  addSpinner: ->
    @spinner = new Spinner(@spinner).spin()
    @$el.before @spinner.el

  removeSpinner: ->
    @spinner.stop()
