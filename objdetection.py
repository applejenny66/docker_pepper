import qi
import time
import numpy as np
import cv2
import argparse
import imutils
import os

class YOLO():
    def __init__(self, istiny = False):
        # loading the yolo & network 
        if (istiny == True):
            self.net = cv2.dnn.readNet("./darknet/yolov3-tiny.weights", "./darknet/cfg/yolov3-tiny.cfg")
        else:
            self.net = cv2.dnn.readNet("./darknet/yolov3.weights", "./darknet/cfg/yolov3.cfg")
        self.classes = []
        # Load Yolo

        with open("./darknet/data/coco.names", "r") as f:
            self.classes = [line.strip() for line in f.readlines()]
        layer_names = self.net.getLayerNames()
        self.output_layers = [layer_names[i[0] - 1] for i in self.net.getUnconnectedOutLayers()]
        self.colors = np.random.uniform(0, 255, size=(len(self.classes), 3))
    
    def useWebcam(self):
        # Loading webcam(camera on computer)
        try:
            self.cap = cv2.VideoCapture(0)
        except:
            try:
                self.cap = cv2.VideoCapture(1)
            except:
                print ("Webcam has some problems. Please check the device.")
        self.font = cv2.FONT_HERSHEY_PLAIN
        self.starting_time = time.time()
        self.frame_id = 0

    def detectingWebcam(self):
        while True:
            _, frame = self.cap.read()
            self.frame_id += 1
            self.height, self.width, self.channels = frame.shape
            # Detecting objects
            blob = cv2.dnn.blobFromImage(frame, 0.00392, (416, 416), (0, 0, 0), True, crop=False)
            self.net.setInput(blob)
            outs = self.net.forward(self.output_layers)
            # Showing informations on the screen
            class_ids = []
            confidences = []
            boxes = []
            for out in outs:
                for detection in out:
                    scores = detection[5:]
                    class_id = np.argmax(scores)
                    confidence = scores[class_id]
                    if confidence > 0.2:
                        # Object detected
                        center_x = int(detection[0] * self.width)
                        center_y = int(detection[1] * self.height)
                        w = int(detection[2] * self.width)
                        h = int(detection[3] * self.height)
                        # Rectangle coordinates
                        x = int(center_x - w / 2)
                        y = int(center_y - h / 2)
                        boxes.append([x, y, w, h])
                        confidences.append(float(confidence))
                        class_ids.append(class_id)
            indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.4, 0.3)
            for i in range(len(boxes)):
                if i in indexes:
                    x, y, w, h = boxes[i]
                    label = str(self.classes[class_ids[i]])
                    confidence = confidences[i]
                    color = self.colors[class_ids[i]]
                    cv2.rectangle(frame, (x, y), (x + w, y + h), color, 2)
                    cv2.rectangle(frame, (x, y), (x + w, y + 30), color, -1)
                    cv2.putText(frame, label + " " + str(round(confidence, 2)), (x, y + 30), self.font, 3, (255,255,255), 3)
            elapsed_time = time.time() - self.starting_time
            fps = self.frame_id / elapsed_time
            #print ("fps: ", fps)
            cv2.putText(frame, "FPS: " + str(round(fps, 2)), (10, 50), self.font, 3, (0, 0, 0), 3)
            cv2.imshow("Image", frame)
            key = cv2.waitKey(1)
            if key == 27:
                break
        self.cap.release()
        cv2.destroyAllWindows()

    def useImage(self, imgname):
        # Loading image
        self.imgname = imgname
        self.img = cv2.imread(self.imgname) #ex. "test.jpg"
        self.img = cv2.resize(self.img, None, fx=0.4, fy=0.4)
        self.height, self.width, self.channels = self.img.shape

    def detectingImage(self):
        # Detecting objects
        blob = cv2.dnn.blobFromImage(self.img, 0.00392, (416, 416), (0, 0, 0), True, crop=False)
        self.net.setInput(blob)
        outs = self.net.forward(self.output_layers)

        # Showing informations on the screen
        class_ids = []
        confidences = []
        boxes = []
        for out in outs:
            for detection in out:
                scores = detection[5:]
                class_id = np.argmax(scores)
                confidence = scores[class_id]
                if confidence > 0.5:
                    # Object detected
                    center_x = int(detection[0] * self.width)
                    center_y = int(detection[1] * self.height)
                    w = int(detection[2] * self.width)
                    h = int(detection[3] * self.height)
                    # Rectangle coordinates
                    x = int(center_x - w / 2)
                    y = int(center_y - h / 2)
                    boxes.append([x, y, w, h])
                    confidences.append(float(confidence))
                    class_ids.append(class_id)

        indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.5, 0.4)

        self.font = cv2.FONT_HERSHEY_PLAIN
        for i in range(len(boxes)):
            if i in indexes:
                x, y, w, h = boxes[i]
                label = str(self.classes[class_ids[i]])
                color = self.colors[i]
                cv2.rectangle(self.img, (x, y), (x + w, y + h), color, 2)
                cv2.putText(self.img, label, (x, y + 30), self.font, 3, color, 3)
        cv2.imshow("Image", self.img)
        cv2.waitKey(0)
        cv2.destroyAllWindows()


"""
try:
    cap = cv2.VideoCapture(-1)
    print ("camera index: -1")
except:
    cap = cv2.VideoCapture(1)
    print ("camera index: 1")
time.sleep(2)
while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()

    # Our operations on the frame come here
    #gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Display the resulting frame
    cv2.imshow('frame', frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()
"""

if __name__ == "__main__":
    applyYOLO = YOLO()

    # if use webcam
    applyYOLO.useWebcam()
    applyYOLO.detectingWebcam()

    # if use image
    #applyYOLO.useImage("test.jpg")
    #applyYOLO.detectingImage()