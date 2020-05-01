from naoqi import ALProxy

class Connect():
    def __init__(self):
        try:
            # add the automaticly find the ip addr
            self.tts = ALProxy("ALTextToSpeech", "192.168.0.182", 9599)
            self.tts.say("Hello, finished connecting.")
        except:
            print ("conneting error.")

if __name__ == "__main__":
    connect = Connect()
