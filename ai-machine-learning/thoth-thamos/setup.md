Before start using the Thamos let's setup the environment.

Next we could go ahead and install `Thamos CLI` -

``pip3 install thamos``{{execute}}


Now that all that is done, let's check what Thamos offer-

``thamos --help``{{execute}}

You should see something like this -<br>
![Thamos help](https://raw.githubusercontent.com/saisankargochhayat/katacoda-scenarios/master/thamos-cli/assets/thamos_help.png)

Bravo if you made it till here! We are almost done with the setup. 
Last step is cloning out our demo app - [Link](https://github.com/thoth-station/s2i-example)

``git clone https://github.com/thoth-station/s2i-example.git && cd s2i-example``{{execute}}

You can see all the files, that our sample repo contains in the Katacoda editor.

Now let's check out our sample application - 

``cat app.py``{{execute}}

And to check all the direct dependencies it needs using - 

``cat requirements.in``{{execute}}