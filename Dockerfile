FROM tarantool/tarantool:2

COPY server.lua          /
COPY trigger.lua         /
COPY databaseService.lua /

CMD ["tarantool", "/server.lua"]
