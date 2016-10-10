local config = {
    "/" = {
        cache = 1,
    },
    "/boys" = {
        cache = 1,
        cache_key = {"scheme", "host", "uri"},
    },
    "/girls" = {
        cache = 1,
    },
    "/kids" = {
        cache = 1,
    },
    "/lifestyle" = {
        cache = 1,
    },
    "/channel" = {
        cache = 1,
    },
    "/product/sale/.*" = {
        cache = 1,
    },
    "/product/outlet/.*" = {
        cache = 1,
    },
    "/product/pro_.*" = {
        cache = 1,
    },
    "/product/show_.*" = {
        cache = 1,
    },
    "/brands(/search)?" = {
        cache = 1,
    },
    "/product/sale/(discount|vip|breakingYards|discount/detail)" = {
        cache = 1,
    },
    "/product/(outlet/activity|index/index|index/brand|new)" = {
        cache = 1,
    },
    "/guang/(index|info/index|plustar|plustar/brandinfo|author/index|star|plusstar)?" = {
        cache = 1,
    }
}
return config
