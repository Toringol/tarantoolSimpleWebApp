local log = require 'log'
box.session.on_connect(function()
        log.info("connected %s:%s from %s", box.session.id(),
            box.session.user(), box.session.peer())
        box.session.storage.peer = box.session.peer()
end)

box.session.on_disconnect(function()
        log.info("disconnected %s:%s from %s", box.session.id(),
            box.session.user(), box.session.storage.peer)
end)
