class @Leaderboard.Views.Contributor extends Backbone.View
  tagName: 'li'

  className: 'row-fluid animated bounceIn'

  template: HandlebarsTemplates['contributor']

  initialize: ->
    @model.view = this
    @listenTo @model, 'change', @render

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$el.data('contributions', @model.get('contributions'))
    @$el