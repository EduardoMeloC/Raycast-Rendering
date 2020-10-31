Window = {
    width = 1000,
    height = 1000,
    flags = { borderless = true }
}

--[[
    The flags table with the options:

    boolean fullscreen (false)
        Fullscreen (true), or windowed (false).
    FullscreenType fullscreentype ("desktop")
        The type of fullscreen to use. This defaults to "normal" in 0.9.0 through 0.9.2 and to "desktop" in 0.10.0 and older.
    number vsync (1)
        Enables or disables vertical synchronisation ('vsync') - 1 to enable vsync, 0 to disable it, and -1 to use adaptive vsync (where supported). Prior to 11.0 this was a boolean flag, rather than a number.
    number msaa (0)
        The number of antialiasing samples.
    boolean stencil (true)
        Whether a stencil buffer should be allocated. If true, the stencil buffer will have 8 bits.
    number depth (0)
        The number of bits in the depth buffer.
    boolean resizable (false)
        True if the window should be resizable in windowed mode, false otherwise.
    boolean borderless (false)
        True if the window should be borderless in windowed mode, false otherwise.
    boolean centered (true)
        True if the window should be centered in windowed mode, false otherwise.
    number display (1)
        The index of the display to show the window in, if multiple monitors are available.
    number minwidth (1)
        The minimum width of the window, if it's resizable. Cannot be less than 1.
    number minheight (1)
        The minimum height of the window, if it's resizable. Cannot be less than 1.
]]
