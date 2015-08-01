# Description
#   A hubot script to query libgen
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Denis Hovart <hello@denishovart.com>


libgen = require 'libgen'

searchableFields = -> [
  'title',
  'author',
  'series',
  'periodical',
  'publisher',
  'year',
  'identifier',
  'md5',
  'extension'
]

displayedInfo = -> [
  'Title',
  'Author',
  displayDownloadLink
]

searchRegExp = ->
  new RegExp 'libgen (.*?)( in (' + (searchableFields().join '|') + '))?$', 'i'

displayResult = (result) ->
  ((for info in displayedInfo()
    if typeof info == 'string' then "#{result[info]}" else info result
  ).join "\n") + "\n"

displayDownloadLink = (result) -> 
  'Download: ' + 'http://gen.lib.rus.ec/book/index.php?md5=' + result.MD5.toLowerCase()

libgenQuery = (query, field, msg) ->
  libgen.search { query: query, search_in: field, mirror: 'http://gen.lib.rus.ec' }, (err,data) ->
    if typeof err isnt "undefined" and err?
      msg.send err
      return
    n = data.length
    if n == 0
      msg.send 'No results found :('
      return
    msg.send (displayResult result for result in data).join "\n"
  "Request transmitted, waiting for results."

module.exports = (robot) ->
  robot.respond searchRegExp(), (msg) ->
    msg.reply libgenQuery msg.match[1], msg.match[3], msg
