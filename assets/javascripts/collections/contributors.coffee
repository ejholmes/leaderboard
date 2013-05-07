Contributor = @Leaderboard.Models.Contributor

class @Leaderboard.Collections.Contributors extends Backbone.Collection
  model: Contributor

  fetch: ->
    @source = new EventSource(@url)

    @source.addEventListener 'update', (e) =>
      data = JSON.parse(e.data)
      @set(data)

    @source.addEventListener 'complete', ->
      @close()