local _M = {}

_M.REDIS_HOST = os.getenv("REDIS_HOST") and os.getenv("REDIS_HOST") or '127.0.0.1'
_M.REDIS_PORT = os.getenv("REDIS_PORT") and os.getenv("REDIS_PORT") or '6379'
_M.SWITCH = tonumber(os.getenv("SWITCH")) and tonumber(os.getenv("SWITCH")) or 0

return _M
