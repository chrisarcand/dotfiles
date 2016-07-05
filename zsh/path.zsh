case $(uname) in
  'Darwin')
    # I hardcode the intial path so that tmux doesn't fuck it up and append duplicates
    # Also allows you to `reload` without constantly appending to your path
    export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin
    ;;
  'Linux')
    ;;
esac

export PATH=$PATH:$HOME/bin # ~/bin
export PATH=$PATH:/usr/local/heroku/bin # Heroku toolbelt MOVE TO TOPIC LATER
export PATH=$PATH:/usr/local/mysql/bin #MySQL MOVE TO TOPIC LATER

