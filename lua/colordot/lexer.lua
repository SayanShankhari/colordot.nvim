local L = {};
L.__index = L;

function L:new (line)
  return setmetatable ({
    line = line,
    pos = 1,
  }, self);
end

-- in lua %x already defined as [0-9A-Za-z]
local HEX_PATTERN = "#%x%x%x%x%x%x";

function L:next()
  local s, e = self.line:find (HEX_PATTERN, self.pos);
  if not s then return nil end;
  self.pos = e + 1;
  return {
    format = "HEX_COLOR",
    lexeme = self.line:sub (s, e),
    column_number = s,
    end_column_number = e,
  };
end

--[[
local c1 = "#ff0000"
local c2 = rgb(255,0,0)
local c3 = hsl(120,100%,50%)
local c4 = "#00ff00"

{
  { type = "HEX_COLOR", line = 0, col = 12, text = "#ff0000" },
  { type = "RGB_COLOR", line = 1, col = 12, text = "rgb(255,0,0)" },
  { type = "HSL_COLOR", line = 2, col = 12, text = "hsl(120,100%,50%)" },
  { type = "HEX_COLOR", line = 3, col = 12, text = "#00ff00" },
}
--]]


return L;
