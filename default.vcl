vcl 4.0;

backend default {
  .host = "webserver:80";
}

sub vcl_recv {
    # A client cookie prevents varnish from caching the file but the tiles are not customized
    # for the user such that it doesn't make sense to have a cookie
    unset req.http.cookie;
    unset req.http.cache-control;
}

sub vcl_backend_response {
  if (beresp.status == 200) {
    unset beresp.http.Cache-Control;
    set beresp.http.Cache-Control = "public; max-age=20000";
    set beresp.ttl = 20000s;
  }
}
