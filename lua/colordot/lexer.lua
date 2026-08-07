local L = {};
L.__index = L;


function L:new (line)
  return setmetatable ({
    line = line,
    pos = 1,
  }, self);
end

-- %w          # %( %) , %. %% %- _
-- A-Z/a-z/0-9 # (  )  , .  %  -  _
local CANDIDATE_CHAR = "[%w#%(%),%.%%%-_]";

function L:next()
  local line = self.line;
  local len = #line;

  -- skip delimeters
  while self.pos <= len do
    local char = line:sub (self.pos, self.pos); -- single chacter string
    if char:match (CANDIDATE_CHAR) then break end;
    self.pos = self.pos + 1;
  end

  -- exit if start point not found
  if self.pos > len then return nil end;

  -- keep track of Start point
  local start = self.pos;

  -- read until next delimeter
  while self.pos <= len do
    local char = line:sub (self.pos, self.pos);
    if not char:match (CANDIDATE_CHAR) then break end;
    self.pos = self.pos + 1;
  end

  local finish = self.pos - 1; -- already walked one character ahead

  return {
    -- format = "HEX_COLOR", -- profile unknown
    lexeme = self.line:sub (start, finish),
    start_col_num = start,
    end_col_num = finish,
  };
end

--[[
Inputs:-
local c1 = "#ff0000"
local c2 = rgb(255,0,0)
local c3 = hsl(120,100%,50%)

Output:-
{ start_col_num = 12, end_col_num = 19, lexeme = "#ff0000" }
{ start_col_num = 12, end_col_num = 23, lexeme = "rgb(255,0,0)" }
{ start_col_num = 12, end_col_num = 28, lexeme = "hsl(120,100%,50%)" }
--]]


return L;
