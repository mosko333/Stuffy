//
//  NewCameraCell.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/2/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraDelegate: class {
    func capturePhoto(_ cell: CameraCell)
    func toPictureLibrary(_ cell: CameraCell)
}

class CameraCell: UITableViewCell {
    
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var thumbnailImage: UIImageView!
   
    
    weak var delegate: CameraDelegate?
    
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
    // we setup the captureSession
    func setupCaptureSession() {
    
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
    
    }
    // we find the device we need
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
        
    }
    // we setup input/output
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            // we run this logic so there isn't multiple inputs
            if captureSession.inputs.isEmpty{
               captureSession.addInput(captureDeviceInput)
            }
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            // we run this logic so there isn't multiple outputs
            if captureSession.outputs.isEmpty {
                captureSession.addOutput(photoOutput!)
            }
            
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    // we setup the camera layer. It is set to the frame of the cameraView
    func setupPreviewLayer() {
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = cameraView.frame
        cameraView.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        
    }
    // we run the session.
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    // we end the session
    func endRunningSession() {
        captureSession.stopRunning()
        captureSession.removeOutput(photoOutput!)
    }

    @IBAction func takePictureButtonTapped(_ sender: Any) {
        delegate?.capturePhoto(self)
        
    }
    @IBAction func libraryButtonTapped(_ sender: Any) {
        delegate?.toPictureLibrary(self)
    }
    
}

