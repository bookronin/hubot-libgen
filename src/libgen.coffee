# Description
#   A hubot script to query libgen
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot libgen <query> - search libgen for <query>
#   hubot libgen <query> in <field> - restrict search to specified field (title|author)
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Denis Hovart <hello@denishovart.com>


libgen = require 'libgen'

searchableFields = -> [
  'title',
  'author'
]

displayedInfo = -> [
  displayTitleAuthorInfo
  displayPublishingInfo
  displayDownloadLink
  displayInfoLink
]

searchRegExp = ->
  new RegExp 'libgen (.*?)( in (' + (searchableFields().join '|') + '))?$', 'i'

displayResult = (result) ->
  ((for info in displayedInfo()
    if typeof info == 'function' then info result else "#{result[info]}"
  ).join "\n")

bytesToSize = (bytes) ->
  sizes = ['bytes', 'kb', 'mb', 'gb', 'tb']
  return '0 Byte' if bytes == 0
  i = parseInt ((Math.floor Math.log bytes) / Math.log 1024)
  "#{Math.round (bytes / (Math.pow 1024, i)), 2}#{sizes[i]}"

displayDownloadLink = (result) -> 
  info = "Download: http://libgen.io/get.php?md5=#{result.MD5}"
  info + " (#{result.Extension}, #{bytesToSize(result.Filesize)})"

displayInfoLink = (result) ->
  "http://libgen.io/book/index.php?md5=#{result.MD5}"

displayTitleAuthorInfo = (result) ->
  "“#{result.Title}” by #{result.Author || '<Author Unknown>'}"

displayPublishingInfo = (result) ->
  "#{result.Publisher || '<Publisher Unknown>'}, #{result.Year || '<Year Unknown>'}"

libgenQuery = (query, field, msg) ->
  libgen.search { query: query, search_in: field, mirror: 'http://gen.lib.rus.ec' }, (err,data) ->
    if typeof err isnt "undefined" and err?
      msg.send err
      return
    n = data.length
    if n == 0
      msg.send 'No results found :('
      return
    msg.send displayResult result for result in data
  "Request transmitted, waiting for results."

module.exports = (robot) ->
  robot.respond searchRegExp(), (msg) ->
    msg.reply libgenQuery msg.match[1], msg.match[3], msg
