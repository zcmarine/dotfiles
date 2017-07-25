-- From here: https://github.com/lodestone/hyper-hacks
-- You'll also have to install Karabiner Elements and map a key to F18 (I used right_command)

-------------------------------------------------------
---------- SET UP THE HYPER KEY -----------------------
-------------------------------------------------------

-- Define a global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- Enter Hyper Mode when F18 (right_command) is pressed
pressedF18 = function() k:enter() end

-- Leave Hyper Mode when F18 (right_command) is pressed
releasedF18 = function() k:exit() end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)


-------------------------------------------------------
---------- SET UP SHORCUTS ----------------------------
-------------------------------------------------------

-- r for reload config
k:bind('', 'r', nil, function() hs.reload() end)

app_config = {
        ['c'] = 'Google Chrome',
        ['e'] = 'Evernote',
        ['f'] = 'Finder',
         -- ['i'] = 'iTerm2',
        ['s'] = 'Slack',
}
for key, application in pairs(app_config) do
    k:bind('', key, nil, function() hs.application.launchOrFocus(application) end)
end


url_config = {
	['b'] = 'https://bamboo.nyc.squarespace.net/myBamboo.action',
	['d'] = 'https://stash.nyc.squarespace.net/projects/DATA',
	['g'] = 'https://mail.google.com/mail/u/0/#inbox',
	['h'] = 'https://hub.squarespace.net/#/',
	['j'] = 'https://jira.squarespace.net/secure/Dashboard.jspa',
	['t'] = 'https://stash.nyc.squarespace.net/projects/STRAT',
	['p'] = 'https://stash.nyc.squarespace.net/projects/DATA/repos/pyline/browse',
}
for key, url in pairs(url_config) do
    k:bind('', key, nil, function()
        news = string.format("app = Application.currentApplication(); app.includeStandardAdditions = true; app.doShellScript('open %s')", url)
        hs.osascript.javascript(news)
	end)
end


-- G for open gmail 1
k:bind('shift', 'g', nil, function()
  news = "app = Application.currentApplication(); app.includeStandardAdditions = true; app.doShellScript('open https://mail.google.com/mail/u/1/#inbox')"
  hs.osascript.javascript(news)
end
)

