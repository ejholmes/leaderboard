Contributor = @Leaderboard.Models.Contributor

class @Leaderboard.Collections.Contributors extends Backbone.Collection
  model: Contributor

  comparator: 'contributions'

  fetch: ->
    @trigger('fetch:start')

    @source = new EventSource(@url)

    @source.addEventListener 'update', (e) =>
      data = JSON.parse(e.data)
      @set(data)

    @source.addEventListener 'complete', =>
      @source.close()
      @trigger('fetch:complete')