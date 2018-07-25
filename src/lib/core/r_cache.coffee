# r_cache.coffee, pdso/src/lib/core/

# TODO


r_cache = (tab_id) ->
  # global data
  g = {
    # data report to parent (tab_list)
    rc: {
      tab_id
      # ever got reset after enable tab
      after_reset: false

      # TODO res counts ?
    }
    # callback to report to parent
    rc_callback: null

    # the data cache of all loaded resources
    cache: {
      # TODO
    }
    # TODO
  }
  # report rc to parent
  _report = ->
    g.rc_callback?(tab_id, g.rc)

  set_rc_callback = (cb) ->
    g.rc_callback = cb
    _report()  # update data

  # TODO

  init = ->
    # TODO

  clean_up = ->
    # TODO

  reset = ->
    # reset cache, and reset flag
    g.cache = {}
    g.rc.after_reset = true
    # TODO reset other count ?
    _report()  # update data

  get_cache = ->
    g.cache

  # export API
  {
    init  # async
    set_rc_callback

    reset
    get_cache

    # clean up before remove
    clean_up
  }

module.exports = r_cache
