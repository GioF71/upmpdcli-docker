# Copyright (C) 2021-2022 J.F.Dockes
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the
#   Free Software Foundation, Inc.,
#   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

import os
import subprocess
import threading

from upmplgutils import uplog, direntry
import conftree

class UpmpdcliRadios(object):
    def __init__(self, upconfig):
        datadir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
        if not os.path.isabs(datadir):
            datadir = "/usr/share/upmpdcli"
        self.fetchstream = os.path.join(datadir, "rdpl2stream", "fetchStream.py")
        self._radios = []
        self._readRadios(upconfig)
        #uplog("Radios: %s" % self._radios)

    def _fetchStream(self, index, title, uri, artUri, mime):
        uplog(f"upradios: Fetching {title}")
        streamUri=""
        try:
            streamUri = subprocess.check_output([self.fetchstream, uri])
            streamUri = streamUri.decode('utf-8').strip("\r\n")
        except Exception as ex:
            uplog("fetchStream.py failed for %s: %s" % (title, ex))
        if streamUri:
            self._radios[index] = (title, streamUri, uri, artUri, mime)
        
    def _readRadiosFromConf(self, conf):
        '''Read radio definitions from a config file (either main file or radiolist)'''
        keys = conf.getSubKeys_unsorted()
        threads = []
        cntt = 0
        for k in keys:
            if k.startswith("radio"):
                title = k[6:]
                uri = conf.get("url", k)
                artUri = conf.get("artUrl", k)
                mime = conf.get("mime", k)
                self._radios.append(None)
                idx = len(self._radios) - 1
                t = threading.Thread(target=self._fetchStream, args=(idx, title, uri, artUri, mime))
                t.start()
                threads.append(t)
                cntt += 1
                # Note that it's ok to join a thread multiple times, so we keep things simple
                if cntt >= self._maxthreads:
                    uplog(f"upradios: Waiting for threads")
                    for t in threads:
                        t.join()
                    uplog(f"upradios: Waiting done")
                    cntt = 0
        uplog(f"upradios: Waiting for threads")
        for t in threads:
            t.join()
        uplog(f"upradios: Waiting done")
        # Get rid of None entries in the list, keeping the order
        tlist = []
        for rd in self._radios:
            if rd:
                tlist.append(rd)
        self._radios = tlist
        uplog(f"upradios: Init done")
        
    def _readRadios(self, upconfig):
        '''Read radio definitions from main config file, then possible radiolist'''
        self._radios = []
        self._maxthreads = upconfig.get("upradiosmaxthreads")
        if self._maxthreads:
            self._maxthreads = int(self._maxthreads)
        else:
            self._maxthreads = 5
        self._readRadiosFromConf(upconfig)
        radiolist = upconfig.get("radiolist")
        if radiolist:
            radioconf = conftree.ConfSimple(radiolist)
            self._readRadiosFromConf(radioconf)


    def __iter__(self):
       return RadioIterator(self)

    # Note: not implementing __getitem__ because don't want to deal with slices, neg indexes etc.
    def get_radio(self, idx):
        if idx < 0 or idx > len(self._radios):
            raise(IndexError(f"bad radio index {idx}"))
        radio = self._radios[idx]
        return {"index" : idx, "title" : radio[0], "streamUri" : radio[1],
                "uri" : radio[2], "artUri" : radio[3], "mime": radio[4]}
       
class RadioIterator:
   def __init__(self, radios):
       self._radios = radios
       self._index = 0

   def __next__(self):
       if self._index < (len(self._radios._radios)):
           result = self._radios.get_radio(self._index)
           self._index +=1
           return result

       raise StopIteration            


def radioToEntry(pid, id, radio):
    #uplog(f"radioToEntry: pid {pid} id {id}")
    # if this comes from a 'browse meta', the id is set, else compute it
    if id is None:
        objid = pid
        if objid[-1] != "$":
            objid += "$"
        objid += "e" + str(radio["index"])
    else:
        objid = id
    if "mime" in radio and radio["mime"]:
        mime = radio["mime"]
    else:
        mime = "audio/mpeg"
    return {
        'pid': pid,
        'id': objid,
        'uri': radio["streamUri"],
        'tp': 'it',
        'res:mime': mime,
        'upnp:class': 'object.item.audioItem.musicTrack',
        'upnp:albumArtURI': radio["artUri"],
        'tt': radio["title"],
        # This is for Kodi mostly, to avoid displaying a big "Unknown" placeholder
        'upnp:artist': "Internet Radio"
    }

def radioIndexFromId(objid):
    stridx = objid.find("$e")
    if stridx == -1:
        raise Exception(f"Bad objid {objid}")
    return int(objid[stridx+2:])



if __name__ == "__main__":
    conf = conftree.ConfSimple("/etc/upmpdcli.conf", casesensitive=False)
    radios = UpmpdcliRadios(conf)
    for radio in radios:
        print("%s" % radio)
