return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",

    "hrsh7th/cmp-nvim-lsp-signature-help", -- подсказка параметров функции прямо в строке
    "onsails/lspkind.nvim",                 -- иконки как в IntelliJ
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- как в GoLand: иконка + тип + имя
          maxwidth = 60,
          ellipsis_char = "...",
        }),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),      -- как Ctrl+Space в GoLand
        ["<CR>"]      = cmp.mapping.confirm({ select = false }), -- только явный выбор
        ["<C-e>"]     = cmp.mapping.abort(),

        -- Улучшенная навигация без Tab/S-Tab (они теперь для буферов)
        ["<C-n>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          end
        end, { "i", "s" }),

        ["<C-p>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end, { "i", "s" }),

        -- Стрелки для навигации по автодополнению
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<Up>"]   = cmp.mapping.select_prev_item(),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp",               priority = 1000 },
        { name = "nvim_lsp_signature_help", priority = 900 }, -- параметры функции
        { name = "luasnip",                priority = 800 },
        { name = "buffer",                 priority = 500 },
        { name = "path",                   priority = 250 },
      }),

      -- Сортировка как в GoLand: сначала по релевантности LSP, потом по локальности
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    })

    -- Подсказка параметров функции (то, что в GoLand появляется серым текстом в строке)
    require("cmp").setup.filetype({ "go" }, {
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" }, -- вот эта магия
      })
    })
  end,
}
