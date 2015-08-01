chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'libgen', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/libgen')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.called
