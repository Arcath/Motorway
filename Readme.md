# Motorway

[![Build Status](https://travis-ci.org/Arcath/Motorway.svg?branch=master)](https://travis-ci.org/Arcath/Motorway) [![Coverage Status](https://coveralls.io/repos/Arcath/Motorway/badge.svg?branch=master&service=github)](https://coveralls.io/github/Arcath/Motorway?branch=master) [![Dependency Status](https://david-dm.org/arcath/Motorway.svg)](https://david-dm.org/arcath/Motorway) [![npm version](https://badge.fury.io/js/motorway.svg)](http://badge.fury.io/js/motorway)

Asyncronous Flow control for NodeJS Applications

## Usage

Require Motorway and create a new instance:

```javascript
Motorway = require('motorway')
motorway = new Motorway()
```

### motorway.addJunction(name[, runAfter])

Adds a junction identified by _name_ which runs after all the junctions in _runAfter_ finish

### motorway.addAction(junction, function)

Adds _function_ as an action for _junction_

Actions __must end with__ `this.rejoin()` so that motorway knows when to flag the action as complete.

### motorway.loadJunction(modulePath)

Load a junction from _modulePath_. Your junction file should look like this:

```javascript
module.exports = {
  name: 'configure',
  runAfter: ['init'],
  actions: [
    function(){
      this.rejoin()
    }
  ]
}
```

### motorway.dropJunction(name)

Drops the junction _name_ so that it wont run.


### motorway.replaceJunction(oldJunctionName, newJunctionName)

Creates a new junction call _newJUnctionName_ with the runAfter details from _oldJunctionName_. It then calls dropJunction for _oldJunctionName_

Useful for replacing the `listen` junction with a `test` junction in your tests

### motorway.start(name)

Starts your motoway at the junction _name_
