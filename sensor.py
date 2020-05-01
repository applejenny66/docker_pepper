#! /usr/bin/env python
# -*- encoding: UTF-8 -*-

"""Example: Demonstrates how to record a video file on the robot"""

import qi
import argparse
import sys
import time

class Video():
    def __init__(self, session):
        self.session = session
        self.video_recorder_service = self.session("ALVideoRecorder") 
        # This records a 320*240 MJPG video at 10 fps.
        # Note MJPG can't be recorded with a framerate lower than 3 fps.
        self.video_recorder_service.setResolution(1)
        self.video_recorder_service.setFrameRate(10)
        self.video_recorder_service.setVideoFormat("MJPG")
        try:
            self.video_recorder_service.startRecording("/home/nao/recordings/cameras", "myvideo")
            time.sleep(5)
            self.videoInfo = self.video_recorder_service.stopRecording()
            print ("Initially Success. Video was saved on the robot: ", self.videoInfo[1])
            print ("Num frames: ", self.videoInfo[0])
        except:
            print ("video recording has some problems.")



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", type=str, default="127.0.0.1",
                        help="Robot IP address. On robot or Local Naoqi: use '127.0.0.1'.")
    parser.add_argument("--port", type=int, default=9559,
                        help="Naoqi port number")

    args = parser.parse_args()
    session = qi.Session()
    try:
        session.connect("tcp://" + args.ip + ":" + str(args.port))
    except RuntimeError:
        print ("Can't connect to Naoqi at ip \"" + args.ip + "\" on port " + str(args.port) +".\n"
               "Please check your script arguments. Run with -h option for help.")
        sys.exit(1)
    sensor = Video(session = session)