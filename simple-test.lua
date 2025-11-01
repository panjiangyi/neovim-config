-- Simple test for configuration files
print("Testing basic configuration loading...")

-- Test basic vim options
vim.opt.number = true
vim.opt.relativenumber = true

print("✓ Basic vim options set")

-- Test if we can load the main modules without plugins
local modules_to_test = {
  'plugin-config.lsp',
  -- 'plugin-config.luasnip',  -- Skip for now as it requires plugins
  -- 'plugin-config.cmp',      -- Skip for now as it requires plugins
}

for _, module in ipairs(modules_to_test) do
  local status, err = pcall(require, module)
  if status then
    print("✓ " .. module .. " loaded successfully")
  else
    print("✗ " .. module .. " failed: " .. tostring(err))
  end
end

print("Configuration test completed!")