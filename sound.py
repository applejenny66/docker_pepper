#! /usr/bin/env python
# -*- encoding: UTF-8 -*-

import qi
import argparse
import sys
import time
import numpy as np


class Sound(object):
    def __init__(self, app):
        super(Sound, self).__init__()
        app.start()
        session = app.session
        self.audio_service = session.service("ALAudioRecorder")
        self.asr_service = session.service("ALSpeechRecognition")
        self.asr_service.setLanguage("Chinese") #English
        #self.sound_detect_service = session.service("ALSoundDetection")
        #self.sound_detect_service.setParameter("Sensitivity", 0.5) #0:no sound; 1:the most sensitivity
        #self.isProcessingDone = False
        #self.nbOfFramesToProcess = 20
        self.framesCount=0
        self.micFront = []
        #self.module_name = "SoundProcessingModule"

    def asr(self):
        self.asr_service.subscribe("applejenny") #user name
        time.sleep(20)
        # how to depend the time period?
        self.asr_service.unsubscribe("applejenny")

    def soundDetect(self):
        pass

    def startRecording(self):
        # if you want the 4 channels call setClientPreferences(self.module_name, 48000, 0, 0)
        #self.audio_service.setClientPreferences(self.module_name, 16000, 3, 0)
        #self.audio_service.subscribe(self.module_name)
        #param = (filename, type – “wav” or “ogg”, samplerate – 16000-48000, channels)
        self.audio_service.startMicrophonesRecording("/home/nao/sound_record/test.wav", "wav", 16000, channels) #channels?
        time.sleep(5)
        self.audio_service.stopMicrophonesRecording()

        #while self.isProcessingDone == False:
        #    time.sleep(1)

        #self.audio_service.unsubscribe(self.module_name)

    """
    def processRemote(self, nbOfChannels, nbOfSamplesByChannel, timeStamp, inputBuffer):
        """
        #Compute RMS from mic.
        """
        self.framesCount = self.framesCount + 1

        if (self.framesCount <= self.nbOfFramesToProcess):
            # convert inputBuffer to signed integer as it is interpreted as a string by python
            self.micFront=self.convertStr2SignedInt(inputBuffer)
            #compute the rms level on front mic
            rmsMicFront = self.calcRMSLevel(self.micFront)
            print ("rms level mic front = " + str(rmsMicFront))
        else :
            self.isProcessingDone=True

    def calcRMSLevel(self,data) :
        """
        #Calculate RMS level
        """
        rms = 20 * np.log10( np.sqrt( np.sum( np.power(data,2) / len(data)  )))
        return rms

    def convertStr2SignedInt(self, data) :
        """
        #This function takes a string containing 16 bits little endian sound
        #samples as input and returns a vector containing the 16 bits sound
        #samples values converted between -1 and 1.
        """
        signedData=[]
        ind=0
        for i in range (0,len(data)/2) :
            signedData.append(data[ind]+data[ind+1]*256)
            ind=ind+2

        for i in range (0,len(signedData)) :
            if signedData[i]>=32768 :
                signedData[i]=signedData[i]-65536

        for i in range (0,len(signedData)) :
            signedData[i]=signedData[i]/32768.0

        return signedData
    """

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
    MySound= Sound(app)
    #app.session.registerService("SoundProcessingModule", MySoundProcessingModule)
    #MySound.startProcessing()