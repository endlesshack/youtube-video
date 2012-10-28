(function() {
  window.YoutubeVideo = function(id, callback) {
    return $.ajax({
      url: "http://www.youtube.com/get_video_info?video_id=" + id,
      dataType: "text"
    }).done(function(video_info) {
      var a, b, part, parts, quality, type, video, _i, _len;
      a = new URI("http://bla.com/?" + video_info, {
        decodeQuery: true
      });
      video = a.query;
      if (video.status === "fail") {
        return callback(video);
      }
      video.sources = {};
      window.bla = video;
      parts = a.query.url_encoded_fmt_stream_map.split("&url");
      for (_i = 0, _len = parts.length; _i < _len; _i++) {
        part = parts[_i];
        b = new URI("http://bla.com/?url" + part, {
          decodeQuery: true
        });
        b.query.url = "" + b.query.url + "&signature=" + b.query.sig;
        if (b.query.quality) {
          type = b.query.type.split(";")[0];
          quality = b.query.quality.split(",")[0];
          video.sources["" + type + " " + quality] = b.query;
        }
      }
      video.getSource = function(type, quality) {
        var exact, key, lowest, source, _ref;
        lowest = null;
        exact = null;
        _ref = this.sources;
        for (key in _ref) {
          source = _ref[key];
          if (source.type.match(type)) {
            if (source.quality.match(quality)) {
              exact = source;
            } else {
              lowest = source;
            }
          }
        }
        return exact || lowest;
      };
      return callback(video);
    });
  };
}).call(this);
