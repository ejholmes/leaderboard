class @Leaderboard.Views.Contributor extends Backbone.View
  template: HandlebarsTemplates['contributor']

  initialize: ->
    @listenTo @model, 'change', @render

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$el