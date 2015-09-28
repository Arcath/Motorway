EventEmitter = require('events').EventEmitter
Runner = require './runner'
sodb = require 'sodb'

module.exports =
  class Motorway
    actions: null
    emitter: null
    junctions: null

    constructor: ->
      @actions = new sodb()
      @emitter = new EventEmitter()
      @junctions = new sodb()

      @emitter.on 'next', (junction) => @next(junction)
      @emitter.on 'start', (junction) => @start(junction)

      return this

    loadJunction: (modulePath) ->
      junction = require modulePath

      @addJunction junction.name, junction.runAfter

      for action in junction.actions
        @addAction junction.name, action

    addJunction: (name, runAfter = []) ->
      @junctions.add({name: name, runAfter: runAfter, started: 0, run: 0, complete: false})

    addAction: (junction, func) ->
      junctions = @junctions.where({name: junction})
      if junctions.length == 0
        throw "Junction #{junction} does not exist"
      else
        @actions.add({junction: junction, func: func})

    dropJunction: (name) ->
      junction = @junctions.findOne({name: name})
      junction.complete = true
      junction.runAfter = []
      @junctions.update(junction)

    start: (junction) ->
      runner = new Runner(@junctions.findOne({name: junction}), @actions.where({junction: junction}), @emitter)
      runner.start()

    next: (junction) ->
      thisJunction = @junctions.findOne({name: junction})
      thisJunction.complete = true
      @junctions.update(thisJunction)

      possibles = @junctions.where({runAfter: {includes: junction}})

      for junc in possibles
        results = @junctions.where({name: junc.runAfter}, {complete: false})
        if results.length == 0
          @emitter.emit 'start', junc.name
