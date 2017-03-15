local common = require "common"
local config = require "config"
local redis = require "redtool"
local utils = require "utils"

local rds = redis:new()

local function get_module()
    return ngx.var.arg_module
end

string.split = function(s, p)  --字符串分割
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

switch = function(k)
   if k then
       switch1, err = rds:get(string.format(common.WHO_SWITCH, k)) 
       if err then
           ngx.log(ngx.ERR, err)
           ngx.exit(ngx.HTTP_BAD_REQUEST)
       end
   end
   return tonumber(switch1)
end

request_addr = function(k)
    if k then
        ip, err = rds:smembers(string.format(common.WHO_REQUEST_ADDR, k))
        if err ~= nil then
            ngx.log(ngx.ERR, err)
            ngx.exit(ngx.HTTP_BAD_REQUEST)
        end
    end
    return ip
end

wait_time = function(k)
    if k then
        wait_time1, err = rds:get(string.format(common.WHO_WAIT_TIME, k))
        if err ~= nil then
            ngx.log(ngx.ERR, err)
            ngx.exit(ngx.HTTP_BAD_REQUEST)
        end
    end
    return tonumber(wait_time1)
end

function RandFetch(list,num,poolSize,pool) -- list: 筛选结果，num: 筛取个数，poolSize: 筛取源大小，pool: 筛取源
    pool = pool or {}
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    for i = 1, num do
        local rand = math.random(i,poolSize)
        local tmp = pool[rand] or rand
        pool[rand] = pool[i] or i
        pool[i] = tmp
        table.insert(list, tmp)
    end
end

local request={}
local result = {}
local module_args = string.split(get_module(), ',')
for _, module in ipairs(module_args) do
    RandFetch(request, #request_addr(module), #request_addr(module), request_addr(module))
    result[module] = {on=switch(module), conf={request_addr=request, wait_time=wait_time(module)}}
    request={}
end

ngx.say(cjson.encode(result))
