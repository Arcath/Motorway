# Motorway

Flow control for NodeJS Applications

## Why?

My applications usually end up with a file that calls lots of functions in order, with some functions that require async support etc... which can result in a faily messy file.

Motorway fixes this by defining logical steps and the actions required for that step.

## Usage

```coffee
app = null
Express = require 'express'
Motorway = require 'motorway'

mway = new Motorway()

mway.addJunction 'init'
mway.addJunction 'configure', 'init'
mway.addJunction 'launch', 'configure'

mway.addAction 'init', ->
  app = Express()

mway.addAction 'configure', ->
  app.use '/assets', Express.static('assets')

mway.addAction 'configure', ->
  app.use '/', IndexRouter
  app.use '/admin', AdminRouter
  app.use '/users', UsersRouter
  app.use '/products', ProductsRouter

mway.addAction 'launch', ->
  app.listen 3000
```

Motorway is fundamentally 2 lists junctions and actions.

Junctions are lists of actions which wait for all actions to complete before completing and triggering the next junction.
