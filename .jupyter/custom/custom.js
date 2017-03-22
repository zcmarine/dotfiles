$([IPython.events]).on("app_initialized.NotebookApp", function () {

    IPython.keyboard_manager.command_shortcuts.add_shortcut('ctrl-k', function (event) {
        IPython.notebook.move_cell_up();
        return false;
    });

    IPython.keyboard_manager.command_shortcuts.add_shortcut('ctrl-j', function (event) {
        IPython.notebook.move_cell_down();
        return false;
    });

});