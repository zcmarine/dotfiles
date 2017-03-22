# Make global site packages accessible to IPython from within a virtualenv
import os
import sys

sys.path.append(
    os.path.expanduser('~/Library/Python/2.7/lib/python/site-packages/')
)


# IPython customization
c = get_config()
c.TerminalInteractiveShell.simple_prompt = False
c.TerminalIPythonApp.display_banner = False

from powerline.bindings.ipython.since_5 import PowerlinePrompts
c.TerminalInteractiveShell.prompts_class = PowerlinePrompts


# To use these settings as the base for another profile, put the following at the top of that
# profile's ipython_config.py:
#    load_subconfig('ipython_config.py', profile='default')
