path = require 'path'

expect = require('chai').expect

Motorway = require path.join(__dirname, '..', 'src', 'motorway')

describe 'Motorway', ->
  it 'should create 2 sodbs', ->
    mway = new Motorway()

    expect(mway.junctions).not.to.equal null

  it 'should add junctions', ->
    mway = new Motorway()

    mway.addJunction('one')

    expect(mway.junctions.objects.length).to.equal 1

  it 'should add actions', ->
    mway = new Motorway()

    mway.addJunction('one')
    mway.addAction('one', -> return 1)

    expect(mway.actions.where({junction: 'one'})[0].junction).to.equal 'one'

  it 'should error if adding an action to a none existant junction', ->
    mway = new Motorway()

    expect(->
      mway.addAction('one', -> return 1)
    ).to.throw 'Junction one does not exist'

  it 'should start', (done) ->
    mway = new Motorway()

    mway.addJunction('one')
    mway.addAction('one', -> done())

    mway.start('one')

  it 'should pass to the next junction', (done) ->
    mway = new Motorway()

    mway.addJunction('one')
    mway.addAction('one', -> @rejoin())
    mway.addJunction('two', ['one'])
    mway.addAction('two', -> done())

    mway.start('one')

  it 'should work how the readme implies', (done) ->
    object = null

    loadObjects = ->
      object = {}
      @rejoin()

    setFoo = ->
      object.foo = true
      @rejoin()

    setBar = ->
      object.bar = true
      @rejoin()

    expectFooBar = ->
      expect(object.foo).to.equal true
      expect(object.bar).to.equal true
      done()

    mway = new Motorway()

    mway.addJunction('init')
    mway.addJunction('configure', ['init'])
    mway.addJunction('launch', ['configure'])

    mway.addAction('init', loadObjects)
    mway.addAction('configure', setFoo)
    mway.addAction('configure', setBar)
    mway.addAction('launch', expectFooBar)

    mway.start('init')

  it 'should support async junctions', (done) ->
    count = null

    mway = new Motorway()
    mway.addJunction('init')
    mway.addJunction('add', ['init'])
    mway.addJunction('subtract', ['init'])
    mway.addJunction('finish', ['add', 'subtract'])

    mway.addAction 'init', ->
      count = 0
      @rejoin()

    mway.addAction 'add', ->
      count += 1
      @rejoin()

    mway.addAction 'subtract', ->
      count -= 1
      setTimeout(=>
        @rejoin()
      , 100)

    mway.addAction 'finish', ->
      expect(count).to.eq 0
      done()
      @rejoin()

    mway.start('init')

  it 'should support async actions', (done) ->
    mway = new Motorway()
    mway.addJunction('init')
    mway.addJunction('finish', ['init'])

    mway.addAction 'init', ->
      setTimeout(=>
        @rejoin()
      , 1500)

    mway.addAction 'init', ->
      setTimeout(=>
        @rejoin()
      , 1500)

    mway.addAction 'finish', ->
      done()

    mway.start('init')

  it 'should let you drop junctions', (done) ->
    mway = new Motorway()

    passed = false

    mway.addJunction('pass')
    mway.addJunction('fail', ['pass'])
    mway.addJunction('test', ['pass', 'fail'])

    mway.addAction 'pass', ->
      passed = true
      @rejoin()

    mway.addAction 'fail', ->
      passed = false
      @rejoin()

    mway.addAction 'test', ->
      expect(passed).to.eq true
      done()

    mway.dropJunction('fail')

    mway.start('pass')
