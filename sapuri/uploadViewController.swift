//
//  uploadViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2020/03/11.
//  Copyright © 2020 二渡杏. All rights reserved.
//

import UIKit

class uploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTappedCameraButton() {
        presentPickerController(sourceType: .camera)
    }
    
    @IBAction func onTappedAlbumButton() {
        presentPickerController(sourceType: .photoLibrary)
    }
    
    //カメラ、アルバムの呼び出しメソッド
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker,animated: true, completion: nil)
        }
    }
    
    //写真が選択された時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: nil)
        //画像を出力
        photoImageView.image = info[.originalImage] as? UIImage
    }
    
    //元の画像にテキストを合成するメソッド
    func drawText(image: UIImage) -> UIImage {
        
        let text = "SAPURI"
        
        let textFontAttributes = [
            NSAttributedString.Key.font:UIFont(name: "Arial", size: 120)!,
            NSAttributedString.Key.foregroundColor:UIColor.red
        ]
        
        //グラフィックスコンテキスト生成編集を開始
            UIGraphicsBeginImageContext(image.size)
            
            //読み込んだ写真を書き出す
            image.draw(in: CGRect(x :0, y: 0, width: image.size.width, height: image.size.height))
            
            let margin: CGFloat = 200.0
            let textRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
            
            text.draw(in: textRect, withAttributes: textFontAttributes)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return newImage!
        }
    
    func drawMaskImage(image: UIImage) -> UIImage {
        
        let maskImage = UIImage(named: "stamp.png")!
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(x: 0,y: 0, width: image.size.width, height: image.size.height))
        
        let margin: CGFloat = 100.0
        let maskRect = CGRect(x: image.size.width - maskImage.size.width - margin,
                              y: image.size.height - maskImage.size.height - margin,
                              width: maskImage.size.width, height: maskImage.size.height)
        
        maskImage.draw(in: maskRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @IBAction func onTappedTextButton() {
        if photoImageView.image != nil{
            photoImageView.image = drawText(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedIllustButton() {
        if photoImageView.image != nil{
            photoImageView.image = drawMaskImage(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedUploadButton() {
        if photoImageView.image != nil {
            
            let activityVC = UIActivityViewController(activityItems:[photoImageView.image!,"#SAPURI"],                             applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        } else {
            print("画像がありません")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
