import UIKit

class NewsCell: UITableViewCell {

    private var thumbNail = UIImageView()
    private var titleLabel = UILabel()
    private var title = "Fetching Data..."
    private var imageManager = ImageManager()
    
    var content: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(thumbNail)
        addSubview(titleLabel)
        
        imageManager.delegate = self
        
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func passDataToNewsCell(title: String, imageUrl: String, content: String) {
        titleLabel.text = title
        thumbNail.backgroundColor = .clear
        self.content = content
        imageManager.loadImages(url: imageUrl)
        
    }
    private func commonInit() {
        configureImage()
        configureTitle()
        setImageConstraints()
        setTitleConstraints()
    }
    private func configureImage() {
        
        thumbNail.layer.cornerRadius = 8
        thumbNail.clipsToBounds      = true
        thumbNail.backgroundColor    = .lightGray
        thumbNail.contentMode        = .scaleAspectFill
        
    }
    private func configureTitle() {
        
        titleLabel.numberOfLines = 3
        titleLabel.text = title
        
    }
    private func setImageConstraints() {
        
        //view
        let fromView = thumbNail
        //relative to
        let toView = self
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.widthAnchor.constraint(equalToConstant: 100),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 10),
                                     fromView.heightAnchor.constraint(equalToConstant: 100)])
        
        
    }
    private func setTitleConstraints() {
        
        //view
        let fromView = titleLabel
        //relative to
        let toView = thumbNail
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 10),
                                     fromView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 10)])
        
        
    }
}
extension NewsCell: ImageManagerDelegate {
    
        func didReceivedAnErrorWhileLoadingImage() {
            
            let image = UIImage(named: "news")
            
            DispatchQueue.main.async {
                self.thumbNail.image = image
            }
            
        }
        
        func didFetchImages(codedImage: Data) {

            let image = UIImage(data: codedImage)
            
            thumbNail.image = image
            
        }
    
}
