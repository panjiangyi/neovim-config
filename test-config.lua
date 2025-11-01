#!/usr/bin/env nvim -l

-- Test script to verify our LSP and snippet configuration
print("Testing LSP and Snippet Configuration...")

-- Test if we can require our modules
local status, lsp_config = pcall(require, 'plugin-config.lsp')
if status then
    print("✓ LSP config loaded successfully")
else
    print("✗ LSP config failed to load: " .. tostring(lsp_config))
end

local status, luasnip_config = pcall(require, 'plugin-config.luasnip')
if status then
    print("✓ LuaSnip config loaded successfully")
else
    print("✗ LuaSnip config failed to load: " .. tostring(luasnip_config))
end

local status, cmp_config = pcall(require, 'plugin-config.cmp')
if status then
    print("✓ nvim-cmp config loaded successfully")
else
    print("✗ nvim-cmp config failed to load: " .. tostring(cmp_config))
end

print("Configuration test completed!")