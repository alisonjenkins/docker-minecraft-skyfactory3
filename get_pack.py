#!/usr/bin/python2.7
import json
import urllib2
import zipfile
import sys

def download_file(url, dest):# {{{
    with open(dest, 'wb') as destfile:
        data = urllib2.urlopen(url).read()
        destfile.write(data)# }}}
def unzip_file(zippath):# {{{
    with zipfile.ZipFile(zippath) as myzip:
        myzip.extractall()# }}}
def atlauncher_get_server_url(packname,version):# {{{
    data = urllib2.urlopen('https://api.atlauncher.com/v1/pack/%s/%s/' % (packname, version))
    pack_version = json.load(data)
    return pack_version['data']['serverZipURL']# }}}

destfile = 'minecraft.zip'

if sys.argv[1] == 'skyfactory':
    url = atlauncher_get_server_url('SkyFactory', 'latest')
    download_file(url, destfile)
    unzip_file(destfile)
elif sys.argv[1] == 'agrarianskies2':
    url = 'http://minecraft.curseforge.com/modpacks/225550-agrarian-skies-2/files/2241816/download'
    download_file(url, destfile)
    unzip_file(destfile)
elif sys.argv[1] == 'direwolf20':
    url = 'https://addons-origin.cursecdn.com/files/2272/696/FTBDirewolf20Server-1.10.0-1.7.10.zip'
    download_file(url, destfile)
    unzip_file(destfile)
if sys.argv[1] == 'skyfactory3':
    url = 'https://addons-origin.cursecdn.com/files/2373/70/FTBPresentsSkyfactory3Server_3.0.6.zip'
    download_file(url, destfile)
    unzip_file(destfile)
