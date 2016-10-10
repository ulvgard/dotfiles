# Monitor setup chain

To configure the WM monitor layout for different workstations, this chain 
of configurations is employed to properly configure X and the window manager.

* Monitor setup 
* Window Manager setup
* Window Manager tools setup (bar, system monitoring etc.)

In effect, this chain calls the following scripts

1. msetup.sh
2. wmsetup.sh
3. toolssetup.sh

with similar scripts for resetting e.g. using a laptop screen:

1. mteardown.sh
2. wmteardown.sh
3. toolsteardown.sh

# Scripts are located under each branch

To find the setup and teardown scripts for each host, 
checkout the corresponding branch.
