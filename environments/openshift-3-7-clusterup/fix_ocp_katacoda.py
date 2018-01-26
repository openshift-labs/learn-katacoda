#!/usr/bin/env python

import ruamel.yaml
import os
import socket
import fcntl
import struct

# https://stackoverflow.com/questions/24196932/how-can-i-get-the-ip-address-of-eth0-in-python/30990617
def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

file_name = '/katacoda/config/master/master-config.yaml'
from ruamel.yaml.util import load_yaml_guess_indent

config, ind, bsi = load_yaml_guess_indent(open(file_name))

katacodaid = os.environ['KATACODA_HOST_SUBDOMAIN']
katacodahost = os.environ['KATACODA_HOST']
externalip = os.environ['EXTERNALIP'].replace(".","\.")

masterpublicurl = "https://"+katacodaid+"-8443-"+katacodahost+".environments.katacoda.com"
publicurl = masterpublicurl + "/console/"
internalip = get_ip_address('eth0').replace(".","\.")

config['assetConfig']['masterPublicURL'] = masterpublicurl
config['assetConfig']['publicURL'] = publicurl
config['corsAllowedOrigins'].append("//"+katacodaid+"-8443-"+katacodahost+"\.environments\.katacoda\.com:443$")
config['corsAllowedOrigins'].append("//"+katacodaid+"-8443-"+katacodahost+"\.environments\.katacoda\.com$")
config['corsAllowedOrigins'].append("//"+internalip+"(:|$)")
config['corsAllowedOrigins'].append("//"+externalip+"(:|$)")
config['masterPublicURL'] = masterpublicurl
config['oauthConfig']['masterPublicURL'] = masterpublicurl
config['oauthConfig']['assetPublicURL'] = publicurl
config['routingConfig']['subdomain'] = katacodaid+"-80-"+katacodahost+".environments.katacoda.com"

ruamel.yaml.round_trip_dump(config, open('/katacoda/config/master/master-config.yaml', 'w'), 
                            indent=ind, block_seq_indent=bsi)
