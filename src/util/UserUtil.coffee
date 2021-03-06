class UserUtil
  dwollaAlias: (user) ->
    @findAlias user, "dwolla"

  twitterAlias: (user) ->
    @findAlias user, "twitter"

  facebookAlias: (user) ->
    @findAlias user, "facebook"

  linkedInAlias: (user) ->
    @findAlias user, "linkedin"

  tumblrAlias: (user) ->
    @findAlias user, "tumblr"

  findAlias: (user, service) ->
    for alias in user.aliases
      if alias.service is service
        return alias
    return undefined

module.exports = new UserUtil()