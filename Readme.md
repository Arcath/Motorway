# Motorway

Flow control for NodeJS Applications

## Why?

My applications usually end up with a file that calls lots of functions in order, with some functions that require async support etc... which can result in a fairly messy file.

Motorway fixes this by defining logical steps and the actions required for that step.

## Usage

Motorway is fundamentally 2 lists junctions and actions.

Junctions are lists of actions which wait for all actions to complete before completing and triggering the next junction(s).

Adding a junction takes 2 arguments, the name of the junction and the names of the junctions that need to have finished before it can run. For example:

```javascript
Motorway = require 'motorway'
mway = new Motorway()

mway.addJunction('init')
mway.addJunction('configure', ['init'])
mway.addJunction('load-external-services', ['init'])
mway.addJunction('launch', ['configure', 'load-external-services'])
```

These junctions now need actions adding to them which works like this:

```javascript
object = null

mway.addAction('init', function(){
  object = {}
  this.rejoin()
})

mway.addAction('configure', function(){
  object.foo = 'bar'
  object.where = 'here'
  this.rejoin()
})

mway.addAction('load-external-services', function(){
  object.someApi = 'an object'
  this.rejoin()
})

mway.addAction('launch', function(){
  object.listen 3000
  this.rejoin()
})
```

All actions need to end with `this.rejoin()` which lets Motorway know that this action is done and it can (if all actions are finished) start the next junction.

Once everything is defined you need to start Motorway which is done like this this:

```javascript
mway.start('init')
```
