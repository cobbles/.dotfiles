return {
    'goolord/alpha-nvim',
    dependencies = {
        'nvim-mini/mini.icons',
        'nvim-lua/plenary.nvim'
    },
    config = function ()
        local dashboard = require'alpha.themes.dashboard'
        -- Set header
        dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
        }
        -- Set menu
        dashboard.section.buttons.val = {
            dashboard.button( "space g", "  > Search" , ""),
            dashboard.button( "space f", "  > Find File", ""),
            dashboard.button( "o", "  > File Tree", ":Oil<CR>"),
            dashboard.button( "p", "  > Plugins", ":Lazy<CR>"),
            dashboard.button( "l", "  > LSPs", ":Mason<CR>"),
            dashboard.button( "space ?", "󰋗  > Help" , ""),
            dashboard.button( "q", "󰩈  > Quit", ":q<CR>"),
        }
        require'alpha'.setup(dashboard.config)
    end
};
