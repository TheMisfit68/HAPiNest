import Cocoa
import AVFoundation


// Making this class a subclass AVSpeechSynthesizer instead of using it
// causes the synthesizer to work only once!

@available(OSX 10.14, *)
public class SiriDriver{
    
    var syntheSizer:AVSpeechSynthesizer!
    let voice:AVSpeechSynthesisVoice!
    
    public init(language:SiriLanguage){
        self.voice = AVSpeechSynthesisVoice(language: language.rawValue)
    }
    
    public func speak(text: String){
        
        let textToSpeak = AVSpeechUtterance(string: text)
        textToSpeak.voice = self.voice
        
        syntheSizer = AVSpeechSynthesizer()
        syntheSizer.pauseSpeaking(at: .word)
        syntheSizer.speak(textToSpeak)
    }
    
}

public enum SiriLanguage:String{
    case flemish = "nl-be"
    case american = "en-us"
}
