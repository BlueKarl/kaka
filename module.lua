local common = require "common"
local redis = require "redtool"
local rds = redis:new()

local module = rds:smembers(common.BASE_MODULE)
local result = {}
result['base_module'] = module
ngx.say(cjson.encode(result))
