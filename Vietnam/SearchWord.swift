//
//  SearchWord.swift
//  Vietnam
//
//  Created by 杉山尋美 on 2017/09/28.
//  Copyright © 2017年 hiromi.sugiyama. All rights reserved.
//

import UIKit
import Kanna

class SearchWord: UIViewController {

  @IBOutlet weak var searchWordUnicode: UITextField!
  @IBOutlet weak var searchWordWindows: UITextField!
  
  var targetHtml: String? = "<html><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><body bgcolor=\"white\" text=\"black\" link=\"blue\" vlink=\"purple\" alink=\"red\"><table style=\"border-color:purple;\" border=\"1\" width=\"900\" cellpadding=\"2\" cellspacing=\"0\">"

  var searchWord: String?
  
  override func viewDidLoad() {
        super.viewDidLoad()

    // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @IBAction func searchWord(_ sender: Any) {
    
    if searchWordUnicode != nil {
      searchWord = searchWordUnicode.text
    } else if searchWordWindows != nil {
      searchWord = searchWordWindows.text
    } else {
      print("検索語が入力されていません")
    }

    //  let searchWord: String = "娘"

    // htmlファイルがあるディレクトリーを取得
    let currentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    print("currentDir: \(currentDir)")
    let currentDir2 = FileManager.default.currentDirectoryPath  // "/"を返してくる
    print("currentDir2: \(currentDir2)")
//   let currentDir3 = FileManager.default.homeDirectoryForCurrentUser  // "unavailable"エラーとなる
    
    // ディレクトリ内のhtmlファイルをリストアップし、配列に収納　＜未完＞
    var fileNames: [String] {
        do {
          return try FileManager.default.contentsOfDirectory(atPath: currentDir2)
        } catch {
          return []
        }
    }
    print(fileNames)


    

    var textData: String? // hmtlファイル全体のテキストデータ
    var trText: String? // <tr>...</tr>タグに挟まれたデータ
    
    // 配列内のhtmlファイルを順次テキストデータとして読み込む　＜未完＞
    
    // 検索語を含まないファイルは飛ばす　＜未完＞
    
    // 検索語を含むファイルの処理
    let path = Bundle.main.path(forResource: "a", ofType: "htm")!
    if let data = NSData(contentsOfFile: path){
      textData = String(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!) as String

      if let doc = HTML(html: textData!, encoding: .utf8) {

        // <tr>タグごとに検索語をチェック、含んで入ればその<tr>タグのouterHTMLをtargetHtmlに追記する
        for node in doc.css("tr") {
          trText = node.toHTML!
          if let range = trText?.range(of: searchWord!) {
            targetHtml = targetHtml! + trText!
          } else {
          }
        }
      }
      
    }else{
      print("ファイルがありません")
    }
    
    targetHtml = targetHtml! + "</table></html>"
    
    // 検索結果のhtmlを書き出す
    let htmlFileName = "searchResult.html"
    
    // DocumentディレクトリURLを取得
    if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
        
    // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
    let targetFilePath = documentDirectoryFileURL.appendingPathComponent(htmlFileName)
        
    // 書き込み
    do {
      try targetHtml!.write(to: targetFilePath, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("書き込みエラーが発生しました: \(error)")
    }
      
  }
    
 }
  
  func dismissKeyboard(){
    // キーボードを閉じる
    view.endEditing(true)
  }

}
