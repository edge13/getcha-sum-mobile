userUtil = require "UserUtil"

class OfferUtil
  eligible: (user, offer) ->
    alias = userUtil.findAlias user, offer.type
    return alias?

module.exports = new OfferUtil()