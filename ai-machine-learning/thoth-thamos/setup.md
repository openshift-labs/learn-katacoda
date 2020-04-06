Before start using the Thamos let's setup the environment.

This image comes with Python2 so we are going to install Python3 -

``yum install python3``{{execute}}

Next we could go ahead and install `Thamos CLI` -

``pip3 install thamos``{{execute}}

And finally just export the locale to prevent click errors - 

``export LC_ALL=en_US.utf8 export LANG=en_US.utf8``{{execute}}

More on that here, if you want to know why we do this - [link](http://click.palletsprojects.com/en/5.x/python3/)

Now that all that is done, let's check what Thamos offer-

``thamos --help``{{execute}}

You should see something like this -
![Thamos help](https://raw.githubusercontent.com/saisankargochhayat/katacoda-scenarios/master/thamos-cli/assets/thamos_help.png)

Bravo if you made it till here! We are almost done with the setup. 
Last step is cloning out demo app - [Link](https://github.com/thoth-station/s2i-example)

``git clone https://github.com/thoth-station/s2i-example.git && cd s2i-example``{{execute}}

You can see all the files, that our sample repo contains in the Katacoda editor.