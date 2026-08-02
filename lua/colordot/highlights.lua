local H = {};
local cache = {};

function H.get (hex)
  if cache [hex] then return cache [hex] end;
  local name = "ColorDot_" .. hex:gsub ("#","");
  vim.api.nvim_set_hl (0, name, { fg = hex });
  cache [hex] = name;
  return name;
end

return H;
