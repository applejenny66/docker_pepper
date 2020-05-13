#from naoqi import ALProxy
#from qi import ALProxy
import qi

class Connect():
    def __init__(self):
        """
        try:
            print ("111")
            # add the automaticly find the ip addr
            self.tts = ALProxy("ALTextToSpeech", "192.168.0.189", 9599)
            print (self.tts)
            self.tts.say("Hello, finished connecting.")
        except:
            print ("conneting error.")
        
        s = qi.Session("tcp://127.0.0.1:9559")
        """
        s = qi.Session()
        print (s)
        addrs = "tcp://127.0.0.1:9559"
        s.connect(addrs)
        #foo = s.service("Foo")

        #self.tts = qi.ALProxy("ALTextToSpeech", "192.168.0.189", 9599)
        #print (self.tts)
        #self.tts.say("Hello, finished connecting.")
        
if __name__ == "__main__":
    connect = Connect()
