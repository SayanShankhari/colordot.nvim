local colorlib_path = os.getenv ("COLORLIB_PATH");
if not colorlib_path then error ("COLORLIB_PATH environment path variable not set", 2) end;

-- LOCAL DEPLOYMENT:-
-- 2.1. using runtime path to run locally
-- attach directly to runtime path
vim.opt.rtp:append (colorlib_path);

-- Append the sub-project directory to Lua's search paths
-- ';' splits different paths, and '?' acts as a wildcard for the module name
package.path = package.path .. ";" .. colorlib_path .. "/init.lua";

local scanner = require ("colordot.scanner");
local decorator = require ("colordot.decorator");

local M = {}

function M.refresh (bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf();
  local tokens = scanner.scan (bufnr);
  decorator.render (bufnr, tokens);
end


--[[
vim.pack.add (
  {
    {
      src = "file:///home/sayan/Projects/colorlib",
      name = "colorlib",
    },
  }
);
--]]


function M.setup()
  local group = vim.api.nvim_create_augroup (
      "ColorDot",
      { clear = true }
  );

  vim.api.nvim_create_autocmd (
    {
      "BufEnter",
      "TextChanged",
      "TextChangedI",
    }, {
      group = group,
      callback = function (args)
        M.refresh (args.buf);
      end,
    }
  );
end

-- command: require ("colordot").setup()


return M;
