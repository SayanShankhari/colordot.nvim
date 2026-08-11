local highlights = require ("colordot.highlights");

local D = {};
local SYMBOL = "⬤";

local namespace = vim.api.nvim_create_namespace ("ColorDot");
vim.api.nvim_set_hl (0, "ColorDotReset", {
  fg = vim.api.nvim_get_hl (0, { name = "Normal" }).fg,
  bg = vim.api.nvim_get_hl (0, { name = "Normal" }).bg,
});

function D.render (bufnr, tokens)
  vim.api.nvim_buf_clear_namespace (bufnr, namespace, 0, -1);
  for _, token in ipairs (tokens) do
    vim.api.nvim_buf_set_extmark (
      bufnr,
      namespace,
      token.line_num,
      token.start_col_num,
      {
        hl_group = "ColorDotReset",
        virt_text = {
          {
            SYMBOL,
            highlights.get (token.color),
          }
        },
        virt_text_pos = "inline",
      }
    );
  end
end

return D;
