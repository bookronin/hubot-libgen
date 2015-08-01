# Description
#   A hubot script to query libgen
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot libgen <query> - search libgen for <query>
#   hubot libgen <query> in:<field> - restrict search to specified field (title|author)
#   hubot libgen <query> limit:<num> - limit search to <num> results
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Denis Hovart <hello@denishovart.com>


libgen = require 'libgen'
util = require 'util'

displayResult = (result) ->
  fns = [
    displayTitleAuthorInfo
    displayPublishingInfo
    displayDownloadLink
    displayInfoLink
  ]
  (fn result for fn in fns).join "\n"

bytesToSize = (bytes) ->
  sizes = ['bytes', 'kb', 'mb', 'gb', 'tb']
  return '0 Byte' if bytes == 0
  i = parseInt ((Math.floor Math.log bytes) / Math.log 1024)
  "#{Math.round (bytes / (Math.pow 1024, i)), 2}#{sizes[i]}"

displayDownloadLink = (result) -> 
  info = "Download: http://libgen.io/get.php?md5=#{result.MD5}"
  info += " (#{result.Extension}, #{bytesToSize(result.Filesize)})"
  info

displayInfoLink = (result) ->
  "http://libgen.io/book/index.php?md5=#{result.MD5}"

displayTitleAuthorInfo = (result) ->
  "“#{result.Title}” by #{result.Author || '<Author Unknown>'}"

displayPublishingInfo = (result) ->
  "#{result.Publisher || '<Publisher Unknown>'}, #{result.Year || '<Year Unknown>'}"

libgenQuery = (msg) ->
  query = msg.match[1]
  search_in = msg.message.text.match(/(?:in:\s*(title|author))/i)?[1]
  count = msg.message.text.match(/(?:limit:\s*(\d+))/i)?[1]
  libgen.search {
    query: query
    search_in: search_in
    count: count
    mirror: 'http://gen.lib.rus.ec'
  }, (err,data) ->
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
  robot.respond /libgen (.*(?=\s+in:)|.*(?=\s+limit:)|.*)/i, (msg) ->
    msg.reply libgenQuery msg
