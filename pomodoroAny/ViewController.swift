import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var timer = Timer()
    let seconds = [0, 15, 30, 45]
    let minutes = [15, 30, 45, 60]
    var selectedSeconds = 0
    var selectedMinutes = 0
    var totalTimeInSeconds = 0 // Toplam süre saniye cinsinden
    
    @IBOutlet weak var timeLabel: UILabel!
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "00:00"
    }
    
    @IBAction func selectTimeButton(_ sender: UIButton) {
        // Alert controller
        let alert = UIAlertController(title: "Select Time", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        // PickerView ayarlamaları
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.frame = CGRect(x: 0, y: 50, width: alert.view.bounds.width - 50, height: 150)
        alert.view.addSubview(pickerView)
        
        // Select action (Burada timer'ı başlatıyoruz)
        let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
            // Seçilen dakika ve saniyeyi toplam saniyeye çevir
            self.totalTimeInSeconds = (self.selectedMinutes * 60) + self.selectedSeconds
            
            if self.totalTimeInSeconds > 0 {
                // Timer Label'ı güncelle
                self.updateLabel()
                
                // Timer'ı başlat
                self.startTimer()
            } else {
                self.timeLabel.text = "Süre Seçilmedi"
            }
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Actions'ı alert'e ekle
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        // Alert'i göster
        present(alert, animated: true)
    }
    
    // MARK: - PickerView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Dakika ve saniye
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? minutes.count : seconds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(minutes[row]) min" : "\(seconds[row]) sec"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMinutes = minutes[row]
        } else {
            selectedSeconds = seconds[row]
        }
    }
    
    // MARK: - Timer Functions
    
    func startTimer() {
        // Eğer timer zaten çalışıyorsa durdur
        timer.invalidate()
        
        // Timer başlat
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        // Zaman bittiyse
        if totalTimeInSeconds <= 0 {
            timer.invalidate()
            timeLabel.text = "Zaman Doldu"
        } else {
            totalTimeInSeconds -= 1
            updateLabel()
        }
    }
    
    func updateLabel() {
        let hours = totalTimeInSeconds / 3600
        let minutes = (totalTimeInSeconds % 3600) / 60
        let seconds = totalTimeInSeconds % 60
        
        if hours > 0 {
            timeLabel.text = String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
