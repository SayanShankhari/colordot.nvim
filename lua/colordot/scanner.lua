local lexer = require ("colordot.lexer");

local S = {};

function S.scan (bufnr)
  local tokens = {};
  local lines = vim.api.nvim_buf_get_lines (bufnr, 0, -1, false);
  for lnum, line in ipairs (lines) do
    local lex = lexer:new (line);
    while true do
      local token = lex:next();
      if not token then break end;

      -- extmark only supports 0-based index
      -- update 1-based to 0-based index to fix off-by-one issue
      token.line_number = lnum - 1;
      token.column_number = token.column_number - 1;
      token.end_column_number = token.end_column_number - 1;

      -- calculated color value
      -- TODO: do function mapping from lexeme
      token.color = token.lexeme;

      --tokens [#tokens + 1] = token;
      table.insert (tokens, token);
    end
  end
  return tokens;
end

--[[
{
  {
    line = 12,
    col = 18,
    end_col = 24,
    hex = "#D05C6B"
  }
}
--]]

return S;
