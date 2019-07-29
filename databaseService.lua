log = require('log')
httpd = require('http.server').new('localhost', 8080)

generalHandler = function(req)
	if (req.method == 'PUT') then
		return putHandler(req)
	end

	if (req.method == 'GET') then
		return getHandler(req)
	end

	if (req.method == 'DELETE') then
		return deleteHandler(req)
	end
end


postHandler = function(req)
        local jsonbody = req:json()

	local responce

	if (box.space.database:get{ jsonbody.key } ~= nil) then
		log.error('Error: 409')
		responce = req:render({ json = 'Error: 409' })
		responce.status = 409
	elseif (type(jsonbody.key) == 'string'   and
		type(jsonbody.value) == 'table') then
		local item = box.space.database:insert{ jsonbody.key, jsonbody.value }
		log.info('Inserted key: %s, value: %s', jsonbody.key, jsonbody.value)
		responce = req:render({ json = item })
	else
		log.error('Error: 400')
		responce = req:render({ json = 'Error: 400' })
		responce.status = 400
	end

	return responce
end


putHandler = function(req)
	local id = req:stash('id')
	local jsonbody = req:json()
	local responce

	local item = box.space.database:get{ id }
	
	if not item then
		log.error('Error: 404')
		responce = req:render({ json = 'Error: 404' })
		responce.status = 404
	elseif (type(jsonbody.value) == 'table') then
		local item = box.space.database:put{ id, jsonbody.value }
		log.info('Put key: %s, value: %s', id, jsonbody.value)		
		responce = req:render({ json = item })
	else
		log.error('Error: 400')
		responce = req:render({ json = 'Error: 400' })
		responce.status = 400
	end
	
	return responce
end


getHandler = function(req)
        local id = req:stash('id')

        local item = box.space.database:get{ id }
	
	local responce
	
	if not item then 
		log.error('Error: 404')
		responce = req:render({ json = 'Key not found' })
		responce.status = 404
	else
		responce = req:render({ json = item })
	end

	log.info('Get key: %s', id)
	return responce
end


deleteHandler = function(req)
        local id = req:stash('id')

        local item = box.space.database:delete{ id }

	local responce
	
	if not item then 
		log.error('Error: 404')
		responce = req:render({ json = 'Key not found' })
		responce.status = 404
	else
		responce = req:render({ json = item })
	end

	log.info('Deleted key: %s', id)
        return responce
end

httpd:route({ path = '/kv/:id'}, generalHandler)
httpd:route({ path = '/kv', method = 'POST' }, postHandler)

httpd:start()
