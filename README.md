# RaspberryPi_omxplayer_control_script
Script which uses a control file to play videos from a directory using omxplayer.

I required a quick script to control video adverts from another application for a demo. 
I had previously been using mplayer embedded into the application using the -wid option and mplayers powerful slave protocol controls, however was moving project to Raspberry Pi and mplayer ran videos poorly.

RPi has the omxplayer application which runs great, but lacks mplayers useful options SO this script was put together to enable some control for the demo. I thought I'd share it in case someone finds it useful. 

General usage is your main application will write p or q to the specified control file and all the script does is checks this control file for p or q.

If p then if omxplayer isn't already playing then it will select the next file from the media directory and launch the application.
If q then it will simply kill omxplayer if it's currently running. 


