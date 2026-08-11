local colorlib = require ("colorlib");
local registry = colorlib.registry;
local Color    = colorlib.Color;
local dump     = colorlib.dump;

local P = {};


local patterns = {
  [ registry.Profile.xRGB ]  = '^Color%("' .. registry.Patterns [ registry.Profile.xRGB ]  .. '"%)[,;]*$';
  [ registry.Profile.mxRGB ] = '^Color%("' .. registry.Patterns [ registry.Profile.mxRGB ] .. '"%)[,;]*$';
  [ registry.Profile.RGB ]   = '^Color%("' .. registry.Patterns [ registry.Profile.RGB ]   .. '"%)[,;]*$';
  [ registry.Profile.sRGB ]  = '^Color%("' .. registry.Patterns [ registry.Profile.sRGB ]  .. '"%)[,;]*$';
  [ registry.Profile.lRGB ]  = '^Color%("' .. registry.Patterns [ registry.Profile.lRGB ]  .. '"%)[,;]*$';
  [ registry.Profile.HSL ]   = '^Color%("' .. registry.Patterns [ registry.Profile.HSL ]   .. '"%)[,;]*$';
  [ registry.Profile.nHSL ]  = '^Color%("' .. registry.Patterns [ registry.Profile.nHSL ]  .. '"%)[,;]*$';
  [ registry.Profile.OkLCH ] = '^Color%("' .. registry.Patterns [ registry.Profile.OkLCH ] .. '"%)[,;]*$';
};

function P.parse (candidate)
  for profile, pattern in pairs (patterns) do
    if candidate.lexeme:match (pattern) then
      -- remove any trailing character like comma/semicolon
      local lex, _ = candidate.lexeme:gsub(",$", "");
      lex, _ = lex:gsub(";$", "");

      -- unwrap the expression string from Color interface
      lex = lex:match ('^Color%("([^"]+)"%)$');

      local hex_col = Color (lex, profile);
      hex_col = hex_col or "#000000";

      return {
        format        = profile,
        lexeme        = candidate.lexeme,
        color         = hex_col,
        line_num      = candidate.line_num,
        start_col_num = candidate.start_col_num,
        end_col_num   = candidate.end_col_num,
      };
    end
  end

  -- if no pattern matched
  return nil, "no pattern matched";
end


return P;
