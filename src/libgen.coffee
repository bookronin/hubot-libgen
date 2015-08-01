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
    displayLanguageInfo
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

displayLanguageInfo = (result) ->
  "Language: #{result.Language}"

displayTitleAuthorInfo = (result) ->
  "“#{result.Title}” by #{result.Author || '<Author Unknown>'}"

displayPublishingInfo = (result) ->
  "#{result.Publisher || '<Publisher Unknown>'}, #{result.Year || '<Year Unknown>'}"

libgenQuery = (msg) ->
  libgen.search {
    query: msg.match[1] || msg.match[4]
    search_in: msg.match[2] || msg.match[6]
    count: msg.match[3] || msg.match[5]
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
  robot.respond ///libgen (?:
      ([\w\s]*(?!limit:)(?=\s*in:))(?:\s*in:\s*(author|title))?(?:\s*limit:\s*(\d+))?  #‘in’ first
      |([\w\s]*(?!in:)(?=\s*limit:))(?:\s*limit:\s*(\d+))?(?:\s*in:\s*(author|title))? #‘in’ second
    )///i, (msg) ->
    msg.reply libgenQuery msg
