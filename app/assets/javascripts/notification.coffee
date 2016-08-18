# Creates the faye client
$ ->
  faye = new (Faye.Client)('http://localhost:9292/faye')
  faye.subscribe '/projects/goal_reached', (data) ->
    toastr.success data.msg, data.title
    return
  return