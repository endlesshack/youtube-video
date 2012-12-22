window.YoutubeVideo = (id, callback) ->
  $.ajax(
    url: "http://www.youtube.com/get_video_info?video_id=#{id}"
    dataType: "text"
  ).done (video_info) ->
    video = YoutubeVideo.decodeQueryString(video_info)

    if video.status == "fail"
      return callback(video)

    video.sources = YoutubeVideo.decodeStreamMap(video.url_encoded_fmt_stream_map)
    video.getSource = (type, quality) ->
      lowest = null
      exact = null
      for key, source of @sources
        if source.type.match type
          if source.quality.match quality
            exact = source
          else
            lowest = source
      exact || lowest

    callback(video)

window.YoutubeVideo.decodeQueryString = (queryString) ->
  r = {}
  keyValPairs = queryString.split("&")
  for keyValPair in keyValPairs
    key = decodeURIComponent(keyValPair.split("=")[0])
    val = decodeURIComponent(keyValPair.split("=")[1] || "")
    r[key] = val
  r

window.YoutubeVideo.decodeStreamMap = (url_encoded_fmt_stream_map) ->
  sources = {}
  for urlEncodedStream in url_encoded_fmt_stream_map.split(",")
    stream = YoutubeVideo.decodeQueryString(urlEncodedStream)
    type    = stream.type.split(";")[0]
    quality = stream.quality.split(",")[0]
    stream.original_url = stream.url
    stream.url = "#{stream.url}&signature=#{stream.sig}"
    sources["#{type} #{quality}"] = stream

  sources
