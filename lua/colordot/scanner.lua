local lexer = require ("colordot.lexer");
local parser = require ("colordot.parser");
local dump = require ("colordot.obj_dump");

local S = {};


local function valid_candidate (candidate)
  if not candidate then return false, "candidate: nil" end;
  if type (candidate) ~= "table" then return false, "candidate: not a table" end;
  if not candidate.start_col_num or not candidate.end_col_num or not candidate.lexeme then return false, "candidate: not all fields provided" end;
  if type (candidate.start_col_num) ~= "number" or type (candidate.start_col_num) ~= "number" then return false, "candidate: not valid column number" end;
  if type (candidate.lexeme) ~= "string" then return false, "candidate: not a valid lexeme" end;
  return true;
end

function S.scan (bufnr)
  local tokens = {};
  local lines = vim.api.nvim_buf_get_lines (bufnr, 0, -1, false);
  for lnum, line in ipairs (lines) do
    local lex = lexer:new (line);
    while lex.pos < #line do
      local token = nil;

      -- candidate: { lexeme, start_col_num, end_col_num }
      local candidate = lex:next();
      --if not candidate then --[[ do nothing --]] end;

      -- if candidate then dump (candidate, "candidate") end;

      --local ok, err = valid_candidate (candidate);
      --if not ok then print (err) end;

      -- token: { format, lexeme, color, start_col_num, end_col_num }
      token = valid_candidate (candidate) and parser.parse (candidate);
      --if candidate and not token then print (candidate.lexeme .. ": token not generated") end;

      if token and type (token) == "table" then
        -- extmark only supports 0-based index
        -- update 1-based to 0-based index to fix off-by-one issue
        token.line_num      = lnum - 1;
        token.start_col_num = token.start_col_num - 1;
        token.end_col_num   = token.end_col_num - 1;

        -- tokens [#tokens + 1] = token;
        table.insert (tokens, token);
      end
    end
  end
  return tokens;
end

--[[
local color_code = "#D05C6B";
--
{
  {
    line_number       = 32,
    column_number     = 21,
    end_column_number = 28,
    lexeme            = 'Color("#D05C6B")'
    color             = "#D05C6B"
  }
}
--]]

return S;
