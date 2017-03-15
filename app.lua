local common = require "common"
local config = require "config"
local redis = require "redtool"
local utils = require "utils"

local rds = redis:new()

local function get_module()
    return ngx.var.arg_module
end

local function get_appver()
    return ngx.var.arg_appver
end

local function get_app()
    return ngx.var.arg_app
end

local function get_model()
    return ngx.var.arg_model
end

string.split = function(s, p)
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

function RandFetch(list, num, poolSize, pool)
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

method = function(k, v)
    if v then
        arg, err = rds:smembers(string.format(k, v))
        if err ~= nil then
            ngx.log(ngx.ERR, err)
            ngx.exit(ngx.HTTP_BAD_REQUEST)
        end
    end
    return arg
end

isintable = function(value, tbl)
    if tbl then
        for _, v in ipairs(tbl) do
            if v == value then
                return 1
            end
        end
    end
    return 0
end

format_ver = function(appver)
    if appver then
        return string.sub(appver, 1, 3)
    end
    return 0
end

local request = {}
local result = {}
local module_args = string.split(get_module(), ',')
local appver_args = get_appver()
local app_args = get_app()
local model_args = get_model()

for _, module in ipairs(module_args) do
    local appver = method(common.WHO_APPVER, module)
    local model = method(common.WHO_MODEL, module)
    local app = method(common.WHO_APP, module)
    local message = 0
    
    if switch(module) == 1 and isintable(format_ver(appver_args), appver) == 1 and isintable(app_args, app) == 1 and  isintable(model_args, model) == 1 then
        message = 1
    end
    if request_addr(module) ~= nil then
        RandFetch(request, #request_addr(module), #request_addr(module), request_addr(module))
        result[module] = {on=message, conf={request_addr=request, wait_time=wait_time(module)}}
        request={}
    else
        result[module] = {on=message}
    end
end

ngx.say(cjson.encode(result))
