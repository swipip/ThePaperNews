import UIKit

class NewsCell: UITableViewCell {

    private var thumbNail = UIImageView()
    private var titleLabel = UILabel()
    private var title = "Fetching Data..."
    private var imageManager = ImageManager()
    
    private lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = K.shared.grayTextFieldBackground
        coverView.frame = self.frame
        return coverView
    }()
    
    var articleURL: String = ""
    
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
    func passDataToNewsCell(title: String, imageUrl: String, articleURL: String) {
        
        coverView.removeFromSuperview()
        
        titleLabel.text = title
        thumbNail.backgroundColor = .clear
        self.articleURL = articleURL
        imageManager.loadImages(url: imageUrl)
        
    }
    func setBlankCell() {
        
        self.addSubview(coverView)
        
        let label = UILabel()
        label.text = "No article to dislay in this category"
        label.textColor = .white
        
        self.coverView.addSubview(label)
        
        //view
        let fromView = label
        //relative to
        let toView = self
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0)])
        
    }
    private func commonInit() {
        self.backgroundColor = K.shared.mainColorBackground
        
//        self.subviews.forEach({$0.removeFromSuperview()})
        
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
        titleLabel.font = UIFont.systemFont(ofSize: K.shared.fontSizeContent)
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
