class UserUtil
  dwollaAlias: (user) ->
    @findAlias user, "dwolla"

  twitterAlias: (user) ->
    @findAlias user, "twitter"

  facebookAlias: (user) ->
    @findAlias user, "facebook"

  findAlias: (user, service) ->
    for alias in user.aliases
      if alias.service is service
        return alias
    return undefined

module.exports = new UserUtil()