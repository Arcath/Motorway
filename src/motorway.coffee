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

      return this

    addJunction: (name, runAfter =  null) ->
      @junctions.add({name: name, runAfter: runAfter, started: 0, run: 0, complete: false})

    addAction: (junction, func) ->
      junctions = @junctions.where({name: junction})
      if junctions.length == 0
        throw "Junction #{junction} does not exist"
      else
        @actions.add({junction: junction, func: func})

    start: (junction) ->
      runner = new Runner(@junctions.findOne({name: junction}), @actions.where({junction: junction}), @emitter)
      runner.start()

    next: (junction) ->
      junctions = @junctions.where({runAfter: junction})

      for junc in junctions
        @start(junc.name)
