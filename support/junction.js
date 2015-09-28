module.exports = {
  name: 'configure',
  runAfter: ['init'],
  actions: [
    function(){
      this.rejoin()
    }
  ]
}
