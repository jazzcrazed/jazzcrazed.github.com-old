module.exports = (env, callback) ->

  if !env.helpers.facebookifyDescription
    env.helpers.facebookifyDescription = (content) ->
      regex = /(<([^>]+)>)/ig
      content.replace(regex, "");

  callback()
