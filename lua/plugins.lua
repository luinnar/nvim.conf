---@class PluginConfig.Info
---@field config table
---@field init_fn (fun(): nil)?

---@alias PluginConfig.update_fn fun(event: vim.event.packchanged.data): nil

---@class PluginConfig
---@field private _info PluginConfig.Info[]
---@field private _update { [string] : PluginConfig.update_fn }
local PluginConfig = {}
PluginConfig.__index = PluginConfig

function PluginConfig.New()
    local self = setmetatable({}, PluginConfig)

    self._info = {}
    self._update = {}

    return self
end

---Adds new plugin
---@param url_or_config string|table URL to plugin code
---@param init_fn (fun(): nil)?
---@param update_fn PluginConfig.update_fn?
---@param dependencies ((string|table)[])?
function PluginConfig:add(url_or_config, init_fn, update_fn, dependencies)
    if dependencies then
        for _, dep_info in ipairs(dependencies) do
            self:add(dep_info)
        end
    end

    local config

    if type(url_or_config) == "table" then
        config = url_or_config
    elseif type(url_or_config) == "string" then
        config = { src = url_or_config }
    end

    assert(config.src, "Plugin configuration must have 'src' field")

    if not config.name then
        config.name = string.match(config.src, "([^/]+)/?$")
    end

    table.insert(self._info, { config = config, init_fn = init_fn })

    if update_fn then
        self._update[config.name] = update_fn
    end

    return self
end

---Applies previously added configuration
function PluginConfig:apply()
    vim.api.nvim_create_autocmd("PackChanged", { callback = function(event) self:_onUpdate(event) end })

    local urls = {}

    for _, info in pairs(self._info) do
        table.insert(urls, info.config)
    end

    vim.pack.add(urls)

    for _, info in pairs(self._info) do
        if info.init_fn then
            info.init_fn()
        end
    end
end

---@private
function PluginConfig:_onUpdate(event)
    local plugin_name, event_kind = event.data.spec.name, event.data.kind
    local plugin_update_fn = self._update[plugin_name]

    if event_kind ~= "install" and event_kind ~= "update" then
        return
    end

    if not plugin_update_fn then
        return
    end

    plugin_update_fn(event)
end

return PluginConfig
