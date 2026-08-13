local scanner = require ("colordot.scanner");
local decorator = require ("colordot.decorator");

local M = {}

function M.refresh (bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf();
  local tokens = scanner.scan (bufnr);
  decorator.render (bufnr, tokens);
end

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
