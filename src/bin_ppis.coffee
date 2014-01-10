class BinPPIS

  constructor: () ->
    PPIS = require('ppis')
    @ppis = new PPIS();
    @ppis.promise.then((ppis) ->
      async = require('async')
      ASYNC_CB = null
      CLI = require('..')
      ppis.cli = new CLI(ppis)
      async.auto({
        run: (callback) ->
          ASYNC_CB = callback
          ppis.cli.parse(process.argv, (err, data) ->
            ASYNC_CB(err)
          )
      }, (err, result) ->
        process.exit(err ? 1 : 0)
      )
    )

module.exports = BinPPIS