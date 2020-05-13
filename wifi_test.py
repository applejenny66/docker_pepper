# wifi-testing
#-*- coding: UTF-8 -*- 
import pywifi 
from pywifi import const
import time

def getwifi():
    wifi = pywifi.PyWiFi()
    ifaces = wifi.interfaces()[0]
    ifaces.scan()
    bessis = ifaces.scan_results()
    #print ("bessis: ", bessis)
    list_ = []
    list_wifi_name = []
    for data in bessis:
        
        list_.append((data.ssid, data.signal))
        #list_wifi_name.append()
    #print ("list: ", list_)
    return len(list_), sorted(list_, key=lambda st: st[1], \
        reverse = True)

def getsignal():
    while True:
        n, data = getwifi()
        time.sleep(1)
        if (n is not 0):
            #return data[0:10]
            return data

if __name__ == "__main__":
    print (getsignal())