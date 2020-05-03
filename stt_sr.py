# SpeechRecognition

import speech_recognition as sr
r = sr.Recognizer()

with sr.Microphone() as source:
    print ("say something.")
    audio = r.listen(source)
    print ("stop!")

try:
    print ("text: ", r.recognize_google(audio, language="zh-TW"))
    # write audio to a WAV file
    with open("microphone-results.wav", "wb") as f:
        f.write(audio.get_wav_data())
except:
    print ("unknown")


