class CLI

  constructor: (@ppis) ->
    @model = @ppis.model

    @program = require('commander')
    @program.version(module.version)

    command = @program.command 'get <modelName>'
    command.description 'requesting information'
    command.option('-w, --where [json_condition]', 'filter data by [json_condition]')
    command.option('-o, --order [order]', 'order data by [order]')

    ppis = @ppis
    self = this
    command.action (modelName, options) ->
      modelName = modelName.charAt(0).toUpperCase() + modelName.slice(1)
      model = ppis.model[modelName]
      if model
        ppis.api.getOne(model, options.where, options.order, (err, data) -> self.passData(err, data))
      else
        model = ppis.model.plural[modelName]
        if model
          ppis.api.get(model, options.where, options.order, (err, data) -> self.passData(err, data))
        else
          self.passData('error', { error: "Wrong data request"})

  passData: (err, data) ->
    console.warn(data)
    @callback(err, data)

  parse: (argv, callback) ->
    @callback = callback ? @callback
    @program.parse(argv)

module.exports = CLI