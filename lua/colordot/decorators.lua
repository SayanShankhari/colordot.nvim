local highlights = require ("colordot.highlights");

local D = {};

local namespace = vim.api.nvim_create_namespace ("ColorDot");

function D.render (bufnr, tokens)
  vim.api.nvim_buf_clear_namespace (bufnr, namespace, 0, -1);
  for _, token in ipairs (tokens) do
    vim.api.nvim_buf_set_extmark (
      bufnr,
      namespace,
      token.line_number,
      token.column_number,
      {
        virt_text = {
          {
            "⬤ ",
            highlights.get (token.color),
          }
        },
        virt_text_pos = "inline",
      }
    );
  end
end

return D;
