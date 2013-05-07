#= require environment
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./templates
#= require_tree ./views

Leaderboard = @Leaderboard

$('ul.contributors').each ->
  $el    = $(this)
  stream = $el.data('stream')

  contributors = new Leaderboard.Collections.Contributors [ ], url: stream
  view         = new Leaderboard.Views.Contributors(el: $el, collection: contributors)

  contributors.fetch()