local common = require "common"
local redis = require "redtool"
local rds = redis:new()

local function get_module()
    module, err = rds:smembers(string.format(common.BASE_MODULE))
    if err ~= nil then
        ngx.log(ngx.ERR, err)
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    return module

end

level = function(k)
    if k then
        lv, err = rds:get(string.format(common.WHO_LEVEL, k))
        if err ~= nil then
            ngx.log(ngx.ERR, err)
            ngx.exit(ngx.HTTP_BAD_REQUEST)
        end
    end
    return tonumber(lv)
end

local result = {}
local module_args = get_module()
for _, module in ipairs(module_args) do
    result[module] = {level=level(module)}
end

ngx.say(cjson.encode(result))
