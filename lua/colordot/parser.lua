local P = {};

local colorlib = require ("colorlib");

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
      local xr, xg, xb = lexeme:match ("^#(%x)(%x)(%x)$");
      local xrgb = string.format ("#%s%s%s%s%s%s", xr,xr, xg,xg, xb,xb):lower();
      local color = {
        metadata = { profile = colorlib.registry.Profile.xRGB, bit_depth = 8 },
        channels = { xrgb = xrgb },
      };
      if colorlib.valid (color) then return xrgb end;
    end,
  },
 {
    format = "COLOR_RGB",
    pattern = "^[rR][gG][bB]%((%d+),(%d+),(%d+)%)$",
    convert = function (lexeme)
      local r, g, b = lexeme:match ("^[rR][gG][bB]%((%d+),(%d+),(%d+)%)$");
      r, g, b = r % 256, g % 256, b % 256;
      local color = {
        metadata = { profile = colorlib.registry.Profile.RGB, bit_depth = 8 },
        channels = { r = r, g = g, b = b },
      };
      if colorlib.valid (color) then
        local xrgb = colorlib.conversions.rgb_to_xrgb (r, g, b);
        return xrgb;
      end
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
      local color = {
        metadata = { profile = colorlib.registry.Profile.sRGB },
        channels = { sr = sr, sg = sg, sb = sb },
      };
      if colorlib.valid (color) then
        local xrgb = colorlib.conversions.srgb_to_xrgb (sr, sg, sb);
        return xrgb;
      else
        return "#000000";
      end
    end,
  },
  {
    format = "COLOR_lRGB",
    pattern = "^l[rR][gG][bB]%(([%d%.]+%%?),([%d%.]+%%?),([%d%.]+%%?)%)$",
    convert = function (lexeme)
      local lr_str, lg_str, lb_str = lexeme:match ("^l[rR][gG][bB]%(([%d%.]+%%?),([%d%.]+%%?),([%d%.]+%%?)%)$");
      local lr = tonumber (lr_str);
      local lg = tonumber (lg_str);
      local lb = tonumber (lb_str);
      local color = {
        metadata = { profile = colorlib.registry.Profile.lRGB },
        channels = { lr = lr, lg = lg, lb = lb },
      };
      if colorlib.valid (color) then
        local xrgb = colorlib.conversions.lrgb_to_xrgb (lr, lg, lb);
        return xrgb;
      else
        return "#000000";
      end
    end,
  },
  {
    format = "COLOR_HSL",
    pattern = "^[hH][sS][lL]%((%d+%.?%d*),(%d+%.?%d*%%?),(%d+%.?%d*%%?)%)$",
    convert = function (lexeme)
      local h_str, s_str, l_str = lexeme:match ("^[hH][sS][lL]%((%d+%.?%d*),(%d+%.?%d*%%?),(%d+%.?%d*%%?)%)$");
      s_str, _ = s_str:gsub ("%%$", "");
      l_str, _ = l_str:gsub ("%%$", "");
      local h = tonumber (h_str);
      local s = tonumber (s_str);
      local l = tonumber (l_str);
      local color = {
        metadata = { profile = colorlib.registry.Profile.HSL },
        channels = { h = h, s = s, l = l },
      };
      if colorlib.valid (color) then
        local xrgb = colorlib.conversions.hsl_to_xrgb (h, s, l);
        return xrgb;
      else
        return "#000000";
      end
    end,
  },
  {
    format = "COLOR_nHSL",
    pattern = "^n[hH][sS][lL]%((%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)%)$",
    convert = function (lexeme)
      local nh_str, ns_str, nl_str = lexeme:match ("^n[hH][sS][lL]%((%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)%)$");
      local nh = tonumber (nh_str);
      local ns = tonumber (ns_str);
      local nl = tonumber (nl_str);
      local color = {
        metadata = { profile = colorlib.registry.Profile.nHSL },
        channels = { nh = nh, ns = ns, nl = nl },
      };
      if colorlib.valid (color) then
        local xrgb = colorlib.conversions.nhsl_to_xrgb (nh, ns, nl);
        return xrgb;
      else
        return "#000000";
      end
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
