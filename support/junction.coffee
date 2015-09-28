module.exports =
  name: 'configure'
  runAfter: ['init']
  actions: [
    ->
      @rejoin()
  ]
