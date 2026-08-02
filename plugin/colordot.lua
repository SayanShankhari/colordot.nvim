-- neovim automatically loads plugin/*.lua
--require("colordot").setup();

-- to avoid unnecessary bugs during development time
pcall(function()
  require("colordot").setup();
end);
