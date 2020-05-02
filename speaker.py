#! /usr/bin/env python
# -*- encoding: UTF-8 -*-

import qi
import argparse
import sys
import time
import numpy as np


class Speaker(object):
    def __init__(self, app):
        super(Speaker, self).__init__()
        app.start()
        session = app.session
        self.speaker = session.service("ALTextToSpeech")
        self.speaker.setLanguage("Chinese")
        
    def speak(self, words):
        self.speaker.say(words)
    
    def changeSpeed(self, speed):
        self.speaker.setParameter("speed", speed)
    
    def changePitch(self, pitch):
        self.speaker.setParameter("pitchShift", pitch)

    def changeLanguage(self, language):
        self.speaker.setLanguage(language)

    def others(self):
        """
        1.change the pitch before sentence: 50~200. default:100
        tts.say("\\vct=150\\Hello my friends")

        2.change the speaking rate: 50~400. default:100
        tts.say("\\rspd=50\\hello my friends")

        3.insert a pause
        tts.say("Hello my friends \\pau=1000\\ how are you ?")

        4.change the volume: 0~100. default:80
        tts.say("\\vol=50\\Hello my friends")

        5.insert a bookmark: 0~64535
        tts.say("\\mrk=0\\ I say a sentence.\\mrk=1\\ And a second one.")
        
        6.reset to origin: rst
        tts.say("\\vct=150\\\\rspd=50\\Hello my friends.\\rst\\ How are you ?")
        
        7.set word prominence level:
        0: reduced
        1: stressed
        2: accented
        tts.say("\\emph=0\\ There is a total of 32 apples and 12 oranges")
        tts.say("\\emph=1\\ There is a total of 32 apples and 12 oranges")
        tts.say("\\emph=2\\ There is a total of 32 apples and 12 oranges")
        
        8.control end of sentence detection:
        0: suppress a sentence break -> no break
        1: force a sentence break -> have break
        tts.say("Hello my friends.\\eos=0\\How are you ?") # no break
        tts.say("Hello my friends.\\eos=1\\How are you ?") # break

        9.read mode
        sent: default
        char: spell
        word: word by word
        tts.say("\\readmode=sent\\ Hello my friends")
        tts.say("\\readmode=char\\ Hello my friends")
        tts.say("\\readmode=word\\ Hello my friends")
        
        10.insert a digital audio recording:
        tts.say("\\audio=\"/usr/share/naoqi/wav/0.wav\"\\")

        11.change the speaking style
        tts.say("\\style=joyful\\ Today I am feeling happy.")
        tts.say("\\style=didactic\\ I can explain you how my ears work.")
        tts.say("\\style=neutral\\ Everything is normal.")
        """
        pass






if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", type=str, default="127.0.0.1",
                        help="Robot IP address. On robot or Local Naoqi: use '127.0.0.1'.")
    parser.add_argument("--port", type=int, default=9559,
                        help="Naoqi port number")

    args = parser.parse_args()
    try:
        # Initialize qi framework.
        connection_url = "tcp://" + args.ip + ":" + str(args.port)
        app = qi.Application(["SoundProcessingModule", "--qi-url=" + connection_url])
    except RuntimeError:
        print ("Can't connect to Naoqi at ip \"" + args.ip + "\" on port " + str(args.port) +".\n"
               "Please check your script arguments. Run with -h option for help.")
        sys.exit(1)
    MySpeaker= Speaker(app)
    MySpeaker.speak(words="")
    #app.session.registerService("SoundProcessingModule", MySoundProcessingModule)
    #MySound.startProcessing()