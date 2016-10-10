package.path = "/usr/local/nginx/lua_modules/?.lua"
local config = require("lua_config")
local key = ngx.var.host .. ngx.var.uri
local location = config[key]
if locaiton then 
    ngx.var.cache = locaiton.cache
end

function proxyPass(uri, proxyPrefix)
    local finded = 0
    for k, v in ipairs(config) do 
        if ngx.re.match(uri, "^"..v.router.."$") then
            finded = 1
            ngx.var.pass = v.proxy_pass .. proxyPrefix

            if v.cache ~= nil then
                ngx.var.cache = v.cache
                local cacheKey = ""
                if v.cache_key ~= nil and #v.cache_key > 0 then 
                    for i = 1, #v.cache_key do
                        if ngx.var[v.cache_key[i]] ~= nil then 
                            cacheKey = cacheKey .. ngx.var[v.cache_key[i]]
                        end
                    end
                    ngx.var.cache_key = cacheKey
                else 
                    ngx.var.cache_key = ngx.var.scheme .. ngx.var.host .. uri .. (ngx.var.args and ngx.var.args or "")
                end
            else 
                ngx.var.cache = 0
            end

            

            if v.fenxi_log ~= nil then
                ngx.var.fenxi_log = v.fenxi_log
            else 
                ngx.var.fenxi_log = 0
            end
            break
        end
    end
        --   ngx.header.content_type = "text/plain"
        -- ngx.say(ngx.var.sort)
    if finded == 1 then 
        if ngx.var.cache == "1" then
            ngx.exec("@cache", ngx.var)
        else 
            ngx.exec("@noCache", ngx.var)
        end
    else 
        ngx.exec("@default", ngx.var)
    end
end
--三级域名
local match = ngx.re.match(ngx.var.host, "(\\w*)\\.(\\w*\\.\\w*\\.\\w*)")
if match then 
    if ngx.re.match(ngx.var.host, "^guang\\.") then
        proxyPass("/guang" .. ngx.var.uri, "/guang")
    elseif ngx.re.match(ngx.var.host, "^list\\.") then
        if ngx.var.uri == "/" then
            proxyPass("/product/index/index", "/product/index/index")
        else 
            proxyPass(ngx.var.uri, "")
        end
    elseif ngx.re.match(ngx.var.host, "^search\\.") then
        if ngx.var.uri == "/" then
            if ngx.var.args ~= nil and #ngx.var.args > 0 then
                proxyPass("/product/search/list", "/product/search/list")
            else
                proxyPass("/product/search/index", "/product/search/index")
            end 
        elseif ngx.var.uri == "/search" then
       
            ngx.req.set_uri("/")
            proxyPass("/product/search/index", "/product/search/index")
        else 
            proxyPass(ngx.var.uri, "")
        end
    elseif ngx.re.match(ngx.var.host, "^sale\\.") then
        ngx.redirect("//m.yohobuy.com/product/sale", 301);
    elseif ngx.re.match(ngx.var.host, "^cart\\.") then
        ngx.redirect("//m.yohobuy.com/cart/index/index", 301); --待解决
    elseif ngx.re.match(ngx.var.host, "^new\\.") then
        if ngx.var.uri == "/hotrank" then
            ngx.redirect("//m.yohobuy.com/product/newsale/hotrank", 301);
        else 
            ngx.redirect("//m.yohobuy.com", 301);
        end
    elseif ngx.re.match(ngx.var.host, "^item\\.") then
        ngx.redirect("//m.yohobuy.com", 301);
    else
        --      ngx.header.content_type = "text/plain"
        -- ngx.say("/guang" .. ngx.var.uri)
        -- ngx.req.set_uri_args({domain = match[1]})
        --   ngx.header.content_type = "text/plain"
        -- ngx.say(ngx.var.args)
        proxyPass("/product/index/brand", "/product/index/brand")
    end
else 
    proxyPass(ngx.var.uri, "")
end





