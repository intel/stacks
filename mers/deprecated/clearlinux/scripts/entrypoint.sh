#!/usr/bin/env sh
# $0 is a script name, 
# $1, $2, $3 etc are passed arguments  # $1 is our command
CMD=$1

case "$CMD" in  
    "help" )
        # Display what user will see as help
		echo -e 'Execute docker run -it <this-image> <command> to execute extra argumets.\nE.g. docker run -it <this-image> <command> "ffmpeg -help && gst-launch-1.0 --version"'
		;;
	"start" ) 
	# we can modify files here, using ENV variables passed in 
	# "docker create" command. It can't be done during build process.
    echo -e "Use help to get more available options. E.g. docker run <this-image> help\n"
    exec /bin/bash
	;;

	* ) 
	 # Run custom command. Thanks to this line we can still use 
	 # "docker run this-image /bin/bash" and it will work, or any other command.
	 exec $CMD ${@:2}
	 ;; 
esac