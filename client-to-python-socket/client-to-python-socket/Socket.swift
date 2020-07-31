//
//  Client.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 21/06/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

protocol ClientDelegate: class {
    func receivedMessage(message: String)
}

class Socket: NSObject {
    var delegate: ClientDelegate?
    
    //Recebe/Lê
    var inputStream: InputStream!
    //Envia/Escreve
    var outputStream: OutputStream!
    
    let maxReadLength = 4096
    
    override init(){
        super.init()
    }
    
    func setupNetwork(){
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "192.168.0.15" as CFString, 2350, &readStream, &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendToServer(message: Data, message_length: Int){
        let data = message
        let data_length = String(message_length).data(using: .utf8)!
        
        _ = data_length.withUnsafeBytes {
             guard let pointer_msg_length = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else{
                 print("Erro ao enviar tamanho da mensagem")
                 return
             }
            
            outputStream.write(pointer_msg_length, maxLength: data_length.count)
        }
        
        _ = data.withUnsafeBytes {
            guard let pointer_msg = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else{
                print("Erro ao enviar mensagem")
                return
            }

            outputStream.write(pointer_msg, maxLength: data.count)
        }
    }
}

extension Socket: StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode{
        case .hasBytesAvailable:
            //print("Nova mensagem!")
            readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            print("Fim")
        case .errorOccurred:
            print("Erro")
        case .hasSpaceAvailable:
            print("Há espaço disponível")
        default:
            break
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
      //1
      let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)

      //2
      while stream.hasBytesAvailable {
        //3
        let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)

        //4
        if numberOfBytesRead < 0, let error = stream.streamError {
          print(error)
          break
        }
        
        let serverMessage = String(bytesNoCopy: buffer, length: numberOfBytesRead, encoding: .utf8, freeWhenDone: true)
        
        delegate?.receivedMessage(message: serverMessage!)
      }
    }
}
