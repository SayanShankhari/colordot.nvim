local P = {};


-- keep the PATTERNS biggest to smallest string
local PATTERNS = {
  {
    format = "COLOR_xRGB",
    pattern = "^#%x%x%x%x%x%x$",
    convert = function (lexeme)
      return lexeme:lower();
    end,
  },
  {
    format = "COLOR_SHORT_xRGB",
    pattern = "^#%x%x%x$",
    convert = function (lexeme)
      local r, g, b = lexeme:match ("^#(%x)(%x)(%x)$");
      return string.format ("#%s%s%s%s%s%s", r,r, g,g, b,b):lower();
    end,
  },
 {
    format = "COLOR_RGB",
    pattern = "^[rR][gG][bB]%((%d+),(%d+),(%d+)%)$",
    convert = function (lexeme)
      local r, g, b = lexeme:match ("^[rR][gG][bB]%((%d+),(%d+),(%d+)%)$");
      r, g, b = r % 255, g % 255, b % 255;
      return string.format ("#%02x%02x%02x", r, g, b);
    end,
  },
 {
    format = "COLOR_sRGB",
    pattern = "^s[rR][gG][bB]%(([%d%.]+),([%d%.]+),([%d%.]+)%)$",
    convert = function (lexeme)
      local sr_str, sg_str, sb_str = lexeme:match ("^s[rR][gG][bB]%(([%d%.]+),([%d%.]+),([%d%.]+)%)$");
      local sr = tonumber (sr_str);
      local sg = tonumber (sg_str);
      local sb = tonumber (sb_str);
      local r = math.floor (255 * sr) & 0xff;
      local g = math.floor (255 * sg) & 0xff;
      local b = math.floor (255 * sb) & 0xff;
      return string.format ("#%02x%02x%02x", r, g, b);
    end,
  },
  {
    format = "COLOR_lRGB",
    pattern = "^l[rR][gG][bB]%(([%d%.]+),([%d%.]+),([%d%.]+)%)$",
    convert = function (lexeme)
      local lr_str, lg_str, lb_str = lexeme:match ("^l[rR][gG][bB]%(([%d%.]+),([%d%.]+),([%d%.]+)%)$");
      local lr = tonumber (lr_str);
      local lg = tonumber (lg_str);
      local lb = tonumber (lb_str);
      local r = math.floor (255 * lr) & 0xff;
      local g = math.floor (255 * lg) & 0xff;
      local b = math.floor (255 * lb) & 0xff;
      return string.format ("#%02x%02x%02x", r, g, b);
    end,
  },
};

function P.parse (candidate)
  for _, parser in ipairs (PATTERNS) do
    if candidate.lexeme:match (parser.pattern) then
      -- return token
      return {
        format        = parser.format,
        lexeme        = candidate.lexeme,
        color         = parser.convert (candidate.lexeme),
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
