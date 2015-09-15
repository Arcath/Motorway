module.exports =
  class Runner
    constructor: (@junction, @actions, @emitter) ->

    start: ->
      @junction.started = @actions.length

      for action in @actions
        action.func.call(this)

    rejoin: ->
      @junction.run += 1

      if @junction.started == @junction.run
        @emitter.emit 'next', @junction.name
